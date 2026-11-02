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
            $error = 'Data lokasi belum bisa dimuat. Import database/migrasi_lokasi.sql lewat phpMyAdmin.';
        }

        $this->view->active = 'kuliner';
        $this->view->title = $kuliner->nama . ' — RasaNusantara';
        $this->view->kuliner = $kuliner;
        $this->view->lokasi = $lokasi;
        $this->view->lokasiJson = LokasiKuliner::json($lokasi);
        $this->view->lainnya = Kuliner::lainnya($id, 3);
        $this->view->focus = (int) $this->request->getQuery('lokasi', null, 0);
        $this->view->dbError = $error;
    }
}
