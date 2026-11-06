<?php
define('APP_PATH', dirname(__DIR__) . '/app');
use Phalcon\\Config\\Adapter\\Ini as ConfigIni;
use Phalcon\\Loader;
use Phalcon\\Mvc\\Application;
use Phalcon\\Mvc\\Router;
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
    '/daftar-seller' => ['auth','register'], '/login-seller' => ['auth','login'],
    '/logout' => ['auth','logout'],
    '/seller' => ['seller','index'], '/seller/' => ['seller','index'],
    '/seller/profil' => ['seller','profile'],
    '/seller/tambah' => ['seller','create'],
    '/seller/edit/{id:[0-9]+}' => ['seller','edit'],
    '/seller/hapus/{id:[0-9]+}' => ['seller','delete']
];
foreach ($routes as $pattern => $target) {
    $router->add($pattern, ['controller' => $target[0], 'action' => $target[1]]);
}
$router->notFound(['controller' => 'index', 'action' => 'index']);
$di->setShared('router', $router);
$application = new Application($di);
$response = $application->handle(isset($_GET['_url']) ? $_GET['_url'] : '/');
echo $response->getContent();
