<?php
class AuthController extends ControllerBase
{
    private function go($path) { return $this->response->redirect($path); }
    public function registerAction()
    {
        if (session_status() !== PHP_SESSION_ACTIVE) session_start();
        if (!empty($_SESSION['user_id'])) return $this->go('seller');
        $error = '';
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
                        $db->execute('INSERT INTO users (nama,email,password_hash,status) VALUES (:nama,:email,:hash,\'active\')', ['nama'=>$nama,'email'=>$email,'hash'=>password_hash($password, PASSWORD_DEFAULT)]);
                        $uid = (int)$db->lastInsertId();
                        $role = $db->fetchOne("SELECT id FROM roles WHERE slug='seller'", Phalcon\Db::FETCH_ASSOC);
                        if (!$role) throw new Exception('Role seller belum tersedia. Import database terbaru.');
                        $db->execute('INSERT INTO user_roles (user_id,role_id) VALUES (:uid,:rid)', ['uid'=>$uid,'rid'=>$role['id']]);
                        $db->execute("INSERT INTO seller_profiles (user_id,nama_usaha,jenis_usaha,nomor_telepon,alamat,verification_status) VALUES (:uid,:usaha,:jenis,:tel,:alamat,'pending')", ['uid'=>$uid,'usaha'=>$usaha,'jenis'=>$jenis,'tel'=>$telepon,'alamat'=>$alamat]);
                        $db->commit();
                        $_SESSION['user_id']=$uid; $_SESSION['user_name']=$nama; $_SESSION['user_role']='seller';
                        return $this->go('seller');
                    } catch (\Throwable $e) { $db->rollback(); $error='Pendaftaran belum berhasil. Pastikan migrasi seller sudah diimpor.'; }
                }
            }
        }
        $this->view->error=$error; $this->view->title='Daftar Seller — RasaNusantara';
    }
    public function loginAction()
    {
        if (session_status() !== PHP_SESSION_ACTIVE) session_start();
        if (!empty($_SESSION['user_id'])) return $this->go('seller');
        $error='';
        if ($this->request->isPost()) {
            $email=strtolower(trim((string)$this->request->getPost('email')));
            $password=(string)$this->request->getPost('password');
            $user=$this->db->fetchOne("SELECT u.id,u.nama,u.password_hash,u.status,r.slug AS role FROM users u JOIN user_roles ur ON ur.user_id=u.id JOIN roles r ON r.id=ur.role_id WHERE u.email=:email LIMIT 1", Phalcon\Db::FETCH_ASSOC, ['email'=>$email]);
            if ($user && $user['status']==='active' && password_verify($password,$user['password_hash']) && $user['role']==='seller') {
                $_SESSION['user_id']=(int)$user['id']; $_SESSION['user_name']=$user['nama']; $_SESSION['user_role']=$user['role'];
                $this->db->execute('UPDATE users SET last_login_at=NOW() WHERE id=:id',['id'=>$user['id']]);
                return $this->go('seller');
            }
            $error='Email atau password salah, atau akun ini bukan akun seller.';
        }
        $this->view->error=$error; $this->view->title='Login Seller — RasaNusantara';
    }
    public function logoutAction()
    {
        if (session_status() !== PHP_SESSION_ACTIVE) session_start();
        $_SESSION=[]; session_destroy();
        return $this->go('');
    }
}
