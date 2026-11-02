
<?php
use Phalcon\Mvc\Model;

class Kuliner extends Model
{
    public $id;
    public $nama;
    public $daerah;
    public $deskripsi;
    public $kategori;
    public $gambar;
    public $unggulan;

    public static function semua($daerah = '', $q = '')
    {
        $di = \Phalcon\Di::getDefault();
        $db = $di->getShared('db');

        $sql = "SELECT * FROM kuliner
                WHERE (:region_filter = '' OR daerah = :region_value)
                AND (:search_filter = '' OR nama LIKE :name_search OR deskripsi LIKE :description_search)
                ORDER BY unggulan DESC, nama ASC";

        return $db->fetchAll($sql, \Phalcon\Db::FETCH_ASSOC, [
            'region_filter' => $daerah,
            'region_value' => $daerah,
            'search_filter' => $q,
            'name_search' => '%' . $q . '%',
            'description_search' => '%' . $q . '%'
        ]);
    }

    public static function unggulan()
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT * FROM kuliner WHERE unggulan = 1 ORDER BY id LIMIT 4",
            \Phalcon\Db::FETCH_ASSOC
        );
    }

    public static function daerah()
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT DISTINCT daerah FROM kuliner ORDER BY daerah",
            \Phalcon\Db::FETCH_ASSOC
        );
    }

    public static function cerita()
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT * FROM cerita ORDER BY id LIMIT 3",
            \Phalcon\Db::FETCH_ASSOC
        );
    }
}
