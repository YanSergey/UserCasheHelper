#Использовать gui
#Использовать parserFileV8i
//#Использовать ".."

Перем Форма;
Перем УправляемыйИнтерфейс;

Процедура ВывестиИнформацию(СписокБаз)
	Для каждого База Из СписокБаз Цикл
		СтруктураАдреса = База.Значение;

		Сообщить(СтруктураАдреса.Name);
		Для каждого Часть Из СтруктураАдреса Цикл
			Сообщить("	" + Часть.Ключ + " = " + Часть.Значение);
			Если Часть.Ключ = "Connect" Тогда
				Сообщить("		" + Часть.Ключ + " = " +  Часть.Значение.String);
				Для каждого ЧастьПути Из Часть.Значение.Structure Цикл
					Сообщить("		" + ЧастьПути.Ключ + " = " +  ЧастьПути.Значение);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры


//# Обработка события первого открытия формы
Процедура ПриОткрытииФормы() Экспорт
	ЭлементыФормы 		= Форма.Элементы;
	ВидыПоляФормы 		= Форма.ВидПоляФормы;
	ПоложениеЗаголовка 	= Форма.ПоложениеЗаголовка;
	ВидГруппыФормы 		= Форма.ВидГруппыФормы;

	//Кнопка "Перечитать базы"
	//Кнопка "Очистить ВЕСЬ кэш"
	//Кнопка "Очистить БАЛЛАСТНЫЙ кэш" - кэш уже не существующих баз
	//Кнопка "Проставить имена баз в родительском каталоге"
	//Кнопка "Открыть родительский каталог"

	ПровайдерТЗ = Новый Провайдер;
	ПровайдерТЗ.Источник = ПолучитьТЗ();

	Поле1 = Форма.Элементы.Добавить("ТаблицаИБ", "ПредставлениеСписка", Неопределено);
    Поле1.Представление = Поле1.ВидыПредставлений.Таблица;
	Поле1.ПутьКДанным = ПровайдерТЗ;
	Поле1.Заголовок = "Список ИБ";
	Поле1.ПоложениеЗаголовка = УправляемыйИнтерфейс.ПоложениеЗаголовка.Верх;
	//Поле1.Закрепление = 5;
 	//Поле1.Ширина = 200;
 


	Возврат;
	КоллекцияИБ = ПолучитьСписокБаз();

	Для каждого База Из КоллекцияИБ Цикл
		СтруктураАдреса = База.Значение;

		Если СтруктураАдреса.OrderInList = "-1" Тогда
			Продолжить;
		КонецЕсли;	

		//Имя базы
		ИД = СтруктураАдреса.ID;
		ИмяИБ = СтруктураАдреса.Name;
		ГруппаБазы = ЭлементыФормы.Добавить("ГруппаБазы"+ИД, "ПолеФормы", Неопределено);
		//ГруппаБазы = ЭлементыФормы.Добавить("ГруппаБазы"+ИмяИБ, "ГруппаФормы", Неопределено);
		//ГруппаБазы.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаБазы.Вид = ВидыПоляФормы.ПолеНадписи;
		ГруппаБазы.Заголовок = ИмяИБ;

		//Строка соединения
		АдресБазы = СтрЗаменить(СтруктураАдреса.Connect.String, "Connect=", "");
		//СтрокаСоединения = ЭлементыФормы.Добавить("СтрокаСоединения"+ИД, "ПолеФормы", Неопределено);
		//СтрокаСоединения.Вид = ВидыПоляФормы.ПолеНадписи;
		//СтрокаСоединения.Заголовок = АдресБазы;
		
		//ID
		//ИдБазы = ЭлементыФормы.Добавить("ИдБазы"+ИД, "ПолеФормы", Неопределено);
		//ИдБазы.Вид = ВидыПоляФормы.ПолеНадписи;
		//ИдБазы.Заголовок = СтруктураАдреса.ID;
		
		ОбщаяСтрока = ЭлементыФормы.Добавить("Строка"+ИД, "ПолеФормы", Неопределено);
		ОбщаяСтрока.Вид = ВидыПоляФормы.ПолеНадписи;
		ОбщаяСтрока.Заголовок = "Строка соединения = " + АдресБазы + "ID = " + ИД;
		

		//Размер кэша
		//Кнопка открытия в проводнике
		//Кнопка очистки кэша
		
	КонецЦикла;
 	
КонецПроцедуры

Функция ПолучитьТЗ()
	КоллекцияИБ = ПолучитьСписокБаз();
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ИмяБазы",, "Имя базы", 30);
	ТЗ.Колонки.Добавить("СтрокаСоединения",, "Строка соединения", 50);
	ТЗ.Колонки.Добавить("ID",,, 36);
	

	Для каждого База Из КоллекцияИБ Цикл
		СтруктураАдреса = База.Значение;

		Если СтруктураАдреса.OrderInList = "-1" Тогда
			Продолжить;
		КонецЕсли;	

		ИД = СтруктураАдреса.ID;
		ИмяИБ = СтруктураАдреса.Name;
		АдресБазы = СтрЗаменить(СтруктураАдреса.Connect.String, "Connect=", "");

		СтрокаТЗ = ТЗ.Добавить();
		СтрокаТЗ.ИмяБазы = ИмяИБ;
		СтрокаТЗ.СтрокаСоединения = АдресБазы;
		СтрокаТЗ.ID = ИД;
			
	КонецЦикла;

	
	Возврат ТЗ;	
	
КонецФункции

Функция ПолучитьСписокБаз()
	Парсер = Новый ПарсерСпискаБаз;
	Сообщить("Вывод основного файла");
	Парсер.УстановитьФайл();
	СписокБаз = Парсер.ПолучитьСписокБаз();
	//ВывестиИнформацию(СписокБаз);	

	Возврат СписокБаз;
КонецФункции

УправляемыйИнтерфейс = Новый УправляемыйИнтерфейс();
Форма = УправляемыйИнтерфейс.СоздатьФорму();
Форма.Заголовок = "Помощник работы с кэшем баз 1С";
Форма.Высота = 600;
Форма.Ширина = 800;

//# Устанавливаем обработку события ПриОткрытии
Форма.УстановитьДействие(ЭтотОбъект, "ПриОткрытии", "ПриОткрытииФормы");
Форма.Показать();

