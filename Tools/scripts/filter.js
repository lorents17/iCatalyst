var fso = new ActiveXObject("Scripting.FileSystemObject");
var WshShell = new ActiveXObject("WScript.Shell");
var env = WshShell.Environment("Process");
var re = new RegExp("[^a-zà-ÿ¸¨0-9_:\\.,~@#$\\-+=\\\\/{}\\[\\]'`? ]","ig");
var rd = new RegExp("[\\u2191]","ig");
var rp = new RegExp("\"","ig");
var basepath, outfirst, outdirorig;
var WIN2DOS = 1, DOS2WIN = 0;
var JPG = 0, PNG = 1, GIF = 2, num;
var rfile = new Array(
	{name: "JPG", ri: new RegExp("\\.jp(g|eg?)$","ig"),	mask: "*.jpg;*.jpe?",	opt: -1, max: 3},
	{name: "PNG", ri: new RegExp("\\.png$","ig"), 		mask: "*.png",		opt: -1, max: 2},
	{name: "GIF", ri: new RegExp("\\.gif$","ig"), 		mask: "*.gif",		opt: -1, max: 1}
);

outdirorig = env.Item("outdir");
rfile[JPG].opt = env.Item("jpeg");
rfile[PNG].opt = env.Item("png");
rfile[GIF].opt = env.Item("gif");

if (outdirorig.toUpperCase() == "FALSE")
	outdirorig = "";
else if(!fso.FolderExists(outdirorig) && !CreateTree(outdirorig)) 
	WScript.quit(-1);


if(WScript.Arguments.named.Exists("Basepath"))
	basepath = WScript.Arguments.named.Item("Basepath").substr(1);
else
	WScript.quit(-2);

if(!WScript.StdIn.AtEndOfStream)
	WorkBasepath();
WScript.quit(0);

function WorkBasepath() {
	basepath = fso.GetAbsolutePathName(basepath);
	if(fso.FileExists(basepath)) {
		if(FileMatch(basepath))
			workv(basepath);
	} else if(fso.FolderExists(basepath)) {
		if(outdirorig!="") {
			outfirst = fso.GetBaseName(basepath);
			if(fso.GetExtensionName(basepath)!="") outfirst += "." + fso.GetExtensionName(basepath);
			outfirst = getFolderName(fso.BuildPath(outdirorig,outfirst));
			if(outfirst=="") {
				echoerr(basepath,WIN2DOS);
				return false;
			}
		}
		DirWork(basepath);
	} else echoerr(basepath,WIN2DOS);
	return true;
}

function DirWork(dir) {
	var str;
	while(!WScript.StdIn.AtEndOfStream) {
		str = sDOS2WIN(WScript.StdIn.ReadLine(),DOS2WIN);
		if(FileMatch(str)) 
			workv(str);
	}
	return;
}

function FileMatch(fname) {
	for(var i in rfile)
		if(rfile[i].opt != 0 && fname.match(rfile[i].ri))
			return true;
	return false;
}

function CreateTree(p) {
	p = fso.GetAbsolutePathName(p);
	if(fso.FileExists(p)) return false;
	if(fso.FolderExists(p)) return true;
	var owner = fso.GetParentFolderName(p);
	if(!fso.FolderExists(owner))
		if(!CreateTree(owner)) return false;
	fso.CreateFolder(p);
	return true;
}

function workv(str) {
	if(str.match(rd) || str.match(re)) {
		echoerr(str,WIN2DOS);
		return false;
	}
	var p, tp, tf, outdir;
	p = fso.GetParentFolderName(str);
	if(outdirorig.toUpperCase() == fso.GetAbsolutePathName(p).toUpperCase()) 
		outdir = "";
	else
		outdir = outdirorig;
	tf = fso.GetFileName(str);
	if(outdir != "") {
		if(str.toUpperCase() == basepath.toUpperCase()) {
			tp = outdir;
		} else {
			tp = outfirst + p.substr(basepath.length);
		}
		tf = fso.GetFileName(getFileName(fso.BuildPath(tp,tf)));
	} else {
		tp = p;
	}
	echo(str + "\t" + fso.BuildPath(tp,tf),WIN2DOS);
	return true;
}

function getFileName(fn) {
	if(!fso.FileExists(fn)) return fn;
	var ext, name, i;
	ext = fso.GetExtensionName(fn);
	name = fso.GetParentFolderName(fn) + "\\" + fso.GetBaseName(fn);
	i = 1;
	while(fso.FileExists(name+"-"+padleft(i,4,"0")+"."+ext) && i<10000) ++i;
	if(i>9999) return "";
	return name+"-"+padleft(i,4,"0")+"."+ext;
}

function getFolderName(fn) {
	if(!fso.FolderExists(fn)) return fn;
	var ext, name, i;
	ext = fso.GetExtensionName(fn);
	if(ext!="") ext = "." + ext;
	name = fso.GetParentFolderName(fn) + "\\" + fso.GetBaseName(fn);
	i = 1;
	while(fso.FolderExists(name+"-"+padleft(i,4,"0")+ext) && i<10000) ++i;
	if(i>9999) return "";
	return name+"-"+padleft(i,4,"0")+ext;
}

function padleft(s,l,c) {
	while(s.toString().length<l) s = c + s;
	return s;
}

function echo(str, wd) {
	if(arguments.length == 1)
		WScript.StdOut.WriteLine(str);
	else
		WScript.StdOut.WriteLine(sDOS2WIN(str,wd));
}

function echoerr(str, wd) {
	if(wd == undefined)
		WScript.StdErr.WriteLine(" " + str);
	else
		WScript.StdErr.WriteLine(" " + sDOS2WIN(str,wd));
}

function sDOS2WIN(sText, InsideOut) {
	var aCharsets = ["windows-1251", "cp866"];
	//sText += "";
	//bInsideOut = bInsideOut ? 1 : 0;
	with (new ActiveXObject("ADODB.Stream")) {
		type = 2; 
		mode = 3;
		charset = aCharsets[InsideOut];
		open();
		writeText(sText);
		position = 0;
		charset = aCharsets[1 - InsideOut];
		return readText();
	}
}
