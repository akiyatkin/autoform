<?php

use drakon5999\gdoc2article\GoogleDocs;
use infrajs\config\Config;
use infrajs\ans\Ans;
use infrajs\rest\Rest;


return Rest::get(function($name = false, $list = '', $range = 'A:Z'){
	$conf = Config::get('autoform');
	$ans = array();
	if (empty($conf['books'][$name])) return Ans::err($ans,'Необходимо зарегистрировать книгу и передать к ней ключ в адресе /-autoform/ключ');
	$id = $conf['books'][$name];
	if ($list) $list = "'".$list."'!";
	$data = GoogleDocs::getTable($id, $list.$range);
	$ans['res'] = $data;
	return Ans::ret($ans);
},'submit', function () {
	$ans = array();
	Ans::ret($ans,'Проверка');
});