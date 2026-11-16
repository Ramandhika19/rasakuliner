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

        // Satu produk kuliner memiliki satu titik koordinat yang tersimpan langsung di tabel kuliner.
        $alamatDatabase = trim((string) (isset($kuliner->lokasi_alamat) ? $kuliner->lokasi_alamat : ''));
        $latDatabase = isset($kuliner->latitude) ? $kuliner->latitude : null;
        $lngDatabase = isset($kuliner->longitude) ? $kuliner->longitude : null;
        $usaha = $this->db->fetchOne(
            'SELECT sp.nama_usaha, sp.nomor_telepon, u.nama AS nama_pemilik
             FROM kuliner k
             LEFT JOIN seller_profiles sp ON sp.user_id = k.owner_user_id
             LEFT JOIN users u ON u.id = k.owner_user_id
             WHERE k.id = :id LIMIT 1',
            Phalcon\Db::FETCH_OBJ,
            ['id' => $id]
        );
        $kuliner->nama_usaha = $usaha && !empty($usaha->nama_usaha) ? $usaha->nama_usaha : 'Nama usaha belum diisi';
        $kuliner->nama_pemilik = $usaha && !empty($usaha->nama_pemilik) ? $usaha->nama_pemilik : 'Belum dicantumkan';
        $kuliner->nomor_telepon = $usaha && !empty($usaha->nomor_telepon) ? $usaha->nomor_telepon : '';
        $alamatOsmUrl = $alamatDatabase !== '' ? 'https://www.openstreetmap.org/search?query=' . rawurlencode($alamatDatabase . ', ' . $kuliner->daerah . ', Indonesia') : '';

        $this->view->active = 'kuliner';
        $this->view->title = $kuliner->nama . ' — RasaNusantara';
        $this->view->kuliner = $kuliner;
        // Jika data lama memuat beberapa ulasan dari user yang sama pada cabang berbeda,
        // tampilkan dan hitung hanya ulasan terbaru user tersebut untuk kuliner ini.
        $latestReviewFilter = '(r.user_id IS NULL OR r.id = (SELECT MAX(r2.id) FROM reviews r2 WHERE r2.kuliner_id=r.kuliner_id AND r2.user_id=r.user_id))';
        $this->view->reviews = $this->db->fetchAll(
            'SELECT r.nama_pengunjung,r.rating,r.komentar,r.created_at FROM reviews r WHERE r.kuliner_id=:id AND ' . $latestReviewFilter . '
             ORDER BY r.created_at DESC LIMIT 30',
            Phalcon\Db::FETCH_OBJ,
            ['id'=>$id]
        );
        $reviewStats = $this->db->fetchOne(
            'SELECT COUNT(*) AS total, COALESCE(AVG(r.rating),0) AS average
             FROM reviews r
             WHERE r.kuliner_id=:id AND ' . $latestReviewFilter,
            Phalcon\Db::FETCH_ASSOC,
            ['id'=>$id]
        );
        $this->view->reviewTotal = (int)$reviewStats['total'];
        $this->view->reviewAverage = (float)$reviewStats['average'];
        $this->view->reviewAverageDisplay = number_format((float)$reviewStats['average'], 1, '.', '');
        $this->view->reviewError = isset($_SESSION['review_error']) ? $_SESSION['review_error'] : '';
        $this->view->reviewSuccess = isset($_SESSION['review_success']) ? $_SESSION['review_success'] : '';
        unset($_SESSION['review_error'], $_SESSION['review_success']);
        $this->view->isUser = !empty($_SESSION['user_role']) && $_SESSION['user_role'] === 'user';
        $mapItems = [];
        if ($latDatabase !== null && $lngDatabase !== null && is_numeric($latDatabase) && is_numeric($lngDatabase)
            && abs((float)$latDatabase) <= 90 && abs((float)$lngDatabase) <= 180
            && !((float)$latDatabase === 0.0 && (float)$lngDatabase === 0.0)) {
            $mapItems[] = ['id'=>(int)$kuliner->id,'kuliner_id'=>(int)$kuliner->id,'jenis_titik'=>'kuliner',
                'tempat'=>$kuliner->nama,'kuliner'=>$kuliner->nama,'kategori'=>$kuliner->kategori,'daerah'=>$kuliner->daerah,
                'alamat'=>$alamatDatabase,'kota'=>$kuliner->daerah,'lat'=>(float)$latDatabase,'lng'=>(float)$lngDatabase,
                'nama_usaha'=>$kuliner->nama_usaha,'nama_pemilik'=>$kuliner->nama_pemilik,'telepon'=>$kuliner->nomor_telepon,
                'sumber_data'=>'database','gambar'=>$kuliner->gambar];
        }
        $this->view->lokasiJson = json_encode($mapItems, JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT);
        $this->view->lainnya = Kuliner::lainnya($id, 3);
        $this->view->alamatDatabase = $alamatDatabase;
        $this->view->alamatOsmUrl = $alamatOsmUrl;
    }
}
