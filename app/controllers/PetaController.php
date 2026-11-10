<?php
class PetaController extends ControllerBase
{
    public function indexAction()
    {
        if (empty($_SESSION['user_id']) || empty($_SESSION['user_role']) || $_SESSION['user_role'] !== 'user') {
            return $this->response->redirect('login-user')->send();
        }
        $items = [];
        $error = '';

        try {
            $items = LokasiKuliner::keArray(LokasiKuliner::semua());
        } catch (\Throwable $e) {
            $error = 'Data lokasi belum bisa dimuat. Pastikan tabel lokasi_kuliner sudah dibuat '
                   . '(import database/migrasi_lokasi.sql lewat phpMyAdmin).';
        }

        $kategori = [];
        foreach ($items as $i) {
            $kategori[$i['kategori']] = true;
        }
        $kategori = array_keys($kategori);
        sort($kategori);

        $this->view->active = 'peta';
        $this->view->title = 'Peta Kuliner — RasaNusantara';
        $this->view->itemsJson = LokasiKuliner::json($items);
        $this->view->kategori = $kategori;
        $this->view->total = count($items);
        $this->view->dbError = $error;
    }
}
