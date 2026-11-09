<?php
use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{
    public function initialize()
    {
        if (session_status() !== PHP_SESSION_ACTIVE) session_start();

        // Hapus sesi seller lama yang belum diverifikasi agar tidak melewati pemeriksaan login baru.
        if (!empty($_SESSION['user_id']) && isset($_SESSION['user_role']) && $_SESSION['user_role'] === 'seller') {
            $verified = $this->db->fetchOne(
                "SELECT verification_status FROM seller_profiles WHERE user_id=:id LIMIT 1",
                Phalcon\Db::FETCH_ASSOC,
                ['id'=>(int)$_SESSION['user_id']]
            );
            if (!$verified || $verified['verification_status'] !== 'verified') {
                unset($_SESSION['user_id'], $_SESSION['user_name'], $_SESSION['user_role']);
            }
        }

        $root = dirname(__DIR__, 2) . '/public/assets/';
        $v = 0;
        foreach (['css/style.css', 'js/app.js', 'js/maputil.js', 'js/peta.js', 'js/detail.js', 'js/seller-location.js'] as $f) {
            if (is_file($root . $f)) $v = max($v, filemtime($root . $f));
        }
        $this->view->assetVer = $v;
        $this->view->isSeller = !empty($_SESSION['user_role']) && $_SESSION['user_role'] === 'seller';
        $this->view->isAdmin = !empty($_SESSION['user_role']) && $_SESSION['user_role'] === 'admin';
        $this->view->headerSellerName = isset($_SESSION['user_name']) ? $_SESSION['user_name'] : 'Seller';
        $this->view->headerSellerPhoto = null;
        if ($this->view->isSeller) {
            $columns = $this->db->fetchAll("SHOW COLUMNS FROM seller_profiles LIKE 'foto_profil'", Phalcon\Db::FETCH_ASSOC);
            if (!empty($columns)) {
                $photo = $this->db->fetchOne('SELECT foto_profil FROM seller_profiles WHERE user_id=:id', Phalcon\Db::FETCH_ASSOC, ['id'=>(int)$_SESSION['user_id']]);
                $this->view->headerSellerPhoto = !empty($photo['foto_profil']) ? $photo['foto_profil'] : null;
            }
        }
    }
}
