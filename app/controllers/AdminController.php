<?php
class AdminController extends ControllerBase
{
    private function requireAdmin()
    {
        if (empty($_SESSION['user_id']) || empty($_SESSION['user_role']) || $_SESSION['user_role'] !== 'admin') {
            $this->response->redirect('login-seller')->send();
            return false;
        }
        $ownerEmail = strtolower(trim((string)$this->config->mailer->admin_email));
        $admin = $this->db->fetchOne('SELECT email FROM users WHERE id=:id LIMIT 1', Phalcon\Db::FETCH_ASSOC, ['id'=>(int)$_SESSION['user_id']]);
        if ($ownerEmail === '' || !$admin || strtolower(trim((string)$admin['email'])) !== $ownerEmail) {
            unset($_SESSION['user_id'], $_SESSION['user_name'], $_SESSION['user_role']);
            $this->response->redirect('login-seller')->send();
            return false;
        }
        return true;
    }

    private function notifySeller($email, $name, $status, $reason)
    {
        $mailer = new SmtpMailer($this->config->mailer);
        $safeName = htmlspecialchars($name, ENT_QUOTES, 'UTF-8');
        if ($status === 'verified') {
            $subject = 'Pendaftaran Seller RasaKuliner disetujui';
            $message = '<div style="background:#e2ede5;border-radius:12px;padding:18px;margin:20px 0;color:#17402f"><div style="font-size:12px;font-weight:bold;color:#215f46">STATUS PENDAFTARAN</div><div style="font-size:22px;font-weight:bold;margin-top:6px">✓ Seller disetujui</div></div><p style="font-size:14px;line-height:1.7;color:#5b6b62">Selamat, pendaftaran usaha Anda telah disetujui. Akses Seller RasaKuliner sekarang sudah aktif.</p><p style="margin:24px 0"><a href="' . htmlspecialchars(rtrim((string)$this->config->mailer->app_url, '/') . '/login-seller', ENT_QUOTES, 'UTF-8') . '" style="display:inline-block;padding:14px 22px;background:#17402f;color:#fff;text-decoration:none;border-radius:9px;font-weight:bold">MASUK KE RASAKULINER →</a></p>';
        } else {
            $subject = 'Pembaruan pendaftaran Seller RasaKuliner';
            $safeReason = htmlspecialchars($reason, ENT_QUOTES, 'UTF-8');
            $message = '<div style="background:#fdf0cd;border-radius:12px;padding:18px;margin:20px 0;color:#80520b"><div style="font-size:12px;font-weight:bold">STATUS PENDAFTARAN</div><div style="font-size:22px;font-weight:bold;margin-top:6px">Pendaftaran belum disetujui</div></div><p style="font-size:14px;line-height:1.7;color:#5b6b62">Halo ' . $safeName . ', mohon maaf pendaftaran Seller Anda belum dapat kami setujui saat ini.</p>';
            if ($safeReason !== '') $message .= '<div style="background:#f5f6f0;border-left:4px solid #c8321f;padding:15px 18px;margin:18px 0"><b style="color:#17402f">Catatan dari admin</b><p style="margin:7px 0 0;line-height:1.7">' . nl2br($safeReason) . '</p></div>';
            $message .= '<p style="font-size:14px;line-height:1.7;color:#5b6b62">Silakan perbaiki data usaha sesuai catatan di atas sebelum mengajukan kembali.</p>';
        }
        $mailer->send($email, $subject, '<!doctype html><html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Hasil verifikasi Seller - RasaKuliner</title></head><body style="margin:0;padding:32px 12px;background:#f5f6f0;font-family:Arial,Helvetica,sans-serif;color:#1b2a22"><div style="max-width:620px;margin:0 auto;background:#fff;border:1px solid #dde3d8;border-radius:20px;overflow:hidden"><div style="background:#17402f;padding:28px 34px;color:#fff"><div style="font-size:13px;letter-spacing:2px;color:#f0a81d;font-weight:bold">✿ RASAKULINER</div><div style="font-size:12px;color:#d4e3d9;margin-top:7px">Ruang untuk mengenal kekayaan rasa Nusantara</div></div><div style="padding:34px"><div style="font-size:12px;letter-spacing:1.5px;color:#b87800;font-weight:bold;text-transform:uppercase">PEMBARUAN PENDAFTARAN</div><h1 style="font-size:27px;line-height:1.25;margin:10px 0 12px;color:#17402f">Hasil verifikasi Seller</h1><p style="font-size:15px;line-height:1.75;color:#5b6b62;margin:0 0 24px">Admin telah menyelesaikan pemeriksaan pendaftaranmu.</p>' . $message . '<div style="border-top:1px solid #dde3d8;margin-top:28px;padding-top:18px;color:#758279;font-size:12px;line-height:1.6">Email otomatis dari RasaKuliner. Mohon tidak membalas email ini.<br>Merawat rasa, menjaga cerita.</div></div></div></body></html>');
    }

