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
  @�  8   T E X T   D E F A U L T T P L       0         Welcome! This is the default template for HFS 2.4
template revision TR3.

Here below you'll find some options affecting the template.
Consider 1 is used for "yes", and 0 is used for "no".

DO NOT EDIT this template just to change options. It's a very bad way to do it, and you'll pay for it!
Correct way: in Virtual file system, right click on home/root, properties, diff template,
put this text [+special:strings]
and following all the options you want to change, using the same syntax you see here.

[+special:strings]

option.newfolder=1
option.move=1
option.comment=1
option.rename=1
COMMENT with these you can disable some features of the template. Please note this is not about user permissions, this is global!

[common-head]
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="/favicon.ico">
	<link rel="stylesheet" href="/?mode=section&id=style.css" type="text/css">

[]
{.$common-head.}
	<title>{.!HFS.} %folder%</title>
    <script type="text/javascript" src="/?mode=jquery"></script>
	<style class='trash-me'>
	.onlyscript, button[onclick] { display:none; }
	</style>
    <script>
    // this object will store some %symbols% in the javascript space, so that libs can read them
    HFS = { folder:'{.js encode|%folder%.}' };
    </script>
	<script type="text/javascript" src="/?mode=section&id=lib.js"></script>
</head>
<body>
	<div id="wrapper">
	<!--{.comment|--><h1 style='margin-bottom:100em'>WARNING: this template is only to be used with HFS 2.3 (and macros enabled)</h1> <!--.} -->
	{.$menu panel.}
	{.$folder panel.}
	{.$list panel.}
	</div>
</body>
<!-- Build-time: %build-time% -->
</html>

[list panel]
{.if not| %number% |{:
	<div id='nothing'>{.!{.if|{.length|{.?search.}.}|No results|No files.}.}</div> 
:}|{:
	<div id='files' class="hideTs {.for each|z|mkdir|comment|move|rename|delete|{: {.if|{.can {.^z.}.}|can-{.^z.} .}:}.}">
	%list%
	</div>
:}.}
<div id="serverinfo">
	<a href="http://www.rejetto.com/hfs/"><i class="fa fa-coffee"></i> {.!Uptime.}: %uptime%</a>
</div>


[menu panel]
<script>
	$(function(){
        if ($('#menu-panel').css('position').indexOf('sticky') < 0) // sticky is not supported
            setInterval(function(){ $('#wrapper').css('margin-top', $('#menu-panel').height()+5) }, 300); // leave space for the fixed panel
    });

    function changePwd() {
        {.if|{.can change pwd.}
        | ask(this.innerHTML, 'password', function(s){
            s && ajax('changepwd', {'new':s}, getStdAjaxCB([
                "!{.!Password changed, you'll have to login again..}",
                '>~login'
            ]))
        })
        | showError("{.!Sorry, you lack permissions for this action.}")
		.}
    }//changePwd

    function ajax(method, data, cb) {
        if (!data)
            data = {};
        data.token = "{.cookie|HFS_SID_.}";
        return $.post("?mode=section&id=ajax."+method, data, cb||getStdAjaxCB());
    }//ajax

</script>

<div id='menu-panel'>
	<div id="title-bar">
		{.$title-bar.}
	</div>
	<div id="menu-bar">
		{.if| {.length|%user%.}
		| <button class='pure-button' onclick='$("#user-panel").toggle()'><i class='fa fa-user-circle'></i><span>%user%</span></button>
		| <button class='pure-button' title="{.!Login.}" onclick='location = "~login"'><i class='fa fa-user'></i><span>{.!Login.}</span></button>
		.}
		{.if| {.get|can recur.} |
		<button class='pure-button' onclick="{.if|{.length|{.?search.}.}| location = '.'| $('#search-panel').toggle().find(':input:first').focus().}">
			<i class='fa fa-search'></i><span>{.!Search.}</span>
		</button>
		/if.}
		<button id="multiselection" class='pure-button' title="{.!Enable multi-selection.}"  onclick='toggleSelection()'>
			<i class='fa fa-check-square'></i>
			<span>{.!Selection.}</span>
		</button>
		{.if|{.can mkdir.}|
			<button title="{.!New folder.}" class='pure-button' id='newfolderBtn' onclick='ask(this.innerHTML, "text", name=> ajax("mkdir", { name:name }))'>
				<i class="fa fa-folder"></i>
				<span>{.!New folder.}</span>
			</button>
		.}
		<button id="toggleTs" class='pure-button' title="{.!Display timestamps.}"  onclick="toggleTs()">
			<i class='fa fa-clock-o'></i>
			<span>{.!Toggle timestamp.}</span>
		</button>

		{.if|{.get|can archive.}|
		<button id='archiveBtn' class='pure-button' onclick='ask("{.!Download these files as a single archive?.}", function() { submit({ selection: getSelectedItemsName() }, "{.get|url|mode=archive|recursive.}") })'>
			<i class="fa fa-file-archive-o"></i>
			<span>{.!Archive.}</span>
		</button>
		.}
		{.if| {.get|can upload.} |{:
			<button id="upload" onclick="upload()" class='pure-button' title="{.!Upload.}">
				<i class='fa fa-upload'></i>
				<span>{.!Upload.}</span>
			</button>
		:}.}

		<button id="sort" onclick="changeSort()" class='pure-button'>
			<i class='fa fa-sort'></i>
			<span></span>
		</button>
	</div>

    <div id="additional-panels">
        <div id="user-panel" class="additional-panel" style="display:none;">
			<span>{.!User.}: %user%</span>
			<button class="pure-button" onclick='changePwd.call(this)'><i class="fa fa-key"></i> {.!Change password.}</button>
        </div>
		{.$search panel.}
		{.$upload panel.}
		<div id="selection-panel" class="additional-panel" style="display:none">
			<label><span id="selected-counter">0</span> {.!selected.}</label>
			<span class="buttons">
				<button id="select-mask" class="pure-button"><i class="fa fa-asterisk"></i><span>{.!Mask.}</span></button>
				<button id="select-invert" class="pure-button"><i class="fa fa-retweet"></i><span>{.!Invert.}</span></button>
				<button id="delete-selection" class="pure-button"><i class="fa fa-trash"></i><span>{.!Delete.}</span></button>
				<button id="move-selection" class="pure-button"><i class="fa fa-truck"></i><span>{.!Move.}</span></button>
			</span>
		</div>
    </div>
</div>

[title-bar]
<i class="fa fa-globe"></i> {.!title.}
<i class="fa fa-lightbulb" id="switch-theme"></i>
<script>
$('body').addClass(getCookie('theme'))
$(function(){

    var titleBar = $('#title-bar')
	var h = titleBar.height()
	var on = true
	var k = 'shrink'
    window.onscroll = function(){
        if (window.scrollY > h)
        	titleBar.addClass(k)
		else if (!window.scrollY)
            titleBar.removeClass(k)
    }

    $('#switch-theme').click(function(ev) {
        var k = 'dark-theme';
        $('body').toggleClass(k);
        setCookie('theme', $('body').hasClass(k) ? k : '');
    });
});
</script>
<style>
	#title-bar { color:white; height:1.5em; transition:height .2s ease; overflow:hidden; position: relative; top: 0.2em;font-size:120%; }
	#title-bar.shrink { height:0; }
	#foldercomment { clear:left; }
	#switch-theme { color: #aaa; position: absolute; right: .5em; }
</style>

[folder panel]
<div id='folder-path'>
	{.breadcrumbs|{:<a class='pure-button' href="%bread-url%"/> {.if|{.length|%bread-name%.}|/ %bread-name%|<i class='fa fa-home'></i>.}</a>:} .}
</div>
{.if|%number%|
<div id='folder-stats'>
	%number-folders% {.!folders.}, %number-files% {.!files.}, {.add bytes|%total-size%.}
</div>
.}
{.123 if 2| <div id='foldercomment' class="comment"><i class="fa fa-quote-left"></i>|{.commentNL|%folder-item-comment%.}|</div> .}

[upload panel]
<div id="upload-panel" class="additional-panel closeable" style="display:none">
	<div id="upload-counters">
		{.!Uploaded.}: <span id="upload-ok">0</span> - {.!Failed.}: <span id="upload-ko">0</span> - {.!Queued.}: <span id="upload-q">0</span>
	</div>
	<div id="upload-results"></div>
	<div id="upload-progress">
		{.!Uploading....} <span id="progress-text"></span>
		<progress max="1"></progress>
	</div>
	<button class="pure-button" onclick="reload()"><i class="fa fa-refresh"></i> {.!Reload page.}</button>
</div>

[search panel]
<div id="search-panel" class="additional-panel closeable" style="{.if not|{.length|{.?search.}.}|display:none.}">
	<form>
		{.!Search.} <input name="search" value="{.escape attr|{.?search.}.}" />
		<br><input type='radio' name='where' value='fromhere' checked='true' />  {.!this folder and sub-folders.}
		<br><input type='radio' name='where' value='here' />  {.!this folder only.}
		<br><input type='radio' name='where' value='anywhere' />  {.!entire server.}
		<button type="submit" class="pure-button">{.!Go.}</button>
	</form>
</div>
<style>
	#search-panel [name=search] { margin: 0 0 0.3em 0.1em; }
	#search-panel button { float:right }
</style>
<script>
    $('#search-panel').submit(function(){
        var s = $(this).find('[name=search]').val()
        var folder = ''
        var ps = []
        switch ($('[name=where]:checked').val()) {
            case 'anywhere': folder = '/'
            case 'fromhere':
                ps.push('search='+s)
                break
            case 'here':
                if (s.indexOf('*') < 0)
                    s = '*'+s+'*'
                ps.push('files-filter='+s)
                ps.push('folders-filter='+s)
                break
        }
        location = folder+'?'+ps.join('&')
        return false
    })
</script>

[+special:strings]
title=HTTP File Server
max s dl msg=There is a limit on the number of <b>simultaneous</b> downloads on this server.<br>This limit has been reached. Retry later.
retry later=Please, retry later.
item folder=in folder
no files=No files in this folder
no results=No items match your search query
confirm=Are you sure?

[icons.css|no log]
@font-face { font-family: 'fontello';
	src: url('data:application/x-font-woff;base64,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') format('woff');
}
.fa { font-family: "fontello"; font-style: normal; font-weight: normal; }
.fa-asterisk::before { content:"\e800" }
.fa-check-circled::before { content:"\e801" }
.fa-user::before { content:"\e802" }
.fa-clock-o::before { content:"\e803" }
.fa-download::before { content:"\e804" }
.fa-ban::before { content:"\e805" }
.fa-edit::before { content:"\e806" }
.fa-check-square::before { content:"\e807" }
.fa-folder::before { content:"\e808" }
.fa-globe::before { content:"\e809" }
.fa-home::before { content:"\e80a" }
.fa-key::before { content:"\e80b" }
.fa-lock::before { content:"\e80c" }
.fa-refresh::before { content:"\e80d" }
.fa-retweet::before { content:"\e80e" }
.fa-search::before { content:"\e80f" }
.fa-star::before { content:"\e810" }
.fa-cancel-circled::before { content:"\e811"; }
.fa-truck::before { content:"\e812" }
.fa-upload::before { content:"\e813" }
.fa-bars::before { content:"\f0c9" }
.fa-coffee::before { content:"\f0f4" }
.fa-quote-left::before { content:"\f10d" }
.fa-file-archive-o::before { content:"\f1c6" }
.fa-trash::before { content:"\f1f8" }
.fa-user-circle::before { content:"\f2bd" }
.fa-lightbulb:before { content: '\f0eb' }
.fa-sort:before { content: '\f0dc' }
.fa-sort-alt-up:before { content: '\f160' }
.fa-sort-alt-down:before { content: '\f161' }

