        ��  ��                  �      �� ��     0         <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
  <assemblyIdentity
    name="CiaoSoftware.Ciao.Shell.Contacts"
    processorArchitecture="x86"
    version="5.1.0.0"
    type="win32"/>
  <description>Windows Shell</description>
  <dependency>
    <dependentAssembly>
        <assemblyIdentity
            type="win32"
            name="Microsoft.Windows.Common-Controls"
            version="6.0.0.0"
            processorArchitecture="x86"
            publicKeyToken="6595b64144ccf1df"
            language="*"
        />
    </dependentAssembly>
  </dependency>
  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
   <security>
     <requestedPrivileges>
      <requestedExecutionLevel level="asInvoker" uiAccess="false" />
     </requestedPrivileges>
   </security>
  </trustInfo>
  <asmv3:application xmlns:asmv3="urn:schemas-microsoft-com:asm.v3">
    <asmv3:windowsSettings
         xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">
      <dpiAware>True/PM</dpiAware>
    </asmv3:windowsSettings>
  </asmv3:application>
</assembly>
  ��  8   T E X T   D E F A U L T T P L       0         Welcome! This is the default template for HFS 2.3
template revision TR2.

Here below you'll find some options affecting the template.
Consider 1 is used for "yes", and 0 is used for "no".

DO NOT EDIT this template just to change options. It's a very bad way to do it, and you'll pay for it!
Correct way: in Virtual file system, right click on home/root, properties, diff template,
put this text [+special:strings]
and following all the options you want to change, using the same syntax you see here.

[+special:strings]
option.paged=1
COMMENT this option causes your file list to be paged by default

option.newfolder=1
option.move=1
option.comment=1
option.rename=1
COMMENT with these you can disable some features of the template. Please note this is not about user permissions, this is global!

[]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>{.!HFS.} %folder%</title>
	<link rel="stylesheet" href="/?mode=section&id=style.css" type="text/css">
    <script type="text/javascript" src="/?mode=jquery"></script>
	<link rel="shortcut icon" href="/favicon.ico">
	<style class='trash-me'>
	.onlyscript, button[onclick] { display:none; }
	</style>
    <script>
    // this object will store some %symbols% in the javascript space, so that libs can read them
    HFS = { folder:'{.js encode|%folder%.}', number:%number%, paged:{.!option.paged.} }; 
    </script>
	<script type="text/javascript" src="/?mode=section&id=lib.js"></script>
</head>
<body>
<!--{.comment|--><h1 style='margin-bottom:100em'>WARNING: this template is only to be used with HFS 2.3 (and macros enabled)</h1> <!--.} -->
{.$box panel.}
{.$list.}
</body>
</html>
<!-- Build-time: %build-time% -->

[list]
<div id='files_outer'>
	<div style='height:1.6em;'></div> {.comment| this is quite ugly, i know, but if i use any vertical padding with height:100% i'll get a scrollbar .} 
	{.if not| %number% |{: <div style='font-size:200%; padding:1em;'>{.!{.if|{.length|{.?search.}.}|No results|No files.}.}</div> :}|{:
        <form method='post'>
            <table id='files'>
            {.set|sortlink| {:<a href="{.trim|
                    {.get|url|sort=$1| {.if| {.{.?sort.} = $1.} |  rev={.not|{.?rev.} .} /if.} /get.}
                /trim.}">{.!$2.}{.if| {.{.?sort.} = $1.} | &{.if|{.?rev.}|u|d.}Arr;.}</a>:} .}
            <th>{.^sortlink|n|Name.}{.^sortlink|e|.extension.}
            <th>{.^sortlink|s|Size.}
            <th>{.^sortlink|t|Timestamp.}
            <th>{.^sortlink|d|Hits.}
            %list%
            </table>
        </form>
	:}.}
</div>

[box panel]
<div id='panel'>
    {.$box messages.}
    {.$box login.}
    {.$box folder.}
    {.$box search.}
    {.$box selection.}
    {.$box upload.}
    {.$box actions.}
    {.$box server info.}
</div>

[box messages] 
	<fieldset id='msgs'>
		<legend><img src="/~img10"> {.!Messages.}</legend>
		<ul style='padding-left:2em'>
		</ul>
	</fieldset>

[box login]		
	<fieldset id='login'>
		<legend><img src="/~img27"> {.!User.}</legend>
		<center>
		{.if| {.length|%user%.} |{:
            %user%
            {.if|{.can change pwd.} | 
                <button onclick='changePwd.call(this)' style='font-size:x-small;'>{.!Change password.}</button>
            .}
            :}
            | <a href="~login">{.!Login.}</a>
        .}
		</center>
	</fieldset>                                       

[box folder]
	<fieldset id='folder'>
		<legend><img src="/~img8"> {.!Folder.}</legend>

       <div style='float:right; position:relative; top:-1em; font-weight:bold;'>
		{.if| {.length|{.?search.}.} | <a href="."><img src="/~img14"> {.!Back.}</a>
		| {.if| {.%folder% != / .} | <a href=".."><img src="/~img14"> {.!Up.}</a> .}
		/if.}
		</div>

		<div id='breadcrumbs'>
		{.comment|we need this to start from 1 {.count|folder levels.}.}
		{.breadcrumbs|{:<a href="%bread-url%" {.if|{.length|%bread-name%.}|style='padding-left:{.calc|{.count|folder levels.}*0.7.}em;'.} /> {.if|{.length|%bread-name%.}|&raquo; %bread-name%|<img src="/~img1"> {.!Home.}.}</a>:} .}
       </div>
        
		<div id='folder-stats'>%number-folders% {.!folders.}, %number-files% {.!files.}, {.add bytes|%total-size%.}
		</div>
		
		{.123 if 2| <div id='foldercomment'>|{.commentNL|%folder-item-comment%.}|</div> .}
	</fieldset>

[box search]	
	{.if| {.get|can recur.} |
	<fieldset id='search'>
		<legend><img src="/~img3"> {.!Search.}</legend>
		<form style='text-align:center'>
			<input name='search' size='15' value="{.escape attr|{.?search.}.}">
			<input type='submit' value="{.!go.}">
		</form>
		<div style='margin-top:0.5em;' class='hidden popup'>
			<fieldset>
				<legend>{.!Where to search.}</legend>
					<input type='radio' name='where' value='fromhere' checked='true' />  {.!this folder and sub-folders.}
					<br><input type='radio' name='where' value='here' />  {.!this folder only.}
					<br><input type='radio' name='where' value='anywhere' />  {.!entire server.}
			</fieldset>
		</div>
	</fieldset>
	/if.}

[box selection]	
	<fieldset id='select' class='onlyscript'>
		<legend><img src="/~img15"> {.!Select.}</legend>
		<center>
    	<button onclick="
            var x = $('#files .selector');
            if (x.size() > x.filter(':checked').size())
                x.attr('checked', true).closest('tr').addClass('selected');
			else
                x.attr('checked', false).closest('tr').removeClass('selected');
			selectedChanged();
			">{.!All.}</button>
    	<button onclick="
            $('#files .selector').attr('checked', function(i,v){ return !v }).closest('tr').toggleClass('selected');
			selectedChanged();
            ">{.!Invert.}</button>
    	<button onclick='selectionMask.call(this)'>{.!Mask.}</button>
		<p style='display:none; margin-top:1em;'><span id='selected-number'>0</span> {.!items selected.}</p>
		</center>
	</fieldset>

[box upload]
	{.if| {.get|can upload.} |{:
		<fieldset id='upload'>
    		<legend><img src="/~img32"> {.!Upload.}</legend>
    		<form action="." method='post' enctype="multipart/form-data" style='text-align:right;'>
    		<input type='file' name='file' multiple style='display:block;' />
    		<input type='submit' value='{.!Upload.}' style='margin-top:0.5em;' />
    		</form>
		</fieldset>
	:}.}

[box actions]	
	<fieldset id='actions'>
		<legend><img src="/~img18"> {.!Actions.}</legend>
		<center>
		{.if|{.can mkdir.}|
		<button id='newfolderBtn' onclick='ezprompt(this.innerHTML, {type:"text"}, function(s){
				ajax("mkdir", {name:s});
		    });'>{.!New folder.}</button>
		.}
		{.if|{.can comment.}|
		<button id='commentBtn' onclick='setComment.call(this)'>{.!Comment.}</button>
		.}
		{.if|{.get|can delete.}|
		<button id='deleteBtn' onclick='if (confirm("{.!confirm.}")) submit({action:"delete"}, "{.get|url.}")'>{.!Delete.}</button>

		{.if|{.and|{.!option.move.}|{.can move.}.}| <button id='moveBtn' onclick='moveClicked()'>{.!Move.}</button> .}
		.}
		{.if|{.can rename.}|
		<button id='renameBtn' onclick='
            var a = selectedItems();
                if (a.size() != 1)
				return alert("You must select a single item to rename");
			ezprompt(this.innerHTML, {type:"text"}, function(s){
				ajax("rename", {from:getItemName(a[0]), to:s});
		    });'>{.!Rename.}</button>
		.}
		{.if|{.get|can archive.}|
		<button id='archiveBtn' onclick='if (confirm("{.!confirm.}")) submit({}, "{.get|url|mode=archive|recursive.}")'>{.!Archive.}</button>
		.}
		<a href="{.get|url|tpl=list|sort=|{.if not|{.length|{.?search.}.}|{:folders-filter=\|recursive:}.}.}">{.!Get list.}</a>
		</center>
	</fieldset>

[box server info]
	<fieldset id='serverinfo'>
		<legend><img src="/~img0"> {.!Server information.}</legend>
		<a href="http://www.rejetto.com/hfs/">HttpFileServer %version%</a>
		<br />{.!Server time.}: %timestamp%
		<br />{.!Server uptime.}: %uptime%
	</fieldset>


[+special:strings]
max s dl msg=There is a limit on the number of <b>simultaneous</b> downloads on this server.<br>This limit has been reached. Retry later.
retry later=Please, retry later.
item folder=in folder
no files=No files in this folder
no results=No items match your search query
confirm=Are you sure?

