<?php
class ReviewController extends ControllerBase
{
    public function createAction()
    {
        $id=(int)$this->dispatcher->getParam('id');
        if (empty($_SESSION['user_id']) || empty($_SESSION['user_role']) || $_SESSION['user_role'] !== 'user') {
            return $this->response->redirect('login-user')->send();
        }
        $food=$this->db->fetchOne("SELECT id FROM kuliner WHERE id=:id AND status='approved' LIMIT 1", Phalcon\Db::FETCH_ASSOC, ['id'=>$id]);
        if (!$food) return $this->response->redirect('kuliner')->send();
        if (!$this->request->isPost()) return $this->response->redirect('kuliner/detail/'.$id)->send();
        $rating=(int)$this->request->getPost('rating');
        $comment=trim((string)$this->request->getPost('komentar'));
        if ($rating<1 || $rating>5 || $comment==='') {
            $_SESSION['review_error']='Pilih rating 1–5 dan tulis ulasan terlebih dahulu.';
            return $this->response->redirect('kuliner/detail/'.$id)->send();
        }
        $uid=(int)$_SESSION['user_id'];
        $existing=$this->db->fetchOne('SELECT id FROM reviews WHERE kuliner_id=:kid AND user_id=:uid LIMIT 1', Phalcon\Db::FETCH_ASSOC, ['kid'=>$id,'uid'=>$uid]);
        if ($existing) {
            $this->db->execute('UPDATE reviews SET rating=:rating, komentar=:komentar, nama_pengunjung=:nama WHERE id=:id', ['rating'=>$rating,'komentar'=>$comment,'nama'=>$_SESSION['user_name'],'id'=>$existing['id']]);
        } else {
            $this->db->execute('INSERT INTO reviews (kuliner_id,user_id,nama_pengunjung,rating,komentar) VALUES (:kid,:uid,:nama,:rating,:komentar)', ['kid'=>$id,'uid'=>$uid,'nama'=>$_SESSION['user_name'],'rating'=>$rating,'komentar'=>$comment]);
        }
        $_SESSION['review_success']='Review kamu berhasil disimpan.';
        return $this->response->redirect('kuliner/detail/'.$id)->send();
    }
}