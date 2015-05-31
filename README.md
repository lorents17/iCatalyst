# Image Catalyst

Loseless PNG, JPEG and GIF optimization / compression tool for Windows.

Created by Lorents & Res2001.

## Tools used

### PNG optimization
- AdvDef (AdvanceComp 1.20 beta);
- DeflOpt 2.07;
- Defluff 0.3.2;
- PNGWolfZopfli, 06.05.2015;
- TruePNG 0.5.0.4.

### JPEG optimization
- JPEGinfo, 16.03.2014;
- JPEGstripper, 16.03.2014;
- MozJPEGTran (MozJPEG 3.1).

### GIF optimization
- GIFSicle 1.87.

## Additional software
- DlgMsgBox, 29.02.2012.

## Requirements

Works starting from Windows XP SP3 32-bit.

## Command line options

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
- Specify full path pointing to images or dirs with images. For example: `"C:\Images" "C:\Photos" "C:\logo.png"`.
- You can't use symbols such as `&`, `%`, `(`, `)`, `!` etc. in paths.
- App handles images in directories recursively.
```

### Drag and Drop

- Drop images and directories on `iCatalyst.bat` icon.
- There should not be symbols such as `&`, `%`, `(`, `)`, `!` etc. in paths.
- App handles images in directories recursively.

### PNG optimization settings
- Advanced - uses basic tools. Compression is usually better than Photoshop (Save for Web) by 10%;
- Xtreme - uses advanced tools. Usually better than Advanced mode by 2% but 5 times slower.

### JPEG optimization settings
- Baseline - image will be [displayed line by line when loading](http://habrastorage.org/files/854/7c8/404/8547c84042c34393a808798a9f0ecfe9.gif).
- Progressive - image will be [loaded progressively ](http://habrastorage.org/files/365/aa3/0ef/365aa30ef6044cd48425b1288f5aeff4.gif).
- Default - uses defaults.

## Tricks

- In order to pause optimization in the command line window press right mouse button and "select all". Press right mouse button again to resume.
- You can adjust settings in Tools\config.ini.
- By default multitheaded mode is used so it's not recommended to launch more than a single optimization process since it will be extremely slow. Multi-threaded mode can be turned off in `Tools\config.ini`.

## Thanks

- Original tools authors.
- Member of encode.ru, forum.ru-board.com, forum.script-coding.com, forum.vingrad.ru and cyberforum.ru for their participation in the project;
- X128 for exceptional contributions.

## License

MIT.

## Roadmap

- SVG;
- Lossy PNG and JPEG.
