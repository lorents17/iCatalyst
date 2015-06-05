# Image Catalyst

Loseless PNG, JPEG and GIF optimization / compression tool for Windows.

|![Adobe Photoshop CC 2014 (Save For Web)](https://cloud.githubusercontent.com/assets/3890881/7943531/b6a6e1c2-096d-11e5-810f-16451c828508.png)|![kraken.io](https://cloud.githubusercontent.com/assets/3890881/7943547/cf4b86c4-096d-11e5-9637-751bf78e0301.png)|![Image Catalyst](https://cloud.githubusercontent.com/assets/3890881/7943571/ef8e18fc-096d-11e5-9933-0a59653f7ea8.png)|
|:----------|:----------|:----------|
|Adobe Photoshop CC 2014 (Save For Web) — 59,78 КБ|[kraken.io](https://kraken.io/) — 54,90 КБ|Image Catalyst — 51,39 КБ|

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
- DlgMsgBox, 29.02.2012

### Requirements

Works starting from Windows XP SP3 32-bit.

### Command line options

```
iCatalyst.bat [options] [add folders \ add files]

Options:
/png:#	PNG optimization options:
	1 - Compression level - Xtreme;
	2 - Compression level - Advanced;
	0 - skip PNG optimization.

/jpg:#	JPEG optimization options:
	1 - Encoding Process - Baseline;
	2 - Encoding Process - Progressive;
	3 - defaults;
	0 - skip JPEG optimization.

/gif:#	GIF optimization options:
		1 - defaults:
		0 - skip GIF optimization.

"/outdir:#"	image saving options:
		true  - replace originals;
		false - open dialogue to specify where to save images;
		"full path" - where to save images.
		For example: "/outdir:C:\temp", if there's no such dir exists, it will be created automatically.

Add folders \ Add files
- Specify full path pointing to images or dirs with images. For example: `"C:\Images" "C:\logo.png"`.
- You can't use symbols such as `&`, `%`, `(`, `)`, `!` etc. in paths.
- App handles images in directories recursively.
```

### Drag and Drop

![Drag and Drop](https://cloud.githubusercontent.com/assets/3890881/7943598/28496fd4-096e-11e5-8df6-d6415e47caf8.png)

- Drop images and directories on `iCatalyst.bat` icon.
- There should not be symbols such as `&`, `%`, `(`, `)`, `!` etc. in paths.
- App handles images in directories recursively.

### PNG optimization settings

![PNG](https://cloud.githubusercontent.com/assets/3890881/7943611/39d99dd2-096e-11e5-932f-10d5320d10b4.png)

- Advanced - uses basic tools. Compression is usually better than Photoshop (Save for Web) by 10%;
- Xtreme - uses advanced tools. Usually better than Advanced mode by 2% but 5 times slower.

### JPEG optimization settings

![JPEG](https://cloud.githubusercontent.com/assets/3890881/7943652/873d3c5a-096e-11e5-8050-af54582f5c5b.png)

- Baseline - image will be [displayed line by line when loading](http://habrastorage.org/files/854/7c8/404/8547c84042c34393a808798a9f0ecfe9.gif).
- Progressive - image will be [loaded progressively ](http://habrastorage.org/files/365/aa3/0ef/365aa30ef6044cd48425b1288f5aeff4.gif).
- Default - uses defaults.

### GIF optimization settings

![GIF](https://cloud.githubusercontent.com/assets/3890881/7943690/c73a84ac-096e-11e5-8920-a088a8a0ee60.png)

### Additionally
- In order to pause optimization in the command line window press right mouse button and "select all". Press right mouse button again to resume.
- You can adjust settings in Tools\config.ini.
- By default multitheaded mode is used so it's not recommended to launch more than a single optimization process since it will be extremely slow. Multi-threaded mode can be turned off in `Tools\config.ini`.

## Thanks
- Original tools authors.
- Member of [encode.ru](http://encode.ru/), [forum.ru-board.com](http://forum.ru-board.com/), [forum.script-coding.com](http://script-coding.com/forum/), [forum.vingrad.ru](http://forum.vingrad.ru/) и [cyberforum.ru](http://www.cyberforum.ru/) for their participation in the project;
- X128 for exceptional contributions.

### Alpha version
https://github.com/res2001/iCatalyst

### License

This software is released under the terms of the [MIT license](https://github.com/lorents17/iCatalyst/blob/master/LICENSE.md).


### Future plans
- SVG
- Lossy PNG and JPEG
