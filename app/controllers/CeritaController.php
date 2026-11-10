<?php
class CeritaController extends ControllerBase
{
    public function indexAction()
    {
        $search = trim((string) $this->request->getQuery('q', null, ''));
        $category = trim((string) $this->request->getQuery('kategori', null, ''));

        $where = "status = 'published'
            AND (:category_filter = '' OR kategori = :category_value)
            AND (:search_filter = '' OR judul LIKE :title_search OR ringkasan LIKE :summary_search OR isi LIKE :body_search OR daerah LIKE :region_search)";
        $params = [
            'category_filter' => $category,
            'category_value' => $category,
            'search_filter' => $search,
            'title_search' => '%' . $search . '%',
            'summary_search' => '%' . $search . '%',
            'body_search' => '%' . $search . '%',
            'region_search' => '%' . $search . '%'
        ];

        $this->view->articles = $this->db->fetchAll(
            "SELECT id,slug,judul,kategori,daerah,ringkasan,gambar,penulis,published_at,views,unggulan
             FROM cerita WHERE " . $where . "
             ORDER BY unggulan DESC, published_at DESC, id DESC",
            Phalcon\Db::FETCH_OBJ,
            $params
        );
        $this->view->categories = $this->db->fetchAll(
            "SELECT DISTINCT kategori FROM cerita WHERE status='published' ORDER BY kategori",
            Phalcon\Db::FETCH_OBJ
        );
        $this->view->search = $search;
        $this->view->selectedCategory = $category;
        $this->view->active = 'cerita';
        $this->view->title = 'Cerita & Blog Kuliner Nusantara — RasaKuliner';
    }

    public function detailAction($slug)
    {
        $slug = strtolower(trim((string) $slug));
        $article = $this->db->fetchOne(
            "SELECT * FROM cerita WHERE slug=:slug AND status='published' LIMIT 1",
            Phalcon\Db::FETCH_OBJ,
            ['slug' => $slug]
        );
        if (!$article) return $this->response->redirect('cerita');

        $this->db->execute('UPDATE cerita SET views=views+1 WHERE id=:id', ['id' => (int) $article->id]);
        $article->views = (int) $article->views + 1;

        $this->view->article = $article;
        $this->view->related = $this->db->fetchAll(
            "SELECT id,slug,judul,kategori,daerah,ringkasan,gambar,published_at
             FROM cerita WHERE status='published' AND id<>:id
             ORDER BY (kategori=:category) DESC, unggulan DESC, published_at DESC LIMIT 3",
            Phalcon\Db::FETCH_OBJ,
            ['id' => (int) $article->id, 'category' => $article->kategori]
        );
        $this->view->active = 'cerita';
        $this->view->title = $article->judul . ' — Cerita RasaKuliner';
    }
}
