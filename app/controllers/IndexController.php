<?php
class IndexController extends ControllerBase
{
    public function indexAction()
    {
        $this->view->active = 'home';
        $this->view->title = 'RasaNusantara — Cerita Kuliner Indonesia';
        $this->view->featured = Kuliner::unggulan();
        $this->view->regions = Kuliner::daerah();
        $this->view->stories = Kuliner::cerita();
    }
}
