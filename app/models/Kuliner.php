
<?php
use Phalcon\Mvc\Model;

class Kuliner extends Model
{
    private static $hasStatusColumn;

    public $id;
    public $nama;
    public $daerah;
    public $deskripsi;
    public $kategori;
    public $gambar;
    public $unggulan;

    public static function statusPublik($db, $alias = '')
    {
        if (self::$hasStatusColumn === null) {
            $column = $db->fetchOne(
                "SHOW COLUMNS FROM kuliner LIKE 'status'",
                \Phalcon\Db::FETCH_ASSOC
            );
            self::$hasStatusColumn = !empty($column);
        }

        return self::$hasStatusColumn ? $alias . "status = 'approved'" : '1 = 1';
    }

    private static function filterSql($db, $daerah, $q)
    {
        return " WHERE " . self::statusPublik($db) . "
                AND (:region_filter = '' OR daerah = :region_value)
                AND (:search_filter = '' OR nama LIKE :name_search OR deskripsi LIKE :description_search
                     OR daerah LIKE :region_search OR kategori LIKE :category_search)";
    }

    private static function filterParams($daerah, $q)
    {
        return [
            'region_filter' => $daerah,
            'region_value' => $daerah,
            'search_filter' => $q,
            'name_search' => '%' . $q . '%',
            'description_search' => '%' . $q . '%',
            'region_search' => '%' . $q . '%',
            'category_search' => '%' . $q . '%'
        ];
    }

    public static function semua($daerah = '', $q = '', $limit = 0, $offset = 0)
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        $sql = "SELECT * FROM kuliner" . self::filterSql($db, $daerah, $q) . " ORDER BY unggulan DESC, nama ASC";
        if ((int) $limit > 0) {
            $sql .= " LIMIT " . (int) $limit . " OFFSET " . max(0, (int) $offset);
        }

        return $db->fetchAll($sql, \Phalcon\Db::FETCH_OBJ, self::filterParams($daerah, $q));
    }

    public static function hitung($daerah = '', $q = '')
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        $row = $db->fetchOne(
            "SELECT COUNT(*) AS total FROM kuliner" . self::filterSql($db, $daerah, $q),
            \Phalcon\Db::FETCH_OBJ,
            self::filterParams($daerah, $q)
        );

        return $row ? (int) $row->total : 0;
    }

    public static function unggulan()
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT * FROM kuliner WHERE " . self::statusPublik($db) . " AND unggulan = 1 ORDER BY id LIMIT 4",
            \Phalcon\Db::FETCH_OBJ
        );
    }

    public static function daerah()
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT DISTINCT daerah FROM kuliner WHERE " . self::statusPublik($db) . " ORDER BY daerah",
            \Phalcon\Db::FETCH_OBJ
        );
    }

    public static function cerita()
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT * FROM cerita ORDER BY id LIMIT 3",
            \Phalcon\Db::FETCH_OBJ
        );
    }

    public static function cari($id)
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchOne(
            "SELECT * FROM kuliner WHERE id = :id AND " . self::statusPublik($db),
            \Phalcon\Db::FETCH_OBJ,
            ['id' => (int) $id]
        );
    }

    public static function lainnya($id, $limit = 3)
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            "SELECT * FROM kuliner WHERE id <> :id AND " . self::statusPublik($db) . " ORDER BY unggulan DESC, RAND() LIMIT " . (int) $limit,
            \Phalcon\Db::FETCH_OBJ,
            ['id' => (int) $id]
        );
    }
}
