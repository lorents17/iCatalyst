var args = WScript.Arguments;
if(args.Count() != 1) WScript.Quit(1);
var req = new ActiveXObject("Msxml2.ServerXMLHTTP");
//var req = new ActiveXObject("Microsoft.XMLHTTP");
if (req) {
	req.open("GET", args(0), false);
	req.setRequestHeader("Cache-Control", "max-age=0");
	try {
		req.send(null);
		if (req.readyState == 4)
			if (req.status == 200) {
				WScript.echo(req.responseText);
				WScript.Quit(0);
			}
		} catch(e) {
		WScript.Quit(3);
	}
}
WScript.Quit(2);