    public function sellersAction()
    {
        if (!$this->requireAdmin()) return;
        $message = '';
        $error = '';
        if ($this->request->isPost()) {
            $token = (string)$this->request->getPost('csrf_token');
            if (empty($_SESSION['csrf_admin']) || !hash_equals($_SESSION['csrf_admin'], $token)) {
                $error = 'Permintaan tidak valid. Muat ulang halaman dan coba lagi.';
            } else {
                $uid = (int)$this->request->getPost('user_id');
                $decision = (string)$this->request->getPost('decision');
                $reason = trim((string)$this->request->getPost('rejection_reason'));
                if ($uid < 1 || !in_array($decision, ['approve', 'reject'], true)) {
                    $error = 'Data keputusan tidak valid.';
                } elseif ($decision === 'reject' && $reason === '') {
                    $error = 'Alasan penolakan wajib diisi.';
                } else {
                    $profile = $this->db->fetchOne(
                        "SELECT u.id,u.nama,u.email,sp.verification_status FROM users u JOIN seller_profiles sp ON sp.user_id=u.id WHERE u.id=:id LIMIT 1",
                        Phalcon\Db::FETCH_ASSOC, ['id'=>$uid]
                    );
                    if (!$profile || $profile['verification_status'] !== 'pending') {
                        $error = 'Pendaftaran tidak ditemukan atau sudah diproses.';
                    } else {
                        $newStatus = $decision === 'approve' ? 'verified' : 'rejected';
                        $this->db->begin();
                        try {
                            $this->db->execute(
                                'UPDATE seller_profiles SET verification_status=:status,verified_by=:admin,verified_at=NOW(),rejection_reason=:reason WHERE user_id=:uid AND verification_status=\'pending\'',
                                ['status'=>$newStatus,'admin'=>(int)$_SESSION['user_id'],'reason'=>$decision === 'reject' ? $reason : null,'uid'=>$uid]
                            );
                            if ($decision === 'approve') {
                                $role = $this->db->fetchOne("SELECT id FROM roles WHERE slug='seller' LIMIT 1", Phalcon\Db::FETCH_ASSOC);
                                if (!$role) throw new Exception('Role seller tidak ditemukan di database.');
                                $this->db->execute('INSERT IGNORE INTO user_roles (user_id,role_id,assigned_by) VALUES (:uid,:rid,:admin)', ['uid'=>$uid,'rid'=>$role['id'],'admin'=>(int)$_SESSION['user_id']]);
                            } else {
                                $this->db->execute("DELETE ur FROM user_roles ur JOIN roles r ON r.id=ur.role_id WHERE ur.user_id=:uid AND r.slug='seller'", ['uid'=>$uid]);
                            }
                            $this->db->commit();
                            try {
                                $this->notifySeller($profile['email'], $profile['nama'], $newStatus, $reason);
                                $message = $decision === 'approve' ? 'Seller berhasil disetujui dan email pemberitahuan telah dikirim.' : 'Pendaftaran ditolak dan email pemberitahuan telah dikirim.';
                            } catch (Exception $mailError) {
                                $message = 'Status berhasil diperbarui, tetapi email gagal dikirim: ' . $mailError->getMessage();
                            }
                        } catch (\Throwable $e) {
                            $this->db->rollback();
                            $error = 'Gagal memproses pendaftaran. Periksa struktur database.';
                        }
                    }
                }
            }
        }

        if (empty($_SESSION['csrf_admin'])) $_SESSION['csrf_admin'] = bin2hex(random_bytes(32));
        $this->view->csrfToken = $_SESSION['csrf_admin'];
        $this->view->pendingSellers = $this->db->fetchAll(
            "SELECT u.id,u.nama,u.email,sp.nama_usaha,sp.jenis_usaha,sp.nomor_telepon,sp.alamat,sp.created_at FROM users u JOIN seller_profiles sp ON sp.user_id=u.id WHERE sp.verification_status='pending' ORDER BY sp.created_at ASC",
            Phalcon\Db::FETCH_OBJ
        );
        $this->view->message = $message;
        $this->view->error = $error;
        $this->view->title = 'Verifikasi Seller — RasaKuliner';
    }

