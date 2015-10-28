if(WScript.Arguments.length == 0) WScript.quit(-1);

var fso = new ActiveXObject("Scripting.FileSystemObject");
var re = new RegExp("[^a-zà-ÿ¸¨0-9_:\\.,~@#$\\-+=\\\\/{}\\[\\]'`? ]","ig");
var rd = new RegExp("[\\u2191]","ig");
var rp = new RegExp("\"","ig");
var ri;
var basepath, basepathdos, ret, outfirst;
var argn, outdirorig, outdir, isstdin;

outdir = ""; outdirorig = "";
isstdin = "";
argn = WScript.Arguments.named;

if(argn.Exists("Outdir")) {
	outdirorig = argn.Item("Outdir");
	if(outdirorig.match(rd) || outdirorig.match(re)) {
		WScript.StdErr.WriteLine(sDOS2Win(" " + outdirorig,true));
		WScript.quit(-1);
	}
	if (outdirorig.toUpperCase() == "FALSE") 
		outdirorig = "";
	else {
		outdirorig = fso.GetAbsolutePathName(outdirorig);
		if(!fso.FolderExists(outdirorig)) if(CreateTree(outdirorig)) WScript.quit(-3);
	}
}

var str = "", isjpg = false, ispng = false, isgif = false, num;

if(argn.Exists("JPG")) if(argn.Item("JPG").length > 0) {
	num = parseInt(argn.Item("JPG"));
	if(!isNaN(num) && num>=1 && num<=3) {
		isjpg=true;
		str = "|jp(g|e|eg)";
	}
}

if(argn.Exists("PNG")) if(argn.Item("PNG").length > 0) {
	num = parseInt(argn.Item("PNG"));
	if(!isNaN(num) && num>=1 && num<=2) {
		ispng=true;
		str += "|png";
	}
}

if(argn.Exists("GIF")) if(argn.Item("GIF").length > 0) {
	num = parseInt(argn.Item("GIF"));
	if(!isNaN(num) && num==1) {
		isgif=true;
		str += "|gif";
	}
}

if (!isjpg && !ispng && ! isgif) WScript.quit(0);
ri = new RegExp("\\.("+str.substr(1)+")$","ig");
if(argn.Exists("IsStdIn")) isstdin = argn.Item("IsStdIn").toUpperCase();
ret = 0;

if(isstdin=="YES") {
	while (!WScript.StdIn.AtEndOfStream) {
		basepath = WScript.StdIn.ReadLine().replace(rp,"");
		WorkBasepath();
	}

} else {
	for(i=0;i<WScript.Arguments.unnamed.count;++i) {
		basepath = WScript.Arguments.unnamed(i);
		WorkBasepath();
	}
}

WScript.quit(ret);

function WorkBasepath() {
	if(basepath.match(rd)) {
		WScript.StdErr.WriteLine(sDOS2Win(" " + basepath,true));
		return 0;
	}
	basepath = fso.GetAbsolutePathName(basepath);
	if(fso.FileExists(basepath) && basepath.match(ri)) {
		ret += workv(basepath);
	} else if(fso.FolderExists(basepath)) {
		if(outdirorig!="") {
			outfirst = fso.GetBaseName(basepath);
			if(fso.GetExtensionName(basepath)!="") outfirst += "." + fso.GetExtensionName(basepath);
			outfirst = getFolderName(fso.BuildPath(outdirorig,outfirst));
			if(outfirst=="") {
				WScript.StdErr.WriteLine(" " + sDOS2Win(basepath,true));
				return 0;
			}
		}
		ret += DirWork(basepath);
	}
}

function DirWork(dir) {
	var f, fc, ret;
	ret = 0;
	f = fso.GetFolder(dir);
	fc = new Enumerator(f.files);
	for (; !fc.atEnd(); fc.moveNext()) {
		if(fc.item().Path.match(ri)) ret += workv(fc.item().Path);
	}
	fc = new Enumerator(f.SubFolders);
	for (; !fc.atEnd(); fc.moveNext()) {
		ret += DirWork(fc.item().Path);
	}
	return(ret);
}

