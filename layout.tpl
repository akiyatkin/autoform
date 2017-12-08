<form class="autoform" action="/-autoform/submit">
	{data.res.data::input}
	<div>
		{config.ans::ans.msg}
	</div>
	<span class="next btn btn-success">Продолжить</span>
</form>
<script>
	domready( function () {
		var div = $('.autoform');
		var counter = Session.get('autoform.counter',1);
		var next = function () {
			div.find('.form-group:hidden:first').slideDown('slow');
		}
		for (var i = 0; i < counter; i++) {
			div.find('.form-group:hidden:first').show();
		}		
		div.find('.next').click(function(){
			Session.set('autoform.counter',++counter);
			next();
		})
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
{input-date:}
    <div class="form-group">
    	<label for="input{Поле}">{Вопрос}</label>
        <div class='input-group date' id='input{Поле}'>
            <input name="{Поле}" type="text" class="form-control" />
            placeholder="{Пример}" 
            <span class="input-group-addon">
                <span class="glyphicon glyphicon-calendar"></span>
            </span>
        </div>
    </div>
	        
    <script type="text/javascript">
        domready( function () {
        	$(function () {
            	$('#input{Поле}').datetimepicker();
        	});
        });
    </script>
	    
{input-button:}
	<div class="form-group">
		<button class="btn btn-success" name="{Поле}" id="input{Поле}">{Вопрос}</button>
	</div>
	
