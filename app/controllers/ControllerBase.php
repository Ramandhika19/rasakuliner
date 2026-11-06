<?php
use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{
    public function initialize()
    {
        if (session_status() !== PHP_SESSION_ACTIVE) { session_start(); }
        // Versi aset = waktu ubah file, supaya browser selalu memuat CSS/JS terbaru
        $root = dirname(__DIR__, 2) . '/public/assets/';
        $v = 0;
        foreach (['css/style.css', 'js/app.js', 'js/maputil.js', 'js/peta.js', 'js/detail.js'] as $f) {
            if (is_file($root . $f)) {
                $v = max($v, filemtime($root . $f));
            }
        }
        $this->view->assetVer = $v;
        $this->view->isSeller = !empty($_SESSION['user_role']) && $_SESSION['user_role'] === 'seller';
        $this->view->headerSellerName = isset($_SESSION['user_name']) ? $_SESSION['user_name'] : 'Seller';
        $this->view->headerSellerPhoto = null;
        if ($this->view->isSeller) {
            // Database lama mungkin belum menjalankan migrasi foto profil.
            // Periksa kolom terlebih dahulu agar halaman tetap bisa dibuka.
            $columns = $this->db->fetchAll("SHOW COLUMNS FROM seller_profiles LIKE 'foto_profil'", Phalcon\\Db::FETCH_ASSOC);
            if (!empty($columns)) {
                $photo = $this->db->fetchOne('SELECT foto_profil FROM seller_profiles WHERE user_id=:id', Phalcon\\Db::FETCH_ASSOC, ['id'=>(int)$_SESSION['user_id']]);
                $this->view->headerSellerPhoto = !empty($photo['foto_profil']) ? $photo['foto_profil'] : null;
            }
        }
    }
}
