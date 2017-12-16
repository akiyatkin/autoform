<?php

use drakon5999\gdoc2article\GoogleDocs;
use infrajs\config\Config;
use infrajs\ans\Ans;
use infrajs\rest\Rest;
use infrajs\load\Load;
use infrajs\path\Path;
use infrajs\event\Event;

Event::$classes['Autoform'] = function($ans){
	return $ans['book'].'-'.$ans['list'];
};
return Rest::get(function($name = false, $list = '', $range = 'A:Z'){
	$conf = Config::get('autoform');
	$ans = array();
	if (empty($conf['books'][$name])) return Ans::err($ans,'Необходимо зарегистрировать книгу и передать к ней ключ в адресе /-autoform/ключ');

	$book = $conf['books'][$name];
	if ($list) $list = "'".$list."'!";
	$res = GoogleDocs::getTable($book, $list.$range);
	$ans['res'] = $res;
	return Ans::ret($ans);

}, 'submit', function ($a, $name = false, $list = '', $range = 'A:Z') {
	$conf = Config::get('autoform');
	$ans = array();
	if (empty($conf['books'][$name])) return Ans::err($ans,'Необходимо зарегистрировать книгу и передать к ней ключ в адресе /-autoform/ключ');

	$book = $conf['books'][$name];

	$ans['book'] = $book;
	$ans['list'] = $list;

	if ($list) $list = "'".$list."'!";
	$res = GoogleDocs::getTable($book, $list.$range);

	$form = $_POST;
	foreach ($form as $k=>$v) $form[$k] = trim($form[$k]);
	
	$ans['form'] = $form;

	foreach($res['data'] as $row) {
		if($row['Обязательно']) {
			if(!$form[$row['Поле']]) return Ans::err($ans,'Заполните все обязательные поля.');
		}
	}

	$ans['res'] = $res;

	Event::fire('Autoform.onsubmit', $ans); //Должен быть добавлено свойство orderid

	unset($ans['res']);

	if (!isset($ans['result'])) $ans['result'] = true;

	$dirname = $ans['book'].'-'.$ans['list'];
	Path::mkdir('data/.autoform/'.$dirname);
	file_put_contents('data/.autoform/'.$dirname.'/'.$ans['orderid'].'.json', Load::json_encode($ans));
	return Ans::ans($ans);
});