function CreateTree(p) {
	p = fso.GetAbsolutePathName(p);
	if(fso.FileExists(p)) return(-1);
	if(fso.FolderExists(p)) return(0);
	var owner = fso.GetParentFolderName(p);
	if(!fso.FolderExists(owner))
		if(CreateTree(owner)) return(-2);
	fso.CreateFolder(p);
	return(0);
}

function work(str) {
	var p, tp, tf;
	if(str.match(rd)) {
		WScript.StdErr.WriteLine(" " + sDOS2Win(basepath,true));
		return 0;
	}
	p = fso.GetParentFolderName(str);
	if(outdirorig.toUpperCase() == fso.GetAbsolutePathName(p).toUpperCase()) 
		outdir = "";
	else
		outdir = outdirorig;
	if(!str.match(re) && !str.match(rd)) {
		tf = fso.GetFileName(str);
		if(outdir!="") {
			if(str.toUpperCase()==basepath.toUpperCase()) {
				tp = outdir;
			} else {
				tp = outfirst + p.substr(basepath.length);
				if(CreateTree(tp)) {
					WScript.StdErr.WriteLine(" " + sDOS2Win(str,true));
					return 0;
				}
			}
			filecopy(str,fso.BuildPath(tp,tf));
		} else {
			tp = p;
		}
		WScript.StdOut.WriteLine(sDOS2Win(fso.BuildPath(tp,tf),true));
		return 1;
	} else {
		WScript.StdErr.WriteLine(" " + sDOS2Win(str,true));
		return 0;
	}
}

function workv(str) {
	var p, tp, tf;
	if(str.match(rd)) {
		WScript.StdErr.WriteLine(" " + sDOS2Win(basepath,true));
		return 0;
	}
	p = fso.GetParentFolderName(str);
	if(outdirorig.toUpperCase() == fso.GetAbsolutePathName(p).toUpperCase()) 
		outdir = "";
	else
		outdir = outdirorig;
	if(!str.match(re) && !str.match(rd)) {
		tf = fso.GetFileName(str);
		if(outdir!="") {
			if(str.toUpperCase()==basepath.toUpperCase()) {
				tp = outdir;
			} else {
				tp = outfirst + p.substr(basepath.length);
			}
			tf = fso.GetFileName(getFileName(fso.BuildPath(tp,tf)));
		} else {
			tp = p;
		}
		WScript.StdOut.WriteLine(sDOS2Win(str + "\t" + fso.BuildPath(tp,tf),true));
		return 1;
	} else {
		WScript.StdErr.WriteLine(" " + sDOS2Win(str,true));
		return 0;
	}
}

function checkFileName(fn) {
	if (fn.match(re)) {
		return fso.GetBaseName(fso.GetTempName()) + "." + fso.GetExtensionName(fn);
	}
	return fn;
}

function filecopy(source,target) {
	if(!fso.FileExists(source)) return "";
	var name = getFileName(target);
	if(name=="") return "";
	fso.CopyFile(source,name,true);
	return name;
}

function filemove(source,target) {
	if(!fso.FileExists(source)) return "";
	var name = getFileName(target);
	if(name=="") return "";
	fso.MoveFile(source,name);
	return name;
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

function GetCharCodeHexString(sText) {
	var j, str1="";
	for(j=0;j<sText.length;++j) str1 += " " + sText.charCodeAt(j).toString(16);
	return str1.substr(1);
}

function sDOS2Win(sText, bInsideOut) {
	var aCharsets = ["windows-1251", "cp866"];
	sText += "";
	bInsideOut = bInsideOut ? 1 : 0;
	with (new ActiveXObject("ADODB.Stream")) {
		type = 2; 
		mode = 3;
		charset = aCharsets[bInsideOut];
		open();
		writeText(sText);
		position = 0;
		charset = aCharsets[1 - bInsideOut];
		return readText();
	}
}