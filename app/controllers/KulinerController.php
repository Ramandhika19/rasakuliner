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

    /**
     * Membaca API key dari [vars] googleMapsApiKey atau file lokal.
     * Jangan commit API key ke repository.
     */
    private function googlePlacesApiKey()
    {
        $key = getenv('GOOGLE_MAPS_API_KEY');
        $config = $this->getDI()->get('config');
        if (isset($config->vars->googleMapsApiKey) && trim((string) $config->vars->googleMapsApiKey) !== '') {
            $key = $config->vars->googleMapsApiKey;
        }
        $localConfig = APP_PATH . '/config/google_maps.local.php';
        if (is_file($localConfig)) {
            $local = require $localConfig;
            if (is_array($local) && !empty($local['api_key'])) $key = $local['api_key'];
        }
        return trim((string) $key);
    }

    private function googlePlacesRequest($url, $apiKey, $fieldMask, $payload = null)
    {
        if (!function_exists('curl_init')) return null;
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'X-Goog-Api-Key: ' . $apiKey,
            'X-Goog-FieldMask: ' . $fieldMask
        ]);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
        curl_setopt($ch, CURLOPT_TIMEOUT, 12);
        if ($payload !== null) {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
        }
        $response = curl_exec($ch);
        $status = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        if ($response === false || $status < 200 || $status >= 300) return null;
        $decoded = json_decode($response, true);
        return is_array($decoded) ? $decoded : null;
    }

    private function googlePlaceDistance($lat1, $lng1, $lat2, $lng2)
    {
        $earth = 6371000;
        $dLat = deg2rad($lat2 - $lat1);
        $dLng = deg2rad($lng2 - $lng1);
        $a = sin($dLat / 2) * sin($dLat / 2) +
            cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
            sin($dLng / 2) * sin($dLng / 2);
        return 2 * $earth * atan2(sqrt($a), sqrt(1 - $a));
    }

    /**
     * Cari tempat yang cocok dan ambil rating saja dari hasil Text Search.
     * Tidak meminta komentar/review dan tidak memanggil Place Details.
     */
    private function fetchGoogleRatingForLocation($location, $apiKey)
    {
        $name = trim((string) $location['tempat']);
        $address = trim((string) $location['alamat'] . ' ' . (string) $location['kota']);
        $query = trim($name . ' ' . $address);
        $lat = isset($location['lat']) ? (float) $location['lat'] : 0;
        $lng = isset($location['lng']) ? (float) $location['lng'] : 0;
        if ($name === '' || $query === '') return null;

        $cacheDir = APP_PATH . '/../cache/';
        $cacheFile = $cacheDir . 'google_rating_' . md5($query . '|' . $lat . '|' . $lng) . '.json';
        if (is_file($cacheFile) && filemtime($cacheFile) > time() - 21600) {
            $cached = json_decode(file_get_contents($cacheFile), true);
            if (is_array($cached)) return $cached;
        }

        $payload = ['textQuery' => $query, 'languageCode' => 'id', 'regionCode' => 'ID', 'maxResultCount' => 5];
        if ($lat >= -90 && $lat <= 90 && $lng >= -180 && $lng <= 180 && ($lat != 0 || $lng != 0)) {
            $payload['locationBias'] = ['circle' => [
                'center' => ['latitude' => $lat, 'longitude' => $lng],
                'radius' => 3000.0
            ]];
        }

        $search = $this->googlePlacesRequest(
            'https://places.googleapis.com/v1/places:searchText',
            $apiKey,
            'places.id,places.displayName,places.location,places.formattedAddress,places.rating,places.userRatingCount,places.googleMapsUri',
            $payload
        );
        if (!$search || empty($search['places'])) return null;

        $best = null;
        $bestScore = -1;
        $targetName = strtolower(preg_replace('/[^a-z0-9]+/i', '', $name));
        foreach ($search['places'] as $candidate) {
            if (empty($candidate['id']) || empty($candidate['displayName']['text'])) continue;
            $candidateName = strtolower(preg_replace('/[^a-z0-9]+/i', '', $candidate['displayName']['text']));
            similar_text($targetName, $candidateName, $nameScore);
            $distance = 0;
            if (isset($candidate['location']['latitude'], $candidate['location']['longitude']) && ($lat != 0 || $lng != 0)) {
                $distance = $this->googlePlaceDistance($lat, $lng, (float) $candidate['location']['latitude'], (float) $candidate['location']['longitude']);
                if ($distance > 5000) continue;
            }
            $score = $nameScore - ($distance / 5000 * 15);
            if ($score > $bestScore) { $bestScore = $score; $best = $candidate; }
        }
        if (!$best || $bestScore < 35) return null;

        $result = [
            'name' => isset($best['displayName']['text']) ? $best['displayName']['text'] : $name,
            'address' => isset($best['formattedAddress']) ? $best['formattedAddress'] : $address,
            'rating' => isset($best['rating']) ? (float) $best['rating'] : null,
            'review_count' => isset($best['userRatingCount']) ? (int) $best['userRatingCount'] : 0,
            'url' => isset($best['googleMapsUri']) ? $best['googleMapsUri'] : 'https://www.google.com/maps/search/?api=1&query=' . rawurlencode($query)
        ];
        if (is_dir($cacheDir) && is_writable($cacheDir)) {
            @file_put_contents($cacheFile, json_encode($result, JSON_UNESCAPED_UNICODE));
        }
        return $result;
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
            $error = 'Data lokasi belum bisa dimuat. Import database/migrasi_lokasi.sql lewat phpMyAdmin.';
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
        $this->view->reviews = $this->db->fetchAll('SELECT nama_pengunjung,rating,komentar,created_at FROM reviews WHERE kuliner_id=:id ORDER BY created_at DESC LIMIT 30', Phalcon\Db::FETCH_OBJ, ['id'=>$id]);
        $reviewStats = $this->db->fetchOne('SELECT COUNT(*) AS total, COALESCE(AVG(rating),0) AS average FROM reviews WHERE kuliner_id=:id', Phalcon\Db::FETCH_ASSOC, ['id'=>$id]);
        $this->view->reviewTotal = (int)$reviewStats['total'];
        $this->view->reviewAverage = (float)$reviewStats['average'];
        $this->view->reviewAverageDisplay = number_format((float)$reviewStats['average'], 1, '.', '');
        $this->view->googleRatingPlaces = [];
        $googleApiKey = $this->googlePlacesApiKey();
        $this->view->googleRatingEnabled = $googleApiKey !== '';
        if ($googleApiKey !== '') {
            foreach ($lokasi as $place) {
                $googlePlace = $this->fetchGoogleRatingForLocation($place, $googleApiKey);
                if ($googlePlace) $this->view->googleRatingPlaces[] = $googlePlace;
            }
            if (empty($lokasi) && $alamatDatabase !== '') {
                $fallbackPlace = [
                    'tempat' => $kuliner->nama, 'alamat' => $alamatDatabase,
                    'kota' => $kuliner->daerah,
                    'lat' => $latDatabase !== null ? (float) $latDatabase : 0,
                    'lng' => $lngDatabase !== null ? (float) $lngDatabase : 0
                ];
                $googlePlace = $this->fetchGoogleRatingForLocation($fallbackPlace, $googleApiKey);
                if ($googlePlace) $this->view->googleRatingPlaces[] = $googlePlace;
            }
        }
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
