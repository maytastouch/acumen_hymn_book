var url = window.location.pathname;
var filename = url.substring(url.lastIndexOf('/')+1);
var str = filename.replace('.htm', '');
var no = parseInt(str);
if(no ==1)
{
	var pno = 1;
	var nno = no+1;
}
else if(no ==621)
{
	var pno = no-1;
	var nno = 621;
}
else
{
	var pno = no-1;
	var nno = no+1;
}
	
	
	
window.onload =
  function() {
    var div = document.createElement('div');
    div.id = 'fav';
	div.align = 'center';
	div.innerHTML = '<span><a href="../about.html"><img src="../old.png" align="left"  width=10% style="position:relative; top:10px;"></a></span><a href="../index.html"><img src="../images/lg.png" align="middle" width=70%></a><span><a href="../fav.html"><img src="../fav.png" align="right"  width=10% style="position:relative; top:10px;"></a></span><br/><br/><br/><div align="center"><span><a href="'+pno+'.htm"><img width="32px" height="32px" alt="" border="0" src="../prev.png"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a onclick="addfav()" style="font-size:24px; text-decoration:none; color:#000;">  <img src="../favadd.png" align="center"  width=10%></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="'+nno+'.htm"><img width="32px" height="32px" alt="" border="0" src="../next.png"></a></span></div>'
    if (document.body.firstChild)
      document.body.insertBefore(div, document.body.firstChild);
    else
      document.body.appendChild(div);
  }
  
	
function addfav()
{
	var str = 'Hymn '+ no;
	var favhymns = new Array();
	if (typeof localStorage['favhymns'] != 'undefined')
	{
		favhymns = JSON.parse(localStorage["favhymns"]);
		var index = favhymns.length;
		favhymns[index] = new Array( str, window.location.href);
	}
	else
	{
		
		favhymns[0] = new Array( str, window.location.href );
	}
	localStorage["favhymns"] = JSON.stringify(favhymns);
	//window.location.href = '../fav.html';
	alert("Hymn Added to favourites");
}