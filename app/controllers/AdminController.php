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
            $message = '<p>Halo ' . $safeName . ',</p><p>Selamat! Pendaftaran usaha Anda telah <b>disetujui</b>. Sekarang Anda sudah dapat login dan menggunakan mode Seller RasaKuliner.</p><p>Silakan login melalui halaman Login Seller.</p><p>Salam,<br>Tim RasaKuliner</p>';
        } else {
            $subject = 'Pembaruan pendaftaran Seller RasaKuliner';
            $safeReason = htmlspecialchars($reason, ENT_QUOTES, 'UTF-8');
            $message = '<p>Halo ' . $safeName . ',</p><p>Mohon maaf, pendaftaran Seller Anda belum dapat kami setujui.</p>';
            if ($safeReason !== '') $message .= '<p><b>Catatan admin:</b> ' . nl2br($safeReason) . '</p>';
            $message .= '<p>Silakan perbaiki data usaha sebelum mengajukan kembali.</p><p>Salam,<br>Tim RasaKuliner</p>';
        }
        $mailer->send($email, $subject, '<div style="font-family:Arial,sans-serif;line-height:1.6">' . $message . '</div>');
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

    public function emailDecisionAction($decision, $token)
    {
        $decision = strtolower((string)$decision);
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
