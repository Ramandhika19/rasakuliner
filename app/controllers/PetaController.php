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

            // Titik makanan: koordinat wilayah asal pada tabel kuliner.
            $foods = $db->fetchAll(
                "SELECT id, nama, daerah, kategori, gambar, lokasi_alamat, latitude, longitude
                 FROM kuliner
                 WHERE status = 'approved'
                   AND latitude IS NOT NULL AND longitude IS NOT NULL
                   AND latitude BETWEEN -90 AND 90
                   AND longitude BETWEEN -180 AND 180
                   AND NOT (latitude = 0 AND longitude = 0)
                 ORDER BY unggulan DESC, nama ASC",
                \Phalcon\Db::FETCH_OBJ
            );

            foreach ($foods as $row) {
                $items[] = [
                    'id' => 'kuliner-' . (int) $row->id,
                    'kuliner_id' => (int) $row->id,
                    'jenis_titik' => 'kuliner',
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
                    'sumber_data' => 'database',
                    'gambar' => $row->gambar
                ];
            }

            // Titik warung/restoran: koordinat usaha pada tabel lokasi_kuliner.
            // Data seller tetap ditandai sebagai seller dan tidak dicampur dengan titik asal makanan.
            $places = $db->fetchAll(
                "SELECT l.id, l.kuliner_id, l.nama_tempat, l.alamat, l.kota,
                        l.latitude, l.longitude, l.jam_buka, l.kisaran_harga,
                        l.sumber_data,
                        k.nama AS nama_kuliner, k.daerah, k.kategori, k.gambar
                 FROM lokasi_kuliner l
                 INNER JOIN kuliner k ON k.id = l.kuliner_id
                 WHERE k.status = 'approved'
                   AND l.latitude IS NOT NULL AND l.longitude IS NOT NULL
                   AND l.latitude BETWEEN -90 AND 90
                   AND l.longitude BETWEEN -180 AND 180
                   AND NOT (l.latitude = 0 AND l.longitude = 0)
                 ORDER BY l.nama_tempat ASC",
                \Phalcon\Db::FETCH_OBJ
            );

            foreach ($places as $row) {
                $items[] = [
                    'id' => 'lokasi-' . (int) $row->id,
                    'lokasi_id' => (int) $row->id,
                    'kuliner_id' => (int) $row->kuliner_id,
                    'jenis_titik' => 'lokasi',
                    'tempat' => $row->nama_tempat,
                    'kuliner' => $row->nama_kuliner,
                    'kategori' => $row->kategori,
                    'daerah' => $row->daerah,
                    'alamat' => $row->alamat,
                    'kota' => $row->kota,
                    'lat' => (float) $row->latitude,
                    'lng' => (float) $row->longitude,
                    'jam' => $row->jam_buka,
                    'harga' => $row->kisaran_harga,
                    'sumber_data' => $row->sumber_data,
                    'gambar' => $row->gambar
                ];
            }
        } catch (\Throwable $e) {
            $error = 'Data peta belum bisa dimuat. Periksa struktur tabel kuliner dan lokasi_kuliner beserta kolom koordinatnya.';
        }

        $kategori = [];
        foreach ($items as $item) {
            if (!empty($item['kategori'])) {
                $kategori[$item['kategori']] = true;
            }
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
