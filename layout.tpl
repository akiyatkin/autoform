<form class="autoform" action="/-autoform/submit">
	{data.res.data::input}
	<span class="prev btn btn-default">Назад</span>
	<span class="next btn btn-success">Продолжить</span>
	
</form>
<script>
	domready( function () {
		var div = $('.autoform');
		var counter = Session.get('autoform.counter', 1);
		for (var i = 0; i < counter; i++) {
			div.find('.form-group:hidden:first').show();
		}
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
{input-text:}
	<div class="form-group">
		<label for="input{Поле}">{Вопрос}</label>
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
		<label for="input{Поле}">{Вопрос}</label>
		<textarea rows="3" name="{Поле}" id="input{Поле}" class="form-control"></textarea>
	</div>
{input-datetime:}
    <div class="form-group">
    	<label for="input{Поле}">{Вопрос}</label>
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
        	});
        });
    </script>
	    
{input-button:}
	<div class="form-group">
		<label for="input{Поле}">Стоимость <s style="color:gray">1900 руб.</s> <big style="color:red">690 руб.</big></label>
		<div class="input-group">
			<button class="btn btn-danger" name="{Поле}" id="input{Поле}">{Вопрос}</button>
		</div>
		<div>
			{config.ans:ans.msg}
		</div>
	</div>
	
	
