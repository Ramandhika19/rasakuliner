<?php
class ReviewController extends ControllerBase
{
    public function createAction()
    {
        $id = (int) $this->dispatcher->getParam('id');
        if (empty($_SESSION['user_id']) || empty($_SESSION['user_role']) || $_SESSION['user_role'] !== 'user') {
            return $this->response->redirect('login-user')->send();
        }

        $food = $this->db->fetchOne("SELECT id FROM kuliner WHERE id=:id AND status='approved' LIMIT 1", Phalcon\\Db::FETCH_ASSOC, ['id' => $id]);
        if (!$food) return $this->response->redirect('kuliner')->send();
        if (!$this->request->isPost()) return $this->response->redirect('kuliner/detail/' . $id)->send();

        $rating = (int) $this->request->getPost('rating');
        $comment = trim((string) $this->request->getPost('komentar'));
        $locationId = (int) $this->request->getPost('lokasi_id');

        if ($rating < 1 || $rating > 5 || $comment === '') {
            $_SESSION['review_error'] = 'Pilih rating 1–5 dan tulis ulasan terlebih dahulu.';
            return $this->response->redirect('kuliner/detail/' . $id . '#ulasan')->send();
        }

        $location = null;
        if ($locationId > 0) {
            $location = $this->db->fetchOne(
                'SELECT id FROM lokasi_kuliner WHERE id=:location_id AND kuliner_id=:kuliner_id LIMIT 1',
                Phalcon\\Db::FETCH_ASSOC,
                ['location_id' => $locationId, 'kuliner_id' => $id]
            );
            if (!$location) {
                $_SESSION['review_error'] = 'Tempat makan yang dipilih tidak sesuai dengan halaman kuliner ini.';
                return $this->response->redirect('kuliner/detail/' . $id . '#ulasan')->send();
            }
        } else {
            $locationCount = $this->db->fetchOne(
                'SELECT COUNT(*) AS total FROM lokasi_kuliner WHERE kuliner_id=:id',
                Phalcon\\Db::FETCH_ASSOC,
                ['id' => $id]
            );
            if ((int) $locationCount['total'] > 0) {
                $_SESSION['review_error'] = 'Pilih cabang atau tempat makan yang ingin kamu ulas.';
                return $this->response->redirect('kuliner/detail/' . $id . '#ulasan')->send();
            }
        }

        $uid = (int) $_SESSION['user_id'];
        $locationValue = $location ? $locationId : null;
        $existing = $this->db->fetchOne(
            'SELECT id FROM reviews WHERE kuliner_id=:kid AND user_id=:uid AND lokasi_id <=> :lid LIMIT 1',
            Phalcon\\Db::FETCH_ASSOC,
            ['kid' => $id, 'uid' => $uid, 'lid' => $locationValue]
        );

        if ($existing) {
            $this->db->execute(
                'UPDATE reviews SET rating=:rating, komentar=:komentar, nama_pengunjung=:nama WHERE id=:id',
                ['rating' => $rating, 'komentar' => $comment, 'nama' => $_SESSION['user_name'], 'id' => $existing['id']]
            );
        } else {
            $this->db->execute(
                'INSERT INTO reviews (kuliner_id,lokasi_id,user_id,nama_pengunjung,rating,komentar) VALUES (:kid,:lid,:uid,:nama,:rating,:komentar)',
                ['kid' => $id, 'lid' => $locationValue, 'uid' => $uid, 'nama' => $_SESSION['user_name'], 'rating' => $rating, 'komentar' => $comment]
            );
        }

        $_SESSION['review_success'] = 'Review kamu berhasil disimpan untuk tempat yang dipilih.';
        return $this->response->redirect('kuliner/detail/' . $id . '#ulasan')->send();
    }
}