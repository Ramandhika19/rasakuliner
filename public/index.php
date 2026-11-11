<?php
define('APP_PATH', dirname(__DIR__) . '/app');
use Phalcon\Config\Adapter\Ini as ConfigIni;
use Phalcon\Loader;
use Phalcon\Mvc\Application;
use Phalcon\Mvc\Router;
$config = new ConfigIni(APP_PATH . '/config/config.ini');
$loader = new Loader();
$loader->registerDirs([APP_PATH . '/controllers/', APP_PATH . '/models/', APP_PATH . '/library/'])->register();
require APP_PATH . '/config/services.php';
$router = new Router(false);
$routes = [
    '/' => ['index','index'],
    '/kuliner' => ['kuliner','index'], '/kuliner/' => ['kuliner','index'],
    '/kuliner/detail/{id:[0-9]+}' => ['kuliner','detail'],
    '/peta' => ['peta','index'], '/peta/' => ['peta','index'],
    '/cerita' => ['cerita','index'], '/cerita/' => ['cerita','index'],
    '/cerita/{slug:[a-z0-9-]+}' => ['cerita','detail'],
    '/daftar-seller' => ['auth','register'], '/login-seller' => ['auth','login'],
    '/daftar-user' => ['auth','registerUser'], '/login-user' => ['auth','loginUser'],
    '/review/{id:[0-9]+}' => ['review','create'],
    '/logout' => ['auth','logout'],
    '/admin/seller' => ['admin','sellers'], '/admin/seller/' => ['admin','sellers'],
    '/admin/kuliner' => ['admin','foods'], '/admin/kuliner/' => ['admin','foods'],
    '/admin/seller/email/approve/{token:[a-f0-9]{64}}' => ['admin','emailApprove'],
    '/admin/seller/email/reject/{token:[a-f0-9]{64}}' => ['admin','emailReject'],
    '/seller' => ['seller','index'], '/seller/' => ['seller','index'],
    '/seller/profil' => ['seller','profile'],
    '/seller/tambah' => ['seller','create'],
    '/seller/edit/{id:[0-9]+}' => ['seller','edit'],
    '/seller/hapus/{id:[0-9]+}' => ['seller','delete']
];
foreach ($routes as $pattern => $target) {
    $router->add($pattern, ['controller' => $target[0], 'action' => $target[1]] + (isset($target[2]) ? ['decision' => $target[2]] : []));
}
$router->notFound(['controller' => 'index', 'action' => 'index']);
$di->setShared('router', $router);
$application = new Application($di);
$response = $application->handle(isset($_GET['_url']) ? $_GET['_url'] : '/');
echo $response->getContent();
