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
     * Ambil ulasan publik Google untuk satu cabang/tempat.
     * Hanya place_id yang disimpan; konten Google diminta ulang saat halaman dibuka.
     */
    private function fetchGoogleReviewsForLocation($location, $apiKey)
    {
        $name = trim((string) $location['tempat']);
        $address = trim((string) $location['alamat'] . ' ' . (string) $location['kota']);
        $query = trim($name . ' ' . $address);
        if ($name === '' || $query === '') return null;
        $placeId = isset($location['google_place_id']) ? trim((string) $location['google_place_id']) : '';
        if ($placeId === '') {
            $payload = ['textQuery' => $query, 'languageCode' => 'id', 'regionCode' => 'ID', 'maxResultCount' => 5];
            $lat = isset($location['lat']) ? (float) $location['lat'] : 0;
            $lng = isset($location['lng']) ? (float) $location['lng'] : 0;
            if ($lat >= -90 && $lat <= 90 && $lng >= -180 && $lng <= 180 && ($lat != 0 || $lng != 0)) {
                $payload['locationBias'] = ['circle' => ['center' => ['latitude' => $lat, 'longitude' => $lng], 'radius' => 3000.0]];
            }
            $search = $this->googlePlacesRequest('https://places.googleapis.com/v1/places:searchText', $apiKey, 'places.id,places.displayName,places.location', $payload);
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
            if (!$best || $bestScore < 45) return null;
            $placeId = $best['id'];
            if (!empty($location['id'])) {
                $this->db->execute("UPDATE lokasi_kuliner SET google_place_id=:place_id WHERE id=:id AND (google_place_id IS NULL OR google_place_id='')", ['place_id' => $placeId, 'id' => (int) $location['id']]);
            }
        }
        $details = $this->googlePlacesRequest('https://places.googleapis.com/v1/places/' . rawurlencode($placeId), $apiKey, 'id,displayName,formattedAddress,rating,userRatingCount,googleMapsUri,reviews');
        if (!$details) return null;
        $reviews = [];
        if (!empty($details['reviews']) && is_array($details['reviews'])) {
            foreach ($details['reviews'] as $review) {
                $reviews[] = [
                    'author' => isset($review['authorAttribution']['displayName']) ? $review['authorAttribution']['displayName'] : 'Pengguna Google Maps',
                    'rating' => isset($review['rating']) ? (float) $review['rating'] : 0,
                    'text' => isset($review['text']['text']) ? $review['text']['text'] : '',
                    'published' => isset($review['relativePublishTimeDescription']) ? $review['relativePublishTimeDescription'] : '',
                    'url' => isset($review['googleMapsUri']) ? $review['googleMapsUri'] : (isset($details['googleMapsUri']) ? $details['googleMapsUri'] : ''),
                    'flag_url' => isset($review['flagContentUri']) ? $review['flagContentUri'] : ''
                ];
            }
        }
        return [
            'name' => isset($details['displayName']['text']) ? $details['displayName']['text'] : $name,
            'address' => isset($details['formattedAddress']) ? $details['formattedAddress'] : $address,
            'rating' => isset($details['rating']) ? (float) $details['rating'] : null,
            'review_count' => isset($details['userRatingCount']) ? (int) $details['userRatingCount'] : 0,
            'url' => isset($details['googleMapsUri']) ? $details['googleMapsUri'] : 'https://www.google.com/maps/search/?api=1&query=' . rawurlencode($query),
            'reviews' => $reviews
        ];
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
        $this->view->reviews = $this->db->fetchAll('SELECT r.nama_pengunjung,r.rating,r.komentar,r.created_at,l.nama_tempat FROM reviews r LEFT JOIN lokasi_kuliner l ON l.id=r.lokasi_id WHERE r.kuliner_id=:id ORDER BY r.created_at DESC LIMIT 30', Phalcon\Db::FETCH_OBJ, ['id'=>$id]);
        $reviewStats = $this->db->fetchOne('SELECT COUNT(*) AS total, COALESCE(AVG(rating),0) AS average FROM reviews WHERE kuliner_id=:id', Phalcon\Db::FETCH_ASSOC, ['id'=>$id]);
        $this->view->reviewTotal = (int)$reviewStats['total'];
        $this->view->reviewAverage = (float)$reviewStats['average'];
        $this->view->reviewAverageDisplay = number_format((float)$reviewStats['average'], 1, '.', '');
        $this->view->googleReviewPlaces = [];
        $googleApiKey = $this->googlePlacesApiKey();
        $this->view->googleRatingEnabled = $googleApiKey !== '';
        if ($googleApiKey !== '') {
            foreach ($lokasi as $place) {
                $googlePlace = $this->fetchGoogleReviewsForLocation($place, $googleApiKey);
                if ($googlePlace) {
                    $googlePlace['local_name'] = $place['tempat'];
                    $this->view->googleReviewPlaces[] = $googlePlace;
                }
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
