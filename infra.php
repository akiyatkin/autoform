<?php
use infrajs\event\Event;
use infrajs\mail\Mail;

Event::handler('Autoform.onsubmit', function(&$ans){
	if(!empty($ans['orderid'])) return;
	$ans['orderid'] = 'id заказа';
	$ans['detail'] = 'данные заказы';
	$ans['sum'] = 999; //Цена к оплате; Если 0 - Ваша заявка принята
	$ans['sale'] = 2900; //Зачёркнутая цена

	//$ans['res'] - данные из Google Таблицы
	//$ans['form'] - заполненная форма
	//$ans['book'] - книга из config.book слоя
	//$ans['list'] - лист указанные в config.list

	//$subject = 'Новая заявка '.$ans['orderid'];
	//$from = 'noreplay@'.$_SERVER['HTTP_HOST'];
	//$body = Template::parse('-autoform/mail.tpl', $ans);
	//Mail::toAdmin($subject, $from, $body);
});