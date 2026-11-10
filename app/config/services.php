<?php
use Phalcon\Di\FactoryDefault;
use Phalcon\Mvc\View;
use Phalcon\Mvc\Url;
use Phalcon\Db\Adapter\Pdo\Mysql as DbAdapter;
use Phalcon\Mvc\View\Engine\Volt;

$di = new FactoryDefault();

$di->setShared('config', $config);

$di->setShared('view', function () use ($config) {
    $view = new View();
    $view->setViewsDir(APP_PATH . '/views/');
    $view->registerEngines([
        '.volt' => function ($view, $di = null) {
            $di = $di ?: $view->getDI();
            $volt = new Volt($view, $di);
            $options = class_exists(\Phalcon\Autoload\Loader::class)
                ? ['path' => APP_PATH . '/../cache/', 'separator' => '_', 'compileAlways' => true]
                : ['compiledPath' => APP_PATH . '/../cache/', 'compiledSeparator' => '_', 'compileAlways' => true];
            $volt->setOptions($options);
            return $volt;
        }
    ]);
    return $view;
});

$di->setShared('db', function () use ($config) {
    return new DbAdapter([
        'host'     => $config->database->host,
        'port'     => $config->database->port,
        'username' => $config->database->username,
        'password' => $config->database->password,
        'dbname'   => $config->database->dbname,
        'charset'  => $config->database->charset
    ]);
});

$di->setShared('url', function () use ($config) {
    $url = new Url();
    $url->setBaseUri($config->application->baseUri);
    return $url;
});
