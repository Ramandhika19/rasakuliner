<?php
/**
 * Minimal SMTP client for PHP 7.2+ (Gmail SSL/465).
 * Credentials are read from app/config/config.ini and must never be committed.
 */
class SmtpMailer
{
    private $config;
    public function __construct($config) { $this->config = $config; }

    public function send($to, $subject, $html)
    {
        $cfg = $this->config;
        $host = isset($cfg->host) ? trim((string)$cfg->host) : '';
        $port = isset($cfg->port) ? (int)$cfg->port : 465;
        $username = isset($cfg->username) ? trim((string)$cfg->username) : '';
        $password = isset($cfg->password) ? (string)$cfg->password : '';
        $from = isset($cfg->from_email) ? trim((string)$cfg->from_email) : $username;
        $fromName = isset($cfg->from_name) ? trim((string)$cfg->from_name) : 'RasaKuliner';
        if ($host === '' || $username === '' || $password === '' || $from === '' || !filter_var($to, FILTER_VALIDATE_EMAIL)) {
            throw new Exception('Konfigurasi SMTP belum lengkap. Isi bagian [mailer] di app/config/config.ini.');
        }

        $remote = ($port === 465 ? 'ssl://' : 'tcp://') . $host . ':' . $port;
        $socket = @stream_socket_client($remote, $errno, $errstr, 15, STREAM_CLIENT_CONNECT);
        if (!$socket) throw new Exception('Tidak dapat terhubung ke SMTP: ' . $errstr);
        stream_set_timeout($socket, 15);

        try {
            $this->expect($socket, [220]);
            $this->command($socket, 'EHLO localhost', [250]);
            if ($port !== 465) $this->command($socket, 'STARTTLS', [220]);
            if ($port !== 465) {
                if (!stream_socket_enable_crypto($socket, true, STREAM_CRYPTO_METHOD_TLS_CLIENT)) {
                    throw new Exception('Koneksi TLS SMTP gagal.');
                }
                $this->command($socket, 'EHLO localhost', [250]);
            }
            $this->command($socket, 'AUTH LOGIN', [334]);
            $this->command($socket, base64_encode($username), [334]);
            $this->command($socket, base64_encode($password), [235]);
            $this->command($socket, 'MAIL FROM:<' . $from . '>', [250]);
            $this->command($socket, 'RCPT TO:<' . $to . '>', [250, 251]);
            $this->command($socket, 'DATA', [354]);

            $subjectHeader = '=?UTF-8?B?' . base64_encode($subject) . '?=';
            $headers = [
                'From: =?UTF-8?B?' . base64_encode($fromName) . '?= <' . $from . '>',
                'To: <' . $to . '>',
                'Subject: ' . $subjectHeader,
                'MIME-Version: 1.0',
                'Content-Type: text/html; charset=UTF-8',
                'Content-Transfer-Encoding: base64'
            ];
            $body = chunk_split(base64_encode($html));
            $message = implode("\r\n", $headers) . "\r\n\r\n" . $body;
            $message = preg_replace('/(^|\r\n)\./', '$1..', $message);
            fwrite($socket, $message . "\r\n.\r\n");
            $this->expect($socket, [250]);
            $this->command($socket, 'QUIT', [221]);
        } finally {
            fclose($socket);
        }
        return true;
    }

    private function command($socket, $command, $expected)
    {
        fwrite($socket, $command . "\r\n");
        $this->expect($socket, $expected);
    }

    private function expect($socket, $expected)
    {
        $response = '';
        do {
            $line = fgets($socket, 515);
            if ($line === false) throw new Exception('SMTP tidak memberikan respons.');
            $response .= $line;
        } while (isset($line[3]) && $line[3] === '-');
        $code = (int)substr($response, 0, 3);
        if (!in_array($code, $expected, true)) {
            throw new Exception('SMTP error (' . $code . '): ' . trim($response));
        }
        return $response;
    }
}
