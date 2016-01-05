# Image Catalyst

Оптимизация / сжатие изображений PNG, JPEG и GIF без потери качества для Windows.

|![Adobe Photoshop](https://cloud.githubusercontent.com/assets/3890881/12113971/831d0e22-b3b7-11e5-8f6d-a5cc8f993767.png)|![Image Catalyst](https://cloud.githubusercontent.com/assets/3890881/12110952/70ce4462-b3a2-11e5-8b29-a3822b246dfe.png)|
|:----------|:----------|
|Adobe Photoshop CC 2015 (Экспортировать как) — 56,10 КБ|Image Catalyst (Xtreme) — 51,25 КБ|

##### Авторы — [Lorents](https://github.com/lorents17) & [Res2001](https://github.com/res2001)

### Инструменты

##### PNG:
- AdvDef ([AdvanceComp](https://github.com/amadvance/advancecomp) 1.20)
- DeflOpt 2.07
- [PNGWolfZopfli](https://github.com/jibsen/pngwolf-zopfli) 1.0.0
- [TruePNG](http://x128.ho.ua/pngutils.html) 0.6.1.8

##### JPEG:
- [JPEGinfo](http://rtfreesoft.blogspot.ru/2014/03/jpginfo.html) от 16.03.2014
- [JPEGstripper](http://rtfreesoft.blogspot.ru/2014/03/jpegstripper.html) от 16.03.2014
- JPEGTran ([MozJPEG](https://github.com/mozilla/mozjpeg) 3.1)

##### GIF:
- [GIFSicle](http://www.lcdf.org/gifsicle/) 1.88

##### Дополнительное ПО:
- DlgMsgBox от 29.02.2012

### Системные требования

Операционная система — Windows XP SP3 и выше.

### Параметры командной строки (cmd.exe)

```
call iCatalyst.bat [options] [add folders \ add files]

Options:

/png:#	Параметры оптимизации PNG (Non-Interlaced):
		1 - Уровень сжатия - Advanced
		2 - Уровень сжатия - Xtreme
		0 - пропустить оптимизацию

/jpg:#	Параметры оптимизации JPEG:
		1 - Encoding Process - Baseline
		2 - Encoding Process - Progressive
		3 - параметры оптимизации оригинального изображения
		0 - пропустить оптимизацию

/gif:#	Параметры оптимизации GIF:
		1 - параметры оптимизации по умолчанию
		0 - пропустить оптимизацию

"/outdir:#"	Параметры сохранения изображений:
			true  - открыть диалоговое окно для сохранения изображений
			false - заменить оригинальные изображения на оптимизированные
			"полный путь к папке" - папка сохранения изображений. Например: "/outdir:C:\temp",
			если папки назначения не существует, то она будет создана автоматически.

Add folders \ Add files
- Укажите полный путь к изображениям и\или к папкам с изображениями.
  Например: "C:\Images" "C:\logo.png".
- В полных путях изображений не должно быть специальных символов. 
  Например: &, %, (, ), ! и т.д.
- Приложение оптимизирует изображения во вложенных подпапках.

Примеры: 
call iCatalyst.bat /gif:1 "/outdir:C:\photos" "C:\images"
call iCatalyst.bat /png:2 /jpg:2 "/outdir:true" "C:\images"
```

### Drag and Drop

![Drag and Drop](https://cloud.githubusercontent.com/assets/3890881/7943598/28496fd4-096e-11e5-8df6-d6415e47caf8.png)

- В полных путях изображений не должно быть специальных символов. Например: `&`, `%`, `(`, `)`, `!` и т.д.
- Приложение оптимизирует изображения во вложенных подпапках.

### Параметры оптимизации PNG

![PNG](https://cloud.githubusercontent.com/assets/3890881/10802485/3504f4e4-7dce-11e5-85cf-a07fdb822c2b.PNG)

|Advanced|Xtreme|
|:-------|:----------|
|![Advanced](https://cloud.githubusercontent.com/assets/3890881/7943713/f816fd26-096e-11e5-8a8d-036e9fd443bf.png)|![Xtreme](https://cloud.githubusercontent.com/assets/3890881/12110960/92a49db6-b3a2-11e5-9953-adde90844087.png)|
|Размер — 55,57 КБ; Время оптимизации — 1,5 с|Размер — 54,67 КБ; Время оптимизации — 7,5 с|
|`TruePNG` + `Advdef`|`TruePNG` + `PNGWolfZopfli`|
|Степень сжатия на ~ 10% выше по сравнению с Adobe Photoshop CC 2014 (Save for Web)|Степень сжатия на ~ 2% выше по сравнению с режимом оптимизации Advanced, скорость сжатия ниже ~ 5 раз|

- `Skip` — пропускает оптимизацию изображений PNG.

##### Параметр "Чересстрочно":
- `Нет` — отображает изображение в браузере только после окончания загрузки.
- `Чересстрочно` — отображает версии изображения с низким разрешением в браузере по мере поступления данных во время загрузки файла. Использование этого параметра сокращает время загрузки, однако увеличивает размер файла (не поддерживается). 

### Параметры оптимизации JPEG

![JPEG](https://cloud.githubusercontent.com/assets/3890881/10802484/34d79cec-7dce-11e5-886f-ea71fdc93214.PNG)

|Baseline|Progressive|
|:-------|:----------|
|![Baseline](https://cloud.githubusercontent.com/assets/3890881/7943666/9c3c1324-096e-11e5-8cf1-bceade0ebd85.gif)|![Progressive](https://cloud.githubusercontent.com/assets/3890881/7943679/ace1271e-096e-11e5-9ca4-6f33f421ca52.gif)|
|Для изображений < 10 КБ, рекомендуется использовать — `Baseline` ([подробнее](http://webo.in/articles/habrahabr/73-jpeg-baseline-progressive/))|Для изображений > 10 КБ, рекомендуется использовать — `Progressive` ([подробнее](http://webo.in/articles/habrahabr/73-jpeg-baseline-progressive/))|

- `Default` — использует параметры оптимизации оригинального изображения;
- `skip` — пропускает оптимизацию изображений JPEG.

### Параметры оптимизации GIF

![GIF](https://cloud.githubusercontent.com/assets/3890881/10802483/34d638a2-7dce-11e5-9b95-e39aa476c73d.PNG)

- `Default` — использует параметры оптимизации по умолчанию;
- `Skip` — пропускает оптимизацию изображений GIF.

### Config.ini

Откройте файл `Tools\config.ini` любым текстовым редактором и следуйте инструкции.

```
[options]
;Количество потоков.
;Если указано значение 0, то выбирается значение равное системной переменной %NUMBER_OF_PROCESSORS%.
thread=0

;Параметры сохранения изображений:
;true  - открыть диалоговое окно для сохранения изображений;
;false - заменить оригинальные изображения на оптимизированные;
;path  - путь к папке для сохранения исходящих изображений.
outdir=false

;Проверить обновление.
update=true

[PNG]
;Параметры оптимизации PNG:
;/a# - PNG dirty transparency 0=Clean, 1=Optimize;
;/g# - PNG gamma 0=Remove, 1=Apply & Remove, 2=Keep;
;/na - PNG don't change RGB values for fully transparent pixels;
;/nc - PNG don't change ColorType and BitDepth;
;/np - PNG don't change Palette.
xtreme=/a1 /g0
advanced=/a0 /g0

;Удалить метаданные (chunks).
pngtags=true

[JPEG]
;Удалить метаданные.
jpegtags=true

[GIF]
;Удалить метаданные.
giftags=true
```

### Дополнительно
- Поставить оптимизацию изображений на паузу. Для этого в окне командной строки приложения нажмите на правую кнопку мышки и выберите "Выделить все", для продолжения оптимизации изображения в окне командной строки приложения нажмите на правую кнопку мышки.
- Многопоточный режим оптимизации изображений. По умолчанию, при оптимизации изображений приложение использует многопоточный режим. Настоятельно не рекомендуется запускать параллельно более одной копии приложения, т.к. это существенно снизит как скорость оптимизации изображений, так и быстродействие всей системы в целом. Для отключения многопоточного режима откройте файл `Tools\config.ini` любым текстовым редактором и следуйте инструкции.

### Благодарности
- Благодарим авторов приложений, которые используются в проекте;
- Благодарим участников форумов [encode.ru](http://encode.ru/), [forum.ru-board.com](http://forum.ru-board.com/), [forum.script-coding.com](http://script-coding.com/forum/), [forum.vingrad.ru](http://forum.vingrad.ru/) и [cyberforum.ru](http://www.cyberforum.ru/) за вклад в развитие проекта;
- Отдельно благодарим **X128** за огромный вклад в развитие проекта.

### Альфа-версия
https://github.com/res2001/iCatalyst

### Лицензия
Данное программное обеспечение выпускается под лицензией [MIT](https://github.com/lorents17/iCatalyst/blob/master/LICENSE.RU.md).

### Планы на будущее
- добавить поддержку оптимизации SVG;
- добавить поддержку оптимизации PNG и JPEG с потерями.
