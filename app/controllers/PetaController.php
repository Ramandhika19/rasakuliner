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
            $db = \Phalcon\\Di::getDefault()->getShared('db');
            // Peta kuliner publik mengambil titik langsung dari tabel kuliner.
            // Hanya data database yang disetujui dan memiliki koordinat valid yang ditampilkan.
            $rows = $db->fetchAll(
                "SELECT id, nama, daerah, kategori, gambar, lokasi_alamat, latitude, longitude
                 FROM kuliner
                 WHERE status = 'approved'
                   AND latitude IS NOT NULL AND longitude IS NOT NULL
                   AND latitude BETWEEN -90 AND 90
                   AND longitude BETWEEN -180 AND 180
                   AND NOT (latitude = 0 AND longitude = 0)
                 ORDER BY unggulan DESC, nama ASC",
                \Phalcon\\Db::FETCH_OBJ
            );

            foreach ($rows as $row) {
                $items[] = [
                    'id' => (int) $row->id,
                    'kuliner_id' => (int) $row->id,
                    'tempat' => $row->nama,
                    'kuliner' => $row->nama,
                    'kategori' => $row->kategori,
                    'daerah' => $row->daerah,
                    'alamat' => $row->lokasi_alamat,
                    'kota' => $row->daerah,
                    'lat' => (float) $row->latitude,
                    'lng' => (float) $row->longitude,
                    'jam' => null,
                    'harga' => null,
                    'rating' => null,
                    'google_place_id' => null,
                    'sumber_data' => 'database',
                    'gambar' => $row->gambar
                ];
            }
        } catch (\Throwable $e) {
            $error = 'Data kuliner peta belum bisa dimuat. Pastikan kolom lokasi_alamat, latitude, dan longitude tersedia pada tabel kuliner.';
        }

        $kategori = [];
        foreach ($items as $item) {
            $kategori[$item['kategori']] = true;
        }
        $kategori = array_keys($kategori);
        sort($kategori);

        $this->view->active = 'peta';
        $this->view->title = 'Peta Kuliner — RasaNusantara';
        $this->view->itemsJson = json_encode($items, JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT);
        $this->view->kategori = $kategori;
        $this->view->total = count($items);
        $this->view->dbError = $error;
    }
}
