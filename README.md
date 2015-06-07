# Image Catalyst

Loseless PNG, JPEG and GIF optimization / compression tool for Windows.

|![Adobe Photoshop](https://cloud.githubusercontent.com/assets/3890881/8023708/091611e8-0d20-11e5-8b0b-b0fcc62df307.png)|![Image Catalyst](https://cloud.githubusercontent.com/assets/3890881/7943571/ef8e18fc-096d-11e5-9933-0a59653f7ea8.png)|
|:----------|:----------|
|Adobe Photoshop CC 2014 (Save For Web) — 59,78 КБ|Image Catalyst — 51,39 КБ|

##### Created by [Lorents](https://github.com/lorents17) & [Res2001](https://github.com/res2001)

### Tools

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

##### Additional software:
- DlgMsgBox 29.02.2012

### Requirements

Operating system — Windows XP SP3 32-bit and older.

### Command line options

```
iCatalyst.bat [options] [add folders \ add files]

Options:
/png:#	Optimization settings PNG:
		1 - Compression level - Xtreme
		2 - Compression level - Advanced
		0 - Skip (default)

/jpg:#	Optimization settings JPEG:
		1 - Encoding Process - Baseline
		2 - Encoding Process - Progressive
		3 - Optimization settings default
		0 - Skip (default)

/gif:#	Optimization settings GIF:
		1 - Optimization settings default
		0 - Skip (default)

"/outdir:#	Settings save optimized images:
			true  - replace the original image on optimized
			false - open dialog box for saving images (default)
			"full path to folder - specify the folder to save images. 
			For example: "/outdir:C:\temp", if the destination folder does not exist,
			it will be created automatically.

Add folders \ Add files:
- Specify the full path to the images and / or folders with images. 
  For example: "C:\Images" "C:\logo.png"
- The full paths of images should not be special characters. For example: &, %, (, ) etc.
- The application optimizes images in nested subfolders.
```

### Drag and Drop

![Drag and Drop](https://cloud.githubusercontent.com/assets/3890881/7943598/28496fd4-096e-11e5-8df6-d6415e47caf8.png)

- The full paths of images should not be special characters. For example: `&`, `%`, `(`, `)`, `!` etc.
- The application optimizes images in nested subfolders.

### PNG optimization settings

![PNG](https://cloud.githubusercontent.com/assets/3890881/7943611/39d99dd2-096e-11e5-932f-10d5320d10b4.png)

|Advanced|Xtreme|
|:-------|:----------|
|![Advanced](https://cloud.githubusercontent.com/assets/3890881/7943713/f816fd26-096e-11e5-8a8d-036e9fd443bf.png)|![Xtreme](https://cloud.githubusercontent.com/assets/3890881/7943637/6c37201a-096e-11e5-92ca-855f69ed95ef.png)|
|Size — 55,57 KB; Optimization time — 1,5 s|Size — 54,65 KB; Optimization time — 7,5 s|
|PNG interlace method — None|PNG interlace method — None|
|`TruePNG` + `Advdef`|`TruePNG` + `PNGWolfZopfli`|
|The compression ratio is ~ 10% higher compared to Adobe Photoshop CC 2014 (Save for Web)|The compression ratio is ~ 2% higher compared to Advanced optimization modes, compression speed below ~ 5 times|

- `Skip` — skip the optimization of images PNG.

### JPEG optimization settings

![JPEG](https://cloud.githubusercontent.com/assets/3890881/7943652/873d3c5a-096e-11e5-8050-af54582f5c5b.png)

|Baseline|Progressive|
|:-------|:----------|
|![Baseline](https://cloud.githubusercontent.com/assets/3890881/7943666/9c3c1324-096e-11e5-8cf1-bceade0ebd85.gif)|![Progressive](https://cloud.githubusercontent.com/assets/3890881/7943679/ace1271e-096e-11e5-9ca4-6f33f421ca52.gif)|
|For image < 10 KB, it is recommended to use — `Baseline` ([read more](http://yuiblog.com/blog/2008/12/05/imageopt-4/))|For image > 10 KB, it is recommended to use — `Progressive` ([read more](http://yuiblog.com/blog/2008/12/05/imageopt-4/))|

- `Default` — uses the optimization settings by default;
- `Skip` — skip the optimization of images JPEG.

### GIF optimization settings

![GIF](https://cloud.githubusercontent.com/assets/3890881/7943690/c73a84ac-096e-11e5-8920-a088a8a0ee60.png)

- `Default` — uses the optimization settings by default;
- `Skip` — skip the optimization of images GIF.

### Additionally
- To deliver optimized images on pause. To do this in the command prompt window app click on the right mouse button and select "Select all", to continue optimizing the image in the window command line application click on the right mouse button.
- Change the settings of the application. Open the file `Tools\config.ini` with any text editor and follow the instructions.
- Multithreaded optimizing images. By default, when optimizing the images the app uses multi-threaded mode. It is not recommended to run in parallel more than one copy of the application, as this will significantly reduce the speed of image optimization and performance of the whole system. To disable multi-threading mode, open the file `Tools\config.ini` with any text editor and follow the instructions.

### Thanks
- Thanks the authors of the applications that are used in the project;
- Thanks the participants of the forums [encode.ru](http://encode.ru/), [forum.ru-board.com](http://forum.ru-board.com/), [forum.script-coding.com](http://script-coding.com/forum/), [forum.vingrad.ru](http://forum.vingrad.ru/) и [cyberforum.ru](http://www.cyberforum.ru/) for contribution to the development of the project;
- Thanks **X128** for his huge contribution to the development of the project.

### Alpha version
https://github.com/res2001/iCatalyst

### License

This software is released under the terms of the [MIT license](https://github.com/lorents17/iCatalyst/blob/master/LICENSE.md).


### Future plans
- add support of optimization of SVG;
- add support of optimization of PNG and JPEG lossy.
