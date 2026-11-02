
<?php
define('APP_PATH', dirname(__DIR__) . '/app');

use Phalcon\Config\Adapter\Ini as ConfigIni;
use Phalcon\Autoload\Loader;
use Phalcon\Mvc\Application;
use Phalcon\Mvc\Router;

$config = new ConfigIni(APP_PATH . '/config/config.ini');

$loader = new Loader();
$loader->setDirectories([
    APP_PATH . '/controllers/',
    APP_PATH . '/models/',
    APP_PATH . '/library/'
])->register();

require APP_PATH . '/config/services.php';

$router = new Router(false);

$router->add('/', [
    'controller' => 'index',
    'action' => 'index'
]);

$router->add('/kuliner', [
    'controller' => 'kuliner',
    'action' => 'index'
]);

$router->add('/kuliner/', [
    'controller' => 'kuliner',
    'action' => 'index'
]);

$router->notFound([
    'controller' => 'index',
    'action' => 'index'
]);

$di->setShared('router', $router);

$application = new Application($di);

$response = $application->handle(
    isset($_GET['_url']) ? $_GET['_url'] : '/'
);

echo $response->getContent();
