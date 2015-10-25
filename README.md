# Image Catalyst

Lossless PNG, JPEG and GIF image optimization / compression for Windows.

|![Adobe Photoshop](https://cloud.githubusercontent.com/assets/3890881/8023708/091611e8-0d20-11e5-8b0b-b0fcc62df307.png)|![Image Catalyst](https://cloud.githubusercontent.com/assets/3890881/7943571/ef8e18fc-096d-11e5-9933-0a59653f7ea8.png)|
|:----------|:----------|
|Adobe Photoshop CC 2014 (Save For Web) — 59.78 KB|Image Catalyst — 51.39 KB|

##### Created by [Lorents](https://github.com/lorents17) & [Res2001](https://github.com/res2001)

### Tools

##### PNG:
- AdvDef ([AdvanceComp](https://github.com/amadvance/advancecomp) 1.20)
- DeflOpt 2.07
- [PNGWolfZopfli](https://github.com/jibsen/pngwolf-zopfli) 1.0.0
- [TruePNG](http://x128.ho.ua/pngutils.html) 0.6.1.5

##### JPEG:
- [JPEGinfo](http://rtfreesoft.blogspot.ru/2014/03/jpginfo.html) от 16.03.2014
- [JPEGstripper](http://rtfreesoft.blogspot.ru/2014/03/jpegstripper.html) от 16.03.2014
- JPEGTran ([MozJPEG](https://github.com/mozilla/mozjpeg) 3.1)

##### GIF:
- [GIFSicle](http://www.lcdf.org/gifsicle/) 1.88

##### Additional software:
- DlgMsgBox 29.02.2012

### System requirements

Operating system — Windows XP SP3 and higher.

### Command line options (cmd.exe)

```
-----------------------------------------------------------------------------
 Image Catalyst - lossless PNG, JPEG and GIF image optimization / compression

 Please check README for more details

 call iCatalyst.bat [options] [add directories \ add files]

 Options:

 /png:# PNG optimization mode (Non-Interlaced):
        1 - Compression level - Xtreme
        2 - Compression level - Advanced
        0 - Skip (default)

 /jpg:# JPEG optimization mode:
        1 - Encoding Process - Baseline
        2 - Encoding Process - Progressive
        3 - use mode of original image
        0 - Skip (default)

 /gif:# GIF optimization mode:
        1 - use settings of original image
        0 - Skip (default)

 "/outdir:#" image saving options:
        true  - replace original image with optimized variant
        false - open dialog box for saving images (default)
        "full path to directory" - specify directory to save images to.
        for example: "/outdir:C:\temp". If the destination directory
        does not exist, it will be created automatically.

 Add directories \ Add files:
 - Specify full image paths and / or paths to directories containing images.
   For example: "C:\Images" "C:\logo.png"
 - Full image paths should not contain any special characters such as
   "&", "%", "(", ")" etc.
 - Images in sub-directories are optimized recursively.

 Examples:
 call iCatalyst.bat /gif:1 "/outdir:C:\photos" "C:\images"
 call iCatalyst.bat /png:2 /jpg:2 "/outdir:true" "C:\images"
-------------------------------------------------------------------------------

```

### Drag and Drop

![Drag and Drop](https://cloud.githubusercontent.com/assets/3890881/7943598/28496fd4-096e-11e5-8df6-d6415e47caf8.png)

- Full image paths should not contain any special characters such as `&`, `%`, `(`, `)`, `!` etc.
- Images in sub-directories are optimized recursively.

### PNG optimization settings

![PNG](https://cloud.githubusercontent.com/assets/3890881/7943611/39d99dd2-096e-11e5-932f-10d5320d10b4.png)

|Advanced|Xtreme|
|:-------|:----------|
|![Advanced](https://cloud.githubusercontent.com/assets/3890881/7943713/f816fd26-096e-11e5-8a8d-036e9fd443bf.png)|![Xtreme](https://cloud.githubusercontent.com/assets/3890881/7943637/6c37201a-096e-11e5-92ca-855f69ed95ef.png)|
|Size — 55,57 KB; Optimization time — 1,5 s|Size — 54,65 KB; Optimization time — 7,5 s|
|`TruePNG` + `Advdef`|`TruePNG` + `PNGWolfZopfli`|
|Compression ratio is about 10% higher compared to Adobe Photoshop CC 2014 (Save for Web)|Compression ratio is about 2% higher compared to Advanced optimization modes, compression speed is 5 times better|

- `Skip` — skip optimization of PNG images.

##### Interlace option:
- `None` — displays the image in a browser only when download is complete.
- `Interlaced` — displays low-resolution versions of the image in a browser as the file downloads. Interlacing makes download time seem shorter, but it also increases file size (not support). 

### JPEG optimization settings

![JPEG](https://cloud.githubusercontent.com/assets/3890881/7943652/873d3c5a-096e-11e5-8050-af54582f5c5b.png)

|Baseline|Progressive|
|:-------|:----------|
|![Baseline](https://cloud.githubusercontent.com/assets/3890881/7943666/9c3c1324-096e-11e5-8cf1-bceade0ebd85.gif)|![Progressive](https://cloud.githubusercontent.com/assets/3890881/7943679/ace1271e-096e-11e5-9ca4-6f33f421ca52.gif)|
|For image < 10 KB, it is recommended to use — `Baseline` ([read more](http://yuiblog.com/blog/2008/12/05/imageopt-4/))|For image > 10 KB, it is recommended to use — `Progressive` ([read more](http://yuiblog.com/blog/2008/12/05/imageopt-4/))|

- `Default` — uses settings of original images;
- `Skip` — skip optimization of JPEG images.

### GIF optimization settings

![GIF](https://cloud.githubusercontent.com/assets/3890881/7943690/c73a84ac-096e-11e5-8920-a088a8a0ee60.png)

- `Default` — uses settings of original images;
- `Skip` — skip optimization of GIF images.

### Config.ini

Open the file `Tools\config.ini` with any text editor and follow the instructions.

```
[options]
;Number of streams. If value early 0, is used value of parameter %NUMBER_OF_PROCESSORS%.
thread=0

;Automatic replacement of original images by the optimized.
outdir=false

;Check update.
update=true

[PNG]
;Parameters of optimization of PNG:
;/a# - PNG dirty transparency 0=Clean, 1=Optimize;
;/g# - PNG gamma 0=Remove, 1=Apply & Remove, 2=Keep;
;/na - PNG don't change RGB values for fully transparent pixels;
;/nc - PNG don't change ColorType and BitDepth;
;/np - PNG don't change Palette.
xtreme=/a1 /g0
advanced=/a0 /g0

;Remove PNG Metadata (Chunks).
pngtags=true

[JPEG]
;Remove JPEG Metadata.
jpegtags=true

[GIF]
;Remove GIF Metadata.
giftags=true
```

### Additionally
- To pause optimization process click on right mouse button in the command prompt window and choose "Select all" in the context menu. To resume click right mouse button again.
- By default optimization runs in multi-threading mode. It is not recommended to run in more than one copy of the application, as it will significantly reduce both the image optimization speed and system performance overall. To disable multi-threading mode, open the file `Tools\config.ini` with any text editor and follow the instructions.

### Thanks
- Thanks to the authors of the applications that are used in the project;
- Thanks to the participants of [encode.ru](http://encode.ru/), [forum.ru-board.com](http://forum.ru-board.com/), [forum.script-coding.com](http://script-coding.com/forum/), [forum.vingrad.ru](http://forum.vingrad.ru/) and [cyberforum.ru](http://www.cyberforum.ru/) for contribution to the development of the project;
- Thanks **X128** for his huge contribution to the development of the project.

### Alpha version
https://github.com/res2001/iCatalyst

### License

This software is released under the terms of the [MIT license](https://github.com/lorents17/iCatalyst/blob/master/LICENSE.md).


### Future plans
- add support of optimization of SVG;
- add support of optimization of PNG and JPEG lossy.
