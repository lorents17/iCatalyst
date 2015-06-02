# Image Catalyst

Оптимизация / сжатие изображений PNG, JPEG и GIF без потери качества для Windows.

|![Adobe Photoshop CC 2014 (Save For Web)](https://cloud.githubusercontent.com/assets/3890881/7943531/b6a6e1c2-096d-11e5-810f-16451c828508.png)|![kraken.io](https://cloud.githubusercontent.com/assets/3890881/7943547/cf4b86c4-096d-11e5-9637-751bf78e0301.png)|![Image Catalyst](https://cloud.githubusercontent.com/assets/3890881/7943571/ef8e18fc-096d-11e5-9933-0a59653f7ea8.png)|
|:----------|:----------|:----------|
|Adobe Photoshop CC 2014 (Save For Web) — 59,78 КБ|[kraken.io](https://kraken.io/) — 54,90 КБ|Image Catalyst — 51,39 КБ|

Авторы - [Lorents](https://github.com/lorents17) & [Res2001](https://github.com/res2001)

### Инструменты оптимизации / сжатия

##### PNG:
- AdvDef ([AdvanceComp](http://advancemame.sourceforge.net/doc-advdef.html) 1.20 beta)
- DeflOpt 2.07
- [Defluff](http://encode.ru/threads/1214-defluff-a-deflate-huffman-optimizer) 0.3.2
- [PNGWolfZopfli](https://github.com/jibsen/pngwolf-zopfli) 1.0.0
- [TruePNG](http://x128.ho.ua/pngutils.html) 0.5.0.4

##### JPEG:
- [JPEGinfo](http://rtfreesoft.blogspot.ru/2014/03/jpginfo.html) от 16.03.2014
- [JPEGstripper](http://rtfreesoft.blogspot.ru/2014/03/jpegstripper.html) от 16.03.2014
- MozJPEGTran ([MozJPEG](https://github.com/mozilla/mozjpeg) 3.1)

##### GIF:
- [GIFSicle](http://www.lcdf.org/gifsicle/) 1.87

##### Дополнительное ПО:
- DlgMsgBox от 29.02.2012

### Требования

Операционная система - Windows XP SP3 32-bit и старше.

### Параметры командной строки

```
iCatalyst.bat [options] [add folders \ add files]

Options:
/png:#	Параметры оптимизации PNG:
		1 - Уровень сжатия - Xtreme
		2 - Уровень сжатия - Advanced
		0 - пропустить оптимизацию PNG

/jpg:#	Параметры оптимизации JPEG:
		1 - Encoding Process - Baseline
		2 - Encoding Process - Progressive
		3 - параметры оптимизации по умолчанию
		0 - пропустить оптимизацию JPEG

/gif:#	Параметры оптимизации GIF:
		1 - параметры оптимизации по умолчанию
		0 - пропустить оптимизацию GIF

"/outdir:#"	Параметры сохранения оптимизированных изображений:
			true  - заменить оригинальные изображения на оптимизированные
			false - открыть диалоговое окно для сохранения изображений
			"полный путь к папке" - папка сохранения изображений. Например: "/outdir:C:\temp",
			если папки назначения не существует, то она будет создана автоматически.

Add folders \ Add files
- Укажите полный путь к изображениям и\или к папкам с изображениями. Например: "C:\Images" "C:\logo.png".
- В полных путях изображений не должны быть символы. Например: `&`, `%`, `(`, `)`, `!` и т.д.
- Приложение автоматически оптимизирует изображения во вложенных подпапках.
```

### Drag and Drop

![enter image description here](http://s020.radikal.ru/i703/1505/fb/d9dd0a11fdfa.png)

- Перенесите изображения и\или папки с изображениями на значок `iCatalyst.bat`.
- В полных путях изображений не должны быть символы. Например: `&`, `%`, `(`, `)`, `!` и т.д.
- Приложение автоматически оптимизирует изображения во вложенных подпапках.

### Параметры оптимизации PNG

![enter image description here](https://hsto.org/files/0fc/f39/4c8/0fcf394c84b848e293ee7cae4ca52d20.png)

|Advanced|Xtreme|
|:-------|:----------|
|![enter image description here](http://s011.radikal.ru/i318/1505/6a/530ea671f0de.png)|![enter image description here](http://i038.radikal.ru/1505/ea/e8d4a4117cce.png)|
|Размер — 55,57 КБ. Время оптимизации — 1,5 с|Размер — 54,65 КБ. Время оптимизации — 7,5 с|
|PNG interlace method — None|PNG interlace method — None|
|TruePNG + Advdef|TruePNG + PNGWolfZopfli|
|Степень сжатия на ~ 10% выше по сравнению с Adobe Photoshop CC 2014 (Save for Web).|Степень сжатия на ~ 2% выше по сравнению с режимом оптимизации Advanced, скорость сжатия ниже ~ 5 раз.|

### Параметры оптимизации JPEG

![enter image description here](https://hsto.org/files/8d0/0de/ed3/8d00deed3ba848d38d87f0f29e518bc8.png)

|Baseline|Progressive|
|:-------|:----------|
|![enter image description here](http://hsto.org/files/854/7c8/404/8547c84042c34393a808798a9f0ecfe9.gif)|![enter image description here](http://hsto.org/files/365/aa3/0ef/365aa30ef6044cd48425b1288f5aeff4.gif)|
|Последовательное (линейное) отображение изображения по мере поступления данных при загрузке.|Поочередно все более детализированные версии целого изображения по мере поступления данных при загрузке.|

- *Default* - использует параметры оптимизации по умолчанию.

### Параметры оптимизации GIF

![enter image description here](https://hsto.org/files/594/5ec/99e/5945ec99e5ca4ad8a21de1d9315f0531.png)

- *Default* - использует параметры оптимизации по умолчанию.

### Дополнительно
- Поставить оптимизацию изображений на паузу. Для этого в окне командной строки приложения нажмите на правую кнопку мышки и выберите "Выделить все", для продолжения оптимизации изображения в окне командной строки приложения нажмите на правую кнопку мышки.
- Изменения настроек приложения. Откройте файл `Tools\config.ini` любым текстовым редактором и следуйте инструкции.
- Многопоточный режим оптимизации изображений. По умолчанию, при оптимизации изображений приложение использует многопоточный режим. Настоятельно не рекомендуется запускать параллельно более одной копии приложения, т.к. это существенно снизит как скорость оптимизации изображений, так и быстродействие всей системы в целом. Для отключения многопоточного режима откройте файл `Tools\config.ini` любым текстовым редактором и следуйте инструкции.

### Благодарности
- благодарим авторов приложений, которые используются в проекте;
- благодарим участников форумов [encode.ru](http://encode.ru/), [forum.ru-board.com](http://forum.ru-board.com/), [forum.script-coding.com](http://script-coding.com/forum/), [forum.vingrad.ru](http://forum.vingrad.ru/) и [cyberforum.ru](http://www.cyberforum.ru/) за вклад в развитие проекта;
- отделанная благодарность **X128** за огромный вклад в развитие проекта.

### Альфа-версия проекта
https://github.com/res2001/iCatalyst


### Лицензия
Данное программное обеспечение выпускается под лицензией [MIT](https://github.com/lorents17/iCatalyst/blob/master/LICENSE.RU.md).

### Планы на будущее
- добавить поддержку оптимизации изображений SVG;
- добавить поддержку оптимизации изображений PNG и JPEG с потерями.
