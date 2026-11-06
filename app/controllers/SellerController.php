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
            $this->db->execute('UPDATE seller_profiles SET nama_usaha=:usaha,jenis_usaha=:jenis,nomor_telepon=:tel,alamat=:alamat WHERE user_id=:uid',[
                'usaha'=>trim((string)$this->request->getPost('nama_usaha')),'jenis'=>trim((string)$this->request->getPost('jenis_usaha')),
                'tel'=>trim((string)$this->request->getPost('nomor_telepon')),'alamat'=>trim((string)$this->request->getPost('alamat')),'uid'=>(int)$_SESSION['user_id']]);
            return $this->response->redirect('seller/profil');
        }
        $this->view->error=$error; $this->view->title='Profil Seller — RasaNusantara';
    }
    public function createAction()
    {
        if (!$this->requireSeller()) return;
        $this->setCommon(); $this->view->food=null; $this->view->error='';
        if ($this->request->isPost()) return $this->saveFood(null);
        $this->view->title='Tambah Kuliner — RasaNusantara';
    }
    public function editAction()
    {
        if (!$this->requireSeller()) return;
        $id=(int)$this->dispatcher->getParam('id'); $food=$this->owned($id);
        if (!$food) return $this->response->redirect('seller');
        $this->setCommon(); $this->view->food=$food; $this->view->error='';
        if ($this->request->isPost()) return $this->saveFood($id);
        $this->view->title='Edit Kuliner — RasaNusantara';
    }
    private function saveFood($id)
    {
        $data=['nama'=>trim((string)$this->request->getPost('nama')),'daerah'=>trim((string)$this->request->getPost('daerah')),
            'deskripsi'=>trim((string)$this->request->getPost('deskripsi')),'kategori'=>trim((string)$this->request->getPost('kategori')),
            'gambar'=>trim((string)$this->request->getPost('gambar'))];
        if (in_array('', $data, true) || !filter_var($data['gambar'], FILTER_VALIDATE_URL)) {
            $this->view->error='Semua kolom wajib diisi dan URL gambar harus valid.'; return;
        }
        if ($id) {
            $this->db->execute("UPDATE kuliner SET nama=:nama,daerah=:daerah,deskripsi=:deskripsi,kategori=:kategori,gambar=:gambar,status='pending',submitted_at=NOW(),reviewed_by=NULL,reviewed_at=NULL,rejection_reason=NULL WHERE id=:id AND owner_user_id=:uid", $data+['id'=>$id,'uid'=>(int)$_SESSION['user_id']]);
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