[style.css|no log]
body { font-family:tahoma, verdana, arial, helvetica, sans; font-weight:normal; font-size:9pt; background-color:#eef; }
html, body { padding:0; border:0; height:100%; }
html, body, p, form { margin:0 }
a { text-decoration:none; color:#47c; border:1px solid transparent; padding:0 0.1em; }
a:visited { color:#55F; }
a:hover { background-color:#fff; border-color:#47c; }
img { border-style:none }
fieldset { margin-bottom:0.7em; text-align:left; padding:0.6em; }

#panel { float:left; margin-top:1em; margin-left:1em; max-width:250px; }
#panel hr { width:80%; margin:1em auto; }
#files_outer { height:100%; overflow:auto; text-align:left; padding:0 1.6em; }
#files { background:#ddf; border:0; }
#files tr { background:#fff; }
#files tr.even { background:#eef; }
#files tr.selected { background:#bcf; }
#files td { padding:0.2em 0.5em; text-align:right; }
#files tr td:first-child { text-align:left; }
#files th { padding:0.5em 1em; background:#47c; text-align:center; }
#files th a { color:white; font-size:130%; }
#files th a:hover { background:transparent; border-color:#fff; color:#fff; font-size:130%; }
#files td:first-child { text-align:left; }
#files td.nosize { text-align:center; font-style:italic; }
#files .selector { display:none; }
#actions button { margin:0.2em; } 
#breadcrumbs { margin-top:1em; padding-left:0.5em; }
#breadcrumbs a { padding:0.15em 0; border-width:2px; display:block; word-break:break-all; }
#folder-stats, #foldercomment { margin-top:1em; padding-top:0.5em; border-top:1px solid #666;  }
#folder-stats { color:#666; text-align:center; }
#msgs { display:none; }
#msgs li:first-child { font-weight:bold; }
#pages span { padding-left:0.5em; padding-right:0.5em; cursor:pointer; }
#pages button { font-size:smaller; }
.selectedPage { font-weight:bold; font-size:larger; }
.hidden { display:none; }
                             
[file=folder=link|private]
	<tr class='{.if|{.mod|{.count|row.}|2.}|even.}'><td>
        <input type='checkbox' class='selector' name='selection' value="%item-url%" {.if not|{.or|{.get|can delete.}|{.get|can access.}|{.get|can archive item.}.}|disabled='disabled'.} />
		{.if|{.get|is new.}|<span class='flag'>&nbsp;NEW&nbsp;</span>.}
		{.if not|{.get|can access.}|<img src='/~img_lock'>.}
		<a href="%item-url%"><img src="%item-icon%"> %item-name%</a>
		{.if| {.length|{.?search.}.} |{:{.123 if 2|<div class='item-folder'>{.!item folder.} |{.breadcrumbs|{:<a href="%bread-url%">%bread-name%/</a>:}|from={.count substring|/|%folder%.}/breadcrumbs.}|</div>.}:} .}
		{.123 if 2|<div class='comment'>|{.commentNL|%item-comment%.}|</div>.}

[+file]
<td>%item-size%B<td>%item-modified%<td>%item-dl-count%

[+folder]
<td class='nosize'>{.!folder-item|folder.}<td>%item-modified%<td>%item-dl-count%

[+link]
<td class='nosize'>link<td colspan='2'>

[error-page]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html>
  <head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <style type="text/css">
  {.$style.css.}
  </style>
  </head>
<body>
%content%
<hr>
<div style="font-family:tahoma, verdana, arial, helvetica, sans; font-size:8pt;">
<a href="http://www.rejetto.com/hfs/">HttpFileServer %version%</a>
<br>%timestamp%
</div>
</body>
</html>

[not found]
<h1>{.!Not found.}</h1>
<a href="/">{.!go to root.}</a>

[overload]
<h1>{.!Server Too Busy.}</h1>
{.!The server is too busy to handle your request at this time. Retry later.}

[max contemp downloads]
<h1>{.!Download limit.}</h1>
{.!max s dl msg.}
<br>({.disconnection reason.})

[unauthorized]
<h1>{.!Unauthorized.}</h1>
{.!Either your user name and password do not match, or you are not permitted to access this resource..}

[deny]
<h1>{.!Forbidden.}</h1>
{.or|%reason%|{.!This resource is not accessible..}.}

[ban]
<h1>{.!You are banned.}</h1>
%reason%

[upload]

[upload-file]

[upload-results]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>HFS %folder%</title>
	<link rel="stylesheet" href="/?mode=section&id=style.css" type="text/css">
	<style>
	li {list-style-image:url(/~img7); padding-bottom:1em; }
    li.bad { list-style-image:url(/~img11); }
	ul { border:1px solid #999; border-left:0; border-right:0; padding-top:1em; }
	a.back { display: block; width: 10em; white-space:nowrap; padding:0.3em 0.5em; margin-top:1em; }
    </style>
</head>
<body style='margin:2em;'>
<h1>{.!Upload results.}</h1>
{.or|{.^ok.}|0.} {.!files uploaded correctly..}
{.123 if 2|<br /> |{.^ko.}| files failed..}
<a href="." class='back'><img src="/~img14"> {.!Back.}</a>
{.^back.}
<ul>
%uploaded-files%
</ul>
<a href="." class='back'><img src="/~img14"> {.!Back.}</a>
</body>
</html>

[upload-success]
{.inc|ok.}
<li> <a href="%item-url%">%item-name%</a>
<br />%item-size% @ %smart-speed%B/s
{.if| {.length|%user%.} |{: {.append| %folder-resource%\hfs.comments.txt |{.filename|%item-resource%.}=uploaded by %user%
/append.} :}/if.}

[upload-failed]
{.inc|ko.}
<li class='bad'>%item-name%
<br />{.!%reason%.}

[progress|no log]
<style>
#progress .fn { font-weight:bold; }
.out_bar { margin-top:0.25em; width:100px; font-size:15px; background:#fff; border:#555 1px solid; margin-right:5px; float:left; }
.in_bar { height:0.5em; background:#47c;  }
</style>
<ul style='padding-left:1.5em;'>
%progress-files%
</ul>

[progress-nofiles]
{.!No file exchange in progress..}

[progress-upload-file]
{.if not|{.{.?only.} = down.}|{:
	<li> {.!Uploading.} %total% @ %speed-kb% KB/s
	<br /><span class='fn'>%filename%</span>
    <br />{.!Time left.} %time-left%"
	<br /><div class='out_bar'><div class='in_bar' style="width:%perc%px"></div></div> %perc%%
:}.}

[progress-download-file]
{.if not|{.{.?only.} = up.}|{:
	<li> Downloading %total% @ %speed-kb% KB/s
	<br /><span class='fn'>%filename%</span>
    <br />{.!Time left.} %time-left%"
	<br><div class='out_bar'><div class='in_bar' style="width:%perc%px"></div></div> %perc%%
:}.}

[ajax.mkdir|no log]
{.check session.}
{.set|x|{.postvar|name.}.}
{.break|if={.pos|\|var=x.}{.pos|/|var=x.}|result=forbidden.}
{.break|if={.not|{.can mkdir.}.}|result=not authorized.}
{.set|x|{.force ansi|%folder%{.^x.}.}.}
{.break|if={.exists|{.^x.}.}|result=exists.}
{.break|if={.not|{.length|{.mkdir|{.^x.}.}.}.}|result=failed.}
{.add to log|User %user% created folder "{.^x.}".}
{.pipe|ok.}

[ajax.rename|no log]
{.check session.}
{.break|if={.not|{.can rename.}.}|result=forbidden.}
{.break|if={.is file protected|{.postvar|from.}.}|result=forbidden.}
{.break|if={.is file protected|{.postvar|to.}.}|result=forbidden.}
{.set|x|{.force ansi|%folder%{.postvar|from.}.}.}
{.set|y|{.force ansi|%folder%{.postvar|to.}.}.}
{.break|if={.not|{.exists|{.^x.}.}.}|result=not found.}
{.break|if={.exists|{.^y.}.}|result=exists.}
{.break|if={.not|{.length|{.rename|{.^x.}|{.^y.}.}.}.}|result=failed.}
{.add to log|User %user% renamed "{.^x.}" to "{.^y.}".}
{.pipe|ok.}

[ajax.move|no log]
{.check session.}
{.set|dst|{.force ansi|{.postvar|dst.}.}.}
{.break|if={.not|{.and|{.can move.}|{.get|can delete.}|{.get|can upload|path={.^dst.}.}/and.}.} |result={.!forbidden.}.}
{.set|log|{.!Moving items to.} {.^dst.}.}
{.for each|fn|{.replace|:|{.no pipe||.}|{.force ansi|{.postvar|files.}.}.}|{:
    {.break|if={.is file protected|var=fn.}|result=forbidden.}
    {.set|x|{.force ansi|%folder%.}{.^fn.}.}
    {.set|y|{.^dst.}/{.^fn.}.}
    {.if not |{.exists|{.^x.}.}|{.^x.}: {.!not found.}|{:
        {.if|{.exists|{.^y.}.}|{.^y.}: {.!already exists.}|{:
            {.set|comment| {.get item|{.^x.}|comment.} .}
            {.set item|{.^x.}|comment=.} {.comment| this must be done before moving, or it will fail.}
            {.if|{.length|{.move|{.^x.}|{.^y.}.}.} |{:
                {.move|{.^x.}.md5|{.^y.}.md5.}
                {.set|log|{.chr|13.}{.^fn.}|mode=append.}
                {.set item|{.^y.}|comment={.^comment.}.}
            :} | {:
                {.set|log|{.chr|13.}{.^fn.} (failed)|mode=append.}
                {.maybe utf8|{.^fn.}.}: {.!not moved.}
            :}/if.}
        :}/if.}
    :}.}
    ;
:}.}
{.add to log|{.^log.}.}

[ajax.comment|no log]
{.check session.}
{.break|if={.not|{.can comment.}.} |result=forbidden.}
{.for each|fn|{.replace|:|{.no pipe||.}|{.postvar|files.}.}|{:
     {.break|if={.is file protected|var=fn.}|result=forbidden.}
     {.set item|{.force ansi|%folder%{.^fn.}.}|comment={.encode html|{.force ansi|{.postvar|text.}.}.}.}
:}.}
{.pipe|ok.}

[ajax.changepwd|no log]
{.check session.}
{.break|if={.not|{.can change pwd.}.} |result=forbidden.}
{.if|{.length|{.set account||password={.force ansi|{.postvar|new.}.}.}/length.}|ok|failed.}

[special:alias]
check session=if|{.{.cookie|HFS_SID_.} != {.postvar|token.}.}|{:{.cookie|HFS_SID_|value=|expires=-1.} {.break|result=bad session}:}
can mkdir=and|{.get|can upload.}|{.!option.newfolder.}
can comment=and|{.get|can upload.}|{.!option.comment.}
can rename=and|{.get|can delete.}|{.!option.rename.}
can change pwd=member of|can change password
can move=or|1|1
escape attr=replace|"|&quot;|$1
commentNL=if|{.pos|<br|$1.}|$1|{.replace|{.chr|10.}|<br />|$1.}
add bytes=switch|{.cut|-1||$1.}|,|0,1,2,3,4,5,6,7,8,9|$1 {.!Bytes.}|K,M,G,T|$1{.!Bytes.}

[special:import]
{.new account|can change password|enabled=1|is group=1|notes=accounts members of this group will be allowed to change their password.}

[lib.js|no log]
// <script> // this is here for the syntax highlighter

function outsideV(e, additionalMargin) {
    outsideV.w || (outsideV.w = $(window));
    if (!(e instanceof $))
        e = $(e);
    return e.offset().top + e.height() > outsideV.w.height() - (additionalMargin || 0) - 17;
} // outsideV

function quotedString(s) { return '"'+s.replace(/(['"\\])/g, "\\$1")+'"' }

$(function(){
    // make these links into buttons for homogeneity
    $('#actions a').replaceWith(function(){ return "<button onclick='location = "+quotedString(this.getAttribute('href'))+"'>"+this.innerHTML+"</button>"; });
    // selecting functionality
    $('#files .selector').show().change(function(){
        $(this).closest('tr').toggleClass('selected');
        selectedChanged();
    });
    $('.trash-me').detach(); // this was hiding things for those w/o js capabilities
    // infinite upload fields available
    var x = $('input[type=file]');
    x.change(function(){
        if ($(this).data('fired')) return;
        $(this).data('fired',1);
        fileTpl.clone(true).insertAfter(this).css('display','block');
    });
    // we must create an empty "template", by cloning before it's set to a file, because on some browsers (Opera 10) emptying the value run-time is not allowed.
    // this must be done after the above instruction, so we'll clone also the behavior. 
    var fileTpl = x.clone(true).css('display','none');

    var x = $('#upload');
    if  (x.size()) {
        // make it popup by button, so we save some vertical space and avoid some scrollbar
        x.hide(); 
        $('#actions button:first').before(
            $("<button>{.!Upload.}</button>").click(function(){ 
                $(this).slideUp(); x.fadeIn(); 
            })
        );
        // on submit			
        x.find('form').submit(function(){ 
            if (!$("[name=file]").val()) return false; // no file, no submit
            $(this).hide(); // we don't need the form anymore, make space for the progress bars
            // build the gui
            x.append("<div id='progress'>{.!in progress....}</div>");
            x.append($("<button style='float:right'>{.!Cancel.}</button>").click(function(){
                // stop submit/upload
                if (typeof stop == 'function')
                    stop(); 
                else
                    document.execCommand("Stop");
                $(this).add($("#progress")).remove(); // remove progress indicators and this button too
                $("#upload form").slideDown(); // re-show the form
            }));

            // refresh information
            function updateProgress() {
                var now = new Date();
                if (now-updateProgress.last < updateProgress.refresh*3) return; // until the request is fulfilled, we give it 3 times the refresh time
                updateProgress.last = now;
                $.get('/?mode=section&id=progress&only=up', function(txt) {
                    if (!txt) return;
                    var x = $('#progress');
                    if (!x.size()) return clearInterval(updateProgress.handle);
                    if (txt.indexOf('<li>') >= 0) x.html(txt);
                    updateProgress.last = 0;
                });
            }//updateProgress
            updateProgress.refresh = 3; // choose the time, in seconds
            updateProgress.refresh *= 1000; // javascript wants it in milliseconds
            updateProgress.handle = setInterval(updateProgress, updateProgress.refresh);
            return true;
        });
    }

    // search options appear when it gets focus
    $('#search').focusin(function(evt){
        inSearch = 1;
        if (evt.target.getAttribute('type') == 'submit') return; // the submitter button won't expand the popup, but sets the flag to avoid the popup to be closed
        $("#search .popup").slideDown();
    }).focusout(function(evt){
        inSearch = 0;
        setTimeout(function(){
            if (!inSearch)
                $("#search .popup").fadeOut();
        });
    });
    $('#search form').submit(function(){
        var s = $(this).find('[name=search]').val();
        var a = '';
        var ps = [];
        switch ($('[name=where]:checked').val()) {
            case 'anywhere': 
                a = '/';
            case 'fromhere':
                ps.push('search='+s);
                break;
            case 'here':
                if (s.indexOf('*') < 0) s = '*'+s+'*';
                ps.push('files-filter='+s);
                ps.push('folders-filter='+s);
                break;
        }
        location = a+'?'+ps.join('&');
        return false;
    });
    
    // workaround for those browsers not supporting :first-child selector used in style
    if ($('#files td:first').css('text-align') != 'left')
        $('#files tr td:first-child').css('text-align','left');

    // here we make some changes trying to make the panel fit the window
    var removed = 0;
    var e = $('#panel'); 
    while (outsideV(e)) {
        switch (++removed) {
            case 1: $('#serverinfo').hide(); continue;
            case 2: $('#select').hide(); continue;
            case 3: $('#breadcrumbs a').css({display:'inline',paddingLeft:0}); continue;
            case 4: $('#login').replaceWith($('#login center').prepend('<img src="/~img27">')); continue;
        }
        break; // give up
    }
    if (HFS.paged)
        if (getCookie('paged') == 'no')
            addPagingButton('#actions button:first');
        else
            pageIt();
               
    {.$more onload.}
    selectedChanged();
    // darn you ie6!
    if (!$.browser.msie || $.browser.version > 6) return;
    $('fieldset').width('250px').after('<br>');
    $('#panel').css('margin-right','1.5em');
    $('a').css('border-width','0');
    setTimeout(pageIt, 500); // at this time the page is not correctly formatted in IE6
});//onload

function ajax(method, data, cb) {
	if (!data)
		data = {};
	data.token = "{.cookie|HFS_SID_.}";
	return $.post("?mode=section&id=ajax."+method, data, cb||getStdAjaxCB());
}//ajax

function addPagingButton(where) {
    $("<button>{.!Paged list.}</button>").insertBefore(where || '#files').click(function(){
        $(this).remove();
        pageIt(true);
        delCookie('paged');
    });
}//addPagingButton

function pageIt(anim) {
    var rows = $('#files tr');
    if (!rows.size()) return;
    
    page = 0; // this is global
    var pages = $("<div id='pages'>{.!Page.} </div>").css('visibility','hidden').insertBefore('#files');
    var pageSize = 0;
    while (!outsideV(rows[pageSize], 20))
        if (++pageSize >= rows.size())
            return pages.remove();
    if (pageSize == 0) return; // this happens when the page is not formatted at this exact time, and the table is misplaced 

    Npages = Math.ceil(HFS.number / pageSize);
    if (Npages == 1)
        return pages.remove();
    $('#files').width($('#files').width()); // hold it still

    var s = '';
    for (var i=1; i <= Npages; i++)
        s += '<span>'+i+'</span> ';
    s = $(s);
    s.appendTo(pages).click(function(){
        page = Number(this.innerHTML)-1;
        $('#files tr:gt(0):visible').hide();
        $('#files tr:gt('+(page*pageSize)+'):lt('+pageSize+')').show();
        pages.find('span').removeClass('selectedPage').filter(':nth('+page+')').addClass('selectedPage');
    });
    s.first().addClass('selectedPage');		
    $('#files tr:gt('+((page+1)*pageSize)+')').hide();
    pages.append($("<button type='button'>{.!No pages.}</button>").click(function(){
        pages.slideUp(function(){ pages.remove(); });
        $('#files tr:hidden').show();
        addPagingButton();
        setCookie('paged', 'no');
    }));
    pages.css({visibility:'', display:'none'});
    if (anim) pages.slideDown()
    else pages.show();		
}//pageIt

function selectedChanged() {
    $("#selected-number").text( selectedItems().size() ).parent().show();
} // selectedChanged

function getItemName(el) {
    if (typeof el == 'undefined')
        return false;
    // we handle elements, not jquery sets
    if (el.jquery)
        if (el.size())
            el = el[0];
        else
            return false;
    // take the url, and ignore any #anchor part
    var s = el.getAttribute('href') || el.getAttribute('value');
    s = s.split('#')[0];
    // remove protocol and hostname
    var i = s.indexOf('://');
    if (i > 0)
        s = s.slice(s.indexOf('/',i+3));
    // current folder is specified. Remove it.
    if (s.indexOf(HFS.folder) == 0)
        s = s.slice(HFS.folder.length);
    // folders have a trailing slash that's not truly part of the name
    if (s.slice(-1) == '/')
        s = s.slice(0,-1);
    // it is encoded
    s = (decodeURIComponent || unescape)(s);        
    return s;
} // getItemName

function submit(data, url) {
    var f = $('#files').closest('form');
    if (url) f.attr('action', url);
    f.find('.temp').remove();
    for (var k in data)
        f.append("<input class='temp' type='hidden' name='"+k+"' value='"+data[k]+"' />");
    f.submit();
}//submit

function putMsg(txt, time) {
    if (!time) time = 4000;
    var msgs = $('#msgs');
    msgs.slideDown();
    if (msgs.find('ul li:first').html() == txt)
        clearTimeout(lastTimeoutID);
    else
        msgs.find('ul').prepend("<li>"+txt+"</li>");
    lastTimeoutID = setTimeout("$('#msgs li:last').fadeOut(function(){$(this).detach(); if (!$('#msgs li').size()) $('#msgs').slideUp(); });", time);
}//putMsg

RegExp.escape = function(text) {
    if (!arguments.callee.sRE) {
        var specials = '/.*+?|()[]{}\\'.split('');
        arguments.callee.sRE = new RegExp('(\\' + specials.join('|\\') + ')', 'g');
    }
    return text.replace(arguments.callee.sRE, '\\$1');
}//escape

function include(url, type) {
    $.ajaxSetup({async: false}); // we'll wait.
    if (!type)
        type = /[^.]+$/.exec(url);
    var res;
    if  (type == 'js')
        res = $.getScript(url);
    else res = $.get(url, function(){ 
        if (type == 'css')
            $('head').append('<link rel="stylesheet" href="'+url+'" type="text/css" />');
    });
    $.ajaxSetup({async: true}); // restore it
    return res.responseText;
}//include

function ezprompt(msg, options, cb) {
    // 2 parameters means "options" is missing
    if (arguments.length == 2) {
        cb = options;
        options = {};
    }
    if (!$.prompt) { // load on demand
        include('/?mode=section&id=impromptu.css');
        include('/?mode=section&id=jquery.impromptu.js');
    }
    var v;
    if (v = options.type) {
        msg += '<br />';
        if (v == 'textarea')
            msg += '<textarea name="txt" cols="30" rows="8">'+options['default']+'</textarea>';
        else
            msg += '<input name="txt" type="'+v+'"'
                + ((v = options['default']) ? ' value="'+v+'"' : '')
                + ' />';
    }
    $.prompt(msg, {
        opacity: 0.9,
        overlayspeed: 'fast',
        loaded: function(){
            $('#jqibox').find(':input').keypress(function (e) {
                var c = (e.keyCode || e.which);
                if (options.keypress && options.keypress(c, this, e) === false) return;
                if (c != 13 || this.tagName == 'TEXTAREA') return; // ENTER key is like submit, but not in textarea
                $('.jqibuttons button:first').click();
                return false;
            }).filter(':first').focus()[0].select();
        },
        submit: function(val,div,form) {
            var res = cb(options.type ? $.trim(form.txt) : form, $('#jqibox'), options.cbData );
            if (res === false) {
                $('#jqibox').find(':input:first').focus();
                return false;
            }
            return true;
        }, 
        fadeClicked: function() { $('#jqibox').find(':input:first').focus(); }
    });
}//ezprompt

// this is a factory for ajax request handlers
function getStdAjaxCB(what2do) {
    if (!arguments.length)
        what2do = true;
    return function(res){
        res = $.trim(res);

        if (res !== "ok") {
            alert("{.!Error.}: "+res);
            if (res === 'bad session')
                location.reload();
            return;
        }
        // what2do is a list of actions we are supposed to do if the ajax result is "ok"
        if (typeof what2do == 'undefined') 
            return;            
        if (!$.isArray(what2do))
            what2do = [what2do];
        for (var i=0; i<what2do.length; i++) {
            var w = what2do[i];
            switch (typeof w) {
                case 'function': w(); break; // you specify exactly what to do
                case 'string':
                    switch (w[0]) {
                        case '!': alert(w.substr(1)); break;
                        case '>': location = w.substr(1); break;
                        default: putMsg(w); break;
                    }
                case 'boolean': if (w) location = location; break;
            }
        }
    }
}//getStdAjaxCB
        
function changePwd() {
    ezprompt(this.innerHTML, {type:'password'}, function(s){
        if (s) ajax('changepwd', {'new':s}, getStdAjaxCB([
            "!{.!Password changed, you'll have to login again..}", 
            '>~login'
        ]));
    });
}//changePwd

function selectedItems() { return $('#files .selector:checked') }

function selectedFilesAsStr() {
    var a = [];
    selectedItems().each(function(){
        a.push(getItemName(this));
    });
    return a.join(":");
}//selectedFilesAsStr

function setComment() {
    var sel = selectedItems();
    if (!sel.size())
        return putMsg("{.!No file selected.}");
    var def = sel.closest('tr').find('.comment').html() || '';
    ezprompt(this.innerHTML, {type:'textarea', 'default':def}, function(s){
        if (s == def && sel.size() == 1) return true; // there s no work to do
        ajax('comment', {text:s, files:selectedFilesAsStr()});
    });
}//setComment

function moveClicked() {
    ezprompt("{.!Enter the destination folder.}", {type:'text'}, function(s){
        ajax('move', {dst:s, files:selectedFilesAsStr()}, function(res){
            var a = res.split(";");
            if (a.length < 2)
                return alert($.trim(res));
            var failed = 0;
            var ok = 0;
            var msg = "";
            for (var i=0; i<a.length-1; i++) {
                var s = $.trim(a[i]);
                if (!s.length) {
                    ok++;
                    continue;
                }
                failed++;
                msg += s+"\n";
            }
            if (failed) 
                msg = "{.!We met the following problems:.}\n"+msg;
            msg = (ok ? ok+" {.!files were moved..}\n" : "{.!No file was moved..}\n")+msg;
            alert(msg);
            if (ok) location = location; // reload
        });
    });
}//moveClicked

function selectionMask() {
    ezprompt('{.!Please enter the file mask to select.}', {'type':'text', 'default':'*'}, function(s){
        if (!s) return false;
        var re = s.match('^/([^/]+)/([a-zA-Z]*)');
        if (re)
            re = new RegExp(re[1], re[2]);
        else {
            var n = s.match(/^(\\*)/)[0].length;
            s = s.substring(n);
            var invert = !!(n % 2); // a leading "\" will invert the logic
            s = RegExp.escape(s).replace(/[?]/g,".");;
            if (s.match(/\\\*/)) {
                s = s.replace(/\\\*/g,".*");
                s = "^ *"+s+" *$";   // in this case let the user decide exactly how it is placed in the string  
            }
            re = new RegExp(s, "i");
        }
        $("#files .selector")
            .filter(function(){ return invert ^ re.test(getItemName(this)); })
            .closest('tr').addClass("selected").find('.selector').attr('checked',true);
        selectedChanged();
    }); 
}//selectionMask

function setCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
} // setCookie

function getCookie(name) {    
    var a = document.cookie.match(new RegExp('(^|;\s*)('+name+'=)([^;]*)'));
    return (a && a[2]) ? a[3] : null;
} // getCookie

function delCookie(name) {
	setCookie(name,"",-1);
} // delCookie


[jquery.impromptu.js|no log]
/*
 * jQuery Impromptu
 * By: Trent Richardson [http://trentrichardson.com]
 * Version 2.7
 * Last Modified: 6/7/2009
 * 
 * Copyright 2009 Trent Richardson
 * Dual licensed under the MIT and GPL licenses.
 * http://trentrichardson.com/Impromptu/GPL-LICENSE.txt
 * http://trentrichardson.com/Impromptu/MIT-LICENSE.txt
 * 
 */
 
(function($) {
	$.prompt = function(message, options) {
		options = $.extend({},$.prompt.defaults,options);
		$.prompt.currentPrefix = options.prefix;

		var ie6		= ($.browser.msie && $.browser.version < 7);
		var $body	= $(document.body);
		var $window	= $(window);

		//build the box and fade
		var msgbox = '<div class="'+ options.prefix +'box" id="'+ options.prefix +'box">';
		if(options.useiframe && (($('object, applet').length > 0) || ie6)) {
			msgbox += '<iframe src="javascript:false;" style="display:block;position:absolute;z-index:-1;" class="'+ options.prefix +'fade" id="'+ options.prefix +'fade"></iframe>';
		} else {
			if(ie6) {
				$('select').css('visibility','hidden');
			}
			msgbox +='<div class="'+ options.prefix +'fade" id="'+ options.prefix +'fade"></div>';
		}
		msgbox += '<div class="'+ options.prefix +'" id="'+ options.prefix +'"><div class="'+ options.prefix +'container"><div class="';
		msgbox += options.prefix +'close">X</div><div id="'+ options.prefix +'states"></div>';
		msgbox += '</div></div></div>';

		var $jqib	= $(msgbox).appendTo($body);
		var $jqi	= $jqib.children('#'+ options.prefix);
		var $jqif	= $jqib.children('#'+ options.prefix +'fade');

		//if a string was passed, convert to a single state
		if(message.constructor == String){
			message = {
				state0: {
					html: message,
				 	buttons: options.buttons,
				 	focus: options.focus,
				 	submit: options.submit
			 	}
		 	};
		}

		//build the states
		var states = "";

		$.each(message,function(statename,stateobj){
			stateobj = $.extend({},$.prompt.defaults.state,stateobj);
			message[statename] = stateobj;

			states += '<div id="'+ options.prefix +'_state_'+ statename +'" class="'+ options.prefix + '_state" style="display:none;"><div class="'+ options.prefix +'message">' + stateobj.html +'</div><div class="'+ options.prefix +'buttons">';
			$.each(stateobj.buttons, function(k, v){
				states += '<button name="' + options.prefix + '_' + statename + '_button' + k + '" id="' + options.prefix +	'_' + statename + '_button' + k + '" value="' + v + '">' + k + '</button>';
			});
			states += '</div></div>';
		});

		//insert the states...
		$jqi.find('#'+ options.prefix +'states').html(states).children('.'+ options.prefix +'_state:first').css('display','block');
		$jqi.find('.'+ options.prefix +'buttons:empty').css('display','none');
		
		//Events
		$.each(message,function(statename,stateobj){
			var $state = $jqi.find('#'+ options.prefix +'_state_'+ statename);

			$state.children('.'+ options.prefix +'buttons').children('button').click(function(){
				var msg = $state.children('.'+ options.prefix +'message');
				var clicked = stateobj.buttons[$(this).text()];
				var forminputs = {};

				//collect all form element values from all states
				$.each($jqi.find('#'+ options.prefix +'states :input').serializeArray(),function(i,obj){
					if (forminputs[obj.name] === undefined) {
						forminputs[obj.name] = obj.value;
					} else if (typeof forminputs[obj.name] == Array) {
						forminputs[obj.name].push(obj.value);
					} else {
						forminputs[obj.name] = [forminputs[obj.name],obj.value];	
					} 
				});

				var close = stateobj.submit(clicked,msg,forminputs);
				if(close === undefined || close) {
					removePrompt(true,clicked,msg,forminputs);
				}
			});
			$state.find('.'+ options.prefix +'buttons button:eq('+ stateobj.focus +')').addClass(options.prefix +'defaultbutton');

		});

		var ie6scroll = function(){
			$jqib.css({ top: $window.scrollTop() });
		};

		var fadeClicked = function(){
			if(options.persistent){
			    if (options.fadeClicked() === false) return; // mod by rejetto
				var i = 0;
				$jqib.addClass(options.prefix +'warning');
				var intervalid = setInterval(function(){
					$jqib.toggleClass(options.prefix +'warning');
					if(i++ > 1){
						clearInterval(intervalid);
						$jqib.removeClass(options.prefix +'warning');
					}
				}, 100);
			}
			else {
				removePrompt();
			}
		};
		
		var keyPressEventHandler = function(e){
			var key = (window.event) ? event.keyCode : e.keyCode; // MSIE or Firefox?
			
			//escape key closes
			if(key==27) {
				removePrompt();	
			}
			
			//constrain tabs
			if (key == 9){
				var $inputels = $(':input:enabled:visible',$jqib);
				var fwd = !e.shiftKey && e.target == $inputels[$inputels.length-1];
				var back = e.shiftKey && e.target == $inputels[0];
				if (fwd || back) {
				setTimeout(function(){ 
					if (!$inputels)
						return;
					var el = $inputels[back===true ? $inputels.length-1 : 0];

					if (el)
						el.focus();						
				},10);
				return false;
				}
			}
		};
		
		var positionPrompt = function(){
			$jqib.css({
				position: (ie6) ? "absolute" : "fixed",
				height: $window.height(),
				width: "100%",
				top: (ie6)? $window.scrollTop() : 0,
				left: 0,
				right: 0,
				bottom: 0
			});
			$jqif.css({
				position: "absolute",
				height: $window.height(),
				width: "100%",
				top: 0,
				left: 0,
				right: 0,
				bottom: 0
			});
			$jqi.css({
				position: "absolute",
				top: options.top,
				left: "50%",
				marginLeft: (($jqi.outerWidth()/2)*-1)
			});
		};

		var stylePrompt = function(){
			$jqif.css({
				zIndex: options.zIndex,
				display: "none",
				opacity: options.opacity
			});
			$jqi.css({
				zIndex: options.zIndex+1,
				display: "none"
			});
			$jqib.css({
				zIndex: options.zIndex
			});
		};

		var removePrompt = function(callCallback, clicked, msg, formvals){
			$jqi.remove();
			//ie6, remove the scroll event
			if(ie6) {
				$body.unbind('scroll',ie6scroll);
			}
			$window.unbind('resize',positionPrompt);
			$jqif.fadeOut(options.overlayspeed,function(){
				$jqif.unbind('click',fadeClicked);
				$jqif.remove();
				if(callCallback) {
					options.callback(clicked,msg,formvals);
				}
				$jqib.unbind('keypress',keyPressEventHandler);
				$jqib.remove();
				if(ie6 && !options.useiframe) {
					$('select').css('visibility','visible');
				}
			});
		};

		positionPrompt();
		stylePrompt();
		
		//ie6, add a scroll event to fix position:fixed
		if(ie6) {
			$window.scroll(ie6scroll);
		}
		$jqif.click(fadeClicked);
		$window.resize(positionPrompt);
		$jqib.bind("keydown keypress",keyPressEventHandler);
		$jqi.find('.'+ options.prefix +'close').click(removePrompt);

		//Show it
		$jqif.fadeIn(options.overlayspeed);
		$jqi[options.show](options.promptspeed,options.loaded);
		$jqi.find('#'+ options.prefix +'states .'+ options.prefix +'_state:first .'+ options.prefix +'defaultbutton').focus();
		
		if(options.timeout > 0)
			setTimeout($.prompt.close,options.timeout);

		return $jqib;
	};
	
	$.prompt.defaults = {
		prefix:'jqi',
		buttons: {
			Ok: true
		},
	 	loaded: function(){

	 	},
	  	submit: function(){
	  		return true;
		},
	 	callback: function(){

	 	},
		opacity: 0.6,
	 	zIndex: 9999,
	  	overlayspeed: 'slow',
	   	promptspeed: 'fast',
   		show: 'fadeIn',
	   	focus: 0,
	   	useiframe: false,
	 	top: "15%",
	  	persistent: true,
	  	timeout: 0,
	  	state: {
			html: '',
		 	buttons: {
		 		Ok: true
		 	},
		  	focus: 0,
		   	submit: function(){
		   		return true;
		   }
	  	}
	};
	
	$.prompt.currentPrefix = $.prompt.defaults.prefix;

	$.prompt.setDefaults = function(o) {
		$.prompt.defaults = $.extend({}, $.prompt.defaults, o);
	};
	
	$.prompt.setStateDefaults = function(o) {
		$.prompt.defaults.state = $.extend({}, $.prompt.defaults.state, o);
	};
	
	$.prompt.getStateContent = function(state) {
		return $('#'+ $.prompt.currentPrefix +'_state_'+ state);
	};
	
	$.prompt.getCurrentState = function() {
		return $('.'+ $.prompt.currentPrefix +'_state:visible');
	};
	
	$.prompt.getCurrentStateName = function() {
		var stateid = $.prompt.getCurrentState().attr('id');
		
		return stateid.replace($.prompt.currentPrefix +'_state_','');
	};
	
	$.prompt.goToState = function(state) {
		$('.'+ $.prompt.currentPrefix +'_state').slideUp('slow');
		$('#'+ $.prompt.currentPrefix +'_state_'+ state).slideDown('slow',function(){
			$(this).find('.'+ $.prompt.currentPrefix +'defaultbutton').focus();
		});
	};
	
	$.prompt.nextState = function() {
		var $next = $('.'+ $.prompt.currentPrefix +'_state:visible').next();

		$('.'+ $.prompt.currentPrefix +'_state').slideUp('slow');
		
		$next.slideDown('slow',function(){
			$next.find('.'+ $.prompt.currentPrefix +'defaultbutton').focus();
		});
	};
	
	$.prompt.prevState = function() {
		var $next = $('.'+ $.prompt.currentPrefix +'_state:visible').prev();

		$('.'+ $.prompt.currentPrefix +'_state').slideUp('slow');
		
		$next.slideDown('slow',function(){
			$next.find('.'+ $.prompt.currentPrefix +'defaultbutton').focus();
		});
	};
	
	$.prompt.close = function() {
		$('#'+ $.prompt.currentPrefix +'box').fadeOut('fast',function(){
        		$(this).remove();
		});
	};
	
})(jQuery);

[impromptu.css|no log]
/*
------------------------------
	Impromptu's
------------------------------
*/
.jqifade{
	position: absolute; 
	background-color: #aaaaaa; 
}
div.jqi{ 
	min-width: 300px; 
	max-width: 600px; 
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; 
	position: absolute; 
	background-color: #ffffff; 
	font-size: 11px; 
	text-align: left; 
	border: solid 1px #eeeeee;
	-moz-border-radius: 10px;
	-webkit-border-radius: 10px;
	padding: 7px;
}
div.jqi .jqicontainer{ 
	font-weight: bold; 
}
div.jqi .jqiclose{ 
	position: absolute;
	top: 4px; right: -2px; 
	width: 18px; 
	cursor: default; 
	color: #bbbbbb; 
	font-weight: bold; 
}
div.jqi .jqimessage{ 
	padding: 10px; 
	line-height: 20px; 
	color: #444444; 
}
div.jqi .jqibuttons{ 
	text-align: right; 
	padding: 5px 0 5px 0; 
	border: solid 1px #eeeeee; 
	background-color: #f4f4f4;
}
div.jqi button{ 
	padding: 3px 10px; 
	margin: 0 10px; 
	background-color: #2F6073; 
	border: solid 1px #f4f4f4; 
	color: #ffffff; 
	font-weight: bold; 
	font-size: 12px; 
}
div.jqi button:hover{ 
	background-color: #728A8C;
}
div.jqi button.jqidefaultbutton{ 
	/*background-color: #8DC05B;*/
	background-color: #BF5E26;
}
.jqiwarning .jqi .jqibuttons{ 
	background-color: #BF5E26;
}

/*
------------------------------
	impromptu
------------------------------
*/
.impromptuwarning .impromptu{ background-color: #aaaaaa; }
.impromptufade{
	position: absolute;
	background-color: #ffffff;
}
div.impromptu{
    position: absolute;
	background-color: #cccccc;
	padding: 10px; 
	width: 300px;
	text-align: left;
}
div.impromptu .impromptuclose{
    float: right;
    margin: -35px -10px 0 0;
    cursor: pointer;
    color: #213e80;
}
div.impromptu .impromptucontainer{
	background-color: #213e80;
	padding: 5px; 
	color: #ffffff;
	font-weight: bold;
}
div.impromptu .impromptumessage{
	background-color: #415ea0;
	padding: 10px;
}
div.impromptu .impromptubuttons{
	text-align: center;
	padding: 5px 0 0 0;
}
div.impromptu button{
	padding: 3px 10px 3px 10px;
	margin: 0 10px;
}

/*
------------------------------
	columns ex
------------------------------
*/
.colsJqifadewarning .colsJqi{ background-color: #b0be96; }
.colsJqifade{
	position: absolute;
	background-color: #ffffff;
}
div.colsJqi{
    position: absolute;
	background-color: #d0dEb6;
	padding: 10px; 
	width: 400px;
	text-align: left;
}
div.colsJqi .colsJqiclose{
    float: right;
    margin: -35px -10px 0 0;
    cursor: pointer;
    color: #bbbbbb;
}
div.colsJqi .colsJqicontainer{
	background-color: #e0eEc6;
	padding: 5px; 
	color: #ffffff;
	font-weight: bold;
	height: 160px;
}
div.colsJqi .colsJqimessage{
	background-color: #c0cEa6;
	padding: 10px;
	width: 280px;
	height: 140px;
	float: left;
}
div.colsJqi .jqibuttons{
	text-align: center;
	padding: 5px 0 0 0;
}
div.colsJqi button{
	background: url(../images/button_bg.jpg) top left repeat-x #ffffff;
	border: solid #777777 1px;
	font-size: 12px;
	padding: 3px 10px 3px 10px;
	margin: 5px 5px 5px 10px;
	width: 75px;
}
div.colsJqi button:hover{
	border: solid #aaaaaa 1px;
}

/*
------------------------------
	brown theme
------------------------------
*/
.brownJqiwarning .brownJqi{ background-color: #cccccc; }
.brownJqifade{
	position: absolute;
	background-color: #ffffff;
}
div.brownJqi{
	position: absolute;
	background-color: transparent;
	padding: 10px;
	width: 300px;
	text-align: left;
}
div.brownJqi .brownJqiclose{
    float: right;
    margin: -20px 0 0 0;
    cursor: pointer;
    color: #777777;
    font-size: 11px;
}
div.brownJqi .brownJqicontainer{
	position: relative;
	background-color: transparent;
	border: solid 1px #5F5D5A;
	color: #ffffff;
	font-weight: bold;
}
div.brownJqi .brownJqimessage{
	position: relative;
	background-color: #F7F6F2;
	border-top: solid 1px #C6B8AE;
	border-bottom: solid 1px #C6B8AE;
}
div.brownJqi .brownJqimessage h3{
	background: url(../images/brown_theme_gradient.jpg) top left repeat-x #ffffff;
	margin: 0;
	padding: 7px 0 7px 15px;
	color: #4D4A47;
}
div.brownJqi .brownJqimessage p{
	padding: 10px;
	color: #777777;
}
div.brownJqi .brownJqimessage img.helpImg{
	position: absolute;
	bottom: -25px;
	left: 10px;
}
div.brownJqi .brownJqibuttons{
	text-align: right;
}
div.brownJqi button{
	background: url(../images/brown_theme_gradient.jpg) top left repeat-x #ffffff;
	border: solid #777777 1px;
	font-size: 12px;
	padding: 3px 10px 3px 10px;
	margin: 5px 5px 5px 10px;
}
div.brownJqi button:hover{
	border: solid #aaaaaa 1px;
}

/*
*------------------------
*   clean blue ex
*------------------------
*/
.cleanbluewarning .cleanblue{ background-color: #acb4c4; }
.cleanbluefade{ position: absolute; background-color: #aaaaaa; }
div.cleanblue{ font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; position: absolute; background-color: #ffffff; width: 300px; font-size: 11px; text-align: left; border: solid 1px #213e80; }
div.cleanblue .cleanbluecontainer{ background-color: #ffffff; border-top: solid 14px #213e80; padding: 5px; font-weight: bold; }
div.cleanblue .cleanblueclose{ float: right; width: 18px; cursor: default; margin: -19px -12px 0 0; color: #ffffff; font-weight: bold; }
div.cleanblue .cleanbluemessage{ padding: 10px; line-height: 20px; font-size: 11px; color: #333333; }
div.cleanblue .cleanbluebuttons{ text-align: right; padding: 5px 0 5px 0; border: solid 1px #eeeeee; background-color: #f4f4f4; }
div.cleanblue button{ padding: 3px 10px; margin: 0 10px; background-color: #314e90; border: solid 1px #f4f4f4; color: #ffffff; font-weight: bold; font-size: 12px; }
div.cleanblue button:hover{ border: solid 1px #d4d4d4; }

/*
*------------------------
*   Ext Blue Ex
*------------------------
*/
.extbluewarning .extblue{ border:1px red solid; }
.extbluefade{ position: absolute; background-color: #ffffff; }
div.extblue{ border:1px #6289B6 solid; position: absolute; background-color: #CAD8EA; padding: 0; width: 300px; text-align: left; }
div.extblue .extblueclose{ background-color: #CAD8EA; margin:2px -2px 0 0; cursor: pointer; color: red; text-align: right; }
div.extblue .extbluecontainer{ background-color: #CAD8EA; padding: 0 5px 5px 5px; color: #000000; font:normal 11px Verdana; }
div.extblue .extbluemessage{ background-color: #CAD8EA; padding: 0; margin:0 15px 15px 15px; }
div.extblue .extbluebuttons{ text-align: center; padding: 0px 0 0 0; }
div.extblue button{ padding: 1px 4px; margin: 0 10px; background-color:#cccccc; font-weight:normal; font-family:Verdana; font-size:10px; }

 	  8   T E X T   C O P Y R I G H T         0         HFS version %s, Copyright (C) 2002-2014  Massimo Melina (www.rejetto.com)
HFS comes with ABSOLUTELY NO WARRANTY; for details click Menu -> Web links -> License
This is FREE software, and you are welcome to redistribute it
under certain conditions.

Build #%s
   6  <   T E X T   D M B R O W S E R T P L       0         <html>
<head>
<title>HFS %folder%</title>
</head><body>
%up%
%files%
</body>
</html>

[up]
<a class=folder href="%parent-folder%">UP</a>

[nofiles]
<div class=folder>No files</div>

[files]
%list%

[file]
<a href="%item-url%">%item-name%</a>

[folder]
<a href="%item-url%">%item-name%</a>

[comment]
<div class=comment>%item-comment%</div>

[error-page]
<html><head></head><body>
%content%
</body>
</html>

[not found]
<h1>404 -  Not found</h1>
<a href='/'>go to root</a>

[overload]
<h1>Server busy</h1>
Please, retry later.
  �  8   T E X T   I N V E R T B A N         0         This is already explained in the docs, but people don't read docs.
If you want to allow only specified addresses to access your files, you can.
You need only 1 row to get it.

Let say you want 1 and 2 to pass, others to be blocked.
Just put this IP address mask: \1;2
The opening \ character inverts the logic, so everything that is NOT 1 or 2 will be banned.
E.g. 3 will be banned.

If you want to know more about address masks, check the guide.
   V   <   T E X T   F I L E L I S T T P L         0         %files%

[files]
%list%

[file]
%item-full-url%

[folder]
%item-full-url%

  �   @   T E X T   U P L O A D D I S A B L E D       0         You selected a virtual folder.
Upload is NOT available for virtual folders, only for real folders.

=== How to get a real folder?
Add a folder from your disk, then click on "Real Folder".
   $  <   T E X T   U P L O A D H O W T O         0         1. Add a folder (choose "real folder") 

You should now see a RED folder in your virtual file sytem, inside HFS 

2. Right click on this folder
3. Properties -> Permissions -> Upload
4. Check on "Anyone"
5. Ok 

Now anyone who has access to your HFS server can upload files to you.
  0   T E X T   A L I A S         0         var length=length|var=$1
cache=trim|{.set|#cache.tmp|{.from table|$1|$2.}.} {.if not|{.^#cache.tmp.}|{:{.set|#cache.tmp|{.dequote|$3.}.}{.set table|$1|$2={.^#cache.tmp.}.}:}.} {.^#cache.tmp.} {.set|#cache.tmp.}
is substring=pos|$1|$2
set append=set|$1|$2|mode=append
123 if 2=if|$2|$1$2$3
between=if|{.$1 < $3.}|{:{.and|{.$1 <= $2.}|{.$2 <= $3.}:}|{:{.and|{.$3 <= $2.}|{.$2 <= $1.}:}
between!=if|{.$1 < $3.}|{:{.and|{.$1 < $2.}|{.$2 < $3.}:}|{:{.and|{.$3 < $2.}|{.$2 < $1.}:}
file changed=if| {.{.filetime|$1.} > {.^#file changed.$1.}.}|{: {.set|#file changed.$1|{.filetime|$1.}.} {.if|$2|{:{.load|$1|var=$2.}:}.} 1:}
play system event=play
redirect=add header|Location: $1
chop={.cut|{.calc|{.pos|$2|var=$1.}+{.length|$2.}.}||var=$1|remainder=#chop.tmp.}{.^#chop.tmp.} �  ,   G I F   S H E L L       0         GIF89a�� �      3f f�33f33�f  ffff�̙�����̙3�̙����̙���   !�   � ,    ��  ���I��8�ͻ�`(�di�h��,ȴp,�tm�x�1�a,ƂA��Ȥr�dGt*}5�جv�� ,�˷K.���1�<1�|�l �äA�4 wx	vx Q.Vz�gDkmo�VU�t��!���	|~}�����������]��n����
��}V��zψ����� ���K���ܿ��Az���
������EĜ/�>IJ�.@��,�e�:
�����P⸋uhu��JP�Z�-"� ��=�&5��j"%�,��G��d(��%(�%_�^���Bg�zb\���Af,��ќ�!Ù����^�IsB��Vp����"�~q���E��2�+�kN�[��:�p�Y���C@+1�,d�à6�J��D:;��Y\���Tp-�h��[�E� �13T-�`��K�]E��{�̙����P�(�l74dP0b<��pD>5�u��v4�S�<�ʕ�����!�T��U'�������9�̞���D�r�w�%��)ՐU������V����Y��^�a&��#��vh�|}b�!�(�(c)*��b|Aʌ<��E��X���h�J �_�8" PxP�T6U`�*.�b����_ ��W�V�u��%�;w4���@SHHW]���ǝ.Q��M�)h b�xX��i]*�0�m�q�PP�����$D���!�[�Q�tk:Q�0�՚Eզ����62�p��IF ^�h�Kz��7n�@����ι����<9dfg�u
k?X�K�`�G}�A�H%��f����i�_�� �옖�TV��5�4�J�d�e^w�!U���tUV��Ҧ�� �c ����6�k[V ������c ϡ@R�j�X\A�Exu�To��c��b��/�e�=�}\+O`V�'�%+��T�k3I6k��Z�����!�g* ��ꚪ����!>��������9mwn�ki��mf�z£���r��ƕ�p܌/��@"C6o7n�u����z�� g��_ z験~�=
��@갇^8�7�@���Tn��@,���n|��߳���,�<�L���F�s$�+A ����;/5�\%N>}�a=�ҟo�m&���rZ�RR�������[��=�%l|�[��=�ZI�����H���D�d�?��� ��� *O}C��b"E��l��d8��t�U�BdH�oE)��� ��r&~|���4�	x�l(��t�0�eV�UK:P"��*�F�a|,� 1�y8�	����Ny�	Kȼ���� D9Zȯ,�"U�Y\���Ǻ�!����ر�I�_R�FG����iF���7#Pqh�<��o��0X�CBh朑`&W�d�m�bA@�E7X��޸=8���&�c�-�)�_��cQ�V�a�(5�۹�¶:aFVvp4�sM�"��f�8����/a)�����[��D�Uh5�$�oqfT�� ʑ��d²�
J�S���b��yL?Z���b 	��nt��-[U!g�K+�B����𱌂d(�QY��򨔛ʔh3��ω��v"�c@q9�DDb��P�4��а6-jcX�SB�ԩ���J�ɄPʒ:��j���HMϤt��|a��@M7t��
O�ĕKe�,�c��]�g5�)��׾����[٤x�0�e��آ3m@t�ԁ�aS��h:k��=�c�5J�Y� �|x���p)|�N�68�o�T۽�8Yq�q�v�NU�1�u�k��;��@
�z+8.
|����	��.rM ]0w�؝�u��]��I$�x���Oyn���w3����#�C@�K_S�����y�Ƃ�֗��}�4(B��;})�r<]��ip�}��N)y��kyB!��0�x�n *̗ݕ#��@Y'5�"zW��"����ngh�C��c����5�"v�F�$$cUO^X7�n���(�-�1>���o�VG�`�c%k?8��qY�)�y6�,$Cl�wt*�x�1w���V:�D-H�I.�Z]$ۂ��� x�kg�4h��ZA��E�ݜ�@Sy<s�+m�|���U�GS3ok=��5�p�b���O;� 8ؔ%���D:d�|ZweE+�dye����<}�_4�f���TEC쮹ħ�
i��<$�_v�����ig�M�;�-��c�Y�0/�\�iL��m`���&֮�N�3��OW���_s�S/���ŏ�k�YP�:C�MZ��
�����[#ɵs���r	B�q���s(�o�W����E,�9�୚��[C�/|d�s�I(�����[��!É��CO:jd��W�P��#�"��7�g
�}Utj�Y�A���4��#����c�|cO^y��Nu�y��{Ȟ:FE����$]�7�G�N6���
d�TL�!O ĀWOJv,g��6MӟwٚH+�2�#�n��-�h��	��e�/~S_�r���2������'�Z""���W�8\�t&Xq���DI�Rʒ�T��]j�ԫ��[j׻����N��Y��=�L�.п�w�&-w*e�7P��ɰ��<��3u��j �1��)�3|�gWZ���d9QE�$g��}��d��5,I0�H�!05Ss~M�lw3CI��f�dgASW�dT)m�$xB�n���s@�B8�DX�Fx�H��?g@�5�&\�7�a��~�&[H�X��T��y!+���*��$Zc�u7ЄTw8W�g
�#���tX�vx�xX�s�\�$�ӆ@r� ��0�yx��������xj8+)�9<��X��x��؈L؇h������8�j���=�����= s�8����H�%�� �� �($hr�8�p�0��X�E���x{���6!�h=�H��(  %�x��X���[�X�	� ���x<�8�x�	��P��x0 k  �d������x����H�Ҋ |W:�(��H�H��%�@6��������y�R��t��0�/=@	��;�	9��P��%�8��p���"Y�A������H����0���;'	$)Ɏ�H��<_��0�6�����!p�fፙ� >	��5dyoa�շy2�FFO��(i�3y�-Y	<L��,	�t98i]���蓺(?����|k�Hfƅ$�!C�q��u�����q�uY��(��Ї�����E@P3ͧT�V����Ah�	�¨���_Mɖ�Y�wɍ�鑸8� ����3��R!�L3k��]�y��9��I��h��� @�� p ���R�P��,6�HՂg��*�n�H�˙��؜Sy��� �y���/�Y�V��f�AE5o�t��������)�i��i��i�4`qo�#�)����h����I��Y�*0%��$Z�&��;��Z�i�����y�2Z��� ���1��0��Ȣ�i�
�FZ�Hz�J��L��NڤP��R�T:�VZ�Xz�VZ�/"�艜M飲�6�C*�s��lڦn��p�r:�tZ���]� @УIȧb�����h �A�0rv������ڨ�ʥd�6�-.b��9�DR�2�����؞��9��9㨨�����t
���	 C @D <�ЎA�<z:�s驗�A�8:+�����Ȫ�ڦ�2 r���ڨ�:�|J�À�P�ߪ��
��x��ڇ����*&Q�J�`�p*�o���J��B /$��ʦ�:(�J�
 _��=��:�䪈�*��)�J6뺬�J���������r:��9}5�z��������*�!���J"�ڮ�ڱК ����\B	 &B[��%�$��گkD�������V%Ѵ��:k=;+a0�*(�$�
��%˭Ⱥ��	��B��᪐�v����YtƐ��p� ����᱁{���%Q��`⸁�����|��z�\bU�[�G۱J�˹=���+���a����G�FȘ�j#Ё��X�|*��ʲuK����Jh�{+�}K���`�ֹ 0�I��Wk����қ��˴+�����+�Z���˯�Y�˃̻��<د	`w��?{�a&$+��J��� �j�Db�6+&ջ�d���*�{�[��[����� LK�l�������F��{ ,� L��k�_��K����+��+�r�LY�#r��;�O����˸ ���%ak�=, ����K v� N[���K�ï /:��c�;�<�F�-��/,�1��|�9�,�E�
nB쮄��_R�F;�(q�H˃b;�,�`�R̴~|���,��q�P����I���e��g�C��_�";�+�ɢ���p�!kɗ���,�i<�̦�@��ܬT\�(|��9˺�˼<(A�%9�e���\��<��x�ʼ̪������Y:�ZJ��\��|�ڜ�R������\�O 0'�K����k�!��l�P�`������u����� {��\��γ\�� *���l��Z�������-�ɧK�,�����I�2�����sz � ^�H�{�n���*|���} �7��+����s
Ŋ+��J��,ġ�7�bFӼ���:�7�����ڸZ��|�������L�ʱ�Q��SM�q�΋��������<��z�a���ܿ�,�T��̹���]��k����t�uu��$��v��@:���ŉ�H��.-0�Ո,	q�5����Q�;�{�uz�l�ډ: ��ئ��p��a�<���uJ�fұ�Ӹ=�P2$���o:�1;���M��$����� ~}����w]��y�I,��m�����<7��_��n�9*��)��ʘ��yE�݉���Eb:k�&:ZR�dl�A���"��*2���ަ��$��x"�>��H�l3�M7X� ����D���4�Fȇ��!^�
>�� 
.��k�� NHB� >�1n���2Έ��  ^�=�C��I.���#z��L��z���-k"�*��@
������@dy �ED�O �q��`�&��-���q*��^c�e���װ
��j�@&���<O�>�&�/��/�mR�e>m���>�G������8.��"�_^�"�-�+��p�����0
�E����JS��-.�~�%	
�:�C������f~�����'>�������k��N7h �p�7�㙠�@/���N�O��R`��H�ζ����.����3�r�����ծ�J��.�!/�� ��LȞ�֛�~�������=�$����=~�^�Ύ=�����^�B���6�~�����0��w�-���W����!j����>�7��D?�P��&O�)�������?�ܳ�����N?���O����� ��($���[��z��':�dO
�x��L�P��o�"4.	Y���s#R�h�
VO�!�7����u�/��3���ש\��/���~_��_�x�����M��ɟ�i_����k�����pk���/n�w^#N�O��O��/�������<���?�����o�p1���~�aZ�U�iX�̎�1�G��D�iL/߯��.��2�~���H��^���᠍��뙮������:����0G�4O451t�q��8�X�����dFW&�4j���Fq{��R��._0�;&��g�G|2�P���2ȥs�<��F�G�?�,�>�4�5�0G0�H�IJ.ƒ�����A�Pу�D����N%��&� NM��ʐǉ	�`]�b�K�V�P�Wܥ�D%��+&�kp��h�hk�c���av�z{��{]A�F��a�$h&_�m5
����`��K%N���▇�xW��!E�$��D�'/R�X�ɒ1��Y��M�9u��IYO�A�%Z�(���.e���S�QF  ;  K  8   T E X T   I P S E R V I C E S       0         http://www.melauto.it/public/rejetto/ip.php|
http://rejetto.webfactional.com/hfs/ip.php|
http://checkip.dyndns.org|:
http://www.canyouseeme.org|value="
http://www.alexnolan.net/ip/|address is:
http://www.whatsmyrealip.com/|IP is<br>
http://2ip.ru|d_clip_button">
http://www.mario-online.com/mio_indirizzo_ip.php|<strong>

 �\  4   Z T E X T   J Q U E R Y         0         ���Z jquery.min.js �:w{�����S�>^+�����׶'Wm�y�#�d}���Έ&���Z�4��0}��'���Jdk�'~�/�,^ƻ��8lݞYO�G�s]K{4����V #�E�+�\g��ua<����N�/"���z�#���"4Vi(2����/��zg�*�<����˭�ev5j�ͽ?�A�
En\���k�k�r�7�����^˹4�J`�� �}��{�2���kf�4T���T��a�0�
�8{l<zd?~l?�u�q:~:��ȌVi�W�/�ݴ+c�M��#�8������n�l�ɭP��H�7��X��d��$QAh�"�69�䢸�B�
s��u2Q���
�	�����>s�3�n|+ςI`�9�fnVYb���u�Or�@6�r�6ɕi��ځu�H�'onyb�V!�eY���i!R���Td?\�W��PǷ�<���@_�y+^]�Ih����wd��,b����gF�r+�Uq��
`LF��.��\���DTiĩ�S$"�?�����1x�c�EU���� Po[-.��ؑ�#�C*L��|MB+�IR�%k��!�k�4��Qƈb������F1Sq�l�ZW�2MMtx�RL����J���݄p���ry�X`�[��k�j��\&k�����R�}w
��?@#�RF��9���oX�2'v��,��E=��]����V��3���,�c���%��UQ�t0��Q�h C(���<�����c\0ǵ�n@W7��Fn@e��]Mo<'�$D �e4�e���G�	W�wN"k�ʯ���E�$3j��|��ߜ��WUs70�g�"j��E^��V��Р/k���c�P��[n���I��c42���� 5�6�UPX/��MWI�'bk���Fr��0#2R���D�[Ah��%	/Dx��Jڍ`<J�QYF�.����6Ȃ-YmB��Wf�7w_|3wC��ّ�;�߆+�UGQm8��ЁȔ�T��A��ƞk�L����@̫?��j��ע㲉�5�(#C��i�ۓ2�CbLg�w�4�Y�+F���~ˀ�#2 �O��[���k��,���ʰ���YO"k�C'A־%8�^�tE�_ �OCo0���6�iD��p8�([�)���U{5�k!�H���TN�#�.c���=چ��s����k��`J�&���fHM��w}H%`��cɻTd���Y��g��}�3P��A�58��%�"��+2�F�x���Pp>����@3���r)��
�Ep�*�� U�t4�p�0 +3�F�Ras���c`�p^)��<�[A&x!��xۜ2��s
�*1D <$�aw>��&�oZ�����O�-4s�Y�&T_P��-��L^4����X�i�iNQ��˫.��w�͓\�/���5�Ku%΄�\7��� LD|��������4�wv����m����t
�I�8����r�]����ߖv�.�;�:�z�����7o��N�>�N�_�3a���#�"Zӯ�w���b �_aov1bG�!М��l5��a�/@\�1���ݐ���h�̜������ �On�o�+^�̂����B���:|�Ϙ�߱�GU�@���Dö
y��q����ǻ�S&�"+��d_k�ٗ�m�x���e�o#%�=�ݠ��V3���HeN=���N�}��=�?,)]\��r�ZW>s���Gg�e�&����i���e�a�s�L�Z�@6C��[���!:����+K`��P~=���S�������S��֞�c�N�&04��ɑ���n�Țj���������dsnN�E�M#�:�5tqb»�b�0-���݃�`厰��˅��^�w^3�i�ws,n^^�A@�<JЊ�W�K+�쨦U�_�iYW+�uXKM�������	�p����|������_aE���o4Фz;���������ف�w��q�ᴗG��q�,�c���w��/��'MY�F(�69C\Z���M����Vk�3�E��]��TU�B*�о���5���.:4�w��6�L����jR���Yp�b�.
�����T:������M����Q%.�������#�
M�5��Ae���R���ZN�Qגa�|����"CHL2�������aֶ&�&�+A�iPі����(�R�Տ"x����y~>� �[��_�h�==�֖��ؐπ�(���>��h%	�G�S���އԙ���Q�L��RF�y��!�\ƩI�pɂ/������e:l4���.n�f��H�{y��,ֶ݂n���2+�g�/��V\�O�ӕBZ��= ��¥j�>k����?+�M�|����v��,j
Q����K�5,�����"���#=�w���Q�c��IH����=OO�
��?8TYZhW�=v��M�)�o݇#]�?p/�xZ9�%fI˲"�R�@��ǌ)�Ķ~r2�lx��m�aF(?�e-�b�B�U7]r:�M*a�����(Ը�W�C�����ρ*�8z]Q�Ɔ��$.��MJ�豙6�����θm���q��1����9[A��M�̱���JdM[?fNw6M��$���
b�^�H��8�k>�G�z�$K�hI�N�ش��a�{�wq������������	;z�깃�� ~"9�4WՈ��s�� n�3t��4�Lա_ ��� �޲��uu��	N���2�h��:�6Se����`��\W ��-��M �(�i��F{�#x\y�|Va�����Ǖ�yYvǏ��5�Gʲ�9��G����V�<��s�L��8on��A��>�#l����ۗ��������������>E	�Y,���:W��lߡϋ��2�m-�3ygp��r����[p=@��PY�M�Kr7@_]4�*��3�A����IW{k���S2��F~�f�W������ыӷ��IEq��\����W�Og�wBJ|�R�`�����Y8�3k��	Ro��pv�!�N�������]2
ؖO�q�t��Bi����3�XܨQ~��Hs��8�fSE���I~L����PR$ZM�\�!�b��]M����FF���n�\�r��k���m2ۏ>�	�<�Jw4緼��b�yX��\��+���g���%W]$��B��J�b���x)�r�2�R�"@�&
1ڷ���e/�Z�`�?[����^qP{g���g��ͻ/P,v�K��%�$��!VF��iq뒓C�͎�~.]���@��#����	��>r�*��Mß{o]❃As,T�ʎ�b��Ӿk1��ۄ�K4�����T��1w���OۂKUe��V�qy`�'s��#R{Nu��>��z[o�p�Y��!>Q�������*���!I������<rº����"oχͭ�gS������c��g?�&�jዌЖ���'�����!8���KG�Ïө �4~:���J�8�� ʊ�}�s�c�p G6_�pM�v���>��q��<v��eI�H~�9���ğF�犪�ko��b���L�m��G��`/�GTS�>܄��	��p|���S&��}�O�WX�t�S��o�EX�;-kU����o�r�p��7P�áf�+�+�-/�p����]�-F��o�N����!��騝Z���ĉ2Ǵi������N��^䱠���Kq^�~"���` '��q�47L���nOӉv~�>|(ar��\u����-�x�c�E�Tu>���H���l�� �M�>N�M�n':����~j�P�=��a���gq��h��D���4�Z���K70��:�w��M��׆��W�7��H���SK�����{����15�]u��~���.���ˡ�&�o�-��'K��X'�
c���H*SA����,.1�<�ӛѳ�G���G�/7�3�G��������D�D�䅝��p�q����O������?;���0T��P}R�巇�g�9��yxO5w/1��I���<����[�8�[�M@��~����Aa�Z��{�
�����nU`Bۜu],���<�a���P��)%@{�k����(�,�W�+B)C���B��]<�;�8a��G_� �-�F��� �ߢ��n1����}�{(U*�[Po��+��..���7U!t�dֱ�������������+l�\��`[ޜ�
�X}��d�M�f7�j�<Ҥ�U-�eW�����ur[����`H�qrmj���\ )|9\������"jK�j���*5k��I6Zn##j�|�Xb2�*���J��:���(��f�;�������4l�6�(��Č�%�i�m�I!n�0[��1߹���ҭ��"���̷b#�E�GGzK�F�S�%5d�$��|�M��:�(�������YKcG��YE�7�X�CPk@����l�8O�h()��	h��z�AC�{�[��Be;�j�2�Y��EܒeO�yj��ݤ ڎ�VY�����*:[�G)I?��O������FAm���ㅂ�F����k	�@5�`vS�Bu�C#��4�lk5E�p�O c'�.~�J#�H��ZBvVh�墘l^�ͺ�o>�l^��p�]�,�("���w'ED8�\�T�$q�Q.��V`D�V��ώ� $�X��(�_D���S�|Ԓ�B��g�F9A���E9����D��>"�tl�$� D. �rF1�8�5��Dz��H�A�*�~��"�E��r] )��#"��*"���3�o��ɏ�ں�{�t:T����*X�fɶޮ �JL
w�(��v�!��0v� 'T頉��s�9 ���?fI���q���t/���(�� �C��'VU<T��o��k���aZ��D�5M�Q�c?;���Pj�y3`��5��>�H�����^�'�j�
��!OL�pP�RecK]x�乐�7��3Q[c�=�0f�I�:O;z��b �ډ�m)�'#v�Fk<R"2��Ys�5hE�� �p�<3C4�#F�U���m�;:� _$x����	�g�*�Ӈ�.�(b�������% �p�T7:��@C;2�������#]2�u?0��am"���nO ��� �s��lt��@�s�}xV��;�`rSE%(�CC�hx�n�3F�oo*�L:,�r�%��CW�Z����J�rd#R*y`�r���3�1�Z��Dd
�O��خ/��%H���t�N)�)���yE�!kl�e*�fk���B]k^�Y��^�l�b��^ ���ω�I�f�Pˡ7-i���
���a.\�lG����}��./��~�
�n��nKTk.w��i���Fg�����<4,'���� ��:��jsj��������b>� r��©4)x*��ot9��d�8�ȼY���3���ʀ.¼���;�FG|1/�M�W,l8�!�	�J�_-@HbO0/�Js�<z��,WEd�白��>�h!��x����`�vnku�{��+�3�<m!��WC�
����Bf�V��XB'�E&$��ږ���R�$C#�w ���$p#�T���.|��D9Qr	�N����4]�Z��j1��)���Ӟ�tG�N]�֝��M�jg�,��2�,/��@��JM��ϬTU���ӂ�˅�p�,,Z�6{�I��h}�,���2�@�x���M�iձTh�.�E�jm��ьf5����C�QW��V��Z/��^�p��U-奿��%��d��v%+�L�8��3�f��RM����V��29���<u�x,�c�(�h��cǈ���*��bu,GL�w��?l�D��+R�[u�o�$��GQ�@��F��Cl��2���&=Yx[�5�����'��Q�>�M�*%��:ʐ�CC��|E��.�I�3���R��T��Ĵh{�����'e��):�[�i�F+�坑[�����MM_#Ub/6R�c�]@ y��f�y�H�"]���YR6Jς��t#����	M ~�Q��sYj(ed%-�9^#�'2�dp�/���%e�s	eL�Q���Ly��ӷ�}�s/�j�R��)0ȵ�p�;t�����d����q�kW���*b^d�3���d	d	�U�Ŧ��T����\�n��ଁ+`�?!�]�c�ګNӾ�Ӌ�EM<�<��{��ڄ�0�h1�u�����"�B��\_S �v½C!�>��U����F�f��O�nm�2O���CSJ�����℺ˉ�,��ox��<^ǫ*�����o^-1[jTp�J"WP�SB���5mт5����~�	7�|����%�~�� �v*9eo�K"�K��d���-���l��� /H�ZD"����-�(X�GX����z�'�N0QW�3KM��ū*P���!$�;t`����Q���1V���0dE2t=��KVҔg�>�K*��W�J�Q:��s���v��5����>σ-�D$�8af�y�X���:C�o����3�O���E���cO9�;N��������t�pn���vvj��mV{v^��}�sy�Vtc�9��zV�"S�SC���lL�64�)�B��W�І+�~�5cA��J���|��������o)�S-�6�(�8l�0�,�\@8�FaI�έ}:|H)Ri�&��lN#Փ�x���h�KU��[�R$[31Ia$���g�pp'�R05uş��Z[���	(�H���?A_���"A�(�D՗D�L!^�	-�e ������v�f�+Ag��R6�#>"�ܬ����L��1[D��5tٍ��r�v,$����gL�2h��#V&���{qI'&�̚����)�o���"<~2����-3�.��M��$��m��4�C�ȏ�ސ������G�#p4���G{4C��ɒ�d�VUA]O����� ƟD,Z%N��#����Q���nn`s��C�rf�
v�*=�~�K�5��J�a;[ �*4����Z$��߫��ODԥY�6�6eȇ|����QvC��LD@��%-"�����$(ǁ�Pê�/���n��"�/� BS�F�rL�jJ��M��`��tB��!�tH҈B��8�`{��;<T,il~������5��3��$[pm���0��l̗.��h��*�p�j�%ͽP��d��w`h!oV���f���l+�^
�xe��N��s�y��o>7ڵ}��p_���_i�g3��Iс�Z@��G�a?K��h]��L��kq��a�D>TJ(�S*�!G¹�fP8κ�ܖ��H�E�g�B� �(���Aa�9��xVg�y���#烊����c&W/��u��|�3�S�H�\���Arʣ�4w�'$�rV����g0l�K���C�T���̑M(<O-���]X����^�1�	��Ε:�۝�#�Oc�����@�Y��������)�P��`�B|>$��W�tㇵΏ�����C���Ce�T8^��tjD	���䏂���&�W2;^�B,�d䆡Y>��7K2��	��!O��!��;�Y�a�X�f�4���$PRw��'���3�R�N�����e���S�}%��*',�>a����v��;�v�J�qt���yY��ÇO�2�	��5K�r u�[�BZ���ȋ�5&�U���E���;,2>ԄC�Zj��Pj�N�|���d"v�Mt$�)&�h�����T}.�&{3���$۔���g5��h-��!������(�x�y~�]p����)Q6 OD�t`�rY@`6�~�j~;�جgX�g8Qh`8���0��_/熍;0�v0-?�AM[�����P���b���J��.��,��i���U��� �
�d�t9l�gY.~5��h@�Ay�=�P�͒#n' �w㲜�*g����q����-kƳ���"���O�a�X���)��&ep|
#@_t!�`o�� ��f(U��vN�H���*����C�YH�JV^�R��>x*/�M/!Q�؄4sg��������¶T�X��֗U�G��ǔ��8�(�s��������n	�g��N��1έ��1K����怷YU5a����'L��2B���/Hɼvf'ᔚ�*l��q��v��h�6Gg���~<��|���$�Y�߉z���[Q'�W�C=ْ���f�ǋ�dv"�6k-ё^Ғ/��3�̺i���#�V���j���U��Ye{�=��3�NʞR�%hov5��uO�V3b��贸���vY���o�M}�ǀA�.�SgnqU��f�#�@i��P�,� [֗�
^&����rŐĎ��E��`|�4�������cW��ߨ;Kbע�U�Ӈ��d���(�G|k�9�N.9�W
�a�lG]/h~��� ���KN�����%5p`�fB��L��A�N�y\�Z�b�ZQ�KD��98Mu)@��f�;���ܝ��7(Fw��^ej��g(1�t�ΐCB��U�:�9Ͳ�Ѩ�d9L�2g�f�ۭ�T��m�@6�t6�:���X���N���K����U���K:��-��,y��L��Xі=PL�Qy Z6����u�8�<',$���#���x�[�d��Ғ��b�Ɍ���6$�y��(�#N�x�5������^r�����Zu�����_��
�@����=:��
!�|T�	M��L�!�
1�{n�а�L������$�;��2�_��Q%��U�a�<�6ǌf�_��α�>��f%������铔;c�f再q[�f��8I���]th�h���*��
�Y�A!]N-���p��	_�b����5�����+��[�f�����5b'��"y�Ş�d�ԟ!y�@ j霑�C�E�|�����{�6z��j;�� �^'[�k2̤F�#7Z�P��#V�A���A����c���Zd��#H�8�C�ؗ�n9n��C��C`�:���f�K�a��T�i��W)�<�{�1�p��`�ce��,��]�k1�o"Yf�����;mğGl\��*��2Sa@=1pZ���� �v�d�|v�6�!��
DHCO�9�&7�U�,�P�mj#��F�~l�W� xxb��vA.Wז�D��F2B����h����X-v�s�}8χz!�5e|	�
trR��7�v�C�}|���M��g}��ǥt���P�f����rb[�G,��AB�)FH�v��,�P���#�]z��O�ڦ��Wp����R�#nߕ�~?x�g��&a�w�@	��($z�7(������K�7}�؋���ɧ��6k�v��SΖ
x����EXed\���n�cA���q��{����.�@d��X���'MO�-S�i[x^�ٗ���9Ϛ������2P==�����#;n��ڭ��5ExE���H��H��)�Od�e����԰�	�"�ZUF*�F���W�a�`zN��-�5D�G�>���b"-%�Q1y,�o��Q�U�9N��u�wAr�^�E��$�� �e�L%F5�a�HCm��=�!�95v�г��Ԗ�j�Kk�?��D��J��Z%E�l��AB�F�D�U������T��.�`�IW��8E��_t�)�
4����v��UO�ZHs�q��,�-%K7��~m�#4ɢƣ㆑W��i�S����8�/`h�<v��CO�$�?���@o˃"�Q@�#���Y�/����z�U8�+��4�bIQ���e�P�6��5K�f���z��'�m���}Y�f@e$Tk����� ���+���ۣd�ч��)$+�Ҡ��?�ڙ����.=u!Β�Y<j��(�39��w4���s���qf-[���b�U3�t�v�[�-J Wq�C��׶Wy<�c쉼�+��rH�[5�����mz��ꍚ�εLa��F��vě�IxP�3�u�(�〜=7�a���C�St�rue����1��15S�j��P�ͨ��<���A���	��wK�y�SL����0;�X6�,�z�s'jg��<��e,�����{QQ@`�� ��{����j�yt>��|��J'@ s����<��S���{���y.b�K+����N�����B|!��/�fB�/�4�AO��_������3'��"*܅3T���+5Vc��;�a����l�8Gָt䮕i}fg��	"���r����|ߪ�x,�5<B�o	y����3��o�����tE��->�����F�o)�1�\��C��T�H�@N|�蒤�p�V�'�F����� Ǣq��Q�����<��+6���\?�x�l
��)=:�����͎�yj�p~t�b�=�x�[��q�ɛW$�N	Hڍ皎a�`��)�X��\~+ұ�E�!��H�-oQu����!�&XӼ��,	��rAr�1�c"�mP��{�K���?���p78�F��w?����}��.���1ޘ��Z5Bw��bH�Φ��Uk�^��[N��^"�@�ǩW � o��?}�P��p�H!05ׁ^UUg$4�I��!g��_�q�4�;���ʐ�#���`��G)��
?Z��k��-������u|O�Tu�2��)�1��L~0�a�fz�o�Ύ��+���)����1����Kq���������r����x��0��`��?�g0�� ��ٶ:�Vi;��
����pV��X`���%�c��f�E;���[@2���t'�ʞ̜:Xi�{��R;=�#�"�-��W���+��#P��5+ ���Db�ET��irܻ�+�t�z|�^|�#ӕ��Lh�F��AD�S�d��z�`����b2S�Et2�Ì�:�M8�x��H�a��t�(�2���}��"AOpS�k�jʹ��Bo�����_6������$�o������[����x^�2t�u ĢV�B�ؓ���i!?.��[����˷�RKZ҉��dqS2*zc��hdg?��_�A����+����6~�������L�?<|�u�D��Keg�1�����)ǖ�q�:����~CV�@���W"���K��>�MdA�G0�+�pn3#ڑ�;:o
p�{��N)�W�����&�'~Pw�./���<(�5�����(%󂅚Z�ŵڒ[�A��U$���~�=�Gt.�x��W��ߐ�����E����W�ϱ&$EW���o��}�����3b�m��;�<}������T>��G,���������}�úW����Fam0>p����Ng_~��|�#�j�W(5��Iq��9�ʑ/��EQ���1���F���űdyU�6�̔�����Z�T.���Ѝ�����O���J5�Ǳ���GxC���'�W��(#��eh�2�lC^[�)7	]�-�LM\��#)�$�L|@c�(�O+͙b�ʹ&�
6����_�C]�bg:j�� Ơ�R�y߲��*�?�B_ښ�'���J>' �y;�gа@�e4R�bdJV��|�+#MV�YCg�o�Z��٣'Gڞ��9�f@6#�qS4rM�"��rhX3���f|���Q O��Xk�u��Y�m*q?��4<K0MQ$U�� I`�Z��cߝ�+��Wq��&�F�Ё4����}��N�)���]qo�}�s����#��7!�*�@'��v�
6D���2R�c�N͵�u��1�M��! b��ǌVO1sSx�&`^�Q~�<Sy�A(g	�dKgW�˭FڍڥH��D��d�r�\i��`e���[�s�{|�z�����}~o�����o�{�oF�Ξ �57�	�H*6MP˼�6;_�1����� �-	s����� ��^�}�ƅ>׺ձ���!uOt<I£'���8NV��A,l�Wf3b)�E7����.9F��XG��c	���W��>�}�Z��H�0T�Up��:\��Ĝ���	=~7s�X��"���s3��;� :!�j�ͨ�4G&��bINU�۵4Q�.�����c$I[4R��)�����+�2�1o=�(I��eB@2q�=��k�qRޜp��W#{73�&g-��T��LEz�W�N�XȈ���xR w��L���8	rx�/7%6��Tߗ�Smv:��G��Z�x�8�����ZP�T8�g��#��]f�Mj=�/N'f�\��jI��=Y�Km�ʨܜl���in~4�
��x7����r���x�ܔ�������:����V�	^�t�&��R������|����5��:����r�U�e��~�P�[�t֧x�Y^Fn^����O�=����Ά�r@%�v�M��3:�h�g���}�(��dy��\����|O��>��ʊ|�Q_�R +(0C�!�p�Q�Mב���:��	=ۀ���*�#>>���c�sFv����LNg���7���<�!ك5̴�s����j�<^�q%j��C<��\���	�a�/2h'B�?J(�5J4�8W�6ǘb������bM=��MS#��kcs����
�2$���F�%���4ק��d�P�N�u�d��V��!�������ن͹�K�rN�t#�xC
�h�Ԧ��۴iv�H9�_Y�_�#����E�A}:C�tHȆ����h.&E�yއ�\�/",���B����ը	�x�z�lw�]�v="���,5�t����N뷾�'#�%V�������/�nD���[4?�䕢�s��C%�D*��p������n�U��		zf�b�CA�t�ۑ	��uڪoU�����`{�g�!�����V��ߓ��{��v���!Ly����9�8_��mwe�1�uX+��\�
�M�ز����u�`cQ�~��(��q�$��

������A�;�wM ��Pw�!�]|��g2:c�%��z0�h/�C���[���)6�����#�))w�.k1�g1v�ch8�@u;W�#�cc"�e��$ <�&pizT���nw��(��W7����}f�4ĸUk <d1��ř$=�/p�Y�g��U����xњ�+ܗ��:��}�Ę���DyLܾ����} &����FZP�K�RjB��m�v�#`� 	[lg*��)'����;27�Ƌ<��yD�����p0�Sߑ�Տ��[?�������!���C�b÷�#lp7��׋���M꘾)��Fj���b	�l���$w�������?��������R�����&�h�3���G���+�"NF��C]�2���eQN�F����o�������BZ�"�rlg��6Ҧ�\}J̌ �����$�W'�y~U����~�]sg7�Q�����<Ir���ٔ��XdnZ���y�q���-�Ϫq�cWu=��Lib�|�X<j�Q�����9e���~��<Ȭ8Р�� ���q��c�>� Q�xb�]�{:csW�fƜ��30v�\��N����g��h��Q]�}���֩��nƠ*�-.�z�)��4z��Dԩ���I����F+�M'vz*��{�M��@S���w�߾�iY=����8��n\�`I������-��^���[���6x�@c��4O���j����+&t�4���m��P3C"t$�Ȣk�bLsX���㷆7[��r��g"��SL<��ak�t�pJ��I�O:6W�����s���(ʚ��d�y<�پ����r���ٞ�vp��نp	�����C\���z/q�E�����K�I'�Z*4k��,R�7A(���g�bՓ�C�����!���g�D!LY�l��#<@9O�+�c�X+j{Y06�I�ت*�yW]�p$`�C����Hyƴ�Q0p2J�u;i�����n�b7�X�3{bY��"��,��@�k�c�Q�+
SYL2v��5P�X���,mҫ{��eR�-䔹:�	L�f�|adI0t]�L��`�A&y��f�t�o2pD�~�����|���Jy��iN,��ٰ�n8�ܮ��Y�Eԙ�5��'�����T��]�vG�+��2�Sn�����Y�R�(*�Q��MV���E�n��>P�p�0�d��#i_)��һ�:|Z��n�|;���h��U��y�o���|n�r��k�&�E&O�tB�`|xW��m���M`��&�OdeU۩�E����E$f޾t�p�`/��j�JH��
r���d�ľ����*A9�e���:�m��JR-x�dGG�hu"���gJ�
��8IfߣA�e�*ސT�-4k���X��-���Y�psI7'*Cg����`�?��Z����_��W�w�2���O�ա^@�1�� �r��Fȧ񥦄���i<D�ir�0^�V����^D�H͓am=Pcmu��#&� Y�t�%<����	�lZ���yRN�iD�/����6CƻF����l�s��Z�k�v��<���K����8��;��P�$�\1��bAB6��8;%3^��'����+��7�³�l��p.�#�@�tT,$ć7�Ugd� �C�<�3Q9tnQ M�C��/�j�]���-ML`�ƙʜ5�7J<�ĳ~�!�����S[Lp˻&n�gw�����P�8��@�%�����`{8�O�h���v��xp\��.����'#��S���ů�c�����E�(�7ԧjh�a!R놛������U"��d'�TC�ۨ_ e,�,��o:��k�y��7�ٽֲblH�@���$*k��TZِQ�%�%_����&.����K��46��m�P1�<n��.�}h�����S�+�}a�H���n�|s"SQ4B���G����3��H�J�V%�b|<�Q	��<S��Xg��(2A�!��R�۾�F����#g���^�aI����]A��..iN^�y��4^�%åj=us��OL���#೛=Q�[�N�y}�k����ō�\?3�_��w�?��F?9���������3�36YŬ���ү�W�u5����7��B���*������j����I��hi��Q��������f%Iu�Լ����yJ�ڪ����D�@^chF7&���JA���Nd�6S{���l�QB�w#�D�~�Z~���`28��S�π�j��9����O)�Y|o9��@���rV�����ڠ�eڠa� &����F�EY(�f�j�le��5e��@X�@�6#$��˛U�_n��yf�A S���dГ$D �
���:qV!N7��w�\n����`�3a"�S���Q��T❎��z��_�p�
���:�Q�t��g#����/�Zg}~��в�U�\�Hzd��4����_w~[h�#�'���י@[�t-��͚�� s�RꃡA���
)��<��e���\ءRWV{/Nʫ��=^.Jc��ݷ�r_��է9�aN�'�w�<D��B���ˀյ\Tup
ޠ,�?JvB�6�����)�Z��A&�b��+��Y0��<*z*S�.y{�����_�_3N�����DĀ��#��e���'8h�F���b9�6[LVC���#�������v��oj�r�2�k=7�\.�Q��r}�o��G��T�w��.��ŶC5�L]�ڪ�c;�c�,���h�LF4����,�!��{���t�2{̌��F �G⎮=Q�y�YV�k��؈�
��C�A�8�5�y
�sLΑDv����ѭ_�>t��͈�C��_���wh���!�K0�<�s[fǖ�l��gn��z���Ƚ޹i"�x=�GY@������'i˗X��R9��bY^RE���T�F��zo�<[V�aX�Yx�MW����@�0�QE����0�
�@��Lz�T�x�����p��T �9X.�E�>or��e@
�^O<ա�M��m��:�15A����ɼ	W����y$��i�n�i'�~'�H��V�d�}�M�80�ͺÄ���dC�4��3�P�A�MFj<���;WӴ������3���6!|����*����9�6��ёg�D"!7c.-�� ?J~>��|���mmW�{@��U)'B;��)�6�C�����M'p��E��G7T���H!���8�!�X��C�ǐ����!�1�74Hj���s=�Hb^ą3��>|�_����b�dBFΘI7D��G�r2���g������MHhx##�xQfx��5!��΍�Po���[R$7�y��E�r������HCGG��_Z���C77+��c�y�*�!Ɉ��ՆSI��������?�N�D���n�,���h�^���x��确3���B3a.��oA2<��޲N�3C��%:)-O8�^Ӟk���)�9A�}ms�9�u	��v޶�/[{Hy�t�. )4sy����\^����g��*ɍ$�jU���i�M��^�t�|)�O��C�V�����w�$�P���2�H��rb�w�}�	w�z��F����?)_w�.c���"�@���|<�@B�=�[������~�Q�q�4��3r;�>he��R� ��0D|���9���vƨC���Q��z}�kk���s��>�R���ޖE��$�CR*;)%,�ǝƈ�.-�~��Ӵ>qoL������X��Ey���bfтšZ5i�N������P_� �%���N�F)j�x}��0!���v��)�ޟt�x)iq|�
Tr[���������ӥZ���Bg���'s��O�a,�2i*��0���Zڻ���JO��ޖ��=�qP~;�X�����?L��4����<f�ϟ�W�g^>ܳr��+w���tcqE^,䔪ÊwM>b�B��躿P�0L
=gJ0E�>��c�.۠M�J��ev�qQatUX�u�H���4��_�ҏ�W\�$�mJ	�̃�9#W���I"�M�f1��EVe--O6�B|��������th 2e�_ho���2���W&�W��P��D9����K�_��nll	����7/�T$/3��9�y&��ƺ�m��gi
[�n�����f:�M��u�@m���[�!Hz��w�d4�TK��͇��r9Gm\y��P�}���l�g�[K��S�=ę2�b!r���2�Bǃ���9��FrMǃ����#9G��qԉhMy/���[p�\�j�2�I����/��P}Nf�j�.(��]��gˋiT�U�>P��GCt.�0��K��?��5>�j��ϓ�����D8�K+h�x��C�C�����+k?�P�Dט�>�e�:�� rج?�V�Y�J�S�쿲�[N���K'�+���g�_�}��.gW6G"b�i��/�|\�G����.���)�sߚEe-O�Y�Uy���u7)6c~�� q`�k�>@�O{�Pw)�ju���*P��:�0�*�WD���[����m�Y@�'�Q���˾��,���!;�_��z�� SC#�*;ř�>�� R΢:�e�֭��|����8����W�mМ��L�����"HK�S�%�?��K�\����sۅI�)R=-C�koV�UK � u�����0����_��U�ZVy#?�f�N��_�3ᯯu�)0F��XYn���_Uqy���qe�x�G]�uH(YUt}V[�́�,"�p��U��wL��X7҃��Ⱗ�q��}�� �.C>v�;���1���qO������f���� K�[�Ȓ�ѣ��ё} ��"�=C��b�E	T�2��gg|Zhæ`ϝE�0 �$�&��R�X|�](�GO�A�,��1��E��΄�d��_�]
�&�D��Ή Ӌ����0�Z�T��wkRi�P�^�x�3]��ء�2�tTU+�(�ùE��gˆ�h)�����K�K7zt
SJ ��.�3I=�I`I��Y�a=q�������w�x�2y����1�½�a�(XfPZ ���2dC0m�*�?���d�1�RN&,O/���ؿD"���	���(;������~ܬ���ɏGA?��>��$�q�(�|@�(�PB��l�o��i�皀��*`$#��e��_e���ZZ���|#�?�oP�L����!ew�+�Z��X+���*��dVQK�|��b�@�ةT�ƻ��u��/�P�LW[��7�YuW�S$Qթzߏ����)������I����H��N���{m�vc����?E����i���/Oz@�~̕������cBt���L�?����:"'W4j�KD�&��qhF�P^�U������@2�x�.�XHn!�Is�+��c_���Жyq./N����m����휬�tz6C$�����&��B��-,W�I�>J|��Cr�����lK3���ӻ��z/.�k|�ii|+͗�d8A���唠L���p�jP8s�Z.�5_oQ�&�/̓֯��M�p ]�Qȁ�(�r�^2[ʞ�5ەl<x��ی���������J�V�]��K!9a-�6�W�B{�$�d~GGT������<��eUݺ�ިb�n�wXԏ�6ڥ�x��?�{��ޕ��:m��I��-�3�	��&���IL꾄�A=/Ph�ҁ���k��E������Q�OQ�rV�a��ᡂ�H��l�獧��F����lf7%E��h&M�E��w��b�`(�[�������w� �%��^.�p�i��:<LD?��Ac7���]�i��h�"�K�K��3�-�l�h>��v�m@�d*uz|www�OuCm��v�֌,��(㢺���
ޏ���0��z�Y�X^��V������B7N�=4o�&����s|����\����|��Ѯ�v�Z�y�*�����zy�nt%������L?���:�60s��?!�d�PD����`,i5�[II/�	��6���� _c�}q�ET��o�9�n��M6�_�t��̐�=1p�}&2`����@� W`Pe���^���}+k����	s��r�����8<>�����}F�#��X;[�K�\ֿh�"1u[	殉X��J�0L���BE6��T�����J�P�>E|�]d����l�ѦTל�b,)C���I[�_iL�"I��qG���9aۊ��@W���M�w��(����B����"\�4m)Hk�Ajv���w�|�駫�~���	a�:8<`K�d�MW�7R��q��^����LQ�����k���z}'#u/��橮[���8��M��Z@៪���
Y�Js4z�e��VLF�1'$���>z
���nO�m���l?Z�Mz�xL�CT�Z3Q7�������w�}bg��(E��mв��	M�݆àٔ�.b`���QJ�[H�ku��@��E�Z;�ǿ��v���Z�x)c�D���X�R��ޣFưf��|�뗅��������暺B)/�(�ڈ�'R~
�K^R�^�u�ʖ��O�h��p��V�Sղ�|SF����sVU+� k,�(���A[�u�]�pgH��ॣ����(})?z�P���n�̢�a��`!t}�G�T��x�Ď%���S5�#�d)�H¹�@�NU���Ԗ�Gj�������ҏ1C$K/?-�d��=҃��?��t�*~3<�|�o'��/,��>R����%(��Hz%D���P�_�Mt�,�"��CH�{�I�H6;��!�M�y?ۍ�RK�M�fL����5�~�7a�WCɔ�}΋�&Xp�Y�/͵����#l�F�����zE����~���ޞu���_WU��kډ��U����-�`�A�����Q��۸�M�T�N�W�oC	`�1���6�o��UN\��I�l�--�����W��X��N�7�m��}�TT�6�w@M�$�hIiz���mݮ��&�������S�{\"m,W��)��fP�.3V�'6�<��k&����a���@�wF1�.� �M��m��6|G_�_�Td�����<���Q��V���W��y��uD�"yJ�Y����a9ד�ݭ�Q����Z:e�<{F�Ʌ��iq�yΛb^�E�X<�ODV
�6���K!�0BғH;�s�������d;d�r�e��L=��:���/{�&Uݽ�{ߝ�'O��bzΛ��3����'�rk�ҏF�Ȩ�8O�9	9g{�	��:�P�	CA�
Fy�����H޿a�L�'�E����Ҩ��ٯ*�$dE����g��gV�
�X�y"�m��4�D*�#�f:{�4Ch��ۄU�L��zE���a|�ڃ�X� �FY�(�����
���l��(2͜k\R�-(r�,Go�K!��-6��ͫ
�<��Ժ )	�ӍQ��b�h	���{!�S͛F�\�7�Ҿ�I5,��{�íNmu	�g�&h�K�I����E�L�Ait$犤l?��e#@`-p�]�6)�۝�.�N�j�$�x��4;����<;��
ܥi)��h��Qk��"��h�j�4N5���C.�f6��ej[����,G�(���;T����V���F%�� 챎Oλ�h$�`����Ll��6dFEacLe-.0�~XK�}�R��d�eQQ"�����u|ͮ�.����B�b2�6`�GX*�_
�ȴ13�׹gN�=��>��]��Bl.�h9+��5�hR-��Uh� 4��!u-*��c���3�&d��/��`5^����z��͍h��ǖ�5�o�*c<��͵݌�u��������Qϖw�@"���5�R��k|�g�!���Q+sǛ�}.�ҤQ�����6u���%�)
�˗K�����t�ö�Ew�cK_�r/�������<��~���o��cN�����O{4�e<��W���k�R�30A\��Q�7Ħy�&�jdO�`'b�,�6�59������꘤ Yl�( �EL�<��� �O���1�7�A���oJ��憹ұ�y{�/�;�/J�U��@pI�TgM�3��*]�I��p{��.i;j�C��Z /�ah�VH��21��h��Sq��9��N<iL��CF���< ����ٍ�Vī����`;v��b6��Ns������_g�pH�N+�����!a||&����u6��׹m�W��K4�y�#L�.E���"�� -�u)�z֞���([�-�_��-�9gU��R� 1/�/�G���U#��Rlo\�ȗ �e��/�ݥ�B0�� �b;56X�s�������<u���E�d}�}]c�h�z��/�XE����M�E������_���� �"#��ZnL!yD�Ȁ�C���6`<�{\AD���*�;/C�k����J�4�v�Z��y��4�`��Cy��ʞ����P��R�zK�
��t��cZ%|2ڸwt\0>�Ğo��tTa��o6MU�H�v���0�o��q�>����;d��ZU��4L�ι���f��g��R�ք��wZ���`��%�&4���Ӆ&�@6��7щ.��s=h�a?8	VX
�����MP��E��/AY����7]-G�:���Қ'c��?��|�d-��/2�����r�(��p�����8}�����b�- ^h?%�O�~g��w��׵�Skä2
��f��N\$�������8����ެ
�p�@�[�{;Qv��miN�;I�P�[���'��m��sn٬��ec��5m��7�lL�k�*�t�y���UcU�"�BD�Y"%Toʞ[ݓ����,bv�	�;|�������PA2�������8$������Z�^Q�6Q^����K�Y8�aN2Ք6'�4�Hض=�zq:$(��ҌX��������_�/
D�pW�\���
r]L�ٗxT��h����՞�l�^I��t�'f >�*����Gu��^|�6��&��Xm���|�L" |�b����[�ϔW9��Abk!�ð�����b	�~ϙ�s�M]�TޡHIk�.�u��1P�����8Đ�[;�mb�+ıi�ܲ-������{����IJ>�
�p�g$C"F��g'gU�l��9��.�vJ��广���z��=@~�_��Wy�4�4J|a�'�$�G�'J":�#� 1�������4�t���ϲ�=y&��!ۍy�9!����;�vi{�.#�Q�EDv
ƨX总�l]�]e��e�L���gj���*��'�v������B�FI�`�;`���דC|��O�=��{=�^����`�ې�N����ڮ��}tt�~2�^�$���B�s(8٨7	�t3}��航����s�Of)
��?�����X��\w��ﺓ��.��[��=�ꗳ	��~D�#�vb�v�O���?�	�ĵ��R�{�K��X�0G]���}e��,'(�|��4��ĴP08�X�a��4WC]�iO��	����ۍ�:���Q�Ue�"B5���,�H������0n>�qL��%�=!�:��?NS�>�)�=p[��4Ɖ��u���<r�������m�6!]=������U.�,�mh�Se{��R�q�J�n��nQ�t�2ɽ�����r_p���~�����%"�gI?z���+�\L,�9/�I҄� #�s�R��ǝ�r 5]4��Y^�D_�fP�����t�,��P�yQ��w��3�m�W��;���<g��X9����1�*�1:U7�e��:��rk�'��z��0j��"�{j��CU�m�����7k0ָ����P�0���^�ё+U�-EG�����N�+�����' �2��֗�r-��c� �a��l�4�#�MX��@&l���Q;�vJXp�d^[��=֋h�k�ae��%X�B^>|Y:��uo��Ht���Qw{�� �4M�Dg�rK�&�#�
e�;,���in9���p����]�@�Iq�7M�F���Ajz�Ax�Q?�x��%_H�3�\�n7���=�FOG�����t�����i'k;(��J�=�|�C��y�
�ݣ���,o�15lv���\"4U6Ed٭��&l c������TC��'���c�-y-Di�WyS�KZ|C}zblu��_�9}�������,^�C^e�_���X�� �V���D�S5_t��+LW����ۼ���M���/'��,s�>(��DX��)d�5�K�ޫ���<�s(����7�ڍ�<�a��$����L(�R"�L�)d�[�Ə0|�!�{�����4=���9y�t�~~�?��B$C-�)D�zqѢ�֍C{T,�C&E��$���ĉ���0Z�-����

��uO�:�m���s`F�`-������'f���ާ�b���;��qG��后� }w�y�܊Lv����@u�ah��f���G��6�C~�"S�W{c��^�N�p��eH��us�Y8
J6հ0xv3t_]	�~��׻̸^���\|���`�r)���ݏ��u�d�e"�]���9�-n���� ���Ll��2�'!��rqmv��*'���x��5�	 �W �ݞ�2D�h�U9WA����������54^�kS!Xʷ+>��a�}?%fsqݟ�b��'����X�@���'�#�ڎ��+�K�����K�0s��K<v��M�^�����>dr�R�D\ �>pZ���!�MLJ�5�F�W>T�,ME4�jh�RB�n*Th�kֽ�Y���%����j�E�<?�������E-�;���P�?4� �  