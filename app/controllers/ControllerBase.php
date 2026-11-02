<?php
use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{
    public function initialize()
    {
        // Versi aset = waktu ubah file, supaya browser selalu memuat CSS/JS terbaru
        $root = dirname(__DIR__, 2) . '/public/assets/';
        $v = 0;
        foreach (['css/style.css', 'js/app.js', 'js/maputil.js', 'js/peta.js', 'js/detail.js'] as $f) {
            if (is_file($root . $f)) {
                $v = max($v, filemtime($root . $f));
            }
        }
        $this->view->assetVer = $v;
    }
}
