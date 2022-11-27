{
Copyright (C) 2002-2020  Massimo Melina (www.rejetto.com)

This file is part of HFS ~ HTTP File Server.

    HFS is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    HFS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with HFS; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
{$INCLUDE defs.inc }

unit main;
{$I NoRTTI.inc}

interface

uses
  // delphi libs
  Windows, Messages, SysUtils, Forms, Menus, Graphics, Controls, ComCtrls, Dialogs, math,
  Buttons, StdCtrls, ExtCtrls, ToolWin, ImageList, strutils, AppEvnts, types,
  iniFiles, Classes, System.Contnrs, Winapi.CommCtrl,
  Vcl.Mask, Vcl.ImgList, Vcl.VirtualImageList,
  // 3rd part libs. ensure you have all of these, the same version reported in dev-notes.txt
  rnqTraylib,
  // rejetto libs
  hfsGlobal, fileLib, srvConst, serverLib, srvClassesLib,
  IconsLib,
  HSlib, monoLib, progFrmLib, classesLib;


type
  TmyTrayicon = TTrayicon;

  TconnData = class(TconnDataMain)  // data associated to a client connection
  private
    fLastFile: Tfile;
    procedure setLastFile(f: Tfile);
  public
    tray: TmyTrayicon;
    tray_ico: Ticon;
//    countAsDownload: boolean; // cache the value for the Tfile method
    { cache User-Agent because often retrieved by connBox.
    { this value is filled after the http request is complete (HE_REQUESTED),
    { or before, during the request as we get a file (HE_POST_FILE). }
    deleting: boolean;      // don't use, this item is about to be discarded
    nextDloadScreenUpdate: Tdatetime; // avoid too fast updating during download
    preReply: TpreReply;
    lastBytesSent, lastBytesGot: int64; // used for print to log only the recent amount of bytes  
    fileXferStart: Tdatetime;
    bytesGotGrouping, bytesSentGrouping: record
      bytes: integer;
      since: Tdatetime;
     end;
    { here we put just a pointer because the file type would triplicate
    { the size of this record, while it is NIL for most connections }
    f: ^file; // uploading file handle

    property lastFile: Tfile read fLastFile write setLastFile;
    constructor create(conn: ThttpConn);
    destructor Destroy; override;
    function accessFor(f: TFile): Boolean;
   end; // Tconndata

  Tautosave = record
    every, minimum: integer; // in seconds
    last: Tdatetime;
    menu: Tmenuitem;
    end;

  TtreeNodeDynArray = array of TtreeNode;

  TmainFrm = class(TForm)
    filemenu: TPopupMenu;
    newfolder1: TMenuItem;
    Remove1: TMenuItem;
    topToolbar: TToolBar;
    startBtn: TToolButton;
    ToolButton1: TToolButton;
    menuBtn: TToolButton;
    menu: TPopupMenu;
    About1: TMenuItem;
    connmenu: TPopupMenu;
    Kickconnection1: TMenuItem;
    KickIPaddress1: TMenuItem;
    Kickallconnections1: TMenuItem;
    Viewhttprequest1: TMenuItem;
    Saveoptions1: TMenuItem;
    toregistrycurrentuser1: TMenuItem;
    tofile1: TMenuItem;
    toregistryallusers1: TMenuItem;
    timer: TTimer;
    urlToolbar: TToolBar;
    IPaddress1: TMenuItem;
    AutocopyURLonadditionChk: TMenuItem;
    foldersbeforeChk: TMenuItem;
    Browseit1: TMenuItem;
    Openit1: TMenuItem;
    appEvents: TApplicationEvents;
    logmenu: TPopupMenu;
    DumprequestsChk: TMenuItem;
    CopyURL1: TMenuItem;
    Readonly1: TMenuItem;
    Clear1: TMenuItem;
    Copy1: TMenuItem;
    N3: TMenuItem;
    LogtimeChk: TMenuItem;
    LogdateChk: TMenuItem;
    Saveas1: TMenuItem;
    Save1: TMenuItem;
    N4: TMenuItem;
    connPnl: TPanel;
    MinimizetotrayChk: TMenuItem;
    Restore1: TMenuItem;
    Numberofcurrentconnections1: TMenuItem;
    Numberofloggeddownloads1: TMenuItem;
    Numberofloggedhits1: TMenuItem;
    Exit1: TMenuItem;
    Shellcontextmenu1: TMenuItem;
    Flashtaskbutton1: TMenuItem;
    onDownloadChk: TMenuItem;
    onconnectionChk: TMenuItem;
    never1: TMenuItem;
    N6: TMenuItem;
    startminimizedChk: TMenuItem;
    N7: TMenuItem;
    trayicons1: TMenuItem;
    trayfordownloadChk: TMenuItem;
    N8: TMenuItem;
    Loadfilesystem1: TMenuItem;
    Savefilesystem1: TMenuItem;
    N1: TMenuItem;
    N12: TMenuItem;
    usesystemiconsChk: TMenuItem;
    N13: TMenuItem;
    Officialwebsite1: TMenuItem;
    showmaintrayiconChk: TMenuItem;
    Speedlimit1: TMenuItem;
    N10: TMenuItem;
    Limits1: TMenuItem;
    Maxconnections1: TMenuItem;
    Maxconnectionsfromsingleaddress1: TMenuItem;
    Weblinks1: TMenuItem;
    Forum1: TMenuItem;
    FAQ1: TMenuItem;
    License1: TMenuItem;
    Paste1: TMenuItem;
    Addfiles1: TMenuItem;
    Addfolder1: TMenuItem;
    graphSplitter: TSplitter;
    Graphrefreshrate1: TMenuItem;
    Pausestreaming1: TMenuItem;
    Setuserpass1: TMenuItem;
    BanIPaddress1: TMenuItem;
    N2: TMenuItem;
    BannedIPaddresses1: TMenuItem;
    Loadrecentfiles1: TMenuItem;
    alwaysontopChk: TMenuItem;
    Checkforupdates1: TMenuItem;
    Rename1: TMenuItem;
    Otheroptions1: TMenuItem;
    Nodownloadtimeout1: TMenuItem;
    Autoclose1: TMenuItem;
    Showbandwidthgraph1: TMenuItem;
    Pause1: TMenuItem;
    reloadonstartupChk: TMenuItem;
    MIMEtypes1: TMenuItem;
    autocopyURLonstartChk: TMenuItem;
    Accounts1: TMenuItem;
    encodenonasciiChk: TMenuItem;
    encodeSpacesChk: TMenuItem;
    URLencoding1: TMenuItem;
    traymessage1: TMenuItem;
    DMbrowserTplChk: TMenuItem;
    Guide1: TMenuItem;
    autosaveVFSchk: TMenuItem;
    sendHFSidentifierChk: TMenuItem;
    persistentconnectionsChk: TMenuItem;
    Logfile1: TMenuItem;
    VirtualFileSystem1: TMenuItem;
    listfileswithhiddenattributeChk: TMenuItem;
    listfileswithsystemattributeChk: TMenuItem;
    hideProtectedItemsChk: TMenuItem;
    StartExit1: TMenuItem;
    Font1: TMenuItem;
    Newlink1: TMenuItem;
    SetURL1: TMenuItem;
    usecommentasrealmChk: TMenuItem;
    Resetuserpass1: TMenuItem;
    Switchtovirtual1: TMenuItem;
    LogiconsChk: TMenuItem;
    Loginrealm1: TMenuItem;
    Logwhat1: TMenuItem;
    N9: TMenuItem;
    N16: TMenuItem;
    logconnectionsChk: TMenuItem;
    logDisconnectionsChk: TMenuItem;
    logRequestsChk: TMenuItem;
    logRepliesChk: TMenuItem;
    logFulldownloadsChk: TMenuItem;
    logBytesreceivedChk: TMenuItem;
    logBytessentChk: TMenuItem;
    logServerstartChk: TMenuItem;
    logServerstopChk: TMenuItem;
    logBrowsingChk: TMenuItem;
    Help1: TMenuItem;
    Introduction1: TMenuItem;
    N18: TMenuItem;
    Resetfileshits1: TMenuItem;
    Kickidleconnections1: TMenuItem;
    Connectionsinactivitytimeout1: TMenuItem;
    logOnVideoChk: TMenuItem;
    N19: TMenuItem;
    Clearfilesystem1: TMenuItem;
    HintsfornewcomersChk: TMenuItem;
    logUploadsChk: TMenuItem;
    only1instanceChk: TMenuItem;
    compressedbrowsingChk: TMenuItem;
    Numberofloggeduploads1: TMenuItem;
    logProgressChk: TMenuItem;
    Flagfilesaddedrecently1: TMenuItem;
    Flagasnew1: TMenuItem;
    confirmexitChk: TMenuItem;
    Donotlogaddress1: TMenuItem;
    N15: TMenuItem;
    Custom1: TMenuItem;
    noPortInUrlChk: TMenuItem;
    saveTotalsChk: TMenuItem;
    Findexternaladdress1: TMenuItem;
    findExtOnStartupChk: TMenuItem;
    DynamicDNSupdater1: TMenuItem;
    Custom2: TMenuItem;
    N21: TMenuItem;
    CJBtemplate1: TMenuItem;
    NoIPtemplate1: TMenuItem;
    DynDNStemplate1: TMenuItem;
    searchbetteripChk: TMenuItem;
    deletePartialUploadsChk: TMenuItem;
    Minimumdiskspace1: TMenuItem;
    Banthisaddress1: TMenuItem;
    modalOptionsChk: TMenuItem;
    Address2name1: TMenuItem;
    Resetnewflag1: TMenuItem;
    beepChk: TMenuItem;
    Renamepartialuploads1: TMenuItem;
    SelfTest1: TMenuItem;
    Opendirectlyinbrowser1: TMenuItem;
    maxDLs1: TMenuItem;
    Editresource1: TMenuItem;
    logBannedChk: TMenuItem;
    ToolButton2: TToolButton;
    modeBtn: TToolButton;
    Addfiles2: TMenuItem;
    Addfolder2: TMenuItem;
    Clearoptionsandquit1: TMenuItem;
    numberFilesOnUploadChk: TMenuItem;
    Upload2: TMenuItem;
    UninstallHFS1: TMenuItem;
    maxIPs1: TMenuItem;
    maxIPsDLing1: TMenuItem;
    keepBakUpdatingChk: TMenuItem;
    Autosaveevery1: TMenuItem;
    autoSaveOptionsChk: TMenuItem;
    Apachelogfileformat1: TMenuItem;
    SwitchON1: TMenuItem;
    loadSingleCommentsChk: TMenuItem;
    Bindroottorealfolder1: TMenuItem;
    Unbindroot1: TMenuItem;
    Switchtorealfolder1: TMenuItem;
    abortBtn: TToolButton;
    Seelastserverresponse1: TMenuItem;
    N5: TMenuItem;
    logOtherEventsChk: TMenuItem;
    supportDescriptionChk: TMenuItem;
    Showcustomizedoptions1: TMenuItem;
    useISOdateChk: TMenuItem;
    browseUsingLocalhostChk: TMenuItem;
    Addingfolder1: TMenuItem;
    askFolderKindChk: TMenuItem;
    defaultToVirtualChk: TMenuItem;
    defaultToRealChk: TMenuItem;
    enableNoDefaultChk: TMenuItem;
    RunHFSwhenWindowsstarts1: TMenuItem;
    trayInsteadOfQuitChk: TMenuItem;
    Addicons1: TMenuItem;
    Iconmasks1: TMenuItem;
    CopyURLwithpassword1: TMenuItem;
    CopyURLwithdifferentaddress1: TMenuItem;
    hisIPaddressisusedforURLbuilding1: TMenuItem;
    N20: TMenuItem;
    Acceptconnectionson1: TMenuItem;
    Anyaddress1: TMenuItem;
    autoCommentChk: TMenuItem;
    fingerprintsChk: TMenuItem;
    CopyURLwithfingerprint1: TMenuItem;
    recursiveListingChk: TMenuItem;
    Disable1: TMenuItem;
    logOnlyServedChk: TMenuItem;
    Fingerprints1: TMenuItem;
    saveNewFingerprintsChk: TMenuItem;
    Createfingerprintonaddition1: TMenuItem;
    pwdInPagesChk: TMenuItem;
    deleteDontAskChk: TMenuItem;
    Updates1: TMenuItem;
    updateDailyChk: TMenuItem;
    N22: TMenuItem;
    Howto1: TMenuItem;
    testerUpdatesChk: TMenuItem;
    Defaultsorting1: TMenuItem;
    Name1: TMenuItem;
    Size1: TMenuItem;
    Time1: TMenuItem;
    Hits1: TMenuItem;
    centralPnl: TPanel;
    splitV: TSplitter;
    browseBtn: TToolButton;
    Resettotals1: TMenuItem;
    Clearandresettotals1: TMenuItem;
    Dontlogsomefiles1: TMenuItem;
    preventLeechingChk: TMenuItem;
    NumberofdifferentIPaddresses1: TMenuItem;
    NumberofdifferentIPaddresseseverconnected1: TMenuItem;
    Addresseseverconnected1: TMenuItem;
    N24: TMenuItem;
    Allowedreferer1: TMenuItem;
    ToolButton4: TToolButton;
    oemForIonChk: TMenuItem;
    portBtn: TToolButton;
    resetOptions1: TMenuItem;
    quitWithoutAskingToSaveChk: TMenuItem;
    highSpeedChk: TMenuItem;
    freeLoginChk: TMenuItem;
    backupSavingChk: TMenuItem;
    graphMenu: TPopupMenu;
    Reset1: TMenuItem;
    Extension1: TMenuItem;
    linksBeforeChk: TMenuItem;
    updateAutomaticallyChk: TMenuItem;
    stopSpidersChk: TMenuItem;
    logPnl: TPanel;
    logBox: TRichEdit;
    filesPnl: TPanel;
    filesBox: TTreeView;
    logTitle: TPanel;
    filesTitle: TPanel;
    graphBox: TPaintBox;
    dumpTrafficChk: TMenuItem;
    httpsUrlsChk: TMenuItem;
    Hide: TMenuItem;
    Speedlimitforsingleaddress1: TMenuItem;
    macrosLogChk: TMenuItem;
    Debug1: TMenuItem;
    preventStandbyChk: TMenuItem;
    titlePnl: TPanel;
    HTMLtemplate1: TMenuItem;
    Edit1: TMenuItem;
    Changefile1: TMenuItem;
    Changeeditor1: TMenuItem;
    Restoredefault1: TMenuItem;
    logToolbar: TPanel;
    splitH: TSplitter;
    collapsedPnl: TPanel;
    expandBtn: TSpeedButton;
    expandedPnl: TPanel;
    openLogBtn: TSpeedButton;
    searchPnl: TPanel;
    logSearchBox: TLabeledEdit;
    logUpDown: TUpDown;
    openFilteredLog: TSpeedButton;
    collapseBtn: TSpeedButton;
    copyBtn: TToolButton;
    urlBox: TEdit;
    Bevel1: TBevel;
    enableMacrosChk: TMenuItem;
    Donate1: TMenuItem;
    Purge1: TMenuItem;
    Editeventscripts1: TMenuItem;
    maxDLsIP1: TMenuItem;
    Maxlinesonscreen1: TMenuItem;
    Properties1: TMenuItem;
    N11: TMenuItem;
    restoreCfgBtn: TToolButton;
    N14: TMenuItem;
    Runscript1: TMenuItem;
    Changeport1: TMenuItem;
    logDeletionsChk: TMenuItem;
    showMemUsageChk: TMenuItem;
    trayiconforeachdownload1: TMenuItem;
    tabOnLogFileChk: TMenuItem;
    noContentdispositionChk: TMenuItem;
    Defaultpointtoaddfiles1: TMenuItem;
    switchMode: TMenuItem;
    sbar: TStatusBar;
    connBox: TListView;
    Reverttopreviousversion1: TMenuItem;
    updateBtn: TToolButton;
    delayUpdateChk: TMenuItem;
    oemTarChk: TMenuItem;
    AnyAddressV6: TMenuItem;
    AddIPasreverseproxy1: TMenuItem;
    BtnImages: TVirtualImageList;
    procedure FormResize(Sender: TObject);
    procedure filesBoxCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
    procedure newfolder1Click(Sender: TObject);
    procedure filesBoxEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
    procedure filesBoxEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure Remove1Click(Sender: TObject);
    procedure startBtnClick(Sender: TObject);
    procedure filesBoxChange(Sender: TObject; Node: TTreeNode);
    procedure Kickconnection1Click(Sender: TObject);
    procedure Kickallconnections1Click(Sender: TObject);
    procedure KickIPaddress1Click(Sender: TObject);
    procedure Viewhttprequest1Click(Sender: TObject);
    procedure connmenuPopup(Sender: TObject);
    procedure filemenuPopup(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure timerEvent(Sender: TObject);
    procedure menuPopup(Sender: TObject);
    procedure filesBoxDblClick(Sender: TObject);
    procedure filesBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure filesBoxCompare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure foldersbeforeChkClick(Sender: TObject);
    procedure Browseit1Click(Sender: TObject);
    procedure Openit1Click(Sender: TObject);
    procedure splitVMoved(Sender: TObject);
    procedure appEventsShowHint(var HintStr: String;
      var CanShow: Boolean; var HintInfo: THintInfo);
    procedure logmenuPopup(Sender: TObject);
    procedure Readonly1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Clearoptionsandquit1click(Sender: TObject);
    procedure appEventsMinimize(Sender: TObject);
    procedure appEventsRestore(Sender: TObject);
    procedure Restore1Click(Sender: TObject);
    procedure Numberofcurrentconnections1Click(Sender: TObject);
    procedure Numberofloggeddownloads1Click(Sender: TObject);
    procedure Numberofloggedhits1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure onDownloadChkClick(Sender: TObject);
    procedure onconnectionChkClick(Sender: TObject);
    procedure never1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure filesBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure filesBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Savefilesystem1Click(Sender: TObject);
    procedure filesBoxDeletion(Sender: TObject; Node: TTreeNode);
    procedure Loadfilesystem1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Officialwebsite1Click(Sender: TObject);
    procedure showmaintrayiconChkClick(Sender: TObject);
    procedure Speedlimit1Click(Sender: TObject);
    procedure tofile1Click(Sender: TObject);
    procedure Maxconnections1Click(Sender: TObject);
    procedure Maxconnectionsfromsingleaddress1Click(Sender: TObject);
    procedure Forum1Click(Sender: TObject);
    procedure FAQ1Click(Sender: TObject);
    procedure License1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Addfiles1Click(Sender: TObject);
    procedure Addfolder1Click(Sender: TObject);
    procedure graphSplitterMoved(Sender: TObject);
    procedure Graphrefreshrate1Click(Sender: TObject);
    procedure Pausestreaming1Click(Sender: TObject);
    procedure Comment1Click(Sender: TObject);
    procedure filesBoxCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Setuserpass1Click(Sender: TObject);
    procedure browseBtnClick(Sender: TObject);
    procedure BanIPaddress1Click(Sender: TObject);
    procedure BannedIPaddresses1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Checkforupdates1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure Nodownloadtimeout1Click(Sender: TObject);
    procedure alwaysontopChkClick(Sender: TObject);
    procedure Showbandwidthgraph1Click(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
    procedure MIMEtypes1Click(Sender: TObject);
    procedure Accounts1Click(Sender: TObject);
    procedure traymessage1Click(Sender: TObject);
    procedure Guide1Click(Sender: TObject);
    procedure filesBoxAddition(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Logfile1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure Newlink1Click(Sender: TObject);
    procedure SetURL1Click(Sender: TObject);
    procedure Resetuserpass1Click(Sender: TObject);
    procedure Switchtovirtual1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Loginrealm1Click(Sender: TObject);
    procedure Introduction1Click(Sender: TObject);
    procedure Resetfileshits1Click(Sender: TObject);
    procedure persistentconnectionsChkClick(Sender: TObject);
    procedure Kickidleconnections1Click(Sender: TObject);
    procedure Connectionsinactivitytimeout1Click(Sender: TObject);
    procedure splitHMoved(Sender: TObject);
    procedure Clearfilesystem1Click(Sender: TObject);
    procedure Numberofloggeduploads1Click(Sender: TObject);
    procedure Flagfilesaddedrecently1Click(Sender: TObject);
    procedure Flagasnew1Click(Sender: TObject);
    procedure Donotlogaddress1Click(Sender: TObject);
    procedure Custom1Click(Sender: TObject);
    procedure Findexternaladdress1Click(Sender: TObject);
    procedure sbarDblClick(Sender: TObject);
    procedure NoIPtemplate1Click(Sender: TObject);
    procedure Custom2Click(Sender: TObject);
    procedure CJBtemplate1Click(Sender: TObject);
    procedure DynDNStemplate1Click(Sender: TObject);
    procedure Minimumdiskspace1Click(Sender: TObject);
    procedure Banthisaddress1Click(Sender: TObject);
    procedure Address2name1Click(Sender: TObject);
    procedure Resetnewflag1Click(Sender: TObject);
    procedure Renamepartialuploads1Click(Sender: TObject);
    procedure SelfTest1Click(Sender: TObject);
    procedure Opendirectlyinbrowser1Click(Sender: TObject);
    procedure noPortInUrlChkClick(Sender: TObject);
    procedure maxDLs1Click(Sender: TObject);
    procedure MaxDLsIP1Click(Sender: TObject);
    procedure Editresource1Click(Sender: TObject);
    procedure modeBtnClick(Sender: TObject);
    procedure Shellcontextmenu1Click(Sender: TObject);
    procedure UninstallHFS1Click(Sender: TObject);
    procedure maxIPs1Click(Sender: TObject);
    procedure maxIPsDLing1Click(Sender: TObject);
    procedure Autosaveevery1Click(Sender: TObject);
    procedure CopyURL1Click(Sender: TObject);
    procedure Apachelogfileformat1Click(Sender: TObject);
    procedure Bindroottorealfolder1Click(Sender: TObject);
    procedure Unbindroot1Click(Sender: TObject);
    procedure Switchtorealfolder1Click(Sender: TObject);
    procedure abortBtnClick(Sender: TObject);
    procedure Seelastserverresponse1Click(Sender: TObject);
    procedure Showcustomizedoptions1Click(Sender: TObject);
    procedure useISOdateChkClick(Sender: TObject);
    procedure RunHFSwhenWindowsstarts1Click(Sender: TObject);
    procedure askFolderKindChkClick(Sender: TObject);
    procedure defaultToVirtualChkClick(Sender: TObject);
    procedure defaultToRealChkClick(Sender: TObject);
    procedure Addicons1Click(Sender: TObject);
    procedure Iconmasks1Click(Sender: TObject);
    procedure Anyaddress1Click(Sender: TObject);
    procedure filesBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure CopyURLwithfingerprint1Click(Sender: TObject);
    procedure Disable1Click(Sender: TObject);
    procedure saveNewFingerprintsChkClick(Sender: TObject);
    procedure Createfingerprintonaddition1Click(Sender: TObject);
    procedure Howto1Click(Sender: TObject);
    procedure Name1Click(Sender: TObject);
    procedure Size1Click(Sender: TObject);
    procedure Time1Click(Sender: TObject);
    procedure Hits1Click(Sender: TObject);
    procedure Resettotals1Click(Sender: TObject);
    procedure menuBtnClick(Sender: TObject);
    procedure Clearandresettotals1Click(Sender: TObject);
    procedure Dontlogsomefiles1Click(Sender: TObject);
    procedure NumberofdifferentIPaddresses1Click(Sender: TObject);
    procedure NumberofdifferentIPaddresseseverconnected1Click(Sender: TObject);
    procedure Addresseseverconnected1Click(Sender: TObject);
    procedure Allowedreferer1Click(Sender: TObject);
    procedure filesBoxEnter(Sender: TObject);
    procedure filesBoxMouseEnter(Sender: TObject);
    procedure filesBoxMouseLeave(Sender: TObject);
    procedure filesBoxExit(Sender: TObject);
    procedure sbarMouseDown(Sender: TObject; Button: TMouseButton; shift: TShiftState; X, Y: Integer);
    procedure portBtnClick(Sender: TObject);
    procedure SwitchON1Click(Sender: TObject);
    procedure resetOptions1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure Extension1Click(Sender: TObject);
    procedure findExtOnStartupChkClick(Sender: TObject);
    procedure openLogBtnClick(Sender: TObject);
    procedure logSearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure graphBoxPaint(Sender: TObject);
    procedure logUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure logSearchBoxChange(Sender: TObject);
    procedure HideClick(Sender: TObject);
    procedure Speedlimitforsingleaddress1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Restoredefault1Click(Sender: TObject);
    procedure Changefile1Click(Sender: TObject);
    procedure Changeeditor1Click(Sender: TObject);
    procedure expandBtnClick(Sender: TObject);
    procedure collapseBtnClick(Sender: TObject);
    procedure copyBtnClick(Sender: TObject);
    procedure urlBoxChange(Sender: TObject);
    procedure enableMacrosChkClick(Sender: TObject);
    procedure Donate1Click(Sender: TObject);
    procedure Purge1Click(Sender: TObject);
    procedure Editeventscripts1Click(Sender: TObject);
    procedure Maxlinesonscreen1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure filesBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure restoreCfgBtnClick(Sender: TObject);
    procedure Runscript1Click(Sender: TObject);
    procedure logBoxChange(Sender: TObject);
    procedure logBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Changeport1Click(Sender: TObject);
    procedure trayiconforeachdownload1Click(Sender: TObject);
    procedure Defaultpointtoaddfiles1Click(Sender: TObject);
    function appEventsHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    procedure connBoxData(Sender: TObject; Item: TListItem);
    procedure connBoxAdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure Reverttopreviousversion1Click(Sender: TObject);
    procedure updateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AnyAddressV6Click(Sender: TObject);
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
    procedure AddIPasreverseproxy1Click(Sender: TObject);
  private
    function searchLog(dir:integer):boolean;
    procedure WMDropFiles(var msg:TWMDropFiles);
      message WM_DROPFILES;
    procedure WMQueryEndSession(var msg:TWMQueryEndSession);
      message WM_QUERYENDSESSION;
    procedure WMEndSession(var msg:TWMEndSession);
      message WM_ENDSESSION;
    procedure WMNCLButtonDown(var msg:TWMNCLButtonDown);
      message WM_NCLBUTTONDOWN;
    procedure trayEvent(sender:Tobject; ev:TtrayEvent);
    procedure downloadtrayEvent(sender: Tobject; ev: TtrayEvent);
    procedure httpEvent(event: ThttpEvent; conn: ThttpConn);
    function  pointedFile(strict:boolean=TRUE):Tfile;
    function  pointedConnection():TconnData;
    procedure updateSbar();
    function  getFolderPage(folder:Tfile; cd:TconnData; otpl: TTpl):string;
    function  selectedConnection():TconnData;
    function  sendPic(cd:TconnData; idx:integer=-1):boolean;
    procedure ipmenuclick(sender:Tobject);
    procedure acceptOnMenuclick(sender:Tobject);
    procedure copyURLwithAddressMenuClick(sender:Tobject);
    procedure copyURLwithPasswordMenuClick(sender:Tobject);
    procedure updateTrayTip();
    procedure updateCopyBtn();
//    procedure setTrayShows(s:string);
    procedure setTrayShows(s: TTrayShows);
    procedure addTray();
    procedure refreshConn(conn:TconnData);
    function  getVFS(node:Ttreenode=NIL): RawByteString;
    function  getVFSJZ(node: TTreeNode=NIL): RawByteString;
    procedure setnoDownloadTimeout(v:integer);
		procedure addDropFiles(hnd:Thandle; under:Ttreenode);
    procedure pasteFiles();
		function  addFilesFromString(files:string; under:Ttreenode=NIL):Tfile;
		procedure setGraphRate(v:integer);
    procedure updateRecentFilesMenu();
    procedure recentsClick(sender:Tobject);
    procedure popupMainMenu();
    procedure updateAlwaysOnTop();
    procedure initVFS();
		procedure refreshIPlist();
		procedure updateUrlBox();
    procedure loadVFS(fn:string);
    procedure purgeConnections();
    procedure setEasyMode(easy:boolean=TRUE);
    procedure hideGraph();
    procedure showGraph();
    function  fileAttributeInSelection(fa:TfileAttribute):boolean;
    procedure progFrmHttpGetUpdate(sender:TObject; buffer:pointer; Len:integer);
    function  recalculateGraph(): Boolean;
    procedure remove(node:Ttreenode=NIL); OverLoad;
 public
    fileSrv: TFileServer;
    easyMode: boolean;
    selectedFile: Tfile;  // last selected file on the tree
    procedure statusBarHttpGetUpdate(sender:TObject; buffer:pointer; Len:integer);
    function  getLP: TLoadPrefs;
    function  getSP: TShowPrefs;
    procedure onAddingItemOnServer;
    procedure remove(f: TFile=NIL); OverLoad;
    function  setCfg(cfg:string; alreadyStarted:boolean=TRUE):boolean;
    function  getCfg(exclude:string=''): string;
    function  saveCFG(): boolean;
    function  addFile(f: TFile; parent: TTreeNode=NIL; skipComment: Boolean=FALSE): TFile; OverLoad;
    function  addFile(f: TFile; parent: TTreeNode; skipComment: boolean; var newNode: TTreeNode): TFile; OverLoad;
    procedure add2log(lines:string; cd:TconnDataMain=NIL; clr:Tcolor= Graphics.clDefault);
    function  ipPointedInLog():string;
    procedure saveVFS(fn:string='');
    function  finalInit(): boolean;
    procedure processParams_after(var params: TStringDynArray);
    procedure setStatusBarText(s:string; lastFor:integer=5);
    procedure minimizeToTray();
    procedure autoCheckUpdates();
    function  SetSelectedFile(f: TFile): Boolean; OverLoad;
    function  SetSelectedFile(f: TFile; node: TTreeNode): Boolean; OverLoad;
    function  copySelection():TtreeNodeDynArray;
    procedure setLogToolbar(v:boolean);
    function  getTrayTipMsg(const tpl: String=''): String;
    procedure menuDraw(sender:Tobject; cnv: Tcanvas; r:Trect; selected:boolean);
    procedure menuMeasure(sender:Tobject; cnv: Tcanvas; var w:integer; var h:integer);
    procedure wrapInputQuery(sender:Tobject);
    function  fileExistsByURL(const url: string): boolean;
  end; // Tmainfrm

  TFileHlp = class helper for Tfile
     function getShownRealm():string;
  end;

var
  mainFrm: TmainFrm;
//  tpl: Ttpl; // template for generated pages
  customIPs: TStringDynArray;   // user customized IP addresses
  iconMasks: TstringIntPairs;
//  ipsEverConnected: THashedStringList;
//  rootNode: TtreeNode;
  noReplyBan: boolean;
  externalIP: string;
  banlist: array of record ip,comment: String; end;
  trayMsg: string; // template for the tray hint
//  customIPservice: string;
  tplFilename: string; // when empty, we are using the default tpl
  trayNL: string = #13;
//  mimeTypes, address2name, IPservices: TstringDynArray; -> srvVars
//  IPservicesTime: TdateTime; -> srvVars
  inBrowserIfMIME: boolean;
//  VFSmodified: boolean; // TRUE if the VFS changes have not been saved
  tempScriptFilename: string;
//  inTotalOfs, outTotalOfs: int64; // used to cumulate in/out totals
//  hitsLogged, downloadsLogged, uploadsLogged: integer;
  lastFileOpen: string;
  speedLimit: real;            // overall limit, Kb/s --- it virtualizes the value of globalLimiter.maxSpeed, that's actually set to zero when streaming is paused
  currentCFG: string;
  currentCFGhashed: THashedStringList;
  saveMode: ( SM_USER, SM_SYSTEM, SM_FILE );
  tray: TmyTrayicon;
  dyndns: record
    url, lastResult, lastIP: string;
    user, pwd, host: string;
    active: boolean;
    lastTime: Tdatetime;
   end;

procedure kickBannedOnes();
procedure repaintTray();
function  paramsAsArray(): TStringDynArray;
procedure processParams_before(var params: TStringDynArray; const allowed: String='');
function  loadCfg(var ini, tpl: String): Boolean;
function conn2data(i: integer): TconnData; inline; overload;
function countDownloads(const ip: String=''; const user: String=''; f:Tfile=NIL): Integer;
function protoColon(): String;
procedure setSpeedLimitIP(v: real);
function deleteAccount(const name: String): Boolean;
function createFingerprint(const fn: String; showProgress: Boolean = True): String;

implementation

{$R *.dfm}
{ $R data.res }

uses
  {$IFDEF UNICODE}
   AnsiStrings,
  {$ENDIF UNICODE}
  MMsystem, UITypes, Threading,
  clipbrd, dateutils, shlobj, shellapi, winsock,
  OverbyteIcsWSocket, OverbyteIcsHttpProt, OverbyteIcsZLibHigh, OverbyteIcsUtils,
  {$IFDEF UNICODE}
//   AnsiClasses,
  {$ENDIF UNICODE}
  RDFileUtil, RDUtils, RDSysUtils,
  RnQCrypt, RnQzip, RnQLangs, RnQDialogs,
//  RnQJSON,
  RnQNet.Uploads.Lib, RnQNet.Uploads.Tar,
  langLib,
  newuserpassDlg, optionsDlg, utilLib, folderKindDlg, shellExtDlg, diffDlg, ipsEverDlg,
  parserLib, srvUtils, srvVars, netUtils,
  hfs.tray,
  purgeDlg, filepropDlg, runscriptDlg, scriptLib, hfsVars;

// global variables
var
  progFrm: TprogressForm;
  autosaveVFS: Tautosave;
//  lastDiffTpl: record
//    f: Tfile;
//    ofs: integer;
//    end;

function deleteAccount(const name: String): Boolean;
var
  n: integer;
begin
  n := length(accounts);
// search
for var i:=0 to n-1 do
  if sameText(name, accounts[i].user) then // found
    begin
    // shift
    for var j:=i to n-2 do
      accounts[j]:=accounts[j+1];
    // shrink
    setLength(accounts, n-1);
    // aftermaths
    purgeVFSaccounts();
    mainfrm.filesBox.repaint();
    result:=TRUE;
    exit;
    end;
result:=FALSE;
end; // deleteAccount

function noLimitsFor(account:Paccount):boolean;
begin
account:=accountRecursion(account, ARSC_NOLIMITS);
result:=assigned(account) and account.noLimits;
end; // noLimitsFor

function conn2data(p: Tobject): TconnData; inline; overload;
begin
if p = NIL then result:=NIL
else result:=TconnData((p as ThttpConn).data)
end; // conn2data

function conn2data(i: integer): TconnData; inline; overload;
begin
  try
    if i < srv.conns.count then
      result := conn2data(srv.conns[i])
    else
      result := conn2data(srv.offlines[i-srv.conns.count])
   except
    result := NIL
  end
end; // conn2data

function conn2data(li: TlistItem): TconnData; inline; overload;
begin
if li = NIL then
  result := NIL
else
  result := conn2data(li.index)
end; // conn2data

function countDownloads(const ip: String=''; const user: String=''; f: Tfile=NIL): Integer;
var
  i: integer;
  d: TconnData;
begin
result:=0;
i:=0;
while i < srv.conns.count do
  begin
  d:=conn2data(i);
  if isDownloading(d)
  and ((f = NIL) or (assigned(d.lastFile) and d.lastFile.same(f)))
  and ((ip = '') or addressMatch(ip, d.address))
  and ((user = '') or sameText(user, d.usr))
  then
    inc(result);
  inc(i);
  end;
end; // countDownloads


procedure repaintTray();
var
  bmp: Tbitmap;
  n: Integer;
begin
  if quitting or (mainfrm = NIL) then
    exit;
  bmp := getBaseTrayIcon(0, TRAY_ICON_SIZE);

  case trayShows of
   TS_connections: n := srv.conns.count;
   TS_downloads: n := downloadsLogged;
   TS_uploads: n := uploadsLogged;
   TS_hits: n := hitsLogged;
   TS_ips: n := countIPs();
   TS_ips_ever: n := ipsEverConnected.count;
   else
    n := 0;
  end;
  if trayShows <> TTrayShows.TS_none then
    drawTrayIconNumber(bmp.canvas, n, TRAY_ICON_SIZE);
  //tray_ico.Handle := bmpToHico(bmp);
  tray_ico.Handle := bmp2ico32(bmp);
  //tray_ico.Handle := bmp2ico4M(bmp);
  //tray_ico.Transparent := FALSE;
  bmp.free;
  tray.setIcon(tray_ico);
end; // repaintTray

procedure resetTotals();
begin
hitsLogged:=0;
downloadsLogged:=0;
uploadsLogged:=0;
outTotalOfs:=-srv.bytesSent;
inTotalOfs:=-srv.bytesReceived;
repainttray();
end; // resetTotals

procedure flash();
begin
FlashWindow(application.handle, TRUE);
if mainFrm.beepChk.checked then MessageBeep(MB_OK);
end; // flash

procedure onLoadVFSprogress(Sender: TObject; PRC: Real; var Cancel: Boolean);
begin
  if Assigned(progFrm) then
    begin
      Cancel := progFrm.cancelRequested;
      if not Cancel and progFrm.visible then
        begin
          progFrm.progress := prc;
          application.ProcessMessages();
        end;
    end
   else
    begin
      Cancel := False;
    end;
end;

procedure updateDynDNS();
resourcestring
  MSG_DDNS_NO_REPLY = 'no reply';
  MSG_DDNS_OK = 'successful';
  MSG_DDNS_UNK = 'unknown reply: %s';
  MSG_DDNS_ERR = 'error: %s';
  MSG_DDNS_REQ = 'DNS update requested for %s: %s';
  MSG_DDNS_DOING = 'Updating dynamic DNS...';
  MSG_DDNS_FAIL = 'DNS update failed: %s'#13'User intervention is required.';
  MSG_DDNS_REPLY_SIZE = '%d bytes reply';
  MSG_DDNS_badauth='invalid user/password';
  MSG_DDNS_notfqdn='incomplete hostname, required form aaa.bbb.com';
  MSG_DDNS_nohost='specified hostname does not exist';
  MSG_DDNS_notyours='specified hostname belongs to another username';
  MSG_DDNS_numhost='too many or too few hosts found';
  MSG_DDNS_abuse='specified hostname is blocked for update abuse';
  MSG_DDNS_dnserr='server error';
  MSG_DDNS_911='server error';
  MSG_DDNS_notdonator='an option specified requires payment';
  MSG_DDNS_badagent='banned client';

  function interpretResponse(s:string):string;
  const
    ERRORS: array [1..10] of record code,msg:string; end = (
      (code:'badauth';  msg:MSG_DDNS_badauth),
      (code:'notfqdn';  msg:MSG_DDNS_notfqdn),
      (code:'nohost';   msg:MSG_DDNS_nohost),
      (code:'!yours';   msg:MSG_DDNS_notyours),
      (code:'numhost';  msg:MSG_DDNS_numhost),
      (code:'abuse';    msg:MSG_DDNS_abuse),
      (code:'dnserr';   msg:MSG_DDNS_dnserr),
      (code:'911';      msg:MSG_DDNS_911),
      (code:'!donator'; msg:MSG_DDNS_notdonator),
      (code:'badagent'; msg:MSG_DDNS_badagent)
    );
  var
    code: string;
  begin
  s:=trim(s);
  if s = '' then
    exit(MSG_DDNS_NO_REPLY);
  code:='';
  result:= MSG_DDNS_OK;
  code:=trim(lowercase(getTill(' ',s)));
  if stringExists(code, ['good','nochg']) then exit;
  for var i: integer :=1 to length(ERRORS) do
    if code = ERRORS[i].code then
      begin
      dyndns.active:=FALSE;
      exit(format(MSG_DDNS_ERR,[ERRORS[i].msg]));
      end;
  result:=format(MSG_DDNS_UNK,[s]);
  end; // interpretResponse

var
  s: string;
begin
  if externalIP = '' then
    exit;
  mainfrm.setStatusBarText(MSG_DDNS_DOING);
  dyndns.lastTime:=now();
  try
    s := UnUTF(httpGet(xtpl(dyndns.url, ['%ip%', externalIP])));
   except
    s:=''
  end;
  if s > '' then
    dyndns.lastResult:=s;
  if not mainfrm.logOtherEventsChk.checked then
    exit;
  if length(s) > 30 then
    s := format(MSG_DDNS_REPLY_SIZE, [length(s)])
   else
    s:=interpretResponse(s);
  mainfrm.add2log(format(MSG_DDNS_REQ, [dyndns.lastIP,s]));
  if dyndns.active then
    dyndns.lastIP:=externalIP
   else
    msgDlg(format(MSG_DDNS_FAIL, [s]), MB_ICONERROR);
  mainfrm.setStatusBarText('');
end; // updateDynDNS

procedure disableUserInteraction();
begin
if userInteraction.disabled then exit;
userInteraction.disabled:=TRUE;
if mainFrm = NIL then userInteraction.bakVisible:=FALSE
else
  begin
  userInteraction.bakVisible:=mainfrm.visible;
  mainfrm.visible:=FALSE;
  end;
end; // disableUserInteraction

procedure reenableUserInteraction();
begin
if not userInteraction.disabled then exit;
userInteraction.disabled:=FALSE;
if assigned(mainFrm) then
  mainfrm.visible:=userInteraction.bakVisible;
end; // reenableUserInteraction

constructor TconnData.create(conn:ThttpConn);
begin
conn.data:=self;
self.conn:=conn;
time:=now();
lastActivityTime:=time;
downloadingWhat:=DW_UNK;
urlvars:=THashedStringList.create();
urlvars.lineBreak:='&';
tplCounters:=TstringToIntHash.create();
vars:=THashedStringList.create();
postVars:=THashedStringList.create();
end; // constructor

destructor TconnData.destroy;
begin
for var i: integer :=0 to vars.Count-1 do
  if assigned(vars.Objects[i]) and (vars.Objects[i] <> currentCFGhashed) then
    begin
    vars.Objects[i].free;
    vars.Objects[i]:=NIL;
    end;
freeAndNIL(vars);
freeAndNIL(postVars);
freeAndNIL(urlvars);
freeAndNIL(tplCounters);
freeAndNIL(limiter);
// do NOT free "tpl". It is just a reference to cached tpl. It will be freed only at quit time.
if assigned(f) then
  begin
  closeFile(f^);
//  f.free;
  f := nil;
  end;
inherited destroy;
end; // destructor

// we'll automatically free and previous temporary object
procedure TconnData.setLastFile(f:Tfile);
begin
freeIfTemp(FlastFile);
FlastFile:=f;
end;

function TconnData.accessFor(f: TFile): Boolean;
begin
  Result := Self <> NIL;
  if Result then
    Result := f.accessFor(usr, pwd);
end;

function encodeURLA(const s: String; fullEncode: Boolean=FALSE): RawByteString;
var
  r: RawByteString;
begin
  if fullEncode or mainFrm.encodenonasciiChk.checked then
    begin
      r := ansiToUTF8(s);
      result := HSlib.encodeURL(r, mainFrm.encodeNonasciiChk.checked,
        fullEncode or mainFrm.encodeSpacesChk.checked)
    end
   else
    result := HSlib.encodeURL(s, mainFrm.encodeNonasciiChk.checked,
        fullEncode or mainFrm.encodeSpacesChk.checked)
end; // encodeURL

function protoColon():string;
const
  LUT: array [boolean] of string = ('http://','https://');
begin
result:=LUT[mainFrm.httpsUrlsChk.checked];
end; // protoColon

function banAddress(ip:string):boolean;
resourcestring
  MSG_BAN_MASK = 'Ban IP mask';
  MSG_IP_MASK_LONG = 'You can edit the address.'#13'Masks and ranges are allowed.';
  MSG_KICK_ADDR = 'There are %d open connections from this address.'#13'Do you want to kick them all now?';
  MSG_BAN_ALREADY = 'This IP address is already banned';
  MSG_BAN_CMT = 'Ban comment';
  MSG_BAN_CMT_LONG = 'A comment for this ban...';
var
  comm: string;
  l: Integer;
begin
result:=FALSE;
mainfrm.setFocus();
if not InputQuery(MSG_BAN_MASK,MSG_IP_MASK_LONG,ip) then exit;

for var i: Integer :=0 to length(banlist)-1 do
  if banlist[i].ip = ip then
    begin
    msgDlg(MSG_BAN_ALREADY, MB_ICONWARNING);
    exit;
    end;

comm:='';
if not InputQuery(MSG_BAN_CMT,MSG_BAN_CMT_LONG,comm) then exit;

l:=length(banlist);
setlength(banlist, l+1);
banlist[l].ip:=ip;
banlist[l].comment:=comm;

l:=countConnectionsByIP(ip);
if (l > 0) and (msgDlg(format(MSG_KICK_ADDR,[l]), MB_ICONQUESTION+MB_YESNO) = IDYES) then
  kickByIP(ip);
result:=TRUE;
end; // banAddress

function prog(p: real): Boolean;
begin
   Result := True;
   if not progFrm.visible then
     Exit;
   progFrm.progress := p;
   application.processMessages();
   Result := not progFrm.cancelRequested;
end;

function shouldRecur(data:TconnData):boolean;
begin
result:=mainFrm.recursiveListingChk.checked
        and data.allowRecur
end; // shouldRecur

function TMainFrm.fileExistsByURL(const url: string): boolean;
begin
  Result := fileSrv.fileExistsByURL(url, getLP);
end; // fileExistsByURL

function Tmainfrm.getLP: TLoadPrefs;
begin
  Result := [];
  if supportDescriptionChk.checked then
    Include(Result, lpION);
  if listfileswithsystemattributeChk.checked then
    Include(Result, lpSysAttr);
  if listfileswithHiddenAttributeChk.checked then
    Include(Result, lpHdnAttr);
  if loadSingleCommentsChk.checked then
    Include(Result, lpSnglCmnt);
  if fingerprintsChk.checked  then
    Include(Result, lpFingerPrints);
  if recursiveListingChk.checked then
    Include(Result, lpRecurListing);

  if hideProtectedItemsChk.Checked then
    Include(Result, lpHideProt);

  if oemForIonChk.checked then
    Include(Result, lpOEMForION);
end;

function Tmainfrm.getSP: TShowPrefs;
begin
  Result := [];

  if useSystemIconsChk.checked then
    Include(Result, spUseSysIcons);
  if True then
    Include(Result, spNoWaitSysIcons);
  if httpsUrlsChk.checked then
    Include(Result, spHttpsUrls);
  if foldersBeforeChk.checked then
    Include(Result, spFoldersBefore);
  if linksBeforeChk.checked then
    Include(Result, spLinksBefore);

  if noPortInUrlChk.checked then
    Include(Result, spNoPortInUrl);
  if encodenonasciiChk.checked then
    Include(Result, spEncodeNonascii);
  if encodeSpacesChk.checked then
    Include(Result, spEncodeSpaces);
  if compressedbrowsingChk.checked then
    Include(Result, spCompressed);
end;

procedure Tmainfrm.onAddingItemOnServer;
resourcestring
  MSG_ADDING = 'Adding item #%d';
begin
  if addingItemsCounter >= 0 then // counter enabled
    begin
    inc(addingItemsCounter);
    if addingItemsCounter and 15 = 0 then // step 16
      begin
      application.ProcessMessages();
      setStatusBarText(format(MSG_ADDING, [addingItemsCounter]));
      end;
    end;
end;

function Tmainfrm.getFolderPage(folder:Tfile; cd:TconnData; otpl: TTpl):string;
begin
  Result := fileSrv.getAFolderPage(folder, cd, otpl, getLP, getSP, pwdInPagesChk.Checked, macrosLogChk.Checked)
end;

procedure setDefaultIP(v: string);
var
  old: string;
begin
  old := defaultIP;
  if v > '' then
    defaultIP:=v
   else if externalIP > '' then
    defaultIP:=externalIP
   else
    defaultIP:=getIP();
  if mainfrm = NIL then
    exit;
  mainfrm.updateUrlBox();
  if old = defaultIP then
    exit;
  try
    v:=clipboard.AsText;
    if pos(old, v) = 0 then
      exit;
   except
  end;
  setClip( xtpl(v, [old, defaultIP]) );
end; // setDefaultIP

procedure TmainFrm.findExtOnStartupChkClick(Sender: TObject);
resourcestring
  MSG = 'This option is NOT compatible with "dynamic dns updater".'
    +#13'Continue?';
begin
with sender as TMenuItem do
  if dyndns.active and (dyndns.url > '') and checked then
    checked:= msgDlg(MSG, MB_ICONWARNING+MB_YESNO) = MRYES;
end;

function notModified(conn: ThttpConn; f: Tfile): boolean; overload;
begin
  result := notModified(conn, f.resource)
end;

function Tmainfrm.sendPic(cd: TconnData; idx: integer=-1): boolean;
var
  s, url: string;
  special: (no, graph);
begin
  url := decodeURL(cd.conn.request.url);
  result := FALSE;
  special := no;
  if idx < 0 then
    begin
      s := url;
      if not ansiStartsText('/~img', s) then
        exit;
      delete(s,1,5);
      // converts special symbols
      if ansiStartsText('_graph', s) then
        special:=graph else
      if ansiStartsText('_link', s) then
        idx:=ICON_LINK else
      if ansiStartsText('_file', s) then
        idx := ICON_FILE else
      if ansiStartsText('_folder', s) then
        idx := ICON_FOLDER else
      if ansiStartsText('_lock', s) then
        idx := ICON_LOCK
       else
        try
          idx := strToInt(s)
         except
          exit
        end;
    end;

if (special = no) and ((idx < 0) or (idx >= IconsDM.images.count)) then exit;

case special of
  no: cd.conn.reply.body := pic2str(idx, 16);
  graph: cd.conn.reply.body := getGraphPic(cd, graphBox.Width, graphBox.Height);
  end;

result:=TRUE;
{**
// browser caching support
if idx < startingImagesCount then
  s:=intToStr(idx)+':'+etags.values['exe']
else
  s:=etags.values['icon.'+intToStr(idx)];
if notModified(cd.conn, s, '') then
  exit;
}
cd.conn.reply.mode:=HRM_REPLY;
{$IFDEF HFS_GIF_IMAGES}
cd.conn.reply.contentType:='image/gif';
{$ELSE ~HFS_GIF_IMAGES}
cd.conn.reply.contentType:='image/png';
{$ENDIF HFS_GIF_IMAGES}
cd.conn.reply.bodyMode := RBM_RAW;
cd.downloadingWhat:=DW_ICON;
cd.lastFN:=copy(url,2,1000);
end; // sendPic

procedure setupDownloadIcon(data: TconnData);

  procedure painticon();
  var
    bmp: Tbitmap;
    s: string;
    perc: real;
  begin
  perc:=safeDiv(0.0+data.conn.bytesSentLastItem, data.conn.bytesPartial);
  s:=intToStr( trunc(perc*100) )+'%';
  bmp:=getBaseTrayIcon(perc, TRAY_ICON_SIZE);
  drawTrayIconNumber(bmp.canvas, s, TRAY_ICON_SIZE);
//  data.tray_ico.Handle:=bmpToHico(bmp);
  data.tray_ico.Handle := bmp2ico32(bmp);
  bmp.free;
  data.tray.setIcon(data.tray_ico);
  data.tray.setTip(
    if_( (data.conn.reply.bodyMode=RBM_RAW)or(data.conn.reply.bodyMode=RBM_TEXT),
         decodeURL(data.conn.request.url), data.lastFN )
    +trayNL+format('%.1f KB/s', [data.averageSpeed/1000])
    +trayNL+dotted(data.conn.bytesSentLastItem)+' bytes sent'
    +trayNL+data.address
  );
  data.tray.show();
  end; // paintIcon

begin
if (data = NIL) or (data.conn = NIL) then exit;
if assigned(data.tray)
and ((data.conn.state <> HCS_REPLYING_BODY) or
  (data.conn.bytesSentLastItem = data.conn.bytesPartial)) then
  begin
  data.tray.hide();
  freeAndNIL(data.tray);
  data.tray_ico.free;
  exit;
  end;
if not isSendingFile(data) then exit;

if not data.countAsDownload then exit;

if data.tray = NIL then
  begin
  data.tray:= TmyTrayicon.create(mainfrm.handle);
  data.tray.UsrData := data;
  data.tray_ico := Ticon.create();
  data.tray.onEvent := mainfrm.downloadTrayEvent;
  end;
if mainfrm.trayfordownloadChk.checked and isSendingFile(data) then
  paintIcon()
else data.tray.hide();
end; // setupDownloadIcon

function getDynLogFilename(cd:TconnDataMain):string; overload;
var
  d, m, y, w: word;
  u: string;
begin
decodeDateFully(now(), y,m,d,w);
if cd = NIL then u:=''
else u:=nonEmptyConcat('(', cd.usr, ')');
result:=xtpl(logFile.filename, [
  '%d%', int0(d,2),
  '%m%', int0(m,2),
  '%y%', int0(y,4),
  '%dow%', int0(w-1,2),
  '%w%', int0(weekOf(now()),2),
  '%user%', u
]);
end; // getDynLogFilename

procedure applyISOdateFormat();
begin
  if mainfrm.useISOdateChk.checked then
    FormatSettings.ShortDateFormat:='yyyy-mm-dd'
   else
     FormatSettings.ShortDateFormat:=GetLocaleStr(LOCALE_USER_DEFAULT, LOCALE_SSHORTDATE,'');
end;

procedure Tmainfrm.add2log(lines: String; cd: TconnDataMain=NIL; clr: Tcolor= Graphics.clDefault);
var
  s, ts, first, rest, addr: string;
begin
  if not logOnVideoChk.checked
   and ((logFile.filename = '') or (logFile.apacheFormat > '')) then
    exit;

  if clr = Graphics.clDefault then
    clr := clWindowText;

  if logDateChk.checked then
    begin
     applyISOdateFormat(); // this call shouldn't be necessary here, but it's a workaround to this bug www.rejetto.com/forum/?topic=5739
     if logTimeChk.checked then
       ts := datetimeToStr(now())
      else
       ts := dateToStr(now())
    end
   else
    if logTimeChk.checked then
      ts := timeToStr(now())
     else
      ts := '';

  first := chopLine(lines);
  if lines = '' then
    rest := ''
   else
    rest := reReplace(lines, '^', '> ')+CRLF;

  if assigned(cd) and assigned(cd.conn) then
    addr := nonEmptyConcat('', cd.usr, '@')
      +ifThen(cd.conn.v6, '['+cd.address+']', cd.address)
      +':'+cd.conn.port
      +nonEmptyConcat(' {', localDNSget(cd.address), '}')
   else
    addr := '';

  if (logFile.filename > '') and (logFile.apacheFormat = '') then
   begin
    s := ts;
    if (cd = NIL) or (cd.conn = nil) then
      s := s+TAB+''+TAB+''+TAB+''+TAB+''
     else
      s := s+TAB+cd.usr+TAB+cd.address+TAB+cd.conn.port+TAB+localDNSget(cd.address);
    s := s+TAB+first;

    if tabOnLogFileChk.checked then
      s := s+stripChars(reReplace(lines, '^', TAB),[#13,#10])
     else
      s := s+CRLF+rest;

    includeTrailingString(s,CRLF);
    appendFileU(getDynLogFilename(cd), s);
   end;

  if not logOnVideoChk.checked then
    exit;

  logbox.selstart := length(logbox.Text);
  logBox.SelAttributes.name := logFontName;
  if logFontSize > 0 then
    logBox.SelAttributes.size := logFontSize;
  logBox.SelAttributes.Color := clRed;
  logBox.SelText := ts+'  ';
  if addr > '' then
  begin
    logBox.SelAttributes.Color:=ADDRESS_COLOR;
    logBox.SelText:=addr+'  ';
  end;
  logBox.SelAttributes.color:=clr;
  logBox.SelText:=first+CRLF;
  logBox.selAttributes.color:=clBlue;
  logBox.SelText:=rest;

  if (logMaxLines = 0) or (logBox.Lines.Count <= logMaxLines) then
    exit;
  // found no better way to remove multiple lines with a single move
  logbox.LockDrawing;
  //logBox.perform(WM_SETREDRAW, 0, 0);
  try
    logBox.SelStart := 0;
    logBox.SelLength := logBox.perform(EM_LINEINDEX, logBox.lines.count-round(logMaxLines*0.9), 0);;
    logBox.selText := '';
    logbox.selstart := length(logbox.Text);
   finally
  //  logBox.perform(WM_SETREDRAW, 1, 0);
  //  logBox.invalidate();
    logBox.UnlockDrawing;
  end;
end; // add2log

function isBanned(address:string; out comment:string):boolean; overload;
begin
result:=TRUE;
for var i: Integer :=0 to length(banlist)-1 do
  if addressMatch(banlist[i].ip, address) then
    begin
    comment:=banlist[i].comment;
    exit;
    end;
result:=FALSE;
end; // isBanned

function isBanned(cd:TconnData):boolean; overload;
begin result:=assigned(cd) and isBanned(cd.address, cd.banReason) end;

procedure kickBannedOnes();
var
  i: integer;
  d: TconnData;
begin
i:=0;
while i < srv.conns.count do
  begin
  d:=conn2data(i);
  if isBanned(d) then
    d.disconnect(first(d.disconnectReason, 'kick banned'));
  inc(i);
  end;
end; // kickBannedOnes

procedure sayPortBusy(port:string);
resourcestring
  MSG_CANT_OPEN_PORT = 'Cannot open port.';
  MSG_PORT_USED_BY = 'It is already used by %s';
  MSG_PORT_BLOCKED = 'Something is blocking, maybe your system firewall.';
var
  fn: string;
  msg: String;
begin
try fn:=extractFileName(pid2file(port2pid(port)));
except fn:='' end;
  msg := MSG_CANT_OPEN_PORT+#13;
  if fn>'' then
    msg := msg + format(MSG_PORT_USED_BY,[fn])
   else
    msg := msg + MSG_PORT_BLOCKED;
msgDlg(msg, MB_ICONERROR);
end; // sayPortBusy

procedure toggleServer();
resourcestring
  MSG_KICK_ALL = 'There are %d connections open.'#13'Do you want to close them now?';
begin
if srv.active then stopServer()
else
  if not startServer() then
    sayPortBusy(srv.port);
if (srv.conns.count = 0) or srv.active then exit;
if msgDLg(format(MSG_KICK_ALL,[srv.conns.count]), MB_ICONQUESTION+MB_YESNO) = IDYES then
  kickByIP('*');
end; // toggleServer

procedure updatePortBtn();
begin
if assigned(srv) then
  mainfrm.portBtn.Caption:=format(S_PORT_LABEL, [
    if_(srv.active, srv.port, first(port,S_PORT_ANY))]);
end; // updatePortBtn

procedure removeFilesFromComments(files: TStringDynArray);
var
  fn, lastPath, path: string;
  trancheStart, trancheEnd: integer; // the tranche is a window within 'selection' of items sharing the same path
  ss: TstringList;

  procedure doTheTranche();
  var
    b: integer;
    fn, s: string;
    sa: RawByteString;
    anyChange: boolean;
  begin
  // leave only the files' name
  for var i: Integer :=trancheStart to trancheEnd do
    files[i]:=copy(files[i],length(lastPath)+1,MAXINT);
  // comments file
  try
    fn:=lastPath+COMMENTS_FILE;
    ss.loadFromFile(fn, TEncoding.UTF8);
    anyChange:=FALSE;
    for var i: Integer :=trancheStart to trancheEnd do
      begin
      b:=ss.indexOfName(files[i]);
      if b < 0 then continue;
      ss.delete(b);
      anyChange:=TRUE;
      end;
    if anyChange then
      if ss.count = 0 then
        deleteFile(fn)
      else
        ss.saveToFile(fn, TEncoding.UTF8);
  except end;
  // descript.ion
  if not mainfrm.supportDescriptionChk.checked then exit;
  try
    fn:=path+DESCRIPT_ION;
    sa:=loadFile(fn);
    if sa = '' then exit;
    if mainfrm.oemForIonChk.checked then
      begin
        SetLength(s, Length(sa));
        OEMToCharBuff(@sa[1], @s[1], length(s));
      end
     else
      s := UnUTF(sa);
    anyChange:=FALSE;
    for var i: Integer :=trancheStart to trancheEnd do
      begin
      b:=findNameInDescriptionFile(s, files[i]);
      if b = 0 then continue;
      delete(s, b, findEOL(s,b)-b+1);
      anyChange:=TRUE;
      end;
    if anyChange then
      if s='' then
        deleteFile(fn)
      else
        saveTextfile(fn, s);
  except end;
  end; // doTheTranche

begin
// collect files with same path in tranche, then process it
sortArray(files);
trancheStart:=0;
ss:=TstringList.create(); // we'll use this in doTheTranche(), but create the object once, as an optimization
try
  ss.caseSensitive:=FALSE;
  for trancheEnd:=0 to length(files)-1 do
    begin
    fn:=files[trancheEnd];
    path:=getTill(lastDelimiter('\/', fn), fn);
    if trancheEnd = 0 then
      lastPath:=path;
    if path <> lastPath then
      begin
      doTheTranche();
      // init the new tranche
      trancheStart:=trancheEnd+1;
      lastPath:=path;
      end;
    end;
  trancheEnd:=length(files)-1; // after the for-loop, the variable seems to not be reliable
  doTheTranche();
finally ss.free end;
end; // removeFilesFromComments

procedure runTplImport();
var
  f, fld: Tfile;
begin
  f:=Tfile.create(mainFrm.filesBox, tplFilename);
  fld:=Tfile.create(mainFrm.filesBox, extractFilePath(tplFilename));
  try
    runScript(mainFrm.fileSrv, mainFrm.fileSrv.tpl['special:import'], NIL, mainFrm.fileSrv.tpl, f, fld);
   finally
    freeAndNIL(f);
    freeAndNIL(fld);
  end;
end; // runTplImport

// returns true if template was patched
function setTplText(text:string=''):boolean;
resourcestring
  MSG_TPL_INCOMPATIBLE = 'The template you are trying to load is not compatible with current HFS version.'
    +#13'HFS will now use default template.'
    +#13'Ask on the forum if you need further help.';
var
  sec: PtplSection;
begin
result:=FALSE; // mod by mars
//patch290();
if trim(text) = trim(defaultTpl.fullTextS) then
  text:='';
mainFrm.fileSrv.tpl.fullTextS := text;
sec:= mainFrm.fileSrv.tpl.getSection('api level', FALSE);
if (text>'')
and ((sec=NIL) or (strToIntDef(sec.txt.trim,0) < 2)) then
  begin
  mainFrm.fileSrv.tpl.fullText:='';
  tplFilename:='';
  tplImport:=FALSE;
  msgDlg(MSG_TPL_INCOMPATIBLE, MB_ICONERROR);
  end;
tplIsCustomized:= mainFrm.fileSrv.tpl.fullTextS > '';
if boolOnce(tplImport) then
  runTplImport();
end; // setTplText

procedure keepTplUpdated();
begin
if fileExists(tplFilename) then
  begin
  if newMtime(tplFilename, tplLast) then
    if setTplText(UnUTF(loadFile(tplFilename))) then
      saveFile2(tplFilename, mainFrm.fileSrv.tpl.fullText);
  end
else if tplLast <> 0 then
  begin
  tplLast:=0; // we have no modified-time in this case, but this will stop the refresh
  setTplText();
  end;
end; // keepTplUpdated

procedure setNewTplFile(fn:string);
begin
tplFilename:=fn;
tplImport:=TRUE;
tplLast:=0;
end; // setNewTplFile

procedure Tmainfrm.httpEvent(event: ThttpEvent; conn: ThttpConn);
resourcestring
  MSG_LOG_SERVER_START = 'Server start';
  MSG_LOG_SERVER_STOP = 'Server stop';
  MSG_LOG_CONNECTED = 'Connected';
  MSG_LOG_DISC_SRV = 'Disconnected by server';
  MSG_LOG_DISC = 'Disconnected';
  MSG_LOG_GOT = 'Got %d bytes';
  MSG_LOG_BYTES_SENT = '%s bytes sent';
  MSG_LOG_SERVED = 'Served %s';
  MSG_LOG_HEAD = 'Served head';
  MSG_LOG_NOT_MOD = 'Not modified, use cache';
  MSG_LOG_REDIR = 'Redirected to %s';
  MSG_LOG_NOT_SERVED = 'Not served: %d - %s';
  MSG_LOG_UPL = 'Uploading %s';
  MSG_LOG_UPLOADED = 'Fully uploaded %s - %s @ %sB/s';
  MSG_LOG_UPL_FAIL = 'Upload failed %s';
  MSG_LOG_DL = 'Fully downloaded - %s @ %sB/s - %s';
var
  data: TconnData;
  f: Tfile;
  url: string;

  Freq, StartCount, StopCount: Int64;
  TimingSeconds: real;

  procedure switchToDefaultFile();
  var
    default: Tfile;
  begin
  if (f = NIL) or not f.isFolder() then exit;
  default:=f.getDefaultFile();
  if default = NIL then exit;
  freeIfTemp(f);
  f:=default;
  end; // switchToDefaultFile

  function calcAverageSpeed(bytes:int64):integer;
  begin result:=round(safeDiv(bytes, (now()-data.fileXferStart)*SECONDS)) end;

  function runEventScript(const event: String; table: array of String): String; overload;
  var
    md: TmacroData;
    pleaseFree: boolean;
  begin
  result:=trim(eventScripts[event]);
  if result = '' then exit;
  ZeroMemory(@md, sizeOf(md));
  md.cd:=data;
  md.table:=toSA(table);
  md.tpl:=eventScripts;
  addArray(md.table, ['%event%', event]);
  pleaseFree:=FALSE;
  try
    if isReceivingFile(data) then
      begin
      // we must encapsulate it in a Tfile to expose file properties to the script. we don't need to cache the object because we need it only once.

      md.folder:=data.lastFile;
      if assigned(md.folder) then
        md.f := Tfile.createTemp(mainFrm.filesBox, data.uploadDest, md.folder)
       else
        md.f := Tfile.createTemp(mainFrm.filesBox, data.uploadDest)
        ;
      md.f.size := sizeOfFile(data.uploadDest);
      pleaseFree:=TRUE;

      end
    else if assigned(f) then
      md.f:=f
    else if assigned(data) then
      md.f:=data.lastFile;

    if assigned(md.f) and (md.folder = NIL) then
      md.folder:=md.f.parent;

    tryApplyMacrosAndSymbols(fileSrv, result, md);

  finally
    if pleaseFree then
      freeIfTemp(md.f);
    end;
  end; // runEventScript

  function runEventScript(const event:string):string; overload;
  begin result:=runEventScript(event, []) end;

  procedure doLog();
  var
    i: integer;
    s: string;
     function decodedUrl():string;
      begin
      if conn = NIL then
        exit('');
      result:=decodeURL(conn.request.url);
     end;
  begin
  if assigned(data) and data.dontLog and (event <> HE_DISCONNECTED) then exit; // we exit expect for HE_DISCONNECTED because dontLog is always set AFTER connections, so HE_CONNECTED is always logged. The coupled HE_DISCONNECTED should be then logged too.

  if assigned(data) and (data.preReply = PR_BAN)
  and not logBannedChk.checked then exit;

  if not (event in [HE_OPEN, HE_CLOSE, HE_CONNECTED, HE_DISCONNECTED, HE_GOT]) then
    if not logIconsChk.checked and (data.downloadingWhat = DW_ICON)
    or not logBrowsingChk.checked and (data.downloadingWhat = DW_FOLDERPAGE)
    or not logProgressChk.checked and (decodedUrl() = '/~progress') then
      exit;

  if not (event in [HE_OPEN, HE_CLOSE])
  and addressMatch(dontLogAddressMask, data.address) then
    exit;

  case event of
    HE_OPEN: if logServerstartChk.Checked then add2log(MSG_LOG_SERVER_START);
    HE_CLOSE: if logServerstopChk.checked then add2log(MSG_LOG_SERVER_STOP);
    HE_CONNECTED: if logconnectionsChk.Checked then add2log(MSG_LOG_CONNECTED, data);
    HE_DISCONNECTED: if logDisconnectionsChk.checked then
      add2log(if_(conn.disconnectedByServer, MSG_LOG_DISC_SRV,MSG_LOG_DISC)
        +nonEmptyConcat(': ', data.disconnectReason)
        +if_(conn.bytesSent>0, ' - '+format(MSG_LOG_BYTES_SENT, [dotted(conn.bytesSent)])),
      data);
    HE_GOT:
      begin
      i:=conn.bytesGot-data.lastBytesGot;
      if i <= 0 then exit;
      if logBytesreceivedChk.Checked then
        if now()-data.bytesGotGrouping.since <= BYTES_GROUPING_THRESHOLD then
          inc(data.bytesGotGrouping.bytes, i)
        else
          begin
          add2log(format(MSG_LOG_GOT,[i+data.bytesGotGrouping.bytes]), data);
          data.bytesGotGrouping.since:=now();
          data.bytesGotGrouping.bytes:=0;
          end;
      inc(data.lastBytesGot, i);
      end;
    HE_SENT:
      begin
      i:=conn.bytesSent-data.lastBytesSent;
      if i <= 0 then exit;
      if logBytessentChk.checked then
        if now()-data.bytesSentGrouping.since <= BYTES_GROUPING_THRESHOLD then
          inc(data.bytesSentGrouping.bytes, i)
        else
          begin
          add2log(format(MSG_LOG_BYTES_SENT,[dotted(i+data.bytesSentGrouping.bytes)]), data);
          data.bytesSentGrouping.since:=now();
          data.bytesSentGrouping.bytes:=0;
          end;
      inc(data.lastBytesSent, i);
      end;
    HE_REQUESTED:
      if not logOnlyServedChk.checked
      or (conn.reply.mode in [HRM_REPLY, HRM_REPLY_HEADER, HRM_REDIRECT]) then
        begin
        data.logLaterInApache:=TRUE;
        if logRequestsChk.Checked then
          begin
          s:=subStr(conn.getHeader('Range'), 7);
          if s > '' then
            s:=TAB+'['+s+']';
          add2log(format('Requested %s %s%s', [ METHOD2STR[conn.request.method], decodedUrl(), s ]), data);
          end;
        if dumprequestsChk.checked then
          add2log(RawByteString('Request dump')+CRLF+conn.request.full, data);
        end;
    HE_REPLIED:
      if logRepliesChk.checked then
       case conn.reply.mode of
          HRM_REPLY: if not data.fullDLlogged then add2log(format(MSG_LOG_SERVED, [smartSize(conn.bytesSentLastItem)]), data);
          HRM_REPLY_HEADER: add2log(MSG_LOG_HEAD, data);
          HRM_NOT_MODIFIED: add2log(MSG_LOG_NOT_MOD, data);
          HRM_REDIRECT: add2log(format(MSG_LOG_REDIR, [conn.reply.url]), data);
          else if not logOnlyServedChk.checked then
            add2log(format(MSG_LOG_NOT_SERVED, [HRM2CODE[conn.reply.mode], HRM2STR[conn.reply.mode] ])
              +nonEmptyConcat(': ', data.error), data);
          end;
    HE_POST_FILE:
      if logUploadsChk.checked and (data.uploadFailed = '') then
        add2log(format(MSG_LOG_UPL, [data.uploadSrc]), data);
    HE_POST_END_FILE:
      if logUploadsChk.checked then
        if data.uploadFailed = '' then
          add2log(format(MSG_LOG_UPLOADED, [
            data.uploadSrc,
            smartSize(conn.bytesPostedLastItem),
            smartSize(calcAverageSpeed(conn.bytesPostedLastItem)) ]), data)
        else
          add2log(format(MSG_LOG_UPL_FAIL, [data.uploadSrc]), data);
    HE_LAST_BYTE_DONE:
      if logFulldownloadsChk.checked
      and data.countAsDownload
      and (data.downloadingWhat in [DW_FILE, DW_ARCHIVE]) then
        begin
        data.fullDLlogged := TRUE;
        add2log(format(MSG_LOG_DL, [
          smartSize(conn.bytesSentLastItem),
          smartSize(calcAverageSpeed(conn.bytesSentLastItem)),
          decodedUrl()]), data);
        end;
    end;

  { apache format log is only related to http events, that's why it resides
  { inside httpEvent(). moreover, it needs to access to some variables. }
  if (logFile.filename = '') or (logFile.apacheFormat = '')
  or (data = NIL) or not data.logLaterInApache
  or not (event in [HE_LAST_BYTE_DONE, HE_DISCONNECTED]) then exit;

  data.logLaterInApache:=FALSE;
  s:=xtpl(logfile.apacheFormat, [
    '\t', TAB,
    '\r', #13,
    '\n', #10,
    '\"', '"',
    '\\', '\'
  ]);
  s:=reCB('%(!?[0-9,]+)?(\{([^}]+)\})?>?([a-z])', s, apacheLogCb, data);
  appendFileU(getDynLogFilename(data), s+CRLF);
  end; // doLog

  function limitsExceededOnConnection():boolean;
  begin
  if noLimitsFor(data.account) then result:=FALSE
  else
    result:=(maxConnections>0) and (srv.conns.count > maxConnections)
      or (maxConnectionsIP>0)
        and (countConnectionsByIP(data.address) > maxConnectionsIP)
      or (maxIPs>0) and (countIPs() > maxIPs)
  end; // limitsExceededOnConnection

  function limitsExceededOnDownload():boolean;
  var
    was: string;
  begin
    result:=FALSE;
    data.disconnectReason:='';

    if data.conn.ignoreSpeedLimit then exit;

    if (maxContempDLs > 0) and (countDownloads() > maxContempDLs)
    or (maxContempDLsIP > 0) and (countDownloads(data.address) > maxContempDLsIP) then
      data.disconnectReason:=MSG_MAX_SIM_DL
    else if (maxIPsDLing > 0) and (countIPs(TRUE) > maxIPsDLing) then
      data.disconnectReason:=MSG_MAX_SIM_ADDR_DL
    else if preventLeechingChk.checked and (countDownloads(data.address, '', f) > 1) then
      data.disconnectReason:='Leeching';

    was:=data.disconnectReason;
    runEventScript('download');

    result:=data.disconnectReason > '';
    if not result then
      exit;
    data.countAsDownload:=FALSE;
    fileSrv.getPage(if_(was=data.disconnectReason, 'max contemp downloads', 'deny'), data);
  end; // limitsExceededOnDownload

  procedure extractParams();
  const
    MAX = 1000;
  var
    s: string;
    i: integer;
  begin
    s:=url;
    url:=chop('?',s);
    data.urlvars.clear();
    if s > '' then
      begin
        extractStrings(['&'], [], @s[1], data.urlvars);
        for i:=0 to data.urlvars.count-1 do
          data.urlvars[i]:=decodeURL(data.urlvars[i]);
      end;
  end; // extractParams

  procedure closeUploadingFile();
  begin
  if data.f = NIL then exit;
  closeFile(data.f^);
  dispose(data.f);
  data.f:=NIL;
  end; // closeUploadingFile

  // close and eventually delete/rename
  procedure closeUploadingFile_partial();
  begin
  if (data = NIL) or (data.f = NIL) then exit;
  closeUploadingFile();
  if deletePartialUploadsChk.checked then deleteFile(data.uploadDest)
  else if renamePartialUploads = '' then exit;
  if ipos('%name%', renamePartialUploads) = 0 then
    renameFile(data.uploadDest, data.uploadDest+renamePartialUploads)
  else
    renameFile(data.uploadDest,
      extractFilePath(data.uploadDest) + xtpl(renamePartialUploads,['%name%',extractFileName(data.uploadDest)]) );
  end; // closeUploadingFile_partial

  function isDownloadManagerBrowser():boolean;
  begin
  result:=(pos('GetRight',data.agent)>0)
    or (pos('FDM',data.agent)>0)
    or (pos('FlashGet',data.agent)>0)
  end; // isDownloadManagerBrowser

  procedure logUploadFailed();
  begin
  if not logUploadsChk.checked then exit;
  add2log(format(MSG_LOG_UPL_FAIL, [data.uploadSrc])+' : '+data.uploadFailed, data);
  end; // logUploadFile

  function eventToFilename(const event: String; table:array of String): String;
  var
    i: integer;
  begin
  result:=trim(stripChars(runEventScript(event, table), [TAB,#10,#13]));
  // turn illegal chars into underscores
  for i:=1 to length(result) do
    if result[i] in ILLEGAL_FILE_CHARS-[':','\'] then
      result[i]:='_';
  end; // eventToFilename

  procedure getUploadDestinationFileName();
  var
    i: integer;
    fn, ext, s: string;
  begin
  new(data.f);
  fn:=data.uploadSrc;

  data.uploadDest:=f.resource+'\'+fn;
  assignFile(data.f^, data.uploadDest );

  // see if an event script wants to change the name
  s:=eventToFilename('upload name', []);

  if validFilepath(s) then // is it valid anyway?
    begin
    if pos('\', s) = 0 then  // it's just the file name, no path specified: must include the path of the current folder
      s:=f.resource+'\'+s;
    // ok, we'll use this new name
    data.uploadDest:=s;
    fn:=extractFileName(s);
    end;

  if numberFilesOnUploadChk.checked then
    begin
    ext:=extractFileExt(fn);
    setLength(fn, length(fn)-length(ext));
    i:=0;
    while fileExists(data.uploadDest) do
      begin
      inc(i);
      data.uploadDest:=format('%s\%s (%d)%s', [f.resource, fn, i, ext]);
      end;
    end;
  assignFile(data.f^, data.uploadDest);
  end; // getUploadDestinationFileName

  procedure addContentDisposition(fn: String; attach:boolean=TRUE);
  begin
//  conn.addHeader( 'Content-Disposition: '+if_(attach, 'attachment; ')+'filename*=UTF-8''"'+UTF8encode(data.lastFN)+'";');
//  conn.addHeader('Content-Disposition', RawByteString('attachment; filename="')+encodeURL(data.lastFN)+'";');
//  conn.addHeader('Content-Disposition', if_(attach, RawByteString('attachment; ')) + RawByteString('filename*=UTF-8''"')+encodeURL(UTF8encode(fn))+'";');
  conn.setHeaderIfNone(RawByteString('Content-Disposition'), if_(attach, RawByteString('attachment; ')) + RawByteString('filename="')+ encodeURLA(fn)+ RawByteString('";'));
  end;

  function sessionRedirect():boolean;
  var
    s: TSession;
  begin
    if (data.sessionID = '') or (sessions.noSession(data.sessionID)) then
      exit(FALSE);
    s := sessions[data.sessionid];
    if s.redirect = '' then
      exit(FALSE);
    conn.reply.mode := HRM_REDIRECT;
    conn.reply.url := s.redirect;
    s.redirect := ''; // only once
    result := TRUE;
  end; // sessionRedirect

  function sessionSetup():boolean;
  var
//    idx: Integer;
    sid: TSessionId;
    s: Tsession;
  begin
    result:=TRUE;
    if data = NIL then
      Exit;
    data.usr:='';
    data.pwd:='';
//    if sessions.noSession(data.sessionID) then
     begin
      sid := conn.getCookie(SESSION_COOKIE);
      if (sid = '') then
        sid:=data.urlvars.Values[SESSION_COOKIE];
      if (sid = Tsession.sanitizeSID(sid))  and (sid.length >= 10) then
        data.sessionID := sid
       else
        data.sessionID := ''
        ;
      if sessions.noSession(data.sessionID) then
      begin
      data.sessionID:= sessions.initNewSession(conn.address, data.sessionID);
      if sid <> data.sessionID then
        conn.setCookie(SESSION_COOKIE, data.sessionID, ['path','/'], 'HttpOnly'); // the session is site-wide, even if this request was related to a folder
      end;
     end;
    s := sessions[data.sessionID];
    if Assigned(s) then
     begin
        if s.ip <> conn.address then
          begin
          conn.delCookie(SESSION_COOKIE); // legitimate clients that changed address must clear their cookie, or they will be stuck with this invalid session
          conn.reply.mode:=HRM_DENY;
          result:=FALSE;
          exit;
          end;
      s.keepAlive();
     end;
    if (conn.request.user > '') then
      begin
      data.usr:=conn.request.user;
      data.pwd:=conn.request.pwd;
      data.account:=getAccount(data.usr);
      exit;
      end;
    if Assigned(s) then
     begin
      data.account:=getAccount(s.user);
     end;
    if data.account <> NIL then
      begin
       data.usr:=data.account.user;
       data.pwd:=data.account.pwd;
      end;
  end; // sessionSetup

  procedure serveTar();
  var
    tar: TtarStream;
    nofolders, selection, itsAsearch: boolean;

    procedure addFolder(f:Tfile; ignoreConnFilters:boolean=FALSE);
    var
      i, ofs: integer;
      listing: TfileListing;
      fi: Tfile;
      fIsTemp: boolean;
      s: string;
    begin
    if not f.accessFor(data) then exit;
    listing:=TfileListing.create();
    try
      listing.ignoreConnFilter:=ignoreConnFilters;
      listing.timeout:= now()+1/MINUTES;
      listing.fromFolder(getLP, f, data, shouldRecur(data));
      fIsTemp:=f.isTemp();
      ofs:=length(f.resource)-length(f.name)+1;
      for i:=0 to length(listing.dir)-1 do
        begin
        if conn.state = HCS_DISCONNECTED then
          break;

        fi:=listing.dir[i];
        // we archive only files, folders are just part of the path
        if not fi.isFile() then continue;
        if not fi.accessFor(data) then continue;

        // build the full path of this file as it will be in the archive
        if noFolders then
          s:=fi.name
        else if fIsTemp and not (FA_SOLVED_LNK in fi.flags)then
          s:=copy(fi.resource, ofs, MAXINT) // pathTill won't work this case, because f.parent is an ancestor but not necessarily the parent
        else
          s:= fileSrv.pathTill(fi, f.parent); // we want the path to include also f, so stop at f.parent

        tar.addFile(fi.resource, s);
        end
    finally listing.free end;
    end; // addFolder

    procedure addSelection();
    var
      t: string;
      ft: Tfile;
    begin
    selection:=FALSE;
    for var s in data.getFilesSelection() do
        begin
        selection:=TRUE;
        if dirCrossing(s) then 
          continue;
        ft := fileSrv.findFilebyURL(s, getLP, f);
        if ft = NIL then 
          continue;
        try
          if not ft.accessFor(data) then
            continue;
          // case folder
          if ft.isFolder() then
            begin
            addFolder(ft, TRUE);
            continue;
            end;
          // case file
          if not fileExists(ft.resource) then
            continue;
          if noFolders then
            t:=substr(s, lastDelimiter('\/', s)+1)
          else
            t:=s;
          tar.addFile(ft.resource, t);
        finally freeIfTemp(ft) end;
        end;
    end; // addSelection

  begin
  if not f.hasRecursive(FA_ARCHIVABLE) then
    begin
    fileSrv.getPage('deny', data);
    exit;
    end;
  data.downloadingWhat := DW_ARCHIVE;
  data.countAsDownload := TRUE;
  if limitsExceededOnDownload() then
    exit;

  // this will let you get all files as flatly arranged in the root of the archive, without folders
  noFolders:=not stringExists(data.postVars.values['nofolders'], ['','0','false']);
  itsAsearch:=data.urlvars.values['search'] > '';

  tar := TtarStream.create(); // this is freed by ThttpSrv
  try
    tar.fileNamesOEM := oemTarChk.checked;
    addSelection();
    if not selection then
      addFolder(f);

    if tar.count = 0 then
      begin
      tar.free;
      data.disconnectReason:='There is no file you are allowed to download';
      fileSrv.getPage('deny', data, f);
      exit;
      end;
    data.fileXferStart:=now();
    conn.reply.mode:=HRM_REPLY;
    conn.reply.contentType:=DEFAULT_MIME;
    conn.reply.bodyMode:=RBM_STREAM;
    conn.reply.bodyStream:=tar;

    if f.name = '' then exit; // can this really happen?
    data.lastFN:=if_(f.name='/', 'home', f.name)
      +'.'+if_(selection, 'selection', if_(itsAsearch, 'search', 'folder'))
      +'.tar';
    data.lastFN:=first(eventToFilename('archive name', [
      '%archive-name%', data.lastFN,
      '%mode%', if_(selection, 'selection','folder'),
      '%archive-size%', intToStr(tar.size)
    ]), data.lastFN);
    if not noContentdispositionChk.checked then
      addContentDisposition(data.lastFN);
  except tar.free end;
  end; // serveTar

  procedure checkCurrentAddress();
  begin
  if selftesting then exit;
  if limitsExceededOnConnection() then
    data.preReply:=PR_OVERLOAD;
  if isBanned(data)  then
    begin
    data.disconnectReason:='banned';
    data.preReply:=PR_BAN;
    if noReplyBan then conn.reply.mode:=HRM_CLOSE;
    end;
  end; // checkCurrentAddress

  procedure handleRequest();
  var
    dlForbiddenForWholeFolder, specialGrant: boolean;
    mode, urlCmd: string;
    acc: Paccount;

    function accessGranted(forceFile:Tfile=NIL):boolean;
    resourcestring
      MSG_LOGIN_FAILED = 'Login failed';
    begin
    result:=FALSE;
    if assigned(forceFile) then
      f:=forceFile;
    if f = NIL then
      exit;
    if f.isFile() and (dlForbiddenForWholeFolder or f.isDLforbidden()) then
      begin
      fileSrv.getPage('deny', data);
      exit;
      end;
    result:=f.accessFor(data);
    // sections are accessible. You can implement protection in place, if needed.
    if not result  and (f = fileSrv.rootFile)
    and ((mode='section') or startsStr('~', urlCmd) and fileSrv.tpl.sectionExist(copy(urlCmd,2,MAXINT))) then
      begin
      result:=TRUE;
      specialGrant:=TRUE;
      end;
    if result then
      exit;
    if f.isFolder() and sessionRedirect() then // forbidden folder, but we were asked to go elsewhere
      exit;
    conn.reply.realm:=f.getShownRealm();
    runEventScript('unauthorized');
    fileSrv.getPage('login', data, f);
    // log anyone trying to guess the password
    if (forceFile = NIL) and stringExists(data.usr, getAccountList(TRUE, FALSE))
    and logOtherEventsChk.checked then
      add2log(MSG_LOGIN_FAILED, data);
    end; // accessGranted

    function isAllowedReferer():boolean;
    var
      r: string;
    begin
    result:=TRUE;
    if allowedReferer = '' then exit;
    r:=hostFromURL(conn.getHeader('Referer'));
    if (r = '') or (r = data.getSafeHost(data)) then exit;
    result:=fileMatch(allowedReferer, r);
    end; // isAllowedReferer

    procedure replyWithString(s:string);
    var
      a: String;
    begin
    if (data.disconnectReason > '') and not data.disconnectAfterReply then
      begin
      fileSrv.getPage('deny', data);
      exit;
      end;
    
    if conn.reply.contentType = '' then
      conn.reply.contentType:=if_(trim(getTill('<', s))='', RawByteString('text/html'), RawByteString('text/plain'));
    a := conn.getHeader('Accept-Charset');
    if (a <> '') and ( (ipos('utf-8', a) = 0) and (pos('*', a) = 0)) then
      conn.reply.body := UnicodeToAnsi(s, 28591) // ISO 8859-1 Latin 1; Western European (ISO)
     else
      conn.reply.bodyU := s;

    conn.reply.mode:=HRM_REPLY;
    conn.reply.bodyMode := RBM_TEXT;
    fileSrv.compressReply(data);
    end; // replyWithString

    procedure replyWithStringB(const s: RawByteString);
    begin
    if (data.disconnectReason > '') and not data.disconnectAfterReply then
      begin
      fileSrv.getPage('deny', data);
      exit;
      end;

    if conn.reply.contentType = '' then
      conn.reply.contentType:=if_(trim(getTill(RawByteString('<'), s))='', RawByteString('text/html'), RawByteString('text/plain'));
    conn.reply.mode:=HRM_REPLY;
    conn.reply.bodyMode := RBM_RAW;
    conn.reply.body := s;
    fileSrv.compressReply(data);
    end; // replyWithStringB

    procedure replyWithRes(const res: String; contType: RawByteString);
    var
      s: RawByteString;
      isGZ: Boolean;
    begin
      if (data.disconnectReason > '') and not data.disconnectAfterReply then
        begin
        fileSrv.getPage('deny', data);
        exit;
        end;

        s := getRes(pchar(res), 'ZTEXT');
        isGZ := s <> '';
        if not isGZ then
          s := getRes(pchar(res));
      if contType <> '' then
        conn.reply.contentType := contType;
      if conn.reply.contentType = '' then
        conn.reply.contentType:=if_(trim(getTill(RawByteString('<'), s))='', RawByteString('text/html'), RawByteString('text/plain'));
      conn.reply.mode:=HRM_REPLY;
      conn.reply.bodyMode := RBM_RAW;
      conn.reply.body := s;
      conn.reply.IsGZiped := isGZ;
      fileSrv.compressReply(data);
    end; // replyWithRes

    procedure deletion();
    var
      asUrl, s: string;
      doneRes, done, errors: TStringDynArray;
    begin
    if (conn.request.method <> HM_POST)
    or (data.postVars.values['action'] <> 'delete')
    or not accountAllowed(FA_DELETE, data, f) then exit;

    doneRes:=NIL;
    errors:=NIL;
    done:=NIL;
    for asUrl in data.getFilesSelection() do

      begin
        s:=uri2disk(asUrl, f);
        if (s = '') or not fileOrDirExists(s) then  // ignore
          continue;
        runEventScript('file deleting', ['%item-deleting%', s]);
        moveToBin(toSA([s, s+'.md5', s+COMMENT_FILE_EXT]) , TRUE);
        if fileOrDirExists(s) then
          begin
          addString(asUrl, errors);
          continue; // this was not deleted. permissions problem?
          end;

        addString(s, doneRes);
        addString(asUrl, done);
        runEventScript('file deleted', ['%item-deleted%', s]);
      end;

    removeFilesFromComments(doneRes);

    if logDeletionsChk.checked and assigned(done) then
      add2log('Deleted files in '+url+CRLF+join(CRLF, done), data);
    if logDeletionsChk.checked and assigned(errors) then
      add2log('Failed deletion in '+url+CRLF+join(CRLF, errors), data);
    end; // deletion

    function getAccountRedirect(acc:Paccount=NIL):string;
    begin
    result:='';
    if acc = NIL then
      acc:=data.account;
    acc:=accountRecursion(acc, ARSC_REDIR);
    if acc = NIL then exit;
    result:=acc.redir;
    if (result = '') or ansiContainsStr(result, '://') then exit;
    // if it's not a complete url, it may require some fixing
    if not ansiStartsStr('/', result) then result:='/'+result;
    result:=xtpl(result,['\','/']);
    end; // getAccountRedirect

    function addNewAddress():boolean;
    begin
    result:=ipsEverConnected.indexOf(data.address) < 0;
    if not result then exit;
    ipsEverConnected.add(data.address);
    end; // addNewAddress

    // parameters: u(username), e(?expiration_UTC), s2(sha256(rest+pwd))
    function urlAuth():string;
    var
      s, sign: string;
      ss: Tsession;
    begin
    result:='';
    if mode <> 'auth' then
      exit;
    acc:=getAccount(data.urlVars.values['u']);
    if acc = NIL then
      exit('username not found');
    sign:=conn.request.url;
    chop('?',sign);
    s:=chop('&s2=',sign);
    if strSHA256(s+acc.pwd)<>sign then
      exit('bad sign');
    ss := sessions[data.sessionID];
    if Assigned(ss) then
      begin
        try ss.setTTL(TTimeZone.Local.ToLocalTime(StrToFloat(data.urlvars.Values['e'])) - now() )
        except end;

        if ss.ttl < 0 then
          exit('expired');
        ss.user:=acc.user;
        ss.redirect:='.';
      end;
    data.account:=acc;
    data.usr:=acc.user;
    data.pwd:=acc.pwd;
    runEventScript('login')
    end; //urlAuth

    function thumb():Boolean;
    var
      b: rawbytestring;
      s, e: integer;
    begin
      if mode <> 'thumb' then
        exit(FALSE);
      result := TRUE;
      b := loadFile(f.resource, 0, 96*KILO);
      s := pos(rawbytestring(#$FF#$D8#$FF), b, 2);
      if s > 0 then
        e := pos(rawbytestring(#$FF#$D9), b, s)
       else
        e := 0;
      if (s=0) or (e=0) then
        begin
          data.conn.reply.mode := HRM_NOT_FOUND;
          exit;
        end;
      conn.reply.contentType:='image/jpeg';
      conn.reply.mode := HRM_REPLY;
      conn.reply.bodyMode := RBM_RAW;
      conn.reply.Body := Copy(b, s, e-s+2);
    end;

    function sendIcon():Boolean;
    var
      i: Integer;
    begin
      if mode <> 'icon' then
        exit(FALSE);
      result := TRUE;
      i := -1;
      if ((useSystemIconsChk.checked) or (f.icon >= 0)) then
        i := f.getSystemIcon;
      if i >= 0 then
        begin
//          conn.reply.mode := HRM_MOVED;
          conn.reply.mode := HRM_REDIRECT;
          conn.reply.url := '/~img' + IntToStr(i);
          data.dontLog := True;
        end
       else
        begin
          data.conn.reply.mode := HRM_NOT_FOUND;
          exit;
        end;
{
      conn.reply.contentType:='image/jpeg';
      conn.reply.mode := HRM_REPLY;
      conn.reply.bodyMode := RBM_RAW;
      conn.reply.Body := Copy(b, s, e-s+2);
}
    end;

  var
    b: boolean;
    s: string;
//    i: integer;
    section: PtplSection;
  begin
  // eventually override the address
  if addressmatch(forwardedMask, conn.address) then
    begin
    data.address:=getTill(':', getTill(',', conn.getHeader('x-forwarded-for')));
    if not checkAddressSyntax(data.address, false) then
      data.address:=conn.address;
    end;

  checkCurrentAddress();

  // update list
  if (data.preReply = PR_NONE)
  and addNewAddress()
  and ipsEverFrm.visible then
    ipsEverFrm.refreshData();

  data.requestTime:=now();
  data.downloadingWhat:=DW_UNK;
  data.fullDLlogged:=FALSE;
  data.countAsDownload:=FALSE;
  conn.reply.contentType:='';
  specialGrant:=FALSE;

  data.lastFile:=NIL; // auto-freeing

  with objByIp(data.address) do
    begin
    if speedLimitIP < 0 then limiter.maxSpeed:=MAXINT
    else limiter.maxSpeed:=round(speedLimitIP*1000);
    if conn.limiters.indexOf(limiter) < 0 then
      conn.limiters.add(limiter);
    end;

  conn.addHeader('Accept-Ranges', 'bytes');
  if sendHFSidentifierChk.checked then
    conn.addHeader('Server', 'HFS '+ srvConst.VERSION);

  case data.preReply of
    PR_OVERLOAD:
      begin
      data.disconnectReason:='limits exceeded';
      fileSrv.getPage('overload', data);
      end;
    PR_BAN:
      begin
      fileSrv.getPage('ban', data);
      conn.reply.reason:= RawByteString('Banned: ')+ StrToUTF8(data.banReason);
      end;
    end;

  runEventScript('pre-filter-request');
  if conn.disconnectedByServer then
    exit;
  if data.disconnectReason > '' then
    begin
    fileSrv.getPage('deny', data);
    exit;
    end;

  if (length(conn.request.user) > 100) or anycharIn('/\:?*<>|', conn.request.user) then
    begin
    conn.reply.mode:=HRM_BAD_REQUEST;
    exit;
    end;

  if not (conn.request.method in [HM_GET,HM_HEAD,HM_POST]) then
    begin
    conn.reply.mode:=HRM_METHOD_NOT_ALLOWED;
    exit;
    end;
  inc(hitsLogged);

  if data.preReply <> PR_NONE then
    exit;

  url := conn.request.url;
  extractParams();
  url := decodeURL(url, True);
  mode := data.urlvars.values['mode'];

  data.lastFN:=extractFileName( xtpl(url,['/','\']) );
  data.agent:=getAgentID(conn);

  if selfTesting and (url = 'test') then
    begin
    replyWithString('HFS OK');
    exit;
    end;

  if not sessionSetup() then
    exit;
  if mode = 'logout' then
    begin
    data.logout();
    replyWithString('ok');
    exit;
    end;
  if mode = 'login' then
    begin
    acc:=getAccount(data.postVars.values['user']);
    if acc = NIL then
      s:='bad password' // Should be the same error message as if bad password
    else
      if data.passwordValidation(acc.pwd) then
        begin
        s:='ok';
        sessions[data.sessionID].user:=acc.user;
        sessions[data.sessionID].redirect:=getAccountRedirect(acc);
        end
      else
        begin
        s:='bad password'; //TODO shouldn't this change http code?
        end;

    if s='ok' then
      runEventScript('login')
    else
      runEventScript('unauthorized');
    replyWithString(s);
    exit;
    end;
  s:=urlAuth();
  if s > '' then
    begin
    runEventScript('unauthorized');
    conn.reply.mode := HRM_DENY;
    replyWithString(s);
    exit;
    end;

  conn.ignoreSpeedLimit := noLimitsFor(data.account);

  // all URIs must begin with /
  if (url = '') or (url[1] <> '/') then
    begin
    conn.reply.mode := HRM_BAD_REQUEST;
    exit;
    end;

  runEventScript('request');
  if data.disconnectReason > '' then
    begin
    fileSrv.getPage('deny', data);
    exit;
    end;
  if conn.reply.mode = HRM_REDIRECT then
    exit;

  lastActivityTime:=now();
  if conn.request.method = HM_HEAD then
    conn.reply.mode:=HRM_REPLY_HEADER
  else
    conn.reply.mode:=HRM_REPLY;

  if ansiStartsStr('/~img', url) then
    begin
    if not sendPic(data) then
      fileSrv.getPage('not found', data);
    exit;
    end;
  if mode = 'jquery' then
    begin
      if notModified(conn,'jquery'+FloatToStr(uptime), '') then
        exit;
      replyWithRes('jquery', 'text/javascript');
      exit;
    end;

  // forbid using invalid credentials
  if not freeLoginChk.checked and not specialGrant then
    if (data.usr>'')
    and ((data.account=NIL) or (data.account.pwd <> data.pwd))
    and not usersInVFS.match(data.usr, data.pwd) then
      begin
      data.acceptedCredentials:=FALSE;
      runEventScript('unauthorized');
      fileSrv.getPage('unauth', data);
      conn.reply.realm:='Invalid login';
      exit;
      end
    else
      data.acceptedCredentials:=TRUE;

  f := fileSrv.findFileByURL(url, getLP);
  urlCmd:=''; // urlcmd is only if the file doesn't exist
  if f = NIL then
    begin
    // maybe the file doesn't exist because the URL has a final command in it
    // move last url part from 'url' into 'urlCmd'
    urlCmd:=url;
    url:=chop(lastDelimiter('/', urlCmd)+1, 0, urlCmd);
    // we know an urlCmd must begin with ~
    // favicon is handled as an urlCmd: we provide HFS icon.
    // a non-existent ~file will be detected a hundred lines below.
    if ansiStartsStr('~', urlCmd) or (urlCmd = 'favicon.ico') then
      f := fileSrv.findFileByURL(url, getLP);
    end;
  if f = NIL then
    begin
    if sameText(url, '/robots.txt') and stopSpidersChk.checked then
      replyWithStringB('User-agent: *'+CRLF+'Disallow: /')
     else
      fileSrv.getPage('not found', data);
    exit;
    end;
  if f.isFolder() and not ansiEndsStr('/',url) then
    begin
    conn.reply.mode := HRM_MOVED;
    conn.reply.url:= fileSrv.url(f); // we use f.url() instead of just appending a "/" to url because of problems with non-ansi chars http://www.rejetto.com/forum/?topic=7837
    exit;
    end;
  if f.isFolder() and (urlCmd = '') and (mode='') then
    switchToDefaultFile();
  if enableNoDefaultChk.checked and (urlCmd = '~nodefault') then
    urlCmd:='';

  if f.isRealFolder() and not sysutils.directoryExists(f.resource)
  or f.isFile() and not fileExists(f.resource) then
    begin
    fileSrv.getPage('not found', data);
    exit;
    end;
  dlForbiddenForWholeFolder:=f.isDLforbidden();

  if not accessGranted() then
    exit;

  if urlCmd = 'favicon.ico' then
    begin
    sendPic(data, 23);
    exit;
    end;

  b:=urlCmd = '~upload+progress';
  if (b or (urlCmd = '~upload') or (urlCmd = '~upload-no-progress')) then
    begin
    if not f.isRealFolder() then
      fileSrv.getPage('deny', data)
    else if accountAllowed(FA_UPLOAD, data, f) then
      fileSrv.getPage( if_(b,'upload+progress','upload'), data, f)
    else
      begin
      fileSrv.getPage('unauth', data);
      runEventScript('unauthorized');
      end;
    if b then  // fix for IE6
      begin
      data.disconnectAfterReply:=TRUE;
      data.disconnectReason:='IE6 workaround';
      end;
    exit;
    end;

  if (conn.request.method = HM_POST) and assigned(data.uploadResults) then
    begin
    fileSrv.getPage('upload-results', data, f);
    exit;
    end;

  // provide access to any [section] in the tpl, included [progress]
  if mode = 'section' then
    s:=first(data.urlvars.values['id'], 'no-id') // no way, you must specify the id
  else if (f = fileSrv.rootFile) and (urlCmd > '') then
    s:=substr(urlCmd,2)
  else
    s:='';
  if (s > '') and f.isFolder() and not ansiStartsText('special:', s) then
    with fileSrv.tplFromFile(f) do // temporarily builds from diff tpls
      try
        section:=getsection(s);
        if assigned(section) and section.public then // it has to exist and be accessible
          begin
          if not section.cache
          or not notModified(conn, s+floatToStr(section.ts), '') then
            fileSrv.getPage(s, data, f, me());
          exit;
          end;
      finally free
        end;

  if f.isFolder() and not (FA_BROWSABLE in f.flags)
  and stringExists(urlCmd,['','~folder.tar','~files.lst']) then
    begin
    fileSrv.getPage('deny', data);
    exit;
    end;

  if not isAllowedReferer()
  or f.isFile() and f.isDLforbidden() then
    begin
    fileSrv.getPage('deny', data);
    exit;
    end;

  if (urlCmd = '~folder.tar')
  or (mode = 'archive') then
    begin
    serveTar();
    exit;
    end;

  // please note: we accept also ~files.lst.m3u
  if ansiStartsStr('~files.lst', urlCmd)
  or f.isFolder() and (data.urlvars.values['tpl'] = 'list') then
    begin
    if conn.reply.mode=HRM_REPLY_HEADER then
      exit;
    // load from external file
    s:=cfgPath+FILELIST_TPL_FILE;
    if newMtime(s, lastFilelistTpl) then
      filelistTpl.fullText:=loadfile(s);
    // if no file is given, load from internal resource
    if not fileExists(s) and (lastFilelistTpl > 0) then
      begin
      lastFilelistTpl:=0;
      filelistTpl.fullText:=getRes('filelistTpl');
      end;

    data.downloadingWhat:=DW_FOLDERPAGE;
    data.disconnectAfterReply:=TRUE; // needed for IE6... ugh...
    data.disconnectReason:='IE6 workaround';
    replyWithString(trim(getFolderPage(f, data, filelistTpl)));
    exit;
    end;

  // from here on, we manage only services with no urlCmd.
  // a non empty urlCmd means the url resource was not found.
  if urlCmd > '' then
    begin
    fileSrv.getPage('not found', data);
    exit;
    end;

  data.lastFile:=f; // auto-freeing

  if f.isFolder() then
    begin
    if conn.reply.mode=HRM_REPLY_HEADER then
      exit;
    deletion();
    if sessionRedirect() then
      exit;
    data.downloadingWhat:=DW_FOLDERPAGE;
QueryPerformanceFrequency(Freq);
QueryPerformanceCounter(StartCount);
    if DMbrowserTplChk.Checked and isDownloadManagerBrowser() then
      s := getFolderPage(f, data, dmBrowserTpl)
    else
      s := getFolderPage(f, data, fileSrv.tpl);
    if conn.reply.mode <> HRM_REDIRECT then
      replyWithString(s);
QueryPerformanceCounter(StopCount);
TimingSeconds := (StopCount - StartCount) / Freq;
OutputDebugString(PChar('Prepared reply for folder by ' + floattostr(TimingSeconds)));
    exit;
    end;

  if notModified(conn, f) then // calling notModified before limitsExceededOnDownload makes possible for [download] to manipualate headers set here
    exit;
  if thumb() then
    Exit;
  if mode = 'icon' then
    begin
      sendIcon;
      Exit;
    end;

  data.countAsDownload := f.shouldCountAsDownload();
  if data.countAsDownload and limitsExceededOnDownload() then
    exit;

  setupDownloadIcon(data);
  data.eta.idx:=0;
  conn.reply.contentType:=name2mimetype(f.name, DEFAULT_MIME);
  conn.reply.bodyMode:=RBM_FILE;
  conn.reply.bodyU := f.resource;
  data.downloadingWhat := DW_FILE;
  { I guess this would not help in any way for files since we are already handling the 'if-modified-since' field
  try
    conn.addHeader('ETag: '+getEtag(f.resource));
  except end;
  }
  
  data.fileXferStart:=now();
  if data.countAsDownload and (flashOn = 'download') then flash();

  b:=(openInBrowser <> '') and fileMatch(openInBrowser, f.name)
    or inBrowserIfMIME and (conn.reply.contentType <> DEFAULT_MIME);

  s:=first(eventToFilename('download name', []), f.name); // a script can eventually decide the name
  // N-th workaround for IE. The 'accept' check should let us know if the save-dialog is displayed. More information at www.rejetto.com/forum/?topic=6275
  if (data.agent = 'MSIE') and (conn.getHeader('Accept') = '*/*') then
    s:=xtpl(s, [' ','%20']);
  if not noContentdispositionChk.checked or not b then
    addContentDisposition(s, not b);
  end; // handleRequest

  procedure lastByte();

    procedure incDLcount(f:Tfile; res:string);
    begin
    if (f = NIL) or f.isTemp() then autoupdatedFiles.incInt(res)
    else f.DLcount:=1+f.DLcount
    end;

  var
    archive: TarchiveStream;
    i: integer;
  begin
  if data.countAsDownload then
    inc(downloadsLogged);
  // workaround for a bug that was fixed in Wget/1.10
  if stringExists(data.agent, ['Wget/1.7', 'Wget/1.8.2', 'Wget/1.9', 'Wget/1.9.1']) then
    data.disconnect('wget bug workaround (consider updating wget)');
  VFScounterMod:=TRUE;
  case data.downloadingWhat of
    DW_FILE:
      if assigned(data) then
        incDLcount(data.lastFile, data.lastFile.resource);
    DW_ARCHIVE:
      begin
      archive := conn.reply.bodyStream as TarchiveStream;
      for i:=0 to length(archive.flist)-1 do
        incDLcount(Tfile(archive.flist[i].data), archive.flist[i].src);
      end;
    end;
  if data.countAsDownload then
    runEventScript('download completed');
  end; // lastByte

  function canWriteFile():boolean;
  resourcestring
    MSG_MIN_DISK_REACHED = 'Minimum disk space reached.';
  begin
  result:=FALSE;
  if data.f = NIL then exit;
  result:= minDiskSpace <= diskSpaceAt(data.uploadDest) div MEGA;
  if result then exit;
  closeUploadingFile_partial();
  data.uploadFailed:=MSG_MIN_DISK_REACHED;
  end; // canWriteFile

  function complyUploadFilter():boolean;

    function getMask():string;
    begin
    if f.isTemp() then result:=f.parent.uploadFilterMask
    else result:=f.uploadFilterMask;
    if result = '' then
      result:='\'+PROTECTED_FILES_MASK; // the user can disable this default filter by inputing * as mask
    end;

  resourcestring
    MSG_UPL_NAME_FORB = 'File name or extension forbidden.';
  begin
  result:=validFilename(data.uploadSrc)
    and not sameText(data.uploadSrc, DIFF_TPL_FILE) // never allow this
    and not isExtension(data.uploadSrc, '.lnk')  // security matters (by mars)
    and fileMatch(getMask(), data.uploadSrc);
  if not result then
    data.uploadFailed:=MSG_UPL_NAME_FORB;
  end; // complyUploadFilter

  function canCreateFile():boolean;
  resourcestring
    MSG_UPL_CANT_CREATE = 'Error creating file.';
  begin
  IOresult;
  rewrite(data.f^, 1);
  result:=IOresult=0;
  if result then exit;
  data.uploadFailed:=MSG_UPL_CANT_CREATE;
  end; // canCreateFile

var
  ur: TuploadResult;
  i: integer;
begin
if assigned(conn) and (conn.getLockCount <> 1) then
  add2log('please report on the forum about this message');

f:=NIL;
data:=NIL;
if assigned(conn) then
  data:=conn.data;
if assigned(data) then
  data.lastActivityTime:=now();

if dumpTrafficChk.Checked and (event in [HE_GOT, HE_SENT]) then
  appendFileA(exePath+'hfs-dump.bin', TLV(if_(event=HE_GOT,1,2),
    TLV(10, str_(now()))+TLVS(11, data.address)+TLVS(12, conn.port)+TLV(13, conn.eventData)
  ));

if preventStandbyChk.checked and assigned(setThreadExecutionState) then
  setThreadExecutionState(1);

// this situation can happen when there is a call to processMessage() before this function ends
if (data = NIL) and (event in [HE_REQUESTED, HE_GOT]) then
  exit;

case event of
  HE_CANT_OPEN_FILE: data.error:='Can''t open file';
  HE_OPEN:
    begin
    startBtn.Hide();
    updateUrlBox();
    // this happens when the server is switched on programmatically
    usingFreePort:= port='';
    updatePortBtn();
    runEventScript('server start');
    end;
  HE_CLOSE:
    begin
    startBtn.show();
    updatePortBtn();
    updateUrlBox();
    runEventScript('server stop');
    end;
  HE_REQUESTING:
    begin
    // do some clearing, due for persistent connections
    data.vars.clear();
    data.urlvars.clear();
    data.postVars.clear();
    data.tplCounters.clear();
    refreshConn(data);
    end;
  HE_GOT_HEADER: runEventScript('got header');
  HE_REQUESTED:
    begin
    data.dontLog:=FALSE;
//QueryPerformanceFrequency(Freq);
//QueryPerformanceCounter(StartCount);
    handleRequest();
//QueryPerformanceCounter(StopCount);
//TimingSeconds := (StopCount - StartCount) / Freq;
//OutputDebugString(PChar('Prepared request answer by ' + floattostr(TimingSeconds)));
    // we save the value because we need it also in HE_REPLY, and temp files are not avaliable there
    data.dontLog:=data.dontLog or assigned(f) and f.hasRecursive(FA_DONT_LOG);
    if f <> data.lastFile then
      freeIfTemp(f);
    refreshConn(data);
    end;
  HE_STREAM_READY:
    begin
    i:=length(data.disconnectReason);
    runEventScript('stream ready');
    if (i=0) and (data.disconnectReason > '') then // only if it was not already disconnecting
      begin
      conn.reply.ClearAdditionalHeaders; // content-disposition would prevent the browser
      fileSrv.getPage('deny', data);
      conn.initInputStream();
      end;
    end;
  HE_REPLIED:
    begin
    setupDownloadIcon(data); // remove the icon
    data.lastBytesGot:=0;
    if data.disconnectAfterReply then
      data.disconnect('replied');
    if updateASAP > '' then
      data.disconnect('updating');
    refreshConn(data);
    end;
  HE_LAST_BYTE_DONE:
    begin
    if (conn.reply.mode = HRM_REPLY) and (data.downloadingWhat in [DW_FILE, DW_ARCHIVE]) then
      lastByte();
    runEventScript('request completed');
    end;
  HE_CONNECTED:
    begin
    //** lets see if this helps with speed
    i:=-1;
    WSocket_setsockopt(conn.sock.HSocket, IPPROTO_TCP, TCP_NODELAY, @i, sizeOf(i));

    data:=TconnData.create(conn);
    conn.limiters.add(globalLimiter); // every connection is bound to the globalLimiter
    conn.sndBuf:=STARTING_SNDBUF;
    data.address:=conn.address;
    checkCurrentAddress();
    connBox.items.add();
    if (flashOn = 'connection') and (conn.reply.mode <> HRM_CLOSE) then flash();
    runEventScript('connected');
    end;
  HE_DISCONNECTED:
    begin
    closeUploadingFile_partial();
    data.deleting:=TRUE;
    toDelete.add(data);
    with connBox.items do count:=count-1;
    runEventScript('disconnected');
    connBox.invalidate();
    end;
  HE_GOT: lastActivityTime:=now();
  HE_SENT:
    begin
    if data.nextDloadScreenUpdate <= now() then
      begin
      data.nextDloadScreenUpdate:= now()+DOWNLOAD_MIN_REFRESH_TIME;
      refreshConn(data);
      setupDownloadIcon(data);
      end;
    lastActivityTime:=now();
    end;
  HE_POST_FILE:
    begin
    sessionSetup();
    data.downloadingWhat:=DW_UNK;
    data.agent:=getAgentID(conn);
    data.fileXferStart:=now();
    f := fileSrv.findFileByURL(decodeURL(getTill('?',conn.request.url)), getLP);
    data.lastFile:=f; // auto-freeing
    data.uploadSrc:=conn.post.filename;
    data.uploadFailed:='';
    if (f = NIL) or not accountAllowed(FA_UPLOAD, data, f) or not f.accessFor(data) then
      data.uploadFailed:=if_(f=NIL, 'Folder not found.', 'Not allowed.')
    else
      begin
      closeUploadingFile();
      getUploadDestinationFileName();

      if complyUploadFilter() and canWriteFile() and canCreateFile() then
        saveFileA(data.f^, conn.post.data);
      repaintTray();
      end;
    if data.uploadFailed > '' then
      logUploadFailed();
    end;
  HE_POST_MORE_FILE:
    if canWriteFile() then
      saveFileA(data.f^, conn.post.data);
  HE_POST_END_FILE:
    begin
    // fill the record
    ur.fn:=first(extractFilename(data.uploadDest), data.uploadSrc);
    if data.f = NIL then ur.size:=-1
    else ur.size:=filesize(data.f^);
    ur.speed:=calcAverageSpeed(conn.bytesPostedLastItem);
    // custom scripts
    if assigned(data.f) then inc(uploadsLogged);
    closeUploadingFile();
    if data.uploadFailed = '' then
      data.uploadFailed:=trim(runEventScript('upload completed'))
    else
      runEventScript('upload failed');
    ur.reason:=data.uploadFailed;
    if data.uploadFailed > '' then
      deleteFile(data.uploadDest);
    // queue the record
    i:=length(data.uploadResults);
    setLength(data.uploadResults, i+1);
    data.uploadResults[i]:=ur;

    refreshConn(data);
    end;
  HE_POST_VAR: data.postVars.add(conn.post.varname+'='+UnUTF(conn.post.data));
  HE_POST_VARS:
    if conn.post.mode = PM_URLENCODED then
      urlToStrings(conn.post.data, data.postVars);
  // default case
  else refreshConn(data);
  end;//case
 if Assigned(data) then
   sessions.keepAlive(data.sessionID);
if event in [HE_CONNECTED, HE_DISCONNECTED, HE_OPEN, HE_CLOSE, HE_REQUESTED, HE_POST_END, HE_LAST_BYTE_DONE] then
  begin
  repaintTray();
  updateTrayTip();
  end;
doLog();
end; // httpEvent

procedure findSimilarIP(fromIP:string);

  function howManySameChars(ip1,ip2:string):integer;
  var
    i,n: integer;
  begin
  i:=1;
  n:=min(length(ip1),length(ip2));
  while (i<=n) and (ip1[i] = ip2[i]) do
    inc(i);
  result:=i-1;
  end; // howManySameChars

var
  chosen: string;
  i: integer;
  a: TStringDynArray;
begin
if fromIP = '' then exit;
if stringExists(fromIP, customIPs) then
  begin
  setDefaultIP(fromIP);
  exit;
  end;
chosen:=getIP();
//a:=getIPs();
a:=getAcceptOptions();
for i:=0 to length(a)-1 do
  if howManySameChars(chosen, fromIP) < howManySameChars(a[i], fromIP) then
    chosen:=a[i];
setDefaultIP(chosen);
end; // findSimilarIP

procedure setLimitOption(var variable:integer; newValue:integer;
  menuItem:TmenuItem; menuLabel:string);
begin
if newValue < 0 then newValue:=0;
variable:=newValue;
menuItem.caption:=menuLabel
  +format(MSG_MENU_VAL, [if_(newValue=0,DISABLED,intToStr(newValue))]);
end; // setLimitOption

procedure setMaxIPs(v:integer);
begin setLimitOption(maxIPs,v, mainfrm.maxIPs1, MSG_MAX_SIM_ADDR) end;

procedure setMaxIPsDLing(v:integer);
begin setLimitOption(maxIPsDLing,v, mainfrm.maxIPsDLing1, MSG_MAX_SIM_ADDR_DL) end;

procedure setMaxConnections(v:integer);
begin setLimitOption(maxConnections,v, mainfrm.maxConnections1, MSG_MAX_CON) end;

procedure setMaxConnectionsIP(v:integer);
begin setLimitOption(maxConnectionsIP, v, mainfrm.MaxconnectionsfromSingleaddress1, MSG_MAX_CON_SING) end;

procedure setMaxDLs(v:integer);
begin setLimitOption(maxContempDLs, v, mainfrm.maxDLs1, MSG_MAX_SIM_DL) end;

procedure setMaxDLsIP(v:integer);
begin setLimitOption(maxContempDLsIP, v, mainfrm.maxDLsIP1, MSG_MAX_SIM_DL_SING) end;

procedure setAutoFingerprint(v:integer);
resourcestring
  FINGERPRINT = 'Create fingerprint on addition under %d KB';
  NO_FINGERPRINT = 'Create fingerprint on addition: disabled';
begin
autoFingerprint:=v;
mainfrm.Createfingerprintonaddition1.caption:=format(if_(v=0, NO_FINGERPRINT, FINGERPRINT), [v]);
end;

function createFingerprint(const fn: String; showProgress: Boolean): String;
var
  b: TBytes;
begin
  result := '';
  b := getFileMD5(fn, Prog);
  for var i: Integer :=0 to 15 do
    result := result+intToHex(byte(b[i]), 2);
end; // createFingerprint

procedure applyFilesBoxRatio();
begin
if filesBoxRatio <= 0 then exit;
mainfrm.filesPnl.width:=round(filesBoxRatio*mainfrm.clientWidth);
end; // applyFilesBoxRatio

procedure TmainFrm.FormResize(Sender: TObject);
begin
urlBox.Width:=urlToolbar.ClientWidth-browseBtn.Width-copyBtn.width;
applyFilesBoxRatio();
end;

procedure checkIfOnlyCountersChanged();
begin
if not VFSmodified and VFScounterMod then
  mainfrm.saveVFS(lastFileOpen)
end;

function checkVfsOnQuit():boolean;
resourcestring
  MSG_SAVE_VFS = 'Your current file system is not saved.'#13'Save it?';
var
  s: string;
begin
result:=TRUE;
if loadingVFS.disableAutosave then exit;
checkIfOnlyCountersChanged();
if not VFSmodified or mainfrm.quitWithoutAskingToSaveChk.checked then exit;
if mainfrm.autosaveVFSchk.checked then
  mainfrm.saveVFS(lastFileOpen)
else if windowsShuttingDown then
  begin
  s:=lastFileOpen; // don't change this
  mainfrm.saveVFS(VFS_TEMP_FILE);
  lastFileOpen:=s;
  end
else
  case msgDlg(MSG_SAVE_VFS, MB_ICONQUESTION+if_(quitASAP, MB_YESNO, MB_YESNOCANCEL)) of
    IDYES: mainfrm.saveVFS(lastFileOpen);
    IDNO: ; // just go on
    IDCANCEL: result:=FALSE;
    end;
end; // checkVfsOnQuit

procedure inputComment(f:Tfile);
resourcestring
  MSG_INP_COMMENT= 'Please insert a comment for "%s".'
    +#13'You should use HTML: <br> for break line.';
begin
VFSmodified:=inputqueryLong('Comment', format(MSG_INP_COMMENT, [f.name]), f.comment);
end; // inputComment

function Tmainfrm.addFile(f:Tfile; parent:Ttreenode=NIL; skipComment:boolean=FALSE):Tfile;
var
  n: TTreeNode;
begin
  Result := addFile(f, parent, skipComment, n);
end;

function Tmainfrm.addFile(f:Tfile; parent: TTreeNode; skipComment: boolean; var newNode: TTreeNode): Tfile;
resourcestring
  MSG_FILE_ADD_ABORT = 'File addition was aborted.'#13'The list of files is incomplete.';
begin
  newNode := NIL;
  abortBtn.show();
  fileSrv.stopAddingItems := FALSE;
    try
      result := fileSrv.addFileRecur(f, parent, newNode);
     finally
      abortBtn.hide()
    end;
  if result = NIL then
    exit;
  if fileSrv.stopAddingItems then
    msgDlg(MSG_FILE_ADD_ABORT, MB_ICONWARNING);
  if assigned(parent) then
    parent.expanded := TRUE;
  SetSelectedFile(result, newNode);

  if skipComment or not autoCommentChk.checked then
    exit;
  application.restore();
  application.bringToFront();
  inputComment(f);
end; // addFile


procedure TmainFrm.filesBoxCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
AllowCollapse:=node.parent<>NIL;
end;

procedure TmainFrm.Newlink1Click(Sender: TObject);
var
  name: string;
begin
  name := fileSrv.getUniqueNodeName('New link', filesBox.Selected);
  addfile(Tfile.createLink(filesBox, name), filesBox.Selected).node.Selected:=TRUE;
  setURL1click(sender);
end;

procedure TmainFrm.newfolder1Click(Sender: TObject);
var
  name: string;
begin
  name := fileSrv.getUniqueNodeName('New folder', filesBox.selected);
with addFile(Tfile.createVirtualFolder(filesBox, name), filesBox.Selected).node do
  begin
  Selected:=TRUE;
  editText();
  end;
end;

procedure TmainFrm.filesBoxEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
if node = NIL then exit;
{ disable shortcuts, to be used in editbox. Shortcuts need to be re-activated,
{ but when the node text is left unchanged, no event is notified, so we got to
{ use timerEvent to do the work. }
copyURL1.ShortCut:=0;
remove1.ShortCut:=0;
Paste1.ShortCut:=0;

allowedit:=allowedit and not nodeToFile(node).isRoot()
end;

procedure TmainFrm.filesBoxEdited(Sender:TObject; Node:TTreeNode; var S:String);
resourcestring
  MSG_INV_FILENAME = 'Invalid filename';
var
  f: Tfile;
begin
f:=node.data;
s:=trim(s); // mod by mars
if f.name = s then exit;

if f.isFileOrFolder() and not validFilename(s)
or (s = '')
or (pos('/',s) > 0)
then
  begin
  s:=node.text;
  msgDlg(MSG_INV_FILENAME, MB_ICONERROR);
  exit;
  end;

if filesrv.existsNodeWithName(s, node.parent)
and (msgDlg(MSG_SAME_NAME, MB_ICONWARNING+MB_YESNO) <> IDYES) then
  begin
  s:=node.text; // mod by mars
  exit;
  end;

f.name:=s;
VFSmodified:=TRUE;
updateUrlBox();
end;

function setNilChildrenFrom(nodes: TtreeNodeDynArray; father: integer): integer;
var
  i: integer;
begin
result:=0;
for i:=father+1 to length(nodes)-1 do
  if nodes[i].Parent = nodes[father] then
    begin
    nodes[i]:=NIL;
    inc(result);
    end;
end; // setNilChildrenFrom

procedure Tmainfrm.remove(f: TFile=NIL);
begin
  if f = NIL then
    remove(Ttreenode(NIL))
   else
    if f.node <> NIL then
      remove(f.node);
end;

procedure Tmainfrm.remove(node:Ttreenode=NIL);
resourcestring
  MSG_DELETE = 'Delete?';
var
  i: integer;
  list: TtreenodeDynArray;
  warn: boolean;
begin
if assigned(node) then
  begin
  if node.parent = NIL then exit;
  if nodeIsLocked(node) then
    begin
    msgDlg(MSG_ITEM_LOCKED, MB_ICONERROR);
    exit;
    end;
  node.Delete();
  exit;
  end;

i:=filesbox.SelectionCount;
if (i = 0) or (i = 1) and selectedFile.isRoot() then exit;
if not deleteDontAskChk.checked
and (msgDlg(MSG_DELETE, MB_ICONQUESTION+MB_YESNO) = IDNO) then
  exit;
list:=copySelection();
// now proceed
warn:=FALSE;
for i:=0 to length(list)-1 do
  if assigned(list[i]) and assigned(list[i].parent) then
    if assigned(list[i].data) and nodeIsLocked(list[i]) then
      warn:=TRUE
    else
      begin
      // avoid messing with children that will automatically be deleted as soon as the father is
      setNilChildrenFrom(list, i);
      list[i].Delete();
      end;

if warn then
  msgDlg(MSG_SOME_LOCKED, MB_ICONWARNING);
end; // remove

procedure TmainFrm.Remove1Click(Sender: TObject);
begin
// this method is bound to the DEL key also while a renaming is ongoing
if not filesBox.IsEditing() then remove(Ttreenode(NIL))
end;

procedure TmainFrm.startBtnClick(Sender: TObject);
begin toggleServer() end;

function Tmainfrm.pointedConnection():TconnData;
var
  li: TlistItem;
begin
result:=NIL;
with connbox.screenToClient(mouse.cursorPos) do
  li:=connbox.getItemAt(x,y);
if li = NIL then exit;
result:=conn2data(li);
end; // pointedConnection

function Tmainfrm.pointedFile(strict:boolean=TRUE):Tfile;
var
  n: Ttreenode;
  p: Tpoint;
begin
result:=NIL;
p:=filesbox.screenToClient(mouse.cursorPos);
if strict and not (htOnItem in filesBox.getHitTestInfoAt(p.x,p.y)) then exit;
n:=filesbox.getNodeAt(p.x,p.y);
if (n = NIL) or (n.data = NIL) then exit;
result:=n.data;
end; // pointedFile

procedure Tmainfrm.updateUrlBox();
var
  f: Tfile;
begin
if quitting then exit;
if selectedFile = NIL then f:= fileSrv.rootFile
else f:=selectedFile;

if f = NIL then urlBox.Text:=''
else urlBox.text:= fileSrv.fullURL(f)
end; // updateUrlBox

procedure TmainFrm.filesBoxChange(Sender: TObject; Node: TTreeNode);
begin
if filesBox.SelectionCount = 0 then selectedFile:=NIL
else selectedFile:=filesBox.selections[0].data;
updateUrlBox()
end;

function Tmainfrm.selectedConnection():TconnData;
begin
if connBox.selected = NIL then
  result:=NIL
else
  result:=conn2data(connBox.selected)
end;

procedure TmainFrm.setLogToolbar(v:boolean);
begin
expandedPnl.visible:=v;
collapsedPnl.visible:=not v;
end; // setLogToolbar

procedure TmainFrm.Kickconnection1Click(Sender: TObject);
var
  cd: TconnData;
begin
cd:=selectedConnection();
if cd = NIL then exit;
cd.disconnect('kicked');
end;

procedure TmainFrm.Kickallconnections1Click(Sender: TObject);
begin kickByIP('*') end;

procedure TmainFrm.KickIPaddress1Click(Sender: TObject);
var
  cd: TconnData;
begin
cd:=selectedConnection();
if cd = NIL then exit;
kickByIP(cd.address);
end;

procedure setAutosave(var rec:Tautosave; v:integer);
resourcestring
  AUTOSAVE = 'Auto save every: ';
  SECONDS = '%d seconds';
begin
rec.every:=v;
if assigned(rec.menu) then
  rec.menu.caption:=AUTOSAVE + if_(v=0,DISABLED, format(SECONDS,[v]));
end; // setAutosave

procedure updateMenuSpeed(menu: TMenuItem; const lab: String; v: Float32);
begin
  menu.caption := lab + format(MSG_MENU_VAL, [if_(v<0, DISABLED, format(MSG_SPEED_KBS, [v]))]);
end;

procedure setSpeedLimitIP(v:real);
resourcestring
  MSG_SPD_LIMIT_SING = 'Speed limit for single address';
var
  i, vi: integer;
begin
speedLimitIP:=v;
if v < 0 then vi:=MAXINT
else vi:=round(v*1000);
for i:=0 to ip2obj.Count-1 do
  with ip2obj.Objects[i] as TperIp do
    if not customizedLimiter then
      limiter.maxSpeed:=vi;
updateMenuSpeed(mainfrm.Speedlimitforsingleaddress1, MSG_SPD_LIMIT_SING, v);
end; // setSpeedLimitIP

procedure setSpeedLimit(v:real);
resourcestring
  MSG_SPD_LIMIT = 'Speed limit';
begin
speedLimit:=v;
if v < 0 then globalLimiter.maxSpeed:=MAXINT
else globalLimiter.maxSpeed:=round(v*1000);
updateMenuSpeed(mainfrm.speedLimit1, MSG_SPD_LIMIT, v);
end; // setSpeedLimit

procedure autosaveClick(var rec:Tautosave; name:string);
resourcestring
  MSG_AUTO_SAVE = 'Auto-save %s';
  MSG_AUTO_SAVE_LONG = 'Auto-save %s.'
    +#13'Specify in seconds.'
    +#13'Leave blank to disable.';
  MSG_MIN = 'We don''t accept less than %d';
var
  s: string;
  v: integer;
begin
if rec.every <= 0 then s:=''
else s:=intToStr(rec.every);
  repeat
  if not inputquery(format(MSG_AUTO_SAVE,[name]), format(MSG_AUTO_SAVE_LONG,[name]), s) then exit;
  s:=trim(s);
  if s = '' then
    begin
    setAutosave(rec, 0);
    break;
    end
  else
    try
      v:=strToInt(s);
      if v >= rec.minimum then
        begin
        setAutosave(rec, v);
        break;
        end;
      msgDlg(format(MSG_MIN,[rec.minimum]), MB_ICONERROR);
    except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR) end;
  until false;
end; // autosaveClick

function TmainFrm.getCfg(exclude: string=''): string;
type
  Tencoding=(E_PLAIN, E_B64, E_ZIP);

  function encodeW(const s: string; encoding: Tencoding): String;
  begin
  case encoding of
    E_PLAIN: result:=s;
    E_B64: result:=b64utf8W(s);
    E_ZIP:
      begin
      result := b64U(zCompressStr(StrToUTF8(s)));
//      if length(result) > round(0.95*length(s)) then result:=s;
//      result := Base64EncodeString(result);
      end;
    end;
  end;

  function encodeA(const s: RawByteString; encoding: Tencoding): RawByteString;
  begin
  case encoding of
    E_PLAIN: result:=s;
    E_B64: result:=B64R(s);
    E_ZIP:
      begin
      result := zCompressStr(s);
      if length(result) > round(0.95*length(s)) then result:=s;
      result := B64R(result);
      end;
    end;
  end;

  function accountsToStr(): String;
  var
    i: integer;
    a: Paccount;

    function prop(name, value:string; encoding:Tencoding=E_PLAIN):string;
    begin
      if value > '' then
        result:='|'+name+':'+encodeW(value, encoding)
       else
        Result := '';
    end;

  begin
  result:='';
  if Length(accounts) > 0 then
  for i:=0 to length(accounts)-1 do
  	begin
    a:=@accounts[i];
    result:=result
      +prop('login', a.user+':'+a.pwd, E_B64)
      +prop('enabled', yesno[a.enabled])
      +prop('group', yesno[a.group])
      +prop('no-limits', yesno[a.noLimits])
      +prop('redir', a.redir)
      +prop('link', join(':',a.link))
      +prop('notes', a.notes, E_ZIP)
      +';';
    end;
  end; // accountsToStr

  function banlistToStr(): String;
  var
    i: integer;
  begin
  result:='';
  for i:=0 to length(banlist)-1 do
    result:=result+banlist[i].ip+'#'
      +xtpl(banlist[i].comment, ['|','\$pipe'])+'|';
  end;

  function connColumnsToStr():string;
  var
    i: integer;
  begin
  result:='';
  for i:=0 to connBox.columns.count-1 do
    with connBox.columns.items[i] do
      result:=result+format('%s;%d|', [caption, width]);
  end; // connColumnsToStr

var
  iconMasksStr, userIconMasks: string;

  function iconMasksToStr():string;
  var
    i, j: integer;
  begin
  result:='';
  for i:=0 to length(iconMasks)-1 do
    begin
    j:=idx_img2ico(iconMasks[i].int);
    if j >= USER_ICON_MASKS_OFS then
      userIconMasks:=userIconMasks+format('%d:%s|', [j, encodeA(pic2str(j, 16), E_ZIP)]);
    result:=result+format('%s|%d||', [iconMasks[i].str, j]);
    end;
  end; // iconMasksToStr

  function fontToStr(f:Tfont):string;
  begin
  result:=if_(fsBold in f.Style, 'B')+if_(fsItalic in f.Style, 'I')
    +if_(fsUnderline in f.Style, 'U')+if_(fsStrikeOut in f.Style, 'S');
  result:=format('%s|%d|%s|%s', [f.Name,f.size,colorToString(f.Color),result]);
  end; // fontToStr

begin
userIconMasks:='';
iconMasksStr:=iconMasksToStr();
result:='HFS '+ srvConst.VERSION+' - Build #'+VERSION_BUILD+CRLF
+'active='+yesno[srv.active]+CRLF
+'only-1-instance='+yesno[only1instanceChk.checked]+CRLF
+'window='+rectToStr(lastWindowRect)+CRLF
+'window-max='+yesno[windowState = wsMaximized]+CRLF
+'easy='+yesno[easyMode]+CRLF
+'port='+port+CRLF
+'files-box-ratio='+floatToStr(filesBoxRatio)+CRLF
+'log-max-lines='+intToStr(logMaxLines)+CRLF
+'log-read-only='+yesno[logbox.readonly]+CRLF
+'log-file-name='+logFile.filename+CRLF
+'log-font-name='+logFontName+CRLF
+'log-font-size='+intToStr(logFontSize)+CRLF
+'log-date='+yesno[LogdateChk.checked]+CRLF
+'log-time='+yesno[LogtimeChk.checked]+CRLF
+'log-to-screen='+yesno[logOnVideoChk.checked]+CRLF
+'log-only-served='+yesno[logOnlyServedChk.checked]+CRLF
+'log-server-start='+yesno[logServerstartChk.checked]+CRLF
+'log-server-stop='+yesno[logServerstopChk.checked]+CRLF
+'log-connections='+yesno[logConnectionsChk.checked]+CRLF
+'log-disconnections='+yesno[logDisconnectionsChk.checked]+CRLF
+'log-bytes-sent='+yesno[logBytessentChk.checked]+CRLF
+'log-bytes-received='+yesno[logBytesreceivedChk.checked]+CRLF
+'log-replies='+yesno[logRepliesChk.checked]+CRLF
+'log-requests='+yesno[logRequestsChk.checked]+CRLF
+'log-uploads='+yesno[logUploadsChk.checked]+CRLF
+'log-deletions='+yesno[logDeletionsChk.checked]+CRLF
+'log-full-downloads='+yesno[logFulldownloadsChk.checked]+CRLF
+'log-dump-request='+yesno[DumprequestsChk.checked]+CRLF
+'log-browsing='+yesno[logBrowsingChk.checked]+CRLF
+'log-icons='+yesno[logIconsChk.checked]+CRLF
+'log-progress='+yesno[logProgressChk.checked]+CRLF
+'log-banned='+yesno[logBannedChk.checked]+CRLF
+'log-others='+yesno[logOtherEventsChk.checked]+CRLF
+'log-file-tabbed='+yesno[tabOnLogFileChk.checked]+CRLF
+'log-apache-format='+logfile.apacheFormat+CRLF
+'tpl-file='+tplFilename+CRLF
+'tpl-editor='+tplEditor+CRLF
+'delete-dont-ask='+yesno[deleteDontAskChk.checked]+CRLF
+'free-login='+yesno[freeLoginChk.checked]+CRLF
+'confirm-exit='+yesno[confirmexitChk.checked]+CRLF
+'keep-bak-updating='+yesno[keepBakUpdatingChk.checked]+CRLF
+'include-pwd-in-pages='+yesno[pwdInPagesChk.Checked]+CRLF
+'ip='+defaultIP+CRLF
+'custom-ip='+join(';',customIPs)+CRLF
+'listen-on='+listenOn+CRLF
+'external-ip-server='+customIPservice+CRLF
+'dynamic-dns-updater='+b64utf8W(dyndns.url)+CRLF
+'dynamic-dns-user='+dyndns.user+CRLF
+'dynamic-dns-host='+dyndns.host+CRLF
+'search-better-ip='+yesno[searchbetteripChk.checked]+CRLF
+'start-minimized='+yesno[startMinimizedChk.checked]+CRLF
+'connections-height='+intToStr(lastGoodConnHeight)+CRLF
+'files-stay-flagged-for-minutes='+intToStr(filesStayFlaggedForMinutes)+CRLF
+'auto-save-vfs='+yesno[autosaveVFSchk.checked]+CRLF
+'folders-before='+yesno[foldersbeforeChk.checked]+CRLF
+'links-before='+yesno[linksBeforeChk.checked]+CRLF
+'use-comment-as-realm='+yesno[usecommentasrealmChk.checked]+CRLF
+'getright-template='+yesno[DMbrowserTplChk.checked]+CRLF
+'auto-save-options='+yesno[autosaveoptionsChk.checked]+CRLF
+'dont-include-port-in-url='+yesno[noPortInUrlChk.checked]+CRLF
+'persistent-connections='+yesno[persistentconnectionsChk.checked]+CRLF
+'modal-options='+yesno[modalOptionsChk.checked]+CRLF
+'beep-on-flash='+yesno[beepChk.checked]+CRLF
+'prevent-leeching='+yesno[preventLeechingChk.checked]+CRLF
+'delete-partial-uploads='+yesno[deletePartialUploadsChk.checked]+CRLF
+'rename-partial-uploads='+renamePartialUploads+CRLF
+'enable-macros='+yesno[enableMacrosChk.checked]+CRLF
+'use-system-icons='+yesno[usesystemiconsChk.checked]+CRLF
+'minimize-to-tray='+yesno[MinimizetotrayChk.checked]+CRLF
+'tray-icon-for-each-download='+yesno[trayfordownloadChk.checked]+CRLF
+'show-main-tray-icon='+yesno[showmaintrayiconChk.checked]+CRLF
+'always-on-top='+yesno[alwaysontopChk.checked]+CRLF
+'quit-dont-ask='+yesno[quitWithoutAskingToSaveChk.checked]+CRLF
+'support-descript.ion='+yesno[supportDescriptionChk.checked]+CRLF
+'oem-descript.ion='+yesno[oemForIonChk.checked]+CRLF
+'oem-tar='+yesno[oemTarChk.checked]+CRLF
+'enable-fingerprints='+yesno[fingerprintsChk.checked]+CRLF
+'save-fingerprints='+yesno[saveNewFingerprintsChk.checked]+CRLF
+'auto-fingerprint='+intToStr(autoFingerprint)+CRLF
+'stop-spiders='+yesno[stopSpidersChk.checked]+CRLF
+'backup-saving='+yesno[backupSavingChk.checked]+CRLF
+'recursive-listing='+yesno[recursiveListingChk.checked]+CRLF
+'send-hfs-identifier='+yesno[sendHFSidentifierChk.checked]+CRLF
+'list-hidden-files='+yesno[listfileswithhiddenattributeChk.checked]+CRLF
+'list-system-files='+yesno[listfileswithsystemattributeChk.checked]+CRLF
+'list-protected-items='+yesno[hideProtectedItemsChk.checked]+CRLF
+'enable-no-default='+yesno[enableNoDefaultChk.checked]+CRLF
+'browse-localhost='+yesno[browseUsingLocalhostChk.checked]+CRLF
+'add-folder-default='+addFolderDefault+CRLF
+'default-sorting='+defSorting+CRLF
+'last-dialog-folder='+lastDialogFolder+CRLF
+'auto-save-vfs-every='+intToStr(autosaveVFS.every)+CRLF
+'last-update-check='+floatToStr(lastUpdateCheck)+CRLF
+'allowed-referer='+allowedReferer+CRLF
+'forwarded-mask='+forwardedMask+CRLF
+'tray-shows='+ trayShowCode[trayShows]+CRLF
+'tray-message='+escapeNL(trayMsg)+CRLF
+'speed-limit='+floatToStr(speedLimit)+CRLF
+'speed-limit-ip='+floatToStr(speedLimitIP)+CRLF
+'max-ips='+intToStr(maxIPs)+CRLF
+'max-ips-downloading='+intToStr(maxIPsDLing)+CRLF
+'max-connections='+intToStr(maxConnections)+CRLF
+'max-connections-by-ip='+intToStr(maxConnectionsIP)+CRLF
+'max-contemporary-dls='+intToStr(maxContempDLs)+CRLF
+'max-contemporary-dls-ip='+intToStr(maxContempDLsIP)+CRLF
+'login-realm='+loginRealm+CRLF
+'open-in-browser='+openInBrowser+CRLF
+'flash-on='+flashOn+CRLF
+'graph-rate='+intToStr(graph.rate)+CRLF
+'graph-size='+intToStr(graph.size)+CRLF
+'graph-visible='+yesno[graphBox.visible]+CRLF
+'no-download-timeout='+intToStr(noDownloadTimeout)+CRLF
+'connections-timeout='+intToStr(connectionsInactivityTimeout)+CRLF
+'no-reply-ban='+yesno[noReplyBan]+CRLF
+'ban-list='+banlistToStr()+CRLF
+'add-to-folder='+addToFolder+CRLF
+'last-file-open='+lastFileOpen+CRLF
+'reload-on-startup='+yesno[reloadonstartupChk.checked]+CRLF
+'https-url='+yesno[httpsUrlsChk.checked]+CRLF
+'find-external-on-startup='+yesno[findExtOnStartupChk.checked]+CRLF
+'encode-non-ascii='+yesno[encodenonasciiChk.checked]+CRLF
+'encode-spaces='+yesno[encodespacesChk.checked]+CRLF
+'mime-types='+join('|',mimeTypes)+CRLF
+'in-browser-if-mime='+yesno[inBrowserIfMIME]+CRLF
+'icon-masks='+iconMasksStr+CRLF
+'icon-masks-user-images='+userIconMasks+CRLF
+'address2name='+join('|',address2name)+CRLF
+'recent-files='+join('|',recentFiles)+CRLF
+'trusted-files='+join('|',trustedFiles)+CRLF
+'accounts='+accountsToStr()+CRLF
+'account-notes-wrap='+yesno[optionsFrm.notesWrapChk.checked]+CRLF
+'tray-instead-of-quit='+yesno[trayInsteadOfQuitChk.checked]+CRLF
+'compressed-browsing='+yesno[compressedbrowsingChk.checked]+CRLF
+'use-iso-date-format='+yesno[useISOdateChk.Checked]+CRLF
+'hints4newcomers='+yesno[HintsfornewcomersChk.checked]+CRLF
+'save-totals='+yesno[saveTotalsChk.checked]+CRLF
+'log-toolbar-expanded='+yesno[mainfrm.expandedPnl.visible]+CRLF
+'number-files-on-upload='+yesno[numberFilesOnUploadChk.checked]+CRLF
+'do-not-log-address='+dontLogAddressMask+CRLF
+'last-external-address='+dyndns.lastIP+CRLF
+'min-disk-space='+intToStr(minDiskSpace)+CRLF
+'out-total='+intToStr(outTotalOfs+srv.bytesSent)+CRLF
+'in-total='+intToStr(inTotalOfs+srv.bytesReceived)+CRLF
+'hits-total='+intToStr(hitsLogged)+CRLF
+'downloads-total='+intToStr(downloadsLogged)+CRLF
+'upload-total='+intToStr(uploadsLogged)+CRLF
+'many-items-warning='+yesno[warnManyItems]+CRLF
+'load-single-comment-files='+yesno[loadSingleCommentsChk.checked]+CRLF
+'copy-url-on-start='+yesno[autocopyURLonstartChk.checked]+CRLF
+'connections-columns='+connColumnsToStr()+CRLF
+'auto-comment='+yesno[autoCommentChk.checked]+CRLF
+'update-daily='+yesno[updateDailyChk.checked]+CRLF
+'delayed-update='+yesno[delayUpdateChk.checked]+CRLF
+'tester-updates='+yesno[testerUpdatesChk.checked]+CRLF
+'copy-url-on-addition='+yesno[AutocopyURLonadditionChk.checked]+CRLF
+'ip-services='+join(';',IPservices)+CRLF
+'ip-services-time='+floatToStr(IPservicesTime)+CRLF
+'update-automatically='+yesno[updateAutomaticallyChk.checked]+CRLF
+'prevent-standby='+yesno[preventStandbyChk.checked]+CRLF;

if ipsEverConnected.Count < IPS_THRESHOLD then
  result:=result+'ips-ever-connected='+ipsEverConnected.DelimitedText+CRLF;

if exclude = '' then exit;
exclude:=stringReplace(exclude,'.','[^=]', [rfReplaceAll]); // optimization: since we are searching for keys, characters can't be "="
result:=reReplace(result, '^('+exclude+')=.*$', '');
end; // getCfg

// this is to keep the "hashed" version updated
var
  lastUcCFG: Tdatetime;
procedure updateCurrentCFG();
var
  s: string;
begin
if mainfrm = NIL then exit;

// not faster
if lastUcCFG+5/SECONDS > now() then exit;
lastUcCFG:=now();

s:=mainfrm.getCFG('.*-total'); // these will change often and are of no interest, so we ignore them as an optimization
if s = currentCFG then exit;

if (currentCFG>'') // first time, it's not an update, it's an initialization
and mainfrm.autoSaveOptionsChk.checked then
  mainfrm.saveCFG();

currentCFG:=s;
currentCFGhashed.text:=s; // re-parse
end; // updateCurrentCFG

function TmainFrm.setCfg(cfg:string; alreadyStarted:boolean):boolean;
resourcestring
  MSG_BAN = 'Your ban configuration may have been screwed up.'
    +#13'Please verify it.';
var
  l, savedip, build: string;
  warnings: TStringDynArray;
  userIconOfs: integer;

  function yes(s:string=''):boolean;
  begin result:= if_(s>'',s,l)='yes' end;

  function int():int64;
  begin if not tryStrToInt64(l, result) then result:=0 end;

  function real():TdateTime;
  begin try result:=strToFloat(l) except result:=0 end end;

  procedure loadBanlist(s:string);
  var
    p: string;
    i: integer;
  begin
  { old versions wrongly used ; as ban-record separator, while it was already
  { used as address separator }
  if (build < '018') and (pos(';',s) > 0) then
    begin
    s:=xtpl(s,[';','|']);
    addString(MSG_BAN, warnings);
    end;
  setLength(banlist, 0);
  i:=0;
  while s > '' do
    begin
    p:=chop('|',s);
    if p = '' then continue;
    setLength(banlist, i+1);
    banlist[i].comment:=xtpl(p,['\$pipe','|']); // unescape
    banlist[i].ip:=chop('#',banlist[i].comment);
    inc(i);
    end;
  end; // loadBanlist

  function unzipS(s: String): String;
  var
    sa: RawByteString;
  begin
    sa := decodeB64(s);
    try
      result := UTF8ToString(ZDecompressStr(sa));
     except
      Result := UnUTF(sa);
    end;
  end; // unzip

  function unzipA(s: String): RawByteString;
  var
    sa: RawByteString;
  begin
    sa := decodeB64(s);
    try
      result := ZDecompressStr(sa);
     except
      Result := sa;
    end;
  end; // unzip

  procedure strToAccounts();
  var
  	s, t, p: string;
    i: integer;
    a: Paccount;
  begin
  accounts:=NIL;
  while l > '' do
  	begin
    // accounts are separated by semicolons
    s:=chop(';',l);
    if s = '' then continue;
    i:=length(accounts);
    setLength(accounts, i+1);
    a:=@accounts[i];
    a.enabled:=TRUE; // by default
    while s > '' do
      begin
      // account properties are separated by pipes
      t:=chop('|',s);
      p:=chop(':',t); // get property name
      if p = '' then
        continue;
      if p = 'login' then
      	begin
        if not anycharIn(':', t) then
  	      t:=decodeB64utf8(t);
  	    a.user:=chop(':',t);
	      a.pwd:=t;
        end
       else
      if p = 'enabled' then a.enabled:=yes(t)
       else
      if p = 'no-limits' then a.noLimits:=yes(t)
       else
      if p = 'group' then a.group:=yes(t)
       else
      if p = 'redir' then a.redir:=t
       else
      if p = 'link' then a.link:=split(':',t)
       else
      if p = 'notes' then a.notes := unzipS(t);
      end;
    end;
  end; // strToAccounts

  procedure strToIconmasks();
  var
    i: integer;
  begin
  while l > '' do
    begin
    i:=length(iconMasks);
    setLength(iconMasks, i+1);
    iconMasks[i].str:=chop('|',l);
    iconMasks[i].int:=StrToIntDef(chop('||',l),0);
    end;
  end; // strToIconmasks

  procedure readUserIconMasks();
  var
    i, iFrom, iTo: integer;
  begin
  userIconOfs := IconsDM.images.Count;
    while l > '' do
    begin
    iFrom:=strTointDef(chop(':', l), -1);
    iTo:=str2pic(unzipA(chop('|', l)), 16);
    for i:=0 to length(iconMasks)-1 do
      if iconMasks[i].int = iFrom then
        iconMasks[i].int:=iTo;
    end;
  end; // readUserIconmasks

  procedure strToFont(f:Tfont);
  begin
    f.Name:=chop('|', l);
    f.Size:=strToIntDef(chop('|', l), f.size);
    f.Color:=StringToColor(chop('|',l));
    f.Style:=[];
    if pos('B', l) > 0 then f.Style:=f.Style+[fsBold];
    if pos('U', l) > 0 then f.Style:=f.Style+[fsUnderline];
    if pos('I', l) > 0 then f.Style:=f.Style+[fsItalic];
    if pos('S', l) > 0 then f.Style:=f.Style+[fsStrikeout];
  end; // strToFont


  procedure addMissingMimeTypes();
  var
    i: integer;
  begin
  // add missing default mime types
  i:=length(DEFAULT_MIME_TYPES);
  while i > 0 do
    begin
    dec(i, 2);
    if stringExists(DEFAULT_MIME_TYPES[i], mimeTypes) then continue;
    // add the missing pair at the beginning
    addArray(mimeTypes, DEFAULT_MIME_TYPES, 0, i, 2);
    end;
  end;

const
  BOOL2WS: array [boolean] of TWindowState = (wsNormal, wsMaximized);
var
  i: integer;
  h: string;
  activateServer: boolean;
begin
result:=FALSE;
if cfg = '' then exit;

// prior to build #230, this header was required
if ansiStartsStr('HFS ', cfg) then
  begin
  l:=chop(CRLF,cfg);
  chop(' - Build #',l);
  build:=l;
  end
else
  build:=VERSION_BUILD;

warnings:=NIL;
if alreadyStarted then activateServer:=srv.active
else activateServer:=TRUE;

while cfg > '' do
  begin
  l:=chop(CRLF,cfg);
  h:=chop('=',l);
  try
    if h = 'banned-ips' then h:='ban-list';
    if h = 'user-mime-types' then h:='mime-types';  // user-mime-types was an experiment made in build #258..260
    if h = 'save-in-out-totals' then h:='save-totals';

    if h = 'active' then activateServer:=yes;
    if (h = 'window') and (l <> '0,0,0,0') then
    	begin
      lastWindowRect:=strToRect(l);
      boundsRect:=lastWindowRect;
      end;
    if h = 'window-max' then windowstate:=BOOL2WS[yes];
    if h = 'port' then
      if srv.active then changePort(l)
      else port:=l;
    if h = 'ip' then savedip:=l
     else
    if h = 'custom-ip' then customIPs:=split(';',l)
     else
    if h = 'listen-on' then listenOn:=l
     else
    if h = 'dynamic-dns-updater' then dyndns.url:=decodeB64utf8(l)
     else
    if h = 'dynamic-dns-user' then dyndns.user:=l
     else
    if h = 'dynamic-dns-host' then dyndns.host:=l
     else
    if h = 'login-realm' then loginRealm:=l
     else
    if h = 'easy' then setEasyMode(yes)
     else
    if h = 'keep-bak-updating' then keepBakUpdatingChk.checked:=yes;
		if h = 'encode-non-ascii' then encodenonasciiChk.checked:=yes;
		if h = 'encode-spaces' then encodespacesChk.checked:=yes;
		if h = 'search-better-ip' then searchbetteripChk.checked:=yes;
    if h = 'start-minimized' then startMinimizedChk.checked:=yes;
    if h = 'files-box-ratio' then filesBoxRatio:=real;
    if h = 'log-max-lines' then logMaxLines:=int;
    if h = 'log-file-name' then logFile.filename:=l;
    if h = 'log-font-name' then logFontName:=l;
    if h = 'log-font-size' then logFontSize:=int;
    if h = 'log-date' then LogdateChk.checked:=yes;
    if h = 'log-time' then LogtimeChk.checked:=yes;
    if h = 'log-read-only' then logbox.readonly:=yes;
    if h = 'log-browsing' then logBrowsingChk.checked:=yes;
    if h = 'log-icons' then logIconsChk.checked:=yes;
    if h = 'log-progress' then logProgressChk.checked:=yes;
    if h = 'log-banned' then logBannedChk.checked:=yes;
    if h = 'log-others' then logOtherEventsChk.checked:=yes;
    if h = 'log-dump-request' then DumprequestsChk.checked:=yes;
    if h = 'log-server-start' then logServerstartChk.checked:=yes;
    if h = 'log-server-stop' then logServerstopChk.checked:=yes;
    if h = 'log-connections' then logConnectionsChk.checked:=yes;
    if h = 'log-disconnections' then logDisconnectionsChk.checked:=yes;
    if h = 'log-bytes-sent' then logBytessentChk.checked:=yes;
    if h = 'log-bytes-received' then logBytesreceivedChk.checked:=yes;
    if h = 'log-replies' then logRepliesChk.checked:=yes;
    if h = 'log-requests' then logRequestsChk.checked:=yes;
    if h = 'log-uploads' then logUploadsChk.checked:=yes;
    if h = 'log-deletions' then logDeletionsChk.checked:=yes;
    if h = 'log-full-downloads' then logFulldownloadsChk.checked:=yes;
    if h = 'log-apache-format' then logfile.apacheFormat:=l;
    if h = 'log-only-served' then logOnlyServedChk.checked:=yes;
    if h = 'log-to-screen' then logOnVideoChk.checked:=yes;
    if h = 'log-file-tabbed' then tabOnLogFileChk.checked:=yes;
    if h = 'confirm-exit' then confirmexitChk.checked:=yes;
    if h = 'backup-saving' then backupSavingChk.checked:=yes;
    if h = 'connections-height' then lastGoodConnHeight:=int;
    if h = 'files-stay-flagged-for-minutes'then filesStayFlaggedForMinutes:=int;
    if h = 'folders-before' then foldersbeforeChk.checked:=yes;
    if h = 'include-pwd-in-pages' then pwdInPagesChk.Checked:=yes;
    if h = 'minimize-to-tray' then MinimizetotrayChk.checked:=yes;
    if h = 'prevent-standby' then preventStandbyChk.checked:=yes;
		if h = 'use-system-icons' then usesystemiconsChk.checked:=yes;
    if h = 'quit-dont-ask' then quitWithoutAskingToSaveChk.checked:=yes;
		if h = 'auto-save-options' then autosaveoptionsChk.checked:=yes;
    if h = 'use-comment-as-realm' then usecommentasrealmChk.checked:=yes;
    if h = 'persistent-connections'then persistentconnectionsChk.checked:=yes;
		if h = 'show-main-tray-icon' then showmaintrayiconChk.checked:=yes;
    if h = 'delete-dont-ask' then deleteDontAskChk.checked:=yes;
	  if h = 'tray-icon-for-each-download' then trayfordownloadChk.checked:=yes;
    if h = 'copy-url-on-addition' then AutocopyURLonadditionChk.checked:=yes;
    if h = 'copy-url-on-start' then autocopyURLonstartChk.checked:=yes;
    if h = 'enable-macros' then enableMacrosChk.checked:=yes;
    if h = 'update-daily' then updateDailyChk.checked:=yes;
    if h = 'tray-instead-of-quit' then trayInsteadOfQuitChk.checked:=yes;
    if h = 'modal-options' then modalOptionsChk.checked:=yes;
    if h = 'beep-on-flash' then beepChk.checked:=yes;
    if h = 'prevent-leeching' then preventLeechingChk.checked:=yes;
    if h = 'list-hidden-files' then listfileswithhiddenattributeChk.checked:=yes;
    if h = 'list-system-files' then listfileswithsystemattributeChk.checked:=yes;
    if h = 'list-protected-items' then hideProtectedItemsChk.checked:=yes;
    if h = 'always-on-top' then alwaysontopChk.checked:=yes;
    if h = 'support-descript.ion' then supportDescriptionChk.Checked:=yes;
    if h = 'oem-descript.ion' then oemForIonChk.checked:=yes;
    if h = 'oem-tar' then oemTarChk.checked:=yes;
    if h = 'free-login' then freeLoginChk.checked:=yes;
    if h = 'https-url' then httpsUrlsChk.checked:=yes;
    if h = 'enable-fingerprints' then fingerprintsChk.checked:=yes;
    if h = 'save-fingerprints' then saveNewFingerprintsChk.checked:=yes;
    if h = 'auto-fingerprint' then setAutoFingerprint(int);
    if h = 'log-toolbar-expanded' then setLogToolbar(yes);
    if h = 'last-update-check' then lastUpdateCheck:=real;
    if h = 'recursive-listing' then recursiveListingChk.checked:=yes;
    if h = 'enable-no-default' then enableNoDefaultChk.checked:=yes;
    if h = 'browse-localhost' then browseUsingLocalhostChk.checked:=yes;
    if h = 'tpl-file' then tplFilename:=l;
    if h = 'tpl-editor' then tplEditor:=l;
    if h = 'add-folder-default' then addFolderDefault:=l;
    if h = 'default-sorting' then defSorting:=l;
    if h = 'last-dialog-folder' then lastDialogFolder:=l;
    if h = 'send-hfs-identifier' then sendHFSidentifierChk.checked:=yes;
		if h = 'auto-save-vfs' then autosaveVFSchk.checked:=yes;
    if h = 'add-to-folder' then addToFolder:=l;
    if h = 'getright-template' then DMbrowserTplChk.checked:=yes;
		if h = 'speed-limit' then setSpeedLimit(real);
		if h = 'speed-limit-ip' then setSpeedLimitIP(real);
    if h = 'no-download-timeout' then setNoDownloadTimeout(int);
    if h = 'connections-timeout' then connectionsInactivityTimeout:=int;
    if h = 'max-ips' then setMaxIPs(int);
    if h = 'max-ips-downloading' then setMaxIPsDLing(int);
    if h = 'max-connections' then setMaxConnections(int);
    if h = 'max-connections-by-ip' then setMaxConnectionsIP(int);
    if h = 'max-contemporary-dls' then setMaxDLs(int);
    if h = 'max-contemporary-dls-ip' then setMaxDLsIP(int);
		if h = 'tray-message' then trayMsg:=xtpl(unescapeNL(l), [CRLF, trayNL]);
    if h = 'ban-list' then loadBanlist(l);
    if h = 'no-reply-ban' then noReplyBan:=yes;
    if h = 'save-totals' then saveTotalsChk.checked:=yes;
    if h = 'allowed-referer' then allowedReferer:=l;
    if h = 'open-in-browser' then openInBrowser:=l;
		if h = 'last-file-open' then lastFileOpen:=l;
		if h = 'reload-on-startup' then reloadonstartupChk.checked:=yes;
    if h = 'stop-spiders' then stopSpidersChk.checked:=yes;
    if h = 'find-external-on-startup' then findExtOnStartupChk.checked:=yes;
    if h = 'dont-include-port-in-url' then noPortInUrlChk.checked:=yes;
    if h = 'tray-shows' then trayshows:=strToTrayShow(l);
    if h = 'auto-save-vfs-every' then setAutosave(autosaveVFS, int);
    if h = 'external-ip-server' then customIPservice:=l;
    if h = 'only-1-instance' then only1instanceChk.checked:=yes;
		if h = 'graph-rate' then setGraphRate(int);
		if h = 'graph-size' then graph.size:=int;
    if h = 'forwarded-mask' then forwardedMask:=ifThen(l='127.0.0.1','::1;127.0.0.1',l)
     else
    if h = 'delete-partial-uploads' then deletePartialUploadsChk.checked:=yes;
    if h = 'rename-partial-uploads' then renamePartialUploads:=l;
    if h = 'do-not-log-address' then dontLogAddressMask:=l;
    if h = 'out-total' then outTotalOfs:=int;
    if h = 'in-total' then inTotalOfs:=int;
    if h = 'hits-total' then hitsLogged:=int;
    if h = 'downloads-total' then downloadsLogged:=int;
    if h = 'upload-total' then uploadsLogged:=int;
    if h = 'min-disk-space' then minDiskSpace:=int;
    if h = 'flash-on' then flashOn:=l;
    if h = 'last-external-address' then dyndns.lastIP:=l;
    if h = 'recents' then recentFiles:=split(';',l);   // legacy: moved to recent-files because the split-char changed in #111
    if h = 'recent-files' then recentFiles:=split('|',l);
    if h = 'trusted-files' then trustedFiles:=split('|',l);
    if h = 'ips-ever-connected' then ipsEverConnected.DelimitedText:=l;
    if h = 'mime-types' then mimeTypes:=split('|',l);
    if h = 'in-browser-if-mime' then inBrowserIfMIME:=yes;
    if h = 'address2name' then address2name:=split('|',l);
    if h = 'compressed-browsing' then compressedbrowsingChk.checked:=yes;
    if h = 'hints4newcomers' then HintsfornewcomersChk.checked:=yes;
    if h = 'tester-updates' then testerUpdatesChk.checked:=yes;
    if h = 'number-files-on-upload' then numberFilesOnUploadChk.checked:=yes;
    if h = 'many-items-warning' then warnManyItems:=yes;
    if h = 'load-single-comment-files' then loadSingleCommentsChk.checked:=yes;
    if h = 'accounts' then strToAccounts();
    if h = 'use-iso-date-format' then useISOdateChk.Checked:=yes;
    if h = 'auto-comment' then autoCommentChk.checked:=yes;
    if h = 'icon-masks-user-images' then readUserIconMasks();
    if h = 'icon-masks' then strToIconmasks();
    if h = 'connections-columns' then serializedConnColumns:=l;
    if h = 'ip-services' then IPservices:=split(';', l);
    if h = 'ip-services-time' then IPservicesTime:=real;
    if h = 'update-automatically' then updateAutomaticallyChk.checked:=yes;
    if h = 'delayed-update' then delayUpdateChk.checked:=yes;
    if h = 'links-before' then linksBeforeChk.checked:=yes;
    if h = 'account-notes-wrap' then optionsFrm.notesWrapChk.checked:=yes;

		if h = 'graph-visible' then
      if yes then showGraph()
      else hideGraph();
    // extra commands for external use
    if h = 'load-tpl-from' then setNewTplFile(l);
  except end;
  end;

if not alreadyStarted then
  // i was already seeing all the stuff, so please don't hide it
  if (build > '') and (build < '006') then easyMode:=FALSE;

if not alreadyStarted
and not saveTotalsChk.checked then
  begin
  outTotalOfs:=0;
  inTotalOfs:=0;
  hitsLogged:=0;
  downloadsLogged:=0;
  uploadsLogged:=0;
  end;
findSimilarIP(savedIP);
if lastGoodLogWidth > 0 then
  logBox.Width:=lastGoodLogWidth;
if lastGoodConnHeight > 0 then
  connPnl.Height:=lastGoodConnHeight;
if not fileExists(tplFilename) then
  setTplText();
srv.persistentConnections:=persistentconnectionsChk.Checked;
applyFilesBoxRatio();
updateRecentFilesMenu();
keepTplUpdated();
updateAlwaysOnTop();
applyISOdateFormat();
// the filematch() would be fooled by spaces, so lets trim
for i:=0 to length(MIMEtypes)-1 do
  MIMEtypes[i]:=trim(MIMEtypes[i]);

addMissingMimeTypes();
for i:=0 to length(warnings)-1 do
  msgDlg(warnings[i], MB_ICONWARNING);
if alreadyStarted then
  if activateServer <> srv.active then toggleServer()
  else
else
  if activateServer then startServer();
result:=TRUE;

updateCurrentCFG();
end; // setcfg

function loadCfg(var ini,tpl:string):boolean;

  // until 2.2 the template could be kept in the registry, so we need to move it now.  
  // returns true if the registry source can be deleted
  function moveLegacyTpl(tpl:string):boolean;
  begin
  result:=FALSE;
  if (tplFilename > '') or (tpl = '') then exit;
  tplFilename:=cfgPath+TPL_FILE;
  result := saveFileU(tplFilename, tpl);
  end; // moveLegacyTpl

begin
result:=TRUE;
ipsEverConnected.text:=UnUTF(loadfile(IPS_FILE));
ini:=UnUTF(loadFile(cfgPath+CFG_FILE));
if ini > '' then
  begin
  saveMode:=SM_FILE;
  moveLegacyTpl(UnUTF(loadFile(cfgPath+TPL_FILE)));
  exit;
  end;
ini:=loadregistry(CFG_KEY, '');
if ini > '' then
  begin
  saveMode:=SM_USER;
  if moveLegacyTpl(loadregistry(CFG_KEY, TPL_FILE)) then
    deleteRegistry(CFG_KEY, TPL_FILE);
  exit;
  end;
ini:=loadregistry(CFG_KEY, '', HKEY_LOCAL_MACHINE);
if ini > '' then
  begin
  saveMode:=SM_SYSTEM;
  if moveLegacyTpl(loadregistry(CFG_KEY, TPL_FILE, HKEY_LOCAL_MACHINE)) then
    deleteRegistry(CFG_KEY, TPL_FILE, HKEY_LOCAL_MACHINE);
  exit;
  end;
result:=FALSE;
end; // loadCfg

procedure TmainFrm.Viewhttprequest1Click(Sender: TObject);
var
  cd: TconnData;
begin
cd:=selectedConnection();
if cd = NIL then exit;
msgDlg(UnUTF(first([cd.conn.request.full, cd.conn.getBuffer(), RawByteString('(empty)')])));
end;

procedure TmainFrm.connmenuPopup(Sender: TObject);
var
  bs,          // is there any connection selected?
  ba: boolean; // is there any connection listed and connected?
  i: integer;
  cd: TconnData;
begin
  cd:=selectedConnection();
  bs:=assigned(cd);
  ba:=FALSE;
  for i:=0 to connBox.items.count-1 do
    if conn2data(i).conn.state <> HCS_DISCONNECTED then
      begin
      ba:=TRUE;
      break;
      end;
  Viewhttprequest1.enabled:=bs;
  BanIPaddress1.enabled:=bs;
  Kickconnection1.Enabled:=bs and (cd.conn.state <> HCS_DISCONNECTED);
  KickIPaddress1.Enabled:=bs and ba;
  Kickallconnections1.Enabled:=ba;
  Kickidleconnections1.Enabled:=ba;
  pause1.visible:=bs and isDownloading(cd);
  Pause1.Checked:=bs and cd.conn.paused;

  trayiconforeachdownload1.visible:=trayfordownloadChk.Checked and fromTray;
  AddIPasreverseproxy1.Visible := bs and (cd.conn.getHeader('x-forwarded-for') > '');
end;

function expandAccountByLink(a: Paccount; noGroups: boolean=TRUE): TstringDynArray;
var
  i: integer;
begin
result:=NIL;
if a = NIL then exit;

if not (a.group and noGroups) then
  addString(a.user, result);
if length(accounts)>0 then
for i:=0 to length(accounts)-1 do
  if not stringExists(accounts[i].user, result)
  and stringExists(a.user, accounts[i].link) then
    addArray(result, expandAccountByLink(@accounts[i]));
uniqueStrings(result);
end; // expandAccountByLink

function expandAccountsByLink(users:TStringDynArray; noGroups:boolean=TRUE):TstringDynArray;
var
  i: integer;
begin
result:=NIL;
for i:=0 to length(users)-1 do
  addArray(result, expandAccountByLink(getAccount(users[i], TRUE)));
uniqueStrings(result);
end; // expandAccountsByLink

procedure makeOwnerDrawnMenu(mi:Tmenuitem; included:boolean=FALSE);
var
  i: integer;
begin
  if included then
    begin
    mi.onDrawItem:=mainfrm.menuDraw;
    mi.OnMeasureItem:=mainfrm.menuMeasure;
    end;
  for i:=0 to mi.count-1 do
    makeOwnerDrawnMenu(mi.items[i], TRUE);
end; // makeOwnerDrawnMenu

procedure TmainFrm.filemenuPopup(Sender: TObject);
const
  ONLY_ANY = 0;
  ONLY_EASY = 1;
  ONLY_EXPERT = 2;
var
  anyFileSelected: boolean;
//  i: integer;
  f: Tfile;
  a: TStringDynArray;

  function onlySatisfied(only:integer):boolean;
  begin
  result:=(only=ONLY_ANY)
    or (only=ONLY_EASY) and easyMode
    or (only=ONLY_EXPERT) and not easyMode
  end; // onlySatisfied

  procedure visibleAs(mi:Tmenuitem; other:Tmenuitem; only:integer=ONLY_ANY);
  begin mi.visible:=other.visible and onlySatisfied(only) end;

  procedure visibleIf(mi:Tmenuitem; should:boolean; only:integer=ONLY_ANY);
  begin if should then
    mi.visible:=TRUE and onlySatisfied(only) end;

  procedure checkedIf(mi:Tmenuitem; should:boolean);
  begin if should then mi.checked:=TRUE end;

  procedure enabledIf(mi:Tmenuitem; should:boolean);
  begin if should then mi.enabled:=TRUE end;

  procedure setDefaultValues(mi:TmenuItem);
  var
    i: integer;
  begin
  for i:=0 to mi.count-1 do
    begin
    mi[i].visible:=FALSE;
    mi[i].enabled:=TRUE;
    mi[i].checked:=FALSE;
    end;
  end; // setDefaultValues

  function itemsVisible(mi:TmenuItem):integer;
  var
    i: integer;
  begin
  result:=0;
  for i:=0 to mi.count-1 do
    if mi.Items[i].visible then
      inc(result);
  end; // itemsVisible

begin
// default values
setDefaultValues(filemenu.items);
Addfiles1.visible:=TRUE;
Addfolder1.visible:=TRUE;
Properties1.visible:=TRUE;

anyFileSelected:=selectedFile<>NIL;
newfolder1.visible:=not anyFileSelected
  or ((filesBox.SelectionCount=1) and selectedFile.isFolder());
Setuserpass1.visible:=anyFileSelected;
CopyURL1.visible:=anyFileSelected;

visibleIf(Bindroottorealfolder1, (filesBox.SelectionCount=1) and selectedFile.isRoot() and selectedFile.isVirtualFolder(), ONLY_EXPERT);
visibleIf(Unbindroot1, (filesBox.SelectionCount=1) and selectedFile.isRoot() and selectedFile.isRealFolder(), ONLY_EXPERT);

  if filesBox.SelectionCount > 0 then
   for var i:=0 to filesBox.SelectionCount-1 do
     begin
      f:=filesBox.selections[i].data;
      visibleIf(setURL1, FA_LINK in f.flags);
      visibleIf(Remove1, not f.isRoot());
      visibleIf(Flagasnew1, not f.isNew() and (filesStayFlaggedForMinutes>0));
      visibleIf(Resetnewflag1, f.isNew() and (filesStayFlaggedForMinutes>0));
      visibleIf(SwitchToVirtual1, f.isRealFolder() and not f.isRoot(), ONLY_EXPERT);
      visibleIf(SwitchToRealfolder1, f.isVirtualFolder() and not f.isRoot() and (f.resource > ''), ONLY_EXPERT);
      visibleIf(Resetuserpass1, f.user>'');
      visibleIf(CopyURLwithfingerprint1, f.isFile(), ONLY_EXPERT);
     end;
visibleAs(newlink1, newfolder1, ONLY_EXPERT);
visibleIf(purge1, anyFileSelected, ONLY_EXPERT);

if filesBox.SelectionCount = 1 then
  begin
  f:=selectedFile;
  visibleIf(Defaultpointtoaddfiles1, f.isFolder(), ONLY_EXPERT);
  visibleIf(Editresource1, not (FA_VIRTUAL in f.flags), ONLY_EXPERT);
  visibleAs(rename1, remove1);
  visibleIf(openit1, not f.isVirtualFolder());
  visibleIf(browseIt1, TRUE, ONLY_EXPERT);
  paste1.visible:=clipboard.HasFormat(CF_HDROP);

  a:=NIL;
  if anyFileSelected then
    a:=expandAccountsByLink(selectedFile.getAccountsFor(FA_ACCESS, TRUE))
      +expandAccountsByLink(selectedFile.getAccountsFor(FA_UPLOAD, TRUE))
      +expandAccountsByLink(selectedFile.getAccountsFor(FA_DELETE, TRUE));
  visibleIf(CopyURLwithpassword1, assigned(a), ONLY_EXPERT);
  copyURLwithpassword1.Clear();
  uniqueStrings(a, FALSE);
  for var s in a do
    copyURLwithpassword1.add( newItem( s, 0, FALSE, TRUE, copyURLwithPasswordMenuClick, 0, '') );
  end;

a:=getPossibleAddresses();
if length(a) = 1 then a:=NIL;
visibleIf(CopyURLwithdifferentaddress1, anyFileSelected and assigned(a), ONLY_EXPERT);
copyURLwithdifferentaddress1.clear();
for var s in a do
  copyURLwithdifferentaddress1.add( newItem( s, 0, FALSE, TRUE, copyURLwithAddressMenuclick, 0, '') );

end;

function Tmainfrm.saveCFG():boolean;

  procedure proposeUserRegistry();
  resourcestring
    MSG_CANT_SAVE_OPT = 'Can''t save options there.'
      +#13'Should I try to save to user registry?';
  begin
  if msgDlg(MSG_CANT_SAVE_OPT, MB_ICONERROR+MB_YESNO) = IDYES then
    begin
    saveMode:=SM_USER;
    saveCFG();
    end;
  end; // proposeUserRegistry

var
  cfg: string;
begin
result:=FALSE;
if srv = NIL then exit;
if quitting and (backuppedCfg > '') then
  cfg:=backuppedCfg
else
  cfg:=getCfg();
case saveMode of
	SM_FILE:
  	begin
    if not savefileU(cfgPath+CFG_FILE, cfg) then
      begin
      proposeUserRegistry();
      exit;
      end;
    result:=TRUE;
    end;
  SM_SYSTEM:
  	begin
    deleteFile(cfgPath+CFG_FILE);
    deleteRegistry(CFG_KEY);
    if not saveregistry( CFG_KEY, '', cfg, HKEY_LOCAL_MACHINE ) then
      begin
      proposeUserRegistry();
      exit;
      end;
    result:=TRUE;
    end;
  SM_USER:
  	begin
    deleteFile(cfgPath+CFG_FILE);
    result:=saveregistry(CFG_KEY, '', cfg);
    end;
  end;
if ipsEverConnected.Count >= IPS_THRESHOLD  then
  saveFileU(IPS_FILE, ipsEverConnected.text)
else
  deleteFile(IPS_FILE);

if result then
  deleteFile(lastUpdateCheckFN);
end; // saveCFG

// this method is called by all "save options" ways
procedure TmainFrm.tofile1Click(Sender: TObject);
begin
if sender = tofile1 then saveMode:=SM_FILE
else if sender = toregistrycurrentuser1 then saveMode:=SM_USER
else if sender = toregistryallusers1 then saveMode:=SM_SYSTEM
else exit;

if saveCFG() then
  msgDlg(MSG_OPTIONS_SAVED);
end;

procedure TmainFrm.About1Click(Sender: TObject);
const
  copyright = 'HFS version %s'
  +#13'Copyright (C) 2002-2020  Massimo Melina (www.rejetto.com)'
  +#13#13'HFS comes with ABSOLUTELY NO WARRANTY under the license GNU GPL 3.0. For details click Menu -> Web links -> License'
  +#13'This is FREE software, and you are welcome to redistribute it under certain conditions.'
  +#13#13'Build #%s';
begin msgDlg(format(copyright, [srvConst.VERSION,VERSION_BUILD + ' ' + DateTimeToStr(BuiltTime)])) end;

procedure Tmainfrm.purgeConnections();
var
  i: integer;
  data: TconnData;
begin
i:=0;
  if toDelete.Count > 0 then
while i < toDelete.Count do
  begin
  data:=toDelete[i];
  inc(i);
  if data = NIL then continue;
  if assigned(data.conn) and data.conn.dontFree then continue;
  toDelete[i-1]:=NIL;
  setupDownloadIcon(data);
  data.lastFile:=NIL; // auto-freeing

  if assigned(data.limiter) then
    begin
    srv.limiters.remove(data.limiter);
    freeAndNIL(data.limiter);
    end;
  freeAndNIL(data.conn);
  try freeAndNIL(data) except end;
  end;
toDelete.clear();
end; // purgeConnections

function Tmainfrm.recalculateGraph(): Boolean;
var
  i: integer;
begin
  Result := False;
if (srv = NIL) or quitting then exit;
// shift samples
i:=sizeOf(graph.samplesOut)-sizeOf(graph.samplesOut[0]);
move(graph.samplesOut[0], graph.samplesOut[1], i);
move(graph.samplesIn[0], graph.samplesIn[1], i);
// insert new "out" sample
graph.samplesOut[0]:=srv.bytesSent-graph.lastOut;
graph.lastOut:=srv.bytesSent;
// insert new "in" sample
graph.samplesIn[0]:=srv.bytesReceived-graph.lastIn;
graph.lastIn:=srv.bytesReceived;
// increase the max value
i:=max(graph.samplesOut[0], graph.samplesIn[0]);
if i > graph.maxV then
  begin
  graph.maxV:=i;
  graph.beforeRecalcMax:=100;
  end;
Result := graph.maxV <> 0;
dec(graph.beforeRecalcMax);
if graph.beforeRecalcMax > 0 then exit;
// recalculate max value
graph.maxV:=0;
with graph do
  for i:=0 to length(samplesOut)-1 do
    maxV:=max(maxV, max(samplesOut[i], samplesIn[i]) );
graph.beforeRecalcMax:=100;
  Result := True;
end; // recalculateGraph

// parse the version-dependant notice
procedure parseVersionNotice(s:string);
var
  l, msg: string;
begin
while s > '' do
  begin
  l:=trim(chopLine(s));
  // the line has to start with a @ followed by involved versions
  if (length(l) < 2) or (l[1] <> '@') then continue;
  delete(l,1,1);
  // collect the message (until next @-starting line)
  msg:='';
  while (s > '') and (s[1] <> '@') do
    msg:=msg+chopLine(s)+#13;
  // before 2.0 beta14 a bare semicolon-separated string comparison was used
  if filematch(l, srvConst.VERSION) or filematch(l, '#'+VERSION_BUILD) then
    msgDlg(msg, MB_ICONWARNING);
  end;
end; // parseVersionNotice

function doTheUpdate(url:string):boolean;
resourcestring
  MSG_UPD_SAVE_ERROR = 'Cannot save the update';
  MSG_UPD_REQ_ONLY1 = 'The auto-update feature cannot work because it requires the "Only 1 instance" option enabled.'
    +#13#13'Your browser will now be pointed to the update, so you can install it manually.';
  MSG_UPD_WAIT = 'Waiting for last requests to be served, then we''ll update';
  MSG_UPD_DL = 'Downloading new version...';
const
  UPDATE_BATCH_FILE = 'hfs.update.bat';
  UPDATE_BATCH = 'START %0:s /WAIT "%1:s" -q'+CRLF
    +'ping 127.0.0.1 -n 3 -w 1000> nul'+CRLF // wait
    +'DEL "%3:s'+PREVIOUS_VERSION+'"'+CRLF // previous backup
    +'%2:sMOVE "%1:s" "%3:s'+PREVIOUS_VERSION+'"'+CRLF // new backup
    +'DEL "%1:s"'+CRLF // too zealous?
    +'MOVE "%4:s" "%1:s"'+CRLF // new becomes current
    +'START %0:s "%1:s"'+CRLF
    +'DEL %%0'+CRLF; // remove self
var
  size: integer;
  fn: string;
begin
result:=FALSE;
if not mono.working then
  begin
  msgDlg(MSG_UPD_REQ_ONLY1, MB_ICONWARNING);
  openURL(url);
  exit;
  end;
if mainfrm.delayUpdateChk.checked
and (srv.conns.count > 0) then
  begin
  updateASAP:=url;
  stopServer();
  mainfrm.kickidleconnections1Click(NIL);
  mainfrm.setStatusBarText(MSG_UPD_WAIT, 20);
  exit;
  end;
// must ask BEFORE: when the batch will be running, nothing should stop it, or it will fail
if not checkVfsOnQuit() then exit;
VFSmodified:=FALSE;

progFrm.show(MSG_UPD_DL, TRUE);
try
  fn:=paramStr(0)+'.new';
  size:=sizeOfFile(fn);
  // a previous failed update attempt? avoid re-downloading if not necessary
  if (size <= 0) or (httpFileSize(url) <> size) then
    try
      if not UtilLib.httpGetFileWithCheck(url, fn, 2, mainfrm.progFrmHttpGetUpdate) then
        begin
        if not lockTimerevent then
          msgDlg(MSG_COMM_ERROR, MB_ICONERROR);
        exit;
        end;
    except
      if not lockTimerevent then
        msgDlg(MSG_UPD_SAVE_ERROR, MB_ICONERROR);
      exit;
      end;
finally progFrm.hide() end;
if progFrm.cancelRequested then
  begin
  deleteFile(fn);
  exit;
  end;

try
  progFrm.show(MSG_PROCESSING);
  saveFileU(UPDATE_BATCH_FILE, format(UPDATE_BATCH, [
    if_(isNT(), '""'),
    paramStr(0),
    if_(not mainfrm.keepBakUpdatingChk.checked,'REM '),
    exePath,
    fn
  ]));
  execNew(UPDATE_BATCH_FILE);
  result:=TRUE;
finally progFrm.hide() end;
end; // doTheUpdate

function promptForUpdating(url:string):boolean;
resourcestring
  MSG_UPDATE = 'You are invited to use the new version.'#13#13'Update now?';
begin
result:=FALSE;
if url = '' then exit;
if not mainfrm.updateAutomaticallyChk.checked
and (msgDlg(MSG_UPDATE, MB_YESNO) = IDNO) then
  exit;
doTheUpdate(url);
result:=TRUE;
end; // promptForUpdating

function downloadUpdateInfo():Ttpl;
resourcestring
  MSG_REQUESTING = 'Requesting...';
const
  URL = 'https://www.rejetto.com/hfs/hfs.updateinfo.txt';
  ON_DISK = 'hfs.updateinfo.txt';
resourcestring
  MSG_FROMDISK = 'Update info has been read from local file.'
    +#13'To resume normal operation of the updater, delete the file '
      +ON_DISK+' from the HFS program folder.';
var
  s: RawByteString;
begin
lastUpdateCheck:=now();
saveFileA(lastUpdateCheckFN, '');
fileSetAttr(lastUpdateCheckFN, faHidden);

result:=NIL;
progFrm.show(MSG_REQUESTING);
try
  // this let the developer to test the parsing locally
  if not fileExists(ON_DISK) then
    try
      s := httpGet(URL)
     except
    end
  else
    begin
    s := loadFile(ON_DISK);
    msgDlg(MSG_FROMDISK, MB_ICONWARNING);
    end;
finally progFrm.hide() end;
if pos(RawByteString('[EOF]'), s) = 0 then exit;
result:=Ttpl.create(s);
end; // downloadUpdateInfo

procedure Tmainfrm.autoCheckUpdates();
resourcestring
  MSG_CHK_UPD = 'Checking for updates';
  MSG_CHK_UPD_FAIL = 'Check update: failed';
  MSG_CHK_UPD_HEAD = 'Check update: ';
  MSG_CHK_UPD_VER = 'new version found: %s';
  MSG_CHK_UPD_VER_EXT = 'Build #%s (current is #%s)';
  MSG_CHK_UPD_NONE = 'no new version';
var
  info: Ttpl;
  updateURL, ver, build: string;

  function thereSnew(kind:string):boolean;
  var
    s: string;
  begin
  s:=trim(info['last '+kind+' build']);
  result:=(s > VERSION_BUILD) and (s <> refusedUpdate);
  if not result then exit;
  build:=s;
  updateURL:=trim(info['last '+kind+' url']);
  ver:=trim(info['last '+kind]);
  end;

begin
if (VERSION_STABLE and (now()-lastUpdateCheck < 1))
or (now()-lastUpdateCheck < 1/3) then exit;
setStatusBarText(MSG_CHK_UPD);
try
  info:=downloadUpdateInfo();
  if info = NIL then
    begin
    if logOtherEventsChk.checked then
      add2log(MSG_CHK_UPD_FAIL);
    setStatusBarText(MSG_CHK_UPD_FAIL);
    exit;
    end;
  if not thereSnew('stable')
  and (not VERSION_STABLE or testerUpdatesChk.checked) then
    thereSnew('untested');
  // same version? we show build number
  if ver = srvConst.VERSION then
    ver:=format(MSG_CHK_UPD_VER_EXT, [build, VERSION_BUILD]);
  if logOtherEventsChk.checked then
    add2log(MSG_CHK_UPD_HEAD+ifThen(updateURL = '', MSG_CHK_UPD_NONE, format(MSG_CHK_UPD_VER,[ver])));
  parseVersionNotice(info['version notice']);
  setStatusBarText('');
  if updateURL = '' then exit;
  if updateAutomaticallyChk.checked
  and doTheUpdate(updateURL) then exit;
  // notify the user gently
  updateBtn.show();
  updateWaiting:=updateURL;
  flash();
finally freeAndNIL(info) end;
end; // autoCheckUpdates

procedure loadEvents();
begin
if not newMtime(cfgpath+EVENTSCRIPTS_FILE, eventScriptsLast) then
  exit;
eventScripts.fullText:=loadFile(cfgpath+EVENTSCRIPTS_FILE);
runEventScript(mainFrm.fileSrv, 'init');
end;

procedure Tmainfrm.updateCopyBtn();
resourcestring
  TO_CLIP = 'Copy to clipboard';
  ALREADY_CLIP = 'Already in clipboard';
var
  s: string;
begin
s:=copyBtn.caption;
try
  copyBtn.Caption:=if_(clipboard.asText = urlBox.text, ALREADY_CLIP, TO_CLIP);
  if copyBtn.caption <> s then FormResize(NIL);
except end;
end; // updateCopyBtn

procedure TmainFrm.timerEvent(Sender: TObject);
var
  now_: Tdatetime;

  function itsTimeFor(var t:Tdatetime):boolean;
  begin
  result:=(t > 0) and (t < now_);
  if result then t:=0;
  end; // itsTimeFor

  procedure calculateETA(data:TconnData; current:real; leftOver:int64);
  var
    i, n: integer;
  begin
  data.eta.data[data.eta.idx mod ETA_FRAME]:=current;
  inc(data.eta.idx);

  data.averageSpeed:=0;
  n:=min(data.eta.idx, ETA_FRAME);
  for i:=0 to n-1 do
    data.averageSpeed:=data.averageSpeed+data.eta.data[i];
  data.averageSpeed:=data.averageSpeed/n;

  if data.averageSpeed > 0 then
    data.eta.result:=(leftOver/data.averageSpeed)/SECONDS;
  end; // calculateETA

  procedure every10minutes();
  begin
  if dyndns.url > '' then
    getExternalAddress(externalIP);
  end; // every10minutes

  procedure everyMinute();
  begin
    sessions.checkExpired;
  if updateDailyChk.Checked then
    autoCheckUpdates();
  // purge icons older than 5 minutes, because sometimes icons change
  iconsCache.purge(now_-(5*60)/SECONDS);
  end; // everyMinute

  procedure every10sec();
  var
    s: string;
    ss: TstringDynArray;
    sa: TstringDynArray;
  begin
    sa := getPossibleAddresses();
    s := join(';', sa);
    if (cachedIPs = s) and (defaultIP> '') and stringExists(defaultIP, sa) then
      Exit;
  if not stringExists(defaultIP, sa) then
    // previous address not available anymore (it happens using dial-up)
    findSimilarIP(defaultIP);
    
  if searchbetteripChk.checked
  and not stringExists(defaultIP, customIPs) // we don't mess with custom IPs
  and isLocalIP(defaultIP) then // we prefer non-local addresses
    begin
    s:=getIP();
    if not isLocalIP(s) then // clearly better
      setDefaultIP(s)
    else if ansiStartsStr('169.', defaultIP) then // we consider the 169 worst of other locals
      begin
      ss:=getAcceptOptions();
      if length(ss) > 1 then
        setDefaultIP(ss[ if_(ss[0]=defaultIP, 1, 0) ]);
      end;;
    end;

  end; // every10sec

  procedure everySec();
  var
    i, outside, size: integer;
    data: TconnData;
  begin
    // this is a already done in utilLib initialization, but it's a workaround to http://www.rejetto.com/forum/?topic=7724
      FormatSettings.decimalSeparator:='.';
    // check if the window is outside the visible screen area
    outside:=left;
    if assigned(monitor) then  // checking here because the following line once thrown this AV http://www.rejetto.com/forum/?topic=5568
     begin
      for i:=0 to monitor.MonitorNum do
        dec(outside, screen.monitors[i].width);
      if (outside > 0)
      or (boundsRect.bottom < 0)
      or (boundsRect.right < 0) then
        makeFullyVisible();
     end;

    if dyndns.active and (dyndns.url > '') then
      begin
      if externalIP = '' then
        getExternalAddress(externalIP);
      if not isLocalIP(externalIP) and (externalIP <> dyndns.lastIP)
      or (now()-dyndns.lastTime > 24) then
        updateDynDNS();
      // the action above takes some time, and it can happen we asked to quit in the meantime
      if quitting then exit;
      end;

    // the alt+click shortcut to get file properties will result in an unwanted editing request if the file is already selected. This is a workaround.
    if filesBox.isEditing and assigned(filepropFrm) then
      selectedFile.node.EndEdit(TRUE);

    updateTrayTip();

    if warnManyItems and (filesBox.items.count > MANY_ITEMS_THRESHOLD) then
      begin
      warnManyItems:=FALSE;
      msgDlg(MSG_MANY_ITEMS, MB_ICONWARNING);
      end;

    with autosaveVFS do // we do it only if the filename is already specified
      if (every > 0) and (lastFileOpen > '') and not loadingVFS.disableAutosave
      and ((now_-last)*SECONDS >= every) then
        begin
        last:=now_;
        saveVFS(lastFileOpen);
        end;

    if assigned(srv) and assigned(srv.conns) then
      for i:=0 to srv.conns.count-1 do
        begin
        data:=conn2data(i);
        if data = NIL then continue;

        if isReceivingFile(data) then
          begin
          refreshConn(data); // even if no data is coming, we must update other stats
          calculateETA(data, data.conn.speedIn, data.conn.bytesToPost);
          end;
        if isSendingFile(data) then
          begin
          refreshConn(data);
          calculateETA(data, data.conn.speedOut, data.conn.bytesToSend);

          if userIcsBuffer > 0 then
            data.conn.sock.bufSize:=userIcsBuffer;

          if userSocketBuffer > 0 then
            data.conn.sndBuf:=userSocketBuffer
          else if highSpeedChk.checked then
            begin
            size:=minmax(8192, MEGA, round(data.averageSpeed));
            if safeDiv(0.0+size, data.conn.sndbuf, 2) > 2 then
              data.conn.sndBuf:=size;
            end;
          end;

        // connection inactivity timeout
        if (connectionsInactivityTimeout > 0)
        and ((now_-data.lastActivityTime)*SECONDS >= connectionsInactivityTimeout) then
          data.disconnect('inactivity');
        end;

    // server inactivity timeout
    if noDownloadTimeout > 0 then
      if (now_-lastActivityTime)*SECONDS > noDownloadTimeout*60 then
        quitASAP:=TRUE;

    if windowState = wsNormal then
      lastWindowRect:=mainfrm.boundsRect;

    // update can be put off until there's no one connected
    if (updateASAP > '') and (srv.conns.count = 0) then
      doTheUpdate(clearAndReturn(updateASAP)); // before we call the function, lets clear the request

    updateCopyBtn();
    keepTplUpdated();
    updateCurrentCFG();
    loadEvents();

    if assigned(runScriptFrm) and runScriptFrm.visible
    and runScriptFrm.autorunChk.checked and newMtime(tempScriptFilename, runScriptLast) then
      runScriptFrm.runBtnClick(NIL);

    if Assigned(toAddFingerPrint) and (toAddFingerPrint.count > 0) then
      begin
        var fpFN: String := toAddFingerPrint[0];
        toAddFingerPrint.Delete(0);
        TTask.Create(procedure
        var
          s: String;
        begin
          s := createFingerprint(fpFN, False);
          if s > '' then
            saveFileU(fpFN+'.md5', s);
        end).Start;

      end;

    runTimedEvents(fileSrv);
  end; // everySec

  procedure everyTenth();
  var
    f: Tfile;
    n: Ttreenode;
  begin
  purgeConnections();

  // see the filesBoxEditing event for an explanation of the following lines
  if not filesBox.IsEditing and (remove1.ShortCut = 0) then
    begin
    remove1.ShortCut:=TextToShortCut('Del');
    Paste1.ShortCut:=TextToShortCut('Ctrl+V');
    copyURL1.ShortCut:=TextToShortCut('Ctrl+C');
    end;

  with optionsFrm do
    if active and iconsPage.visible then
      updateIconMap();

  if scrollFilesBox in [SB_LINEUP,SB_LINEDOWN] then
    postMessage(filesBox.Handle, WM_VSCROLL, scrollFilesBox, 0);

  if assigned(filesToAddQ) then
    begin
    f := fileSrv.findFilebyURL(addToFolder, getLP);
    if f = NIL then
      f:=selectedFile;
    if f = NIL then
      n:=NIL
    else
      n:=f.node;
    addFilesFromString(join(CRLF, filesToAddQ), n);
    filesToAddQ:=NIL;
    end;

  if itsTimeFor(searchLogTime) then
    if searchLog(0) then logSearchBox.Color:=clWindow
    else
      begin
      logSearchBox.Color:=BG_ERROR;
      searchLogWhiteTime:=now_+5/SECONDS;
      end;
  if itsTimeFor(searchLogWhiteTime) then
    logSearchBox.Color:=clWindow;

  end; // everyTenth

  function every(tenths:integer):boolean;
  begin result:=not quitting and (clock mod tenths = 0) end;

var
  bak: boolean;
begin
if quitASAP and not quitting and not queryingClose then
  begin
  { close is not effective when lockTimerevent is TRUE, so we force it TRUE.
  { it should not be necessary, but we want to be sure to quit even with bugs. }
  bak:=lockTimerevent;
  lockTimerevent:=FALSE;
  application.MainForm.Close();
  lockTimerevent:=bak;
  end; // quit
if not timer.enabled or quitting or lockTimerevent then exit;
lockTimerevent:=TRUE;
try
  // idk how it can be, but sometimes this now() call causes an AV http://www.rejetto.com/forum/index.php?topic=6371.msg1038634#msg1038634
  try now_:=now()
  except now_:=0 end;
  if now_ = 0 then exit;

  inc(clock);
  if every(1) then everyTenth();
  if every(10*60*10) then every10minutes();
  if every(60*10) then everyMinute();
  if every(10*10) then every10sec();
  if every(10) then everySec();
  if every(STATUSBAR_REFRESH) then
    updateSbar();
  if every(graph.rate) then
    begin
     if recalculateGraph() then
       graphBoxPaint(NIL);
    end;
finally lockTimerevent:=FALSE end;
end; // timerEvent

procedure Tmainfrm.updateSbar();
var
  pn: integer;

  function addPanel(s:string; al:TAlignment=taCenter):integer;
  begin
  result:=pn;
  inc(pn);
  if sbar.Panels.count < pn then sbar.Panels.Add();
  with sbar.panels[pn-1] do
    begin
    alignment:=al;
    Text:=s;
    width:=sbar.Canvas.TextWidth(s)+20;
    end;
  end; // addPanel

  procedure checkDiskSpace();
  resourcestring
    MSG_NO_SPACE = 'Out of space';
  type
    Tdrive = 1..26;
  var
    i: integer;
    drives: set of Tdrive;
    driveLetters: TStringDynArray;
    driveLetter: char;
  begin
  if minDiskSpace <= 0 then exit;
  drives:=[];
  i:=0;
  while i < length(uploadPaths) do
    begin
    include(drives, filenameToDriveByte(uploadPaths[i]));
    inc(i);
    end;
  driveLetters:=NIL;
  for i:=low(Tdrive) to high(Tdrive) do
    if i in drives then
      begin
      driveLetter:=chr(i+ord('A')-1);
      if not sysutils.directoryExists(driveLetter+':\') then continue;
      if diskfree(i) div MEGA <= minDiskSpace then
        addString(driveLetter, driveLetters);
      end;
  if driveLetters = NIL then exit;
  sbarIdxs.oos:=addPanel( MSG_NO_SPACE+': '+join(',', driveLetters));
  end; // checkDiskSpace

  function getConnectionsString():string;
  resourcestring
    CONN = 'Connections: %d';
  var
    i: integer;
  begin
  result:=format(CONN, [srv.conns.Count]);
  if easyMode then exit;
  i:=countIPs();
  if i < srv.conns.count then result:=result+' / '+intToStr(i);
  end;

resourcestring
  TOT_IN = 'Total In: %s';
  TOT_OUT = 'Total Out: %s';
  OUT_SPEED = 'Out: %.1f KB/s';
  IN_SPEED = 'In: %.1f KB/s';
  BANS = 'Ban rules: %d';
  MEMORY = 'Mem';
  stack = 'Stack';
  CUST_TPL = 'Customized template';
  VFS_ITEMS = 'VFS: %d items';
  ITEMS_NS = 'VFS: %d items - not saved';
var
  tempText: string;
begin
  if quitting then exit;
  FillMemory(@sbarIdxs, sizeOf(sbarIdxs), Byte(-1));
if sbarTextTimeout < now() then tempText:=''
else tempText:=sbar.Panels[sbar.Panels.Count-1].text;
pn:=0;
if not easyMode then
  addPanel( getConnectionsString() );
sbarIdxs.out:=addPanel( format(OUT_SPEED,[srv.speedOut/1000]) );
addPanel( format(IN_SPEED,[srv.speedIn/1000]) );
if not easyMode then
  begin
  sbarIdxs.totalOut:=addPanel( format(TOT_OUT,[
    smartSize(outTotalOfs+srv.bytesSent)]) );
  sbarIdxs.totalIn:=addPanel( format(TOT_IN,[
    smartSize(inTotalOfs+srv.bytesReceived)]) );
  sbarIdxs.notSaved:=addPanel( format(if_(VFSmodified, ITEMS_NS, VFS_ITEMS),[filesBox.items.count-1]));
  if not vFsmodified then sbarIdxs.notSaved:=-1;
  end;
checkDiskSpace();

if showMemUsageChk.checked then
  begin
    addPanel(MEMORY+': '+dotted(allocatedMemory()));
    addPanel(Stack +': '+dotted(currentStackUsage()));
  end;

if assigned(banlist) then
  sbarIdxs.banStatus:=addPanel(format(BANS, [length(banlist)]));

if tplIsCustomized then sbarIdxs.customTpl:=addPanel(CUST_TPL);

// if tempText empty, ensures a final panel terminator
addPanel(tempText, taLeftJustify);

// delete excess panels
while sbar.Panels.count > pn do sbar.Panels.delete(pn);
end; // updateSbar

procedure Tmainfrm.refreshIPlist();
CONST
  INDEX_FOR_URL = 2;
//  INDEX_FOR_NIC = 1;
  INDEX_FOR_NIC = 2;
var
  a: TStringDynArray;
  a6: TStringDynArray;
  i: integer;
begin
while IPaddress1.Items[INDEX_FOR_URL].Caption <> '-' do
  IPaddress1.delete(INDEX_FOR_URL);
// fill 'IP address' menu
a:=getPossibleAddresses();
for i:=0 to length(a)-1 do
  mainfrm.IPaddress1.Insert(INDEX_FOR_URL,
    newItem(a[i], 0, a[i]=defaultIP, TRUE, ipmenuclick, 0, '') );

// fill 'Accept connections on' menu
while Acceptconnectionson1.count > INDEX_FOR_NIC  do
  Acceptconnectionson1.delete(INDEX_FOR_NIC);

// IPv6
AnyaddressV6.checked:= listenOn = '[*]';
  a6 := listToArray(localIPlist(sfIPv6));
  addUniqueString('::1', a6);
  if length(a6) > 0 then
   for i:=0 to length(a6)-1 do
    Acceptconnectionson1.Insert(INDEX_FOR_NIC,
      newItem( '[' + a6[i] + ']', 0,
              ((a6[i]=listenOn)or (('[' + a6[i] + ']') = listenOn)),
              TRUE, acceptOnMenuclick, 0, '') );
//IPv4
Anyaddress1.checked:= listenOn = '';
a:=listToArray(localIPlist);
addUniqueString('127.0.0.1', a);
for i:=0 to length(a)-1 do
  Acceptconnectionson1.Insert(INDEX_FOR_NIC,
    newItem( a[i], 0, a[i]=listenOn, TRUE, acceptOnMenuclick, 0, '') );
end; // refreshIPlist

procedure TmainFrm.filesBoxDblClick(Sender: TObject);
begin
if assigned(selectedFile) then setClip(fileSrv.fullURL(selectedFile));
updateUrlBox();
end;

procedure fileMenuSetFlag(sender:Tobject; flagToSet:TfileAttribute; filter:TfilterMethod=NIL; negateFilter:boolean=FALSE; recursive:boolean=FALSE; f:Tfile=NIL);
// parameter "f" is designed to be set only inside this function
var
  newState: boolean;

  procedure applyTo(f:Tfile);
  var
    n: TtreeNode;
  begin
  n:=f.node.getFirstChild();
  while assigned(n) do
    begin
    if assigned(n.data) then fileMenuSetFlag(sender, flagToSet, filter, negateFilter, TRUE, n.data);
    n:=n.getNextSibling();
    end;

  if assigned(filter) and (negateFilter = filter(f)) then exit;
  if (flagToSet in f.flags) = newState then exit;
  VFSmodified:=TRUE;
  if newState then include(f.flags, flagToSet)
  else exclude(f.flags, flagToSet);
  end; // applyTo

var
  i: integer;
begin
  if (f = NIL) and (mainFrm.selectedFile = NIL) then
    exit;
  newState := not (sender as TmenuItem).checked;
  if assigned(f) then
    applyTo(f)
   else
    begin
      if mainFrm.filesBox.SelectionCount > 0 then
      for i:=0 to mainFrm.filesBox.SelectionCount-1 do
        applyTo(mainFrm.filesBox.Selections[i].data);
      mainFrm.filesBox.Repaint();
    end;
end;

procedure TmainFrm.HideClick(Sender: TObject);
begin
graphBox.Hide();
graphSplitter.Hide();
end;

procedure TmainFrm.filesBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin filesBox.Selected:=filesbox.GetNodeAt(x,y) end;

procedure setFilesBoxExtras(v:boolean);
begin
{ let disable this silly feature for now
if winVersion <> WV_VISTA then exit;
with mainfrm.filesBox do
  begin
  if isEditing then exit;
  ShowButtons:=v;
  ShowLines:=v;
  end;}
end; // setFilesBoxExtras

procedure TmainFrm.filesBoxMouseEnter(Sender: TObject);
begin
with filesBox do setFilesBoxExtras(TRUE);
end;

procedure TmainFrm.filesBoxMouseLeave(Sender: TObject);
begin
with filesBox do setFilesBoxExtras(focused);
end;

procedure TmainFrm.filesBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if (shift = [ssAlt]) and (button = mbLeft) then
  Properties1.click();
end;

procedure TmainFrm.filesBoxCompare(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
var
  f1, f2: Tfile;
begin
f1:=Tfile(node1.data);
f2:=Tfile(node2.data);
if (f1 = NIL) or (f2 = NIL) then exit;
if not foldersbeforeChk.checked or (f1.isFolder() = f2.isFolder()) then
  compare:=ansiCompareText(f1.name, f2.name)
else
  if f1.isFolder() then compare:=-1
  else compare:=+1;
end;

procedure TmainFrm.foldersbeforeChkClick(Sender: TObject);
var
  n: TTreeNode;
begin
  n := fileSrv.getRootNode;
  n.AlphaSort(TRUE)
end;

procedure browse(url:string);
begin
if mainfrm.browseUsingLocalhostChk.Checked then
  begin
  chop('//',url);
  chop('/',url);
  url:='http://localhost:'+srv.port+'/'+url;
  end;
openURL(url);
end; // browse

procedure TmainFrm.Browseit1Click(Sender: TObject);
begin
if selectedFile = NIL then exit;
if selectedFile.isLink() then openURL(fileSrv.url(selectedfile))
else browse(fileSrv.fullURL(selectedfile))
end;

procedure TmainFrm.Openit1Click(Sender: TObject);
begin
if selectedFile = NIL then exit;
exec('"'+selectedfile.resource+'"')
end;

procedure TmainFrm.openLogBtnClick(Sender: TObject);
var
  mask, fn: string;
  s: TfastStringAppend;
  i: integer;
begin
mask:=logSearchBox.text;
s:=TfastStringAppend.create;
try
  if sender = openLogBtn then s.append(logBox.text)
  else
    for i:=0 to logBox.Lines.Count-1 do
      if filematch('*'+mask+'*', logbox.lines[i]) then
        s.append(logBox.lines[i]+CRLF);
  if s.length() = 0 then
    begin
    msgDlg('It''s empty', MB_ICONWARNING);
    exit;
    end;
  fn:=saveTempFile(s.get());
finally s.free end;
if renameFile(fn, fn+'.txt') then exec(fn+'.txt')
else msgDlg(MSG_NO_TEMP, MB_ICONERROR);
end;

procedure Tmainfrm.ipmenuclick(sender:Tobject);
var
  ip: string;
begin
ip:=(sender as Tmenuitem).caption;
delete(ip, pos('&',ip), 1);
setDefaultIP(ip);
searchbetteripChk.checked:=FALSE;
setClip(urlBox.text);
end; // ipmenuclick

// returns the last file added
function Tmainfrm.addFilesFromString(files:string; under:Ttreenode=NIL):Tfile;
var
  folderKindFrm: TfolderKindFrm;

  function selectFolderKind():integer;
  begin
  application.restore();
  application.BringToFront();
  Application.CreateForm(TfolderKindFrm, folderKindFrm);
  result:=folderKindFrm.ShowModal();
  folderKindFrm.Free;
  end; // selectFolderKind

resourcestring
  MSG_ITEM_EXISTS = '%s item(s) already exists:'#13'%s'#13#13'Continue?';
  MSG_INSTALL_TPL = 'Install this template?';
  MSG_FOLDER_UPLOAD = 'Do you want ANYONE to be able to upload to this folder?';
const
  MAX_DUPE = 50;
var
  f: Tfile;
  kind, s, fn: string;
  doubles: TStringDynArray;
  res: integer;
  upload, skipComment: boolean;
begin
result:=NIL;
if files = '' then exit;
upload:=FALSE;
if singleLine(files) then
  begin
  files:=trim(files); // this let me treat 'files' as a simple filename, not caring of the trailing CRLF

  // suggest template installation
  if (lowerCase(extractFileExt(files)) = '.tpl')
  and (msgDlg(MSG_INSTALL_TPL, MB_YESNO) = MRYES) then
    begin
    setNewTplFile(files);
    exit;
    end;

  upload:=(ipos('upload', extractFilename(files)) > 0)
    and (msgDlg(MSG_FOLDER_UPLOAD, MB_YESNO) = MRYES);
  end;
// warn upon double filenames
doubles:=NIL;
s:=files;
while s > '' do
	begin
  fn:=chopLine(s);
  // we must resolve links here, or we may miss duplicates
	if isExtension(fn, '.lnk') or fileExists(fn+'\target.lnk') then  // mod by mars
    fn:=resolveLnk(fn);

  if (length(fn) = 3) and (fn[2] = ':') then fn:=fn[1]+fn[2] // unit root folder
	else fn:=ExtractFileName(fn);
  if fileSrv.existsNodeWithName(fn, under) then
    if addString(fn, doubles) > MAX_DUPE then
      break;
  end;
if assigned(doubles) then
  begin
  filesBox.Repaint();
  res:=length(doubles);
  s:=if_(res > MAX_DUPE, intToStr(MAX_DUPE)+'+', intToStr(res));
  s:=format(MSG_ITEM_EXISTS, [s, join(', ',doubles)]);
  if msgDlg(s, MB_ICONWARNING+MB_YESNO) <> IDYES then exit;
  end;

f:=NIL;
skipComment:=not singleLine(files);
kind:=if_(upload, 'real', addFolderDefault);
addingItemsCounter:=0;
try
	repeat
  fn:=chopLine(files);
  if fn = '' then continue;
  f:=Tfile.create(filesBox, fn);
  if f.isFolder() then
    begin
    if kind = '' then
      begin // we didn't decide if real or virtual yet
      res:=selectFolderKind();

      if isAbortResult(res) then
        begin
        f.free;
        exit;
        end;
      kind:=if_(res = mrYes, 'virtual', 'real');
      end;

    if kind = 'virtual' then                                             
      include(f.flags, FA_VIRTUAL);
    end;

  f.lock();
  try
    f.name := fileSrv.getUniqueNodeName(f.name, under);
    addFile(f, under, skipComment);
  finally
    f.unlock();
    end;

  until (files = '') or fileSrv.stopAddingItems;
finally addingItemsCounter:=-1 end;

if upload then
  begin
  addUniqueString(USER_ANYONE, f.accounts[FA_UPLOAD]);
  sortArray(f.accounts[FA_UPLOAD]);
  end;
if assigned(f) and autocopyURLonadditionChk.checked then
  setClip(fileSrv.fullURL(f));
result:=f;
end; // addFilesFromString

procedure Tmainfrm.addDropFiles(hnd:Thandle; under:Ttreenode);
var
  i, n: integer;
  buffer: array [0..2000] of char;
  files: string;
begin
if hnd = 0 then exit;
GlobalLock(hnd);
n:=DragQueryFile(hnd,cardinal(-1),NIL,0);
files:='';
buffer:='';
for i:=0 to n-1 do
  begin
  DragQueryFile(hnd,i,@buffer,sizeof(buffer));
  files:=files+buffer+CRLF;
  end;
//DragFinish(hnd);  // this call seems to cause instability, don't know why
GlobalUnlock(hnd);

addFilesFromString(files, under);
end; // addDropFiles

procedure Tmainfrm.WMDropFiles(var msg:TWMDropFiles);
begin
with filesbox.screenToClient(mouse.cursorPos) do
  addDropFiles(msg.Drop, filesbox.getNodeAt(x,y));
inherited;
end; // WMDropFiles

procedure Tmainfrm.WMQueryEndSession(var msg:TWMQueryEndSession);
begin
windowsShuttingDown:=TRUE;
quitting:=TRUE; // in hard times, formClose() is not called (or not soon enough)
quitASAP:=TRUE;
msg.Result:=1;
close();
inherited;
end; // WMQueryEndSession

procedure Tmainfrm.WMEndSession(var msg:TWMEndSession);
begin
if msg.EndSession then
  begin
  windowsShuttingDown:=TRUE;
  quitting:=TRUE;
  quitASAP:=TRUE;
  close();
  end;
inherited;
end; // WMEndSession

procedure TmainFrm.WMNCLButtonDown(var msg:TWMNCLButtonDown);
begin
if (msg.hitTest = windows.HTCLOSE) and trayInsteadOfQuitChk.checked then
  begin
  msg.hitTest:=windows.HTCAPTION; // cancel closing
  minimizeToTray();
  end;
inherited;
end;

procedure TmainFrm.splitVMoved(Sender: TObject);
begin
if logBox.width > 0 then lastGoodLogWidth:=logBox.width;
filesBoxRatio:=filesPnl.Width/ClientWidth
end;

procedure TmainFrm.appEventsShowHint(var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);

  function reduce(const s: String): String;
  begin
    result:=xtpl(s, [ #13,' ', #10,'' ]);
    if length(result) > 30 then
      begin
        setlength(result, 29);
        result:=result+'...';
      end;
  end; // reduce

  function fileHint():string;
  resourcestring
    MSG_VFS_DRAG_INVIT = 'Drag your files here';
    MSG_VFS_URL = 'URL: %s';
    MSG_VFS_PATH = 'Path: %s';
    MSG_VFS_SIZE = 'Size: %s';
    MSG_VFS_DLS = 'Downloads: %s';
    MSG_VFS_INVISIBLE = 'Invisible';
    MSG_VFS_DL_FORB = 'Download forbidden';
    MSG_VFS_DONT_LOG = 'Don''t log';
    MSG_VFS_HIDE_EMPTY = 'Hidden if empty';
    MSG_VFS_NOT_BROW = 'Not browsable';
    MSG_VFS_HIDE_EMPTY_FLD = 'Hide empty folders';
    MSG_VFS_HIDE_EXT = 'Hide extention';
    MSG_VFS_ARCABLE = 'Archivable';
    MSG_VFS_DEF_MASK = 'Default file mask: %s';
    MSG_VFS_ACCESS = 'Access for';
    MSG_VFS_UPLOAD = 'Upload allowed for';
    MSG_VFS_DELETE = 'Delete allowed for';
    MSG_VFS_COMMENT = 'Comment: %s';
    MSG_VFS_REALM = 'Realm: %s';
    MSG_VFS_DIFF_TPL = 'Diff template: %s';
    MSG_VFS_FILES_FLT = 'Files filter: %s';
    MSG_VFS_FLD_FLT = 'Folders filter: %s';
    MSG_VFS_UPL_FLT = 'Upload filter: %s';
    MSG_VFS_DONT_CONS_DL = 'Don''t consider as download';
    MSG_VFS_DONT_CONS_DL_MASK = 'Don''t consider as download (mask): %s';
    MSG_VFS_INHERITED = ' [inherited]';
    MSG_VFS_EXTERNAL = ' [external]';
  var
    f, parent: Tfile;
    s, s2: string;
    inheritd, externl: boolean;

    function flag(const lbl: String; att: TfileAttribute; positive: Boolean=TRUE): String;
    begin result:=if_((att in f.flags) = positive, #13+lbl) end;

    function flagR(const lbl: String; att: TfileAttribute; positive: Boolean=TRUE): String;
    var
      inh: boolean;
    begin
    result:=if_(f.hasRecursive(att, @inh), #13+lbl);
    result:=result+if_(inh, MSG_VFS_INHERITED);
    end; // flagR

    procedure perm(action: TfileAction; const msg: String);
    var
      s: string;
    begin
      s := join(', ', f.getAccountsFor(action, TRUE, @inheritd));
      if (s > '') and inheritd then
        s := s+MSG_VFS_INHERITED;
      if s > '' then
        result := result+#13+msg+': '+s;
    end;

  begin
  result:=if_(HintsfornewcomersChk.checked,MSG_VFS_DRAG_INVIT);
  f:=pointedFile();
  if f = NIL then exit;
  parent:=f.parent;

  result:=format(MSG_VFS_URL,[fileSrv.URL(f)]);
  if f.isRealFolder() or f.isFile() then
    result := result + #13+format(MSG_VFS_PATH,[f.resource]);
  if f.isFile() then
    result:=result+format(#13+MSG_VFS_SIZE+#13+MSG_VFS_DLS,
      [ smartsize(sizeofFile(f.resource)), dotted(f.DLcount) ]);

  s:=flagR(MSG_VFS_INVISIBLE, FA_HIDDENTREE, TRUE);
  if s = '' then s:=flag(MSG_VFS_INVISIBLE, FA_HIDDEN);
  result:=result+s
    +flag(MSG_VFS_DL_FORB, FA_DL_FORBIDDEN)
    +flagR(MSG_VFS_DONT_LOG, FA_DONT_LOG);

  if f.isFolder() then
    begin
    if assigned(parent) and parent.hasRecursive(FA_HIDE_EMPTY_FOLDERS) then
        result:=result+#13+MSG_VFS_HIDE_EMPTY+MSG_VFS_INHERITED;

    result:=result
      +flag(MSG_VFS_NOT_BROW, FA_BROWSABLE, FALSE)
      +flag(MSG_VFS_HIDE_EMPTY_FLD, FA_HIDE_EMPTY_FOLDERS)
      +flagR(MSG_VFS_HIDE_EXT, FA_HIDE_EXT)
      +flagR(MSG_VFS_ARCABLE, FA_ARCHIVABLE)
    end;

  s:=f.getRecursiveFileMask();
  if (s > '') and (f.defaultFileMask = '') then s:=s+MSG_VFS_INHERITED;
  if s > '' then result:=result+#13+format(MSG_VFS_DEF_MASK,[s]);

  perm(FA_ACCESS, MSG_VFS_ACCESS);
  if f.isRealFolder() then perm(FA_UPLOAD, MSG_VFS_UPLOAD);
  perm(FA_DELETE, MSG_VFS_DELETE);

  s:=reduce(f.getDynamicComment(mainfrm.getLP));
  if (s > '') and (f.comment = '') then s:=s+MSG_VFS_EXTERNAL;
  if s > '' then result:=result+#13+format(MSG_VFS_COMMENT,[s]);

  s:=reduce(f.getShownRealm());
  if (s > '') and (f.realm = '') then s:=s+MSG_VFS_INHERITED;
  if s > '' then result:=result+#13+format(MSG_VFS_REALM,[s]);

  s:=reduce(f.getRecursiveDiffTplAsStr(@inheritd, @externl));
  if s > '' then
    begin
    if inheritd then s:=s+MSG_VFS_INHERITED;
    if externl then s:=s+MSG_VFS_EXTERNAL;
    result:=result+#13+format(MSG_VFS_DIFF_TPL,[s]);
    end;

  f.getFiltersRecursively(s, s2);
  result:=result
    +if_(s>'', #13+format(MSG_VFS_FILES_FLT,[s])
      +if_(f.filesFilter = '', MSG_VFS_INHERITED))
    +if_(s2>'', #13+format(MSG_VFS_FLD_FLT, [s2])
      +if_(f.foldersFilter = '', MSG_VFS_INHERITED))
    +if_(f.uploadFilterMask>'', #13+format(MSG_VFS_UPL_FLT,[f.uploadFilterMask]))
    +flag(MSG_VFS_DONT_CONS_DL, FA_DONT_COUNT_AS_DL)
    +if_(f.dontCountAsDownloadMask>'',
      #13+format(MSG_VFS_DONT_CONS_DL_MASK, [f.dontCountAsDownloadMask]))
  end; // filehint

  function connHint():string;
  resourcestring
    MSG_CON_HINT = 'Connection time: %s'#13'Last request time: %s'#13'Agent: %s';
  var
    cd: TconnData;
    st: string;
  begin
  cd:=pointedConnection();
  if assigned(cd) then
    begin
    if isSendingFile(cd) then
      st:=format(MSG_CON_SENT, [
        dotted(cd.conn.bytesSentLastItem),
        dotted(cd.conn.bytesPartial)
      ])
    else if isReceivingFile(cd) then
      st:=format(MSG_CON_received, [
        dotted(cd.conn.bytesPosted),
        dotted(cd.conn.post.length)
      ])
    else
      st:='';

    result:=format(MSG_CON_HINT, [
      dateTimeToStr(cd.time),
      dateTimeToStr(cd.requestTime),
      first(cd.agent,'<unknown>')
    ])+nonEmptyConcat(#13,st);
    end
  else
    result:=if_(HintsForNewcomersChk.checked, 'This box shows info about current connections');
  end;

begin
if hintinfo.HintControl = filesBox then
  begin
  hintinfo.ReshowTimeout:=800;
  hintStr:=filehint();
  end;
if hintinfo.HintControl = connBox then
  begin
  hintinfo.ReshowTimeout:=800;
  hintStr:=connHint();
  end;

if not hintsForNewcomersChk.checked
and ((hintinfo.hintcontrol = modeBtn)
  or (hintinfo.hintcontrol = menuBtn)
  or (hintinfo.hintcontrol = graphBox))
then hintStr:='';
hintStr:=chop(#0, hintStr); // info past null char are used for extra data storing
canShow:=hintstr > '';
end;

procedure TmainFrm.logmenuPopup(Sender: TObject);
begin
Readonly1.Checked:=logBox.ReadOnly;
Readonly1.visible:=not easyMode;
Banthisaddress1.visible:= ipPointedInLog() > '';
Address2name1.visible:=not easyMode;
Logfile1.visible:=not easyMode;
logOnVideoChk.visible:=not easyMode;
Donotlogaddress1.visible:=not easyMode;
Clearandresettotals1.visible:=not easyMode;
Addresseseverconnected1.visible:=not easyMode;
Maxlinesonscreen1.visible:=not easyMode;
Dontlogsomefiles1.visible:=not easyMode;
Apachelogfileformat1.visible:=not easyMode and (logfile.filename>'');
tabOnLogFileChk.Visible:=not easyMode and (logfile.filename>'');
end;

function Tmainfrm.searchLog(dir:integer):boolean;
var
  t, s: string;
  i, l, tl, from, n: integer;
begin
timeTookToSearchLog:=now();
try
  result:=TRUE;
  from:=logBox.SelStart+1;
  t:=ansiLowerCase(logBox.text);
  s:=ansiLowerCase(logSearchBox.text);
  if s = '' then exit;
  result:=FALSE;
  if t = '' then exit;
  tl:=length(t);
  // if we are typing (dir=0) then before search forward, see if we can extend the current selection
  if dir <> 0 then l:=0
  else l:=match(pchar(s), @t[from], FALSE, [#13,#10]);
  if l > 0 then
    i:=from
  // if he doesn't use wildcards, use posEx(), it should be much faster on a long text
  else if pos('?',s)+pos('*',s) = 0 then
    begin
    if dir <= 0 then
      begin
      s:=reverseString(s);
      t:=reverseString(t);
      from:=tl-from+1;
      end;
    i:=posEx(s, t, from+1);
    if i = 0 then i:=pos(s, t);
    if i = 0 then exit;
    l:=length(s);
    if dir <= 0 then i:=tl-i-l+2;
    end
  else // it's using wildcards, so use match(), but don't allow matching across different lines, or a search with a * may take forever
    begin
    if dir = 0 then dir:=-1;
    inc(from, dir);
    i:=from+dir;
    n:=0;
    s:=trim2(s, ['*',' ']);
      repeat
      l:=match(pchar(s), @t[i], FALSE, [#13,#10]);
      if l > 0 then break;
      inc(i, dir);
      inc(n);
      if n >= tl then exit;
      if i > tl then i:=1;
      if i = 0 then i:=tl;
      until false;
    end;
  logBox.SelStart:=i-1;
  logBox.SelLength:=l;
  result:=TRUE;
finally timeTookToSearchLog:=now()-timeTookToSearchLog end;
end;

procedure TmainFrm.logSearchBoxChange(Sender: TObject);
begin
// from when he stopped typing, wait twice the time of a searching, but max 2 seconds
searchLogTime:=now()+min(timeTookToSearchLog*2, 2/SECONDS);
openFilteredLog.Enabled:=logSearchBox.Text > '';
end;

procedure TmainFrm.logSearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
  begin
  searchLog(-1);
  key:=#0;
  end;
end;

procedure TmainFrm.logUpDownClick(Sender: TObject; Button: TUDBtnType);
begin searchLog(if_(button = btNext, -1, +1)) end;

procedure TmainFrm.Readonly1Click(Sender: TObject);
begin with logBox do ReadOnly:=not ReadOnly end;

procedure TmainFrm.Clear1Click(Sender: TObject);
begin logBox.Clear() end;

procedure TmainFrm.Clearandresettotals1Click(Sender: TObject);
begin
logBox.clear();
resetTotals();
end;

procedure TmainFrm.Copy1Click(Sender: TObject);
begin
if logBox.SelLength > 0 then setClip(logBox.SelText)
else setClip(logBox.Text)
end;

procedure TmainFrm.Saveas1Click(Sender: TObject);
var
  fn: string;
begin
fn:='';
if PromptForFileName(fn, 'Text file|*.txt', 'txt', 'Save log', '', TRUE) then
  savefileU(fn, logBox.text);
end;

procedure TmainFrm.Save1Click(Sender: TObject);
begin savefileU('hfs.log', logBox.text) end;

procedure deleteCFG();
begin
deleteFile(lastUpdateCheckFN);
deleteFile(cfgPath+CFG_FILE);
deleteRegistry(CFG_KEY);
deleteRegistry(CFG_KEY, HKEY_LOCAL_MACHINE);
end; // deleteCFG

procedure TmainFrm.Clearoptionsandquit1click(Sender: TObject);
begin
deleteCFG();
autoSaveOptionsChk.Checked:=FALSE;
close();
end;

procedure TmainFrm.collapseBtnClick(Sender: TObject);
begin setLogToolbar(FALSE) end;

function ListView_GetSubItemRect(lv: TlistView; iItem, iSubItem: Integer): Trect;
const
  LVM_FIRST               = $1000;      { ListView messages }
  LVM_GETSUBITEMRECT      = LVM_FIRST + 56;
begin
  result.top:=iSubItem;
  result.left:=0;
  if sendMessage(lv.handle, LVM_GETSUBITEMRECT, iItem, NativeInt(@result)) = 0 then
    result.Top:=-1
end;

procedure TmainFrm.connBoxAdvancedCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  r: Trect;
  cnv: Tcanvas;

  procedure textCenter(const s: String);
  var
    i: integer;
  begin
    i:=((r.bottom-r.top)-cnv.textHeight(s)) div 2; // vertical margin, to center vertically
    inc(r.top, i);
    drawCentered(cnv,r,s);
    dec(r.top, i);
  end; // textCentered

  procedure drawProgress(now,total,lowerbound,upperbound:int64);
  var
    d: real;
    selected: boolean;
    r1: Trect;
    x: integer;
    colors:array [boolean] of Tcolor;
  begin
  if (total <= 0) or (lowerbound >= upperbound) then exit;
  colors[false]:=clWindow;
  colors[true]:=blend(clWindow, clWindowText, 0.25);
  selected:=cdsSelected in state;
  r1:=rect(r.Left+1,r.Top+1,r.Right-1,r.Bottom-1);
  // paint a shadow for non requested piece of data
  cnv.brush.Color:=blend(clWindow, clHotLight, 0.30);
  cnv.Brush.Style:=bsSolid;
  cnv.FillRect(r1);
  // and shrink the rectangle
  x:=r1.Right-r1.Left;
  cnv.pen.color:=colors[selected];
  cnv.pen.Style:=psSolid;
  if lowerbound > 0 then
    begin
    inc( r1.Left, round(x*lowerbound/total) );
    cnv.MoveTo(r1.Left-1, r1.Top);
    cnv.LineTo(r1.Left-1, r1.Bottom);
    end;
  if upperbound > 0 then dec( r1.Right, round(x*(total-upperbound)/total) );
  // border + non filled part
  cnv.brush.Color:=colors[not selected];
  cnv.Brush.Style:=bsSolid;
  cnv.FillRect(r1);
  // filled part
  d:=now / (upperbound-lowerbound);
  if d > 1 then d:=1;
  inc(r1.Left, 1+round(d*(r1.right-r1.Left-2)));
  dec(r1.right); dec(r1.bottom); inc(r1.top);
  cnv.brush.Color:=colors[selected];
  if not IsRectEmpty(r1) then cnv.FillRect(r1);
  // label
  cnv.Font.Name:='Small Fonts';
  cnv.font.Size:=7;
  cnv.font.Color:=clWindowText;
  SetBkMode(cnv.handle, TRANSPARENT);
  inc(r.top);
  textCenter(format('%d%%', [trunc(d*100)]));
  end; // drawProgress

var
  cd: TconnData;
begin
  if subItem <> 5 then
    exit;
  cd := conn2data(item);
  if cd = NIL then
    exit;
  cnv := connBox.canvas;
  r := ListView_GetSubItemRect(connBox, item.index, subItem);
  if isSendingFile(cd) or (cd.conn.reply.bodyMode = RBM_STREAM) then
    drawProgress( cd.conn.bytesSentLastItem, cd.conn.bytesFullBody, cd.conn.reply.firstByte, cd.conn.reply.lastByte )
   else if isReceivingFile(cd) then
    drawProgress( cd.conn.bytesPosted, cd.conn.post.length, 0, cd.conn.post.length);
end;

procedure TmainFrm.connBoxData(Sender: TObject; Item: TListItem);
resourcestring
  MSG_CON_STATE_IDLE = 'idle';
  MSG_CON_STATE_REQ = 'requesting';
  MSG_CON_STATE_RCV = 'receiving';
  MSG_CON_STATE_THINK = 'thinking';
  MSG_CON_STATE_REP = 'replying';
  MSG_CON_STATE_SEND = 'sending';
  MSG_CON_STATE_DISC = 'disconnected';
const
  HCS2STR :array [ThttpConnState] of string = (MSG_CON_STATE_IDLE, MSG_CON_STATE_REQ, MSG_CON_STATE_RCV,
    MSG_CON_STATE_THINK, MSG_CON_STATE_REP, MSG_CON_STATE_SEND, MSG_CON_STATE_DISC);
var
  data: TconnData;

  function getFname():string;
  begin
  if isSendingFile(data) then result:=data.lastFN
  else if isReceivingFile(data) then result:=data.uploadSrc
  else result:='-'
  end;

  function getStatus():string;
  begin
  if isSendingFile(data) then
    begin
    if data.conn.paused then
      result:=MSG_CON_PAUSED
    else
      result:=format(MSG_CON_SENT, [
        smartsize(data.conn.bytesSentLastItem),
        smartsize(data.conn.bytesPartial)
      ]);
    exit;
    end;
  if isReceivingFile(data) then
    begin
    result:=format(MSG_CON_received, [
      smartsize(data.conn.bytesPosted),
      smartsize(data.conn.post.length)
    ]);
    exit;
    end;
  result:=HCS2STR[data.conn.state]
    +if_(data.conn.state = HCS_IDLE, ' '+intToStr(data.conn.requestCount))
  end; // getStatus

  function getSpeed():string;
  var
    d: real;
  begin
  case data.conn.state of
    HCS_REPLYING_BODY: d:=data.conn.speedOut;
    HCS_POSTING: d:=data.conn.speedIn;
    else d:=data.averageSpeed;
    end;
  if d < 1 then result:='-'
  else result:=format(MSG_SPEED_KBS,[d/1000])
  end; // getSpeed

var
  progress: real;
  s: String;
begin
if quitting then exit;
if item = NIL then exit;
data:=conn2data(item);
if data = NIL then exit;
item.caption:=nonEmptyConcat('', data.usr, '@')+data.address+':'+data.conn.port;
while item.subitems.count < 5 do
  item.subitems.add('');

item.imageIndex:=-1;
progress:=-1;
if data.conn.state = HCS_DISCONNECTED then
  item.imageIndex:=21
else if isSendingFile(data) then
  begin
  item.imageIndex:=32;
  progress:= data.conn.bytesSentLastItem / data.conn.bytesPartial;
  end
else if isReceivingFile(data) then
  begin
  item.imageIndex:=33;
  progress:= data.conn.bytesPosted / data.conn.post.length;
  end;

item.subItems[0]:=getFname();
item.subItems[1]:=getStatus();
item.subItems[2]:=getSpeed();
item.subItems[3]:=getETA(data);
  if progress<0 then
    s := ''
   else
    s := format('%d%%', [trunc(progress*100)]);
item.subItems[4]:=s;
end;

function TmainFrm.appEventsHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
callHelp:=FALSE; // avoid exception to be thrown
result:=FALSE;
end;

procedure TmainFrm.appEventsMinimize(Sender: TObject);
begin
if not MinimizetotrayChk.Checked then exit;
minimizeToTray();
end;

procedure TmainFrm.appEventsRestore(Sender: TObject);
begin
trayed:=FALSE;
if not showmaintrayiconChk.checked then tray.hide();
end;

procedure Tmainfrm.trayEvent(sender:Tobject; ev:TtrayEvent);
begin
updateTrayTip();
if userInteraction.disabled then exit;
case ev of
  TE_RCLICK:
    begin
    setForegroundWindow(handle); // application.bringToFront() will act up when the window is minimized: the popped up menu will stay up forever
    with mouse.cursorPos do
     begin
      menu.popup(x,y);
     end;
    end;
  TE_CLICK:
    application.bringToFront();
  TE_2CLICK:
    begin
    application.restore();
    application.bringToFront();
    end;
  end;
end; // trayEvent

procedure TmainFrm.trayiconforeachdownload1Click(Sender: TObject);
begin trayfordownloadChk.Checked:=FALSE end;

procedure TmainFrm.AddIPasreverseproxy1Click(Sender: TObject);
var
  cd: TconnData;
begin
  cd := selectedConnection();
  if assigned(cd) then
    if not addressmatch(forwardedMask, cd.conn.address) then
      forwardedMask := forwardedMask + ';' + cd.conn.address;
end;

procedure Tmainfrm.downloadtrayEvent(sender:Tobject; ev:TtrayEvent);
var
  i: integer;
begin
if userInteraction.disabled then exit;

for i:=connBox.items.count-1 downto 0 do
    if conn2data(i) = (sender as TmyTrayicon).usrData then
      connBox.itemIndex:=i;

case ev of
  TE_CLICK,
  TE_RCLICK:
    try
      fromTray:=TRUE;
      with mouse.cursorPos do
        connmenu.popup(x,y);
    finally fromTray:=FALSE end;
  TE_2CLICK:
    begin
    application.restore();
    application.bringToFront();
    connBox.setFocus();
    end;
  end;
end; // downloadtrayEvent

function Tmainfrm.getTrayTipMsg(const tpl: String=''): String;
var
  a: array of string;
  pat: String;
begin
if quitting or (fileSrv.rootFile = NIL) then
  begin
  result:='';
  exit;
  end;
  a := ['%ip%', defaultIP,
  '%port%', srv.port,
  '%version%', srvConst.VERSION,
  '%build%', VERSION_BUILD];
  pat := first(tpl, trayMsg);
  Result := xtpl(pat, a);

  if ipos('%uptime%', pat)>0 then
    Result := xtpl(Result, ['%uptime%', uptimestr()]);
  if ipos('%url%', pat)>0 then
    Result := xtpl(Result, ['%url%', fileSrv.fullURL(fileSrv.rootFile)]);
  if ipos('%hits%', pat)>0 then
    Result := xtpl(Result, ['%hits%', intToStr(hitsLogged)]);
  if ipos('%downloads%', pat)>0 then
    Result := xtpl(Result, ['%downloads%', intToStr(downloadsLogged)]);
  if ipos('%uploads%', pat)>0 then
    Result := xtpl(Result, ['%uploads%', intToStr(uploadsLogged)]);
end; // getTrayTipMsg

procedure Tmainfrm.updateTrayTip();
begin tray.setTip(getTrayTipMsg()) end;

procedure TmainFrm.Restore1Click(Sender: TObject);
begin
application.Restore();
application.bringToFront();
end;

procedure TmainFrm.restoreCfgBtnClick(Sender: TObject);
begin
setCfg(backuppedCfg);
backuppedCfg:='';
restoreCfgBtn.hide();
eventScriptsLast:=0;
resetOptions1.Enabled:=TRUE;
end;

procedure TmainFrm.Restoredefault1Click(Sender: TObject);
resourcestring
  MSG_TPL_RESET = 'The template has been reset';
begin
if msgDlg(MSG_CONTINUE, MB_ICONQUESTION+MB_YESNO) = MRNO then exit;
tplFilename:='';
tplLast:=-1;
tplImport:=TRUE;
setStatusBarText(MSG_TPL_RESET);
end;

procedure TmainFrm.Reverttopreviousversion1Click(Sender: TObject);
const
  FN = 'revert.bat';
  REVERT_BATCH = 'START %0:s /WAIT "%1:s" -q'+CRLF
    +'ping 127.0.0.1 -n 3 -w 1000> nul'+CRLF
    +'DEL "%1:s"'+CRLF
    +'MOVE "%2:s'+PREVIOUS_VERSION+'" "%1:s"'+CRLF
    +'START %0:s "%1:s"'+CRLF
    +'DEL %%0'+CRLF;
begin
try
  progFrm.show(MSG_PROCESSING);
  saveFileU(FN, format(REVERT_BATCH, [
    if_(isNT(), '""'),
    paramStr(0),
    exePath
  ]));
  execNew(FN);
finally progFrm.hide() end;

end;

procedure TmainFrm.Numberofcurrentconnections1Click(Sender: TObject);
begin setTrayShows(TS_connections) end;

procedure TmainFrm.NumberofdifferentIPaddresses1Click(Sender: TObject);
begin setTrayShows(TS_ips) end;

procedure TmainFrm.NumberofdifferentIPaddresseseverconnected1Click(
  Sender: TObject);
begin setTrayShows(TS_ips_ever) end;

procedure TmainFrm.Numberofloggeddownloads1Click(Sender: TObject);
begin setTrayShows(TS_downloads) end;

procedure TmainFrm.Numberofloggedhits1Click(Sender: TObject);
begin setTrayShows(TS_hits) end;

//procedure Tmainfrm.setTrayShows(s:string);
procedure Tmainfrm.setTrayShows(s: TTrayShows);
begin
trayShows:=s;
repainttray();
end; // setTrayShows

procedure TmainFrm.Exit1Click(Sender: TObject);
begin close() end;

procedure TmainFrm.Extension1Click(Sender: TObject);
begin defSorting:='ext' end;

procedure TmainFrm.onDownloadChkClick(Sender: TObject);
begin flashOn:='download' end;

procedure TmainFrm.onconnectionChkClick(Sender: TObject);
begin flashOn:='connection' end;

procedure TmainFrm.never1Click(Sender: TObject);
begin flashOn:='' end;

procedure Tmainfrm.addTray();
begin
repaintTray();
tray.show();
end; // addTray

procedure TmainFrm.Allowedreferer1Click(Sender: TObject);
resourcestring
  MSG_ALLO_REF = 'Allowed referer';
  MSG_ALLO_REF_LONG = 'Leave empty to disable this feature.'
    +#13'Here you can specify a mask.'
    +#13'When a file is requested, if the mask doesn''t match the "Referer" HTTP field, the request is rejected.';
begin
inputQuery(MSG_ALLO_REF, MSG_ALLO_REF_LONG, allowedReferer)
end;

// addtray

procedure TmainFrm.FormShow(Sender: TObject);
begin
if trayed then showWindow(application.handle, SW_HIDE);
updateTrayTip();
connBox.DoubleBuffered:=true;

  logBox.Font.PixelsPerInch := Self.CurrentPPI;
  IconsDM.images.SetSize(MulDiv(16, Self.CurrentPPI, 96), MulDiv(16, Self.CurrentPPI, 96));
end;

procedure TmainFrm.filesBoxDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
const
  THRESHOLD = 10;
var
  src, dst: Tfile;
  i: integer;
begin
  scrollFilesBox:=-1;
  if y < THRESHOLD then
    scrollFilesBox:=SB_LINEUP;
  if filesBox.Height-y < THRESHOLD then
    scrollFilesBox:=SB_LINEDOWN;

  accept:=FALSE;
  if sender <> source then
    exit; // only move files within filesBox
  dst := pointedFile(FALSE);
  if assigned(dst) and not dst.isFolder() then
    dst := dst.parent;
  if dst = NIL then
    exit;
  if filesBox.SelectionCount > 0 then
    for i:=0 to filesBox.SelectionCount-1 do
      with nodeToFile(filesbox.selections[i]) do
        if isRoot() or isLocked() then exit;
  src := selectedFile;
  accept := (dst <> src.parent) and (dst <> src);
end;

procedure TmainFrm.filesBoxDragDrop(Sender, Source: TObject; X,Y: Integer);
var
  dst: Ttreenode;
  i, bak: integer;
  nodes: array of Ttreenode;
begin
  if selectedFile = NIL then
    exit;
  VFSmodified := TRUE;
  dst := filesBox.dropTarget;
  if not nodeToFile(dst).isFolder() then
    dst := dst.parent;
// copy list of selected nodes
  setlength(nodes, filesBox.SelectionCount);
for i:=0 to filesBox.SelectionCount-1 do nodes[i]:=filesbox.selections[i];
// check for namesakes
for i:=0 to length(nodes)-1 do
  if fileSrv.existsNodeWithName(nodes[i].Text, dst) then
    if msgDlg(MSG_SAME_NAME, MB_ICONWARNING+MB_YESNO) = IDYES then break
    else exit;
// move'em
for i:=0 to length(nodes)-1 do
  begin
  // removing and restoring stateIndex is a workaround to a delphi bug
  bak:=nodes[i].stateIndex;
  nodes[i].stateIndex:=0;
  nodes[i].moveTo(dst, naAddChild);
  nodes[i].stateIndex:=bak;
  end;
filesBox.refresh();
dst.alphaSort(FALSE);
end;

procedure TmainFrm.refreshConn(conn:TconnData);
var
  r: Trect;
  i: integer;
begin
if quitting then exit;

for i:=0 to connBox.items.count-1 do
  if conn2data(i) = conn then
    begin
    connBoxData(connBox, connBox.items[i]);
    r:=connBox.items[i].displayRect(drBounds);
    invalidateRect(connBox.handle, @r, TRUE);
    break;
    end;
//updateSbar();   // this was causing too many refreshes on fast connections
end; // refreshConn


function Tmainfrm.getVFS(node:Ttreenode=NIL): RawByteString;
var
  f: Tfile;
begin
  if node = NIL then
    f := fileSrv.rootFile
   else
    f := nodeToFile(node);
  if f = NIL then
    exit;
  Result := f.getVFS;
end; // getVFS

function Tmainfrm.getVFSJZ(node: TTreeNode=NIL): RawByteString;
var
  f: Tfile;
begin
  if node = NIL then
    f := fileSrv.rootFile
   else
    f := nodeToFile(node);
  if f = NIL then
    exit('');
  Result := f.getVFSZ;
end; // getVFSJZ

function addVFSheader(vfsdata: RawByteString): RawByteString;
begin
  if length(vfsdata) > COMPRESSION_THRESHOLD then
    vfsdata := TLV(FK_COMPRESSED_ZLIB,
//    ZcompressStr2(vfsdata, zcFastest, 31,8, zsDefault) );
      ZcompressStr(vfsdata, clFastest, zsGZip) );
  result := TLV(FK_HEAD, VFS_FILE_IDENTIFIER)
    +TLV(FK_FORMAT_VER, str_(CURRENT_VFS_FORMAT))
    +TLV(FK_HFS_VER, srvConst.VERSION)
    +TLV(FK_HFS_BUILD, VERSION_BUILD)
    +TLV(FK_CRC, str_(getCRC(vfsdata)));  // CRC must always be right before data
  result := result+vfsdata
end; // addVFSheader

procedure TmainFrm.Savefilesystem1Click(Sender: TObject);
begin saveVFS() end;

procedure TmainFrm.filesBoxDeletion(Sender: TObject; Node: TTreeNode);
var
  f: Tfile;
begin
  f := node.data;
  node.data := NIL;
  fileSrv.fileDeletion(f);
end;

function blockLoadSave():boolean;
resourcestring MSG_CANT_LOAD_SAVE = 'Cannot load or save while adding files';
begin
result:=addingItemsCounter > 0;
if not result then exit;
msgDlg(MSG_CANT_LOAD_SAVE, MB_ICONERROR);
end; // blockLoadSave

procedure TmainFrm.Loadfilesystem1Click(Sender: TObject);
resourcestring MSG_OPEN_VFS = 'Open VFS file';
var
  fn: string;
begin
if blockLoadSave() then exit;
if not checkVfsOnQuit() then exit;
fn:='';
if promptForFileName(fn, 'VirtualFileSystem|*.vfs|VirtualFileSystem JSON Zipped|*.vfsjz', 'vfs', MSG_OPEN_VFS) then
  loadVFS(fn);
end;

procedure TmainFrm.graphBoxPaint(Sender: TObject);
var
  bmp: Tbitmap;
  r: Trect;
begin
if not graphBox.visible then exit;
bmp:=Tbitmap.create();
bmp.SetSize(graphBox.Width, graphBox.Height);
r:=bmp.canvas.ClipRect;
drawGraphOn(bmp.canvas);
graphBox.canvas.CopyRect(r,bmp.canvas,r);
bmp.free;
end;

procedure resendShortcut(mi:Tmenuitem; sc:Tshortcut);
var
  i: integer;
begin
if mi.shortcut = sc then mi.click();
for i:=0 to mi.count-1 do resendShortcut(mi.items[i], sc); 
end;

procedure TmainFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
altPressedForMenu:=(key = 18) and (shift = [ssAlt]);
resendShortcut(menu.items, shortcut(key,shift));
if shift = [] then
  case key of
    VK_F10: popupMainMenu();
    end;
end;

procedure TmainFrm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if altPressedForMenu and (key = 18) and (shift = []) then
  popupMainMenu();
altPressedForMenu:=FALSE
end;

procedure TmainFrm.Officialwebsite1Click(Sender: TObject);
begin openURL('https://www.rejetto.com/hfs/') end;

procedure TmainFrm.showmaintrayiconChkClick(Sender: TObject);
begin
if showmaintrayiconChk.Checked then addTray()
else tray.hide();
end;

procedure TmainFrm.expandBtnClick(Sender: TObject);
begin setLogToolbar(TRUE) end;

procedure TmainFrm.Speedlimit1Click(Sender: TObject);
resourcestring
  MSG_MAX_BW = 'Max bandwidth (KB/s).';
  MSG_LIM0 = 'Zero is an effective limit.'#13'To disable instead, leave empty.';
var
  s: string;
begin
if speedLimit < 0 then s:=''
else s:=floatToStr(speedLimit);
if not inputquery(MSG_SET_LIMIT, MSG_MAX_BW+#13+MSG_EMPTY_NO_LIMIT+#13, s) then
  exit;
try
  s:=trim(s);
  if s = '' then setSpeedLimit(-1)
  else setSpeedLimit(strToFloat(s));
  if speedLimit = 0 then
    msgDlg(MSG_LIM0, MB_ICONWARNING);
  // a manual set of speedlimit voids the pause command
  Pausestreaming1.Checked:=FALSE;
except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR) end;
end;

procedure TmainFrm.Speedlimitforsingleaddress1Click(Sender: TObject);
resourcestring
  MSG_MAX_BW_1 = 'Max bandwidth for single address (KB/s).';
var
  s: string;
begin
if speedLimitIP <= 0 then s:=''
else s:=floatToStr(speedLimitIP);
if inputquery(MSG_SET_LIMIT, MSG_MAX_BW_1+#13+MSG_EMPTY_NO_LIMIT, s) then
	try
  	s:=trim(s);
  	if s = '' then setSpeedLimitIP(-1)
    else setSpeedLimitIP(strToFloat(s));
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
end;

procedure Tmainfrm.setnoDownloadTimeout(v:integer);
begin
if v < 0 then v:=0;
if v <> noDownloadTimeout then lastActivityTime:=now();
noDownloadTimeout:=v;
noDownloadTimeout1.caption:=MSG_DL_TIMEOUT
  +format(MSG_MENU_VAL, [if_(v=0, DISABLED, intToStr(v) )]);
end;

procedure Tmainfrm.setGraphRate(v:integer);
resourcestring
  MSG_GRAPH_RATE_MENU = 'Graph refresh rate: %d (tenths of second)';
begin
if v < 1 then v:=1;
if graph.rate = v then exit;
graph.rate:=v;
Graphrefreshrate1.caption:=format(MSG_GRAPH_RATE_MENU, [v]);
// changing rate invalidates previous data
  ZeroMemory(@graph.samplesIn, sizeof(graph.samplesIn));
  ZeroMemory(@graph.samplesOut, sizeof(graph.samplesOut));
graph.maxV:=0;
end; // setGraphRate

procedure TmainFrm.Maxconnections1Click(Sender: TObject);
resourcestring
  MSG_MAX_CON_LONG = 'Max simultaneous connections to serve.'
    +#13'Most people don''t know this function well, and have problems. If you are unsure, please use the "Max simultaneous downloads".';
  MSG_WARN_CONN = 'In this moment there are %d active connections';
var
  s: string;
begin
if maxConnections > 0 then s:=intToStr(maxConnections)
else s:='';
if inputquery(MSG_SET_LIMIT, MSG_MAX_CON_LONG+#13+MSG_EMPTY_NO_LIMIT, s) then
	try setMaxConnections(strToUInt(s))
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
if (maxConnections > 0) and (srv.conns.count > maxConnections) then
  msgDlg(format(MSG_WARN_CONN, [srv.conns.count]), MB_ICONWARNING);
end;

procedure TmainFrm.maxDLs1Click(Sender: TObject);
resourcestring
  MSG_WARN_ACT_DL = 'In this moment there are %d active downloads';
var
  s: string;
  i: integer;
begin
if maxContempDLs > 0 then s:=intToStr(maxContempDLs)
else s:='';
if inputquery(MSG_SET_LIMIT, MSG_MAX_SIM_DL+#13+MSG_EMPTY_NO_LIMIT, s) then
	try setMaxDLs(strToUInt(s))
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
if maxContempDLs = 0 then exit;
i:=countDownloads();
if i > maxContempDLs then
  msgDlg(format(MSG_WARN_ACT_DL, [i]), MB_ICONWARNING);
end;

procedure TmainFrm.Maxconnectionsfromsingleaddress1Click(Sender: TObject);
resourcestring
  MSG_MAX_CON_SING_LONG = 'Max simultaneous connections to accept from a single IP address.'
    +#13'Most people don''t know this function well, and have problems. If you are unsure, please use the "Max simultaneous downloads from a single IP address".';
var
  s: string;
  addresses: TStringDynArray;
  i: integer;
begin
if maxConnectionsIP > 0 then s:=intToStr(maxConnectionsIP)
else s:='';
if inputquery(MSG_SET_LIMIT, MSG_MAX_CON_SING_LONG+#13+MSG_EMPTY_NO_LIMIT, s) then
	try setMaxConnectionsIP(strToUInt(s))
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
if maxConnectionsIP = 0 then exit;
addresses:=NIL;
for i:=0 to srv.conns.Count-1 do
  with conn2data(i) do
    if countConnectionsByIP(address) > maxConnectionsIP then
      addUniqueString(address, addresses);
if assigned(addresses) then
  msgDlg(format(MSG_ADDRESSES_EXCEED,[join(#13, addresses)]), MB_ICONWARNING);
end;

procedure TmainFrm.MaxDLsIP1Click(Sender: TObject);
var
  s: string;
  addresses: TStringDynArray;
  i: integer;
begin
if maxContempDLsIP > 0 then s:=intToStr(maxContempDLsIP)
else s:='';
if inputquery(MSG_SET_LIMIT, MSG_MAX_SIM_DL_SING+#13+MSG_EMPTY_NO_LIMIT, s) then
	try setMaxDLsIP(strToUInt(s))
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
if maxContempDLsIP = 0 then exit;
addresses:=NIL;
for i:=0 to srv.conns.Count-1 do
  with conn2data(i) do
    if countDownloads(address) > maxContempDLsIP then
      addUniqueString(address, addresses);
if assigned(addresses) then
  msgDlg(format(MSG_ADDRESSES_EXCEED,[join(#13, addresses)]), MB_ICONWARNING);
end;

procedure TmainFrm.Forum1Click(Sender: TObject);
begin openURL('http://www.rejetto.com/forum/') end;

procedure TmainFrm.FAQ1Click(Sender: TObject);
begin openURL('http://www.rejetto.com/sw/?faq=hfs') end;

procedure TmainFrm.License1Click(Sender: TObject);
begin openURL('https://www.gnu.org/licenses/gpl-3.0.html') end;

procedure Tmainfrm.pasteFiles();
begin
// try twice
try addDropFiles(clipboard.GetAsHandle(CF_HDROP), filesBox.selected)
except
  try addDropFiles(clipboard.GetAsHandle(CF_HDROP), filesBox.selected)
  except on e:Exception do
    msgDlg(e.message, MB_ICONERROR);
    end
  end;
end;

procedure TmainFrm.Paste1Click(Sender: TObject);
begin pasteFiles() end;

procedure TmainFrm.Addfiles1Click(Sender: TObject);
var
//  dlg: TopenDialog;
  i: integer;
  fn: String;
  initDir: String;

begin
{dlg:=TopenDialog.create(self);
if sysutils.directoryExists(lastDialogFolder) then
  dlg.InitialDir:=lastDialogFolder;
dlg.Options:=dlg.Options+[ofAllowMultiSelect, ofFileMustExist, ofPathMustExist];
if dlg.Execute() then
  begin
	for i:=0 to dlg.files.count-1 do
    addFile(Tfile.create(filesBox, dlg.files[i]), filesBox.Selected, dlg.Files.count<>1 );
  lastDialogFolder:=extractFilePath(dlg.fileName);
  end;
dlg.free;
}
  if sysutils.directoryExists(lastDialogFolder) then
    initDir := lastDialogFolder;

  if OpenSaveFileDialog(Self.Handle, '', '', initDir, '', fn, True, True) then
    if fn > '' then
      begin
        var files := split(';', fn);
        if Length(Files) > 0 then
          for i:=0 to Length(Files)-1 do
            addFile(Tfile.create(filesBox, files[i]), filesBox.Selected, Length(Files)<>1 );
        lastDialogFolder := extractFilePath(fn);
      end;
end;

procedure TmainFrm.Addfolder1Click(Sender: TObject);
begin
if selectFolder('', lastDialogFolder) then
  begin
  addFilesFromString(lastDialogFolder, filesBox.selected);
  end;
end;

procedure TmainFrm.graphSplitterMoved(Sender: TObject);
begin graph.size:=graphBox.height end;

procedure TmainFrm.Graphrefreshrate1Click(Sender: TObject);
resourcestring
  MSG_GRAPH_RATE = 'Graph refresh rate';
  MSG_TENTH_SEC = 'Tenths of second';
var
  s: string;
begin
s:=intToStr(graph.rate);
if inputquery(MSG_GRAPH_RATE, MSG_TENTH_SEC,s) then
	try
  	s:=trim(s);
  	if s = '' then setGraphRate(10)
    else setGraphRate(strToInt(s))
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
end;

procedure TmainFrm.Pausestreaming1Click(Sender: TObject);
begin
if pausestreaming1.checked then globalLimiter.maxSpeed:=0
else setSpeedLimit(speedLimit)
end;

procedure TmainFrm.Comment1Click(Sender: TObject);
var
  i: integer;
begin
if selectedFile = NIL then exit;
inputComment(selectedFile);
for i:=0 to filesBox.SelectionCount-1 do
  nodeToFile(filesBox.Selections[i]).comment:=selectedFile.comment;
end;

procedure TmainFrm.filesBoxCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  f: Tfile;
  a: TStringDynArray;
  onlyAnon: boolean;
begin
  if not sender.visible then
    exit;
  if not Self.Visible then
    Exit;
  if not node.isVisible then
    Exit;
  f := Tfile(node.data);
  if f = NIL then
    exit;
  if f.hasRecursive([FA_HIDDEN, FA_HIDDENTREE], TRUE) then
	  with sender.Canvas.Font do
  	  style:=style+[fsItalic];
  a := f.accounts[FA_ACCESS];
  onlyAnon := onlyString(USER_ANONYMOUS, a);
  node.stateIndex := RDUtils.ifThen((f.user > '') or (assigned(a) and not onlyAnon), ICON_LOCK, -1);
end;

function Tmainfrm.fileAttributeInSelection(fa:TfileAttribute):boolean;
var
  i: integer;
begin
for i:=0 to filesBox.SelectionCount-1 do
  if fa in nodeTofile(filesBox.Selections[i]).flags then
    begin
    result:=TRUE;
    exit;
    end;
result:=FALSE;
end; // fileAttributeInSelection

procedure TmainFrm.Setuserpass1Click(Sender: TObject);
var
  i: integer;
  user, pwd: string;
  f: Tfile;
begin
if selectedFile = NIL then exit;
if fileAttributeInSelection(FA_LINK)
and (msgDlg(MSG_UNPROTECTED_LINKS, MB_ICONWARNING+MB_YESNO) <> IDYES) then exit;
user:=selectedFile.user;
pwd:=selectedFile.pwd;
if not newuserpassFrm.prompt(user, pwd) then exit;
for i:=0 to filesBox.SelectionCount-1 do
  begin
  f:=filesBox.Selections[i].data;
  usersInVFS.drop(f.user, f.pwd);
  f.user:=user;
  f.pwd:=pwd;
  usersInVFS.track(f.user, f.pwd);
  end;
filesBox.Repaint();
VFSmodified:=TRUE;
end;

procedure TmainFrm.browseBtnClick(Sender: TObject);
begin browse(urlBox.Text) end;

procedure TmainFrm.BanIPaddress1Click(Sender: TObject);
var
  cd: TconnData;
begin
cd:=selectedConnection();
if cd = NIL then exit;
banAddress(cd.address);
end;

procedure TmainFrm.BannedIPaddresses1Click(Sender: TObject);
begin
  showOptions(optionsFrm.bansPage, mainfrm.modalOptionsChk.checked)
end;

procedure Tmainfrm.recentsClick(sender:Tobject);
var
  i: integer;
begin
if blockLoadSave() then exit;
i:=strToInt((sender as Tmenuitem).Caption[3]);
if i > length(recentFiles) then exit;
dec(i); // convert to zero based
if fileExists(recentFiles[i]) then
  begin
  if not checkVfsOnQuit() then exit;
  loadVFS(recentFiles[i]);
  end
else
  begin
  msgDlg('The file does not exist anymore', MB_ICONERROR);
  removeString(recentFiles, i);
  updateRecentFilesMenu();
  end;
end;

procedure Tmainfrm.updateRecentFilesMenu();
var
  i: integer;
begin
Loadrecentfiles1.Clear();
for i:=0 to length(recentFiles)-1 do
  loadrecentfiles1.Add(
    NewItem( '[&'+intToStr(i+1)+'] '+ExtractFileName(recentFiles[i]), 0, FALSE, TRUE, recentsClick, 0, 'recent') );
Loadrecentfiles1.visible:=Loadrecentfiles1.count>0;
end; // updateRecentFilesMenu

procedure Tmainfrm.loadVFS(fn:string);
resourcestring
  MSG_LOADING_VFS = 'Loading VFS';
  MSG_VFS_OLD = 'This file is old and uses different settings.'
    +#13'The "let browse" folder option will be reset.'
    +#13'Re-saving the file will update its format.';
  MSG_UNK_FK = 'This file has been created with a newer version.'
    +#13'Some data was discarded because unknown.'
    +#13'If you save the file now, the discarded data will NOT be saved.';
  MSG_VIS_ONLY_ANON =
    'This VFS file uses the "Visible only to anonymous users" feature.'
    +#13'This feature is not available anymore.'
    +#13'You can achieve similar results by restricting access to @anonymous,'
    +#13'then enabling "List protected items only for allowed users".';
  MSG_AUTO_DISABLED = 'Because of the problems encountered in loading,'
    +#13'automatic saving has been disabled'
    +#13'until you save manually or load another one.';
  MSG_CORRUPTED = 'This file does not contain valid data.';
  MSG_MACROS_FOUND = '!!!!!!!!! DANGER !!!!!!!!!'
    +#13'This file contains macros.'
    +#13'Don''t accept macros from people you don''t trust.'
    +#13#13'Trust this file?';
var
  took: Tdatetime;
  data2: RawByteString;

  function anyAutosavingFeatureEnabled():boolean;
  begin  result:=(autosaveVFS.every > 0) or autosaveVFSchk.checked end;

  function restoreBak(var dd: RawByteString): boolean;
  begin
    result := fileExists(fn+BAK_EXT)
      and (not fileExists(fn) or renameFile(fn, fn+CORRUPTED_EXT))
      and renameFile(fn+BAK_EXT, fn);
    if result then
      dd := loadfile(fn);
  end; // restoreBak

begin
  if fn = '' then
    exit;
  if ExtractFileExt(fn) = '.vfsjz' then
    begin // JSON in Zip
      filesBox.hide(); // it seems to speed up a lot
      progFrm.show('Loading VFS...', TRUE);
      disableUserInteraction();
      try
        ZeroMemory(@loadingVFS, sizeof(loadingVFS));
        took := now();

        data2 := loadfile(fn);
        loadingVfs.bakAvailable := fileExists(fn+BAK_EXT);
        if not ansiStartsStr('PK', data2)
        and not restoreBak(data2) then
          begin
            if data2 = '' then
              msgDlg(MSG_CORRUPTED, MB_ICONERROR);
            exit;
          end;
        try
          initVFS();
          fileSrv.setVFSJZ(data2, NIL, onLoadVFSprogress);
          if loadingVFS.useBackup and restoreBak(data2) then
            begin
            initVFS();
            fileSrv.setVFSJZ(data2, NIL, onLoadVFSprogress);
            end;
          took := now()-took;
         finally
          if progFrm.cancelRequested then
            initVFS()
           else
            lastFileOpen := fn;
          VFSmodified := FALSE;
          purgeVFSaccounts(); // remove references to non-existent users
          filesBox.FullCollapse();
          var n := fileSrv.getRootNode;
          if Assigned(n) then
            begin
              n.Selected := TRUE;
              n.MakeVisible();
            end;
        end;
       finally
        reenableUserInteraction();
        progFrm.hide();
        filesBox.show();
      end;
      if progFrm.cancelRequested then
        exit;
      if loadingVFS.macrosFound
      and not stringExists(fn, trustedFiles)
      and (msgDlg(MSG_MACROS_FOUND, MB_ICONWARNING+MB_YESNO, MSG_LOADING_VFS) = mrNo) then
        begin
        initVFS();
        exit;
        end;
      addUniqueString(fn, trustedFiles);
      if loadingVFS.visOnlyAnon then
        msgDlg(MSG_VIS_ONLY_ANON, MB_ICONWARNING, MSG_LOADING_VFS);
      if loadingVFS.resetLetBrowse then
        msgDlg(MSG_VFS_OLD, MB_ICONWARNING, MSG_LOADING_VFS);
      if loadingVFS.unkFK then
        msgDlg(MSG_UNK_FK, MB_ICONWARNING, MSG_LOADING_VFS);

      with loadingVFS do disableAutosave:=unkFK or resetLetBrowse or visOnlyAnon;
      if loadingVFS.disableAutosave and anyAutosavingFeatureEnabled() then
        msgDlg(MSG_AUTO_DISABLED, MB_ICONWARNING, MSG_LOADING_VFS);

      setStatusBarText(format('Loaded in %.1f seconds (%s)', [took*SECONDS,fn]), 10);
    end
   else
    begin
      filesBox.hide(); // it seems to speed up a lot
      progFrm.show('Loading VFS...', TRUE);
      disableUserInteraction();
      try
        ZeroMemory(@loadingVFS, sizeof(loadingVFS));
        took:=now();
        data2 := loadfile(fn);
        loadingVfs.bakAvailable:=fileExists(fn+BAK_EXT);
        if not ansiStartsStr(TLV(FK_HEAD, VFS_FILE_IDENTIFIER), data2)
        and not restoreBak(data2) then
          begin
          if data2 = '' then
          msgDlg(MSG_CORRUPTED, MB_ICONERROR);
          exit;
          end;
        try
          initVFS();
          fileSrv.setVFS(data2, NIL, onLoadVFSprogress);
//          setVFS2_(data2);
          if loadingVFS.useBackup and restoreBak(data2) then
            begin
            initVFS();
            fileSrv.setVFS(data2, NIL, onLoadVFSprogress);
            end;
          took:=now()-took;
         finally
          if progFrm.cancelRequested then
            initVFS()
           else
            lastFileOpen:=fn;
          VFSmodified:=FALSE;
          purgeVFSaccounts(); // remove references to non-existent users
          filesBox.FullCollapse();
          var n := fileSrv.getRootNode;
          if Assigned(n) then
            begin
              n.Selected := TRUE;
              n.MakeVisible();
            end;
        end;
       finally
        reenableUserInteraction();
        progFrm.hide();
        filesBox.show();
      end;
      if progFrm.cancelRequested then exit;
      if loadingVFS.macrosFound
      and not stringExists(fn, trustedFiles)
      and (msgDlg(MSG_MACROS_FOUND, MB_ICONWARNING+MB_YESNO, MSG_LOADING_VFS) = mrNo) then
        begin
        initVFS();
        exit;
        end;
      addUniqueString(fn, trustedFiles);
      if loadingVFS.visOnlyAnon then
        msgDlg(MSG_VIS_ONLY_ANON, MB_ICONWARNING, MSG_LOADING_VFS);
      if loadingVFS.resetLetBrowse then msgDlg(MSG_VFS_OLD, MB_ICONWARNING, MSG_LOADING_VFS);
      if loadingVFS.unkFK then msgDlg(MSG_UNK_FK, MB_ICONWARNING, MSG_LOADING_VFS);

      with loadingVFS do disableAutosave:=unkFK or resetLetBrowse or visOnlyAnon;
      if loadingVFS.disableAutosave and anyAutosavingFeatureEnabled() then
        msgDlg(MSG_AUTO_DISABLED, MB_ICONWARNING, MSG_LOADING_VFS);

      setStatusBarText(format('Loaded in %.1f seconds (%s)', [took*SECONDS,fn]), 10);
    end;

  removestring(fn, recentFiles); // avoid duplicates
  insertstring(fn, 0, recentFiles); // insert fn as first element
  removeString(recentFiles, MAX_RECENT_FILES, length(recentFiles)); // shrink2max
  updateRecentFilesMenu();
end; // loadVFS

procedure TmainFrm.logBoxChange(Sender: TObject);
begin logToolbar.visible:=not easyMode and (logBox.Lines.count > 0) end;

procedure Tmainfrm.popupMainMenu();
begin
menuBtn.Down:=TRUE;
with menuBtn.clientToScreen(point(0,menuBtn.height)) do
  menu.popup(x,y);
menuBtn.Down:=FALSE;
end;

procedure TmainFrm.portBtnClick(Sender: TObject);
var
  s: string;
begin
s:=port;
  repeat
  if not inputQuery('Port', 'Specify a port to accept connection,'#13'or leave empty to decide automatically.', s) then exit;
  s:=trim(s);
  if not isOnlyDigits(s) then
    begin
    msgDlg('Numbers only', MB_ICONERROR);
    continue;
    end;
  if changePort(s) then exit;
  sayPortBusy(s);
  until FALSE;
end;

procedure Tmainfrm.updateAlwaysOnTop();
begin
if alwaysOnTopchk.checked then FormStyle:=fsStayOnTop
else formStyle:=fsNormal
end; // updateAlwaysOnTop

procedure TmainFrm.updateBtnClick(Sender: TObject);
begin
if now()-lastUpdateCheck > 1*HOURS then
  autoCheckUpdates(); // refresh update info, in case the button is clicked long after the check

doTheUpdate(clearAndReturn(updateWaiting));
updateBtn.hide();
end;

procedure TmainFrm.Changeeditor1Click(Sender: TObject);
begin selectFile(tplEditor, '', 'Programs|*.exe', [ofFileMustExist]) end;

procedure TmainFrm.Changefile1Click(Sender: TObject);
begin
if selectFile(tplFilename, 'Change template file', 'Template file|*.tpl', [ofPathMustExist, ofCreatePrompt]) then
  setNewTplFile(tplFilename);
end;

procedure TmainFrm.Changeport1Click(Sender: TObject);
begin portBtnClick(portBtn) end;

procedure TmainFrm.Checkforupdates1Click(Sender: TObject);
resourcestring
  MSG_UPD_INFO = 'Last stable version: %s'#13#13'Last untested version: %s'#13;
  MSG_NEWER = 'There''s a new version available online: %s';
  MSG_SRC_UPD = 'Searching for updates...';
var
  updateURL: string;
  info: Ttpl;
begin
progFrm.show(MSG_SRC_UPD);
try info:=downloadUpdateInfo()
finally progFrm.hide() end;

if info = NIL then
  begin
  msgDlg(MSG_COMM_ERROR, MB_ICONERROR);
  exit;
  end;

try
  msgDlg(format(MSG_UPD_INFO, [ info['last stable'], first([info['last untested'],'none']) ]));

  updateURL:='';
  if trim(info['last stable build']) > VERSION_BUILD then
    begin
    msgDlg(format(MSG_NEWER,[info['last stable']]));
    updateURL:=trim(info['last stable url']);
    end
  else
    if (not VERSION_STABLE or testerUpdatesChk.checked)
    and (trim(info['last untested build']) > VERSION_BUILD) then
      begin
      msgDlg(format(MSG_NEWER,[info['last untested']]));
      updateURL:=trim(info['last untested url']);
      end;

  msgDlg(info['notice'], MB_ICONWARNING);
  parseVersionNotice(info['version notice']);
finally info.free end;
promptForUpdating(updateURL);
end;

procedure Tmainfrm.setEasyMode(easy:boolean=TRUE);
resourcestring
  ARE_EXPERT = 'You are in Expert mode';
  ARE_EASY = 'You are in Easy mode';
  SW2EXPERT = 'Switch to Expert mode';
  SW2EASY = 'Switch to Easy mode';
const
  ICO :array [boolean] of integer = (ICON_EXPERT, ICON_EASY);
begin
easyMode:=easy;
switchMode.caption:=ifThen(easyMode, SW2EXPERT, SW2EASY);
//switchMode.imageIndex:=ICO[not easyMode];  disabled because it's ugly, it uses the same icon as the next menu item (accounts)
modeBtn.caption:=ifThen(easyMode, ARE_EASY, ARE_EXPERT);
modeBtn.imageIndex:=ICO[easyMode];
if not easyMode or graphInEasyMode then showGraph()
else hideGraph();
optionsFrm.mimePage.tabVisible:=not easyMode;
optionsFrm.accountsPage.tabVisible:=not easyMode;
optionsFrm.a2nPage.tabVisible:=not easyMode;
logBoxChange(NIL);
updateSbar();
end; // switchEasyMode

procedure TmainFrm.Rename1Click(Sender: TObject);
begin
if assigned(selectedFile) then
  filesBox.Selected.EditText()
end;

procedure TmainFrm.noDownloadtimeout1Click(Sender: TObject);
resourcestring
  MSG_DL_TIMEOUT_LONG = 'Enter the number of MINUTES with no download after which the program automatically shuts down.'
    +#13'Leave blank to get no timeout.';
var
  s:string;
begin
if noDownloadTimeout > 0 then s:=intToStr(noDownloadTimeout)
else s:='';
if inputquery(MSG_DL_TIMEOUT, MSG_DL_TIMEOUT_LONG, s) then
	try setnoDownloadTimeout(strToUInt(s))
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
end;

procedure Tmainfrm.initVFS();
begin
  uploadPaths := NIL;
  fileSrv.clearNodes;
  fileSrv.initRootWithNode(filesBox);
  VFSmodified := FALSE;
  lastFileOpen := '';
end; // initVFS

procedure TmainFrm.alwaysontopChkClick(Sender: TObject);
begin updateAlwaysOnTop() end;

procedure TmainFrm.hideGraph();
begin
graphSplitter.hide();
graphBox.hide();
graphInEasyMode:=FALSE;
end; // hideGraph

procedure TmainFrm.showGraph();
begin
graphSplitter.show();
graphBox.show();
graphBox.Height:=graph.size;
if easyMode then graphInEasyMode:=TRUE;
end; // showGraph

procedure TmainFrm.Showbandwidthgraph1Click(Sender: TObject);
begin showGraph() end;

procedure TmainFrm.Pause1Click(Sender: TObject);
var
  cd: TconnData;
begin
cd:=selectedConnection();
if cd = NIL then exit;
with cd.conn do paused:=not paused;
end;

procedure TmainFrm.MIMEtypes1Click(Sender: TObject);
begin
  showOptions(optionsFrm.mimePage, mainfrm.modalOptionsChk.checked)
end;

procedure TmainFrm.accounts1Click(Sender: TObject);
begin
  showOptions(optionsFrm.accountsPage, mainfrm.modalOptionsChk.checked)
end;

procedure TmainFrm.CopyURL1Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  s:='';
  if filesBox.SelectionCount > 0 then
    for i:=0 to filesBox.SelectionCount-1 do
      s := s+fileSrv.fullURL(nodeTofile(filesBox.Selections[i]))+CRLF;
  setLength(s, length(s)-2);
  setClip(s);
end;

procedure Tmainfrm.copyURLwithPasswordMenuClick(sender:TObject);
var
  a: Paccount;
  user, pwd: string;
  f: Tfile;
begin
if selectedFile = NIL then exit;
user:=(sender as Tmenuitem).caption;
delete(user, pos('&',user), 1);
// protection may have been inherited
f:=selectedFile;
while assigned(f) and (f.accounts[FA_ACCESS] = NIL) and (f.user = '') do
  f:=f.parent;

if assigned(f) and (f.user = user) then
  pwd:=f.pwd
else
  begin
  a:=getAccount(user);
  if assigned(a) then pwd:=a.pwd
  else pwd:='';
  end;

setClip( fileSrv.fullURL(selectedFile,'',user,pwd) )
end; // copyURLwithPasswordMenuClick

procedure Tmainfrm.copyURLwithAddressMenuClick(sender:Tobject);
var
  s, addr: string;
  i: integer;
begin
addr:=(sender as Tmenuitem).Caption;
delete(addr, pos('&',addr), 1);

s:='';
for i:=0 to filesBox.SelectionCount-1 do
  s:=s+fileSrv.fullURL(nodeTofile(filesBox.Selections[i]), addr)+CRLF;
setLength(s, length(s)-2);

setClip(s);
end; // copyURLwithAddressMenuClick

procedure TmainFrm.CopyURLwithfingerprint1Click(Sender: TObject);
var
  f: Tfile;
  s, hash: string;
  i: integer;
begin
if selectedFile = NIL then exit;
s:='';
try
  for i:=0 to filesBox.SelectionCount-1 do
    begin
    f:=filesBox.Selections[i].data;

    progFrm.show('Hashing '+f.name, TRUE);
    progFrm.progress:=i / filesBox.SelectionCount;
    application.ProcessMessages();

    hash:=loadFingerprint(f.resource);
    if (hash = '') and f.isFile() then
      begin
      progFrm.push( 1/filesBox.SelectionCount );
      try hash:=createFingerprint(f.resource);
      finally progFrm.pop() end;
      if saveNewFingerprintsChk.checked and (hash > '') then
        saveFileU(f.resource+'.md5', hash);
      end;
    if progFrm.cancelRequested then exit;
    s:=s + fileSrv.fullURL(f) + nonEmptyConcat('#!md5!', hash) + CRLF;
    end;
finally progFrm.hide() end;
setLength(s, length(s)-2);

urlBox.Text:=getTill(#13, s);
setClip(s);
end;

procedure TmainFrm.urlBoxChange(Sender: TObject);
begin updateCopyBtn() end;

procedure TmainFrm.traymessage1Click(Sender: TObject);
begin
  showOptions(optionsFrm.trayPage, mainfrm.modalOptionsChk.checked)
end;

procedure TmainFrm.Guide1Click(Sender: TObject);
begin openURL(HFS_GUIDE_URL) end;

procedure Tmainfrm.saveVFS(fn:string='');
begin
if blockLoadSave() then exit;
if fn = '' then
  begin
    fn:=lastFileOpen;
    if not promptForFileName(fn, 'VirtualFileSystem|*.vfs|VirtualFileSystem JSON Zipped|*.vfsjz', 'vfs', 'Save VFS', '', TRUE) then
      exit;
  end;
  if isExtension(fn, '.vfsjz') then
    begin
      savefileA(fn, getVFSJZ());
    end
   else
    begin
      lastFileOpen := fn;
      deleteFile(fn+BAK_EXT);
      renameFile(fn, fn+BAK_EXT);
      if not savefileA(fn, addVFSheader(getVFS())) then
        begin
        deleteFile(fn);
        renameFile(fn+BAK_EXT, fn);
        msgDlg('Error saving', MB_ICONERROR);
        exit;
        end;
      if not backupSavingChk.checked then
        deleteFile(fn+BAK_EXT);
      VFSmodified:=FALSE;
      loadingVFS.disableAutosave:=FALSE;
      addUniqueString(fn, trustedFiles);
    end;
end; // saveVFS

procedure TmainFrm.filesBoxAddition(Sender: TObject; Node: TTreeNode);
begin
  VFSmodified:=TRUE;
  if Node.Data <> NIL then
    TFile(Node.Data).SyncNode(Node);
end;

procedure TmainFrm.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
  NewDPI: Integer);
begin
  logBox.Font.PixelsPerInch := NewDPI;
  IconsDM.images.SetSize(MulDiv(16, NewDPI, 96), MulDiv(16, NewDPI, 96));
end;

procedure TmainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
quitting:=TRUE;
if applicationFullyInitialized then
  begin
  runEventScript(fileSrv, 'quit');
  timer.enabled:=FALSE;
  if autosaveOptionsChk.checked and not cfgLoaded then
    saveCFG();
  end;
// we disconnectAll() before srv.free, so we can purgeConnections()
if assigned(srv) then srv.disconnectAll(TRUE);
purgeConnections();
freeAndNIL(srv);
freeAndNIL(tray);
freeAndNIL(tray_ico);
end;

procedure TmainFrm.Logfile1Click(Sender: TObject);
resourcestring
  MSG_LOG_FILE = 'Log file';
  MSG_LOG_FILE_LONG = 'This function does not save any previous information to the log file.'
    +#13'Instead, it saves all information that appears in the log box in real-time (from when you click "OK", below).'
    +#13'Specify a filename for the log.'
    +#13'If you leave the filename blank, no log file is saved.'
    +#13
    +#13'Here are some symbols you can use in the filename to split the log:'
    +#13'  %d% -- day of the month (1..31)'
    +#13'  %m% -- month (1..12)'
    +#13'  %y% -- year (2000..)'
    +#13'  %dow% -- day of the week (0..6)'
    +#13'  %w% -- week of the year (1..53)'
    +#13'  %user% -- username surrounded by parenthesis';
begin
InputQuery(MSG_LOG_FILE, MSG_LOG_FILE_LONG, logFile.filename)
end;

procedure TmainFrm.Font1Click(Sender: TObject);
var
  dlg: TFontDialog;
begin
dlg:=TFontDialog.Create(NIL);
dlg.Font.name:=logFontName;
dlg.Font.size:=logFontSize;
if dlg.Execute then
  begin
  logBox.font.Assign(dlg.Font);
  logFontName:=dlg.Font.Name;
  logFontSize:=dlg.Font.size;
  end;
dlg.free;
end;

procedure TmainFrm.SetURL1Click(Sender: TObject);
resourcestring
  MSG_SET_URL = 'Set URL';
  MSG_SET_URL_LONG = 'Please insert an URL for the link'
    +#13
    +#13'Do not forget to specify http:// or whatever.'
    +#13'%%ip%% will be translated to your address';
var
  i: integer;
  s: string;
begin
if selectedFile = NIL then exit;
s:=selectedFile.resource;
// this is a little help for who's linking an email. We don't mess with http/ftp because even www.asd.com may be the name of a folder.
if ansiContainsStr(s, '@')
and not ansiStartsText('mailto:', s)
and not ansiContainsStr(s, '://')
and not ansiContainsStr(s, '/') then
  s:='mailto:'+s;
if not inputquery(MSG_SET_URL, MSG_SET_URL_LONG, s) then exit;
for i:=0 to filesBox.SelectionCount-1 do
  with nodeToFile(filesBox.Selections[i]) do
    if FA_LINK in flags then
      resource:=s;
VFSmodified:=TRUE;
end;

procedure TmainFrm.Resetuserpass1Click(Sender: TObject);
var
  i: integer;
  f: Tfile;
begin
for i:=0 to filesBox.SelectionCount-1 do
  begin
  f:=filesBox.Selections[i].data;
  usersInVFS.drop(f.user, f.pwd);
  f.user:='';
  f.pwd:='';
  end;
VFSmodified:=TRUE;
filesBox.Repaint();
end;

procedure TmainFrm.Switchtovirtual1Click(Sender: TObject);
var
  f: Tfile;
  under: Ttreenode;
  i: integer;
  bakIcon: integer;
  someLocked: boolean;
  nodes: TtreenodeDynArray;
  sysIcons: Boolean;
begin
  if selectedFile = NIL then
    exit;
  nodes := copySelection();

  addingItemsCounter := 0;
  sysIcons := mainfrm.useSystemIconsChk.checked;
  try
    someLocked:=FALSE;
    for i:=0 to length(nodes)-1 do
      if assigned(nodes[i]) then
        with nodeToFile(nodes[i]) do
          if isRealFolder() and not isRoot() then
            if isLocked() then
              someLocked:=TRUE
             else
              begin
                bakIcon:=icon;
                f:=Tfile.create(filesBox, resource);
                under:=node.Parent;
                include(f.flags, FA_VIRTUAL);
                setNilChildrenFrom(nodes, i);
                node.Delete();
                addFile(f, under, TRUE);
                f.setupImage(sysIcons, bakIcon);
                f.node.Focused:=TRUE;
              end;
    VFSmodified:=TRUE;
    if someLocked then
      msgDlg(MSG_SOME_LOCKED, MB_ICONWARNING);
   finally
    addingItemsCounter:=-1
  end;
end;

procedure TmainFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
queryingClose:=TRUE;
try
  if confirmexitChk.checked and not windowsShuttingDown and not quitASAP then
    if msgDlg('Quit?', MB_ICONQUESTION+MB_YESNO) = IDNO then
      begin
      canclose:=FALSE;
      exit;
      end;
  if not checkVfsOnQuit() then
    begin
    canClose:=FALSE;
    exit;
    end;
  fileSrv.stopAddingItems:=TRUE;
  if lockTimerevent or not applicationFullyInitialized then
    begin
    quitASAP:=TRUE;
    canClose:=FALSE;
    end;
  { it's better to switch off this flag, because some software that has been queried after us may prevent
  { Windows from shutting down, but the flag would stay set, while Windows is no more shutting down. }
  windowsShuttingDown:=FALSE;
finally queryingClose:=FALSE end;
end;

procedure TmainFrm.FormCreate(Sender: TObject);
begin
  screen.onActiveFormChange:=wrapInputQuery;
  easyMode := TRUE;
end;

procedure TmainFrm.Loginrealm1Click(Sender: TObject);
resourcestring
  MSG_REALM = 'Login realm';
  MSG_REALM_LONG = 'The realm string is shown on the user/pass dialog of the browser.'
    +#13'Here you can customize the realm for the login button';
begin
if inputquery(MSG_REALM, MSG_REALM_LONG, loginRealm) then
  loginRealm:=trim(loginRealm);
end;

procedure TmainFrm.Introduction1Click(Sender: TObject);
begin openURL('http://www.rejetto.com/hfs/guide/intro.html') end;

procedure TmainFrm.Reset1Click(Sender: TObject);
begin
zeroMemory(@graph.samplesIn, sizeOf(graph.samplesIn));
zeroMemory(@graph.samplesOut, sizeOf(graph.samplesOut));
graph.maxV:=0;
graph.beforeRecalcMax:=1;
recalculateGraph();
end;

procedure TmainFrm.Resetfileshits1Click(Sender: TObject);
var
  n: Ttreenode;
begin
  repaintTray();
  n := fileSrv.getRootNode;
while assigned(n) do
  begin
  nodeToFile(n).DLcount:=0;
  n:=n.getNext();
  end;
VFSmodified:=TRUE;
autoupdatedFiles.clear();
end;

procedure TmainFrm.persistentconnectionsChkClick(Sender: TObject);
begin
srv.persistentConnections:=persistentconnectionsChk.Checked;
if not srv.persistentConnections then
  Kickidleconnections1Click(NIL);
end;

procedure TmainFrm.Kickidleconnections1Click(Sender: TObject);
var
  i: integer;
begin
i:=0;
while i < srv.conns.count do
  begin
  with conn2data(i) do
    if conn.state = HCS_IDLE then
      disconnect('kicked idle');
  inc(i);
  end;
end;

procedure TmainFrm.Connectionsinactivitytimeout1Click(Sender: TObject);
resourcestring
  MSG_INACT_TIMEOUT = 'Connection inactivity timeout';
  MSG_INACT_TIMEOUT_LONG = 'The connection is kicked after a timeout.'
    +#13'Specify in seconds.'
    +#13'Leave blank to get no timeout.';
var
  s:string;
begin
if connectionsInactivityTimeout <= 0 then s:=''
else s:=intToStr(connectionsInactivityTimeout);
if not inputquery(MSG_INACT_TIMEOUT, MSG_INACT_TIMEOUT_LONG, s) then exit;
try connectionsInactivityTimeout:=strToUInt(s)
except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR) end;
end;

procedure TmainFrm.splitHMoved(Sender: TObject);
begin if connPnl.height > 0 then lastGoodConnHeight:=connPnl.height end;

procedure TmainFrm.Clearfilesystem1Click(Sender: TObject);
resourcestring
  MSG_CHANGES_LOST = 'All changes will be lost'#13'Continue?';
begin
checkIfOnlyCountersChanged();
if VFSmodified and (msgDlg(MSG_CHANGES_LOST, MB_ICONQUESTION+MB_YESNO) = IDNO) then exit;
initVFS();
end;

function checkMultiInstance():boolean;
begin
result:=not mono.working;
if result then msgDlg(MSG_SINGLE_INSTANCE, MB_ICONERROR);
end; // checkMultiInstance

function isIntegratedInShell():boolean;
begin
result:=(loadregistry('*\shell\Add to HFS\command', '', HKEY_CLASSES_ROOT) > '')
  and (loadregistry('Folder\shell\Add to HFS\command','',HKEY_CLASSES_ROOT) >'')
  and (loadregistry('.vfs', '', HKEY_CLASSES_ROOT) > '')
  and (loadregistry('.vfs\shell\Open\command', '', HKEY_CLASSES_ROOT) > '')
end; // isIntegratedInShell

function integrateInShell():boolean;
var
  exe: string;

  function addToContextMenuFor(kind:string):boolean;
  begin
  deleteRegistry(kind+'\shell\HFS', HKEY_CLASSES_ROOT); // legacy: till version 2.0 beta23 we used this key. this call is to keep the registry clean from old unused keys.
  result:=saveRegistry(kind+'\shell\Add to HFS\command', '',
    '"'+exe+'" "%1"', HKEY_CLASSES_ROOT);
  end;

begin
exe:=expandFileName(paramStr(0));
result:=addToContextMenuFor('*')
  and addToContextMenuFor('Folder')
  and saveregistry('.vfs','','HFS file system', HKEY_CLASSES_ROOT)
  and saveregistry('.vfs\shell\Open\command','','"'+exe+'" "%1"', HKEY_CLASSES_ROOT)
end; // integrateInShell

procedure disintegrateShell();
begin
deleteRegistry('*\shell\Add to HFS', HKEY_CLASSES_ROOT);
deleteRegistry('*\shell\HFS', HKEY_CLASSES_ROOT);
deleteRegistry('Folder\shell\Add to HFS', HKEY_CLASSES_ROOT);
deleteRegistry('Folder\shell\HFS', HKEY_CLASSES_ROOT);
deleteRegistry('.vfs\shell\Open\command', HKEY_CLASSES_ROOT);
deleteRegistry('.vfs', HKEY_CLASSES_ROOT);
end; // disintegrateShell

procedure uninstall();
const
  BATCH_FILE = 'hfs.uninstall.bat';
  BATCH = 'START "" /WAIT "%s" -q'+CRLF
    +'DEL "%0:s"'+CRLF
    +'DEL %%0'+CRLF;
begin
  if checkMultiInstance() then exit;
  mainfrm.autosaveoptionsChk.checked:=FALSE;
  disintegrateShell();
  deleteCFG();
  saveFileU(BATCH_FILE, format(BATCH,[paramStr(0)]));
  quitASAP:=TRUE;
  execNew(BATCH_FILE);
end; // uninstall

procedure processParams_before(var params:TStringDynArray; const allowed: String='');
var
  i, n, consume: integer;
  fn: string;

  function getSinglePar():string;
  begin
  if i >= length(params)-1 then raise Exception.Create('missing parameter needed');
  consume:=2;
  result:=params[i+1];
  end; // getSinglePar

begin
//** see if FindCmdLineSwitch() can be useful for the job below
i:=2; // [0] is cwd [1] is the exe file
while i < length(params) do
  begin
  if (length(params[i]) = 2) and (params[i][1] = '-')
  and ((allowed = '') or (pos(params[i][2], allowed) > 0)) then
    begin
    consume:=1; // number of params an option takes
    case params[i][2] of
      'q': quitASAP:=TRUE;
      'u': uninstall();
      'i': cfgPath:=IncludeTrailingPathDelimiter(getSinglePar());
      'b': userIcsBuffer:=strToIntDef(getSinglePar(), 0);
      'B': userSocketBuffer:=strToIntDef(getSinglePar(), 0);
      'd': // delay
        begin
        n:=strToIntDef(getSinglePar(), 0);
        if n > 0 then sleep(n*100);
        end;
      'a':
        begin
        fn:=getSinglePar();
        if not fileExists(fn) then fn:=cfgPath+fn;
        if not fileExists(fn) then exit;
        mainfrm.setcfg(UnUTF(loadFile(fn)));
        end;
      'c': mainfrm.setcfg(unescapeNL(getSinglePar()));
      end;
    for consume:=1 to consume do removeString(params, i);
    continue;
    end;
  inc(i);
  end;
end; // processParams_before

procedure Tmainfrm.processParams_after(var params:TStringDynArray);
var
  i: integer;
  dir: string;
begin
dir:=includeTrailingPathDelimiter(popString(params));
popString(params); // hfs.exe
for i:=0 to length(params)-1 do
  if not isAbsolutePath(params[i]) then
    params[i]:=dir+params[i];
// note: 2 .vfs files will be treated as any file
if (length(params) = 1) and isExtension(params[0], '.vfs') then
  begin
  if blockLoadSave() then exit;
  mainfrm.loadVFS(params[0])
  end
else
  { parameters are also passed by other instances via sendMessage().
  { since this operation may require user interaction, it must be queued
  { because those instances wouldn't quit until the dialog is closed. }
  addArray(filesToAddQ, params);
end; // processParams_after

procedure TmainFrm.Numberofloggeduploads1Click(Sender: TObject);
begin setTrayShows(TS_uploads) end;

procedure TmainFrm.Flagfilesaddedrecently1Click(Sender: TObject);
resourcestring
  MSG_FLAG_NEW = 'Flag new files';
  MSG_FLAG_NEW_LONG = 'Enter the number of MINUTES files stay flagged from their addition.'
    +#13'Leave blank to disable.';
var
  s: string;
begin
if filesStayFlaggedForMinutes <= 0 then s:=''
else s:=intToStr(filesStayFlaggedForMinutes);
if InputQuery(MSG_FLAG_NEW, MSG_FLAG_NEW_LONG, s) then
	try
  	s:=trim(s);
  	if s = '' then filesStayFlaggedForMinutes:=0
    else filesStayFlaggedForMinutes:=strToInt(s);
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
end;

procedure TmainFrm.Flagasnew1Click(Sender: TObject);
var
  i: integer;
begin
if selectedFile = NIL then exit;
for i:=0 to filesBox.SelectionCount-1 do
  nodeTofile(filesBox.Selections[i]).atime:=now();
VFSmodified:=TRUE;
end;

function removeFlagNew(f:Tfile; childrenDone:boolean; par, par2: IntPtr):TfileCallbackReturn;
begin
result:=[];
VFSmodified:=TRUE;
f.atime:=now()-succ(filesStayFlaggedForMinutes)/(24*60)
end; // removeFlagNew

procedure TmainFrm.Resetnewflag1Click(Sender: TObject);
var
  i: integer;
begin
if selectedFile = NIL then exit;
for i:=0 to filesBox.SelectionCount-1 do
  nodeTofile(filesBox.Selections[i]).recursiveApply(removeFlagNew);
VFSmodified:=TRUE;
end;

procedure TmainFrm.resetOptions1Click(Sender: TObject);
var
  keepAccounts: Taccounts;
begin
(sender as Tmenuitem).enabled:=FALSE;
restoreCfgBtn.show();
eventScripts.fullText:='';
backuppedCfg:=getCfg();
keepAccounts:=accounts;
setCfg(defaultCfg);
accounts:=keepAccounts;
end;

procedure Tmainfrm.setStatusBarText(s:string; lastFor:integer);
begin
with sbar.panels[sbar.panels.count-1] do
  begin
  alignment:=taLeftJustify;
  text:=s;
  end;
sbarTextTimeout:=now()+lastFor/SECONDS;
end;

procedure TmainFrm.Donate1Click(Sender: TObject);
begin openURL('http://www.rejetto.com/hfs-donate') end;

procedure TmainFrm.Donotlogaddress1Click(Sender: TObject);
resourcestring
  MSG_DONT_LOG_MASK = 'Do not log address';
  MSG_DONT_LOG_MASK_LONG = 'Any event from the following IP address mask will be not logged.';
begin
inputQuery(MSG_DONT_LOG_MASK, MSG_DONT_LOG_MASK_LONG, dontLogAddressMask)
end;

procedure TmainFrm.Custom1Click(Sender: TObject);
resourcestring
  MSG_CUST_IP = 'Custom IP addresses';
  MSG_CUST_IP_LONG = 'Specify your addresses, each per line';
var
  s: string;
  a: TStringDynArray;
begin
s:=join(CRLF, customIPs);
if not inputQueryLong(MSG_CUST_IP, MSG_CUST_IP_LONG, s) then exit;
customIPs:=split(CRLF, s);
removeStrings('', customIPs);
// change the address if it is not available anymore
a:=getPossibleAddresses();
if assigned(a) and not stringExists(defaultIP, a) then
  setDefaultIP(a[0]);
end;

procedure TmainFrm.Findexternaladdress1Click(Sender: TObject);
resourcestring
  MSG_NO_EXT_IP = 'Can''t find external address'#13'( %s )';
var
  service: string;
begin
// this is a manual request, try twice
if not getExternalAddress(externalIP, @service)
and not getExternalAddress(externalIP, @service) then
  begin
  msgDlg(format(MSG_NO_EXT_IP, [service]), MB_ICONERROR);
  exit;
  end;
setDefaultIP(externalIP);
msgDlg(externalIP);
end;

procedure TmainFrm.sbarDblClick(Sender: TObject);
resourcestring
  MSG_RESET_TOT = 'Do you want to reset total in/out?';
var
  i: integer;
begin
i:=whatStatusPanel(sbar,sbar.screenToClient(mouse.cursorPos).X);
if (i = sbarIdxs.totalIn) or (i = sbarIdxs.totalOut) then
  if msgDlg(MSG_RESET_TOT, MB_YESNO) = IDYES then
    begin
    outTotalOfs:=-srv.bytesSent;
    inTotalOfs:=-srv.bytesReceived;
    end;
if i = sbarIdxs.banStatus then BannedIPaddresses1Click(NIL);
if i = sbarIdxs.customTpl then Edit1Click(NIL);
if i = sbarIdxs.oos then Minimumdiskspace1Click(NIL);
if i = sbarIdxs.out then Speedlimit1Click(NIL);
if i = sbarIdxs.notSaved then Savefilesystem1Click(NIL); 
end;

procedure TmainFrm.sbarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
// since right click is not used for now, it will act as double click
if button = mbRight then
  sbarDblClick(sender);
end;

procedure forceDynDNSupdate(url:string='');
resourcestring
  MSG_DISAB_FIND_EXT = 'This option makes pointless the option "Find external address at startup", which has now been disabled for your convenience.';
begin
dyndns.url:=url;
if url = '' then exit; 
// this function is called when setting any dyndns service.
// calling it from somewhere else may make the following test unsuitable
if mainfrm.findExtOnStartupChk.checked then
  begin
  mainfrm.findExtOnStartupChk.checked:=FALSE;
  msgDlg(MSG_DISAB_FIND_EXT, MB_ICONINFORMATION);
  exit;
  end;
dyndns.active:=TRUE;
dyndns.lastIP:='';
externalIP:='';
end; // forceDynDNSupdate

procedure TmainFrm.Custom2Click(Sender: TObject);
resourcestring
  MSG_ENT_URL = 'Enter URL';
  MSG_ENT_URL_LONG = 'Enter URL for updating.'
    +#13'%ip% will be translated to your external IP.';
var
  s: string;
begin
s:=dyndns.url;
if inputQuery(MSG_ENT_URL, MSG_ENT_URL_LONG, s) then
  forceDynDNSupdate(s);
end;

procedure TmainFrm.Defaultpointtoaddfiles1Click(Sender: TObject);
begin
if selectedFile = NIL then exit;
addToFolder:= fileSrv.URL(selectedFile);
msgDlg(MSG_OK);
end;

function dynDNSinputUserPwd():boolean;
resourcestring
  MSG_ENT_USR = 'Enter user';
  MSG_ENT_PWD = 'Enter password';
begin
result:=inputQuery(MSG_ENT_USR, MSG_ENT_USR, dyndns.user)
  and (dyndns.user > '')
  and inputQuery(MSG_ENT_PWD, MSG_ENT_PWD, dyndns.pwd)
  and (dyndns.pwd > '');
dyndns.user:=trim(dyndns.user);
dyndns.pwd:=ifThen(dyndns.user='', '', trim(dyndns.pwd));
end; // dynDNSinputUserPwd

function dynDNSinputHost():boolean;
resourcestring
  MSG_ENT_HOST = 'Enter host';
  MSG_ENT_HOST_LONG = 'Enter domain (full form!)';
  MSG_HOST_FORM = 'Please, enter it in the FULL form, with dots';
begin
result:=FALSE;
while true do
  begin
  if not inputQuery(MSG_ENT_HOST, MSG_ENT_HOST_LONG, dyndns.host)
  or (dyndns.host = '') then exit;
  dyndns.host:=trim(dyndns.host);
  if pos('://', dyndns.host) > 0 then
    chop('://', dyndns.host);
  if pos('.', dyndns.host) > 0 then
    begin
    result:=TRUE;
    exit;
    end;
  msgDlg(MSG_HOST_FORM, MB_ICONERROR);
  end;
end; // dynDNSinputHost

procedure finalizeDynDNS();
begin
addUniqueString(dyndns.host, customIPs);
setDefaultIP(dyndns.host);
end; // finalizeDynDNS

procedure TmainFrm.NoIPtemplate1Click(Sender: TObject);
begin
if not dynDNSinputUserPwd() or not dynDNSinputHost() then exit;
forceDynDNSupdate('http://'+dyndns.user+':'+dyndns.pwd+'@dynupdate.no-ip.com/nic/update?hostname='+dyndns.host);
finalizeDynDNS();
end;

procedure TmainFrm.CJBtemplate1Click(Sender: TObject);
begin
if not dynDNSinputUserPwd() then exit;
forceDynDNSupdate('http://www.cjb.net/cgi-bin/dynip.cgi?username='+dyndns.user+'&password='+dyndns.pwd+'&ip=%ip%');
dyndns.host:=dyndns.user+'.cjb.net';
finalizeDynDNS();
end;

procedure TmainFrm.DynDNStemplate1Click(Sender: TObject);
begin
if not dynDNSinputUserPwd() or not dynDNSinputHost() then exit;
forceDynDNSupdate('http://'+dyndns.user+':'+dyndns.pwd+'@members.dyndns.org/nic/update?hostname='+dyndns.host+'&myip=%ip%&wildcard=NOCHG&backmx=NOCHG&mx=NOCHG&system=dyndns');
finalizeDynDNS();
end;

procedure TmainFrm.Minimumdiskspace1Click(Sender: TObject);
resourcestring
  MSG_MIN_SPACE = 'Min disk space';
  MSG_MIN_SPACE_LONG = 'The upload will fail if your disk has less than the specified amount of free MegaBytes.';
var
  s: string;
begin
if minDiskSpace <= 0 then s:=''
else s:=intToStr(minDiskSpace);
if InputQuery(MSG_MIN_SPACE, MSG_MIN_SPACE_LONG, s) then
	try
  	s:=trim(s);
  	if s = '' then minDiskSpace:=0
    else minDiskSpace:=strToInt(s);
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
end;

function pointToCharPoint(re:TRichEdit; pt:Tpoint):Tpoint;
const
  EM_EXLINEFROMCHAR = WM_USER+54;
begin
result.x:=re.perform(EM_CHARFROMPOS, 0, NativeInt(@pt));
if result.x < 0 then exit;
result.y:=re.perform(EM_EXLINEFROMCHAR, 0, result.x);
dec(result.x, re.perform(EM_LINEINDEX, result.y, 0));
end; // pointToCharPoint

function Tmainfrm.ipPointedInLog():string;
var
  s: string;
  pt: Tpoint;
begin
result:='';
pt:=pointToCharPoint(logBox, logRightClick);
if pt.x < 0 then
  pt:=logbox.caretpos;
if pt.y >= logbox.lines.count then
  exit;
s:=logbox.lines[pt.y];
s:=reGet(s, '^.+  (\S+@)?\[?(\S+?)\]?:\d+  ', 2);
if checkAddressSyntax(s,FALSE) then
  result:=s;
end; // ipPointedInLog

procedure TmainFrm.logBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var pt: Tpoint;
begin
if button = mbRight then
  begin
  logRightClick:=point(x,y);
  pt:=pointToCharPoint(logBox, Point(x,y));
  if pt.x >= 0 then
    logBox.CaretPos:=pt;
  end;
end;

procedure TmainFrm.Banthisaddress1Click(Sender: TObject);
begin banAddress(ipPointedInLog()); end;

procedure TmainFrm.Address2name1Click(Sender: TObject);
begin
  showOptions(optionsFrm.a2nPage, mainfrm.modalOptionsChk.checked)
end;

procedure TmainFrm.Addresseseverconnected1Click(Sender: TObject);
begin
if modalOptionsChk.checked then ipsEverFrm.ShowModal()
else ipsEverFrm.show()
end;

procedure TmainFrm.Renamepartialuploads1Click(Sender: TObject);
resourcestring
  MSG_REN_PART = 'Rename partial uploads';
  MSG_REN_PART_LONG = 'This string will be appended to the filename.'
    +#13
    +#13'If you need more control, enter a string with %name% in it, and this symbol will be replaced by the original filename.';
begin
InputQuery(MSG_REN_PART, MSG_REN_PART_LONG, renamePartialUploads)
end;

procedure TmainFrm.SelfTest1Click(Sender: TObject);
resourcestring
  MSG_SELF_BEFORE = 'Here you can test if your server does work on the Internet.'
    +#13'If you are not interested in serving files over the Internet, this is NOT for you.'
    +#13
    +#13'We''ll now perform a test involving network activity.'
    +#13'In order to complete this test, you may need to allow HFS''s activity in your firewall, by clicking Allow on the warning prompt.'
    +#13
    +#13'WARNING: for the duration of the test, all ban rules and limits on the number of connections won''t apply.';
  MSG_SELF_OK = 'The test is successful. The server should be working fine.';
  MSG_SELF_OK_PORT = 'Port %s is not working, but another working port has been found and set: %s.';
  MSG_SELF_3 = 'You may be behind a router or firewall.';
  MSG_SELF_6 = 'You are behind a router.'
    +#13'Ensure it is configured to forward port %s to your computer.';
  MSG_SELF_7 = 'You may be behind a firewall.'
    +#13'Ensure nothing is blocking HFS.';

  function doTheTest(host:string; port:string=''):string;

    function findRedirection():boolean;
    var
      http: THttpCli;
    begin
    result:=FALSE;
    http:=Thttpcli.create(NIL);
    try
      http.url:=host;
      http.agent:=HFS_HTTP_AGENT;
      try http.get()
      except // a redirection will result in an exception
        if (http.statusCode < 300) or (http.statusCode >= 400) then exit;        
        result:=TRUE;
        host:=http.hostname;
        port:=http.ctrlSocket.Port;
        end;
    finally http.free end
    end;

  var
    t: Tdatetime;
    ms: integer;
    name: string;
  begin
  result:='';
  if progFrm.cancelRequested then exit;
  { The user may be using the "port 80 redirect" service of no-ip, or a similar one.
  { The redirection service does not support a request containing "test" as URL,
  { considering it malformed (it requires a leading slash).
  { Thus, we need to find the redirect here (client-side), and then test to see if
  { the target of the redirection is a working HFS. }
  if (port = '') and not checkAddressSyntax(host) and noPortInUrlChk.Checked then
    name:=ifThen(findRedirection(), host);
  if port = '' then
    port:=srv.port;
  if name = '' then
    name:=host+':'+port;
  progFrm.show('Testing '+name+' ...', TRUE);
  if not srv.active and not startServer() then exit;
  // we many need to try this specific test more than once
    repeat
    t:=now();
    try
//        result:=UnUTF(httpGet(SELF_TEST_URL+'?port='+port+'&host='+host+'&natted='+YESNO[localIPlist.IndexOf(externalIP)<0] ))
      result:=UnUTF(httpGet(SELF_TEST_URL+'?port='+port+'&host='+host+'&natted='+YESNO[not stringExists(externalIP, getAcceptOptions())] ))
    except break end;
    t:=now()-t;
    if (result ='') or (result[1] <> '4') or progFrm.cancelRequested then break;
    ms:=3100-round(t*SECONDS*1000); // we mean to never query faster than 1/3s
    if ms > 0 then
      sleep(ms);
    until progFrm.cancelRequested;
  end; // doTheTest

  function successful(s:string):boolean;
  begin result:=(s > '') and (s[1] = '1') end;

var
  best: record host, res: string; end;

  procedure tryDifferentHosts();
  resourcestring
    MSG_RET_EXT = 'Retrieving external address...';
  var
    i: integer;
    tries: TStringDynArray;
    s: string;
  begin
  if externalIP = '' then
    begin
    progFrm.show(MSG_RET_EXT);
    getExternalAddress(externalIP);
    end;
  tries:=getPossibleAddresses();
  // ensure defaultIP is the first one
  insertString(defaultIP, 0, tries);
  uniqueStrings(tries);

  best.res:='';
  for i:=0 to length(tries)-1 do
    begin
    if isLocalIP(tries[i]) then continue;

    progFrm.progress:=succ(i)/succ(length(tries));
    s:=doTheTest(tries[i]);
    // we want a digit
//    if (s='') or not (s[1] in ['0'..'9']) then continue;
    if (s='') or not (IsDigit(s[1])) then continue;
    // we want a better one (lower)
    if (best.res > '') and (best.res[1] <= s[1]) then continue;
    // we consider this to be better, record it
    best.res:=s;
    best.host:=tries[i];
    if successful(s) then break;
    end;
  end; // tryDifferentHosts

  procedure tryDifferentPorts();
  var
    i: integer;
    tries: TStringDynArray;
    bak: record
      port: string;
      active: boolean;
      end;
    ip, s: string;
  begin
  ip:=defaultIP;
  if isLocalIP(ip) then
    ip:=externalIP;
  if (ip='') or isLocalIP(ip) then
    exit;
  // build list of ports we'll test
  tries:=toSA(['80','8123']);
  removeString(srv.port, tries); // already tested

  bak.active:=srv.active;
  bak.port:=port;
  for i:=0 to length(tries)-1 do
    begin
    progFrm.progress:=succ(i)/succ(length(tries));
    port:=tries[i];
    stopServer();
    if not startServer() then continue;
    s:=doTheTest(ip);
    if successful(s) then break;
    end;
  if successful(s) and (best.res = '') then
    begin
    best.res:=s;
    best.host:=defaultIP;
    end
  else
    begin
    port:=bak.port;
    stopServer();
    if bak.active then startServer();
    end;
  end; // tryDifferentPorts

resourcestring
  MSG_SELF_CANT_ON = 'Unable to switch the server on';
  MSG_SELF_CANT_LIST = 'Self test cannot be performed because HFS was configured to accept connections only on 127.0.0.1';
  MSG_SELF_CANT_S = 'Self test doesn''t support HTTPS.'#13'It''s likely it won''t work.';
  MSG_SELF_ING = 'Self testing...';
  MSG_TEST_CANC = 'Test cancelled';
  MSG_TEST_INET = 'Testing internet connection...';
  MSG_SELF_UNAV = 'Sorry, the test is unavailable at the moment';
  MSG_SELF_NO_INET = 'Your internet connection does not work';
  MSG_SELF_NO_ANSWER = 'The test failed: server does not answer.';
var
  originalPort, s: string;
begin
if msgDlg(MSG_SELF_BEFORE, MB_ICONWARNING+MB_OKCANCEL) <> IDOK then exit;

originalPort:=port;

if not srv.active and not startServer() then
  begin
  port:='';
  if not startServer() then
    begin
    msgDlg(MSG_SELF_CANT_ON, MB_ICONERROR);
    exit;
    end;
  end;

if listenOn = '127.0.0.1' then
  begin
  msgDlg(MSG_SELF_CANT_LIST, MB_ICONERROR);
  exit;
  end;

if httpsUrlsChk.checked then
  msgDlg(MSG_SELF_CANT_S, MB_ICONWARNING);

disableUserInteraction();
progFrm.show(MSG_SELF_ING);
selfTesting:=TRUE;
try
  best.res:='';
  progFrm.push(0.5);
  tryDifferentHosts();
  progFrm.pop();

  progFrm.push(0.4);
  if not successful(best.res) then
    tryDifferentPorts();
  progFrm.pop();

  s:=best.res;
  if successful(s) then
    begin
    progFrm.progress:=1;
    if (originalPort = '') or (originalPort = port) then
      msgDlg(MSG_SELF_OK)
    else
      msgDlg(format(MSG_SELF_OK_PORT, [originalPort, port]));
    if best.host <> defaultIP then setDefaultIP(best.host);
    exit;
    end
  else


  if progFrm.cancelRequested then
    begin
    msgDlg(MSG_TEST_CANC);
    exit;
    end;

  // error
  if s = '' then
    try
      progFrm.show(MSG_TEST_INET);
      if httpGet(ALWAYS_ON_WEB_SERVER) > '' then
        s:=MSG_SELF_UNAV
       else
        s:=MSG_SELF_NO_INET;
    except s:=MSG_SELF_NO_INET end
  else
    begin
    case s[1] of
      '3': s:=MSG_SELF_3;
      '6': s:=format(MSG_SELF_6, [first(port,'80')]);
      '7': s:=MSG_SELF_7;
      end;
    s:=MSG_SELF_NO_ANSWER+#13#13+s;
    end;
  msgDlg(s, MB_ICONERROR);

finally
  selfTesting:=FALSE;
  reenableUserInteraction();
  progFrm.hide();
  end;
end;

procedure TmainFrm.Opendirectlyinbrowser1Click(Sender: TObject);
resourcestring
  MSG_OPEN_BROW = 'Open directly in browser';
  MSG_OPEN_BROW_LONG = '"Suggest" the browser to open directly the specified files.'
    +#13'Other files should pop up a save dialog.';
begin
InputQuery(MSG_OPEN_BROW, MSG_OPEN_BROW_LONG, openInBrowser)
end;

procedure TmainFrm.noPortInUrlChkClick(Sender: TObject);
resourcestring
  MSG_HIDE_PORT = 'You should not use this option unless you really know its meaning.'
    +#13'Continue?';
begin
if noPortInUrlChk.Checked and (msgDlg(MSG_HIDE_PORT, MB_YESNO) = ID_YES) then
  mainfrm.updateUrlBox()
else
  noPortInUrlChk.Checked:=FALSE;
end;

function getTplEditor():string;
begin
result:=first([
  if_(fileExists(tplEditor), nonEmptyConcat('"', tplEditor, '"')),
  loadregistry('SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\notepad++.exe', '', HKEY_LOCAL_MACHINE),
  'notepad.exe'
])
end;

procedure TmainFrm.Edit1Click(Sender: TObject);
begin
if not fileExists(tplFilename) then
  begin
  tplFilename:=TPL_FILE;
  saveFileU(tplFilename, defaultTpl.fullTextS);
  end;
exec(getTplEditor(), '"'+tplFilename+'"');
end;

procedure TmainFrm.Editeventscripts1Click(Sender: TObject);
resourcestring
  MSG_EVENTS_HLP = 'For help on how to use this file please refer http://www.rejetto.com/wiki/?title=HFS:_Event_scripts';
var
  fn: string;
begin
fn:=cfgPath+EVENTSCRIPTS_FILE;
if not fileExists(fn) then
  saveFileU(fn, MSG_EVENTS_HLP);
exec(getTplEditor(), '"'+fn+'"');
end;

procedure TmainFrm.Editresource1Click(Sender: TObject);
resourcestring
  MSG_EDIT_RES = 'Edit resource';
var
  oldRes, oldName, res: string;
  done, nameSync: boolean;
begin
  if (selectedFile = NIL) or (FA_VIRTUAL in selectedFile.flags) then
    exit;
  res := selectedFile.resource;
  oldRes := res;
  oldName := selectedFile.name;
  // name sync, only if the name was not customized
  nameSync := selectedFile.name = ExtractFileName(selectedFile.resource);
  if selectedFile.isFolder then
    done := selectFolder(MSG_EDIT_RES, res)
   else
    done := PromptForFileName(res, '', '', MSG_EDIT_RES);
  if done then
    VFSmodified := TRUE;
  selectedFile.setResource(res);
  if not nameSync then
    selectedFile.setName(oldName);
  selectedFile.setupImage(mainfrm.useSystemIconsChk.checked);
end;

procedure TmainFrm.enableMacrosChkClick(Sender: TObject);
resourcestring
  MSG_TPL_USE_MACROS = 'The current template is using macros.'
    +#13'Do you want to cancel this action?';
begin
  if anyMacroMarkerIn(fileSrv.tpl.fullTextS) and not enableMacrosChk.Checked then
    enableMacrosChk.Checked:=msgDlg(MSG_TPL_USE_MACROS, MB_ICONWARNING+MB_YESNO) = MRYES;
end;

procedure TmainFrm.modeBtnClick(Sender: TObject);
begin setEasyMode(not easyMode) end;

procedure TmainFrm.Shellcontextmenu1Click(Sender: TObject);
begin
if isIntegratedInShell() then disintegrateShell()
else if integrateInShell() then msgDlg(MSG_ADD_TO_HFS)
else msgDlg(MSG_ERROR_REGISTRY, MB_ICONERROR);
end;

procedure TmainFrm.menuBtnClick(Sender: TObject);
begin popupMainMenu() end;

var
  bakShellMenuText: string;
procedure TmainFrm.menuPopup(Sender: TObject);
resourcestring
  REMOVE_SHELL = 'Remove from shell context menu';
  S_OFF = 'Switch OFF';
  S_ON = 'Switch ON';
  LOG = 'Log';

  procedure showSetting(mi:Tmenuitem; v:integer; unit_:string); overload;
  begin mi.caption:=getTill('...', mi.caption, TRUE)+if_(v>0, format('       (%d %s)', [v, unit_])) end;

var
  i: integer;
begin
  if quitting then exit; // here we access some objects like srv that may not be ready anymore

  refreshIPlist();
  if Fingerprints1.Count > 0 then
    for i:=1 to Fingerprints1.Count-1 do
      Fingerprints1.items[i].Enabled:=fingerprintsChk.checked;

  logmenu.items.caption:=LOG;
  if menu.items.find(logmenu.items.caption) = NIL then
    menu.items.insert(7, logmenu.items);

  SwitchON1.imageIndex:=if_(srv.active, 11, 4);
  SwitchON1.caption:=if_(srv.active, S_OFF, S_ON);

stopSpidersChk.Enabled:=not fileExistsByURL('/robots.txt');
Showbandwidthgraph1.visible:=not graphBox.visible;
if bakShellMenuText='' then
  bakShellMenuText:=Shellcontextmenu1.Caption;
Shellcontextmenu1.Caption:=if_(isIntegratedInShell(), REMOVE_SHELL, bakShellMenuText);
showSetting(mainFrm.Connectionsinactivitytimeout1, connectionsInactivityTimeout, 'seconds');
showSetting(mainFrm.Minimumdiskspace1, minDiskSpace, 'MB');
showSetting(mainFrm.Flagfilesaddedrecently1, filesStayFlaggedForMinutes, 'minutes');
Restore1.visible:=trayed;
Restoredefault1.Enabled:=tplIsCustomized;
Numberofcurrentconnections1.Checked:= trayShows = TS_connections;
Numberofloggedhits1.checked:= trayShows= TS_hits;
Numberofloggeddownloads1.checked:= trayShows= TS_downloads;
Numberofloggeduploads1.Checked:= trayShows= TS_uploads;
NumberofdifferentIPaddresses1.Checked:= trayShows= TS_ips;
NumberofdifferentIPaddresseseverconnected1.Checked:= trayShows= TS_ips_ever;
ondownloadChk.checked:= flashOn='download';
onconnectionChk.checked:= flashOn='connection';
never1.checked:= flashOn='';
defaultToVirtualChk.Checked:= addFolderDefault='virtual';
defaultToRealChk.Checked:= addFolderDefault='real';
askFolderKindChk.Checked:= addFolderDefault='';
name1.Checked:= TRUE;
time1.Checked:= defSorting='time';
size1.checked:= defSorting='size';
hits1.Checked:= defSorting='hits';
Extension1.Checked:= defSorting='ext';
Renamepartialuploads1.Enabled:=not deletePartialUploadsChk.checked;
Seelastserverresponse1.visible:= dyndns.lastResult>'';
Disable1.visible:= dyndns.url>'';
try RunHFSwhenWindowsstarts1.checked:= paramStr(0) = readShellLink(startupFilename)
except RunHFSwhenWindowsstarts1.checked:= FALSE end;
// point out where the options will automatically be saved
tofile1.Default:= saveMode=SM_FILE;
toregistrycurrentuser1.default:= saveMode=SM_USER;
toregistryallusers1.Default:= saveMode=SM_SYSTEM;

Reverttopreviousversion1.Visible:=fileExists(exePath+PREVIOUS_VERSION);
Saveoptions1.visible:=not easyMode;
testerUpdatesChk.visible:=not easyMode;
preventStandbyChk.visible:=not easyMode;
searchbetteripChk.visible:=not easyMode;
Addfiles2.visible:=easyMode;
Addfolder2.visible:=easyMode;
freeLoginChk.visible:=not easyMode;
Speedlimitforsingleaddress1.visible:=not easyMode;
quitWithoutAskingToSaveChk.visible:=not easyMode;
backupSavingChk.visible:=not easyMode;
Defaultsorting1.visible:=not easyMode;
sendHFSidentifierChk.visible:=not easyMode;
URLencoding1.visible:=not easyMode;
persistentconnectionsChk.visible:=not easyMode;
DMbrowserTplChk.visible:=not easyMode;
MIMEtypes1.visible:=not easyMode;
compressedbrowsingChk.visible:=not easyMode;
modalOptionsChk.visible:=not easyMode;
Allowedreferer1.visible:=not easyMode;
Fingerprints1.visible:=not easyMode;
findExtOnStartupChk.visible:=not easyMode;
listfileswithsystemattributeChk.visible:=not easyMode;
Custom1.visible:=not easyMode;
noPortInUrlChk.visible:=not easyMode;
DynamicDNSupdater1.visible:=not easyMode;
only1instanceChk.visible:=not easyMode;
Flashtaskbutton1.visible:=not easyMode;
HintsfornewcomersChk.visible:=not easyMode;
Graphrefreshrate1.visible:=not easyMode;
foldersbeforeChk.visible:=not easyMode;
listfileswithhiddenattributeChk.visible:=not easyMode;
saveTotalsChk.visible:=not easyMode;
trayfordownloadChk.visible:=not easyMode;
Accounts1.visible:=not easyMode;
VirtualFileSystem1.visible:=not easyMode;
Pausestreaming1.visible:=not easyMode;
Maxconnections1.visible:=not easyMode;
Maxconnectionsfromsingleaddress1.visible:=not easyMode;
maxIPsDLing1.visible:=not easyMode;
maxIPs1.visible:=not easyMode;
MaxDLsIP1.visible:=not easyMode;
Connectionsinactivitytimeout1.visible:=not easyMode;
minimumDiskSpace1.visible:=not easyMode;
HTMLtemplate1.visible:=not easyMode;
shellcontextmenu1.visible:=not easyMode;
useCommentAsRealmChk.visible:=not easyMode;
openDirectlyInBrowser1.visible:=not easyMode;
keepBakUpdatingChk.visible:=not easyMode;
loginRealm1.visible:=not easyMode;
DumprequestsChk.visible:=not easyMode;
logBytesreceivedChk.visible:=not easyMode;
logBytessentChk.visible:=not easyMode;
logconnectionsChk.visible:=not easyMode;
logDisconnectionsChk.visible:=not easyMode;
autoCommentChk.visible:=not easyMode;
traymessage1.visible:=not easyMode;
showmaintrayiconChk.visible:=not easyMode;
numberOfLoggedHits1.visible:=not easyMode;
Showcustomizedoptions1.visible:=not easyMode;
enableNoDefaultChk.visible:=not easyMode;
browseUsingLocalhostChk.visible:=not easyMode;
useISOdateChk.visible:=not easyMode;
Addicons1.visible:=not easyMode;
Acceptconnectionson1.visible:=not easyMode;
numberFilesOnUploadChk.visible:=not easyMode;
Renamepartialuploads1.visible:=not easyMode;
deletePartialUploadsChk.visible:=not easyMode;
updateAutomaticallyChk.visible:=not easyMode;
stopSpidersChk.visible:=not easyMode;
linksBeforeChk.visible:=not easyMode;
Debug1.visible:=not easyMode;
delayUpdateChk.visible:=not easyMode;
end;

function paramsAsArray():TStringDynArray;
var
  i: integer;
begin
i:=paramCount();
setlength(result, i+2);
result[0]:=monoLib.initialPath;
for i:=0 to i do result[i+1]:=paramStr(i);
end; // paramsAsArray

function Tmainfrm.finalInit():boolean;

  function getBrowserPath():string;
  var
    i: integer;
  begin
  result:=loadRegistry('HTTP\shell\open\command', '', HKEY_CLASSES_ROOT);
  if result = '' then exit;
  i:=nonQuotedPos(' ', result);
  if i > 0 then
    delete(result, i, MAXINT);
  result:=dequote(result);
  end; // getBrowserPath

  procedure fixAddToHFS();
  var
    should: string;

    procedure fix(kind:string);
    var
      s: string;
    begin
    s:=loadregistry(kind+'\shell\Add to HFS\command', '', HKEY_CLASSES_ROOT);
    if (s > '') and (s <> should) then
      saveRegistry(kind+'\shell\Add to HFS\command','', should, HKEY_CLASSES_ROOT);
    end;

  begin
  should:='"'+expandFileName(paramstr(0))+'" "%1"';
  fix('*');
  fix('Folder');
  end; // fixAddToHFS

  function loadAndApplycfg():boolean;
  resourcestring
    MSG_RE_NOIP = 'You are invited to re-insert your No-IP configuration, otherwise the updater won''t work as expected.';
  var
    iniS, tplS: string;
  begin
    loadCfg(iniS, tplS);
    result := setcfg(iniS, FALSE);
    // convert old no-ip template url to new one (build#204)
    if dyndns.active and ansiContainsText(dyndns.url, 'no-ip.com') and not ansiContainsText(dyndns.url, 'nic/update')
    and (msgDlg(MSG_RE_NOIP, MB_OKCANCEL+MB_ICONWARNING) = MROK) then
        NoIPtemplate1Click(NIL);
    if (tplS > '') and assigned(fileSrv.tpl) then
      setTplText(tplS);
    if lastUpdateCheck = 0 then
      lastUpdateCheck:=getMtime(lastUpdateCheckFN);
  end; // loadAndApplycfg

  procedure strToConnColumns(l: String);
  var
    s, labl: string;
    i: integer;
  begin
   while l > '' do
    with connBox.columns do
      begin
       s := chop('|',l);
       if s = '' then
         continue;
       labl := chop(';',s);
       for i:=0 to count-1 do
        with items[i] do
         if caption = labl then
           begin
            width := strToIntDef(s, width);
            break;
           end;
      end;
  end; // strToConnColumns

resourcestring
  MSG_TRAY_DEF = '%ip%'#13'Uptime: %uptime%'#13'Downloads: %downloads%';
  MSG_CLEAN_START = 'Clean start';
  MSG_RESTORE_BAK = 'A file system backup has been created for a system shutdown.'#13'Do you want to restore this backup?';
  MSG_EXT_ADDR_FAIL = 'Search for external address failed';
var
  params: TStringDynArray;
begin
  result := FALSE;

{ it would be nice, but this is screwing our layouts. so for now we'll just stay with the main window.
for i:=0 to application.componentCount-1 do
  if application.components[i] is Tform then
    fixFontFor(application.components[i] as Tform);
}
fixFontFor(mainFrm);
sbar.canvas.font.assign(sbar.font); // this is just a workaround, i don't exactly understand the need of it.

// some windows versions do not support multiline tray tips
if winVersion < WV_2000 then trayNL:='  ';

trayMsg:=MSG_TRAY_DEF;

startingImagesCount:= IconsDM.images.count;
srv:=ThttpSrv.create();
srv.autoFreeDisconnectedClients:=FALSE;
srv.limiters.add(globalLimiter);
srv.onEvent:=httpEvent;
tray_ico:=Ticon.create();
tray:=TmyTrayicon.create(self.Handle);
DragAcceptFiles(handle, true);
caption:=format('HFS ~ HTTP File Server %s%sBuild %s',
  [srvConst.VERSION, stringOfChar(' ',80), VERSION_BUILD]);
application.Title:=format('HFS %s (%s)', [srvConst.VERSION, VERSION_BUILD]);
setSpeedLimit(-1);
setSpeedLimitIP(-1);
setGraphRate(10);
setMaxConnections(0);
setMaxConnectionsIP(0);
setMaxDLs(0);
setMaxDLsIP(0);
setMaxIPs(0);
setMaxIPsDLing(0);
setnoDownloadTimeout(0);
setAutosave(autosaveVFS, 0);
setAutoFingerprint(0);
setLogToolbar(FALSE);

autosaveVFS.minimum:=5;
autosaveVFS.menu:=autosaveevery1;

params:=paramsAsArray();
processParams_before(params, 'i');

fileSrv := TFileServer.Create(scriptLib.tryApplyMacrosAndSymbols, getSP, getLP,
                              onAddingItemOnServer);

initVFS();
setFilesBoxExtras(winVersion <> WV_VISTA);

defaultCfg:=xtpl(getCfg(), ['active=no', 'active=yes']);

loadEvents();
cfgLoaded:=FALSE;
// if SHIFT is pressed skip configuration loading
if not holdingKey(VK_SHIFT) then
  cfgLoaded:=loadAndApplyCFG()
else
  setStatusBarText(MSG_CLEAN_START);

// CTRL avoids the only1instance setting
if not holdingKey(VK_CONTROL)
and only1instanceChk.checked and not mono.master then
  begin
  result:=FALSE;
  quitASAP:=TRUE;
  end;

if not cfgLoaded then
  setTplText();
  
processParams_before(params);

if not quitASAP then
  begin

  if not cfgLoaded then
    begin
    startServer();
    if not isIntegratedInShell() then
      with TshellExtFrm.create(mainfrm) do
        try
          case showModal() of
            mrYes:
              if not integrateInShell() then
                msgDlg(MSG_ERROR_REGISTRY, MB_ICONERROR);
            mrNo:;
            else
              begin
              application.terminate();
              exit;
              end;
          end;
        finally free end;
    end;

  if findExtOnStartupChk.checked and getExternalAddress(externalIP) then
    setDefaultIP(externalIP);

  end;

// no address set or not available anymore
if not stringExists(defaultIP, getPossibleAddresses()) then
  setDefaultIP(getIP());

progFrm:=TprogressForm.create();
progFrm.preventBackward:=TRUE;
updateUrlBox();
application.HintPause:=100;
splitV.AutoSnap:=FALSE;
splitV.AutoSnap:=TRUE;
splitV.update();
graph.size:=graphBox.height;
if not quitASAP then
  begin
  if autocopyURLonStartChk.Checked then
    setClip(fileSrv.fullURL(fileSrv.rootFile) );


  if reloadonstartupChk.checked then
    if not fileExists(lastFileOpen) and not fileExists(lastFileOpen+BAK_EXT) then
      lastFileOpen:='';

  if getMtime(VFS_TEMP_FILE) > getMtime(lastFileOpen) then
    if msgDlg(MSG_RESTORE_BAK, MB_YESNO+MB_ICONWARNING) = MRYES then
      begin
      deleteFile(lastFileOpen+BAK_EXT);
      if renameFile(lastFileOpen, lastFileOpen+BAK_EXT) then
        renameFile(VFS_TEMP_FILE, lastFileOpen)
      else
        lastFileOpen:=VFS_TEMP_FILE
      end;

  loadVFS(lastFileOpen);
  end;
processParams_after(params);

if not quitASAP then
  begin
  if not cfgLoaded then
    setEasyMode(easyMode);
  tray.setIcon(tray_ico);
  tray.onEvent:=trayEvent;
  if showmaintrayiconChk.checked then addTray();
  end;
timer.Enabled:=TRUE;
applicationFullyInitialized:=TRUE;
if quitASAP then
  begin
  application.showmainform:=FALSE;
  close();
  exit;
  end;

  LoadSomeLanguage('HFS', exePath);
  translateWindows;
show();
strToConnColumns(serializedConnColumns);
if startminimizedChk.checked then application.Minimize();
if findExtOnStartupChk.checked and (externalIP = '') then
  setStatusBarText(MSG_EXT_ADDR_FAIL, 30);
updatePortBtn();
fixAddToHFS();
filesBox.setFocus();
//loadEvents();
formResize(NIL); // recalculate to solve graphical glitches

if not tplIsCustomized then
  runTplImport();

runEventScript(fileSrv, 'start');
{** trying to move loadEvents() before loadCfg()
if srv.active then
  runEventScript('server start'); // because this event wouldn't fire at start, the server was already on
}
end; // finalInit

function expertModeNeededMsg(p_easyMode: Boolean):string;
resourcestring MSG_TO_EXPERT = 'Switch to expert mode.';
begin
  result:=if_(p_easyMode, MSG_TO_EXPERT)
end;

procedure TmainFrm.Dontlogsomefiles1Click(Sender: TObject);
resourcestring MSG_DONT_LOG_HINT = 'Select the files/folder you don''t want to be logged,'
  +#13'then right click and select "Don''t log".';
begin
  msgDlg(expertModeNeededMsg(easyMode) +#13+MSG_DONT_LOG_HINT );
end;

procedure TmainFrm.progFrmHttpGetUpdate(sender:Tobject; buffer:pointer; len:integer);
begin
with sender as ThttpCli do
  begin
  progFrm.progress:=safeDiv(0.0+RcvdCount, contentLength);
  if progFrm.cancelRequested then abort();
  end;
end; // progFrmHttpGetUpdate

procedure TmainFrm.statusBarHttpGetUpdate(sender:Tobject; buffer:pointer; len:integer);
resourcestring MSG_DL_PERC = 'Downloading %d%%';
begin
with sender as ThttpCli do
  setStatusBarText( format(MSG_DL_PERC, [safeDiv(RcvdCount*100, contentLength)]) );
end; // statusBarHttpGetUpdate

procedure TmainFrm.Properties1Click(Sender: TObject);
begin
if selectedFile = NIL then exit;

filepropFrm:=TfilepropFrm.Create(mainFrm);
try
  if filepropFrm.showModal() = mrCancel then exit;
finally freeAndNIL(filepropFrm) end;
VFSmodified:=TRUE;
filesBox.invalidate();
end;

function purgeFilesCB(f: Tfile; childrenDone: boolean; par, par2: IntPtr): TfileCallbackReturn;
begin
  result := [];
  if f.locked or f.isRoot() then
    exit;
  result := [FCB_RECALL_AFTER_CHILDREN];
  //if f.isFile() and purgeFrm.rmFilesChk.checked and not fileExists(f.resource)
  //or f.isRealFolder() and purgeFrm.rmRealFoldersChk.checked and not sysutils.directoryExists(f.resource)
  //or f.isVirtualFolder() and purgeFrm.rmEmptyFoldersChk.checked and (f.node.count = 0)
  if f.isFile() and (par and 1 <> 0) and not fileExists(f.resource)
  or f.isRealFolder() and (par and 2 <> 0) and not sysutils.directoryExists(f.resource)
  or f.isVirtualFolder() and (par and 4 <> 0) and (f.node.count = 0)
  then
    result:=[FCB_DELETE]; // don't dig further
end; // purgeFilesCB

procedure TmainFrm.Purge1Click(Sender: TObject);
var
  f: Tfile;
  param: IntPtr; // 3 bits used as parameters
  purgeFrm: TpurgeFrm;
begin
  purgeFrm := NIL;
f:=selectedFile;
if f = NIL then
  f:= fileSrv.rootFile;
if purgeFrm = NIL then
  application.CreateForm(TpurgeFrm, purgeFrm);
  try
    if purgeFrm.showModal() <> mrOk then exit;
      param := 0;
      if purgeFrm.rmFilesChk.checked then
        param := param + 1;
      if purgeFrm.rmRealFoldersChk.checked then
        param := param + 2;
      if purgeFrm.rmEmptyFoldersChk.checked then
        param := param + 4;
  finally
    purgeFrm.Free;
    purgeFrm := NIL;
  end;
  f.recursiveApply(purgeFilesCB, param);
end;

procedure TmainFrm.UninstallHFS1Click(Sender: TObject);
resourcestring MSG_UNINSTALL_WARN = 'Delete HFS and all settings?';
begin
if checkMultiInstance() then exit;
if msgDlg(MSG_UNINSTALL_WARN, MB_ICONQUESTION+MB_YESNO) <> IDYES then
  exit;
uninstall();
end;

procedure TmainFrm.maxIPs1Click(Sender: TObject);
resourcestring
  MSG_NUM_ADDR = 'In this moment there are %d different addresses';
var
  s: string;
  i: integer;
begin
if maxIPs > 0 then s:=intToStr(maxIPs)
else s:='';
if inputquery(MSG_SET_LIMIT, MSG_MAX_SIM_ADDR+#13+MSG_EMPTY_NO_LIMIT, s) then
	try setMaxIPs(strToUInt(s))
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
if maxIPs = 0 then exit;
i:=countIPs();
if i > maxIPs then
  msgDlg(format(MSG_NUM_ADDR, [i]), MB_ICONWARNING);
end;

procedure TmainFrm.maxIPsDLing1Click(Sender: TObject);
resourcestring
  MSG_NUM_ADDR_DL = 'In this moment there are %d different addresses downloading';
var
  s: string;
  i: integer;
begin
if maxIPsDLing > 0 then s:=intToStr(maxIPsDLing)
else s:='';
if inputquery(MSG_SET_LIMIT, MSG_MAX_SIM_ADDR_DL+#13+MSG_EMPTY_NO_LIMIT, s) then
	try setMaxIPsDLing(strToUInt(s))
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR)
  end;
if maxIPsDLing = 0 then exit;
i:=countIPs(TRUE);
if i > maxIPsDLing then
  msgDlg(format(MSG_NUM_ADDR_DL, [i]), MB_ICONWARNING);
end;

procedure TmainFrm.Maxlinesonscreen1Click(Sender: TObject);
resourcestring
  MSG_MAX_LINES = 'Max lines on screen.';
var
  s: string;
begin
s:=if_(logMaxLines > 0, intToStr(logMaxLines));
  repeat
  if not inputQuery(MSG_SET_LIMIT, MSG_MAX_LINES+#13+MSG_EMPTY_NO_LIMIT, s) then break;
  try
    logMaxLines:=strToUInt(s);
    break;
  except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR) end;
  until false;
end;

procedure TmainFrm.Autosaveevery1Click(Sender: TObject);
begin autosaveClick(autosaveVFS, 'file system') end;

procedure TmainFrm.Apachelogfileformat1Click(Sender: TObject);
resourcestring
  MSG_APACHE_LOG_FMT = 'Apache log file format';
  MSG_APACHE_LOG_FMT_LONG = 'Here you can specify how to format the log file complying Apache standard.'
    +#13'Leave blank to get bare copy of screen on file.'
    +#13
    +#13'Example:'
    +#13'   %h %l %u %t "%r" %>s %b';
begin
InputQuery(MSG_APACHE_LOG_FMT, MSG_APACHE_LOG_FMT_LONG, logFile.apacheFormat)
end;

procedure TmainFrm.Bindroottorealfolder1Click(Sender: TObject);
var
  f: Tfile;
  res: string;
begin
f:=selectedFile;
if (f = NIL) or not f.isVirtualFolder() or not f.isRoot() then exit;
res:=exePath;
if not selectFolder('', res) then exit;
f.setResource(res);
exclude(f.flags, FA_VIRTUAL);
VFSmodified:=TRUE;
end;

procedure TmainFrm.Unbindroot1Click(Sender: TObject);
var
  f: Tfile;
begin
f:=selectedFile;
if (f = NIL) or not f.isRealFolder() or not f.isRoot() then exit;
f.setResource('');
f.uploadFilterMask:='';
f.accounts[FA_UPLOAD]:=NIL;
include(f.flags, FA_VIRTUAL);
VFSmodified:=TRUE;
end;

procedure TmainFrm.SwitchON1Click(Sender: TObject);
begin toggleServer() end;

procedure TmainFrm.Switchtorealfolder1Click(Sender: TObject);
var
  i: integer;
  someLocked: boolean;
  list: TtreeNodeDynArray;
begin
if selectedFile = NIL then exit;
someLocked:=FALSE;
list:=copySelection();
for i:=0 to length(list)-1 do
  if assigned(list[i]) then
    with nodeTofile(list[i]) do
      if isVirtualFolder() and not isRoot() and (resource > '') then
        if isLocked() then someLocked:=TRUE
        else
          begin
          exclude(flags, FA_VIRTUAL);
          setResource(resource);
          setupImage(mainfrm.useSystemIconsChk.checked);
          setNilChildrenFrom(list, i);
          node.DeleteChildren();
          end;
VFSmodified:=TRUE;
if someLocked then msgDlg(MSG_SOME_LOCKED, MB_ICONWARNING);
end;

procedure TmainFrm.abortBtnClick(Sender: TObject);
begin
  fileSrv.stopAddingItems := TRUE
end;

procedure TmainFrm.Seelastserverresponse1Click(Sender: TObject);
var
  fn: string;
begin
if ipos('<html>', dyndns.lastResult) = 0 then
  begin
  msgDlg(dyndns.lastResult);
  exit;
  end;
fn:=saveTempFile(dyndns.lastResult);
if fn = '' then
  begin
  msgDlg(MSG_NO_TEMP, MB_ICONERROR);
  exit;
  end;
renameFile(fn, fn+'.html');
exec(fn+'.html');
end;

procedure TmainFrm.Showcustomizedoptions1Click(Sender: TObject);
var
  default: TStrings;
  current, defV, v, k: string;
  diff: string;
begin
default:=TStringList.create();
default.text:=defaultCfg;
current:=getCfg();
diff:='# '+srvConst.VERSION+' (build '+VERSION_BUILD+')'+CRLF;

while current > '' do
  begin
  v:=chopLine(current);
  k:=chop('=', v);
  if ansiEndsStr('-width', k) or ansiEndsStr('-height', k)
  or stringExists(k, ['active','window','graph-visible','graph-size','ip', 'accounts',
    'dynamic-dns-user', 'dynamic-dns-host', 'ips-ever', 'ips-ever-connected',
    'icon-masks-user-images', 'last-external-address', 'last-dialog-folder'])
  then continue;
  
  defV:=default.values[k];
  if defV = v then continue;
  if k = 'dynamic-dns-updater' then
    begin // remove login data
    v:=decodeB64utf8(v);
    chop('//',v);
    v:=chop('/',v);
    if ansiContainsStr(v, '@') then chop('@',v);
    v:='...'+v+'...';
    end;
  diff:=diff+k+'='+v+CRLF+'# default: '+defV+CRLF+CRLF;
  end;
default.free;

diffFrm.memoBox.text:=diff;
diffFrm.showModal();
end;

procedure TmainFrm.useISOdateChkClick(Sender: TObject);
begin applyISOdateFormat() end;

procedure TmainFrm.RunHFSwhenWindowsstarts1Click(Sender: TObject);
begin
deleteFile(startupFilename); // we delete both for deactivation (of course) and before activation (to purge possible existing links to other exe files)
if not (sender as Tmenuitem).Checked then
  createShellLink(startupFilename, paramStr(0));
end;

procedure TmainFrm.Runscript1Click(Sender: TObject);
begin
if not fileExists(tempScriptFilename) then
  saveFileA(tempScriptFilename, '');
runScriptLast:=getMtime(tempScriptFilename);
if runScriptFrm = NIL then
  runScriptFrm:=TrunScriptFrm.create(self);
runScriptFrm.show();
exec(getTplEditor(), '"'+tempScriptFilename+'"');
end;

procedure TmainFrm.minimizeToTray();
begin
application.Minimize();
addTray();
showWindow(application.handle, SW_HIDE); // hide taskbar button
trayed:=TRUE;
end; // minimizeToTray

procedure TmainFrm.askFolderKindChkClick(Sender: TObject);
begin addFolderDefault:='' end;

procedure TmainFrm.defaultToVirtualChkClick(Sender: TObject);
begin addFolderDefault:='virtual' end;

procedure TmainFrm.defaultToRealChkClick(Sender: TObject);
begin addFolderDefault:='real' end;

procedure TmainFrm.Addicons1Click(Sender: TObject);
resourcestring MSG_ICONS_ADDED = '%d new icons added';
var
  files: TStringDynArray;
  i, n: integer;
begin
if not selectFiles('', files) then exit;
n:= IconsDM.images.Count;
for i:=0 to length(files)-1 do
  IconsDM.getImageIndexForFile(files[i]);
n:= IconsDM.images.Count-n;
msgDlg(format(MSG_ICONS_ADDED,[n]));
end;

procedure TmainFrm.Iconmasks1Click(Sender: TObject);
begin
  showOptions(optionsFrm.iconsPage, mainfrm.modalOptionsChk.checked);
end;

procedure TmainFrm.Anyaddress1Click(Sender: TObject);
begin
listenOn:='';
restartServer();
end;

procedure TmainFrm.AnyAddressV6Click(Sender: TObject);
begin
listenOn:='[*]';
restartServer();
end;

procedure Tmainfrm.acceptOnMenuclick(sender:Tobject);
begin
listenOn:=(sender as Tmenuitem).caption;
delete(listenOn, pos('&',listenOn), 1);
restartServer();
end; // acceptOnMenuclick

procedure TmainFrm.filesBoxEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
scrollFilesBox:=-1;
filesBox.Refresh();
end;

procedure TmainFrm.filesBoxEnter(Sender: TObject);
begin setFilesBoxExtras(TRUE) end;

procedure TmainFrm.filesBoxExit(Sender: TObject);
begin setFilesBoxExtras(filesBox.MouseInClient) end;

procedure TmainFrm.Disable1Click(Sender: TObject);
resourcestring MSG_DDNS_DISABLED = 'Dynamic DNS updater disabled';
begin
dyndns.url:='';
msgDlg(MSG_DDNS_DISABLED);
end;

procedure TmainFrm.saveNewFingerprintsChkClick(Sender: TObject);
resourcestring
  MSG_MD5_WARN = 'This option creates an .md5 file for every new calculated fingerprint.'
    +#13'Use with care to get not your disk invaded by these files.';
begin
if saveNewFingerprintsChk.Checked then
  msgDlg(MSG_MD5_WARN, MB_ICONWARNING);
end;

procedure TmainFrm.Createfingerprintonaddition1Click(Sender: TObject);
resourcestring
  MSG_AUTO_MD5 = 'Auto fingerprint';
  MSG_AUTO_MD5_LONG = 'When you add files and no fingerprint is found, it is calculated.'
    +#13'To avoid long waitings, set a limit to file size (in KiloBytes).'
    +#13'Leave empty to disable, and have no fingerprint created.';
var
  s: string;
begin
if autoFingerprint = 0 then s:=''
else s:=intToStr(autoFingerprint);
if not inputquery(MSG_AUTO_MD5, MSG_AUTO_MD5_LONG, s) then exit;
try setAutoFingerprint(strToUInt(s))
except msgDlg(MSG_INVALID_VALUE, MB_ICONERROR) end;
end;

procedure TmainFrm.Howto1Click(Sender: TObject);
resourcestring MSG_UPL_HOWTO = '1. Add a folder (choose "real folder")'
  +#13
  +#13'You should now see a RED folder in your virtual file sytem, inside HFS'
  +#13
  +#13'2. Right click on this folder'
  +#13'3. Properties -> Permissions -> Upload'
  +#13'4. Check on "Anyone"'
  +#13'5. Ok'
  +#13
  +#13'Now anyone who has access to your HFS server can upload files to you.';
begin msgDLg(MSG_UPL_HOWTO) end;

procedure TmainFrm.Name1Click(Sender: TObject);
begin defSorting:='name' end;

procedure TmainFrm.Size1Click(Sender: TObject);
begin defSorting:='size' end;

procedure TmainFrm.Time1Click(Sender: TObject);
begin defSorting:='time' end;

procedure TmainFrm.Hits1Click(Sender: TObject);
begin defSorting:='hits' end;

procedure TmainFrm.Resettotals1Click(Sender: TObject);
begin resetTotals() end;

procedure TmainFrm.copyBtnClick(Sender: TObject);
begin setClip(urlBox.text) end;

function TmainFrm.copySelection():TtreeNodeDynArray;
var
  i: integer;
begin
setlength(result, filesBox.SelectionCount);
for i:=0 to filesBox.SelectionCount-1 do
  result[i] := filesbox.selections[i];
end; // copySelection

function TmainFrm.SetSelectedFile(f: TFile): Boolean;
var
  n: TTreeNode;
begin
  n := f.node;
  Result := n <> NIL;
  filesBox.Selected := n;
end;

function TmainFrm.SetSelectedFile(f: TFile; node: TTreeNode): Boolean;
var
  n: TTreeNode;
begin
  n := node;
  Result := n <> NIL;
  if not Result then
    n := f.node;
  Result := n <> NIL;
  filesBox.Selected := n;
end;

procedure TmainFrm.menuMeasure(sender:Tobject; cnv: Tcanvas; var w:integer; var h:integer);
begin
with sender as Tmenuitem do
  if isLine() then
    w:=cnv.textwidth(hint+'----')
  else
    w:=cnv.textWidth(caption+'----')+ IconsDM.images.Width;
h:=getSystemMetrics(SM_CYMENU);
end;

procedure TmainFrm.menuDraw(sender:Tobject; cnv: Tcanvas; r:Trect; selected:boolean);
var
  mi: Tmenuitem;
  s: string;
  i: integer;
  iw: Integer;
begin
  iw := IconsDM.images.width;
mi:=sender as Tmenuitem;
if mi.IsLine() then
  begin
  i:=(r.Bottom+r.top) div 2;
  cnv.Pen.Color:=clBtnHighlight;
  cnv.MoveTo(r.Left, i);
  cnv.lineTo(r.right, i);
  cnv.Pen.Color:=clBtnShadow;
  cnv.MoveTo(r.Left, i-1);
  cnv.lineTo(r.right, i-1);

  if mi.hint = '' then exit;
  s:=' '+mi.hint+' ';
  inc(r.Top, cnv.TextHeight(s) div 5);
  cnv.font.color:=clBtnHighlight;
  drawText(cnv.handle, pchar(s), -1, r, DT_VCENTER or DT_CENTER);
  setBkMode(cnv.handle, TRANSPARENT);
  cnv.font.color:=clBtnShadow;
  dec(r.Left);
  dec(r.top);
  drawText(cnv.handle, pchar(s), -1, r, DT_VCENTER or DT_CENTER);
  exit;
  end;
cnv.fillRect(r);
inc(r.left, iw*2);
inc(r.top,2);
drawText(cnv.handle, pchar(mi.caption), -1, r, DT_LEFT or DT_VCENTER);
dec(r.left, iw*2);

if mi.ImageIndex >= 0 then
  IconsDM.images.draw(cnv, r.left+1, r.top, mi.ImageIndex);
if mi.Checked then
  begin
  cnv.font.Name:='WingDings';
  with cnv.Font do size:=size+2;
  cnv.TextOut(r.Left+ iw, r.Top, #$0252); // check mark
  end;
end;

procedure TmainFrm.wrapInputQuery(sender:Tobject);
var
  Form: TCustomForm;
  Prompt: TLabel;
  Edit: TEdit;
  Ctrl: TControl;
  I, J, ButtonTop: Integer;
  coef: real;
begin
Form := Screen.ActiveCustomForm;
if (Form=NIL) or (Form.ClassName<>'TInputQueryForm') then
  Exit;

  Edit := NIL;
  Prompt := NIL;
//  Ctrl := NIL;
  ButtonTop := 0;
  coef := self.CurrentPPI / 96;

for I := 0 to Form.ControlCount-1 do
  begin
  Ctrl := Form.Controls[i];
  if Ctrl is TLabel then
    Prompt := TLabel(Ctrl)
  else if Ctrl is TEdit then
    Edit := TEdit(Ctrl);
  end;
if Assigned(Edit) then
  begin
    Edit.SetBounds(Prompt.Left, Prompt.Top + Prompt.Height + trunc(5 * coef), max(200, Prompt.Width), Edit.Height);
    Form.ClientWidth := (Edit.Left * 2) + Edit.Width;
    ButtonTop := Edit.Top + Edit.Height + trunc(coef * 15);
  end;

J := 0;
for I := 0 to Form.ControlCount-1 do
  begin
  Ctrl := Form.Controls[i];
  if Ctrl is TButton then
    begin
    Ctrl.SetBounds(Form.ClientWidth - ((Ctrl.Width + trunc(coef * 15)) * (2-J)), ButtonTop, Ctrl.Width, Ctrl.Height);
    Form.ClientHeight := Ctrl.Top + Ctrl.Height + trunc(coef * 13);
    Inc(J);
    end;
  end;
end;



function TFileHlp.getShownRealm():string;
var
  f: Tfile;
begin
f:=self;
  repeat
  result:=f.realm;
  if result > '' then exit;
  f:=f.parent;
  until f = NIL;
if mainfrm.useCommentAsRealmChk.checked then
  result:= getDynamicComment(mainfrm.getLP);
end; // getShownRealm




var
  dll: HMODULE;

INITIALIZATION

randomize();
setErrorMode(SEM_FAILCRITICALERRORS);
exePath:=extractFilePath(ExpandFileName(paramStr(0)));
cfgPath:=exePath;
// we give priority to exePath because some people often clear the temp folder
tmpPath:=exePath;
if savefileA(tmpPath+'test.tmp','') then
  deleteFile(tmpPath+'test.tmp')
 else
  tmpPath:=getTempDir();
lastUpdateCheckFN:=tmpPath+'HFS last update check.tmp';
setCurrentDir(exePath); // sometimes people mess with the working directory, so we force it to the exe path
defaultTpl:=Ttpl.create(getRes('defaultTpl'));
//tpl_help := UnUTF(getRes('tplHlp'));
defSorting:='name';
dmBrowserTpl:=Ttpl.create(getRes('dmBrowserTpl'));
filelistTpl:=Ttpl.create(getRes('filelistTpl'));
globalLimiter:=TspeedLimiter.create();
ip2obj:=THashedStringList.create();
etags:=THashedStringList.create();
sessions:=Tsessions.create();
ipsEverConnected:=THashedStringList.create();
ipsEverConnected.sorted:=TRUE;
ipsEverConnected.duplicates:=dupIgnore;
ipsEverConnected.delimiter:=';';
logMaxLines:=2000;
trayShows:= TS_downloads;
flashOn:='download';
forwardedMask:='::1;127.0.0.1';
runningOnRemovable:=DRIVE_REMOVABLE = GetDriveType(PChar(exePath[1]+':\'));
etags.values['exe']:= MD5PassHS(dateToHTTPr(getMtimeUTC(paramStr(0))));
toAddFingerPrint := TStringList.Create;


dll:=GetModuleHandle('kernel32.dll');
if dll <> HINSTANCE_ERROR then
  setThreadExecutionState:=getprocaddress(dll, 'SetThreadExecutionState');

toDelete:=Tlist.create();
usersInVFS:=TusersInVFS.create();

openInBrowser:='*.htm;*.html;*.jpg;*.jpeg;*.gif;*.png;*.txt;*.swf;*.svg;*.webp';

saveMode:=SM_USER;
lastDialogFolder:=getCurrentDir();
autoupdatedFiles:=TstringToIntHash.create();
iconsCache:=TiconsCache.create();
dyndns.active:=TRUE;
connectionsInactivityTimeout:=60; // 1 minute
startupFilename:=getShellFolder('Startup')+'\HFS.lnk';
tempScriptFilename:=getTempDir()+'hfs script.tmp';

logfile.apacheZoneString:=if_(GMToffset < 0, '-','+')
  +format('%.2d%.2d', [abs(GMToffset div 60), abs(GMToffset mod 60)]);


FINALIZATION

progFrm.free;
toDelete.free;
defaultTpl.Free;
filelistTpl.free;
autoupdatedFiles.free;
iconsCache.free;
usersInVFS.free;
if Assigned(globalLimiter) then
  FreeAndNil(globalLimiter);
ip2obj.free;
ipsEverConnected.free;
etags.free;
if Assigned(toAddFingerPrint) then
  FreeAndNil(toAddFingerPrint);

end.
