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
        $this->view->sellerName=isset($_SESSION['user_name']) ? $_SESSION['user_name'] : 'Seller';
        $this->view->sellerProfile=$this->profileData();
        $this->view->active='seller';
    }
    private function saveUploadedImages($field, $kulinerId)
    {
        $saved = [];
        if (!$this->request->hasFiles()) return $saved;
        $dir = dirname(APP_PATH) . '/public/img/kuliner/' . (int)$kulinerId;
        foreach ($this->request->getUploadedFiles() as $file) {
            if ($file->getKey() !== $field || !$file->getName()) continue;
            if (count($saved) >= 3) throw new Exception('Maksimal 3 gambar untuk satu kuliner.');
            if ($file->getSize() > 4 * 1024 * 1024) throw new Exception('Ukuran setiap gambar maksimal 4 MB.');
            $finfo = finfo_open(FILEINFO_MIME_TYPE);
            $mime = finfo_file($finfo, $file->getTempName());
            finfo_close($finfo);
            $ext = ['image/jpeg'=>'jpg','image/png'=>'png','image/webp'=>'webp'];
            if (!isset($ext[$mime])) throw new Exception('Format gambar harus JPG, PNG, atau WEBP.');
            if (!is_dir($dir) && !mkdir($dir, 0755, true) && !is_dir($dir)) throw new Exception('Folder img/kuliner tidak dapat dibuat.');
            $name = 'kuliner-' . (int)$kulinerId . '-' . date('YmdHis') . '-' . bin2hex(random_bytes(4)) . '.' . $ext[$mime];
            if (!$file->moveTo($dir . '/' . $name)) throw new Exception('Gagal menyimpan gambar.');
            $saved[] = 'img/kuliner/' . (int)$kulinerId . '/' . $name;
        }
        return $saved;
    }
    private function removeLocalImage($path, $prefix)
    {
        $path = str_replace('\\\\', '/', (string)$path);
        if (strpos($path, $prefix) !== 0) return;
        $full = dirname(APP_PATH) . '/public/' . $path;
        if (is_file($full)) @unlink($full);
    }
    private function uploadProfileImage()
    {
        if (!$this->request->hasFiles()) return null;
        foreach ($this->request->getUploadedFiles() as $file) {
            if ($file->getKey() !== 'foto_profil' || !$file->getName()) continue;
            if ($file->getSize() > 4 * 1024 * 1024) throw new Exception('Ukuran gambar maksimal 4 MB.');
            $finfo=finfo_open(FILEINFO_MIME_TYPE); $mime=finfo_file($finfo,$file->getTempName()); finfo_close($finfo);
            $ext=['image/jpeg'=>'jpg','image/png'=>'png','image/webp'=>'webp'];
            if (!isset($ext[$mime])) throw new Exception('Format foto harus JPG, PNG, atau WEBP.');
            $uid=(int)$_SESSION['user_id']; $dir=dirname(APP_PATH).'/public/img/profil/'.$uid;
            if (!is_dir($dir) && !mkdir($dir,0755,true) && !is_dir($dir)) throw new Exception('Folder foto profil tidak dapat dibuat.');
            $name='profil-'.$uid.'-'.date('YmdHis').'-'.bin2hex(random_bytes(4)).'.'.$ext[$mime];
            if (!$file->moveTo($dir.'/'.$name)) throw new Exception('Gagal menyimpan foto profil.');
            return 'img/profil/'.$uid.'/'.$name;
        }
        return null;
    }
    private function existingGallery($id)
    {
        return $this->db->fetchAll('SELECT id,gambar FROM kuliner_gambar WHERE kuliner_id=:id ORDER BY urutan,id', Phalcon\Db::FETCH_OBJ, ['id'=>(int)$id]);
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
                $oldProfile = $this->profileData();
                $photo = $this->uploadProfileImage();
                $sql = 'UPDATE seller_profiles SET nama_usaha=:usaha,jenis_usaha=:jenis,nomor_telepon=:tel,alamat=:alamat';
                $bind = ['usaha'=>trim((string)$this->request->getPost('nama_usaha')),'jenis'=>trim((string)$this->request->getPost('jenis_usaha')),
                    'tel'=>trim((string)$this->request->getPost('nomor_telepon')),'alamat'=>trim((string)$this->request->getPost('alamat')),'uid'=>(int)$_SESSION['user_id']];
                if ($photo) { $sql .= ',foto_profil=:foto'; $bind['foto']=$photo; }
                $sql .= ' WHERE user_id=:uid';
                $this->db->execute($sql, $bind);
                if ($photo && !empty($oldProfile->foto_profil)) $this->removeLocalImage($oldProfile->foto_profil, 'img/profil/'.(int)$_SESSION['user_id'].'/');
                return $this->response->redirect('seller/profil');
            } catch (Exception $e) { $error=$e->getMessage(); }
            $this->setCommon();
        }
        $this->view->error=$error; $this->view->title='Profil Seller — RasaNusantara';
    }
    public function createAction()
    {
        if (!$this->requireSeller()) return;
        $this->setCommon(); $this->view->food=(object)[]; $this->view->isEdit=false; $this->view->error='';
        $this->view->title='Tambah Kuliner — RasaNusantara';
        $this->view->pick('seller/form');
        if ($this->request->isPost()) return $this->saveFood(null);
    }
    public function editAction()
    {
        if (!$this->requireSeller()) return;
        $id=(int)$this->dispatcher->getParam('id'); $food=$this->owned($id);
        if (!$food) return $this->response->redirect('seller');
        $this->setCommon(); $this->view->food=$food; $this->view->isEdit=true; $this->view->error='';
        $this->view->title='Edit Kuliner — RasaNusantara';
        $this->view->pick('seller/form');
        if ($this->request->isPost()) return $this->saveFood($id);
    }
    private function saveFood($id)
    {
        $data=['nama'=>trim((string)$this->request->getPost('nama')),'daerah'=>trim((string)$this->request->getPost('daerah')),
            'deskripsi'=>trim((string)$this->request->getPost('deskripsi')),'kategori'=>trim((string)$this->request->getPost('kategori')),
            'lokasi_alamat'=>trim((string)$this->request->getPost('lokasi_alamat')),
            'latitude'=>trim((string)$this->request->getPost('latitude')),'longitude'=>trim((string)$this->request->getPost('longitude'))];
        try {
            $image = $this->uploadImage('gambar', 'kuliner');
            if ($image) $data['gambar']=$image;
            elseif (!$id) throw new Exception('Pilih gambar makanan terlebih dahulu.');
            if ($data['nama']==='' || $data['daerah']==='' || $data['deskripsi']==='' || $data['kategori']==='') throw new Exception('Nama, daerah, kategori, dan deskripsi wajib diisi.');
            if ($data['latitude']!=='' && !is_numeric($data['latitude'])) throw new Exception('Latitude tidak valid.');
            if ($data['longitude']!=='' && !is_numeric($data['longitude'])) throw new Exception('Longitude tidak valid.');
            if (($data['latitude']==='') !== ($data['longitude']==='')) throw new Exception('Pilih titik lokasi pada peta sampai koordinat terisi.');
            if ($data['latitude']!=='' && (abs((float)$data['latitude'])>90 || abs((float)$data['longitude'])>180)) throw new Exception('Koordinat lokasi berada di luar batas yang valid.');
            if ($data['latitude']==='') { $data['latitude']=null; $data['longitude']=null; }
        } catch (Exception $e) {
            $this->view->error=$e->getMessage();
            $this->view->food=$id ? $this->owned($id) : (object)$data;
            return;
        }
        if ($id) {
            $sql="UPDATE kuliner SET nama=:nama,daerah=:daerah,deskripsi=:deskripsi,kategori=:kategori,lokasi_alamat=:lokasi_alamat,latitude=:latitude,longitude=:longitude,status='pending',submitted_at=NOW(),reviewed_by=NULL,reviewed_at=NULL,rejection_reason=NULL";
            if (isset($data['gambar'])) $sql.=',gambar=:gambar';
            $sql.=' WHERE id=:id AND owner_user_id=:uid';
            $this->db->execute($sql, $data+['id'=>$id,'uid'=>(int)$_SESSION['user_id']]);
        } else {
            $this->db->execute("INSERT INTO kuliner (owner_user_id,nama,daerah,deskripsi,kategori,gambar,lokasi_alamat,latitude,longitude,status,submitted_at) VALUES (:uid,:nama,:daerah,:deskripsi,:kategori,:gambar,:lokasi_alamat,:latitude,:longitude,'pending',NOW())", $data+['uid'=>(int)$_SESSION['user_id']]);
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
