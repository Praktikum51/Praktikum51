
&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)

	Стр = Элементы.Товары.ТекущиеДанные;
	Стр.Сумма = Стр.Количество * Стр.Цена;
	Объект.СуммаДокумента=Объект.Товары.Итог("Сумма");

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЦенуНоменклатуры(Номенклатура)
	
	Возврат Номенклатура.ЦенаПокупки;

КонецФункции

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	Стр = Элементы.Товары.ТекущиеДанные;
	Стр.Цена=ПолучитьЦенуНоменклатуры(Стр.Номенклатура);
	КоличествоПриИзменении(Элемент);
	
КонецПроцедуры


&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ТекущийЭлемент = Элементы.Склад;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	МассивПроверяемыхТоваров = Новый Массив;
	Для каждого ТекСтр Из Объект.Товары Цикл
	    МассивПроверяемыхТоваров.Добавить(ТекСтр.Номенклатура);
	КонецЦикла; 
	
	МассивНайденыхУслуг = ПолучитьМассивУслугВТабличнойЧастиТовары(МассивПроверяемыхТоваров);
	Если МассивНайденыхУслуг.Количество()<>0 Тогда
			Сообщить("В табличной части товары найдены услуги. Документ не может быть записан!");
			Для каждого НазваниеУслуги Из МассивНайденыхУслуг Цикл
			  Сообщить(НазваниеУслуги + " является услугой.");
			КонецЦикла; 
		    Отказ = Истина;
	КонецЕсли; 
КонецПроцедуры



&НаСервереБезКонтекста
Функция ПолучитьМассивУслугВТабличнойЧастиТовары(МассивПроверяемыхТоваров)

	МассивВозвращаемыхУслуг = Новый Массив;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Наименование
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка В(&МассивТоваров)
		|	И Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.Услуга)";

	Запрос.УстановитьПараметр("МассивТоваров", МассивПроверяемыхТоваров);
	
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивВозвращаемыхУслуг.Добавить(ВыборкаДетальныеЗаписи.Наименование);
	КонецЦикла;

    возврат МассивВозвращаемыхУслуг;
КонецФункции // ()
 