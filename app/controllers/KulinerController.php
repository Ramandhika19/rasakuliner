<?php
class KulinerController extends ControllerBase
{
    const PER_HALAMAN = 12;

    public function indexAction()
    {
        $region = trim((string) $this->request->getQuery('daerah', null, ''));
        $search = trim((string) $this->request->getQuery('q', null, ''));
        $page = max(1, (int) $this->request->getQuery('halaman', null, 1));

        $total = Kuliner::hitung($region, $search);
        $pages = max(1, (int) ceil($total / self::PER_HALAMAN));
        $page = min($page, $pages);

        $this->view->active = 'kuliner';
        $this->view->title = 'Jelajahi Kuliner — RasaNusantara';
        $this->view->selectedRegion = $region;
        $this->view->search = $search;
        $this->view->kuliner = Kuliner::semua($region, $search, self::PER_HALAMAN, ($page - 1) * self::PER_HALAMAN);
        $this->view->regions = Kuliner::daerah();
        $this->view->total = $total;
        $this->view->page = $page;
        $this->view->pages = $pages;
        $this->view->pageLinks = $this->pageLinks($region, $search, $page, $pages);
        $this->view->prevUrl = $page > 1 ? $this->pageUrl($region, $search, $page - 1) : '';
        $this->view->nextUrl = $page < $pages ? $this->pageUrl($region, $search, $page + 1) : '';
        $this->view->regionLinks = $this->regionLinks($search);
    }

    private function pageUrl($region, $search, $page)
    {
        $params = [];
        if ($region !== '') {
            $params['daerah'] = $region;
        }
        if ($search !== '') {
            $params['q'] = $search;
        }
        if ($page > 1) {
            $params['halaman'] = $page;
        }

        return $this->url->get('kuliner') . ($params ? '?' . http_build_query($params) : '');
    }

    private function pageLinks($region, $search, $page, $pages)
    {
        $links = [];
        for ($i = 1; $i <= $pages; $i++) {
            $links[] = ['n' => $i, 'url' => $this->pageUrl($region, $search, $i), 'current' => $i === $page];
        }

        return $links;
    }

    private function regionLinks($search)
    {
        $links = [];
        foreach (Kuliner::daerah() as $r) {
            $links[$r->daerah] = $this->pageUrl($r->daerah, $search, 1);
        }

        return $links;
    }

    public function detailAction()
    {
        $id = (int) $this->dispatcher->getParam('id');
        $kuliner = Kuliner::cari($id);

        if (!$kuliner) {
            return $this->response->redirect('kuliner');
        }

        $lokasi = [];
        $error = '';
        try {
            $lokasi = LokasiKuliner::keArray(LokasiKuliner::untukKuliner($id));
        } catch (\Throwable $e) {
            $error = 'Data lokasi belum bisa dimuat. Import database/migrations/20261111_sumber_lokasi.sql lewat phpMyAdmin.';
        }

        // Fallback: gunakan alamat/koordinat yang disimpan langsung pada tabel kuliner
        // apabila belum ada baris di tabel lokasi_kuliner.
        $alamatDatabase = trim((string) (isset($kuliner->lokasi_alamat) ? $kuliner->lokasi_alamat : ''));
        $latDatabase = isset($kuliner->latitude) ? $kuliner->latitude : null;
        $lngDatabase = isset($kuliner->longitude) ? $kuliner->longitude : null;
        $this->view->alamatDatabase = $alamatDatabase;
        $this->view->alamatMapsUrl = $alamatDatabase !== ''
            ? 'https://www.google.com/maps/search/?api=1&query=' . rawurlencode($alamatDatabase . ', ' . $kuliner->daerah . ', Indonesia')
            : '';
        $this->view->alamatOsmUrl = $alamatDatabase !== ''
            ? 'https://www.openstreetmap.org/search?query=' . rawurlencode($alamatDatabase . ', ' . $kuliner->daerah . ', Indonesia')
            : '';
        if (count($lokasi) === 0 && $alamatDatabase !== '') {
            if ($latDatabase !== null && $lngDatabase !== null && is_numeric($latDatabase) && is_numeric($lngDatabase)) {
                $lokasi[] = [
                    'id' => 0, 'kuliner_id' => $id, 'tempat' => $kuliner->nama,
                    'kuliner' => $kuliner->nama, 'kategori' => $kuliner->kategori,
                    'daerah' => $kuliner->daerah, 'alamat' => $alamatDatabase,
                    'kota' => $kuliner->daerah, 'lat' => (float) $latDatabase,
                    'lng' => (float) $lngDatabase, 'jam' => '', 'harga' => '',
                    'rating' => null, 'telepon' => '', 'gambar' => $kuliner->gambar
                ];
            }
        }

        $this->view->active = 'kuliner';
        $this->view->title = $kuliner->nama . ' — RasaNusantara';
        $this->view->kuliner = $kuliner;
        $this->view->lokasi = $lokasi;
        $this->view->reviews = $this->db->fetchAll('SELECT r.nama_pengunjung,r.rating,r.komentar,r.created_at,l.nama_tempat FROM reviews r LEFT JOIN lokasi_kuliner l ON l.id=r.lokasi_id WHERE r.kuliner_id=:id ORDER BY r.created_at DESC LIMIT 30', Phalcon\Db::FETCH_OBJ, ['id'=>$id]);
        $reviewStats = $this->db->fetchOne('SELECT COUNT(*) AS total, COALESCE(AVG(rating),0) AS average FROM reviews WHERE kuliner_id=:id', Phalcon\Db::FETCH_ASSOC, ['id'=>$id]);
        $this->view->reviewTotal = (int)$reviewStats['total'];
        $this->view->reviewAverage = (float)$reviewStats['average'];
        $this->view->reviewAverageDisplay = number_format((float)$reviewStats['average'], 1, '.', '');
        // Google Maps hanya menjadi tautan referensi eksternal; tidak memanggil Places API berbayar.
        $this->view->googleReviewPlaces = [];
        $this->view->googleRatingEnabled = false;
        $this->view->reviewError = isset($_SESSION['review_error']) ? $_SESSION['review_error'] : '';
        $this->view->reviewSuccess = isset($_SESSION['review_success']) ? $_SESSION['review_success'] : '';
        unset($_SESSION['review_error'], $_SESSION['review_success']);
        $this->view->isUser = !empty($_SESSION['user_role']) && $_SESSION['user_role'] === 'user';
        $this->view->lokasiJson = LokasiKuliner::json($lokasi);
        $this->view->lainnya = Kuliner::lainnya($id, 3);
        $this->view->focus = (int) $this->request->getQuery('lokasi', null, 0);
        $this->view->dbError = $error;
    }
}
