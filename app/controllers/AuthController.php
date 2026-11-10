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
                            $applicantHtml = '<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head><body style="margin:0;padding:32px 12px;background:#f5f6f0;font-family:Arial,sans-serif;color:#1b2a22"><div style="max-width:620px;margin:0 auto;background:#fff;border:1px solid #dde3d8;border-radius:20px;overflow:hidden"><header style="background:#17402f;padding:28px 34px;color:#fff"><b style="color:#f0a81d;letter-spacing:2px">✿ RASAKULINER</b><div style="font-size:12px;color:#d4e3d9;margin-top:7px">Merawat rasa, menjaga cerita.</div></header><main style="padding:34px"><div style="font-size:12px;color:#b87800;font-weight:bold;letter-spacing:1px">PENDAFTARAN DITERIMA</div><h1 style="font-size:27px;color:#17402f;margin:10px 0">Terima kasih sudah bergabung!</h1><p style="line-height:1.7;color:#5b6b62">Halo ' . $safeName . ', pendaftaran usaha kamu sudah kami terima.</p><div style="background:#f5f6f0;border-radius:12px;padding:18px;margin:20px 0"><div style="font-size:12px;color:#b87800;font-weight:bold">USAHA YANG DIDAFTARKAN</div><div style="font-size:19px;font-weight:bold;color:#17402f;margin-top:6px">' . $safeBusiness . '</div><span style="display:inline-block;margin-top:12px;padding:6px 11px;border-radius:30px;background:#fdf0cd;color:#80520b;font-size:12px;font-weight:bold">● MENUNGGU VERIFIKASI</span></div><p style="line-height:1.7;color:#5b6b62">Tim RasaKuliner sedang memeriksa informasi usaha yang kamu kirimkan. Kamu akan menerima email lagi setelah ada keputusan. Selama proses ini, akses Seller belum aktif.</p><footer style="border-top:1px solid #dde3d8;margin-top:28px;padding-top:18px;color:#758279;font-size:12px">Email otomatis dari RasaKuliner. Mohon tidak membalas email ini.</footer></main></div></body></html>';
                            $mailer->send($email, 'Pendaftaran Seller RasaKuliner sedang ditinjau', $applicantHtml);
                        } catch (Exception $mailError) {
                            $mailErrors[] = 'Email konfirmasi ke pendaftar gagal: ' . $mailError->getMessage();
                        }
                        $adminEmail = isset($this->config->mailer->admin_email) ? trim((string)$this->config->mailer->admin_email) : '';
                        if ($adminEmail !== '') {
                            try {
                                // Pastikan tabel token tersedia otomatis pada database lokal.
                                // Tetap gunakan migration SQL sebagai opsi setup manual.
                                $this->db->execute("CREATE TABLE IF NOT EXISTS seller_email_actions (
                                    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                    user_id INT UNSIGNED NOT NULL,
                                    token_hash CHAR(64) NOT NULL,
                                    expires_at DATETIME NOT NULL,
                                    used_at DATETIME DEFAULT NULL,
                                    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    PRIMARY KEY (id),
                                    UNIQUE KEY uq_seller_email_actions_token (token_hash),
                                    KEY idx_seller_email_actions_user (user_id),
                                    CONSTRAINT fk_seller_email_actions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
                                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
                                $actionToken = bin2hex(random_bytes(32));
                                $this->db->execute(
                                    'INSERT INTO seller_email_actions (user_id,token_hash,expires_at) VALUES (:uid,:hash,DATE_ADD(NOW(), INTERVAL 48 HOUR))',
                                    ['uid'=>$uid,'hash'=>hash('sha256',$actionToken)]
                                );
                                $base = isset($this->config->mailer->app_url) ? rtrim((string)$this->config->mailer->app_url, '/') : '';
                                if ($base === '') throw new Exception('app_url belum diatur pada konfigurasi.');
                                $approveUrl = $base . '/admin/seller/email/approve/' . $actionToken;
                                $rejectUrl = $base . '/admin/seller/email/reject/' . $actionToken;
                                $adminHtml = '<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head><body style="margin:0;padding:0;background:#f3f4ed;font-family:Arial,Helvetica,sans-serif;color:#25352b"><table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#f3f4ed;padding:32px 12px"><tr><td align="center"><table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="max-width:620px;background:#ffffff;border-radius:18px;overflow:hidden;border:1px solid #e4e8df"><tr><td style="background:#17402f;padding:27px 34px"><div style="font-size:21px;font-weight:800;letter-spacing:2px;color:#ffffff">✿ RASAKULINER</div><div style="font-size:11px;letter-spacing:1.5px;color:#d6e4d9;margin-top:7px">MERAWAT RASA, MENJAGA CERITA</div></td></tr><tr><td style="padding:34px 34px 12px"><div style="display:inline-block;background:#fff4d9;color:#94620c;font-size:10px;font-weight:bold;letter-spacing:1.4px;padding:8px 12px;border-radius:30px">TINJAUAN MITRA BARU</div><h1 style="font-size:27px;line-height:1.25;color:#17402f;margin:18px 0 10px">Ada calon Seller baru! 🌿</h1><p style="font-size:14px;line-height:1.8;color:#657269;margin:0">Seseorang baru saja mendaftarkan usahanya ke RasaKuliner. Yuk, periksa detail pendaftarannya dan tentukan apakah usaha ini siap bergabung.</p></td></tr><tr><td style="padding:18px 34px 10px"><table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#f7f8f3;border:1px solid #e6eadf;border-radius:13px"><tr><td style="padding:21px 22px"><div style="font-size:10px;font-weight:bold;letter-spacing:1.3px;color:#a87413">PROFIL CALON MITRA</div><div style="font-size:20px;font-weight:bold;color:#17402f;margin-top:10px">' . $safeName . '</div><div style="font-size:13px;color:#657269;margin-top:5px">' . htmlspecialchars($email, ENT_QUOTES, 'UTF-8') . '</div><div style="height:1px;background:#e1e7dd;margin:16px 0"></div><div style="font-size:10px;color:#849087;letter-spacing:1px;font-weight:bold">NAMA USAHA</div><div style="font-size:16px;font-weight:bold;color:#26382d;margin-top:5px">' . $safeBusiness . '</div></td></tr></table></td></tr><tr><td style="padding:22px 34px 8px"><p style="font-size:13px;line-height:1.7;color:#657269;margin:0 0 17px">Pilih tindakan berikut untuk memproses pendaftaran. Keputusan akan langsung memperbarui status Seller dan mengirim pemberitahuan ke email pendaftar.</p><table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0"><tr><td align="center" width="50%" style="padding:0 6px 0 0"><a href="' . htmlspecialchars($approveUrl, ENT_QUOTES, 'UTF-8') . '" style="display:block;background:#1d6848;color:#ffffff;text-decoration:none;text-align:center;font-size:13px;font-weight:bold;padding:15px 8px;border-radius:9px">✓ &nbsp; TERIMA SELLER</a></td><td align="center" width="50%" style="padding:0 0 0 6px"><a href="' . htmlspecialchars($rejectUrl, ENT_QUOTES, 'UTF-8') . '" style="display:block;background:#fff1ed;color:#b83225;border:1px solid #f0c8bf;text-decoration:none;text-align:center;font-size:13px;font-weight:bold;padding:15px 8px;border-radius:9px">✕ &nbsp; TOLAK SELLER</a></td></tr></table><p style="font-size:11px;line-height:1.7;color:#879188;margin:18px 0 0">Demi keamanan, tautan keputusan bersifat pribadi, berlaku selama 48 jam, dan hanya dapat digunakan satu kali. Jika tombol tidak bisa dibuka, salin tautannya ke browser.</p></td></tr><tr><td style="padding:25px 34px 28px"><div style="height:1px;background:#e7ebe3"></div><p style="font-size:11px;line-height:1.7;color:#8a948c;margin:17px 0 0">Email otomatis dari <strong style="color:#17402f">RasaKuliner</strong>.<br>Pesan ini dikirim khusus ke administrator untuk proses verifikasi mitra.</p></td></tr></table><div style="font-size:10px;color:#9aa39b;padding:17px 10px">© RasaKuliner · Platform kuliner Nusantara</div></td></tr></table></body></html>';
                                $mailer->send($adminEmail, 'Konfirmasi Seller baru - RasaKuliner', $adminHtml);
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


    public function registerUserAction()
    {
        if (!empty($_SESSION['user_id']) && isset($_SESSION['user_role']) && $_SESSION['user_role'] === 'user') return $this->go('');
        $error = '';
        if ($this->request->isPost()) {
            $nama=trim((string)$this->request->getPost('nama'));
            $email=strtolower(trim((string)$this->request->getPost('email')));
            $password=(string)$this->request->getPost('password');
            if ($nama==='' || !filter_var($email,FILTER_VALIDATE_EMAIL) || strlen($password)<8) $error='Lengkapi nama, email valid, dan password minimal 8 karakter.';
            else {
                $exists=$this->db->fetchOne('SELECT id FROM users WHERE email=:email LIMIT 1', Phalcon\\Db::FETCH_ASSOC, ['email'=>$email]);
                if ($exists) $error='Email sudah terdaftar. Silakan login.';
                else {
                    $this->db->begin();
                    try {
                        $this->db->execute("INSERT INTO users (nama,email,password_hash,status) VALUES (:nama,:email,:hash,'active')", ['nama'=>$nama,'email'=>$email,'hash'=>password_hash($password,PASSWORD_DEFAULT)]);
                        $uid=(int)$this->db->lastInsertId();
                        $role=$this->db->fetchOne("SELECT id FROM roles WHERE slug='user' LIMIT 1", Phalcon\\Db::FETCH_ASSOC);
                        if (!$role) throw new Exception('Role user belum tersedia.');
                        $this->db->execute('INSERT INTO user_roles (user_id,role_id) VALUES (:uid,:rid)', ['uid'=>$uid,'rid'=>$role['id']]);
                        $this->db->commit();
                        session_regenerate_id(true);
                        $_SESSION['user_id']=$uid; $_SESSION['user_name']=$nama; $_SESSION['user_role']='user';
                        return $this->go('');
                    } catch (\\Throwable $e) { $this->db->rollback(); $error='Registrasi gagal. Periksa database lalu coba lagi.'; }
                }
            }
        }
        $this->view->error=$error; $this->view->title='Daftar User — RasaKuliner';
    }

    public function loginUserAction()
    {
        if (!empty($_SESSION['user_id']) && isset($_SESSION['user_role']) && $_SESSION['user_role'] === 'user') return $this->go('');
        $error='';
        if ($this->request->isPost()) {
            $email=strtolower(trim((string)$this->request->getPost('email')));
            $password=(string)$this->request->getPost('password');
            $user=$this->db->fetchOne('SELECT id,nama,password_hash,status FROM users WHERE email=:email LIMIT 1', Phalcon\\Db::FETCH_ASSOC, ['email'=>$email]);
            $role=$user ? $this->db->fetchOne("SELECT r.slug FROM user_roles ur JOIN roles r ON r.id=ur.role_id WHERE ur.user_id=:id AND r.slug='user' LIMIT 1", Phalcon\\Db::FETCH_ASSOC, ['id'=>$user['id']]) : false;
            if ($user && $role && $user['status']==='active' && password_verify($password,$user['password_hash'])) {
                session_regenerate_id(true);
                $_SESSION['user_id']=(int)$user['id']; $_SESSION['user_name']=$user['nama']; $_SESSION['user_role']='user';
                $this->db->execute('UPDATE users SET last_login_at=NOW() WHERE id=:id',['id'=>$user['id']]);
                return $this->go('');
            }
            $error='Email atau password salah, atau akun ini bukan akun User.';
        }
        $this->view->error=$error; $this->view->title='Login User — RasaKuliner';
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