[style.css|no log|cache]
/*! normalize.css v8.0.0 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}h1{font-size:2em;margin:.67em 0}hr{box-sizing:content-box;height:0;overflow:visible}pre{font-family:monospace,monospace;font-size:1em}a{background-color:transparent}abbr[title]{border-bottom:none;text-decoration:underline;text-decoration:underline dotted}b,strong{font-weight:bolder}code,kbd,samp{font-family:monospace,monospace;font-size:1em}small{font-size:80%}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sub{bottom:-.25em}sup{top:-.5em}img{border-style:none}button,input,optgroup,select,textarea{font-family:inherit;font-size:100%;line-height:1.15;margin:0}button,input{overflow:visible}button,select{text-transform:none}[type=button],[type=reset],[type=submit],button{-webkit-appearance:button}[type=button]::-moz-focus-inner,[type=reset]::-moz-focus-inner,[type=submit]::-moz-focus-inner,button::-moz-focus-inner{border-style:none;padding:0}[type=button]:-moz-focusring,[type=reset]:-moz-focusring,[type=submit]:-moz-focusring,button:-moz-focusring{outline:1px dotted ButtonText}fieldset{padding:.35em .75em .625em}legend{box-sizing:border-box;color:inherit;display:table;max-width:100%;padding:0;white-space:normal}progress{vertical-align:baseline}textarea{overflow:auto}[type=checkbox],[type=radio]{box-sizing:border-box;padding:0}[type=number]::-webkit-inner-spin-button,[type=number]::-webkit-outer-spin-button{height:auto}[type=search]{-webkit-appearance:textfield;outline-offset:-2px}[type=search]::-webkit-search-decoration{-webkit-appearance:none}::-webkit-file-upload-button{-webkit-appearance:button;font:inherit}details{display:block}summary{display:list-item}template{display:none}[hidden]{display:none}

{.$icons.css.}

.pure-button {
	background-color: #cde; padding: .5em 1em; color: #444; color: rgba(0,0,0,.8); border: 1px solid #999; border: transparent; text-decoration: none; box-sizing: border-box;
	border-radius: 2px; display: inline-block; zoom: 1; white-space: nowrap; vertical-align: middle; text-align: center; cursor: pointer; user-select: none;
}
body { font-family:tahoma, verdana, arial, helvetica, sans; transition:background-color 1s ease; }
a { text-decoration:none; color:#26c; border:1px solid transparent; padding:0 0.1em; }
#folder-path { float:left; margin-bottom: 0.2em; }
#folder-path a { padding: .5em; }
#folder-path a:first-child { padding:.28em } #folder-path i.fa { font-size:135% }
button i.fa { font-size:110% }
.item { margin-bottom:.3em; padding:.3em  .8em; border-top:1px solid #ddd;  }
.item:hover { background:#f8f8f8; }
.item-props { float:right; font-size:90%; margin-left:12px; color:#777; margin-top:.2em; }
.item-link { float:left; word-break:break-word; /* fix long names without spaces on mobile */ }
.item img { vertical-align: text-bottom; margin:0 0.2em; }
.item .fa-lock { margin-right: 0.2em; }
.item .clearer { clear:both }
.comment { color:#666; padding:.1em .5em .2em; background-color: #f5f5f5; border-radius: 1em; margin-top: 0.1em; }
.comment>i { margin-right:0.5em; }
.item-size { margin-left:.3em }
.selector { float:left; width: 1.2em; height:1.2em; margin-right: .5em;}
.item-menu { padding:0.1em 0.3em; border-radius:0.6em; border: 1px outset; position: relative; top: -0.1em;}
.dialog-content .buttons { margin-top:1.5em }
.dialog-content .buttons button { margin:.5em auto; min-width: 9em; display:block; }
.dialog-content.error { background: #fcc; }
.dialog-content.error h2 { text-align:center }
.dialog-content.error button { background-color: #f77; color: white; }
#wrapper { max-width:60em; margin:auto; } /* not too wide or it will be harder to follow rows */
#serverinfo { font-size:80%; text-align:center; margin: 1.5em 0 0.5em; }
#selection-panel { text-align:center; }
#selection-panel label { margin-right:0.8em }
#selection-panel button { vertical-align:baseline; }
#selection-panel .buttons { white-space:nowrap }

.item-menu { display:none }
.can-comment .item-menu,
.can-rename .item-menu,
.can-delete .item-menu { display:inline-block; display:initial; }

#folder-stats { font-size:90%; padding:.1em .3em; margin:.5em; float:right; }
#files,#nothing { clear:both }
#nothing { padding:1em }

.dialog-overlay { background:rgba(0,0,0,.75); position:fixed; top:0; left:0; width:100%; height:100%; z-index:100; }
.dialog-content { position: absolute; top: 50%; left: 50%;
	transform: translate(-50%, -50%);
	-webkit-transform: translate(-50%, -50%);
	-moz-transform: translate(-50%, -50%);
	-ms-transform: translate(-50%, -50%);
	-o-transform: translate(-50%, -50%);
	background:#fff; border-radius: 1em; padding: 1em; text-align:center; min-width: 10em;
}
.ask input { border:1px solid rgba(0,0,0,0.5); padding: .2em; margin-top: .5em; }
.ask .close { float: right; font-size: 1.2em; color: red; position: relative; top: -0.4em; right: -0.3em; }

#additional-panels input {     color: #555; padding: .1em 0.3em; border-radius: 0.4em; }

.additional-panel { position:relative; max-height: calc(100vh - 5em); text-align:left; margin: 0.5em 1em; padding: 0.5em 1em; border-radius: 1em; background-color:#555; border: 2px solid #aaa; color:#fff; line-height: 1.5em; display:inline-block;  }
.additional-panel .close { position: absolute; right: -0.8em; top: -0.2em; color: #aaa; font-size: 130%; }

body.dark-theme { background:#222; color:#aaa; }
body.dark-theme #title-bar { color:#bbb }
body.dark-theme a { color:#79b }
body.dark-theme a.pure-button { color:#444 }
body.dark-theme .item:hover { background:#111; }
body.dark-theme .pure-button { background:#89a; }
body.dark-theme .item .comment { background-color:#444; color:#888; }
body.dark-theme #foldercomment { background-color:#333; color:#999; }
body.dark-theme .dialog-overlay { background:rgba(100,100,100,.5) }
body.dark-theme .dialog-content { background:#222; color:#888; }
body.dark-theme input,
body.dark-theme textarea,
body.dark-theme select,
body.dark-theme #additional-panels input
{ background: #111; color: #aaa; }

#msgs { display:none; }
#msgs li:first-child { font-weight:bold; }

#menu-panel { position:fixed; top:0; left:0; width: 100%; background:#555; text-align:center;
position: -webkit-sticky; position: -moz-sticky; position: -ms-sticky; position: -o-sticky; position: sticky; margin-bottom:0.3em;
z-index:1; /* without this .item-menu will be over*/ }
#menu-panel button span { margin-left:.8em }
#user-panel button { padding:0.3em 0.6em; font-size:smaller; margin-left:1em; }
#user-panel span { position: relative; top: 0.1em; }
#menu-bar { padding:0.2em 0 }

@media (min-width: 50em) {
#toggleTs { display: none }
}
@media (max-width: 50em) {
#menu-panel button { padding: .4em .6em; }
.additional-panel button span,
#menu-bar button span { display:none } /* icons only */
#menu-bar i { font-size:120%; } /* bigger icons */
#menu-bar button { width: 3em; max-width:10.7vw; padding: .4em 0; }
.hideTs .item-ts { display:none }
}

#upload-panel { font-size: 88%;}
#upload-progress { margin-top:.5em; display:none; }
#upload-progress progress { width:10em; position:relative; top:.1em; }
#progress-text { position: absolute; color: #000; font-size: 80%; margin-left:.5em; z-index:1; }
#upload-results a { color:#b0c2d4; }
#upload-results>* { display:block; word-break: break-all; }
#upload-results>span { margin-left:.15em; } /* better alignment */
#upload-results { max-height: calc(100vh - 11em); overflow: auto;}
#upload-panel>button { margin: auto; display: block; margin-top:.8em;} /* center it*/


[file=folder=link|private]
<div class='item item-type-%item-type% {.if|{.get|can access.}||cannot-access.} {.if|{.get|can archive item.}|can-archive.}'>
	<div class="item-link">
		<a href="%item-url%">
			<img src="%item-icon%" />
			%item-name%
		</a>
	</div>
	<div class='item-props'>
		<span class="item-ts"><i class='fa fa-clock-o'></i> {.cut||-3|%item-modified%.}</span>
[+file]
		<span class="item-size"><i class='fa fa-download' title="{.!Download counter:.} %item-dl-count%"></i> %item-size%B</span>
[+file=folder=link]
		{.if|{.get|is new.}|<i class='fa fa-star' title="{.!NEW.}"></i>.}
[+file=folder]
        <button class='item-menu pure-button' title="{.!More options.}"><i class="fa fa-bars"></i></button>
[+file=folder=link]
 	</div>
	<div class='clearer'></div>
[+file=folder=link]
    {.if| {.length|{.?search.}.} |{:{.123 if 2|<div class='item-folder'>{.!item folder.} |{.breadcrumbs|{:<a href="%bread-url%">%bread-name%/</a>:}|from={.count substring|/|%folder%.}/breadcrumbs.}|</div>.}:} .}
	{.123 if 2|<div class='comment'><i class="fa fa-quote-left"></i><span class="comment-text">|{.commentNL|%item-comment%.}|</span></div>.}
</div>

[error-page]
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style type="text/css">
  {.$style.css.}
  </style>
  </head>
<body>
%content%
<hr>
<div style="font-family:tahoma, verdana, arial, helvetica, sans; font-size:8pt;">
<a href="http://www.rejetto.com/hfs/">HFS</a> - %timestamp%
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
[{.cut|1|-1|%uploaded-files%.}
]

[upload-success]
{
"url":"%item-url%",
"name":"%item-name%",
"size":"%item-size%",
"speed":"%smart-speed%"
},
{.if| {.length|%user%.} |{:
	{.set item|%folder%%item-name%|comment={.!uploaded by.} %user%.}
:}.}

[upload-failed]
{ "err":"{.!%reason%.}", "name":"%item-name%" },

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
	<li> {.!Downloading.} %total% @ %speed-kb% KB/s
	<br /><span class='fn'>%filename%</span>
    <br />{.!Time left.} %time-left%"
	<br><div class='out_bar'><div class='in_bar' style="width:%perc%px"></div></div> %perc%%
:}.}

[ajax.mkdir|no log]
{.check session.}
{.set|x|{.postvar|name.}.}
{.break|if={.pos|\|var=x.}{.pos|/|var=x.}|result=forbidden.}
{.break|if={.not|{.can mkdir.}.}|result=not authorized.}
{.set|x|%folder%{.^x.}.}
{.break|if={.exists|{.^x.}.}|result=exists.}
{.break|if={.not|{.length|{.mkdir|{.^x.}.}.}.}|result=failed.}
{.add to log|{.!User.} %user% {.!created folder.} "{.^x.}".}
{.pipe|ok.}

[ajax.rename|no log]
{.check session.}
{.break|if={.not|{.can rename.}.}|result=forbidden.}
{.break|if={.is file protected|{.postvar|from.}.}|result=forbidden.}
{.break|if={.is file protected|{.postvar|to.}.}|result=forbidden.}
{.set|x|%folder%{.postvar|from.}.}
{.set|yn|{.postvar|to.}.}
{.set|y|%folder%{.^yn.}.}
{.break|if={.not|{.exists|{.^x.}.}.}|result=not found.}
{.break|if={.exists|{.^y.}.}|result=exists.}
{.set|comment| {.get item|{.^x.}|comment.} .}
{.set item|{.^x.}|comment=.}
{.break|if={.not|{.length|{.rename|{.^x.}|{.^yn.}.}.}.}|result=failed.}
{.set item|{.^x.}|resource={.filepath|{.get item|{.^x.}|resource.}.}{.^yn.}.}
{.set item|{.^x.}|name={.^yn.}.}
{.set item|{.^y.}|comment={.^comment.}.}
{.add to log|{.if|%user%|{.!User.} %user%|{.!Anonymous.}.} {.!renamed.} "{.^x.}" {.!to.} "{.^yn.}".}
{.pipe|ok.}

[ajax.move|no log]
{.check session.}
{.set|dst|{.postvar|dst.}.}
{.break|if={.not|{.and|{.can move.}|{.get|can delete.}|{.get|can upload|path={.^dst.}.}/and.}.} |result=forbidden.}
{.set|log|{.!Moving items to.} {.^dst.}.}
{.for each|fn|{.replace|:|{.no pipe||.}|{.postvar|files.}.}|{:
    {.break|if={.is file protected|var=fn.}|result=forbidden.}
    {.set|x|%folder%{.^fn.}.}
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
                {.^fn.}: {.!not moved.}
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
     {.set item|%folder%{.^fn.}|comment={.postvar|text.}.}
:}.}
{.pipe|ok.}

[ajax.changepwd|no log]
{.check session.}
{.break|if={.not|{.can change pwd.}.} |result=forbidden.}
{.if|{.length|{.set account||password={.postvar|new.}.}/length.}|ok|failed.}

[special:alias]
check session=if|{.{.cookie|HFS_SID_.} != {.postvar|token.}.}|{:{.cookie|HFS_SID_|value=|expires=-1.} {.break|result=bad session.}:}
can mkdir=and|{.get|can upload.}|{.!option.newfolder.}
can comment=and|{.get|can upload.}|{.!option.comment.}
can rename=and|{.get|can delete.}|{.!option.rename.}
can delete=get|can delete
can change pwd=member of|can change password
can move=or|1|1
escape attr=replace|"|&quot;|$1
commentNL=if|{.pos|<br|$1.}|$1|{.replace|{.chr|10.}|<br />|$1.}
add bytes=switch|{.cut|-1||$1.}|,|0,1,2,3,4,5,6,7,8,9|$1 {.!Bytes.}|K,M,G,T|$1B

[special:import]
{.new account|can change password|enabled=1|is group=1|notes=accounts members of this group will be allowed to change their password.}

[lib.js|no log|cache]
// <script> // this is here for the syntax highlighter

function outsideV(e, additionalMargin) {
    outsideV.w || (outsideV.w = $(window));
    if (!(e instanceof $))
        e = $(e);
    return e.offset().top + e.height() > outsideV.w.height() - (additionalMargin || 0) - 17;
} // outsideV

function selectionChanged() { $('#selected-counter').text( getSelectedItems().length ) }

function getItemName(el) {
    if (!el)
        return false
    el = $(el)
    var a = el.closest('a')
    if (!a.length)
        a = el.closest('.item').find('.item-link:first a')
    // take the url, and ignore any #anchor part
    var s = a.attr('href') || a.attr('value');
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
    var f = $('<form method="post">').attr('action',url||undefined).hide().appendTo('body')
    for (var k in data) {
        var v = data[k]
		if (!Array.isArray(v))
            f.append("<input type='hidden' name='"+k+"' value='"+v+"' />")
		else
		    v.forEach(function(v2) {
				f.append("<input type='hidden' name='"+k+"' value='"+v2+"' />")
        	})
    }
    f.submit()
}//submit

RegExp.escape = function(text) {
    if (!arguments.callee.sRE) {
        var specials = '/.*+?|()[]{}\\'.split('');
        arguments.callee.sRE = new RegExp('(\\' + specials.join('|\\') + ')', 'g');
    }
    return text.replace(arguments.callee.sRE, '\\$1');
}//escape

function dialog(content, cb) {
    var ret = $('<div class="dialog-content">').html(content).keydown(function(ev) {
		if (ev.keyCode===27)
			ret.close()
	})
	ret.close = function() {
        ret.closest('.dialog-overlay').remove()
        cb && cb()
    }
    ret.appendTo(
        $('<div class="dialog-overlay">').appendTo('body')
            .click(ret.close)
    ).click(function(ev){
        ev.stopImmediatePropagation()
    })
    return ret
} // dialog

function showMsg(content, cb) {
	if (~content.indexOf('<'))
		content = content.replace(/\n/g, '<br>')
    var ret = dialog($('<div>').css({ display:'inline-block', textAlign:'left' }).html(content), cb).css('text-align', 'center')
		.append(
			$('<div class="buttons">').html(
				$('<button class="pure-button">').text("{.!Ok.}")	
					.click(ev=> ret.close() ) ) )
	return ret
}//showMsg

function showError(msg, cb) {
    return msg && showMsg("<h2>{.!Error.}</h2>"+msg, cb).addClass('error')
}

/*  cb: function(value, dialog)
	options: type:string(text,textarea,number), value:any, keypress:function
*/
function ask(msg, options, cb) {
    // 2 parameters means "options" is missing
    if (arguments.length == 2) {
        cb = options;
        options = {};
    }
	if (typeof options==='string')
		options = { type:options }
    msg += '<br />';
    var v = options.type
	if (!v)
	    msg += '<br><button class="pure-button">{.!Ok.}</button>'
	else if (v == 'textarea')
		msg += '<textarea name="txt" cols="30" rows="8">'+options.value+'</textarea><br><button type="submit" class="pure-button">Ok</button>';
	else
		msg += '<input name="txt" type="'+v+'" value="'+(options.value||'')+'" />';
	var ret = dialog($('<form class="ask">')
		//.html($(`<i class="fa fa-times-rectangle close">`).click(ev=>ret.close()))
		.append(msg)
		.submit(function(ev) {
			if (false !== cb(options.type ? $.trim(ret.find(':input').val()) : $(ev.target), $(ev.target).closest('form'))) {
                ret.close()
                return false
            }
		})
	)

    ret.find(':input').focus().select() // autofocus attribute seems to work only first time :(

	return ret
}//ask

// this is a factory for ajax request handlers
function getStdAjaxCB(what2do) {
    if (!arguments.length)
        what2do = true;
    return function(res){
        res = $.trim(res);

        if (res !== "ok") {
            showError("{.!"+res+".}")
            if (res === 'bad session')
                location.reload();
            return;
        }
        // what2do is a list of actions we are supposed to do if the ajax result is "ok"
        if (what2do === null)
            return;
        if (!$.isArray(what2do))
            what2do = [what2do];
        what2do.forEach(w=>{
			if (w===true)
				return location.reload()
			if (typeof w==='function')
				return w() // you specify exactly what to do
			switch (w[0]) {
				case '!': return showMsg(w.substr(1))
				case '>': return location = w.substr(1)
			}
        })
    }
}//getStdAjaxCB

function getSelectedItems() {
    return $('#files .selector:checked')
}

function getSelectedItemsName() {
    return getSelectedItems().get().map(function(x) {
        return getItemName(x)
    })
}//getSelectedItemsName

function deleteFiles(files) {
	ask("{.!confirm.}", function(){
		return submit({ action:'delete', selection:files })
	})
}

function moveFiles(files) {
	ask("{.!Enter the destination folder.}", 'text', function(dst) {
		return ajax('move', { dst: dst, files: files.join(':') }, function(res) {
			var a = res.split(';')
			a.pop()
			if (!a.length)
				return showMsg($.trim(res))
			var failed = 0;
			var ok = 0;
			var msg = '';
			a.forEach(function(s) {
				s = $.trim(s)
				if (!s.length) {
					ok++
					return
				}
				failed++;
				msg += s+'\n'
			})
			if (failed)
				msg = "{.!We met the following problems:.}\n"+msg
			msg = (ok ? ok+' {.!files were moved..}\n' : "{.!No file was moved..}\n")+msg
			if (ok)
				showMsg(msg, reload)
			else
				showError(msg)
		})
	})
}//moveFiles

function reload() { location = '.' }

function selectionMask() {
    ask("{.!Please enter the file mask to select.}", {type:'text', value:'*'}, function(s){
        if (!s) return;
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
                s = "^ *"+s+" *$"; // in this case var the user decide exactly how it is placed in the string
            }
            re = new RegExp(s, "i");
        }
        $("#files .selector")
            .filter(function(i, e) {
                return invert ^ re.test(getItemName(e));
            })
            .prop('checked',true);
        selectionChanged()
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

function delCookie(name) { setCookie(name,'', -1) }

function getCookie(name) {
	var a = document.cookie.match(new RegExp('(?:^| )' + name + '=([^;]+)'))
	return a && a[1]
} // getCookie

// quando in modalità selezione, viene mostrato una checkbox per ogni item, e viene anche mostrato un pannello per all/none/invert
var multiSelection = false
function toggleSelection() {
    $('#selection-panel').toggle()
	if (multiSelection = !multiSelection)
		$("<input type='checkbox' class='selector' />")
			.prependTo('.item-selectable a') // having the checkbox inside the A element will put it on the same line of A even with long A, otherwise A will start on a new line.
			.click(ev=>{ // we are keeping the checkbox inside an A tag for layout reasons, and firefox72 is triggering the link when the checkbox is clicked. So we reprogram the behaviour.
				setTimeout(()=>{ 
					ev.target.checked ^= 1
					selectionChanged() 
				})
				return false 
			})
	else
		$('#files .selector').remove()
}//toggleSelection

function upload(){
	$("<input type='file' name='file' multiple>").change(function(){
		var files = this.files
		if (!files.length) return
		$('#upload-panel').slideDown('fast')
		uploadQ.add(function(done){
			sendFiles(files, done)
		})
  	}).click()
} //upload

uploadQ = newQ().on('change', function(ev) {
    var n = Math.max(0, ev.count-1) // we don't consider the one we are working
    $('#upload-q').text(n)
})

function newQ(){
    var a = []
	var ret = $({})
    ret.add = function(job) {
        a.push(job)
		change()
        if (a.length!==1) return
		job(function consume(){
			a.shift() // trash it
			if (a.length)
				a[0](consume) // next
			else
				ret.trigger('empty')
			change()
		})
    }

    function change(){ ret.trigger({ type:'change', count:a.length }) }

	return ret
}//newQ

function changeSort(){
    dialog([
        $('<h3>').text('{.!Sort by.}'),
        $('<div class="buttons">').html(objToArr(sortOptions, function(label,code){
            return $('<button class="pure-button">')
				.text(label)
				.prepend(urlParams.sort===code ? '<i class="fa fa-sort-alt-'+(urlParams.rev?'down':'up')+'"></i> ' : '')
                .click(function(){
					urlParams.rev = (urlParams.sort===code && !urlParams.rev) ? 1 : undefined
					urlParams.sort = code||undefined
                    location.search = encodeURL(urlParams)
				})
		}))
	])
}//changeSort

function objToArr(o, cb){
    var ret = []
	for (var k in o) {
	    var v = o[k]
		ret.push(cb(v,k))
	}
	return ret
}

function sendFiles(files, done) {
    var formData = new FormData()
    for (var i = 0; i < files.length; i++)
        formData.append('file', files[i])

    $.ajax({
        type: 'POST',
        data: formData,
        success: function(data) {
            try {
                data = JSON.parse(data)
                data.forEach(function(r) {
                    $('#upload-'+(r.err ? 'ko' : 'ok')).text(function(i, s) {
                        return Number(s) + 1
                    })
                    $(r.err ? '<span title="'+r.err+'"><i class="fa fa-ban"></i> '+ r.name+'</span>' 
						: '<a title="{.!Size.}: '+r.size+'&#013;{.!Speed.}: '+r.speed+'B/s" href="'+r.url+'"><i class="fa fa-'+(r.err ? 'ban' : 'check-circle')+'"></i> '+r.name+'</a>')
						.appendTo('#upload-results');
                })
            }
            catch(e){
                console.error(e)
                showError('Invalid server reply')
            }
        },
        complete: done,
        cache: false,
        contentType: false,
        processData: false,
        xhr: function() {
            var e = $('#upload-progress')
            var prog = e.find('progress').prop('value', 0)
            e.slideDown('fast')
            var xhr = $.ajaxSettings.xhr()
            var last = 0
            var now = 0
            xhr.upload.onprogress = function(ev){
                prog.prop('value', (now = ev.loaded) / ev.total);
            }
            var h = setInterval(function() {
                $('#progress-text').text(smartSize(now)+'B @ '+smartSize(now-last)+'/s')
                last = now
            },1000)
            xhr.upload.onload = function(ev) {
                e.slideUp('fast')
                clearInterval(h)
            }
            return xhr
        }
    })
}//sendFiles

function smartSize(n, options) {
    options = options||{}
	var orders = ['','K','M','G','T','P']
	var order = options.order||1024
	var max = options.maxOrder||orders.length-1
	var i = 0
	while (n >= order && i<max) {
		n /= order
		++i
	}
	if (options.decimals===undefined)
		options.decimals = n<5 ? 1 : 0
	return round(n, options.decimals)
		+orders[i]
}//smartSize

function round(v, digits) {
	return !digits ? Math.round(v) : Math.round(v*Math.pow(10,digits)) / Math.pow(10,digits)
}//round

function log(){
	console.log.apply(console,arguments)
	return arguments[arguments.length-1]
}

function toggleTs(){
    var k = 'hideTs'
    $('#files').toggleClass(k)
    setCookie('ts', Number(!$('#files').hasClass(k)));
}

function decodeURL(urlData) {
	var ret = {}
    urlData.split('&').forEach(function(x){
        if (!x) return
        x = x.split("=").map(decodeURIComponent)
		ret[x[0]] = x.length===1 ? true : x[1]
    })
	return ret
}//decodeURL

function encodeURL(obj) {
    var ret = []
	for (var k in obj) {
	    var v = obj[k]
		if (v===undefined) continue
		k = encodeURIComponent(k)
	    if (v !== true)
	        k += '='+encodeURIComponent(v)
		ret.push(k)
	}
	return ret.join('&')
}//encodeURL

urlParams = decodeURL(location.search.substring(1))
sortOptions = {
	n: "{.!Name.}",
	e: "{.!Extension.}",
	s: "{.!Size.}",
	t: "{.!Timestamp.}",
	d: "{.!Hits.}",
	'': '{.!Default.}'
}

$(function(){
    $('.trash-me').detach(); // this was hiding things for those w/o js capabilities
    if (Number(getCookie('ts')))
        toggleTs()

    $('body').on('click','.item-menu', function(ev){
        var it = $(ev.target).closest('.item')
        var acc = it.hasClass('can-access')
        var name = getItemName(ev.target)
        dialog([
            $('<h3>').text(name),
            it.find('.item-ts').clone(),
            $('<div class="buttons">').html([
                it.closest('.can-delete').length > 0
				&& $('<button class="pure-button"><i class="fa fa-trash"></i> {.!Delete.}</button>')
					.click(function() { deleteFiles([name]) }),
                it.closest('.can-rename').length > 0
				&& $('<button class="pure-button"><i class="fa fa-edit"></i> {.!Rename.}</button>').click(renameItem),
                it.closest('.can-comment').length > 0
				&& $('<button class="pure-button"><i class="fa fa-quote-left"></i> {.!Comment.}</button>').click(setComment),
                it.closest('.can-move').length > 0
				&& $('<button class="pure-button"><i class="fa fa-truck"></i> {.!Move.}</button>')
					.click(function(){  moveFiles([name]) })
            ])
        ]).addClass('item-menu-dialog')

        //{.if|{.and|{.!option.move.}|{.can move.}.}| <button id='moveBtn' onclick='moveFiles()'>{.!Move.}</button> .}

        function setComment() {
            var value = it.find('.comment-text').text() || '';
            ask(this.innerHTML, { type: 'textarea', value: value }, function(s){
                if (s !== value)
                    ajax('comment', { text: s, files: name })
            })
        }//setComment

        function renameItem() {
            ask(this.innerHTML+ ' '+name, { type: 'text', value: name }, function(to){
                ajax("rename", { from: name, to: to });
            })
        }
    })

    $('#select-invert').click(function(ev) {
        $('#files .selector').prop('checked', function(i,v){ return !v })
        selectionChanged()
    })
    $('#select-mask').click(selectionMask)
    $('#move-selection').click(function(ev) { moveFiles(getSelectedItemsName()) })
		.toggle($('.can-delete').length > 0)
    $('#delete-selection').click(function(ev) { deleteFiles(getSelectedItemsName()) })
        .toggle($('.can-delete').length > 0)

    $('#files .cannot-access .item-link img').after('<i class="fa fa-lock" title="{.!No access.}"></i>')
	$('#files.can-delete .item:not(.cannot-access), #files .item.can-archive').addClass('item-selectable')
    if (! $('.item-selectable').length)
        $('#multiselection').hide()

    $('.additional-panel.closeable').prepend(
        $('<i class="fa fa-times-circle close">').click(function(ev){
            $(ev.target).closest('.closeable').fadeOut('fast').trigger('closed')
        }))

    $('#upload-panel').on('closed', function(ev){
        $('#upload-ok,#upload-ko').text('0')
        $('#upload-results').html('')
    })

	$('#sort span').text(sortOptions[urlParams.sort]||'{.!Sort.}')

    /* experiment
    $('.additional-panel.closeable').each(function(i, e) {
        swipable(e, 'right')
    })

    function swipable(e, dir) {
        e = $(e)
        e.mousedown(function(ev) {
            e.css('position','relative')
            var o = { x:ev.pageX, y:ev.pageY }
            console.warn(o)
            e.mouseup(function(ev) {
                e.css({ left: 0, top: 0 })
                e.off('mousemove.dragging')
            })
            e.on('mousemove.dragging', function(ev) { return e.css({ left:ev.pageX-o.x, top:ev.pageY-o.y }) })
        })
    }
    */

    selectionChanged()
})//onload
  8   T E X T   C O P Y R I G H T         0         HFS version %s, Copyright (C) 2002-2020  Massimo Melina (www.rejetto.com)
HFS comes with ABSOLUTELY NO WARRANTY; for details click Menu -> Web links -> License
This is FREE software, and you are welcome to redistribute it
under certain conditions.

Build #%s
   <   T E X T   D M B R O W S E R T P L       0         <html>
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
    8   T E X T   I N V E R T B A N         0         Normal behavior of the Ban is to prevent access to the addresses you specify (also called black-list).
If you want the opposite, to allow the addresses that you specify (white-list), enter all addresses in a single row preceded by a \ character.

Let say you want to allow all your 192.168 local network plus your office at 1.1.1.1.
Just put this IP address mask: \192.168.*;1.1.1.1
The opening \ character inverts the logic, so everything else is banned.

If you want to know more about address masks, check the guide.
K   <   T E X T   F I L E L I S T T P L         0         %files%

[files]
%list%

[file]
%item-full-url%

[folder]
%item-full-url%

 �   @   T E X T   U P L O A D D I S A B L E D       0         You selected a virtual folder.
Upload is NOT available for virtual folders, only for real folders.

=== How to get a real folder?
Add a folder from your disk, then click on "Real Folder".
  <   T E X T   U P L O A D H O W T O         0         1. Add a folder (choose "real folder") 

You should now see a RED folder in your virtual file sytem, inside HFS 

2. Right click on this folder
3. Properties -> Permissions -> Upload
4. Check on "Anyone"
5. Ok 

Now anyone who has access to your HFS server can upload files to you.
    0   T E X T   A L I A S         0         var length=length|var=$1
cache=trim|{.set|#cache.tmp|{.from table|$1|$2.}.} {.if not|{.^#cache.tmp.}|{:{.set|#cache.tmp|{.dequote|$3.}.}{.set table|$1|$2={.^#cache.tmp.}.}:}.} {.^#cache.tmp.} {.set|#cache.tmp.}
is substring=pos|$1|$2
set append=set|$1|$2|mode=append
123 if 2=if|$2|$1$2$3
between=if|{.$1 < $3.}|{:{.and|{.$1 <= $2.}|{.$2 <= $3.}:}|{:{.and|{.$3 <= $2.}|{.$2 <= $1.}:}
between!=if|{.$1 < $3.}|{:{.and|{.$1 < $2.}|{.$2 < $3.}:}|{:{.and|{.$3 < $2.}|{.$2 < $1.}:}
file changed=if| {.{.filetime|$1.} > {.^#file changed.$1.}.}|{: {.set|#file changed.$1|{.filetime|$1.}.} {.if|$2|{:{.load|$1|var=$2.}:}.} 1:}
play system event=play
redirect=add header|Location: $1
chop={.cut|{.calc|{.pos|$2|var=$1.}+{.length|$2.}.}||var=$1|remainder=#chop.tmp.}{.^#chop.tmp.}   C   8   T E X T   I P S E R V I C E S       0         http://hfsservice.rejetto.com/ip.php|!
http://checkip.dyndns.org|:
 9�  4   Z T E X T   J Q U E R Y         0         �     �{w�������Oak�0�-���{�W͙��i�ݙ1s� a�m�p�m<��UID�x��R�*�
���pp���L�7������A10}Zu�Ivq �(�����&I�<_G��398;��p�8�̣$�.������L��&	vki'&�n��yfw�\L���md��@N�� �Qh�)4_��� ����i��&)�O��.Je6��(�[x�+hU+	��2ߥ� �н�~M\�0�e@��z��V��2���F��;.Z�3��I��b!��I시-�u��Vl/ P�}Y���G�<���Q�dW�X���m�1M�2���'m8��",�]"JfP�$�x���=K��g�-vo^�y��{1uG�A����ma�x����5?��"��]z��Xڏ�����^�L�t?G�<�l�$OPz�A���a �,Ow~��V�2������2_YS�'/�T�7�ɉ/�ke�,e�6����z=�^g:b�����Z�ϵ��P�r�_u@�J=�d#ӥ4�&e�1`W�|P6Εux87�w�Y5��gR��^�'8�� dг��MS�j��x�̮Az̯��(v�P��챁|
����v}_ғ.�Ag ��,?@^�S���p�xs�u��[�b>������)����_�ax��(���k9.����\��*�c�j{��,�Xd�|�l�bÖzٳx���zo�CvC�����3u�<y�g,��k�/�p61�yI��"n���0�K�� [��F#ʎ��( do*���(�%�
�9� �R�j<���b5G@`�'����R�+D��T���%���s�3| ֏k�ZΦ��=������R���?`��\F3(�-P�V�߆�F�eD�+ٛ� d j�$Q0��Ԩ)>��g�(�|��F@<���������W��7&��Tn����DGB(��ߤ��I�m:6|���I�m�5��qpRu��9ԣS��R�����������[��i�s1�[�xjO#��Iqn�Q��p�m��K��"��u"rӣ�8*�}����Z�Ǡ��{h_��Pgx\]�A�j�E�Ö�BL�$����NQI�Lyz�Ʌh�^� *i�Z�t4[#@p�����9{��UҾ�$�����H��
���T���{ιW��{��O�sa�!�Q�@1V�Z�v�\����Hڪ��+׉'֯oĺA
邇~��8� /��'?����aֶ�&rው\c��Ǌ�u��/���k�*'�{�`��0bR�F��6��l���ʏ�@�)�b������(��ܿ恎�^�%�π��g�K����5$�u��|Ee
���?R:��D�7�J�0���ʉ�C�r��a� F��L�*c��T�h�&_�ZK͇�`����c���X����U��*����p��|H }[��3�,����<��羖��R���!�~����x�g��^I�*t�l&�ޮ��4A�T8r4r���@&|ܕ��PmS8�L-	�@r�Я@QG�AΕ����G�,kR؊���"���q��N�( ��0�J�ToG�J=�5�$[���[�f?�XΗ�NrĶt�V3m*�^+�Q�ym�Ke��tAE_X&���
�(�fb��}�/��\zh��|3���\�q��t�%Amp��P'B�[ ?�-EI���JV���C ��`��s�~�Ƅ�шU&����8�a��J䠮l��c���S��?�o�d�r�0vtk�2�Y��?ꢬ<��t:�T���@o��J<峊��or��n;�a@g?%b�R��$B͑C�D� #oD\�Y��
]�d á0�M���@K4�_o���?����̪s&-�P+�;��]L1��)��#)9?�BZ)?[��]�+�f��mlG,c9�q�E����d4;�T�n�Ń[�;���/�I����B?~��;��^s��0���|���Of������2��דm�e?��?U/?Ë.^��EVG�k�~[���^S�ML��%�+� /"���B��$�3��]C���4YgE C�A�	oVQȸ�2�U�R�b�[��v-�d�A��]B\>����Y,.�b�.�b����Ĵ��3)`���-�/0q:ï��tD�{N��ގșIF�F�¢��}yT��6�����/�|��3��X�Á��)J��(�,@�N�r@�3M��M���: �-������b���}�h�گM��'KB���䋢q� )�������r�o=�Ϙ~��aӹ}uՠ��ϝ���
����3�-=����(��2�#��g���+�3�M)z}��ŧO�Q`������*�3�_|��[wDO��O�������@���o��LeتS����
�c��M��H�1��\J����$@_�,���EpF㢱X5P�qx�P6K� p�ŉN�~1<*��R�K]��z4�k5T��b	<i��<@cdQIof����?*Iܳ��s�*����6#R)
o��IL�G�0o���o��|ypG��Ev�pb�G7r��=g�4�oL���\���bRu ,�w~� W�L~θ���':���K���3�|����!8�b m��7�dzGF����gO�W�&uAQ�X.�l�[O�4ټ\��eH3������M�gϾ��9�M�}bų�O��z^ ����xV���x^�u�s3Q���e�u[��v�*�և��H,}��?(���r���~,�
V��(��f颕����p�&զ�j�ao���d#wr+d�r+O�~�1��L_U[��l������ u��ah�:ac�bZ�3���c���Ҩ�hH��M�>@V�uCavlx�ff-1�RuT��p̈́?Rgm��)�<qf���G\�6���7Y���Z"��̐�!��(�aݩS�K�}V�9��By��0r�c���gp����֭�++X�����b�u�)
sO\��wg��0���wb�[�L�H���:Pz��^�Z�'���4�u�u
�2.敨ZU*��� ��+��9XD,i�( ��W��>�� �<2��Iv8�]�e)_���i�k�'M���7dte��F�KJ��p
�_�FG����g �2�b�0B��^�l�0��V� 7�u
����(ƌ#1�N���O����
��P2�����s�C�r��������#�����G3BK_n|)�*=�f�n���l�im�>�N/��/��|��gP�ˁ�I���ܤ.�5�岢�kP�D�f��\�ҙh�#����R䲴?����F��!H�ka�U`�V)���u���v+�]�N�Np��I�[�`�D�*~q����H��-����0l
`u~�9o�������W��d���g�JZ/���*�T�������1l��"o���P�T2�Օ{f�g�붢�^�a��]���7�i��9m�w�_�7[���<F��	|qZaee�|����M~�Xn��dKv�`	f ��!�p0����)��5II��﫻��`?{��bR�=�x��(�˻���s�)7OA��v����k��>�{ۍ����
��+(ǸT�L��ج�
�Roٸ�.[ƾ<$�6c�d	�ؖC3�̔8(C'�?E�����=r"����xe�z��.�ND@X �pF-��QN�2�N�$I�L��-����H���y��79������ ��T~
6�!2t �"��d�#&����x�,���������/Wb�s�ĤC�������  �*��^swH&"��`�L~~�Jja������0�U�9j�f�v|����3ķ�e�{<��m=��@�Ύ����=��rG�����VL�ɤK��%��4��D0���,if%�p����k���uԻ�d�k��Ə�'Q׎�+�X��|�B~
8n��#��C����+�}�o���L�j)�J�J>�l�Og����������<X��_�N�k?�"�X��>��8�)��|/:{�A�|�����^W��1�6�X��[_l�K���d�6Ū���u'����ı����ֺul3�k���I�7uI�.�b����U��j[�
,���_�������*qϚz���F���,�|3a�F�6m��μu�E�g+4I.E#)�����Xlp��Sb�q��G����I��Xx�~�UC�XU��3f��P��M�,�E����Cf��ʁ2�TCE�Ln�w��sq`���ӛ���:�#4�O�?�ce�j>�����Ě���;oi�ېCqm�_ׂoU��CnA(,�iߜ�=ǫ$�L�d���*��dNY���ִ8Q�Q����]�d��t��Ӕ�=����*�Cs�BSP�^�Fm7�f@-q�t8�=7N����B��x�w����8���>���3,��{��������t�ˡÓ4��ީ�z���x���u7j��G��(u}u���Y��S���F��8�:o�xv���3�ӳ�S����ue�b^��1>�����p��XA��ח�a��n.�#\�๺Z	�ץ=�QM4�%����eS��s��y}�o��r��u���Y^��U{���nr��F�� %�15b��n��U�>���<��=E��?ƪ2VV�Gq�Q�<RF�Ve^�ʼu������7|v�!%R�I�.M���TG��n�{T}N;T4=]_)��P[M4*K�MGi��LUᇂ^#!��Z<`E՞u1EIU�_��DJ�)*��� �?^�L_�NQ��Z��B<c��Rj�d3�-'n�$�{aІvh�OҠ��}pN1C�s<Q��B'�(�d`��|b�P��*�G�Tɧ{���@�d�]�J?Y���2Ȼm*�VZP�Z��8���S���@����O�vdv�j����Ȯx?嘉�З�)eB�?P��N���s|E{��<y���������jO�]O��3��B%�����_��x��PW�1H�w�1æ8��6��� �t:��5h��N�8��;�uK��Sdy�Q?mGKM�P�z^#7�Хax�Av�]���"��ڶ�l�t�1�� �V���b��5��w��p��T��C)��b=Qj�&���/�C���N�M�첒��گ�&A��ިb�����������p�|5�&��p���g�K=��e�ߢ���]_�WV2{J���?��/��"���j��UͩK�G&>l$_�ô��=3	~YG`z-I��jQ�p�Z��] ��&X�0�C���B���a�t*S��D�@�2
���h)�l�ɻ"�|������.������F�GS&��.J�=:��q"��S�УL!�[=�Ւ1ݣAk�{����_��u���ްS����u���C�}���a�_[t.�_�40�T�xS��_�{���ߔ]Z����e6����|m��{t����W}����nL�y玳��l�r�<۔#�Dw�~}K�cs��_�&��^dmg>��Y3���ܐ<j�isjlQ��ZN11V�ڊ>2hS7�mZ�B�vZA�l(�+�`]���׺��Utv�fϖ��5�v��)~+&�%"EI%^���RD������B����H�ѹ�C���Ik�#=��u�ؑ���S�XƇ$�+�����k�C�U:��M}`����u)����i�K-�|s����o9�KY��obv�����;K����[Px�˖��!u�lt�\�d|��ٺ�kgSf_?�¡v[Ϲ�W�pՕ��_b���0.a;i�����6�vݺ���n-��3a���"Xŧ�	^5)
�+	��r��N���;���ܝ�d�3��0 ���e��c���S�%������J8�K��W�O7�1������8�����)�-Y�N8�f��j&�ʎ�YjF҂�rm�l )T�~���L�\s-�!:+M�ό[������@��������ݼ�T}Ɔ[��A�A~��"�}��:�-#��}��~P����i���b�.t���L�u���Ӣ����EP-����Z��ה
�2n���
?�Uc�*��i�Ԇ�ΎM�p���c�_ZVV�{1�	��w�X/&67�{�7�����A�&��9�hSY�;%~f��ȑ���Q]�������H�ܯd]�+Es��c�
��)��� ����`Bz �B�S�mKa���նXP��+p��Uq5�Q��V*Sص�Q^��.ށ���Ŵ^ﱌxI�/{��r�!�I��x7U��
���T�㸾��O ��xMK*�b�h��B��rmc_.:|L��Oױ�����1:�Ƭ��E�w�_��qM@\�*�@���TAqr�����Ŧ�������d��ՖW1�.;���[���ʌ'������)�S��š�D�QuQ��m���-Њ�< ��N4С�|/:(�~1=��1[i�Hk���rȵ�Z�)�f3ַ_e��1��<�c��,RM��i�d��r��ʭ��4��jg�T ���������!�P����I�ζ�U�ގt���蒇�SRLB��e?��|�EV�2����ݩ�3-Y��|��>����D-x[�w_����4������Sw����dR?-G���8��L��_zu�MQ/�����_�_#<�������_oj�����[���dh!���ܕ��[��4�A�_"N�.`@ຈ��8	����:" �VL�Y׌"��ʚ��Q�иP^4�8��t���z	���;��r�CE�aژE�|���b�,��ihY��r�.�^Z�.A�|lC��$M��m�L�?ɻ]w �ѷ=���J��\M���F��LHe��s��� �6�{w+���c�fW�`�UV�ۏ�¦g�<P�T�{Jc���oâxY�@�c��{HR9/�%T�'��*� ��!m���II��F7c������笔{'���c�dg�l,#t�׶D�\0���5�wӌ�|z6ݩ��0�C�����ܔ��+�oI��<��o�C�{	������zc�&Ȑ��� ���7lo$�{ӑ��O��{�X1��f���G���P�m1r��Ɣvcm����C�sWBT�����	�2,�s#�ߥ7F��}*�@��Á!������B��^|^�&�O�� �AG�kCyhTtCq��5�C~���s�K�BW��gm�/���� B��I�A����-�u�����S��F�Z_��덩��9ˋlݶ��Oϲy��<�[pNL����}E�9���s�]x|�h!_��nN�(���KZ)���.��@��lF�m�9O�� �i�ؐݝSs��(N{�!���^�쒢�*����9Z8��'�x�6�n�o�|�m�nrۂ��P��S:�ώ0�}��|�59���1�N�E��ҝ�m������B��`�04�jG��a�����B�x��ϱv��%α)�!Qa�]������2#D�-i�<[N��*F��K�WE���t�t�ΦNQ��H��3��X{RQ�X2���Ts3m��N���ԡ�a/�ъ�fp���e/ɰ�3�`o�dOZ˃dN[1K��R}�����ȥn���H�5.�ǢzZ���u�8Z-��]wx�lM�����/��i��Qyc��D�:0hS�ag�2��5�jOG��.�o���gZ�W:����D�n^�=�y�c"dD��BMohm���5	�2�Oo� Fӆ@��~Mm�ܫ�T�H��J�ɵ�t��Y�-�|�B�+�POr�,���7oԶ� D	^��G�6����e�3k317�2��n�����^���C�?��XI�:�n�om{�S��/D�cI;�GΝںsd�&�����H���a�D;�ү�7}n^)}�R��kT6s�f&�f�F�[�[�|����A��YG2�<'*E�Zٰ�C+�M/S�5.4%�T�k܅5V�0E$��f�0��F�0̘u)���F�l�|5��D>�a�?���������'����9���ׯ>�9�^0�@�ǺW��>N���Tt ��`$TW����^�������B{��}/`�L�0ק��p����� ꮟۥ��0V�w
��(�]�K�W��]��#+s�9X�9_�������|k���繻�>���q7�R������'�9�s�z�X,�q�#��R:E)-��KS�F�m߮uJ��:32wN�1QN��
�ʝ�*��Z���y�]
?'o�����tV��/ ��<��h$��v����z'�O�O�B�O-��E��/n��eM�`���^�"���%�4C�_����v��=z��1�툺w�'>�{!a��x��YC��sw?����w��X8};���`e��,G��-���w6���@��{#���N��:�	�c�@�g�b�W���-�ļޘ� f�N�,93�ԥ�X��}���b��
�!��3iGP$)��w�� �^ލۼ�K.��tL���JL(��{؇��`��i�x�r偢�i"��.�GԌ�z_���gt� Grw�n@�����5�y�̉���Q�,ͳ�/�^�<ka_��8<�g���/�ٓ�%�w;^�gl��[�������膳/�!O�A��.�q8#/�Pxhv��FN�i�pV�JǨ�;kF�5$����IZ�u�v,,�P#���$#.qʢRPk����U��l���5K$�5�'�n��v��Dw)��f*��Ԩ�X�b̷1�m-&`hyD��R47�Y�%�ҍ%#buE�"0�@�J�i��u�c2���&��;U yU)]|��W��b�EV��K��~����5���'<����t�c�Fv�1q(�s(FGoJ�¡D�Z�U~�"����DLщ�>�����g�g����Ξ����>����G�z�g�0� �T�1�x��rh�-wn�(6ߦ�`}=�DN������1?2���Y��3F�YS�!ĚH_n�`����<��J�e�����ҧ� dqsb�P��B�r��Ա!w�`��@?����:rc�vj�d��gLjZ�.�fÖEU�F�0���@Z�Kz���FL��9��L�W�n`��Y��|��F�8����ȴ�9��ɿ2c;�������.k���v�9��V���i�1i��p�ڹ��]�^�,�K2�tR�Z郺Ӭ`���M{lm��F5l ����)o��d��Hߴ�K�Ͽ_�.W-�	����Q��P�"�(�޴s�CLg�$�rm�u0����C�=��)Ф���j���圍�:N�+��Ɯ�p���v�N��s /�- |9��z���di���¡�N@��s��2�}E��X�S��ξ-���Y`�Ĉ.dpƣ�Qa�|��q�G���(��_�Ӯ�)eg=��t0�@4.9���*�d �]wcd�uݛ��v��8pR��0�c��P���"��δt��B��vkd�غ��T��ޙk#|�����5S� �3*+2ԉ-��Z|�[e)���zyG��y����`\`}X�|&�Ձ�ņQ	�mg޾���Mb���wf�]��>�գ+[�x����7�1:/��4�d��Pa�=���y�|eGfwx�>/u m]�6J�l|�G��a���mF�h[G�n{��qO@Vx�������Nxx;B�R�ج�&
��|���	���y�Ѯ��Y����9�F�b0�ix�lX�I�>N�*�s����h���a�>x���V[6��b̸+6�v�q��N�O��ZR]7���ʨ1���#��f�q�7} -�k<�5a�л�L��Fv�P��#��3l2Y<u����.�P��X#��I������X݈��+Ƣ0jK�\�7ohF8B��d��
�a��n:w@���<����8ww��~bjH�ډ({ޅ:�\�r�� ��v���[�s9,&,�����*����l�k��ej��V�ٺ�~I+}�Q�\�\T�p��,C\B�����.T=	jo]�ԫ�k?�9�-�(����	�3��Gr6f.���vs�L��l�I��bpS"<:���U����Il~^j� �W"A�yJ��'��)��YX^@Ä�X��]�}�S��x{�?B�cW?��z8ʌH��&$|�^�q�l��Ot��	v���Di��N�4
��r�b�zW9d��İ��Ip߭�P��u��0�	l��eX�z�ގY����xs3�9݊��!���G���w�3�鳅�ٍfd,p��pl����\�H^s:���,T;'��)��]xx�].o�� pc;�xF�x+��sh�ߘZ��r��`�%g\/��Ԍ3?&�I8����zȼ�6�6Wu~�����.�`w�R��=�"��z]���ٴ�a5s`�N]ģ\��V��'�,Ψ�;tI�Ƒ�t�!0#kjt�����wl7���j~���"t����S�G���z���zfN� �[�K��a
ޑ���V��H�[	��&�k�|C�#r�ĬfM�e>�˒�9T���v��nE��q<;����z�ީ�>�~^t>=M ��X *��v��-���yA�h�6:��'(�������{��>��PОfne�C޻f;�\��d�O�b��%!����sM&��J�a�|3Ȟ;8��Q!['��[��G�G�:��S��:�RkR�TB�'�h>o�qP���z�ih�Q8q=���{PM��� Mkk��g���
q뢆���*]��	P��	~yl �[��T�(���������_����m+�1��A��� ��"�T�(?G�x�P絛R�����:+���W 7}e:�N��E��vS Mڷ�E���lM�B����Y�ݦ�Eʛ�\��vO2�ϑT��p������Ӻȫ�cp�	T�}�,������)�Oe
�^z@!3u���&���x���h�v�}�M=��+7��L��H���L���x��s8���1�ozE(?Q$�OpK~��ߊ7��Ů�Q'�����h�5�/ނ��w�fհ�P=*/���	R����a�6ɵ�<Ɋ�����4���,�A�"Bzx�_uv�����u���E�F��q�҈���K���&�4��'�!�^�͸�ʎCˮ�{+;�~m[��e'��/��8iY�����{7j�9�\��y��7�9�1´�D���:�,V��+�"�� ���"�v�}3b�D&rU�F�pl �o��2�إ�7f�Lo����܊�jr���&x����� <�'/��S>��;s��~|�g*��|	8?�C��wIM�;H&���w:9���E�K��\�!���G�I�7��?Β�(�	'_y�B(�T�D>'U���7�[���Ͽ��i�vu��۾�ze�Q���~�k
�;�0�f�;^Q�}ĺ�k����5B5?O%������Md��e4�5�_�?����U@)���Z_��pA_�@�{��ֳ���O�\�6u`�UM����ҀI��C��كt8�X_o�?� �F��;��2g8��
���$E�07�YAȘs��3��t�6;���KR�)gfla�9��!� �P}e��(V�"e���z3*��0���fqA_ũ���1��7��J!
���G:(T=KSyiJ'J/��RGͦ&�r�)�/KK��.�̀�2r��j'9�ߧ`����|�X#l���M+�-[��D� }emA81ę��,���Nfz���<[/�����_$<6d̉x,�u������{��lj	�"F�t�f�}��>�������������jv����ɟ>��#r������_�G@�:Fk���i<�gY���]"&�!�]<���#���qV"�O���{�ÈS���y��+�4�Cv���;���k	�N��H$Y"��p?�H����,b&Ӫ�M�t�7B�K�&Q�I�CA��i%zd�f�F�u0W&��B��n�-��OJ��E�������h������Ѓ�pbA1�qR�%�������u����-�$!���/���wT
�b=��@\�d}��l��u7{�Z\�S7�h>�m�����;y:�"�-_6	;�
���a��<dl#��D�9;���TA�-�l_��7�&Nw"� g;����#���imjD�!F�R�Mܸ����1J;ҕ���>�{�����8������$!G�(�2XEї~`��nZz��I�êA�n�'1�ix�p���h�;r����U�����i��	wG��D�����n��r�[n�Yn�h;�Ԧx:���IX/aK���[s.��o���lh����*Ӊn�t9���#���7��hۦCW�i���NwO���)d[{2�� L颳����y�4xk�_�4A�rA�ob���Ss���Jm��yS\�U���β��+?-@�񚪮���!��+}�@\�q�r�J���@���J��(%&�?M�(;�Ye;��M�'��3�{�!�"([GS����k�w|��<�*r�J���g�@��:�^��߻^p�XeZ�&���o��8��_Ϟx���0��O�k��sK���ɦ�%�Jݙ�y�wj\�����5��hB�����V�u����u�Kى��ើ·+��]X�0ɵ��,>�4ط����榜A���k&O�,�)���ԶH�*6�
\*رeqg_�R�i}A��z��m�O��f�A�d�f��M���#3�W�P���s'`���>B�� ��{��m��@`�QА��I~1I�;9QO*b�e��5N5Htܚs]S����\P���i�r�_;�ܞ˄��u��N���D2 �
L(Y��X�_�BW��� :����Q�빿f�Mɒ�iPmqU����;���sP��w{�%�Ɏ��j��1�"sM^d�k�ʖ92�T����!�9�B-��{b8f��ZA�b����8���ū�m��B�T���-e.
J~q39���(�MKӷ���-��I�n[�˶*�^7-�9��"�AF�rE��b�����*ؾ�w������f���~��y_�K6�e�ԫ�UKTY�]�^V�(��������%�x���ݹ_�h��+j�:	����b�W��)�i�N�/6���v�=k�'��KNK�QE�Z��I�%�[�fֻ<
u� ����8z��UUI�S~���Q��Y�������?v��1�'W�9�L��X�����Ǿ��{�R�[�f��<N���(���r����Ҁ���ё~�?}�Z_A�$��A������*\!;�3�.>��$�+�p���'�r��pt��J镏�<>��*�:���^�Ȼ0��j�-w���nۼ�ގvh�%��V���}K�0�l{�hB�qS�^Ǆ�Ɍ����s��0"�&�x؏:&?ѽ��E�]@����05�^Ũbvz��H풆vy��E�B�����U3�~J�ٲY�4&��}!�V�aS�9p���R�䎒T��[S|٦�.A$o��}�S�@�E�Q�j���3R2�R��uQ;�8(���;R�ov�f������%gܷ_���&p8p����!M	7�pӣ)$g�p�E�^��i�g�����}�����ǣ��%��C�;>ˇQ��֪�������۶�Z#)�8�e�6`�E��5<4͜B/>�M��pJA��&Q �+�6�S���{�<�e�dY�=r+��W�X}Nz�F�]RI�;�J1�7/)i�!q?��>y%-�=����Y�E�^���ޘ��}P��&
��^���T��(�7�����t#�Ps���L����\�b�s�܈����Tל� ALc.L^dX¥����Q��Ժ�C�]��z����qz��š۫z�S�@ׯx�~�i���\M.���(���=
`��,�΋w�!@[�w�9����p��*@�؃z����~������ل4��x�-�e��1�ϰ���F��������G;t�h�C( ?�/�6��2ʯ�2�[mG���1�n�ti�èˋeר�� $k3]h��m��xSPk=ְ,ֺ#\���kT�^EA0}�k�q��n�т^���=ｸ�0zHuv9�&��@0p�&�L`Ԗ��k��η���T��_��"�`�����QcfTE�	!6V��b���3$�R�+XҨ��qe�[�LM����cQq00m:b�<�xZZAFZ�B�n�͛#}i�^�������KVK�zw���t�?�k�V�euq��l�'�i�/a���nɌ5g:��!Qj@�9L'�==�C�Q�I���U8�I0�D�p��LT�3�&�E���@����`�NW�>(�b��_�u=��-��	�L��}Vf���	r׺�y�g����Ƽ,��VLc)3�L��Q��Td7�wH�ouâf�?�fȷ����!�^$$��;��F����i�A.��a�)�n��M��]��a�.������օ�X]�p-]u~�u���\W�^W4��F�w�}�Ħ�}H������^��+��N�����ngg�� 9�����aCk�37e
�-�1Q��Z�@��}����F�~�C_H��k�B���9:ǡ�S����6�q�bu�>��#�K5�q����aI�g��D�,�2�v��k��1b/E^��vF�Jc�2�A��6ktl�&���ȍ���4���d���!�_i�/͜Z�ɖ��K߻O�w����9��;��f�x͵�P�تa�:͇Q隖9�(uD`=H�&ʩ������nn;Tn�w#��Β�����6��c6��j7s�u1 �t2ZaB�j�/le+c�J����qؔ�a�B?�/�s�5����y��v�/޶�Ix�-K��Wݥ��.�Ks��Y��Pﺾ�^�8T�ĭ;��+��	��
)B���Os9DD��(�>L��}ա�1mK���1��"X��ÄܺG[iq�بE��I"�u�!{���t�2�D�1W�QR�\ȭQ�r�_9�5��Ԅ�!���ڝ�nO]�j0�r8L����_��PnJ�8JN�8x�bE�%�.�\�]�~"k4a�}�t�������iCSpF���3n�`i�ԛ(�͜d�_��NŨ��4�p.^�����e�D/'�
��� _"o�˨Nj��K{l��ST4K�S����%d�"�\^f�W�2�/�W��]���$M3����:��g8rnBB�)݅�w�B�� �����E��[\���pA�(]9NKvDx4�(=<Y^��2��r�߶>�-SV�Ĵ%̔���]�lYNQ��F	���tO��}�݄�O^bW��=�.���k���,���6}EX*6ߥ�B/�������a����q��k��K����mW1g�Aωc	%{��I2�<:jї�Iݽ���N��ސC�p�t�߹d�0��[�)�}�.���w��XQ�/���0H�S��ƿԘ/�M�^r���[yzKۆ���ZxCT�< �2����������G_ �����}����:�zR3ʚ /���~q�j���>[�N;�1 n�Q�<S��Dv�]aX�w�KEV>�*T��lW����̶�m;��,�W����p�9��&Υϕ.�
�P�^�Z���Ml�f��WΜ�\u�U��˦^R�F!�Q���>��� �\"�>�]�4�t�<x��-޶s�Zeװ�Ҳ'�^�]T��F�`'i�L���Y��3F[B�GgPa����-��p�]�r������]�i�d�d?8}Z��o�[�������8��>����+6��%�N%K�X�UkڶW�� j� �h_H�~e`�d���B���p[N���:/��*m4�Ț�Z��%m�u����������]���=`ad�0!�����i9����a^(�L�BC�Ja���Å[Qj�*��Ă�ȻS:�~�Y�K{��TΩLX��l�K"�$��И$�o$��N����,$���H�gL�}�,8�@ݣ�)f9pO�
����T���\�S�R���|b�p8Q�o��6����a��f}r`�?+����%���핌���U���ޫn7+$uN�=���s��EAx��j���7��ǈ(�o�B�{y��jIHCU-�HK�͊3d[	�{��)�u������ܧ.���b�����C<AZͨEF�*��B���ؓ�Ւ�����ތD>��� �/�Kit�6���_����4W���_�n׶�x�v8�2�=������ƀ�~��w]Z�",�>b	Ǭ}�^6� f��0�I�2�7��q@yw"�Ձ�2!W�\�����$��� ������8^��˥�H��v$-?=P_��m��=o[��N�a���1���~��b�w� ����>��p6oX����U9�]E4��ROb���K�JH����*c��S-J�rU�A>V�Tߏ�5̫�csQ�AևZ�4�(lsn��p�A��E77�:)ʆ����J�)Fh:�<.����-���%"���C����|9���.����[�6��t��j[���s[�f�״��Hk��|��T�Q?E��cF�G��c�06#�b�d�ϖu7�-H`H���l�$��W�u�k�ґ�62;��%s�h���y۝Qg���A��(Sr݋
G�H"���p����^*��c�<�Y�twt!|�P�}��)m��qL�(����>DF�3�(���������B�����t��_�y���GO�x��ӽW���d�uߖ}�6/7�W����2�����I�p��ʏ7ڵf,��ҬɹAOp�8k��ma�6Y�a:.6���)^56���t��~��O�".	���6��3�й�JmI^ʓg`��
��{H6�Q���b*lL_�w�Bv��?�u��cm�@�qˮ�E.��u{��s���&���2Q���'Հ�,����0p�k�z��D�\���2Qu���۶��6C�88�Ъ �{��@������>e�m���;�FrU,��f���� �!v�_:{�Z;� uM���6ǻ��O�\�.�%%KJlK�%�^R�-��!*Oj��A�D�9�D�Å���ln�H����owR���1�����h�3(����� ��3U�+~���Ws��p�t�s���&	��b:Tz�m��7u�R�9��Q�]��ȧ�ײ�[�m[�>�p���~�8�ߺ���y������7,,��-K�\Cd��o=��I��]:��4���$�Ӿ���ݥ^{�؋ecJ����������vڿH˳�� u�U�'5���Mo�gZ9#V�
1*���:m𰟜D���ڃ�i�������sM�1�Dm��1���Pn���jҰx���&
��#J7��k�!���W9I?Ej���ڈ�Z�uk��L��d%e!I��=G�6��������-Қ���6ԯb�)ņK��4TA��+~WF2S4=������vĔ��E,l0���ϖD�؃�G o�*��gf�0G{�?@���M���To�C%Gs}Wt��R:=�����ŋ��ggV�����}���%$WW-�i�vy9oE
`-�-kԨ��/��"�����|��MD�ۧ��ڊ�R��${o��Q���Ӝ��6�PQ�7{��/҇<|���\O�!{��g���Ӗh�-"�^�!��r|@�����@��'���xU� O���Y�{�x�Q���(#�q*�IT�]<����4��&�k�+ڿo�g]_��p�v����)Q��a�$9J&�SG�>��3�Xq/��L��eB�_�# �u�T�;���� ���F��z�?J=cS�V��م���s,R=Ҧ,n������Y@�����Uy�Y�n-�+0���R*��K_�i:�6F���z���G�1���	�!��5��8پ�4W�&8i�ii�F�����+Yk�)���g���6J��E�7U�q�
Y���i�V�)�t7a��]�e����(?Z�S�5����uՓ�~�+*�R\j��B}r1�G�䤧��1�,����b�1q��ݶ��������"���Y̔�ҥ\M�Qe��:U����#�M׈�K�m[�
�-��Q2Xv�^;17��/��U%���)^J�ۼ2����un��%nК�Vϱ�*�Sg�?Ѭ�ߘ����f��Fiࠖ����W�"��t`>+p�,�	�~v9��bnhHi��Y�Jk�9�Ό2RNi�	�<@��RgN��f�R��%2e�ӥ����4pI{Ma>�ߘ%@������<��CJD�:�s�)fZ7n(��7+�qaI�Jc��R$�.R�V>ÆD3�7���`�ƪٸ��WvQ�@茖y�chV�Y�{�M�@���-ۆ�̧�V��	_݃��G�v�ͤh��.���W�"ݕpCt��FM��qzE��������g�������y�},���m�๗�����m�<M&��ZjA>뫒g�'|��sM	�p�E�-	:Gڿ�����Į�ݓnD���^�4G�4�+�%�{~NKd2���B����hE����1��Y�� `�%��5���E��hAo�(:Nj�@��T��I^�uV�Y���g[��/��`�%�	{n��H}ab%}}������
�`8��V3�6�O���96�-�
�1}�%������c�����s�� r ��K_��?��#/9�g�� �������^_~S\-��/-lű���37F�xkF��v���U����a.޶��:P���ΜV���	��ھ &��ց];J�#�/]�F\1y|9b��#q�ޏr��O��M��5�[�3������Jd�O�"��n�В�����z��=q���F�����c��:���K81�		}vV��w�޻�P���ѽY:ISg��gO!D���.�w`����cm���k�U(�~�y�	����1�/���n5���<d��A`Ȝ�:��س��UU�$�p]{D㖆�cc̕��}��Y�x��>�B�<E�g�.N�̈́�m6� �޷�P(�g���J���d|������J^_��S��� ���.��⭇�Wة��I���C�}�v��J?��!IY#��-�x�s���0�y��O�,�P�S�E!�q�I�Y^�������O� �G�h0�w��,�Ή�5Rt�А^=F�4����"�Z��i��:rRh�5��"K`;�Y~]���#K�<d�?��_�Gd��o1��\��`��q�D���kk"v\#+���k��R��F�D$9���kAc�0�6F,1Z
R�.�'���{qo���ԥy|�xOLT"$�=$�c����E�.�:�u�ڶ�H��(_�v����� `�n
�����4w�T�~@߿Xlu�׊�k��Y����_+1o9q�-�/�z�[��sG!��A�9d�1�HA����zc*��
k1:.�#���(����t�8�{��2Mw�#����O&(�FTg�uq��X�tM��oؠ\�/�ӷ1Ɩt�z_�4I��D�]�:�B�n��I"k��>�!wAc��0��#O7Zv�X-��гf����o�g��R�,��9AB�N.zٞK���˞��I�x��hMw�G�m'�����H��-���`L}�	�X-���rY���w,�>�D��1�ܓ*<8}3~� �U�!�|��Y}�CÖc�U��E�w�����V���'j��KA��]�WkvG�z��ν���v�{X-�Ň��x�_U7�i�qK�����+>�V)¼@��.�?�k���#���|�fvԧ�	�Vm���F��v���+�t%�h_/L��5�����ìi�~%JC8�����0�&�V��Q"��D~���M���{LL'�bd8.���)�y7��:�4��D���4����ac�v�f��k[m� ���ee��Eu�z3���3(�=	�1���a������Ī��A�@�!�e�>%�����1��g.��jk΀ћ�L������aMv�7����S}'�ط�RJ_��m������?�(�v�%ڒ-s����H�t8�y�ca���K"�U�=*��	�Q6F*a�t F�]�Ti�Ay��p�h��U�P��rz�oj��Y�}���)��'�m�VB7��i�=�,�����"�x��p)n\��j(t���s3|��#�G����������2��J͔�F�<�O:����;�1�C�A7�^�	��q�ZT�g�Jǣ��S��2Ef��UP!� l�I"6�M��4� κ�x"6$�[#9i.�û�9�u3�uvW��!���жm��3����w�>���P�*ghB��$��.dJ���ז�/��}\���2���d]~�H�h��
Da$i��������Ho���)H6���:f���^��H��jy�,�+��c��vG�{���0u���ϩ�8qaJ~n��N�~+�i"�(U��'���^��,�.���$���)fᰲ�Nl
V���6=
���kG+�VO���ߊ�' ��MJ��U�+��)�pA�A/�͙	T��Dj��sF���a�^���S�ݫA�9�h��h�����4p�~�G�~Nk��Z�7DJ�bx(�����݇��(M^eL�@��4~�����2�2�@2;2en�)�U<����j���LU��u�Mq�goJ�T��ҊUG'i-���"+̦�Xk* �un_�I枩��?�>���:Ɏ5��g3bS��E?��J:�x���l�X7�������EY�N{�_*����TZ19D:ȓ���~2��r�xĊ�=JV�0/���1M�(<�:NH|�r"3��?�'��D
�1������T\&���\|��x���3�{�|�s�Ƙ��D�zC����-6 2cK�]�w�t�Ԫ�;�N�sBw��&�9����$ɠj���J�@�������0�!�Y�B��D�_}'��sռ��f}����)��-�/8���� 	нyu� -��=�~�
3�c��V���zW��U��*ψ|l5>��E���=��?����FE��{�\z�S�T�����t�MY�Zzt̮h�'2�r�{��?Y"PgZ�s�(�a����ɖ��yk���S3�o]�T`�4t^�`�x�i��_�I������IV5a�o�{g|�!�g�\O�F���_��1��E�Yb�����H�Ю�0FS�`*qy����0\�'�v�c�۝�t��/FngHu�X��	��,Vv��i�g���cH�{�Vy�9�f@S��	.�@�oT=��#�i"t�D�������f��R��P��su�>
+]��
����z�������%��~܄�ln��*���7��/\8���{�U�Ў��E�����cT��Zʻ�VP.�Q>����'O���W��'jBۯ�?I#�oS׽k�,��i���~㤞�099>~RN�
�#]ۦ���$�V֡�N�g����䀕�y�?D������Λ�L����u��a�R��`d(��9�a��(g�Y�P��9�:!Z���-e1?����?��0�N��Q��Q:���ǚ��]-H��!�A��(�[	/���	cZ��N�*~�H�%�̎�#[��P��H����n������*���gQ���ө��|��cATfKÚ��1^Ev}2؇��j4�čxp�ۖ�|ȿ�kp���X���2u���k��i\�d����K}����m3�ލ}��NKz����_�N���.��*9�"��V#j����LUJ�X����<��[��1)=:�א���*[�ʨ8�w� �1������J~]9�)E���P��OI�\p�e��q�+7�G��O�Mse�F�q��r٘�>+�%�͵7~f*m{vC˙_D6|� ���2%��@'+w�q�(��&XsP|�z�^����rCa�嵬�\�[X�����	H�e|�C�V!r�@��wU�a}'o�\�iH���h,�h�G>)��>OSY��~|S7�a�ݦ�+����4QAׂ����1����ҹ(]��>M��cx�����pn���7�K��a�O�2� Bb��qiy7k�`��k�2�;B�k#/���P"azͣ��b([6��a#���������)0��;^�]�I�{�gg��i53���C�Ͻ�`"��M1�@��N�`6Ÿ��=�I;�����5��~��:�02�p�d�1f�$�� ���'�R/K}^��*Z��-�n�^���� ����ʪ�q�����\_��x$���*S��]�]�V���1�1�d�!(�ʹ!��A�*������#�M�3C_�:���?C���ϋ�2���\�U9�s��$�?�:�O7�qrf4��	��`l�y��9�S�D=GΞ
w�'�EMX�����7�8˵����_~��;1��tLe��E�SH�Т��,��$��������9��?b�ޡL�.q��3�hY�on�%2
���*�6�p��m@U� ��N��Bimk_��P�8�9�ي.��k�!�K�� ��r}a����<~��Ѷ�\���\�������h!ۉ@�de���f�ߊ7�Ϩ�$����ϯ�2��̃�J)zO��~�	zo%wl���*���P�)'qʯqʇg[)�����*\#�7���I�JZ�/�"���o��4 sbH9c� �����m 0����ꮙ��}�5ER�DR�����M���wX+�q-��Z�$�y:M��M�&���p� 1*���As���K�_�BfN����!�#꺟�А�	�Pg�T��V�g����$���WҔ`,�c]�K�9"�4s�ɽgȞ����������y~]�X�
����1��cϮ&�HuxΘOF.���t����3�zD�Z���fB�z S"�W�B3gJZK#$��]%B�]�h�i"�g�k��%�����{c2喬�4�,d��kۨ%#4[��v[圫q��C���vU�4s�f<�)�09��>]��Cvb��
w����s.�l����pO�o�W�A�pA{�v9{�{��s�zL��3�˼��쒮W������Xξ\�4�xa�Jǖ�������`u	?g/�\����-<8K]V�g��d���N�,Y���e~T�@e�3-C�����;��3���4!�֊vz��$��vC����Z,3fCY+��yo	�skǽ.y��$��h	�[���DF7���h����j:�T�x�q�{�)���$K+�����:;��w�Ю�G����B$N�.&vΛ���	���
���-�Y����_��!:	$�vT]�)m-���5Nݤ~9/�[�`y�­��mYV���wu�o�׈�E���"	:�)�pV,W.���qq���ǎ�j|_������!���.�B�aKH��_��>�ߝ��f%���쨁�������F^ Ya
�@l�W�)�6V�Y��8׻�xr�rf,��@90;]�g�{��2�V�PY7�w�Ր��o�q1:��Z���C�`?��� W;*m�BzA��pg�d-������ⷞ5��?�E�X~�9~�oUȖ�`��`Q^�{�G�Ӑ�,���Qnٽ��G�l���H���'=BW5�u��C0ro�q�5��Ҿʫú� '�x�šܡ��
z�w[]Cqgb�g��/��	����(D�za��&��v�i�xƦ�(x;�ՖJN=7}�v����� ��x]w>3�v�,�)V�	m�p懒n�J�0b��t�r�-)R��f�s宺�]1f�٧��/]��o��Ql������t�����U�-֖>=��&��"K-$8�$\;	�^���`[J���sv����xZ�)>���`�`��tBB����3L�Ep[��m�ۊ$���sV�Lk��49������~�J��Q������pZ;�oU]uGx���L7���Yw����v]b����Cn�{�~�y�6w�0��k)�j��i4�V;�"��?�%F�R��	�)Yu�fh����|D'�[�S[�L����׸�w�٨�N�b�ѱ��&벐��ܶc|�j��R|�Ì��%�� �ՄoVԾ�`w�2Yj��ȿ_s��~�!�uSi��_]�4������nC�@B��������G��e�%�s����.�G/��me����;��%F�qU�V��l��.+"k��KO�C������/�mE\�TP��;p�� i��t2�dN��C��k���Ti����͞�A�Q���C)Dp˗_B�SO:� �(�Z���1M��m�!<���93�/P���8/]pl/�2��T�{!�*��d���C���׻��r5b�c�H��Η�K+�&8cГx�J�0� �~�u��T��X��%nX����'�9�9E�#�[�-C6����ϊ�Gų�ܱ=��=vV��*�S�P�*ؾ�.{-j��6uz]�w�,��]V77�+|Uh��w�GB���9�RG�\��H� r��o!T��I�
����+Av��wD�ܷY�+X	�y+���\U�<�N���r��{��]� ?�3���5ٟ�3���LF�еA>��tפ��m���?\~@��N�mS������������}�yq��Dɏ��O�x����	]���%�r�	6��T����1%�΋������k��
����d�$��	�UD̝�1�P��+X5L�ZB�Aj�9��G����dc�HJ���Ydt�<�ɬ7��ޡbuӌ��yk3��f��,�44B�zY���Q!,'��)ٴ��[�q�D �����<�{�B�l�kL�m���h�5�U(�sC��c�S�߇5��K�x;E���3���!|&�Q	�0Ie�-tA�fr�94[/e�EgP�YN�Bͫĺ[Z����4V�s����?^�ؚ�wD��D�8��,�C"#Mq��"��T^T6�l.=�nj}V�ބ�|��*N�hPg&�]*=�;|�8���L�;aA[`�Bk���u�y,�Vf���ib+Z!*¿�2�Ė\z�n�&��!l|{��hI���㢂��_�ᚨ�i�&�DG��p�Q��5bl�γ��WK�`Yao匜���ԯJ1p��f�����߰�n���`k�4,@�A$_rݻ@�*Ly���X���1�w����;�<ҮqA���Ǒ=�����C��=3fH�;	���҄�< �Y
�LJ�Lucdh�C*%�C�I�zp~Wf�Pˎ�C�Q�s\gL0Y��&�#�A����,-��ud� � sU:s�p �ށ_:�:w�%� ����I����+���o����9��=�����8V�B{��k@�1���!��І2�쩵4�]e�g���6�B�X�f�|�wLs��7�uI'�}��S�y�1�9�O��dR�3�2ɒ���˿.	!���]9<����7�kb��ݱ�My�ݮ�;�@���W���p��S˦j���'dW�Ҁ^����u9�7���@���� #
D-O�l����3$kQf��]���s�Ju6Z���,��Y�o�����I�&�M��[��DW��b��v|!�q۽�ĐU�������f܋CX`8���%^��rpWb���~U.k�Q�͂�jM:7㬫i���^�J9�liYne�t�뭃b��4\���cS#�g�-	���������V���*�6����S�'X^���)SP(��N��O��^j�ZPGGmvx��1n?][�ѡ��%�?�~}��Nrk�/aJ<->��E�x�X��u�Z��V8��G}l�-2 ��:�t|�,�B� 2����)�&e�3�	��RR�`����8�n�G� � ��ۉ3�0�R76�-�B��O�:��� ���w�KQ��=߾�}��I$��ZcD���Xe��}������HvP�i��>8�bG:�k(�����B���@��n�Ը���	`�l��-��[vۼ��?b�A�~�����܎�,�gn,�]�^�]�)�W7��8 �Y���Σ�-�����j���$��7�˘�f���b���"��"�{J�B�zeCw7��xM6H���;��������?n�^���Q��*�T�<���3	��,9?�����7�2Z)u���j��gd]��q:em��w19R�~,b�ZJ��"�	����r�����9S[�HR26�H�P�@�Y��U`��H�b(+�B6��>�z�N�����tί����3������t�{k���&ƪ�ʍ�^�J�F���W�����ý���\�ח$�����4��U��A	)��>m�ƕE�PLw)j��["�_�8��َgq}�q¿�v����W~ک�l�=�-%!K�;ӆ*�8[���Ow	uaLO�h���N�@	=/�\�Gh=�����L� �+���7�����t"��(|�ʃ\�� �pt�[o޲QiI�k����.��.��E�;`t����K'�}<����VK�<u�}��_B��'սպ��H��P�=!���]q$�	ޫ˕�u9��J��Z~1U{�۹� 78C�����\�{��6�z��x\_�~Y_o�c�.�T��h�Pz$<��������}%��{�,����|����c��C�S�'oy�3~�u%�ݟ{A��������Z�)�~|��m{�ڄ�H&/^��>k_�8E���]mn�yw��.f|q���V=I��^��p/��
�2,t��i���V�<>%�U��|~v:98�9�����~���o;F6�z<D,�[�J>w�q)d�il����fK5�^���_����wxV��9V��5D
���A����`���U*�GbbðK��K����QN�	Z�Q*Dom�����_�4��RE< ��P~��7��&Ok6eE�섘� ����j���ח�D)�KJ}\�T�/V�2�fI��f=�=�VD.�ysU���<�oldJ�#x��ND��[~��%������E�z��je4u%ڨ_����!9/�_a�����o����Ξ��~�$W��ދ�3��Z���MNO/�_����%1
�? y�M1o���o�h���|m�(i� ��U�7[�/���~��ǟ)��q/�^�o��Wt6ɰ)���A9�?�=�?h�H8�VQB��m�h���J(o~�(M��(qʤ$>������~^�o��ۏ="!_�3�)�̻rBå�KQ����*���}��R]rD�d�JX�2%r��Q�-U�EI
 U9t���i�׬b}���}1b6C�[��22.�.$}�O�����+�u�'�-rn�԰K4��mgmې�P>��ӥ9W�#"���s�?Wz�?P-Rz�ٴqf���$t >ˋ!��}=6�΋��λ���������B0p�N�X����_:�Qi*��Ę+5��8����eL�>Vo`�-tN�t��i��.eh"�]��.x����X�����:E񊺡S�zW<@�DY��v.m�{�����['|X�٘�i�i��-�D[�T�f�,Ѹ��*�\!�m�ot���Ϝ�!��,DBj3W[VD��D��t���f������,X/���K�p,��xh���q���0q����O�v�s�&�=�_�;_,�U}#��ӑxZD���.�4��# ���i�C��zT+ke��	s��0���(�����'c=5�=������ׄib�pAC%����)P�?�Ƒ#[s���>"�|��?�����5�
!�-��C�4����<.�v�ʛ^���E������U�|�ޓ)�aK��P�ѕ�5F��t]87wU��݂�ψC�jeȎ5=Mn�Y�̅`���b������6���R3�7�{2�˛�����j	��K��/�d�TMT�a|2���=1~bP��^
�{������ T��zJ����鋃?'��.]�Z�Jq3(ha�˫D\�I��&t�[E�=�I���U7bl���Ua=Tnm�Q;`�(��Ey�U��G_��ԭ�n)��H`�	�"D�i�� �~c��I&� �{�g�|J�EH��Gϳ��nu�P�|�\!3�~E��`w�9�Y|muo*1����B	���p��Jő?m�+������Ȟ^�WC�9Ny�2ߍc�5V�BE��ST�����v�mWz>	tl���𜤫7o`�Re�ݧ���U���)�O`�JUW���Y�����6����������-�ܙc��$UAE P�����o�S	���=9�.����s'�څz� О��E4�J]��Ct��M��\���m�y��ݕ[��ܟu�5�v���3O���:7�Rb�0�k��Z� /fn!q�?��1��:���Ͳn��(Fg�" +����3>��� ?�S�B�6�4��.�ϙ��Nõ8��s0/��(כQ^q;��5ty9#$�ޤ���s��\{�{_�D��Z�
̽h��˛�>���W���;�� �D(�$�`�e���oJ��$9:bIg�,T����b]�m���b$�^L�=�C?��7I���D6�fM�����|���É���t'��O��A�`�k6}(_�xb��Xq���Γ?'d���?&JQ�^6���S��Ξ�����3��#b�t.� a�!D�M�w��z�+}���t�R�K���ʝ��lI���L�G&O�J�D��L�T���@Țr���Y@���˳�Ʌ]��g�'&����F�G4fy�&����5�OgcU�d�~U�*����'��d�94ײ�d���� ���!A��cE� ��*�3f.���%Չ�T��m@��	_�"	��U~��q�W�B��"�[��k�<�t��c>fTY�W+`���n�Y�3ebq�nt�h�[('�t�9><f#�*`X�~�1{�V�H{�	g�~��g���
�
c�R��22����&���&�`��`���D�s��*�'[uO��+׈sC;�{�S�6�?��9��\�� �=�Ɲ��Jhy��[�͂S�tavcs=Ilv؞�e�x��3'0Ղ���~�^&�w�kN�cf���Mzp���ˍ��2�8[�~R�eG:gr7�V�ү�SM!=rG-�3j����J;3K�t&��[I������!E:�T|��l�?�'�)e�v��Y�!wk~��+��P�"O{�����@������үǎ�Z�屣}1|Hv�Xi(udG�r���5��=�l$���5$KߘW�O4��B|j�R��$��-Hl�捆^4�n�����W�1.(����En
�A� ����X�ԧ�L���ʮ#+�����3 T��+��]���w�R���s�Q�?�|��K��Ur� )�m�O�6�����]xm��[����m0�d�R�-pI$N'��R\�9?;�e��:��ʮ�	eJtBfP�"y.VW�K�i{��v�vd}e�f��?�
yחڝ�Y�����5|��7� ��m�o����Y�j=p��*GBչ��|�GԂKO@�S�U=���������RVW��	:XE;��clTW�U6/�3O]�X���R��%��L#}�9�]1A�����Aޭ7`�\�c ��z��kiT�`�X:P��|���L�	�P8�,��
���2�P���#�^����B5\
eW�QeR��U��.�W&:U�>ym���16$\���p��\B��Xb������������$��p���w���qR(/P��b_u`��Cn[�:��^m/�):{[/�`���"0v��G=����K�!��O����]�=3���ǭ���쏵�B���4G�����\����3�47��+�.+�D����F^^sfZ6�̿d��z�3�I̛+u����zL��|{�:"��)ܶ�9)V��)�� �Ir�L�>.H�6y�%xi�%�����	�+��G)
��_��̔���0���k�h�fT��-�^R�,(U^Z����<u��gF����+`�+�k?IL2I)�b<�Kp�.�F���y��0!�5��3�"^�n�:n`�La�����C��J��K�r0�u�^^�ɣ���A��Iҿs��Z����h'E��3J��F�8A�/A�g�'gce��H�G�Nn�������>��=��D�͂v/	ET��v�6��Iuʙ���$����3֨�hZ;e�Hy�� �F�Ї��� �%��Ѣ�	d(��F�V�Y�E@������ѻ�@J�cz-)_V����q���g����jl��xڷ8�0�Z�f��d�
�����٢�÷� �P�����O�]@䏶��B9�|�~/�oI���^���J�*"@��u(��lnȺ�'��V�t�����ۄ�Т����N	����W,e�4�Vj��h���M���?�gznJ�^�ɤ�pj���qZ
��d
^)�|ў�a����{�VW��W���3�B�O�(�>��'����a�D?��"J��]�&�XB��4%�Ɏƛ�X]_�V@��ͮ�܄���C�L#���B,);�9��;fJW�Uv��~�hW�2�-^�󈪡T0q=����DK���yI�d۠�w�����R�"93���	��Gvl|�t�\��pg�E��d;�îtۻm;��|����6"��lf���h8d�-1:����<�U�%��f�¼k�He�ǃk�GD��� ���m�^T�r{�)�K+V��������򧟾OT�ö��pyAgI�g��"�������}���D��M(��Ȩ$,�.������R����փm/k��N=� ��Q�B���l�H���'����Ca�EN��=pG���ہ��L|�+.A Q,ET��'ǏfaZ-�D"��h#���F����襡邙��k��L9�!��i�M���=B٦n����3�ᓷW��q���wF�J)@���0��eZpT]�	�BD��ք���v7�Vx1\��*5�E���Q��j_�$~=�l<����WY�~�9�q��n��+�KG��_JP1�	�5�xt��=�(Z�#~9�C���Z^X���t�'�7�ǿ�]�#L=�Ųe#��w�� Cu*E$�x���JO�L�r�҆b:��{�uUދHU֋ы��q�?����'��w���˝��uh��+P�2��-k�n�����h(*�7{D���J���9�Vw�����x��Oyn�"�V�#����T�
t�S꽀�75:���7�畈�6J��Agf�0a��l�7� �Y梜 =����Y�lD���H�������\
�o^�x �I����0?-{�nY�3��?/Rڒ��pgi�����8�����7)�1��~Vb͔��>4��1����u{�Þi,�d���X�-�;R	��/
+O�ЅS݃�A}���'�tŬ2�Qa��$���'�i��v N�G Rl^nњ��K��#wZ��N���g�'oG��J�@��p�>���}��$�ΰz{Ztpb����$�d�<?'�S��l�=NU���p�t���S����拁u�z�Kg�6�������D�p^[� vV�3��z���i��� ٿw��y0N�l�����D��ղ�	!ꆋu�Ӭȕ��f��f1觾�\|dYYL�����&!rr�<��xe[l43�2D�Gk�u�%1JIy�+�E����:�m11��OgzyM=}���oG�3�>���^**PY:ﺫ�۔&�Z"j�e�Y:�UlL;��//Qd�+_���C4y8`�)~p&�"��QC�����{��}z��=j�?��m�,���l���ϡ_>άv	�h��|�BZ\�{�z�Nۻ\6�?����(���i0?��f��/�;�R��eE�knq�3�F�ͯ�C<��Cu D��օ�Q�+�K�$\ FE�[6�[�1��g����j�F�^Ea[��������5
YZ0(;��[>�.�X|�v�0�r���k�N]Ɣ�ѶBr��d3����+��|���N�l������B���v2���� ��7�������F+����Q�!��ȱ�l�.<w9��ŶkA�/�,�V[��*E�_��v��ѯ����[\?���i�?A�|��L��a?����Ῥ��M)��hi�3:���U��*o����rcp�Ѹ�Ǉl�b�ub����>��3qz~M�j���)=��\{^0�]᭿�Ѝ.)�ƫ��G�*���Ҽ��~�ٸ+�/�=9��N&�#*e���`��q��g��缎�<�k�� ��E*��?-��Ιhf�3��������w��DNS��cBe�������އZy��DV����2Ȏ���P�r���Ѳ�ѱ�r�t���Ż'�m~=󫳯 �H}Ԭ��\I,:1(�+0������s�!���c�Th���'��O��8z�" �m�.�!�y3~;�X2ɇ�'͌|��'xL'�dx9	��������p���E�0]-Ns������k�?�F��W1��ݭ��)+|�@�+���`��yE�W[��q(v�h5���'�{���r��i�{ur����^��Vʥ}�^2���o�vT�Ң�����f~�W)�����˘UWzx)~C�	5yip��E��H��B��o�3V0I��:��bs��]֘��{��dI�%��&_���W���>�|�4�>W �v�R���l�F�F��e(�[�7l�9��Fs1xҟ-�wp�!{�\ц�_�f�`ו�����/-�bN<���nşl���Q�Zn� �C�M�K%�=ãm0�Ժ顑�A"��{���Ÿ��[��V�n��3U���=*>���D��,z�i`&�~��Si������~�\O|������C�t���B��z��9�.%v�-��(��[�~�p��\��!�5
07E�����x��ivk�	�@���J/����7X�l�(��m;\J�v�~0n�aTP���PNp��V���Q�KɃw7[�ib�8f��NV����ꦭ���z��"�ծ���^�by��E�ͱ&�pxIc�%�lr_���=e�[F6�s��3h�Y7d���et�s�� KgԠ�n@�!��w',�:`�ӏ���k�g~�}d�=���Ԡ��gm�ԫs���K���"-�Ȭ9g10���ra�X���/B?-��:�Ate�=��{ �R��M��u��|��޿���?S���euzN$�K���1w��Vc��F��s��#�c��ɡ�� l�Y�}��^���랅�sҎ#��ᢱ�hn�؅�X�'�1Cb���u6p�R�^`�4�0TÅ�8��O��j�O��;�����G-�� WKB@�u�7㣶z��w�V5�G5�%��"�i����Y����F;����^��~�%�٣&޸�.���ˋ�z0$��Ǻr�?��G�qn���eJ �-�����/!e���Vo&�^�P (���͓�G���)�O^ܟM(�������'g�Q��"�����D�8;ү��%���M���)E�Oɔϋ��&��<��������T�g����!��^O<����[��5m�����t�#h�-M�)H/j��=��f����v�=�ɝ���c6�PTx%�U�G��/�����V�-��̯�>��?`��rZKp������jݩ��{��n
adv�+g�In����Ky�\%J��z�z�Ѩ��pT�2��	��vr_dJ0�t4��,]����G�%����Ӆ�6!I/\M�ۚ�y���QCv��Ԩ�8q����vHq�w٘�Qf.���ȓQ���i���˨��1K~=�K���T� U�J�z�Cp��T����IM���5hZ��:
k	��P�F�콼[��Ę댿����s�A��P���M�HJ��}�2��q�o�l�0�����=td�7�56�L���3��?j��c̸"��ućs�Cس��m�`��n�D�7���
V5��X,,�Z:J+R�"�,������:r�t�	J��by���F���wS��ܗ7�F�$E���k�Tj��r����{�W����0<����*Y�ɠ�Ϛ��i�!"��-��fk�tm�ȥWū张u�B�ϱ[�5^mkW�f���1�����a�.�(R��+e )g�� rxS̊�R����V���;	I���G^�0	����w�uQɧϟ���i)�I�U�#�u���2�#���Q�([��Qq�����;K9e[D�Jm�¢�fæ\E��L68Ǧ���@�4�j��%�#�}u�Tk�]h������U%w�,+�H�#7⦂H���4ȟhV:��R'ev��<}S���
��H����M|�_4m�q���pl�©t}����^*b�$�R:��ăk
��A��ۭ�7L�3�� �����=)�H�^/@�"Ż0�( �ww�橩A��L��u+��+�@A��3nN:��θN�(7 ���)�����nTtEy�t!�3����D{��9����}������� ߶�`�t�K1�[�l�)��Y��جt��[nʿ����a����4��p;��=����Ͼt3�j�P�ِ�} �V�������+�4e꣫���a�+7.H�����
�]�@�#��/6� y��"iZ�'.���Gŏ�O������XQ3/v����ʺ^|�D�0�.�$��_ТT�9�GF�"����t�}E�1��ŨaZ� L!�ME��d��^*}a�W��u���>>s&\�!91�^x����]>��y��!�O�����Q���/�®���Ւ����e��DP��W&���NȬu�cm,k�zI��#g�5�����:M^�X2�j�(
'J�����?�7�m]�d���U�}׵��Â*�u�O�yT�P^f�_�C����9���5��\��4_7�G͈?N���$�I���I��D!���DNz܃*�)�qFuR�����q1�XKr����#��.8j��ml���z�q:Y���d��cF-��y��h�+W�~@�=��3#��/{rZ����U�����55lO��֪�'�]��i�h٪�����a��>�
ku����q������lp��SY�--�	Gg�v�����[(~�a�&� NR5��^[a�cj��H�_�ۥ���n�_���hȃ�uW\�m�1�����d��PM��&�=8<<�̚H�w*��.��w2������G�Ң�Į���d"0X�_��H~Wv]ON �E���L�SS�a?y������`f6�?�.uU�^F\J,��RO�����"��odYC_�_����D%2�
�,��Q�9��ۚѶ �HS���彛2����,B{������s���_X�˝\������s�:B��S�+gV�MT���^q8sn�S��x�r��M��:�$�D������'��{jЎ��ɝ]Qi��̗o�mSl��c��a��݃}������7h�M62n(g��,p��{#XB�ߘ"�����|+�����s��%����]�o�+�U��D�o�w��]��o��U�I��ҁBm:+�|���"+����J�ߙ��ߛ��Ě�JtE�D;�ھ-Ɂ�6`�ƈN`���P$��-g��F�1=���x,�k�:�0߱��ʛY�3AQ���4�3��~�"zLm�A��C44$��\�����3=�z�{�Ä�G��V�s"s��,ʹر����s�V��V/�v��[��7ϊ:t�@Q27*�O�x�$�����n�f���C7�,j��A�*df-Л�ʊGd�C�����	O�����{AG�q�H@�[E��
w^E'�W��,TJ�t�'�:Ԣ    