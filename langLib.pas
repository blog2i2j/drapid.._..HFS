{
  Copyright (C) 2002-2004  Massimo Melina (www.rejetto.com)

  This file is part of &RQ.

    &RQ is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    &RQ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with &RQ; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit langLib;
{$I forRnQConfig.inc}
{$I NoRTTI.inc}

interface

uses
  RnQLangs, classes, forms;

procedure translateWindows;
procedure translateWindow(w: Tform);
procedure translateComponent(c: Tcomponent; window: Tform);

implementation

uses
  utilLib, SyncObjs, ComCtrls, // CheckLst,
//  RQUtil,
  RDGlobal,
  Types, stdctrls, ExtCtrls, menus, controls, sysUtils, strUtils;



function trans(const s: String): String; {$IFDEF HAS_INLINE} inline; {$ENDIF HAS_INLINE}
begin
{if AnsiStartsStr('___',s) then
  result:=getTranslation(copy(s,4,9999))
else
}
//  if useLang and Assigned(LangVar) then
    result:=getTranslation(s);
end; // trans

(*procedure trans2(var s:string); inline;
begin
{if AnsiStartsStr('___',s) then
  result:=getTranslation(copy(s,4,9999))
else
}
  s := getTranslation(s);
end; // trans*)

type
  TLangControl = class(TControl)
    property Caption;
  end;

procedure translateComponent(c: Tcomponent; window: Tform);

  procedure recurMenu(it: Tmenuitem);
  var
    i: integer;
  begin
    it.caption := trans(it.caption);
    it.hint := trans(it.hint);
    with it do
      for i:=0 to count-1 do
        recurMenu(items[i]);
  end; // recurMenu

{  procedure recurTree(t: Ttreenode); overload;
  var
    i: integer;
  begin
  t.text := trans(t.text);
  for i:=0 to t.count-1 do
    recurTree(t.item[i]);
  end; // recurTree
}
{  procedure recurTree(t: Ttreenodes); overload;
  var
    i: integer;
  begin
  for i:=0 to t.count-1 do
    recurTree(t.item[i]);
  end; // recurTree
}
  procedure tstrings_trans(s: Tstrings);
  var
    i: integer;
  begin
  for i:=0 to s.count-1 do
    s[i] := trans(s[i]);
  end; // tstrings_trans
var
  i, k: integer;
begin
   if c is Tmenu then
    with c as Tmenu do
      recurMenu(items)
   else if c is Tlabelededit then
    with c as Tlabelededit do
    with editlabel do
      caption := trans(caption)
   else if c is Tradiogroup then
    with c as Tradiogroup do
      begin
       caption := trans(caption);
       tstrings_trans(items);
      end
   else if c is TcomboBox then
    with TcomboBox(c) do
      begin  // itemindex is lost during translation
       i := itemIndex;
       k := Items.Count;
       if k > 0 then
        begin
         tstrings_trans(items);
         itemIndex := i;
        end;
      end
   else if c is TListView then
      begin  // itemindex is lost during translation
       for var cc in TListView(c).Columns do
         TListColumn(cc).Caption := trans(TListColumn(cc).Caption)
      end
{    else if c is TVirtualDrawTree then
     begin
       for I := 0 to TVirtualDrawTree(c).Header.Columns.Count - 1 do
          TVirtualDrawTree(c).Header.Columns.Items[i].Text :=
            getTranslation(TVirtualDrawTree(c).Header.Columns.Items[i].Text)
     end
}
{
else if c is Tchecklistbox then with c as Tchecklistbox do
  tstrings_trans(items)
}
  else if c is TControl then
    with TLangControl(c) do
    begin
     hint := trans(hint);
     if caption > '' then
      caption :=trans(caption)
    end
;

{if c is TColorPickerButton then with c as TColorPickerButton do
  begin
  caption:=trans(caption);
  customText:=trans(customText);
  end;}

  for i:=c.componentCount-1 downto 0 do
    translateComponent(c.components[i], window);
end; // translateComponent

procedure translateWindow(w: Tform);
begin translateComponent(w, w) end;

procedure translateWindows;
var
  i: integer;
begin
  i := 0;
  while i < screen.formCount do
    begin
      translateWindow(screen.forms[i]);
      inc(i);
    end;

  i := 0;
  while i < screen.DataModuleCount do
    begin
      translateComponent(screen.DataModules[i], NIL);
      inc(i);
    end;
end; // translateWindows

end.
