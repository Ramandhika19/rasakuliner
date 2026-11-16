<?php
/**
 * Lokasi tempat menikmati sebuah kuliner (tabel lokasi_kuliner).
 * Koordinat disimpan sebagai latitude & longitude.
 */
class LokasiKuliner
{
    private static function select()
    {
        return "SELECT l.id, l.kuliner_id, l.nama_tempat, l.alamat, l.kota, l.latitude, l.longitude,
                       l.jam_buka, l.kisaran_harga, l.telepon,
                       l.sumber_data, l.seller_user_id,
                       k.nama AS kuliner, k.kategori, k.daerah, k.gambar
                FROM lokasi_kuliner l
                JOIN kuliner k ON k.id = l.kuliner_id";
    }

    /** Semua lokasi dari kuliner yang tampil ke publik. */
    public static function semua()
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            self::select() . " WHERE " . Kuliner::statusPublik($db, 'k.') . " ORDER BY l.id",
            \Phalcon\Db::FETCH_OBJ
        );
    }

    /** Semua lokasi untuk satu kuliner. */
    public static function untukKuliner($kulinerId)
    {
        $db = \Phalcon\Di::getDefault()->getShared('db');

        return $db->fetchAll(
            self::select() . " WHERE l.kuliner_id = :id AND " . Kuliner::statusPublik($db, 'k.') . " ORDER BY l.id",
            \Phalcon\Db::FETCH_OBJ,
            ['id' => (int) $kulinerId]
        );
    }

    /** Ubah baris DB menjadi array siap-JSON untuk peta. */
    public static function keArray($rows)
    {
        $out = [];
        foreach ($rows as $r) {
            $out[] = [
                'id'        => (int) $r->id,
                'kuliner_id'=> (int) $r->kuliner_id,
                'tempat'    => $r->nama_tempat,
                'kuliner'   => $r->kuliner,
                'kategori'  => $r->kategori,
                'daerah'    => $r->daerah,
                'alamat'    => $r->alamat,
                'kota'      => $r->kota,
                'lat'       => $r->latitude !== null ? (float) $r->latitude : null,
                'lng'       => $r->longitude !== null ? (float) $r->longitude : null,
                'jam'       => $r->jam_buka,
                'harga'     => $r->kisaran_harga,
                'telepon'   => $r->telepon,
                'sumber_data' => isset($r->sumber_data) ? $r->sumber_data : 'database',
                'seller_user_id' => isset($r->seller_user_id) ? (int) $r->seller_user_id : null,
                'gambar'    => $r->gambar,
            ];
        }
        return $out;
    }

    public static function json($data)
    {
        return json_encode($data, JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT);
    }
}
