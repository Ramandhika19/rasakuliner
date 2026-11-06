<?php
class SellerController extends ControllerBase
{
    private function requireSeller()
    {
        if (session_status() !== PHP_SESSION_ACTIVE) session_start();
        if (empty($_SESSION['user_id']) || empty($_SESSION['user_role']) || $_SESSION['user_role'] !== 'seller') {
            $this->response->redirect('login-seller')->send(); return false;
        }
        return true;
    }
    private function owned($id)
    {
        return $this->db->fetchOne('SELECT * FROM kuliner WHERE id=:id AND owner_user_id=:uid', Phalcon\Db::FETCH_OBJ, ['id'=>(int)$id,'uid'=>(int)$_SESSION['user_id']]);
    }
    private function profileData()
    {
        return $this->db->fetchOne('SELECT * FROM seller_profiles WHERE user_id=:id', Phalcon\Db::FETCH_OBJ, ['id'=>(int)$_SESSION['user_id']]);
    }
    private function setCommon()
    {
        $this->view->sellerName=$_SESSION['user_name'];
        $this->view->sellerProfile=$this->profileData();
        $this->view->active='seller';
    }
    private function uploadImage($field, $folder)
    {
        if (!$this->request->hasFiles()) return null;
        foreach ($this->request->getUploadedFiles() as $file) {
            if ($file->getKey() !== $field || !$file->getName()) continue;
            if ($file->getSize() > 4 * 1024 * 1024) throw new Exception('Ukuran gambar maksimal 4 MB.');
            $tmp = $file->getTempName();
            $finfo = finfo_open(FILEINFO_MIME_TYPE);
            $mime = finfo_file($finfo, $tmp);
            finfo_close($finfo);
            $extensions = ['image/jpeg'=>'jpg', 'image/png'=>'png', 'image/webp'=>'webp'];
            if (!isset($extensions[$mime])) throw new Exception('Format gambar harus JPG, PNG, atau WEBP.');
            $relativeDir = 'uploads/' . $folder;
            $absoluteDir = dirname(APP_PATH) . '/public/' . $relativeDir;
            if (!is_dir($absoluteDir) && !mkdir($absoluteDir, 0755, true) && !is_dir($absoluteDir)) {
                throw new Exception('Folder upload tidak dapat dibuat.');
            }
            $filename = $field . '-' . date('YmdHis') . '-' . bin2hex(random_bytes(5)) . '.' . $extensions[$mime];
            if (!$file->moveTo($absoluteDir . '/' . $filename)) throw new Exception('Gagal menyimpan gambar.');
            return '/' . $relativeDir . '/' . $filename;
        }
        return null;
    }
    public function indexAction()
    {
        if (!$this->requireSeller()) return;
        $this->setCommon();
        $uid=(int)$_SESSION['user_id'];
        $this->view->foods=$this->db->fetchAll('SELECT k.*,(SELECT COUNT(*) FROM reviews rv WHERE rv.kuliner_id=k.id) AS review_count,(SELECT ROUND(AVG(rv.rating),1) FROM reviews rv WHERE rv.kuliner_id=k.id) AS avg_rating FROM kuliner k WHERE k.owner_user_id=:uid ORDER BY k.updated_at DESC',Phalcon\Db::FETCH_OBJ,['uid'=>$uid]);
        $this->view->stats=$this->db->fetchOne("SELECT COUNT(*) AS total, SUM(status='approved') AS approved, SUM(status='pending') AS pending, SUM(status='rejected') AS rejected FROM kuliner WHERE owner_user_id=:uid",Phalcon\Db::FETCH_OBJ,['uid'=>$uid]);
        $this->view->reviewStats=$this->db->fetchOne('SELECT COUNT(*) AS total, ROUND(AVG(rating),1) AS average FROM reviews rv JOIN kuliner k ON k.id=rv.kuliner_id WHERE k.owner_user_id=:uid',Phalcon\Db::FETCH_OBJ,['uid'=>$uid]);
        $this->view->title='Dashboard Seller — RasaNusantara';
    }
    public function profileAction()
    {
        if (!$this->requireSeller()) return;
        $this->setCommon(); $error='';
        if ($this->request->isPost()) {
            try {
                $photo = $this->uploadImage('foto_profil', 'profil');
                $sql = 'UPDATE seller_profiles SET nama_usaha=:usaha,jenis_usaha=:jenis,nomor_telepon=:tel,alamat=:alamat';
                $bind = ['usaha'=>trim((string)$this->request->getPost('nama_usaha')),'jenis'=>trim((string)$this->request->getPost('jenis_usaha')),
                    'tel'=>trim((string)$this->request->getPost('nomor_telepon')),'alamat'=>trim((string)$this->request->getPost('alamat')),'uid'=>(int)$_SESSION['user_id']];
                if ($photo) { $sql .= ',foto_profil=:foto'; $bind['foto']=$photo; }
                $sql .= ' WHERE user_id=:uid';
                $this->db->execute($sql, $bind);
                return $this->response->redirect('seller/profil');
            } catch (Exception $e) { $error=$e->getMessage(); }
            $this->setCommon();
        }
        $this->view->error=$error; $this->view->title='Profil Seller — RasaNusantara';
    }
    public function createAction()
    {
        if (!$this->requireSeller()) return;
        $this->setCommon();
        $this->view->food=(object)[];
        $this->view->error='';
        $this->view->title='Tambah Kuliner — RasaNusantara';
        // createAction dan editAction memakai satu template form.volt.
        $this->view->pick('seller/form');
        if ($this->request->isPost()) return $this->saveFood(null);
    }
    public function editAction()
    {
        if (!$this->requireSeller()) return;
        $id=(int)$this->dispatcher->getParam('id'); $food=$this->owned($id);
        if (!$food) return $this->response->redirect('seller');
        $this->setCommon(); $this->view->food=$food; $this->view->error='';
        $this->view->title='Edit Kuliner — RasaNusantara';
        // Hindari Phalcon mencari seller/edit.volt yang memang tidak ada.
        $this->view->pick('seller/form');
        if ($this->request->isPost()) return $this->saveFood($id);
    }
    private function saveFood($id)
    {
        $data=['nama'=>trim((string)$this->request->getPost('nama')),'daerah'=>trim((string)$this->request->getPost('daerah')),
            'deskripsi'=>trim((string)$this->request->getPost('deskripsi')),'kategori'=>trim((string)$this->request->getPost('kategori'))];
        try {
            $image = $this->uploadImage('gambar', 'kuliner');
            if ($image) $data['gambar']=$image;
            elseif (!$id) throw new Exception('Pilih gambar makanan terlebih dahulu.');
            if (in_array('', $data, true)) throw new Exception('Semua informasi kuliner wajib diisi.');
        } catch (Exception $e) {
            $this->view->error=$e->getMessage();
            $this->view->food=$id ? $this->owned($id) : null;
            return;
        }
        if ($id) {
            $sql="UPDATE kuliner SET nama=:nama,daerah=:daerah,deskripsi=:deskripsi,kategori=:kategori,status='pending',submitted_at=NOW(),reviewed_by=NULL,reviewed_at=NULL,rejection_reason=NULL";
            if (isset($data['gambar'])) $sql.=',gambar=:gambar';
            $sql.=' WHERE id=:id AND owner_user_id=:uid';
            $this->db->execute($sql, $data+['id'=>$id,'uid'=>(int)$_SESSION['user_id']]);
        } else {
            $this->db->execute("INSERT INTO kuliner (owner_user_id,nama,daerah,deskripsi,kategori,gambar,status,submitted_at) VALUES (:uid,:nama,:daerah,:deskripsi,:kategori,:gambar,'pending',NOW())", $data+['uid'=>(int)$_SESSION['user_id']]);
        }
        return $this->response->redirect('seller');
    }
    public function deleteAction()
    {
        if (!$this->requireSeller()) return;
        $id=(int)$this->dispatcher->getParam('id');
        if ($this->request->isPost()) $this->db->execute('DELETE FROM kuliner WHERE id=:id AND owner_user_id=:uid',['id'=>$id,'uid'=>(int)$_SESSION['user_id']]);
        return $this->response->redirect('seller');
    }
}
