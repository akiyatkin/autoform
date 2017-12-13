<?php

use drakon5999\gdoc2article\GoogleDocs;
use infrajs\config\Config;
use infrajs\ans\Ans;
use infrajs\rest\Rest;
use infrajs\load\Load;

return Rest::get(function($name = false, $list = '', $range = 'A:Z'){
	$conf = Config::get('autoform');
	$ans = array();
	if (empty($conf['books'][$name])) return Ans::err($ans,'Необходимо зарегистрировать книгу и передать к ней ключ в адресе /-autoform/ключ');

	$id = $conf['books'][$name];
	if ($list) $list = "'".$list."'!";
	$res = GoogleDocs::getTable($id, $list.$range);
	$ans['res'] = $res;
	return Ans::ret($ans);

}, 'submit', function ($a, $name = false, $list = '', $range = 'A:Z') {
	$conf = Config::get('autoform');
	$ans = array();
	if (empty($conf['books'][$name])) return Ans::err($ans,'Необходимо зарегистрировать книгу и передать к ней ключ в адресе /-autoform/ключ');

	$id = $conf['books'][$name];
	if ($list) $list = "'".$list."'!";
	$res = GoogleDocs::getTable($id, $list.$range);

	$form = $_POST;
	$form['promo'] = trim($form['promo']);
	$ans['form'] = $form;

	foreach($res['data'] as $row) {
		if($row['Обязательно']) {
			if(!$form[$row['Поле']]) return Ans::err($ans,'Заполните все обязательные поля. За помощью можно обратиться по телефонам в <a href="/moroz/contacts">контактах</a>.');
		}
	}

	$orderid = $form['name'].' '.$form['phone'];
	if ($form['promo']) $orderid .= ' '.$form['promo'];
	
	$ans['orderid'] = $orderid;

	$ans['detail'] = Load::json_encode($form);
	//РАСЧЁТ ЦЕНЫ
	$sum = (int) preg_replace("/\D/",'',$res['descr']['Базовая цена']);
	if ($form['promo']) {
		if ($form['promo'] == $res['descr']['Купон для скидки']) {
			$ans['sale'] = $sum;
			$sum = (int) preg_replace("/\D/",'',$res['descr']['Цена со скидкой']);
		} else if(strstr($form['promo'], $res['descr']['Биглион'])) {
			$ans['biglion'] = true;
			$sum = 0;
		} else if($form['promo'] == 'itlife') {
			$ans['sale'] = $sum;
			$sum = 3;
		}
	}
	$days = explode(';', $res['descr']['Дни наценки']);
	$time = strtotime($form['datetime']);
	$day = date('j', $time); //Время заявки
	if (in_array($day, $days)) {
		$ans['holiday'] = true;
		$k = (1 + preg_replace("/\D/",'',$res['descr']['Размер наценки'])/100);
		$sum = $sum * $k;
		if(!empty($ans['sale'])) {
			$ans['sale'] = $ans['sale'] * $k;
		}
	}
	$ans['sum'] = $sum;

	file_put_contents('data/.autoform/'.$orderid.'.json', Load::json_encode($ans));
	return Ans::ret($ans);
});