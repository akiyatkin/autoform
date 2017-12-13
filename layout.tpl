{root:}

{config.ans.result?:showans?:form}


{form:}
	{config.ans:ans.msg}
	<form class="autoform" action="/-autoform/submit/{config.book}/{config.list}">
		{data.res.data::input}
		<!--<span class="prev btn btn-default">Назад</span>-->
		<span class="next btn btn-success">Продолжить</span>
	</form>

	<script>
		domready( function () {
			var div = $('.autoform');
			var form = div;
			var counter = Session.get('autoform.counter', 1);
			for (var i = 0; i < counter; i++) {
				div.find('.form-group:hidden:first').show();
			}
			form.submit(function(){
				Ascroll.go('#PAGE');
			});
			var check = function(){
				var rows = div.find('.form-group').filter(':not(:animated)');
				var anim = !!div.find('.form-group:animated').length;
				if (rows.filter(':hidden').length > 0) {
					div.find('.next').show();
				} else {
					div.find('.next').hide();
				}

				if (rows.filter(':visible').length > 1 || anim) {
					div.find('.prev').show();
				} else {
					div.find('.prev').hide();
				}
			}
			check();
			div.find('.next').click( function () {
				Session.set('autoform.counter', ++counter);
				div.find('.form-group:hidden:first').slideDown('slow', check);
				check();
			});
			div.find('.prev').click(function(){
				Session.set('autoform.counter', --counter);
				div.find('.form-group:visible:last').slideUp('slow', check);
				check();
			});
		});
	</script>
{ans::}-ans/ans.tpl
{input:}
	{:input-{Тип}}
	{mark:}<span style="color:red">*</span>
{input-text:}
	<div class="form-group">
		<label for="input{Поле}">{Вопрос} {Обязательно?:mark}</label>
		<div class="row">
			<div class="col-sm-6">
			
				<input type="text" name="{Поле}" type="text" id="input{Поле}" placeholder="{Пример}" class="form-control">
			</div>
			<div class="col-sm-6">
				{Подсказка:help}
			</div>
		</div>
	</div>
	{help:}<span class="a" onclick="$(this).next().slideToggle('slow')">Помощь</span><div style="display:none">{.}</div>
{input-textarea:}
	<div class="form-group">
		<label for="input{Поле}">{Вопрос} {Обязательно?:mark}</label>
		<div class="row">
			<div class="col-sm-6">
			
				<textarea rows="3" name="{Поле}" id="input{Поле}" class="form-control"></textarea>
			</div>
			<div class="col-sm-6">
				{Подсказка:help}
			</div>
		</div>
	</div>
{input-datetime:}
    <div class="form-group">
    	<label for="input{Поле}">{Вопрос} {Обязательно?:mark}</label>
        <div class='input-group date' id='input{Поле}'>
            <input placeholder="{Пример}" name="{Поле}" type="text" class="form-control" />
            <span class="input-group-addon">
                <span class="glyphicon glyphicon-calendar"></span>
            </span>
        </div>
    </div>
	        
    <script type="text/javascript">
        domready( function () {
        	$(function () {
        		var val = Session.get('autoform.datetime',null);
        		setTimeout(function(){
        			$('#input{Поле}').datetimepicker({
	            		format: 'DD.MM.YYYY H:mm',
	            		stepping: 5, 
	            		minDate:moment("12/20/17"),
	            		maxDate:moment("01/20/18"),
	            		widgetPositioning:{
				            horizontal: 'auto',
				            vertical: 'bottom'
				         }
	            	});
        		},1);


            	/*.on("dp.change", function (e) {
            		$(this).val(e.date._i).change();
		        });*/
        	});
        });
    </script>
	    
{input-button:}
	<div class="form-group">
		<div class="input-group">
			<button class="btn btn-danger" name="{Поле}" id="input{Поле}">{Вопрос}</button>
		</div>
	</div>
{showans:}
	{config.ans.sum?config.ans:showanspay?config.ans:showansready}
	{showanspay:}
		<h2>Ваша заявка почти готова!</h2>
		<img src="/images/moroz/cards.png" class="right">
		<p>Осталось оплатить с помощью карты VISA или MasterCard</p>
		{sale?:strokecost?:basecost}
		{config.ans:payform}
		{basecost:}
			<p><b>Стоимость <big style="color:red">{sum}&nbsp;руб.</big></b></p>
		{strokecost:}
			<p><b>Стоимость <s style="color:gray">{sale}&nbsp;руб.</s> 
			<big style="color:red">{sum}&nbsp;руб.</big></b></p>
	{showansready:}
		<h2>Ваша заявка принята!</h2>
		<p>Номер заявки: <b>{orderid}</b></p>
		{data.res.descr.Готово}
		<p>
			<input class="btn btn-default" type="button" value="Назад" onclick="delete Controller.find('id','{id}').config.ans;  Controller.check();">
		</p>
{payform:}
<p>
	<form data-onsubmit="false" action="https://money.yandex.ru/eshop.xml" method="post" target="_blank">
	    <input required name="shopId" value="{~conf.autoform.ykassa.shopid}" type="hidden"/>
	    <input required name="scid" value="{~conf.autoform.ykassa.scid}" type="hidden"/>
	    <input required name="sum" id="ysum" value="{sum}" type="hidden">
	    <textarea name="orderDetails" style="display:none">{detail}</textarea>
	    <input type="hidden" required value="{orderid}" name="customerNumber" id="yphone"/>

		<input class="btn btn-default" type="button" value="Назад" onclick=" delete Controller.find('id','{id}').config.ans;  Controller.check();">
	    <input class="btn btn-success" type="submit" value="Перейти к оплате">
	</form>
</p>