<?php
class PetaController extends ControllerBase
{
    public function indexAction()
    {
        if (empty($_SESSION['user_id']) || empty($_SESSION['user_role']) || !in_array($_SESSION['user_role'], ['user', 'seller', 'admin'], true)) {
            return $this->response->redirect('login-user')->send();
        }
        $items = [];
        $error = '';
        try {
            $db = \Phalcon\Di::getDefault()->getShared('db');
            $foods = $db->fetchAll(
                "SELECT k.id,k.nama,k.daerah,k.kategori,k.gambar,k.lokasi_alamat,k.latitude,k.longitude,
                        sp.nama_usaha,sp.nomor_telepon,u.nama AS nama_pemilik
                 FROM kuliner k
                 LEFT JOIN seller_profiles sp ON sp.user_id=k.owner_user_id
                 LEFT JOIN users u ON u.id=k.owner_user_id
                 WHERE k.status='approved' AND k.latitude IS NOT NULL AND k.longitude IS NOT NULL
                   AND k.latitude BETWEEN -90 AND 90 AND k.longitude BETWEEN -180 AND 180
                   AND NOT (k.latitude=0 AND k.longitude=0)
                 ORDER BY k.unggulan DESC,k.nama ASC",
                \Phalcon\Db::FETCH_OBJ
            );
            foreach ($foods as $row) {
                $items[] = [
                    'id'=>(int)$row->id,'kuliner_id'=>(int)$row->id,'jenis_titik'=>'kuliner',
                    'tempat'=>$row->nama,'kuliner'=>$row->nama,'kategori'=>$row->kategori,
                    'daerah'=>$row->daerah,'alamat'=>$row->lokasi_alamat,'kota'=>$row->daerah,
                    'lat'=>(float)$row->latitude,'lng'=>(float)$row->longitude,
                    'nama_usaha'=>$row->nama_usaha ? $row->nama_usaha : 'Nama usaha belum diisi',
                    'nama_pemilik'=>$row->nama_pemilik ? $row->nama_pemilik : 'Belum dicantumkan',
                    'telepon'=>$row->nomor_telepon,'sumber_data'=>'database','gambar'=>$row->gambar
                ];
            }
        } catch (\Throwable $e) {
            $error = 'Data peta belum bisa dimuat. Periksa kolom latitude dan longitude pada tabel kuliner.';
        }
        $kategori = [];
        foreach ($items as $item) if (!empty($item['kategori'])) $kategori[$item['kategori']] = true;
        $kategori = array_keys($kategori); sort($kategori);
        $this->view->active = 'peta';
        $this->view->title = 'Peta Kuliner — RasaNusantara';
        $this->view->itemsJson = json_encode($items, JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT);
        $this->view->kategori = $kategori;
        $this->view->total = count($items);
        $this->view->dbError = $error;
    }
}