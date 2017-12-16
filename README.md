# Форма сгенерированная по данным в Google Sheets

Пример формы: [lab-iq.ru/moroz/order](http://lab-iq.ru/moroz/order)

## Установка через composer
``` 
{
	"require":{
		"akiyatkin/autoform": "~1"
	}
}
```

## Запуск
1. Нужно настроить учётную запись в [Google API](https://console.developers.google.com) подробно об этом рассказано в зависимости расширении [drakon5999/gdoc2article](https://github.com/Drakon5999/gdoc2article).
1. Указать id таблицы в конфиге .infra.json в свойстве. 
```
{
	"autoform":{
		"books":{
			"mytable":"10juUX6E4WE0iJj087Nh326-oW8-Nuzowg28A6NO4V0E"
		}
	}
}
```
Данные таблицы станут доступны через REST-сервис /-autofrom/mytable/listname
1. Для построения формы нужно подключить готовый слой с помощью [infrajs/controller](https://github.com/infrajs/controller)
```
{
	"external":"-autoform/layer.json",
	"config":{
		"book":"mytable",
		"list":"Лист 1"
	}
}
```
1. В таблице данных должны быть определёные колонки значения, которых будет обработаны и сгененирована форма. 

## Данные для генерации формы
1. **Вопрос** - название поля
1. **Подсказка** - несколько предложения доплонительного описания
1. **Обязательно** - да или пустая строка, что бы заполнение поля считалось обязательным

## Обработка формы
Пример приведён в файле infra.php. Нужно подписаться на событие ```Autofrom.onsubmit``` и сформировать нужные данные для оплаты на основе данных из формы. Для Яндекс Кассы с интеграцией по Email в конфиге ```.infra.json``` нужно указать ```shopid``` и ```scid```.