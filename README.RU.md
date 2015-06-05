# Image Catalyst

Оптимизация / сжатие изображений PNG, JPEG и GIF без потери качества для Windows.

|![Adobe Photoshop CC 2014 (Save For Web)](https://cloud.githubusercontent.com/assets/3890881/7943531/b6a6e1c2-096d-11e5-810f-16451c828508.png)|![kraken.io](https://cloud.githubusercontent.com/assets/3890881/7943547/cf4b86c4-096d-11e5-9637-751bf78e0301.png)|![Image Catalyst](https://cloud.githubusercontent.com/assets/3890881/7943571/ef8e18fc-096d-11e5-9933-0a59653f7ea8.png)|
|:----------|:----------|:----------|
|Adobe Photoshop CC 2014 (Save For Web) — 59,78 КБ|[kraken.io](https://kraken.io/) — 54,90 КБ|Image Catalyst — 51,39 КБ|

Авторы - [Lorents](https://github.com/lorents17) & [Res2001](https://github.com/res2001)

### Инструменты

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
- В полных путях изображений не должно быть специальных символов. Например: &, %, (, ), ! и т.д.
- Приложение автоматически оптимизирует изображения во вложенных подпапках.
```

### Drag and Drop

![Drag and Drop](https://cloud.githubusercontent.com/assets/3890881/7943598/28496fd4-096e-11e5-8df6-d6415e47caf8.png)

- Перенесите изображения и\или папки с изображениями на значок `iCatalyst.bat`.
- В полных путях изображений не должно быть специальных символов. Например: `&`, `%`, `(`, `)`, `!` и т.д.
- Приложение автоматически оптимизирует изображения во вложенных подпапках.

### Параметры оптимизации PNG

![PNG](https://cloud.githubusercontent.com/assets/3890881/7943611/39d99dd2-096e-11e5-932f-10d5320d10b4.png)

|Advanced|Xtreme|
|:-------|:----------|
|![Advanced](https://cloud.githubusercontent.com/assets/3890881/7943713/f816fd26-096e-11e5-8a8d-036e9fd443bf.png)|![Xtreme](https://cloud.githubusercontent.com/assets/3890881/7943637/6c37201a-096e-11e5-92ca-855f69ed95ef.png)|
|Размер — 55,57 КБ. Время оптимизации — 1,5 с|Размер — 54,65 КБ. Время оптимизации — 7,5 с|
|PNG interlace method — None|PNG interlace method — None|
|TruePNG + Advdef|TruePNG + PNGWolfZopfli|
|Степень сжатия на ~ 10% выше по сравнению с Adobe Photoshop CC 2014 (Save for Web).|Степень сжатия на ~ 2% выше по сравнению с режимом оптимизации Advanced, скорость сжатия ниже ~ 5 раз.|

### Параметры оптимизации JPEG

![JPEG](https://cloud.githubusercontent.com/assets/3890881/7943652/873d3c5a-096e-11e5-8050-af54582f5c5b.png)

|Baseline|Progressive|
|:-------|:----------|
|![Baseline](https://cloud.githubusercontent.com/assets/3890881/7943666/9c3c1324-096e-11e5-8cf1-bceade0ebd85.gif)|![Progressive](https://cloud.githubusercontent.com/assets/3890881/7943679/ace1271e-096e-11e5-9ca4-6f33f421ca52.gif)|
|Последовательное (линейное) отображение изображения по мере поступления данных при загрузке.|Поочередно все более детализированные версии целого изображения по мере поступления данных при загрузке.|

- *Default* - использует параметры оптимизации по умолчанию.

### Параметры оптимизации GIF

![GIF](https://cloud.githubusercontent.com/assets/3890881/7943690/c73a84ac-096e-11e5-8920-a088a8a0ee60.png)

- *Default* - использует параметры оптимизации по умолчанию.

### Дополнительно
- Поставить оптимизацию изображений на паузу. Для этого в окне командной строки приложения нажмите на правую кнопку мышки и выберите "Выделить все", для продолжения оптимизации изображения в окне командной строки приложения нажмите на правую кнопку мышки.
- Изменения настроек приложения. Откройте файл `Tools\config.ini` любым текстовым редактором и следуйте инструкции.
- Многопоточный режим оптимизации изображений. По умолчанию, при оптимизации изображений приложение использует многопоточный режим. Настоятельно не рекомендуется запускать параллельно более одной копии приложения, т.к. это существенно снизит как скорость оптимизации изображений, так и быстродействие всей системы в целом. Для отключения многопоточного режима откройте файл `Tools\config.ini` любым текстовым редактором и следуйте инструкции.

### Благодарности
- благодарим авторов приложений, которые используются в проекте;
- благодарим участников форумов [encode.ru](http://encode.ru/), [forum.ru-board.com](http://forum.ru-board.com/), [forum.script-coding.com](http://script-coding.com/forum/), [forum.vingrad.ru](http://forum.vingrad.ru/) и [cyberforum.ru](http://www.cyberforum.ru/) за вклад в развитие проекта;
- отделанная благодарность **X128** за огромный вклад в развитие проекта.

### Альфа-версия
https://github.com/res2001/iCatalyst

### Лицензия
Данное программное обеспечение выпускается под лицензией [MIT](https://github.com/lorents17/iCatalyst/blob/master/LICENSE.RU.md).

### Планы на будущее
- добавить поддержку оптимизации SVG
- добавить поддержку оптимизации PNG и JPEG с потерями