    public function emailDecisionAction($token)
    {
        $decision = strtolower((string)$this->dispatcher->getParam('decision'));
        $token = (string)$token;
        if (!in_array($decision, ['approve', 'reject'], true) || !preg_match('/^[a-f0-9]{64}$/', $token)) {
            $this->view->decisionError = 'Tautan konfirmasi tidak valid.';
            $this->view->pick('admin/email-decision');
            return;
        }

        $ownerEmail = strtolower(trim((string)$this->config->mailer->admin_email));
        if ($ownerEmail === '') {
            $this->view->decisionError = 'Email admin belum dikonfigurasi.';
            $this->view->pick('admin/email-decision');
            return;
        }

        $action = $this->db->fetchOne(
            "SELECT a.id AS action_id,a.user_id,u.nama,u.email,sp.nama_usaha,sp.verification_status
             FROM seller_email_actions a
             JOIN users u ON u.id=a.user_id
             JOIN seller_profiles sp ON sp.user_id=a.user_id
             WHERE a.token_hash=:hash AND a.used_at IS NULL AND a.expires_at>NOW()
             LIMIT 1",
            Phalcon\Db::FETCH_ASSOC,
            ['hash'=>hash('sha256',$token)]
        );

        if (!$action || $action['verification_status'] !== 'pending') {
            $this->view->decisionError = 'Tautan sudah digunakan, kedaluwarsa, atau pendaftaran sudah diproses.';
            $this->view->pick('admin/email-decision');
            return;
        }

        $message = '';
        $error = '';
        if ($this->request->isPost()) {
            $reason = trim((string)$this->request->getPost('rejection_reason'));
            if ($decision === 'reject' && $reason === '') {
                $error = 'Alasan penolakan wajib diisi.';
            } else {
                $admin = $this->db->fetchOne('SELECT id FROM users WHERE LOWER(email)=:email LIMIT 1', Phalcon\Db::FETCH_ASSOC, ['email'=>$ownerEmail]);
                $adminId = $admin ? (int)$admin['id'] : null;
                $newStatus = $decision === 'approve' ? 'verified' : 'rejected';
                $this->db->begin();
                try {
                    $this->db->execute(
                        "UPDATE seller_profiles SET verification_status=:status,verified_by=:admin,verified_at=NOW(),rejection_reason=:reason WHERE user_id=:uid AND verification_status='pending'",
                        ['status'=>$newStatus,'admin'=>$adminId,'reason'=>$decision === 'reject' ? $reason : null,'uid'=>(int)$action['user_id']]
                    );
                    $changed = $this->db->affectedRows();
                    if ($changed !== 1) throw new Exception('Pendaftaran sudah diproses oleh admin lain.');
                    if ($decision === 'approve') {
                        $role = $this->db->fetchOne("SELECT id FROM roles WHERE slug='seller' LIMIT 1", Phalcon\Db::FETCH_ASSOC);
                        if (!$role) throw new Exception('Role seller tidak ditemukan.');
                        $this->db->execute(
                            'INSERT IGNORE INTO user_roles (user_id,role_id,assigned_by) VALUES (:uid,:rid,:admin)',
                            ['uid'=>(int)$action['user_id'],'rid'=>(int)$role['id'],'admin'=>$adminId]
                        );
                    } else {
                        $this->db->execute("DELETE ur FROM user_roles ur JOIN roles r ON r.id=ur.role_id WHERE ur.user_id=:uid AND r.slug='seller'", ['uid'=>(int)$action['user_id']]);
                    }
                    $this->db->execute('UPDATE seller_email_actions SET used_at=NOW() WHERE id=:id AND used_at IS NULL', ['id'=>(int)$action['action_id']]);
                    $this->db->commit();
                    try {
                        $this->notifySeller($action['email'], $action['nama'], $newStatus, $reason);
                        $message = $decision === 'approve'
                            ? 'Seller berhasil diterima. Akses Seller sudah aktif dan email keputusan telah dikirim ke pendaftar.'
                            : 'Pendaftaran Seller ditolak dan email keputusan telah dikirim ke pendaftar.';
                    } catch (Exception $mailError) {
                        $message = 'Status berhasil diperbarui, tetapi email ke pendaftar gagal dikirim: ' . $mailError->getMessage();
                    }
                    $action = null;
                } catch (\Throwable $e) {
                    $this->db->rollback();
                    $error = 'Gagal menyimpan keputusan: ' . $e->getMessage();
                }
            }
        }

        $this->view->action = $action;
        $this->view->decision = $decision;
        $this->view->token = $token;
        $this->view->message = $message;
        $this->view->error = $error;
        $this->view->title = 'Konfirmasi Seller — RasaKuliner';
        $this->view->pick('admin/email-decision');
    }

}
