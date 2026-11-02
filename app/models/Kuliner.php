
<?php

use Phalcon\Mvc\Model;
use Phalcon\Di\Di;
use Phalcon\Db\Enum;

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
        $di = Di::getDefault();
        $db = $di->getShared('db');

        $sql = "SELECT * FROM kuliner
                WHERE (:region_filter = '' OR daerah = :region_value)
                AND (:search_filter = '' OR nama LIKE :name_search OR deskripsi LIKE :description_search)
                ORDER BY unggulan DESC, nama ASC";

        return $db->fetchAll($sql, Enum::FETCH_ASSOC, [
            'region_filter' => $daerah,
            'region_value' => $daerah,
            'search_filter' => $q,
            'name_search' => '%' . $q . '%',
            'description_search' => '%' . $q . '%'
        ]);
    }

    public static function unggulan()
    {
        $db = Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT * FROM kuliner WHERE unggulan = 1 ORDER BY id LIMIT 4",
            Enum::FETCH_ASSOC
        );
    }

    public static function daerah()
    {
        $db = Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT DISTINCT daerah FROM kuliner ORDER BY daerah",
            Enum::FETCH_ASSOC
        );
    }

    public static function cerita()
    {
        $db = Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT * FROM cerita ORDER BY id LIMIT 3",
            Enum::FETCH_ASSOC
        );
    }
}
