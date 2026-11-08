<?php
class AuthController extends ControllerBase
{
    private function go($path) { return $this->response->redirect($path); }

    public function registerAction()
    {
        if (!empty($_SESSION['user_id'])) return $this->go($_SESSION['user_role'] === 'admin' ? 'admin/seller' : 'seller');
        $error = '';
        $success = '';
        if ($this->request->isPost()) {
            $nama = trim((string)$this->request->getPost('nama'));
            $email = strtolower(trim((string)$this->request->getPost('email')));
            $password = (string)$this->request->getPost('password');
            $usaha = trim((string)$this->request->getPost('nama_usaha'));
            $jenis = trim((string)$this->request->getPost('jenis_usaha'));
            $telepon = trim((string)$this->request->getPost('nomor_telepon'));
            $alamat = trim((string)$this->request->getPost('alamat'));
            if ($nama === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($password) < 8 || $usaha === '') {
                $error = 'Lengkapi data dengan benar. Password minimal 8 karakter.';
            } else {
                $db = $this->db;
                $exists = $db->fetchOne('SELECT id FROM users WHERE email = :email', Phalcon\Db::FETCH_ASSOC, ['email'=>$email]);
                if ($exists) $error = 'Email sudah terdaftar. Silakan login.';
                else {
                    $db->begin();
                    try {
                        $db->execute("INSERT INTO users (nama,email,password_hash,status) VALUES (:nama,:email,:hash,'active')", ['nama'=>$nama,'email'=>$email,'hash'=>password_hash($password, PASSWORD_DEFAULT)]);
                        $uid = (int)$db->lastInsertId();
                        $db->execute("INSERT INTO seller_profiles (user_id,nama_usaha,jenis_usaha,nomor_telepon,alamat,verification_status) VALUES (:uid,:usaha,:jenis,:tel,:alamat,'pending')", ['uid'=>$uid,'usaha'=>$usaha,'jenis'=>$jenis,'tel'=>$telepon,'alamat'=>$alamat]);
                        $db->commit();
                        $success = 'Pendaftaran berhasil dikirim. Akun Seller menunggu persetujuan admin. Kamu belum bisa login sebagai Seller sampai disetujui.';
                        $mailErrors = [];
                        $mailer = new SmtpMailer($this->config->mailer);
                        $safeName = htmlspecialchars($nama, ENT_QUOTES, 'UTF-8');
                        $safeBusiness = htmlspecialchars($usaha, ENT_QUOTES, 'UTF-8');
                        try {
                            $mailer->send(
                                $email,
                                'Pendaftaran Seller RasaKuliner sedang ditinjau',
                                '<p>Halo ' . $safeName . ',</p><p>Pendaftaran usaha <b>' . $safeBusiness . '</b> sudah kami terima dan sedang menunggu pemeriksaan admin.</p><p>Kami akan mengirim email lagi setelah admin memberikan keputusan. Selama proses ini, akun belum bisa digunakan untuk login sebagai Seller.</p><p>Salam,<br>Tim RasaKuliner</p>'
                            );
                        } catch (Exception $mailError) {
                            $mailErrors[] = 'Email konfirmasi ke pendaftar gagal: ' . $mailError->getMessage();
                        }
                        $adminEmail = isset($this->config->mailer->admin_email) ? trim((string)$this->config->mailer->admin_email) : '';
                        if ($adminEmail !== '') {
                            try {
                                $actionToken = bin2hex(random_bytes(32));
                                $this->db->execute(
                                    'INSERT INTO seller_email_actions (user_id,token_hash,expires_at) VALUES (:uid,:hash,DATE_ADD(NOW(), INTERVAL 48 HOUR))',
                                    ['uid'=>$uid,'hash'=>hash('sha256',$actionToken)]
                                );
                                $base = isset($this->config->mailer->app_url) ? rtrim((string)$this->config->mailer->app_url, '/') : '';
                                if ($base === '') throw new Exception('app_url belum diatur pada konfigurasi.');
                                $approveUrl = $base . '/admin/seller/email/approve/' . $actionToken;
                                $rejectUrl = $base . '/admin/seller/email/reject/' . $actionToken;
                                $detail = '<p>Ada pendaftaran Seller baru di RasaKuliner.</p><p><b>Pemilik:</b> ' . $safeName . '<br><b>Email:</b> ' . htmlspecialchars($email, ENT_QUOTES, 'UTF-8') . '<br><b>Usaha:</b> ' . $safeBusiness . '</p>';
                                $detail .= '<p>Tautan keputusan berlaku 48 jam dan hanya dapat digunakan satu kali. Buka tautan untuk memeriksa lalu konfirmasi keputusan.</p>';
                                $detail .= '<p><a href="' . htmlspecialchars($approveUrl, ENT_QUOTES, 'UTF-8') . '" style="display:inline-block;padding:12px 20px;background:#176b45;color:#fff;text-decoration:none;border-radius:7px;font-weight:bold">TERIMA SELLER</a></p>';
                                $detail .= '<p><a href="' . htmlspecialchars($rejectUrl, ENT_QUOTES, 'UTF-8') . '" style="display:inline-block;padding:12px 20px;background:#a83232;color:#fff;text-decoration:none;border-radius:7px;font-weight:bold">TOLAK SELLER</a></p>';
                                $mailer->send($adminEmail, 'Konfirmasi Seller baru - RasaKuliner', $detail);
                            } catch (Exception $mailError) {
                                $mailErrors[] = 'Email tombol konfirmasi admin gagal: ' . $mailError->getMessage();
                            }
                        } else {
                            $mailErrors[] = 'email admin belum diatur pada konfigurasi SMTP';
                        }
                        if (!empty($mailErrors)) $success .= ' Namun ada kendala pengiriman: ' . implode(' | ', $mailErrors) . '. Periksa konfigurasi SMTP lokal.';
                    } catch (\Throwable $e) {
                        $db->rollback();
                        $error = 'Pendaftaran belum berhasil. Pastikan tabel users dan seller_profiles sudah tersedia.';
                    }
                }
            }
        }
        $this->view->error = $error;
        $this->view->success = $success;
        $this->view->title = 'Daftar Seller — RasaKuliner';
    }

