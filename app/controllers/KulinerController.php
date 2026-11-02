<?php
class KulinerController extends ControllerBase
{
    public function indexAction()
    {
        $this->view->active = 'kuliner';
        $this->view->title = 'Jelajahi Kuliner — RasaNusantara';
        $this->view->selectedRegion = $this->request->getQuery('daerah', 'trim', '');
        $this->view->search = $this->request->getQuery('q', 'string', '');
        $this->view->kuliner = Kuliner::semua(
            $this->view->selectedRegion,
            $this->view->search
        );
        $this->view->regions = Kuliner::daerah();
    }
}