    public function loginAction()
    {
        if (!empty($_SESSION['user_id'])) return $this->go($_SESSION['user_role'] === 'admin' ? 'admin/seller' : 'seller');
        $error = '';
        $pendingNotice = false;
        if ($this->request->isPost()) {
            $email = strtolower(trim((string)$this->request->getPost('email')));
            $password = (string)$this->request->getPost('password');
            $user = $this->db->fetchOne('SELECT id,nama,password_hash,status FROM users WHERE email=:email LIMIT 1', Phalcon\Db::FETCH_ASSOC, ['email'=>$email]);
            if ($user && $user['status'] === 'active' && password_verify($password, $user['password_hash'])) {
                $role = $this->db->fetchOne(
                    "SELECT r.slug FROM user_roles ur JOIN roles r ON r.id=ur.role_id WHERE ur.user_id=:id AND r.slug IN ('admin','seller') ORDER BY CASE r.slug WHEN 'admin' THEN 0 ELSE 1 END LIMIT 1",
                    Phalcon\Db::FETCH_ASSOC, ['id'=>$user['id']]
                );
                if ($role && $role['slug'] === 'admin' && strtolower(trim((string)$user['email'])) === strtolower(trim((string)$this->config->mailer->admin_email))) {
                    session_regenerate_id(true);
                    $_SESSION['user_id'] = (int)$user['id'];
                    $_SESSION['user_name'] = $user['nama'];
                    $_SESSION['user_role'] = 'admin';
                    $this->db->execute('UPDATE users SET last_login_at=NOW() WHERE id=:id', ['id'=>$user['id']]);
                    return $this->go('admin/seller');
                }
                $profile = $this->db->fetchOne('SELECT verification_status FROM seller_profiles WHERE user_id=:id LIMIT 1', Phalcon\Db::FETCH_ASSOC, ['id'=>$user['id']]);
                if ($role && $role['slug'] === 'seller' && $profile && $profile['verification_status'] === 'verified') {
                    session_regenerate_id(true);
                    $_SESSION['user_id'] = (int)$user['id'];
                    $_SESSION['user_name'] = $user['nama'];
                    $_SESSION['user_role'] = 'seller';
                    $this->db->execute('UPDATE users SET last_login_at=NOW() WHERE id=:id', ['id'=>$user['id']]);
                    return $this->go('seller');
                }
                if ($profile && $profile['verification_status'] === 'pending') { $pendingNotice = true; $error = 'Pendaftaran Seller masih menunggu persetujuan admin.'; }
                elseif ($profile && $profile['verification_status'] === 'rejected') $error = 'Pendaftaran Seller ditolak. Silakan periksa email untuk melihat catatan admin.';
                else $error = 'Akun ini belum memiliki akses Seller.';
            } else {
                $error = 'Email atau password salah, atau akun tidak aktif.';
            }
        }
        $this->view->error = $error;
        $this->view->pendingNotice = $pendingNotice;
        $this->view->title = 'Login Seller — RasaKuliner';
    }

    public function logoutAction()
    {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
        }
        session_destroy();
        return $this->go('');
    }
}
