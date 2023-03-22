#NoTrayIcon
#SingleInstance Force
#NoEnv
#WinActivateForce
SetBatchLines, -1
DetectHiddenWindows, On
ScriptName := "Perfect Match"
ScriptIni = %A_ScriptDir%\%ScriptName%.ini
SetWorkingDir, %A_ScriptDir%
ShowSplash()
InitializeVars()
CreateGuis()
OnMessage(0x47, "WM_WINDOWPOSCHANGED")
OnMessage(0x112,"WM_SYSCOMMAND")
OnExit, ExitSub
Menu, tray, Icon

Sleep, 3000
DllCall("AnimateWindow","UInt",Splash_ID,"Int",1000,"UInt","0x90000")
;Gosub, ShowCredits
Return

; #Include C:\Program Files (x86)\AutoHotkey\Lib\Robert's INI library Basic.ahk
#Include C:\Program Files (x86)\AutoHotkey\Lib\UnHtm.ahk
#Include C:\Program Files (x86)\AutoHotkey\Lib\Ansi2Unicode.ahk

;*************************************** Show Splash Screen ****************************************

ShowSplash()
{
 Global
 Gui, 1:Default
 Gui, +LastFound
 Gui1ID := WinExist()
 LV_guiID := Gui1ID
 GroupAdd, GuiNum1, ahk_id %Gui1ID%
 Gui, 77:Default
 Gui, +LastFound
 Gui, +Owner1 +ToolWindow
 Splash_ID:=WinExist()
 Gui, -Caption +AlwaysOnTop +Border
 Gui, Add, Picture, w1044 h798, PerfectLogo.jpg
 Gui, Show, Hide
 DllCall("AnimateWindow","UInt",Splash_ID,"Int",250,"UInt","0x16")
}

; ************************************* Initialize Variables ***************************************

InitializeVars()
{
 Global
 Error := RIni_Read(1, ScriptIni)
 IniSections := RIni_GetSections(1)
 If (Error = -11) OR (IniSections = "General") OR (IniSections = "")
 {
  FileDelete, %ScriptIni%
  FileAppend,
  (LTrim
   [General]
   LastProject=Default
   HideMessages=
   MessageOption=2
   MessageTips=0
   [Default]
   MatchedRoms=
   LastRomFolder=
   LastArtFolder=
   ArtFolderList=
   RomExtensions=zip,7z
   ArtExtensions=avi,bmp,flv,jpg,jpeg,mpg,mpeg,png,mp4
   Recurse=0
   MoveFiles=0
   RemoveExact=0
   Remove99=0
   RomSquareBracket=0
   RomCurlyBracket=0
   RomRoundBracket=0
   ArtSquareBracket=0
   ArtCurlyBracket=0
   ArtRoundBracket=0
   RomTrimLeft=0
   RomTrimRight=0
   ArtTrimLeft=0
   ArtTrimRight=0
   Regex=[^a-zA-Z0-9& ]
   ReplaceLV=vs\versus\X\X|gp\grand prix\X\X|bros\brothers\X\X|one\1\X\X|two\2\X\X|three\3\X\X|four\4\X\X|five\5\X\X|six\6\X\X|seven\7\X\X|eight\8\X\X|nine\9\X\X|Ten\10\X\X|I\1\X\X|II\2\X\X|III\3\X\X|IV\4\X\X|V\5\X\X|VI\6\X\X|VII\7\X\X|VIII\8\X\X|IX\9\X\X|X\10\X\X|VV\55\X\X|A\\X\X|, The\\X\X|The\\X\|
  ), %ScriptIni%
 }

 IniRead, LastProject, %ScriptIni%, General, LastProject, General
 IniRead, HideMessages, %ScriptIni%, General, HideMessages
 IniRead, MessageOption, %ScriptIni%, General, MessageOption
 IniRead, MessageTips, %ScriptIni%, General, MessageTips
 Keys := "MatchedRoms,LastRomFolder,LastArtFolder,ArtFolderList,RomExtensions,ArtExtensions,Recurse,MoveFiles,RemoveExact,Remove99,RomSquareBracket
 ,RomCurlyBracket,RomRoundBracket,ArtSquareBracket,ArtCurlyBracket,ArtRoundBracket,RomTrimLeft,RomTrimRight,ArtTrimLeft,ArtTrimRight,Regex,ReplaceLV"
 Loop, Parse, Keys, `,
   IniRead, %A_LoopField%, %ScriptIni%, %LastProject%, %A_LoopField%, %A_Space%
 Loop, 3
   MO%A_Index% := A_Index = MessageOption ? 1 : 0
 Loop, 2
   MT%A_Index% := A_Index = MessageTips ? 1 : 0
 SplitPath, LastRomFolder,, OutExt
 IllegalChars = \/:?<>*|"
 Null =
 Stop = 0
 RefreshMatchLV = 1
 ;Delete Brackets
 BracketTypes := "Round,Square,Curly"
 RoundRegex := "\(.+?\)"
 SquareRegex := "\[.+?]"
 CurlyRegex := "\{.+?}"
 ; In Cell Editing
 SetControlDelay,0
 LV_EnableCVSmode = 0		;makes column headers "A-Z"
 LV_EnableLineNumbers=0	;0 or 1 - add line numbers in column one or not 	-	for in-cell editing
 LV_FontSize = 10				;specify font size for listview, static, edit controls	-	for in-cell editing
 LV_EnableSingleClick = 1	;whether or not to do cell highlighting on singleclick
 LV_EnterRight = 1			;when enter pressed, move cell highlight down or right
 LV_AddRowsOnScroll = 0	;if at last row and down arrow is pressed, add rows as needed
 LV_AddColsOnScroll = 0		;if at last col and right arrow is pressed, add columns as needed
 LV_NewColWidth = 100		;default width for new columns

 Message1 := "`n Settings saved for XXX "
 Message2 := "`n There are no projects to open. "
 Message3 := "`n Select a project to open. "
 Message4 := "`nEither select a project from the list or`ntype a new name into the box. "
 Message5 := "`n Could not create folder. XXX "
 Message6 := "`n XXX extensions have not been changed. "
 Message7 := "`n There are no files with XXX extensions. `n You will need to set extensions to add YYY "
 Message8 := "`n Use [...] to change primary art folder. "
 Message9 := " Unable to get Rom names from XXX `n If you are positive that this a rom dat or xml file `n please report this error along with your file. "
 Message10 := "`n You need to match your files first. "
 Message11 := "`n You need to select at least one row. "
 Message12 := "`n You need to select at least one file. "
 Message13 := "`n You Have Not Set Your XXX Path. "
 Message14 := "`n No Roms found. Please check for directory and extensions settings "
 Message15 := "`n It would appear that all of your roms have an art file. "
 Message16 := "`n XXX has been saved. "
 Message17 := "`n Settings saved for XXX "
 Message18 := "`n You need to match your files first. "
 Message19 := "`n You need to select at least one row. "
 Message20 := "`n You Have Not Set Your XXX Path. "
 Message21 := "`n XXX extensions have not been changed. "
 Message22 := "`n You need to select at least one row. "
 Message23 := "`n You need to select at least one file. "
}

;***************************************************************************************************
;****************************************** Create Gui's *******************************************
;***************************************************************************************************

CreateGuis()
{
 Global
 Gui, 1:Default
 Gui, +OwnDialogs 
 Gui, Margin, 0, 0
 Gui, Color, FBA441, FBA441 ;AC201C
 SysGet, CBW, 71
 SysGet, CBH, 72
 CBW-=2
 CBH-=2
 
;******************************************* Match Tab ********************************************* 

 Menu, ProjectMenu, Add, Open Project...%A_Tab%Ctrl+O, OpenProject
 Menu, ProjectMenu, Add, Save Project%A_Tab%Ctrl+S, SaveProject
 Menu, ProjectMenu, Add, Save Project As...%A_Tab%F12, SaveProjectAs
 Menu, MyMenuBar, Add, Projects, :ProjectMenu
 Menu, MyMenuBar, Add, Messages, MessageSettings ;:SettingsMenu
 Menu, MyMenuBar, Add, Credits, ShowCredits
 Menu, MyMenuBar, Color, FBA441
 Gui, Menu, MyMenuBar

 Gui, Add, Tab2, h708 w1010 vCurrentTab gChangeTabs, Settings||Match
 Gui, Tab, Match
 Gui, Add, Picture, x2 y22 w1006 h685 0x120E hwnddHwnd
 Gui, Add, ListView, -ReadOnly x20 y40 r37 w800 +altsubmit vMatchLV gMatchLV_Events, RomName|Suggested ArtWork|Match `%|Hidden|Short Name
 LV_ModifyCol(1,363)
 LV_ModifyCol(2,363)
 LV_ModifyCol(3,53)
 LV_ModifyCol(3,"Integer")
 LV_ModifyCol(4,0)
 LV_ModifyCol(5,0)

 Gui, Add, StatusBar, -Theme BackgroundFBA441 ;FF8040 A04020
 SB_SetParts(150)
 SB_SetText("   " ScriptName " by Matt McLemore AKA 'Tempest'", 2)
 SB_SetText("   " LastProject)

 Gui, Add, Button, x860 y110 w100 h30 vB10 gSelectAll, Select &All
 Gui, Add, Button, xp y+10 w100 h30 vB11 gSelectNone, Select &None
 
 Gui, Add, Button, xp y+35 w100 h30 vB12 gStartMatch, &Start Match
 Gui, Add, Button, xp y+10 w100 h30 vB13 gStopMatch, Stop Match
 
 Gui, Add, Button, xp y+35 w100 h30 vB14 gSearchArt, Search &Art Folder
 Gui, Add, Button, xp y+10 w100 h30 vB15 gViewArt, &View Art
 Gui, Add, Button, xp y+35 w100 h30 vB16 gMissList, Miss List
 
 Gui, Add, Button, xp y+10 w100 h30 vB17 gRename, Rename
 Gui, Add, Button, xp y+35 w100 h30 vB18 gRestart, Start Over

 Gui, Add, Button, xp y+10 w100 h30 vB19 gExitSub, Quit 
 
;****************************************** Settings Tab *******************************************

 ;Paths and Extensions
 Gui, Tab, Settings
 Gui, Add, Picture, x2 y22 w1006 h685 0x120E hwndcHwnd
 Gui, Add, Text, BackgroundTrans x20 y40 w87, Rom/dat/xml Path
 Gui, Add, Edit, x+10 yp-3 w325 r1 vLastRomFolder, %LastRomFolder%
 Gui, Add, Button, x+10 yp-2 w25 vB1 gGetRomFolder, ...
 Gui, Add, Text, BackgroundTrans x20 y+15 w87, Rom Extensions
 Gui, Add, Edit, x+10 yp-3 w325 vRomExtensions gGuiPreview, %RomExtensions%
 Gui, Add, Button, x+10 yp-2 w25 vExtButton gSetRomExtensions, Set
 Control_Colors("ExtButton", "Set", "0x1C20AC")
  
 Gui, Add, Text, BackgroundTrans x20 y+15 w87, Rom Preview File
 Gui, Add, Edit, x+10 yp-3 w325 vRomPreviewFile gGuiPreview
 Gui, Add, Button, x+10 yp-2 w25 vB2 gGetRomPreviewFile, ...

 StringTrimLeft, TempVar, ArtFolderList, 1
 Gui, Add, Text, BackgroundTrans Section x490 y40 w73, Art Path
 Gui, Add, DropDownList, cbFBA441 x+10 yp-3 w325 0x80 vLastArtFolder gSetArtPreview, %TempVar%
 Gui, Add, Button, x+10 yp-2 w25 vNewArtFolder gGetArtFolder, ...
 Control_Colors("NewArtFolder", "Set", "0x1C20AC")
 Gui, Add, Button, x+8 yp w25 vAddArtFolder gGetArtFolder, Add
 Control_Colors("AddArtFolder", "Set", "0x1C20AC")
 Gui, Add, Button, x+8 yp w25 vDelArtFolder gDelArtFolder, Del
 Control_Colors("DelArtFolder", "Set", "0x1C20AC")
 Gui, Add, Text, BackgroundTrans xs y+15 w73, Art Extensions
 Gui, Add, Edit, x+10 yp-3 w325 vArtExtensions gGuiPreview, %ArtExtensions%
 Gui, Add, Button, x+10 yp-2 w25 vB3 gSetArtExtensions, Set

 Gui, Add, Text, BackgroundTrans xs y+15 w73, Art Preview File
 Gui, Add, Edit, x+10 yp-3 w325 vArtPreviewFile gGuiPreview
 Gui, Add, Button, x+10 yp-2 w25 vB4 gGetArtPreviewFile, ...

 ;Rom Brackets Options
 Gui, Add, GroupBox, Section x25 y145 w250 h180
 Gui, Add, Edit, Disabled xp+20 yp w117
 Gui, Add, Text, xs+24 yp+3, Delete Brackets (Rom)
 Gui, Add, Text, BackgroundTrans xs+20 yp+25, %A_Space%[ ... ]
 Gui, Add, Edit, xp+35 yp-3 w30 Number vRomSquareBracket gGuiPreview Limit1
 Gui, Add, UpDown, cRed x+5 yp Range-5-5 Wrap, %RomSquareBracket%
 Gui, Add, Text, BackgroundTrans x+5 yp+3, Bracket Block
 Gui, Add, Text, BackgroundTrans xs+20 yp+30, %A_Space%{ ... }
 Gui, Add, Edit, xp+35 yp-3 w30 Number vRomCurlyBracket gGuiPreview Limit1
 Gui, Add, UpDown, x+5 yp Range-5-5 Wrap, %RomCurlyBracket%
 Gui, Add, Text, BackgroundTrans x+5 yp+3, Bracket Block
 Gui, Add, Text, BackgroundTrans xs+20 yp+30, %A_Space%( ... )
 Gui, Add, Edit, xp+35 yp-3 w30 Number vRomRoundBracket gGuiPreview Limit1
 Gui, Add, UpDown, x+5 yp Range-5-5 Wrap, %RomRoundBracket%
 Gui, Add, Text, BackgroundTrans x+5 yp+3, Bracket Block
 Gui, Add, Text, BackgroundTrans xs+20 yp+35 w150, Rom Bracket Preview
 Gui, Add, Edit, xp yp+20 w210 ReadOnly vRomBracketResult

 ;RomTrim
 Gui, Add, GroupBox, Section xs yp+47 w250 h155
 Gui, Add, Edit, Disabled xp+20 yp w115
 Gui, Add, Text, xs+24 yp+3, Trim Characters (Rom)
 Gui, Add, Edit, xs+20 yp+25 w30 Number vRomTrimLeft gGuiPreview Limit1
 Gui, Add, UpDown, yp Range0-9 Wrap, %RomTrimLeft%
 Gui, Add, Text, BackgroundTrans xp+35 yp+3, Left Side
 Gui, Add, Edit, xs+20 yp+30 w30 Number vRomTrimRight gGuiPreview Limit1
 Gui, Add, UpDown, yp Range0-9 Wrap, %RomTrimRight%
 Gui, Add, Text, BackgroundTrans xp+35 yp+3, Right Side 
 Gui, Add, Text, BackgroundTrans xs+20 yp+35 w150, Rom Trim Preview
 Gui, Add, Edit, xp yp+20 w210 ReadOnly vRomTrimResult 
 Recurse = 0

 ;Match Options
 Gui, Add, GroupBox, Section xs yp+47 h200 w250
 Gui, Add, Edit, Disabled xp+20 yp w78
 Gui, Add, Text, xs+24 yp+3, Match Options
 Gui, Add, CheckBox, xs+20 yp+30 w%CBW% h%CBH% vRecurse gGuiPreview Checked%Recurse%
 Gui, Add, Text, BackgroundTrans x+0 yp, % "  Scan Rom Sub-Folders"
 Gui, Add, CheckBox, xs+20 yp+30 w%CBW% h%CBH% vMoveFiles gGuiPreview Checked%MoveFiles%
 Gui, Add, Text, BackgroundTrans x+ yp, % "  Delete Original Art"
 Gui, Add, CheckBox, xs+20 yp+30 w%CBW% h%CBH% vRemoveExact gGuiPreview Checked%RemoveExact%
 Gui, Add, Text, BackgroundTrans x+ yp, % "  Remove 100`% matches from search"
 Gui, Add, CheckBox, xs+20 yp+30 w%CBW% h%CBH% vRemove99 Checked%Remove99%
 Gui, Add, Text, BackgroundTrans x+ yp, % "  Remove 99.9`% matches from search"
 Gui, Add, Text, BackgroundTrans x-20 y-20 vRegion, Region
; Gui, Add, Text, BackgroundTrans xp yp+30, Match Rom to Art

 ;Art Brackets Options
 Gui, Add, GroupBox, Section x298 y145 w250 h180
 Gui, Add, Edit, Disabled xp+20 yp w107
 Gui, Add, Text, xs+24 yp+3, Delete Brackets (Art)
 Gui, Add, Text, BackgroundTrans xs+20 yp+25, %A_Space%[ ... ]
 Gui, Add, Edit, xp+35 yp-3 w30 Number vArtSquareBracket gGuiPreview Limit1
 Gui, Add, UpDown, x+5 yp Range-5-5 Wrap, %ArtSquareBracket%
 Gui, Add, Text, BackgroundTrans x+5 yp+3, Bracket Block
 Gui, Add, Text, BackgroundTrans xs+20 yp+30, %A_Space%{ ... }
 Gui, Add, Edit, xp+35 yp-3 w30 Number vArtCurlyBracket gGuiPreview Limit1
 Gui, Add, UpDown, x+5 yp Range-5-5 Wrap, %ArtCurlyBracket%
 Gui, Add, Text, BackgroundTrans x+5 yp+3, Bracket Block
 Gui, Add, Text, BackgroundTrans xs+20 yp+30, %A_Space%( ... )
 Gui, Add, Edit, xp+35 yp-3 w30 Number vArtRoundBracket gGuiPreview Limit1
 Gui, Add, UpDown, x+5 yp Range-5-5 Wrap, %ArtRoundBracket%
 Gui, Add, Text, BackgroundTrans x+5 yp+3, Bracket Block
 Gui, Add, Text, BackgroundTrans xs+20 yp+35 w150, Art Bracket Preview
 Gui, Add, Edit, xp yp+20 w210 ReadOnly vArtBracketResult
 
 ;ArtTrim
 Gui, Add, GroupBox, xs yp+47 w250 h155
 Gui, Add, Edit, Disabled xp+20 yp w105
 Gui, Add, Text, xs+24 yp+3, Trim Characters (Art)
 Gui, Add, Edit, xs+20 yp+25 w30 Number vArtTrimLeft gGuiPreview Limit1
 Gui, Add, UpDown, yp Range0-9 Wrap, %ArtTrimLeft%
 Gui, Add, Text, BackgroundTrans xp+35 yp+3, Left Side
 Gui, Add, Edit, xs+20 yp+30 w30 Number vArtTrimRight gGuiPreview Limit1
 Gui, Add, UpDown, yp Range0-9 Wrap, %ArtTrimRight%
 Gui, Add, Text, BackgroundTrans xp+35 yp+3, Right Side 
 Gui, Add, Text, BackgroundTrans xs+20 yp+35 w150, Art Trim Preview
 Gui, Add, Edit, xp yp+20 w210 ReadOnly vArtTrimResult 

 ; Regex
 Gui, Add, GroupBox, xs yp+47 w250 h200
 Gui, Add, Edit, Disabled xp+20 yp w82
 Gui, Add, Text, xs+24 yp+3 cBlue vRegReplace, Regex Replace
 Gui, Font, Norm
 Gui, Add, Edit, xp yp+25 w210 gGuiPreview vRegex, %Regex%
 Gui, Add, Text, BackgroundTrans xp yp+30 w150, Replacement Text
 Gui, Add, Edit, xp yp+15 w210 gGuiPreview vReplaceText
 Gui, Add, Text, BackgroundTrans xp yp+30 w150, Regex Preview (Rom)
 Gui, Add, Edit, xp yp+15 w210 ReadOnly vRomRegexResult
 Gui, Add, Text, BackgroundTrans xp yp+30 w150, Regex Preview (Art)
 Gui, Add, Edit, xp yp+15 w210 ReadOnly vArtRegexResult

 ;StringReplace 
 Gui, Add, GroupBox, Section x566 y145 w418 h556
 Gui, Add, Edit, Disabled xs+20 yp w73
 Gui, Add, Text, xs+24 yp+3, Replace Text
 Gui, Add, ListView, xs+20 yp+25 w378 r18 AltSubmit vReplaceLV hwndLV_LView, Search For:|Replace With:|A|W
 LV_ModifyCol(1, 162)
 LV_ModifyCol(2, 162)
 LV_ModifyCol(3, 25)
 LV_ModifyCol(4, 25)
 Gosub, LoadSRL 
 Gui, Add, Button, xp y+25 w85 h30 vB5 gAddSRL, Add New
 Gui, Add, Button, x+15 yp w85 h30 vB6 gRemoveSRL, Delete
 Gui, Add, Button, x+15 yp w85 h30 vB7 gClearSRL, Delete All
 Gui, Add, Button, x+15 yp w38 h30 vB8 gMoveUp, /\
 Gui, Add, Button, x+2 yp w38 h30 vB9 gMoveDown, \/
 Gui, Add, Text, BackgroundTrans xs+20 yp+43 w150, Final Preview (Rom)
 Gui, Add, Edit, xp yp+20 w378 ReadOnly vRomReplacementResult
 Gui, Add, Text, BackgroundTrans xs+20 yp+43 w150, Final Preview (Art)
 Gui, Add, Edit, xp yp+20 w378 ReadOnly vArtReplacementResult
 Loop, 19
   Control_Colors("B" A_Index, "Set", "0x1C20AC")
 Control_Colors(Gui1ID, "RCB", 0, 0)
 Gui, Show, Hide

;*************************************** Regex Help (GUI 2) ****************************************

 Gui, 2:Default
 Gui, +Owner1 +OwnDialogs +Border +0x40000
 Gui, Color, AC201C, FBA441
 Gui, Font, s10
 Gui, Add, Text,x10 y10,  A Perl-Compatible Regular Expression (PCRE) Pattern`n\.*?+[{|()^$ must be preceded by a backslash to be seen as literal.
 Gui, Add, Text,y+10 x10, Examples:
 Gui, Add, Edit, y+5 x10, 1.  [^a-zA-Z0-9& ] Only match characters a-z, A-Z, 0-9, &, and {space}
 Gui, Add, Text, y+5 x30, Before:  'Game_Name!, The'
 Gui, Add, Text, y+5 x30, After:       'Game Name The'
 Gui, Add, Edit,y+10 x10, 2.  \_.* Matches up to the first _ {Underscore}
 Gui, Add, Text, y+5 x30, Before:  'Game_Name!, The'
 Gui, Add, Text, y+5 x30, After:       'Game'
 Gui, Font, Underline
 Gui, Add, Text, y+10 x120 cBlue gLink1 vURL_Link1, (RegEx) - Quick Reference
 Gui, Add, Button, Default yp x+100 vClose, Close
 GuiControl, Focus, Close
 Gui, Font, norm
 
;************************************** Search Roms (GUI 3) ****************************************

 Gui, 3:Default
 Gui, +Owner1 +OwnDialogs +Border +0x40000
 Gui, Color, AC201C, FBA441
 Gui, +LastFound
 Gui3ID := WinExist()
 GroupAdd, GuiNum3, ahk_id %Gui3ID%
 Gui, Add, ListView, r20 w550 h368 vSearchLV gSearchLV AltSubmit -Hdr +Grid, Search Roms
 Gui, Add, CheckBox, x20 y+15 vAnyWhere gSearch, Search anywhere in filename
 Gui, Add, Text, x+20 yp, Search
 Gui, Add, Edit, x+5 yp-3 w200 Lowercase Limit25 vSearch gSearch
 Gui, Add, Button, x+30 yp w70, Close
 
;***************************************  Miss List (Gui 4) ****************************************

 Gui, 4:Default
 Gui, +Owner1 +OwnDialogs +Border +0x40000
 Gui, Color, AC201C, FBA441
 Gui, Add, Text, r2 w550 vGui4Text
 Gui, Add, ListView, r20 w550 h368 -hdr vMissListLV, A
 Gui, Add, Button, w70 x400 gSaveList, Save
 Gui, Add, Button, x+20 yp w70, Close

;************************************* Set Extensions (Gui 5) **************************************
 
 Gui, 5:Default
 Gui, +Owner1 +OwnDialogs +Border +0x40000
 Gui, Color, AC201C, FBA441
 Gui, Add, Text, vExtGuiText w150, XXX XXXXXXXXXXX
 Gui, Add, ListView, w200 r6 vExtLV checked -hdr, A
 Gui, Add, Button, w60 y+10 xp+140, OK
 Gui, Show, Hide

;************************************ Get File/Folder (Gui 6) **************************************

 Gui, 6:Default
 Gui, +Owner1 +OwnDialogs +Border +0x40000
 Gui, Color, AC201C, FBA441
 If FoF_ImageListID =
 {
  FoF_Ext := "dat,xml" ; Comma Delimited List of Extensions. Leave Blank If No Filter Is Desired.
  Loop, Parse, FoF_Ext, `,
    FoF_Text .= FoF_Text = "" ? "*." A_LoopField : ",*." A_LoopField
  FoF_ImageListID := IL_Create(10)
  Loop 12
      IL_Add(FoF_ImageListID, "shell32.dll", A_Index)
      
  Gui, +Resize -MaximizeBox -MinimizeBox -SysMenu +AlwaysOnTop
  Gui, Add, Text, y10, Folder or File. (%FoF_Text%)
  Gui, Add, TreeView, Section r10 w300 vFoF_Tree gFoF_AddChildren AltSubmit -Lines ImageList%FoF_ImageListID%
  Gui, Add, Button, x148 y+10 w74 gFoF_OK Default, OK
  Gui, Add, Button, x+6 yp w74 gFoF_Cancel, Cancel
  
  FoF_ID := TV_Add("DeskTop", 0, "icon3")
  FoF_AddFilesToTree(A_Desktop, FoF_ID, FoF_ImageListID)
  FoF_ID := TV_Add("Documents", 0, "icon4")
  FoF_AddFilesToTree(A_MyDocuments, FoF_ID, FoF_ImageListID)
  FoF_ID := TV_Add("Programs", 0, "icon4")
  FoF_AddFilesToTree(A_ProgramFiles, FoF_ID, FoF_ImageListID)
  FoF_DriveTypes := "Fixed,CdRom,Removable"
  FoF_IconNumber := "9,12,7"
  StringSplit, FoF_IconNumber, FoF_IconNumber, `,
  Loop, Parse, FoF_DriveTypes, `,
  {
   FoF_IconNumber := FoF_IconNumber%A_Index%
   DriveGet, FoF_List, List, %A_LoopField%
   Loop, Parse, FoF_List
   {
    FoF_ID := TV_Add(A_LoopField . ":", 0, "Icon" FoF_IconNumber)
    FoF_AddFilesToTree(A_LoopField . ":", FoF_ID, FoF_ImageListID)
   }
  }
 } 
;******************************* Get Preview File From Dat (Gui 7) *********************************

 Gui, 7:Default
 Gui, +Owner1 +OwnDialogs +Border +0x40000
 Gui, Color, AC201C, FBA441
 Gui, +Resize -MaximizeBox -MinimizeBox -SysMenu +AlwaysOnTop
 Gui, Add, Text, y10
 Gui, Add, ListView, Section r10 w300 vRomFromDat gGetRomPreviewFile, File Name
 Gui, Add, Button, x148 y+10 w74 Default, OK
 Gui, Add, Button, x+6 yp w74, Cancel
 
;************************************ Display Messages (Gui 8) *************************************

 Gui, 8:Default
 Gui, +Owner1 +Border +0x40000 ;+OwnDialogs
 Gui, Color, AC201C, FBA441
 Gui, Add, Text, BackgroundTrans r5 w220 vGui8Text
 Gui, Add, Button, x65 y85 w70 Default vMBoxOK gMBoxOK, OK
 Control_Colors("MBoxOK", "Set", "0x1C20AC")
 Gui, Add, Button, x+20 yp w70 vMsgCancel gMsgCancel, Cancel
 Control_Colors("MBoxCancel", "Set", "0x1C20AC")
 Gui, Add, Checkbox, x20 y+15 vHideMessage, Do not show this message again.
 Gui, Add, Edit, x10 y10 w50 vMsgNum
 GuiControl, Hide, MsgNum
 
;************************************** Project Gui (Gui 9) ****************************************

 Gui, 9:Default
 Gui, +Owner1 +OwnDialogs +Border +0x40000
 Gui, Color, AC201C, FBA441
 Gui, Add, Text, w300 vProjectText, Open Project
 Gui, Add, ListView, r20 w300 r10 AltSubmit -Hdr vProjectsLV gProjectsLV, A
 Gui, Add, Text, y+20, Project Name:
 Gui, Add, Edit, x+5 yp-3 w228 vProjectEdit
 Gui, Add, Button, w70 x150 y+20 vProjectSave, Save
 Gui, Add, Button, w70 xp yp vProjectOpen, Open
 Gui, Add, Button, x+20 yp w70, Cancel
 
;***************************************  BackDrop (Gui10) *****************************************

 Gui, 10:Default
 Gui, +LastFound
 Gui10ID := WinExist()
 Gui, -caption +0x40000 +ToolWindow
 Gui, Color, Black

;************************************* Settings Gui (Gui 11) ***************************************

 Gui, 11:Default
 Gui, +Owner1 +OwnDialogs +Border +0x40000
; Gui, Color, FBA441, FBA441
 Gui, Color, AC201C, FBA441
; Gui, Add, Picture, x0 y0 w600 h180 0x120E hwnddHwnd
 Gui, Add, GroupBox, Section w300 h235
 Gui, Add, Edit, Disabled xp+20 yp w117
 Gui, Add, Text, xs+24 yp+3, Message Options
 Gui, Font, Bold cFBA441
 Gui, Add, Text, xs+15 ys+35, Show Messages
 Gui, Font, Norm
 Gui, Add, Radio, xs+25 y+15 Checked%MO1% vMessageOption, Hide all messsages
 Gui, Add, Radio, xs+25 y+15 Checked%MO2%, Show all messages
 Gui, Add, Radio, xs+25 y+15 Checked%MO3%, Do Not Show Hidden Messages
 Gui, Font, Bold
 Gui, Add, Text, xs+15 y+20, Tooltips
 Gui, Font, Norm
 Gui, Add, Radio, xs+25 y+15 Checked%MT1% vMessageTips, Show hidden messages as Tooltips
 Gui, Add, Radio, xs+25 y+15 Checked%MT2%, Show all messages as Tooltips
 Gui, Add, CheckBox, xs y+40 vResetMessages, Reset hidden messages
 Gui, Font, Norm cBlack
 Gui, Add, Button, w70 x150 yp-3, OK
 Gui, Add, Button, w70 x+20 yp, Cancel

;************************************** Credits GUI (Gui 12) ***************************************

 CreditsText =
 (







      `t
      `t`tAuthor:`t Matt McLemore Aka 'Tempest'



      `t`t`tFunctions by others:


       `t`t`tAddFileIcon() by Icarus
       http://www.autohotkey.com/community/viewtopic.php?t=29642



      `t`t`tAnsi2Unicode() by Sean
      http://www.autohotkey.com/community/viewtopic.php?t=17343



      `t`tControl_Colors() by DerRaphael
      http://www.autohotkey.com/community/viewtopic.php?p=208290



      `t`tCreateGradientBitmap() by Skan
      http://www.autohotkey.com/community/viewtopic.php?p=425387



      `t`tListview In-Cell Editing by Micahs
      `thttp://www.autohotkey.com/forum/topic19929.html



      `t`tRobert's INI library Basic by Rseding
      `thttp://www.autohotkey.net/~Rseding91/Fast ini library/
      `tStdLib Compliant/Basic/RIni.ahk



      `t`t`tSetTip() by Micahs
      http://www.autohotkey.com/community/viewtopic.php?p=262187



      `t`t   UnHtm() by Skan 19-Nov-2009
      `t   www.autohotkey.com/forum/topic51342.html







 )

 WinH = 100          ; Height of GUI
 YPos := WinH   ; Bottom of GUI Window
 Gui, 12:Default
 Gui,  +Owner1 +ToolWindow
 Gui, Margin, 0, 0
 Gui, Font, Bold s10
 Gui, Add, Picture, x0 y0 w600 h180 0x120E hwnddHwnd
 Gui, Add, Text, BackgroundTrans vCreditsGui x0 y%YPos% w600, %CreditsText%
 Gui, Font, Normal

;**************************************** Initialize Gui 1 *****************************************
  
 Gui, 1:Default
 Gui, Show, Hide Center AutoSize, % ScriptName " by Matt McLemore AKA 'Tempest'"
 Gui, Submit, Hide
 DllCall( "DeleteObject", UInt,hBMP )
 hBMP := GDI_CreateGradientBitmap( 3, "FBA441", "AC201C", 1024, 768 ) ;"FBA441", "AC201C" "FF8040", "A04020"
 DllCall( "SendMessage", UInt,cHwnd, UInt,0x172, UInt,0, UInt,hBMP )
 DllCall( "SendMessage", UInt,dHwnd, UInt,0x172, UInt,0, UInt,hBMP )
 GuiControl, Focus, Region
 SetPreviewFile("Rom", LastRomFolder)
 SetPreviewFile("Art", LastArtFolder)
 ClickLink()
 WinGetPos, GuiX, GuiY, GuiW, GuiH, ahk_id%Gui1ID%
 GuiW -= 10, GuiH -=10
 Gui, 10:Show, x%GuiX% y%Guiy% w%GuiW% h%GuiH%
 Gui, 1:Show
 InitCellEditing("ReplaceLV", "1")
} ; End Create Gui's

;******************************************* On Message ********************************************

WM_SYSCOMMAND(wParam)
{
 Global Gui1ID
 If (A_Gui = 1 && wParam = 0xF020) ; SC_MINIMIZE
 {
   Gui, 10: Hide
   Gui, 1: Minimize
 }
 If (A_Gui = 1 && wParam = 0xF120) ; SC_RESTORE
 {
  Gui, 1: +AlwaysOnTop
  Gui, 1: Restore
  Sleep, 10
  Gui, 10:Show
  Gui, 1: -AlwaysOnTop
 }
}

WM_WINDOWPOSCHANGED()
{
 Global Gui1ID, Gui10ID
 WinGetPos, GuiX, GuiY,,, ahk_id%Gui1ID%
 GuiX -= 6, GuiY -=6
 WinMove, ahk_id%Gui10ID%,, %GuiX%, %GuiY%
}

;****************************************** Project Menu *******************************************

OpenProject:
 LoadProjectsLV("Open")
Return

SaveProjectAs:
LoadProjectsLV()
Return

SaveProject:
 IniSave()
 MBox(1,LastProject)
Return

LoadProjectsLV(Param="")
{
 Global IniSections, ProjectsLV
 Gui, +Disabled
 Gui, 9:Default
 Gui, 9:ListView, ProjectsLV
 LV_Delete()
 Flag = 0
 Loop, Parse, IniSections, `,
 {
  If (A_LoopField <> "General")
  {
   LV_Add("", A_LoopField)
   Flag = 1
  }
 }
 If Flag = 0
 {
  MBox(2)
  Return
 } 
 If Param = Open
 {
  GuiControl,, ProjectText, Open Project
  GuiControl, Hide, ProjectSave
  GuiControl, Show, ProjectOpen
 }
 Else
 {
  GuiControl,, ProjectText, Save Project as:
  GuiControl, Hide, ProjectOpen
  GuiControl, Show, ProjectSave
 }
 Gui, 9:Show,, %ScriptName%
 WinGet,  GuiID, ID, A 
 WinWaitNotActive,  ahk_id %GuiID%
 Gui, 1:Default
 Gui, -Disabled
 Gui, 1:Show
}

;********************************* Project Dialog (Gui 9) Actions **********************************

ProjectsLV:
If A_GuiEvent = Normal
{
 RowNumber := LV_GetNext(0)
 If RowNumber <> 0
 {
  LV_GetText(TempVar, RowNumber)
  GuiControl,, ProjectEdit, %TempVar%
 }
}
Return

9ButtonOpen:
 GuiControlGet, ProjectEdit
 If ProjectEdit = 
    Mbox(3)
 Else
 {
  LastProject := ProjectEdit
  Gui, 9:Hide
  Loop, Parse, Keys, `,
  {
   IniRead, %A_LoopField%, %ScriptIni%, %LastProject%, %A_LoopField%
   GuiControl, 1:, %A_LoopField%, % %A_LoopField%
  }
  GoSub, LoadSRL
  SetTip("Edit1", LastRomFolder)
  SetTip("ComboBox1", LastArtFolder)
  SB_SetText("   " LastProject)
 }
Return

9ButtonSave:
 GuiControlGet, ProjectEdit
 If ProjectEdit = 
    Mbox(4)
 Else
 {
  LastProject := ProjectEdit
  If LastProject Not In %IniSections%
     IniSections .= "," LastProject
  IniSave()
  Gui, 9:Hide
  SB_SetText("   " LastProject)
  MBox(17, LastProject)
 }
Return

9ButtonCancel:
9GuiClose:
 Gui, Hide
Return

;**************************************** Message Options ******************************************

MessageSettings:
 Gui, 11:Default
 Gui, Show
 WinGet,  GuiID, ID, A
 WinWaitNotActive,  ahk_id %GuiID%
Return

11ButtonOK:
 Gui, 11:Submit
 If ResetMessages = 1
 {
  GuiControl,, ResetMessages, 0
  HideMessages =
 }
11ButtonCancel:
11GuiClose:
 Gui, Hide
 Gui, 1:Default
 Gui, 1:Show
Return

;*********************************** Custom Message Box (Gui 8) ************************************

MBox(MsgNum, Var="", Cancel=False)
{
 Global MBoxOK, HideMessages, MessageOption, MessageTips, TipActive, GuiPid
 If (MessageOption = 1) OR (GuiPid = "")        ;Hide all messsages
    Return
 GuiControl, 8:, MsgNum, %MsgNum%
 Var1 := "XXX", Var2 := "YYY"
 Message := Message%MsgNum%
 Loop, Parse, Var, |
    StringReplace, Message, Message, % Var%A_Index%, %A_LoopField%, A
 Hidden = 0
 If MsgNum In %HideMessages%
    Hidden = 1
 If MessageOption = 2        ;Show all messages
 {
  If MessageTips = 2         ;Show all Messages as ToolTips
  {
   Message .= "`n "
   ToolTip, %Message%,,, 20
   TipActive = 1
  }
  Else If Hidden = 1
  {
   Message .= "`n "
   ToolTip, %Message%,,, 20
   TipActive = 1
  }
  Else GoSub, ShowMessage
 }
 Else If (MessageOption = 3 AND Hidden = 0)  ;Do Not Show Hidden Messages
 {
  If MessageTips = 2
  {
   Message .= "`n "
   ToolTip, %Message%,,, 20
   TipActive = 1
  }
  Else Gosub, ShowMessage
 }
Return

 ShowMessage:
  MBoxOK = 1
  StringReplace, Message, Message, `n, `n, UseErrorLevel
  Loop, % 2 - ErrorLevel
    Message := "`n" Message
  Gui, 8:Default
  GuiControl,, Gui8Text, %Message%
  If Cancel
  {
   GuiControl, Show, MsgCancel
   GuiControl, Move, MBoxOK, x65
  }
  Else
  {
   GuiControl, Hide, MsgCancel
   GuiControl, Move, MBoxOK, x155
  }
  Gui, Show, w232 h155, %ScriptName%
  WinGet,  GuiID, ID, A
  WinWaitNotActive,  ahk_id %GuiID%
 Return
}

8GuiClose:
MsgCancel:
 MBoxOK = 0
MBoxOK:
 GuiControlGet, HideMessage
 If HideMessage = 1
 {
  GuiControlGet, MsgNum, 8:
  HideMessages .= HideMessages = "" ? MsgNum : "," MsgNum
  Sort, HideMessages, D`, U
  GuiControl,, HideMessage, 0
 }
 Gui, Hide
 Gui, 1:Default
Return

;****************************************** GUI Previews *******************************************

GuiPreview:
 Gui, Submit, NoHide
 MatchedOnce = 0
 If (A_GuiControl <> "RemoveExact") And (A_GuiControl <> "Remove99")
 {
  RefreshMatchLV = 1
  GoSub, StringReplaceInit
  GuiPreview("Art")
  GuiPreview("Rom")
 }
Return

GuiPreview(Type)
{
 GuiControlGet, Text,, %Type%PreviewFile
 If Text = No file found.
    Text =
 Text := DeleteBrackets(Text,Type)
 Text := RemoveSpaces(Text)
 GuiControl, 1:, %Type%BracketResult, %Text%
 Text := TrimChars(Text,Type)
 Text := RemoveSpaces(Text)
 GuiControl, 1:, %Type%TrimResult, %Text%
 Text := Regex(Text)
 Text := RemoveSpaces(Text)
 GuiControl, 1:, %Type%RegexResult, %Text%
 Text := StringReplacement(Text)
 Text := RemoveSpaces(Text)
 GuiControl, 1:, %Type%ReplacementResult, %Text%
}

;***************************************** Get Rom Folder ******************************************

GetRomFolder:
 GoSub, SelectFileFolder
 If FoF_FullPath =
    Return
 GuiControl,1:, LastRomFolder, %FoF_FullPath%
 Flag := SetPreviewFile("Rom", FoF_FullPath)
Return

SelectFileFolder:
 Gui, 6:Default
 Gui, Show, h286 w317, Browse For File Or Folder
 WinGet,  GuiID, ID, A 
 WinWaitNotActive,  ahk_id %GuiID%
Return

FoF_Cancel:
6GuiClose:
 FoF_FullPath =
FoF_Ok:
 Gui, 6:Hide
 Gui, 1:Default
Return

;***************************************************************************************************

FoF_AddChildren:
 If A_GuiEvent = Normal
 {
  FoF_ItemID := A_EventInfo
  FoF_ParentID := FoF_ItemID
  FoF_FullPath =
  Loop
  {
   TV_GetText(ParentText, FoF_ParentID)
   FoF_ParentID := TV_GetParent(FoF_ParentID)
   If FoF_ParentID = 0
   {
    If ParentText = desktop
       ParentText = %A_Desktop%
    If ParentText = documents
       ParentText = %A_MyDocuments%
    If ParentText = programs
       ParentText = %A_ProgramFiles%
    FoF_FullPath = %ParentText%\%FoF_FullPath%
    Break
   }
   Else FoF_FullPath = %ParentText%\%FoF_FullPath%
  }
  StringReplace, FoF_FullPath, FoF_FullPath, \\ , \
  StringRight, FoF_LastChar, FoF_FullPath, 1
  If FoF_LastChar = \
     StringTrimRight, FoF_FullPath, FoF_FullPath, 1
  FoF_AddFilesToTree(FoF_FullPath, FoF_ItemID, FoF_ImageListID, 1)
 }
Return

FoF_AddFilesToTree(Path, ParentID, FoF_ImageListID, Flag = 0)
{
 Static TreeMap := "`n"
 Global FoF_Ext
 If Flag = 0
 {
  TreeMap .= ParentID "`n"
  Loop, %Path%\*.*, 1
  {
   SplitPath, A_LoopFileName,,, FoF_ThisExt
   If (FoF_Ext = "") OR InStr(FoF_Ext, FoF_ThisExt)
   {
    FoF_IconNumber := AddFileIcon(A_LoopFileFullPath, FoF_ImageListID)
    ChildID := TV_Add(A_LoopFileName, ParentID , "Icon" . FoF_IconNumber)
    Loop, %A_LoopFileFullPath%\*.*, 1
    {
     SplitPath, A_LoopFileName,,, FoF_ThisExt
     If (FoF_Ext = "") OR InStr(FoF_Ext, FoF_ThisExt)
     {
      FoF_IconNumber := AddFileIcon(A_LoopFileFullPath, FoF_ImageListID)
      TV_Add(A_LoopFileName, ChildID , "Icon" . FoF_IconNumber)
     }
    }
   }
  }
 }
 Else
 {
  Pos := InStr( TreeMap, "`n" ParentID "`n" )
  If Pos = 0
  {
   TreeMap .= ParentID "`n"
   ChildID := TV_GetChild(ParentID)
   Loop
   {
    If ChildID = 0 
       Break
    TV_GetText(Dir, ChildID)
    Loop, %path%\%Dir%\*.*, 1
    {
     SplitPath, A_LoopFileName,,, FoF_ThisExt
     If (FoF_Ext = "") OR InStr(FoF_Ext, FoF_ThisExt)
     {
      FoF_IconNumber := AddFileIcon(A_LoopFileFullPath, FoF_ImageListID)
      TV_ADD(A_LoopFileName, ChildID , "Icon" . FoF_IconNumber)
     }
    }
    ChildID := TV_GetNext(ChildID)
   }
  }
 }
 GuiControl, MoveDraw, FoF_Tree
}

;************* By Icarus - http://www.autohotkey.com/community/viewtopic.php?t=29642 ***************

AddFileIcon(File, ImageList)
{
 VarSetCapacity(Filename, 260)
 sfi_size = 352
 VarSetCapacity(sfi, sfi_size)

 FileName := file
 SplitPath, FileName,,, FileExt
 If FileExt in EXE,ICO,ANI,CUR
 {
  ExtID := FileExt
  IconNumber = 0
 }
 Else
 {
  ExtID = 0
  Loop 7
  {
   StringMid, ExtChar, FileExt, A_Index, 1
   If Not ExtChar
     Break
   ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
  }
  IconNumber := IconArray%ExtID%
 }
  
 If Not IconNumber
 {
  If not DllCall("Shell32\SHGetFileInfoA", "str", FileName, "uint", 0, "str", sfi, "uint", sfi_size, "uint", 0x101)
    IconNumber = 9999999
     
  Else
  {
   hIcon = 0
   Loop 4
   hIcon += *(&sfi + A_Index-1) << 8*(A_Index-1)
   IconNumber := DllCall("ImageList_ReplaceIcon", "uint", imageList, "int", -1, "uint", hIcon) + 1
   DllCall("DestroyIcon", "uint", hIcon)
   IconArray%ExtID% := IconNumber
  }
 }
 Return IconNumber
}

;***************************************** Get Art Folder ******************************************

GetArtFolder:
 FileSelectFolder, ArtFolder, *%LastArtFolder%,, Skinny Match - Browse to your Art Folder
 If Errorlevel  = 1
    Return
 GuiControl := A_GuiControl
 Flag := SetPreviewFile("Art", ArtFolder)
 If Flag = 1
 {
  ControlGet, ArtFolderList, List,, Combobox1
  If GuiControl = NewArtFolder
     ArtFolderList := "|" ArtFolder "||"
  Else
  {
   StringReplace, ArtFolderList, ArtFolderList, `n, |, A
   ArtFolderList := "|" ArtFolderList "|"
   IfNotInstring, ArtfolderList, |%Artfolder%|
      ArtFolderList .= ArtFolder "||"
   Else
      StringReplace, ArtFolderList, ArtFolderList, |%Artfolder%|, |%Artfolder%||
  }
  GuiControl, 1:, LastArtFolder, %ArtFolderList%
  IniWrite, |%ArtFolderList%, %ScriptIni%, %LastProject%, ArtFolderList
 }
Return

;*************************************** Delete Art Folder *****************************************

DelArtFolder:
 GuiControlGet, ArtFolder,, LastArtFolder
 ControlGet, ArtFolderList, List,, Combobox1
 IfInString, ArtFolderList, `n
 {
  StringReplace, ArtFolderList, ArtFolderList, `n, |, A
  ArtFolderList := RegexReplace(ArtFolderList, "^\Q" ArtFolder "\E\||\|\Q" ArtFolder "\E\||\|\Q" ArtFolder "\E$", "|", Count)
  ArtFolderList := RegexReplace(ArtFolderList, "^\||\|$")
  IfInString, ArtFolderList, | 
    StringReplace, ArtFolderList, ArtFolderList, |, ||
  Else ArtFolderList .= "||"
  GuiControl,, LastArtFolder, |%ArtFolderList%
  GuiControlGet, ArtFolder,, LastArtFolder
  SetPreviewFile("Art", ArtFolder)
  IniWrite, |%ArtFolderList%, %ScriptIni%, %LastProject%, ArtFolderList
 }
 Else MBox(8)
Return

;************************************ Set Preview (Automatic) **************************************

SetArtPreview:
 GuiControlGet, ArtFolder,, LastArtFolder
 SetPreviewFile("Art", ArtFolder)
Return

SetPreviewFile(Type, Folder)
{
 Global RefreshMatchLV, Data, ScriptIni, StartPos, LastProject, Needle, DataFileType
 Flag = 0
 SplitPath, Folder,,, OutExt
 If OutExt = ;No extension means user selected a folder
 {
  GuiControlGet, Extensions, 1:, %Type%Extensions
  If Extensions  =
     Extensions = *
  Recurse = 0
  If Type = Rom
     GuiControlGet, Recurse, 1:, Recurse
  Loop, Parse, Extensions, `,
  {
   Loop, %Folder%\*.%A_LoopField%, 0, %Recurse%
   {
    Flag = 1
    SplitPath, A_LoopFileName,,,, NameNoExt
    If Type = Rom
    {
     GuiControl, Enable, Recurse
     GuiControl, Enable, RomExtensions
     GuiControl, Enable, ExtButton
    }
    Break
   }
  }
  If Flag = 0
  {
   MBox(7, Extensions "|" Folder)
   GuiControl,, %Type%PreviewFile, No file found.
   Return
  }
 }
 Else
 {
  FileRead, Data, %Folder%
  DataFileType := "SoftList"
  Needle := "m)^\s*<software name= ?""(?!.*\[BIOS])(.+?)"""
  StartPos := InStr(Data, "<softwarelist name=")
  If StartPos = 0
  {
   DataFileType := "HyperSpinXML" 
   Needle := "m)^\s*<game name= ?""(?!.*\[BIOS])(.+?)"""
   StartPos := InStr(Data, "<game name=") 
  }
  If StartPos = 0
  {
   DataFileType := "CMP"
   Needle := "m)^\s*name ?""(?!.*\[BIOS])(.+?)"""
   StartPos := InStr(Data, "game (")
  }

;\.*?+[{|()^$                                            
  ;<game name="Activision Decathlon, The (USA)">         HyperSpin
  ;name "[BIOS] Atari 5200 (USA)"                        CMP (NoIntro/Tosec)
	;rom ( name "5200 Menu Program (2003) (PD).a52"        GoodSet
	;<software name="aeroblst">                            SoftList
	;	<description>Aero Blasters</description>
  If DataFileType = SoftList
     Flag := RegExMatch(Data, "<description>(.+?)</description>", NameNoExt, StartPos)
  Else
     Flag := RegExMatch(Data, Needle, NameNoExt, StartPos)
  NameNoExt := UnHTM(NameNoExt1)
  NameNoExt := UTF82Ansi(NameNoExt)
  If (StartPos = 0) OR (Flag = 0)
  {
   DataFileType =
   MBox(9,Folder)
   Return
  }
  GuiControl, Disable, Recurse
  GuiControl, Disable, RomExtensions
  GuiControl, Disable, ExtButton
 }
 Class := Type = "Rom" ? "Edit1" : "ComboBox1"
 SetTip(Class, Folder)
 Last%Type%Folder = %Folder%
 IniWrite, %Folder%, %ScriptIni%, %LastProject%, Last%Type%Folder
 GuiControl, 1:, %Type%PreviewFile, %NameNoExt%
 RefreshMatchLV = 1
 Return Flag
}

;********************************** Get Preview (User Selected) ************************************

GetRomPreviewFile:
 GetPreviewFile("Rom")
Return

GetArtPreviewFile:
 GetPreviewFile("Art")
Return

GetPreviewFile(Type)
{
 Global Data, StartPos, Needle, DataFileType
 GuiControlGet, Folder, 1:, Last%Type%Folder
 SplitPath, Folder,,, OutExt
 If OutExt <>
 {
  Gui, 7:Default
  Gui, 7:ListView, RomFromDat
  LV_Delete()
  Pos := StartPos
  Loop
  {
   If DataFileType = SoftList
      Pos := RegExMatch(Data, "<description>(.+?)</description>", TempVar, Pos)
   Else
      Pos := RegExMatch(Data, Needle, TempVar, Pos)
   If Pos = 0
      Break
   Pos += StrLen(TempVar1)
   NameNoExt := UnHTM(TempVar1)
   NameNoExt := UTF82Ansi(NameNoExt)
   LV_ADD("", NameNoExt)
  }
 Gui, 7:Show,, %ScriptName%
 WinGet,  GuiID, ID, A 
 WinWaitNotActive,  ahk_id %GuiID%
 }
 Else
 { 
  GuiControlGet, Extensions, 1:, %Type%Extensions
  StringReplace, TempVar, Extensions, `,, `;*., A
  If TempVar =
     TempVar := "*"
  TempVar = *.%TempVar%
  FileSelectFile, PreviewFile,,%Folder%, Select %Type% Preview File, %TempVar%
  If PreviewFile <>
  {
   SplitPath, PreviewFile, Name,, Ext, NameNoExt
   GuiControl,, %Type%PreviewFile, %NameNoExt%
  }
 }
}

7ButtonOK:
 Gui +OwnDialogs
 RowNumber := LV_GetNext()
 LV_GetText(NameNoExt, RowNumber)
 GuiControl, 1:, RomPreviewFile, %NameNoExt%

7ButtonCancel:
7GuiClose:
 Gui, Hide
 Gui, 1:Default
 Gui, 1:Show
Return

;************************************* Handle Match LV Events ***************************************

MatchLV_Events:
 If (A_GuiEvent == "e")
 {
  LV_GetText(NextText, EditRow)
  Tooltip
  If PrevText <> %NextText%
     LV_Modify(EditRow,"",PrevText,NextText,"Edit")
 }
 Else  If (A_GuiEvent == "E")
 {
  EditRow := A_EventInfo
  LV_GetText(PrevText, A_EventInfo)
  ToolTip,%PrevText%
 }
 Else If (A_GuiEvent == "F")
 {
  RefreshMatchLV()
 }
 Else If A_GuiEvent = R
 {
  RowNumber := A_EventInfo
  Goto, SearchArt
 }
 Else If (A_GuiEvent = "DoubleClick")  AND (MatchedOnce = 1)
 {
  GoSub, ViewArt
 }
 Else If (A_GuiEvent = "RightClick") AND (MatchedOnce = 1)
 {
  MenuRow := A_EventInfo
  Gui, 1:Default
  Menu, MyMenu, Add
  Menu, MyMenu, DeleteAll
  LV_GetText(MatchCount, MenuRow, 4)
  Flag = 0
  Loop, Parse, AltMatch%MatchCount%, `,
  {
   Flag = 1
   StringSplit, TempVar, A_LoopField, |
   MenuItem :=  s_ItemList%TempVar1% A_Tab TempVar2 "%"
   Menu, MyMenu, Add, %MenuItem%, MenuHandler
  }
  If Flag = 1
     Menu, MyMenu, Show
 }
Return

MenuHandler:
 StringSplit, MenuItem, A_ThisMenuItem, %A_Tab%
 Gui, 1:ListView, MatchLV
 LV_Modify(MenuRow,"-select Col2",MenuItem1,"Menu")
Return

;******************************* Refresh Match Lv if Options Change ********************************

RefreshMatchLV()
{
 Global
 If RefreshMatchLV = 1
 {
  Gui, Submit, NoHide
  Gui, 1:Default
  Gui, 1:ListView, MatchLV
  LV_Delete()
  GuiControl, -Redraw, MatchLV
  SplitPath, LastRomFolder,,, OutExt
  If (OutExt = "")
  {
   Loop, Parse, RomExtensions, `,
   {
    Loop, %LastRomFolder%\*.%A_LoopField%, 0, %Recurse%
    {
;     MsgBox, %A_LoopFileName%
     IfNotInString, A_LoopFileName, [Bios]
     {
      SplitPath, A_LoopFileName, Name,, Ext, NameNoExt
      If NameNoExt Not in %MatchedRoms%
         LV_ADD("", NameNoExt)
     }
    }
   }
  }
  Else
  {
   Pos := StartPos 
   Loop
   {
    Pos := RegExMatch(Data, Needle , TempVar, Pos)
    If Pos = 0
       Break
    Pos += StrLen(TempVar1)
    NameNoExt := UnHTM(TempVar1)
    NameNoExt := UTF82Ansi(NameNoExt)
    If NameNoExt Not in %MatchedRoms%
    { 
     If DataFileType = SoftList
     {
      ShortName := NameNoExt
      Pos := RegExMatch(Data, "<description>(.+?)</description>" , TempVar, Pos)
      NameNoExt := UnHTM(TempVar1)
      NameNoExt := UTF82Ansi(NameNoExt)
      LV_ADD("", NameNoExt,"","","", ShortName)
     }
     Else     
       LV_ADD("", NameNoExt)
    }
   }
  }
  GuiControl, +Redraw, MatchLV
  MatchedOnce = 0
  Save = 0
  RefreshMatchLV = 0
 }
}

;***************************************************************************************************
;********************************** GUI (1) Labels and Hot Keys ************************************
;***************************************************************************************************

; Hot Keys
 ^Q:: ExitApp
#IfWinActive ahk_group GuiNum1

 Escape:: GoTo, StopMatch
 ^A:: GoTo, Selectall
 ^N:: GoTo, SelectNone
 ~^V:: GoTo, ViewArt
 ^R:: GoTo, SearchArt
 F12:: GoTo, SaveProjectAs
 ^O:: GoTo, OpenProject
 ^S:: GoTo, SaveProject
 DEL:: GoTo, HideTip
#IfWinActive

HideTip:
 If TipActive = 1
 {
  GuiControlGet, MsgNum, 8:
  HideMessages .= HideMessages = "" ? MsgNum : "," MsgNum
  Tooltip,,,, 20
 }
Return

ChangeTabs:
 GuiControlGet, CurrentTab
 If CurrentTab = Match
    RefreshMatchLV()
Return

GuiContextMenu:
 If A_GuiControl = RegReplace
 {
  Gui, 2:Default
  Gui, 2:Show,,%ScriptName%
 }
Return

Restart:
 Run, %A_ScriptName%

StopMatch:
 GuiControlGet, CurrentTab
 If CurrentTab = Match
 {
  Stop = 1
  WinActivate, Matt McLemore
 }
Return

Selectall:
 GuiControlGet, CurrentTab
 Gui, 1:ListView, MatchLV
 If CurrentTab = Match
    LV_Modify(0, "Select")
Return

SelectNone:
 GuiControlGet, CurrentTab
 Gui, 1:ListView, MatchLV
 If CurrentTab = Match
    LV_Modify(0, "-Select")
Return

;************************************** View Image - GUI (2) ***************************************

ViewArt:
 If (CurrentTab = "Match")
 {
  If MatchedOnce = 0
     MBox(10)
  Else
  {
   Gui, ListView, MatchLV
   RowNumber := LV_GetNext(0)
   If Not RowNumber
      MBox(11)
   Else 
   {
    GuiControlGet, ArtExtensions
    WinGetActiveTitle, Title
    RowNumber = 0
    While RowNumber := LV_GetNext(RowNumber)
    {
     Loop, Parse, ArtExtensions, `,
     {
      LV_GetText(ArtFile, RowNumber, 2)
      IfExist %ArtFolder%\%ArtFile%.%A_LoopField%
        RunWait, %ArtFolder%\%ArtFile%.%A_LoopField%
     }
    }
   }
  }
 }
Return

;********************************** Search Art Folder - GUI (3) ************************************

SearchArt:
 If (CurrentTab = "Match")
 {
  If MatchedOnce = 0
     MBox(18)
  Else
  {
   RefreshMatchLV()
   RowNumber := LV_GetNext(0) 
   If Not RowNumber
      MBox(19)
   Else
   {
    LV_GetText(Title,Rownumber)
    Gui, 3:Default
    Gui, 3:Show,, %Title%
    ControlFocus, Edit1, %Title%
    GuiControl,, Search, %Null%
    LV_Modify( 1, "Select")
   }
  }
 }
Return

Search:
 GuiControlGet, AnyWhere
 GuiControlGet, Search
 LV_Delete()
 GuiControl, -Redraw, SearchLV
 Loop, %OrigArtList0%
 {
  If OrigArtList%A_Index% =
     Continue
  If AnyWhere = 0
  {
   StringLeft, SearchText, OrigArtList%A_Index%, StrLen(Search)
   If SearchText = %Search%
      LV_Add("", OrigArtList%A_Index%)
  }
  Else
  {
   IfInString, OrigArtList%A_Index%, %Search%
     LV_Add("", OrigArtList%A_Index%)
  }
 }
 GuiControl, +Redraw, SearchLV
 LV_Modify( 1, "Select") 
Return

; Accept choice in Search GUI

#IfWinActive ahk_group GuiNum3
 Enter::          
  EventInfo := "1"
  Enter()
 Return
#IfWinActive

SearchLV:
 If(A_GuiEvent = "Normal")
 {
  EventInfo := A_EventInfo
  Enter()
 }
Return

Enter()
 {
  Global RowNumber, EventInfo
  Gui, 3:Default
  Lv_GetText(SearchText, EventInfo)
  Gui, 3:Hide
  Gui, 1:Default
  If RowNumber <> 0
     LV_Modify( RowNumber, "Col2", SearchText,"Search") 
  Gui, Show
 }

;************************************* Missing List - GUI (4) **************************************

MissList: 
 Gui, Submit, NoHide
 SaveText=
 If % LV_GetCount() = 0
    MBox(14)
 Else
 {
  Loop % LV_GetCount()
  {
   LV_GetText(NameNoExt, A_Index)
   IfExist, % ArtFolder . "\" . NameNoExt . ".*"
     Continue
   IfExist, % ArtFolder . "\Renamed\" . NameNoExt . ".*"
     Continue
   SaveText.= NameNoExt . "`n"
  }
  If SaveText <>
  {
   Gui, 4:Default
   Gui, ListView, MissListLV
   LV_Delete()
   GuiControl,, Gui4Text, %ArtFolder%`n%Artfolder%\Renamed
   Loop, Parse, SaveText, `n
     LV_Add("", A_LoopField)
   Gui, 4:Show,, Roms Without Art
  }
  Else MBox(15)
 }
Return

SaveList:
 Gui +OwnDialogs
 Fileselectfile, savefile, s,,Save As:,*.txt
 If ErrorLevel = 0
 {
  FileDelete, %SaveFile%
  Loop, 50
  {
   Sleep, 50
   IfNotExist, %SaveFile%
     Break
  }
  FileAppend, %SaveText%, %SaveFile%
  MBox(16, SaveFile)
 }
 4ButtonClose:
 4GuiClose:
 Gui, Hide
 Gui, 1:Default
 Gui, 1:Show
Return

;************************************ Set Extensions - GUI (5) *************************************

SetArtExtensions:
 Type  := "Art"
 ControlGet, FolderList, List,, Combobox1
 GoTo, ExtLV

SetRomExtensions:
 Type  := "Rom"
 GuiControlGet, FolderList,, LastRomFolder

ExtLV:
 If Last%Type%Folder =
    MBox(20, Type)
 Else
 {
  GuiControlGet, CurrentExt, 1:, %Type%Extensions
  StringSplit, Folder, FolderList, `n, `r
  If CurrentExt =
     CurrentExt = *
  Extensions := CurrentExt
  Recurse = 0
  If Type = Rom
     GuiControlGet, Recurse
  Loop, %Folder0%
  {
   Loop, % Folder%A_Index% "\*.*",, %Recurse%
   {
    IfNotInString, Extensions, %A_LoopFileExt%
      IF StrLen(A_LoopFileExt) = 3
        Extensions .=  "," A_LoopFileExt
   }
  }
  Sort, Extensions, U D,
  StringLower, Extensions, Extensions
  Gui, 5:Default
  GuiControl,, ExtGuiText, %Type% Extensions:
  Gui, ListView, ExtLV
  LV_Delete()
  Loop, Parse, Extensions, `,
  {
   If A_LoopField <>
   {
    If A_LoopField in %CurrentExt%
       LV_add("Check", A_LoopField)
    Else
       LV_add("", A_LoopField)
   }
  }
  Gui, Show,, %ScriptName%
  WinGet,  GuiID, ID, A 
  WinWaitNotActive,  ahk_id %GuiID%
 }
Return

5ButtonOK:
 Extensions =
 While RowNumber := LV_GetNext(RowNumber, "Check")
 {
  LV_GetText(Ext, RowNumber, 1)
  Extensions .= Ext . ","
 }
 Gui, Hide
 Gui, 1:Default
 StringTrimRight, Extensions, Extensions, 1
 If Extensions = %CurrentExt%
    MBox(21, Type)
 Else
 {
  GuiControl, 1:, %Type%Extensions, %Extensions%
  GuiControlGet, Folder,  1:, Last%Type%Folder
  SetPreviewFile(Type, Folder)
 }
Return

5GuiClose:
3ButtonClose:
3GuiClose:
2ButtonClose:
 Gui, Hide
 Gui, 1:Default
 Gui, 1:Show, Restore
Return

;************************************* Prepare Name For Match **************************************

PrepName4Match(Text, Type, NoSpaces = 0)
{
; Gui, Submit, NoHide               ; this and
; GoSub, StringReplaceInit          ; this need to go before the line that calls this function.
 OutText =
 Loop, Parse, Text, `n
 {
  TempVar := DeleteBrackets(A_Loopfield, Type)
  TempVar := TrimChars(TempVar, Type)
  TempVar := Regex(TempVar)
  OutText .= StringReplacement(TempVar) "`n"
 }
 StringTrimRight, OutText, OutText, 1
 If NoSpaces = 1
    StringReplace, OutText, OutText, %A_Space%, %Null%, A
 Else OutText := RemoveSpaces(OutText)
 Return OutText
}

;************************************** Renaming Algorithms ****************************************

DeleteBrackets(Text, Type)
{
 Global
 Loop, Parse, BracketTypes, `,
 {
  If %Type%%A_LoopField%Bracket <> 0
  {
   Pos = 1
   BracketRegex = %A_LoopField%Regex
   Count = %Type%%A_LoopField%Bracket
   Limit := ABS(%Count%)
   If %Count% < 0
   {
    Loop, %Limit%
    {
     Pos := RegexMatch(Text, %BracketRegex%,"", Pos)
     If Pos = 0
        Break
     Pos++
    }
   }
   Text := RegexReplace(Text, %BracketRegex%, "", "", Limit, Pos)
   Text = %Text%
  }
 }
 Return Text
}


TrimChars(Text,Type)
{
 Global ArtTrimLeft, ArtTrimRight, RomTrimLeft, RomTrimRight
 TrimRight := Type . "TrimRight"
 TrimLeft := Type . "TrimLeft"
 StringTrimRight, Text, Text, % %TrimRight% + 0
 StringTrimLeft, Text, Text, % %TrimLeft% + 0
 Return Text
}

Regex(Text)
{
 Global Regex, ReplaceText
 If Regex <>
 {
  TempVar := RegexMatch(Text, "([\[\{\(].+?[]}\)])", BracketInfo)
  StringReplace, Text, Text, %BracketInfo1%, ¬
  StringSplit, Text, Text, ¬
  Text1 := RegexReplace(Text1, Regex, ReplaceText)
  Text = %Text1%%BracketInfo1%%Text2%
 }
 Return Text
}

StringReplacement(Text)
{
 Global ReplacementCount, SearchString, ReplaceString, ReplaceWholeWords, ReplaceAll, IllegalChars
 Loop, %ReplacementCount%
 {
  TempText := Text
  TempSearchString := SearchString%A_Index%
  TempReplaceString := ReplaceString%A_Index%
  If ReplaceWholeWords%A_Index%
  {
   TempText := A_Space . TempText . A_Space
   TempSearchString := A_Space . TempSearchString . A_Space
   TempReplaceString := A_Space . TempReplaceString . A_Space
  }
  StringReplace, Text, TempText, %TempSearchString%, %TempReplaceString%, % ReplaceAll%A_Index%
 }
 Loop, Parse, IllegalChars
    StringReplace, Text, Text, %A_loopfield%,, A
 Text = %Text%
 Return Text
}

;************************************** Remove Extra Spaces ****************************************

RemoveSpaces(Text)
{
 Loop
 {
  StringReplace, Text, Text, %A_Space%%A_Space%, %A_Space%, UseErrorLevel
  If ErrorLevel = 0
     Break
 }
 Return Text
}

;******************************* String Replacement LV Labels/Subs *********************************

StringReplaceInit:
 Gui, 1:ListView, ReplaceLV
 ReplacementCount = 0
 Loop % LV_GetCount()
 {
  ReplacementCount := A_Index
  LV_GetText(SearchString%A_Index%, A_Index, 1)
  LV_GetText(ReplaceString%A_Index%, A_Index, 2)
  LV_GetText(TempVar, A_Index, 3)
  ReplaceAll%A_Index% := TempVar=X ? 0 : 1
  LV_GetText(TempVar, A_Index, 4)
  ReplaceWholeWords%A_Index% := TempVar=X ? 0 : 1
 }
Return

AddSRL:
 Gui, 1:ListView, ReplaceLV
 LV_ADD()
 LV_Modify(LV_GetCount(),"Vis Focus Select")
 LV_mx := lv_lx +12
 LV_my := LV_ly + LV_lh - 12
 GoSub, DoubleClick
Return

RemoveSRL:
 Gui, 1:ListView, ReplaceLV
 RowNumber := LV_GetNext(0)
 IF RowNumber <> 0
 {
  LV_Delete(RowNumber)
  If (LV_GetCount()<18)
  {
   LV_ModifyCol(1, 162)
   LV_ModifyCol(2, 162)
  }
  Gosub, GuiPreview
 }
Return

ClearSRL:
 Gui, 1:ListView, ReplaceLV
 LV_Delete()
 LV_ModifyCol(1, 162)
 LV_ModifyCol(2, 162)
 Gosub, GuiPreview
Return

MoveUp:
PgUp:
 Gui, 1:ListView, ReplaceLV
 LV_MoveRow()
 Gosub, GuiPreview
Return

MoveDown:
PgDn:
 Gui, 1:ListView, ReplaceLV
 LV_MoveRow(false)
 Gosub, GuiPreview
Return

LV_MoveRow(moveup = true)
{
 Loop, % (allr := LV_GetCount("Selected"))
    max := LV_GetNext(max)
 Loop, %allr%
 {
  cur := LV_GetNext(cur)
  If ((cur = 1 && moveup) || (max = LV_GetCount() && !moveup))
     Return
  Loop, % (ccnt := LV_GetCount("Col"))
     LV_GetText(col_%A_Index%, cur, A_Index)
  LV_Delete(cur), cur := moveup ? cur-1 : cur+1
  LV_Insert(cur, "Select Focus", col_1)
  Loop, %ccnt%
     LV_Modify(cur, "Col" A_Index, col_%A_Index%), col_%A_Index% := ""
 }
}

LoadSRL:
 Gui, 1:ListView, ReplaceLV
 GuiControl, -Redraw, ReplaceLV
 LV_Delete()
 Loop, Parse, ReplaceLV, |
 {
  StringSplit, OutArray, A_LoopField, \
  If OutArray0
     LV_Add("", OutArray1, OutArray2, OutArray3, OutArray4)
 }
 If LV_GetCount()> 15
 {
  LV_ModifyCol(1, 153)
  LV_ModifyCol(2, 153)
 }
 GuiControl, +Redraw, ReplaceLV
Return

;****************************************** StartMatch ********************************************
;**************** OrigArtList (string)  Contains the list of items to be searched *****************
;**************************************************************************************************

StartMatch:
 Gui, Submit, NoHide
 If LastRomFolder =
    Gosub, GetRomFolder
 If LastRomFolder =
   Return
 If LastArtFolder =
    GoSub, GetArtFolder
 If LastArtFolder =
    Return
 Gui, 1:ListView, MatchLV
 If % LV_GetCount("Selected") = 0
 {
  MBox(22)
  Return
 }
 
 If (LastArtFolder <> PrevArtFolder) ; Shouldn't this IF include everything below it?
 {
  MatchedOnce = 0
  PrevArtFolder := LastArtFolder
  SB_SetText("   Initializing " LastArtFolder,2)
  OrigArtList =
  Loop, Parse, ArtExtensions, `,
  {
   Loop, %LastArtFolder%\*.%A_LoopField%
   {
    SplitPath, A_LoopFileName, Name,, Ext, NameNoExt
    OrigArtList .= NameNoExt . "`n"
   }
  }
  Sort, OrigArtList, U
  OrigArtList := "`n" OrigArtList
 }

 Gosub, StringReplaceInit
 MatchCount = 0
 StartTime := A_TickCount
 Gui, 1:ListView, MatchLV
 If MatchedOnce = 0
 {
  TempArtList := OrigArtList 
  PreppedArtList := PrepName4Match(TempArtList, "Art")
  PreppedArtList_NoSpace := PrepName4Match(TempArtList, "Art", 1)
  StringSplit, TempArtList, TempArtList, `n
  RowNumber = 0
  While RowNumber := LV_GetNext(RowNumber)    ; 100% Matches
  {
   LV_GetText(RomName, RowNumber)
   SB_SetText("   Searching for 100% Matches: " RomName, 2)
   IfInString TempArtList, `n%RomName%`n
   {
    MatchCount++
    LV_Modify(RowNumber, "Col2 -Select", RomName, "100%", MatchCount)
    If RemoveExact = 1
       StringReplace, OrigArtList, OrigArtList, `n%RomName%`n, `n
   }
  }
  While RowNumber := LV_GetNext(RowNumber)    ; 99.9% Matches
  {
   LV_GetText(RomName, RowNumber)
   SB_SetText("   Searching for 99.9% Matches: " RomName, 2)
   PreppedRom := PrepName4Match(RomName, "Rom")     
   Pos := InStr(PreppedArtList, "`n" PreppedRom "`n")
   If Pos > 0
   {
    MatchCount++
    TempVar := SubStr(PreppedArtList, 1, Pos)
    StringReplace, TempVar, TempVar, `n, `n, UseErrorLevel
    Index := ErrorLevel + 1
    TempVar := TempArtList%Index%
    LV_Modify(RowNumber, "Col2 -Select", TempVar, "99.9%", MatchCount)
    If Remove99 = 1
;    {
       StringReplace, OrigArtList, OrigArtList, % "`n" TempVar "`n", `n
;       StringReplace, PreppedArtList, PreppedArtList, % "`n" PreppedRom "`n", `n
;    }
   }
   Else
   {
    StringReplace, PreppedRom, PreppedRom, %A_Space%,,A
    Pos := InStr(PreppedArtList_NoSpace, "`n" PreppedRom "`n")  
    If Pos > 0
    {
     MatchCount++
     TempVar := SubStr(PreppedArtList_NoSpace, 1, Pos)
     StringReplace, TempVar, TempVar, `n, `n, UseErrorLevel
     Index := ErrorLevel + 1
     TempVar := TempArtList%Index%
     LV_Modify(RowNumber, "Col2 -Select", TempVar, "99.9%", MatchCount)
     If Remove99 = 1
;     {
      StringReplace, OrigArtList, OrigArtList, % "`n" TempVar "`n", `n
;      StringReplace, PreppedArtList_NoSpace, PreppedArtList_NoSpace, % "`n" PreppedRom "`n", `n
;      StringReplace, PreppedArtList, PreppedArtList, % "`n" PreppedRom "`n", `n
;     }
    }
   }
  }
  If Stop = 1
  {
   Stop = 0
   SoundPlay, *64
   SB_SetText("    Matching Stopped by User", 2)
   Return
  }
 }
 MatchedOnce = 1
 TempRomList =
 TempArtList =
 SB_SetText("   Preparing for Fuzzy Match...", 2)
 s_ItemList := PrepName4Match(OrigArtList, "Art")
 StringSplit, S_ItemList, S_ItemList, `n
 StringSplit, OrigArtList, OrigArtList, `n

  ;create array of Trigrams for each word in Search Items
 Loop, Parse, s_ItemList, `n
 {
  Index := A_Index
  s_ItemTrigrams%Index% =
  s_NumTrigrams%Index% = 
  StringReplace, TempItem, A_LoopField, %A_Space%,, All
  Trigrams := StrLen(TempItem) - 2
  Loop, %Trigrams%
  {
   s_NumTrigrams%Index%++
   s_ItemTrigrams%Index% .= SubStr(TempItem,A_Index, 3) . "`n"
  }
  StringTrimRight, s_ItemTrigrams%Index%, s_ItemTrigrams%Index%, 1
 }

 ;Begin Fuzzy Match
 RowNumber = 0
 While RowNumber := LV_GetNext(RowNumber)
 {
  LV_GetText(RomName, RowNumber)
  SB_SetText("   Fuzzy Matching: " RomName, 2)
  MatchCount++
  m_Length := StrLen(RomName)
  
 ;create List of Trigrams for Match Item
  m_NumTrigrams = 
  m_ItemTrigrams =
  StringReplace, TempItem, RomName, %A_Space%,, All
  Trigrams := StrLen(TempItem) - 2
  Loop, %Trigrams%
  {
   m_NumTrigrams++
   m_ItemTrigrams .= SubStr(TempItem,A_Index, 3) . "`n"
  }
  StringTrimRight, m_ItemTrigrams, m_ItemTrigrams, 1
  
  Loop, 7
  {
   BestIndex%A_Index% = 0
   BestFitness%A_Index% = 0
  }

  Loop, Parse, s_ItemList, `n ;Compare Match Item to Search List
  {
   If A_LoopField =
      Continue
   s_ItemIndex := A_Index
   SearchItem = %A_LoopField%
   s_Length := StrLen(SearchItem)
   
  ;Match #1 Instr() Match
   iLength := m_Length < s_Length ? m_Length : s_Length
   tLength := m_Length > s_Length ? m_Length : s_Length
   TempVar1 := SubStr(SearchItem,1,iLength)
   IfInstring, RomName, %TempVar1%
   {
    TempFitness := Round(iLength / tLength *100)
    If TempFitness > %BestFitness1%
    {
     BestIndex1 := s_ItemIndex
     BestFitness1 := TempFitness
    }
   }
  ;Match #2 Instr() Match
   TempVar1 := SubStr(RomName,1,iLength)
   IfInstring, SearchItem, %TempVar1%
   {
    TempFitness := Round(iLength / tLength *100)
    If TempFitness > %BestFitness2%
    {
     BestIndex2 := s_ItemIndex
     BestFitness2 := TempFitness
    }
   }

 ; Match #3 Greatest number of matching words.
   m_Fitness = 0
   m_WordCount = 0
   TempSearchItem := A_Space . SearchItem . A_Space
   Loop, Parse, RomName, %A_Space%
   {
    m_WordCount++
    LoopField := A_Space . A_LoopField . A_Space
    IfInString, TempSearchItem, %LoopField%
    {
     StringReplace, TempSearchItem, TempSearchItem, %LoopField%, %A_Space%
     m_Fitness++
    }
   }

   s_Fitness = 0
   s_WordCount = 0
   TempMatchItem := A_Space . RomName . A_Space
   Loop, Parse, SearchItem, %A_Space%
   {
    s_WordCount++
    LoopField := A_Space . A_LoopField . A_Space
    IfInString, TempMatchItem, %LoopField%
    {
     StringReplace, TempMatchItem, TempMatchItem, %LoopField%, %A_Space%
     s_Fitness++
    }
   }
   iWordCount := s_WordCount > m_WordCount ? s_WordCount : m_WordCount

   m_Fitness := Round(m_Fitness / iWordCount * 100)
   If m_Fitness > %BestFitness3%
   {   
    BestIndex3 := s_ItemIndex
    BestFitness3 := m_Fitness
   }
   s_Fitness := Round(s_Fitness / iWordCount * 100)
   If s_Fitness > %BestFitness6%
   {   
    BestIndex6 := s_ItemIndex
    BestFitness6 := s_Fitness
   }
 
 ; Match #4 Greatest number of matching TriGrams.
   TempFitness =
   sTrigrams := s_ItemTrigrams%A_Index%
   mTrigrams := m_ItemTrigrams
   If s_NumTrigrams%A_Index% > %m_NumTrigrams%
   {
    sTrigrams := m_ItemTrigrams 
    mTrigrams := s_ItemTrigrams%A_Index%
   }   
   Loop, Parse, mTrigrams, `n
   {
    IfInString, sTrigrams, %A_LoopField%
    {
     StringReplace, sTrigrams, sTrigrams, %A_LoopField%
     TempFitness++
    }
   }
   iTrigrams := m_NumTrigrams > s_NumTrigrams%s_ItemIndex% ? m_NumTrigrams : s_NumTrigrams%s_ItemIndex%
   TempFitness := Round(TempFitness / iTrigrams * 100)
   If TempFitness > %BestFitness4% 
   {
    BestIndex5 := BestIndex4
    BestFitness5 := BestFitness4
    BestIndex4 := s_ItemIndex
    BestFitness4 := TempFitness
   }
  }

; Sort out the best match and alternative matches for context menu
  AltMatch%MatchCount% = 
  Sort()
  Loop, 6
  {
   If BestFitness%A_Index% <> 0
   {
    IfNotInstring, AltMatch%MatchCount%, % BestIndex%A_Index% . "|"
      AltMatch%MatchCount% .= BestIndex%A_Index% . "|" . BestFitness%A_Index% . ","
    If BestFitness%A_Index% > %BestFitness7%
    {
     BestIndex7 := BestIndex%A_Index%
     BestFitness7 := BestFitness%A_Index%
    }
   }
  }
  StringTrimRight, AltMatch%MatchCount%, AltMatch%MatchCount%, 1
  
  i_MatchName := "NO MATCH FOUND"
  If BestFitness7 = 100
     BestFitness7 = 99.9
  If BestFitness7 <> 0
    i_MatchName := OrigArtList%BestIndex7%
  LV_Modify(RowNumber, "Col2 -Select", i_MatchName, BestFitness7 "%", MatchCount) 
  If Stop = 1
  {
   Stop = 0
   SoundPlay, *64
   SB_SetText("    Matching Stopped by User", 2)
   Return
  }
 }

 SoundPlay, *64
 ElapsedTime := (A_TickCount - StartTime)/1000
 dt = 20000101000000
 dt += ElapsedTime, seconds
 FormatTime, ElapsedTime, %dt%, H:mm:ss 
 SB_SetText("    Matched "  MatchCount " Items in " ElapsedTime " Seconds", 2)
Return

;********************************************** Sort ***********************************************

Sort()
{
 Global
 Loop, 5
 {
  Min := A_Index
  Max := A_Index +1
  While Max < 7
  {
   If (BestFitness%Min% < BestFitness%Max%)
      Min := Max
   Max++
  }
  Swap(BestFitness%A_Index%,BestFitness%Min%)
  Swap(BestIndex%A_Index%,BestIndex%Min%)
 }
}

Swap(ByRef Old, ByRef New)
{
 temp := Old
 Old := New
 New := temp
}

;********************************************* Rename **********************************************

Rename:
 Gui +OwnDialogs
 If (CurrentTab = "Match") AND (MatchedOnce = 1)
 {
  Gui, 1:ListView, MatchLV
  MatchCount = 0
  RowNumber = 0
  While RowNumber := LV_GetNext(RowNumber)
  {
   MatchCount++
   RowNumber%MatchCount% := RowNumber
  }
  If MatchCount = 0
  {
   MBox(23)
   Return
  }
  ControlGet, ArtFolderList, List,, Combobox1
  StringReplace, TempVar, ArtFolderList, ||, |, A
 ; StringTrimLeft, TempVar, TempVar, 1
  StringSplit, Folder, TempVar, |
  Loop, %Folder0%
  {
    IfNotExist, % Folder%A_Index% . "\Renamed"
    {
      FileCreateDir, % Folder%A_Index% . "\Renamed"
      If ErrorLevel <> 0 
         MBox(5, ErrorLevel)
    }
  }
  GuiControl, -Redraw, MatchLV
  GuiControlGet, MoveFiles
  GuiControlGet, ArtExtensions
  Loop %MatchCount%
  {
   ThisRow := MatchCount - A_Index +1
   LV_GetText(OldName, RowNumber%ThisRow%, 2)
   If OldName =
      Continue
   If DataFileType = SoftList
      LV_GetText(NewName, RowNumber%ThisRow%, 5)
   Else
      LV_GetText(NewName, RowNumber%ThisRow%, 1)
   SB_SetText(" Renaming: " OldName, 2)
   Loop, %Folder0%
   {
    Index := A_Index
    Loop, Parse, ArtExtensions, `,
    {
     If MoveFiles = 1
        FileMove,  % Folder%Index% "\" OldName "." A_LoopField, % Folder%Index% "\Renamed\" NewName "." A_LoopField
     Else 
        FileCopy,  % Folder%Index% "\" OldName "." A_LoopField, % Folder%Index% "\Renamed\" NewName "." A_LoopField
    }
   }
   StringReplace, OldName, OldName, `,, |, A
   MatchedRoms .= MatchedRoms = "" ? OldName : "," OldName
   LV_Delete(RowNumber%ThisRow%)
  }
  GuiControl, +Redraw, MatchLV
  SoundPlay, *64
  SB_SetText(" Renaming Completed.", 2)
 }
 If MatchedOnce = 0
    MBox(10)
Return

;***************************************** Clickable Link ******************************************

ClickLink()
{
 Global
 Process, Exist
 GuiPid := ErrorLevel
 WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %GuiPid%
; OnMessage(0x20, "HandleMessage")
; OnMessage(0x200, "HandleMessage")
}

Link1:
  Run, http://www.autohotkey.com/docs/misc/RegEx-QuickRef.htm,,, Pid
  WinWaitActive, Regular Expressions (RegEx) - Quick Reference
  WinWaitNotActive, Regular Expressions (RegEx) - Quick Reference
  WinActivate, AHK_Group GuiNum1
Return

HandleMessage(p_w, p_l, p_m, p_hw)
{
 global   WM_SETCURSOR, WM_MOUSEMOVE,
 static   URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl
 If (p_m = WM_SETCURSOR)
 {
   If URL_hover
     Return, true
 }
 Else If (p_m = WM_MOUSEMOVE)
 {
  ; Mouse cursor hovers URL text control
  StringLeft, CtrlIsURL, A_GuiControl, 3
  If (CtrlIsURL = "URL")
  {
   If URL_hover=
   {
     Gui, Font, cBlue underline
     GuiControl, Font, %A_GuiControl%
     LastCtrl = %A_GuiControl%
     h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)
     URL_hover := true
   }                 
   h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
  }
  ; Mouse cursor doesn't hover URL text control
  Else
  {
   If URL_hover
   {
    Gui, Font, norm cBlue
    GuiControl, Font, %LastCtrl%
    DllCall("SetCursor", "uint", h_old_cursor)
    URL_hover=
   }
  }
 }
}
;****************************************** Show Credits *******************************************

ShowCredits:
 Gui, +Disabled
 Gui, 12:Default
 Gui, Show, w500 h%WinH%, %ScriptName% Credits:
 Loop
 {
  YPos := 0  ; Bottom of GUI Window
  Loop
  {
     YPos--
     GuiControl 12:Move, CreditsGui, y%YPos%
     GuiControlGet CreditsGui, Pos
     If (CreditsGuiY + CreditsGuiH < WinH)
        Break
     Sleep 50

  }
 }
Return

#IfWinActive, RomData Magician Credits:
   Pause::Pause, Toggle, 1
#IfWinActive

12GuiClose:
 Gui, 1:Default
 Gui, -Disabled
 Gui, 12:Hide
Return

;********************************************** Exit ***********************************************

GuiClose:
ExitApp

ExitSub:
 IniSave()
ExitApp

IniSave()
{
 Global
 Gui, 1:Default
 Gui, Submit, Nohide
 GuiControlGet, ArtFolder,, LastArtFolder
 ControlGet, ArtFolderList, List,, Combobox1, ahk_group GuiNum1
 TempVar =
 Loop, Parse, ArtFolderList, `n
 {
  IfNotInString, TempVar, %A_LoopField%|
  TempVar .= A_LoopField = ArtFolder ? A_LoopField "||" : A_LoopField "|"
 }
 ArtFolderList := TempVar
 Gui, 1:ListView, ReplaceLV
 ReplaceLV =
 Loop % LV_GetCount()
 {
  LV_GetText(SearchString, A_Index, 1)
  If SearchString <>
  {
   LV_GetText(ReplaceString, A_Index, 2)
   LV_GetText(ReplaceAll, A_Index, 3)
   LV_GetText(ReplaceWholeWords, A_Index, 4)
   ReplaceLV .= SearchString "\" ReplaceString "\" ReplaceAll "\" ReplaceWholeWords "|"
  }
 }
 ArtFolderList := "|" ArtFolderList
 Loop, Parse, Keys, `,
 {
  LoopField := %A_LoopField%
  IniWrite, %LoopField%, %ScriptIni%, %LastProject%, %A_LoopField%
 }
 IniWrite, %LastProject%, %ScriptIni%, General, LastProject
 IniWrite, %HideMessages%, %ScriptIni%, General, HideMessages
 IniWrite, %MessageOption%, %ScriptIni%, General, MessageOption
 IniWrite, %MessageTips%, %ScriptIni%, General, MessageTips
}

;********************************** Control_Colors by DerRaphael ***********************************
;*************** http://www.autohotkey.com/community/viewtopic.php?p=208290#p208290 ****************

Control_Colors(Hwnd, Msg, wParam, lParam = 0)
{
   ;Critical

   If !(Hwnd+0) {
     GuiControlGet, nHwnd, Hwnd, %Hwnd%
     Hwnd := nhwnd
   }

   Static OldWinProc := ""          ; origin Windowprocedure
   Static NewWinProc := ""          ; new Windowprocedure
   Static SetValue := "Set"         ; take over Values
   Static Register := "RCB"         ; RegisterCallBack
   Static ValueList := ""           ; Values

   ; Aufruf als Fensterprozedur?
   If (A_EventInfo <> NewWinProc) {
      If (Msg = SetValue) {
         If (RegExMatch(ValueList, "m)^" . (Hwnd +0) . "\|")) {
            ValueList := RegExReplace(ValueList
                                     , "m)^" . (Hwnd + 0) . "\|.*$"
                                     , (Hwnd + 0) . "|"
                                     . (wParam + 0) . "|"
                                     . (lParam + 0))
         } Else {
            ValueList .= (Hwnd + 0) . "|"
                      .  (wParam + 0) . "|"
                      .  (lParam + 0) .  "`r`n"
         }
         Return
      }
      If (Msg = Register) {
         If (NewWinProc = "") {
            NewWinProc := RegisterCallback("Control_Colors","",4)
            OldWinProc := DllCall("SetWindowLong"
                                 , UInt, Hwnd
                                 , Int, -4
                                 , Int, NewWinProc
                                 , UInt)
         }
         Return
      }
      Return
   }
   ; 0x0133 : WM_CTLCOLOREDIT
   ; 0x0138 : WM_CTLCOLORSTATIC
   If (Msg = 0x0133 Or Msg = 0x0135 Or Msg = 0x0138) {
      If (RegExMatch(ValueList, "m)^"
                     . (lParam + 0) . "\|(?P<BG>\d+)\|(?P<TX>\d+)$"
                     , C)) {
         DllCall("SetTextColor", UInt, wParam, UInt, CTX)
         DllCall("SetBkColor", UInt, wParam, UInt, CBG)
         Return, DllCall("CreateSolidBrush", UInt, CBG)
      }
   }
   Return DllCall("CallWindowProcA"
                  , UInt, OldWinProc
                  , UInt, Hwnd
                  , UInt, Msg
                  , UInt, wParam
                  , UInt, lParam)
}

;********************************** CreateGradientBitmap By Skan ***********************************
;*************** http://www.autohotkey.com/community/viewtopic.php?p=425387#p425387 ****************

GDI_CreateGradientBitmap( G=3, C1="ABCDEF", C2="123456", W=256, H=256 ) {
 ; Thanks to HotkeyIt : www.autohotkey.com/forum/viewtopic.php?t=37376
 ; This post : www.autohotkey.com/forum/viewtopic.php?p=425387#425387
 D := ( G := G<1||G>5 ? 3:G ) < 3 ? 2 : 3,  SZ := D*D*4,  VarSetCapacity( B$,40+SZ,0 )
 ; Init BITMAPINFOHEADER ( 40 Bytes )
 NumPut(SZ,NumPut(0x180001,NumPut(D,NumPut(D,NumPut(40,B$))))+4), C1:="0x" C1, C2:="0x" C2
 ; Dynamic BITMAP Data
 _ := G=1 ? NumPut(C1,NumPut(C1,NumPut(C2,NumPut(C2,&B$+40)-1)+1)-1) : G=2 ? NumPut(C2
 ,NumPut(C1,NumPut(C2,NumPut(C1,&B$+40)-1)+1)-1) : G=3 ? NumPut(C2,NumPut(C2,NumPut(C2
 ,NumPut(C2,NumPut(C1,NumPut(C2,NumPut(C2,NumPut(C2,NumPut(C2,&B$+40)-1)-1)+2)-1)-1)+2)-1)
 -1):G=4 ? NumPut(C2,NumPut(C1,NumPut(C2,NumPut(C2,NumPut(C1,NumPut(C2,NumPut(C2,NumPut(C1
 ,NumPut(C2,&B$+40)-1)-1)+2)-1)-1)+2)-1)-1) :G=5 ? NumPut(C2,NumPut(C2,NumPut(C2,NumPut(C1
 ,NumPut(C1,NumPut(C1,NumPut(C2,NumPut(C2,NumPut(C2,&B$+40)-1)-1)+2)-1)-1)+2)-1)-1) : 0
 ; Obtain GDI Bitmap
 hBM := DllCall( "CreateDIBitmap", UInt, hDC := DllCall( "GetDC", UInt,cHwnd   ), UInt,&B$
      , Int,6, UInt,&B$+40, UInt,&B$, UInt,1 ), DllCall( "ReleaseDC", UInt,hDC )
 ; Obtain Resized GDI Bitmap / Obtain a copy with DIB section
 hBM := DllCall( "CopyImage", UInt,hBM, UInt,0, Int,W, Int,H, UInt,0x8, UInt )
 Return DllCall( "CopyImage", UInt,hBM, UInt,0, Int,0, Int,0, UInt,0x2000|0x8, UInt )
}

;******************************* Listview In-Cell Editing by Micahs ********************************
;************************ http://www.autohotkey.com/forum/topic19929.html **************************

InitCellEditing(LV_lvname, LV_g=1)	;name of control	;LV_g = gui number, default = 1
{
	global
	LVS_SINGLESEL = 0x4							;allow one item to be selected
	LVS_SHOWSELALWAYS = 0x8					;shows selection highlighting even if no focus
	LVS_EX_FULLROWSELECT = LV0x20			;whole row selection
	debounce=0

	LV_listOptions = 
		(Join`s LTrim
			+AltSubmit     
			NoSort
			-Checked
			+Grid
			+%LVS_EX_FULLROWSELECT%
			+%LVS_SHOWSELALWAYS%
			+%LVS_SINGLESEL%
			+glistClick
		)
		
	LV_dhw := A_DetectHiddenWindows	;save current state
	DetectHiddenWindows,On
;	Gui,%LV_g%:+LastFound
	Gui,%LV_g%:Default
;	LV_guiID := WinExist()	;get id for gui
	DetectHiddenWindows, %LV_dhw%	;restore original state
	GuiControl, %LV_g%:%LV_listOptions%, %LV_lvname%
;	ControlGet, LV_LView, Hwnd,, %LV_lvname%, ahk_id %LV_guiID%
;~ OutputDebug,%LV_lvname%   ID: %LV_LView%,	on %LV_guiID%
	SysGet,SM_CXVSCROLL,2			;get width of vertical scrollbar
	LVIR_LABEL = 0x0002				;LVM_GETSUBITEMRECT constant - get label info
	LVM_GETITEMCOUNT = 4100		;gets total number of rows
	LVM_SCROLL = 4116					;scrolls the listview
	LVM_GETTOPINDEX = 4135		;gets the first displayed row
	LVM_GETCOUNTPERPAGE = 4136	;gets number of displayed rows
	LVM_GETSUBITEMRECT = 4152	;gets cell width,height,x,y
	
	Gui, %LV_g%:Add, Edit, x0 y-50 vLV_CellEdit hwndLV_Edit	;make edit control
	Gui, %LV_g%:Add, Text, x0 y-50 vCellHighlight hwndLV_Highlight +Border +BackgroundTrans -Wrap	;make static control
	LV_LV := getClassNN(LV_LView)
	LV_ED := getClassNN(LV_Edit)
	LV_ST := getClassNN(LV_Highlight)
	ControlGetPos,LV_lx,LV_ly,LV_lw,LV_lh,%LV_LV%,ahk_id %LV_guiID%	;get info on listview
	GroupAdd,LV_editKeypress,ahk_id %LV_guiID%	;for ENTER, ESC, and ARROW key handling
	Hotkey, IfWinActive, ahk_group LV_editKeypress	;create hotkeys
		Hotkey,Enter	,EnterPressed
		Hotkey,Esc		,CommandPressed
	Hotkey, IfWinActive

	If(!LV_Getcount())
	{	
   LV_Add()
	}
	;SetTimer, IsScrolling, 350
Return	;end init
}
	listClick:
	 If (A_GuiEvent = "ColClick")
	 {
    GuiControl,1:Hide,%LV_ST%	;hide static control
		GuiControl,1:Hide,%LV_ED%	;hide edit control
	  If A_EventInfo > 2
	  {
     ColValue3 := ColValue3 = "X" ? "" : "X"
     ColValue4 := ColValue4 = "X" ? "" : "X"
     LV_Modify(0, "Col"A_EventInfo, ColValue%A_EventInfo%)
	  }
    Gosub, GuiPreview
	 }
		Else If(A_GuiEvent = "DoubleClick")
		{	
      CoordMode,MOUSE,RELATIVE
			MouseGetPos,LV_mx,LV_my	;,LV_oID,LV_oCNN
			Gosub doubleclick
		}
		Else If(A_GuiEvent = "Normal" and LV_EnableSingleClick)
		{	
      CoordMode,MOUSE,RELATIVE
			MouseGetPos,LV_mx,LV_my	;,LV_oID,LV_oCNN
			Gosub singleclick
		}
		Else If A_GuiEvent In D,d,e,S,s,RightClick	;hide edit on these events
		{	
      GuiControl,1:Hide,%LV_ST%	;hide static control
			GuiControl,1:Hide,%LV_ED%	;hide edit control
;			GuiControl,+Redraw,ReplaceLV
		}
		Else If(A_GuiEvent = "K")	;user started typing
		{	
     LV_tmp := RegExReplace(Chr(A_EventInfo),"\W","")
			If(LV_tmp)
			{	
        VarSetCapacity(LV_XYstruct, 16, 0)	;recreate struct		;get the cell info before edit show
				;InsertInteger(LVIR_LABEL	,LV_XYstruct,0)	;get label info constant
				;InsertInteger(LV_currCol	,LV_XYstruct,4)	;subitem index
				NumPut(LVIR_LABEL, LV_XYstruct, 0)	;get label info constant
				NumPut(LV_currCol, LV_XYstruct, 4)	;subitem index
				SendMessage,LVM_GETSUBITEMRECT,%LV_currRow%,&LV_XYstruct,%LV_LV%,ahk_id %LV_guiID%	;get cell coords
				LV_mx := ExtractInteger(LV_XYstruct,0,4) + LV_lx	;row upperleft x = itempos x + listview x
				LV_my := ExtractInteger(LV_XYstruct,4,4) + LV_ly	;row upperleft y = itempos y + listview y
				Gosub CellInfo
				LV_DispControl := LV_ED	;make edit1 the default control
				LV_spacer = 
				Gosub CellReSize
				GuiControl,+Redraw,ReplaceLV	;update the listview
				Gosub CellPosition
				GuiControl,Focus,%LV_DispControl%	;set focus	
				If !GetKeyState("Shift") or !GetKeyState("Shiftlock","T")
				{	
         StringLower,LV_tmp, LV_tmp
				}
				GuiControl,1:,%LV_DispControl%,%LV_tmp%	;set the text
				Send,{End}
			}
		}
	Return

	doubleclick:
	  Gosub, CellInfo
		GuiControl,1:Hide,%LV_ED%	;hide edit control
		GuiControl,1:Hide,%LV_ST%	;hide static control
		If(LV_currCol = 1) OR (LV_currCol = 2)	;if not column one
		{	
      LV_DispControl := LV_ED		;make edit1 the default control
			LV_spacer =
			Gosub CellReSize
			Gosub CellPosition
;			LV_Modify(LV_currRow, "Focus Select")
			GuiControl,1:Focus,%LV_DispControl%	;set focus
      LV_Modify(LV_currRow, "-Focus -Select")	

			Send,+{End}
			SetTimer,isEditFocused,75	;start edit focus monitor
		}
	Return

	singleclick:
		GuiControl,1:Hide,%LV_ED%	;hide edit control
		GuiControl,1:Hide,%LV_ST%	;hide edit control
		Gosub CellInfo
		If (LV_currCol = 3) OR (LV_currCol = 4)	;if not column one
		{
     LV_GetText(Option,LV_currRow,LV_currCol)
     Option := Option = "X" ? "" : "X"
     LV_Modify(LV_currRow,"Col"LV_currCol,Option)
     Gosub, GuiPreview
     LV_Modify(LV_currRow, "Focus Select")
    }
	Return

	;*************************cell size and position stuff******************************
	CellInfo:
		SendMessage,LVM_GETITEMCOUNT,0,0,%LV_LV%,ahk_id %LV_guiID%
		LV_TotalNumOfRows := ErrorLevel	;get total number of rows
		SendMessage,LVM_GETCOUNTPERPAGE,0,0,%LV_LV%,ahk_id %LV_guiID%
		LV_NumOfRows := ErrorLevel	;get number of displayed rows
		SendMessage,LVM_GETTOPINDEX,0,0,%LV_LV%,ahk_id %LV_guiID%
		LV_topIndex := ErrorLevel	;get first displayed row
		VarSetCapacity(LV_XYstruct, 16, 0)	;create struct
		Loop,%LV_NumOfRows%	;gets the current row, and cell Y,H
		{	
      LV_which := LV_topIndex + A_Index - 1	;loop through each displayed row
			NumPut(LVIR_LABEL	,LV_XYstruct,0)	;get label info constant
			NumPut(A_Index - 1	,LV_XYstruct,4)	;subitem index
			SendMessage,LVM_GETSUBITEMRECT,%LV_which%,&LV_XYstruct,%LV_LV%,ahk_id %LV_guiID%	;get cell coords
			LV_RowY  	:= ExtractInteger(LV_XYstruct,4,4) + LV_ly	;row upperleft y = itempos y + listview y
			LV_RowY2 	:= ExtractInteger(LV_XYstruct,12,4) + LV_ly	;row bottomright y2 = itempos y2 + listview y
			LV_currColHeight := LV_RowY2 - LV_RowY ;get cell height
			If(LV_my <= LV_RowY + LV_currColHeight)	;if mouse Y pos less than row pos + height
			{	
        LV_currRow 	:= LV_which +1	;1-based current row
				LV_currRow0	:= LV_which		;0-based current row
				Break
			}
		}
		
		VarSetCapacity(LV_XYstruct, 16, 0)	;create struct
		Loop % LV_GetCount("Col")	;gets the current column, and cell X,W
		{
			NumPut(LVIR_LABEL	,LV_XYstruct,0)	;get label info constant
			NumPut(A_Index - 1	,LV_XYstruct,4)	;subitem index
			SendMessage,LVM_GETSUBITEMRECT,%LV_currRow0%,&LV_XYstruct,%LV_LV%,ahk_id %LV_guiID%	;get cell coords
			LV_RowX 	:= ExtractInteger(LV_XYstruct,0,4) + LV_lx	;row upperleft x = itempos x + listview x
			LV_RowX2 	:= ExtractInteger(LV_XYstruct,8,4) + LV_lx	;row bottomright x2 = itempos x2 + listview x
			LV_currColWidth := LV_RowX2 - LV_RowX	;get cell width
			If(LV_mx <= LV_RowX + LV_currColWidth)	;if mouse X pos less than column pos+width
			{	
        LV_currCol := A_Index	;get current column number
				Break
			}
		}
	Return

	CellReSize:
		If(LV_RowX < LV_lx)	;make sure the cell is in view, then get the cell x coord again if it wasn't
		{	
      LV_hscrollVal := LV_RowX - LV_lx - 4 	;get the difference
			SendMessage,LVM_SCROLL,%LV_hscrollVal%,0,%LV_LV%,ahk_id %LV_guiID%	;scroll the column into view
			VarSetCapacity(LV_XYstruct, 16, 0)	;recreate struct
			NumPut(LVIR_LABEL	,LV_XYstruct,0)	;get just label coords
			NumPut(LV_currCol-1,LV_XYstruct,4)	;0-based subitem index
			SendMessage,LVM_GETSUBITEMRECT,%LV_currRow0%,&LV_XYstruct,%LV_LV%,ahk_id %LV_guiID%	;get cell coords
			LV_RowX := ExtractInteger(LV_XYstruct,0,4) + LV_lx	;row upperleft x = itempos x + listview x
		}
		LV_scrollWidth := LV_TotalNumOfRows > LV_NumOfRows ? SM_CXVSCROLL : 0	;0 if no vscroll, else = SM_CXVSCROLL
		If(LV_RowX+LV_currColWidth > LV_lx+LV_lw-LV_scrollWidth)	;if edit will be too wide, shrink it
		{	
     LV_currColWidth -= ((LV_RowX+LV_currColWidth) - (LV_lx+LV_lw-LV_scrollWidth)) + 3
		}
	Return

	CellPosition:
		LV_CellX_LV := LV_currCol									;get cell column
		LV_CellY_LV := LV_currRow								;get cell row
		LV_GetText(LV_coltxt,LV_CellY_LV,LV_CellX_LV)	;get the text
		LV_edW := LV_currColWidth								;get control width
		LV_edH := LV_currColHeight + 1							;get control height
		LV_edX := LV_RowX + 2									;get control x pos
		LV_edY := LV_RowY + 1									;get control y pos
		ControlMove,%LV_DispControl%,LV_edX,LV_edY,LV_edW,LV_edH	;move and size control
		If(LV_DispControl = LV_ED)
		{	
     GuiControl,1:,%LV_DispControl%,%LV_coltxt%	;set the text
		}
		GuiControl,1:Show,%LV_DispControl%					;show control
	Return

	CellHide:
		SetTimer,CellHide,Off	;just to let the hotkeys work - can't have hotkeys in a func
		GuiControl,1:Hide, %LV_ED%	;%LV_DispControl%
		LV_Modify(LV_currRow, "Focus Select")
	Return
	;*************************end cell size and position stuff******************************

	isEditFocused:
		GuiControlGet,LV_cFoc,Focus
		If(LV_cFoc != LV_DispControl)
		{	
      SetTimer,isEditFocused,Off
			Gosub CellHide
		}
	Return
	
	EnterPressed:	;called from hotkey "enter"
	  If CurrentTab = Match
	     Return
    Editing = 0  
		GuiControlGet,LV_fControl,Focus	;get control with focus
		If(LV_fControl = LV_DispControl)	;if Edit, save any changes
		{	
      Editing = 1
      Gui,Submit,NoHide
			LV_clickedRow := LV_topIndex + LV_currRow
			LV_CellX_save = Col%LV_CellX_LV%	;save edit contents
			LV_Modify(LV_CellY_LV,LV_CellX_save,LV_CellEdit)
			Gosub CellHide
			LV_fControl := LV_LV
			LV_xChange = 1	;set default values for enter key event
			LV_yChange = 0
		} 
     GoSub, GuiPreview
		
		If(LV_fControl = LV_LV)	;listview has focus - arrows or enter pressed
		{	
      LV_scrollChange = 0
			SendMessage,LVM_GETITEMCOUNT,0,0,%LV_LV%,ahk_id %LV_guiID%
			LV_TotalNumOfRows := ErrorLevel	;get total number of rows
			LV_TotalNumOfCols := LV_GetCount("Column")-1	;get total number of columns
			
			GuiControl,1:Hide,%LV_ST%	;hide static control to avoid artifacts
			
			LV_RowTmp := LV_currRow + LV_yChange < 1 ? 1 : LV_currRow + LV_yChange	;can't be less than one (up-down)
			LV_ColTmp := LV_currCol + LV_xChange < 1 ? 1 : LV_currCol + LV_xChange	;can't be less than two (left-right)

			LV_Modify(LV_RowTmp, "Focus Select")	;select new row
			VarSetCapacity(LV_XYstruct, 16, 0)	;recreate struct
			NumPut(LVIR_LABEL	,LV_XYstruct,0)	;get label info constant
			NumPut(LV_ColTmp	,LV_XYstruct,4)	;subitem index
			SendMessage,LVM_GETSUBITEMRECT,%LV_RowTmp%,&LV_XYstruct,%LV_LV%,ahk_id %LV_guiID%	;get cell coords
			LV_mx := ExtractInteger(LV_XYstruct,0,4) + LV_lx		;row upperleft x = itempos x + listview x
			LV_my := ExtractInteger(LV_XYstruct,4,4) + LV_ly	;row upperleft y = itempos y + listview y
			Gosub CellInfo
			
			;after all this must get cellinfo again if changed!
			If(LV_scrollChange)	;if listview scroll value changed, recalc cell pos
			{	
        VarSetCapacity(LV_XYstruct, 16, 0)	;recreate struct		;get the cell info again after any changes
				NumPut(LVIR_LABEL	,LV_XYstruct,0)	;get label info constant
				NumPut(LV_ColTmp	,LV_XYstruct,4)	;subitem index
				SendMessage,LVM_GETSUBITEMRECT,%LV_currRow%,&LV_XYstruct,%LV_LV%,ahk_id %LV_guiID%	;get cell coords
				LV_mx := ExtractInteger(LV_XYstruct,0,4) + LV_lx	;row upperleft x = itempos x + listview x
				LV_my := ExtractInteger(LV_XYstruct,4,4) + LV_ly	;row upperleft y = itempos y + listview y
				Gosub CellInfo
			}
      Keywait, Enter
			If(LV_currCol = 2)
			{
        LV_DispControl := LV_ED	;make edit1 the default control
				LV_spacer = %A_Space%
				Gosub CellReSize
				Gosub CellPosition
				GuiControl,Focus,%LV_DispControl%	
				LV_Modify(LV_currRow, "-Focus -Select")
				Send,+{End}
			  SetTimer,isEditFocused,75
			}
		}
	Return

	CommandPressed:
		If(A_ThisHotkey="Esc") AND (CurrentTab <> "Match")
		{	
      Gosub CellHide	;cancel
			GuiControl,1:Show,%LV_ST%
		}
	Return
	

getClassNN(kID,kTxt=0,g=1)	;kID = control Hwnd	;kTxt = control text, default=0	;g = gui number, default=1
{
	Gui,%g%:+LastFound
	guiID := WinExist()	;get the id for the gui
	If(kTxt) and (!kID)	;don't do this if the id is provided
	{	
    mm := A_TitleMatchMode
		SetTitleMatchMode,3	;exact match only
		ControlGet,o,hWnd,,%kTxt%,ahk_id %guiID%	;get the id
		SetTitleMatchMode,%mm%	;restore previous setting
		If(o)	;found match
		{	
     kID := o	;set sought-after id
		}
	}
	WinGet, controls, ControlList, ahk_id %guiID%
	Loop, Parse, controls, `n
	{	
    ControlGet,o,hWnd,,%A_LoopField%,ahk_id %guiID%	;get the id
		If(o = kID)	;found it
		{	
     Return A_Loopfield	;return the classnn
		}
	}
}

InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4)
; The caller must ensure that pDest has sufficient capacity.  To preserve any existing contents in pDest,
; only pSize number of bytes starting at pOffset are altered in it.
{
	Loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
	{	
    ;DllCall("RtlFillMemory", "UInt", &pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF)
		NumPut(pInteger, pDest + A_Index-1, pOffset, "UChar")
	}
}

ExtractInteger(ByRef pSource, pOffset = 0, pIsSigned = false, pSize = 4)
; pSource is a string (buffer) whose memory area contains a raw/binary integer at pOffset.
; The caller should pass true for pSigned to interpret the result as signed vs. unsigned.
; pSize is the size of PSource's integer in bytes (e.g. 4 bytes for a DWORD or Int).
; pSource must be ByRef to avoid corruption during the formal-to-actual copying process
; (since pSource might contain valid data beyond its first binary zero).
{
    Loop %pSize%  ; Build the integer by adding up its bytes.
        result += *(&pSource + pOffset + A_Index-1) << 8*(A_Index-1)
    if (!pIsSigned OR pSize > 4 OR result < 0x80000000)
        return result  ; Signed vs. unsigned doesn't matter in these cases.
    ; Otherwise, convert the value (now known to be 32-bit) to its signed counterpart:
    return -(0xFFFFFFFF - result + 1)
}


;***** Tooltip by Micahs - http://www.autohotkey.com/community/viewtopic.php?p=262187#p262187 ******

/*
	tooltipV2.ahk
	Version: 1.2
	By: Micahs
	
	CallWith: (You can use Hwnd, var, text, classnn)
	setTip("Button1", "This button does absolutely nothing.")   ;using the classnn
	setTip("Ok", "Begin the Process")   ;using the caption
	setTip("Cancel", "Cancel Whatever is Happening!")
	setTip(DDL, "Dropdownlist")   ;using the variable
	setTip(MYEdit, "The infamous edit control")   ;using the hwnd
*/

SetTip(tipControl, tipText, guiNum=1)   ;tipControl - text,variable,hwnd,classnn ;   tipText - text to display ;   gui number, default is 1
{
	global
	local List_ClassNN
	Gui,%guiNum%:Submit,NoHide
	Gui,%guiNum%:+LastFound
	WinGet, tipGui_guiID, ID
	WinGet, List_ClassNN, ControlList
	StringReplace, List_ClassNN, List_ClassNN, `n, `,, All
	IfInString, tipControl, %List_ClassNN%	;it is a classnn
	{	tipGui_ClassNN := tipControl   ;use it as is
	}
	Else	;must be text/var or ID
	{	tipGui_ClassNN := tipGui_getClassNN(tipControl, guiNum)   ;get the classnn
	}
	tipGui_%guiNum%_%tipGui_ClassNN% := tipText   ;set the tip   
	If(!tipGui_Init)	;enable tooltips when the first one is set, but only if TipsState has not been called (either to enable or disable)
	{	TipsState(1)
	}
}

TipsState(ShowToolTips)
{
	global tipGui_Init
	tipGui_Init = 1	;iniialize this latch
	If(ShowToolTips)
	{	OnMessage(0x200, "WM_MOUSEMOVE")   ;enable tips
	}
	Else
	{	OnMessage(0x200, "")   ;disable tips
	}
}

WM_MOUSEMOVE()
{
 global
 IfEqual, A_Gui,, Return
 MouseGetPos,,,tipGui_outW,tipGui_outC
 If(tipGui_outC != tipGui_OLDoutC)
 {	tipGui_OLDoutC := tipGui_outC
 	ToolTip,,,, 20
 	tipGui_counter := A_TickCount + 500
 	Loop
 	{	 MouseGetPos,,,, tipGui_newC
 		IfNotEqual, tipGui_outC, %tipGui_newC%, Return
 		tipGui_looper := A_TickCount
 		IfGreater, tipGui_looper, %tipGui_counter%, Break
 		Sleep, 50
 	}
 	Gui, %A_Gui%:+LastFound
 	tipGui_ID := WinExist()
 	SetTimer, tipGui_killTip, 500
 	tooltip, % tipGui_%A_Gui%_%tipGui_outC%,,, 20
 }
 Return

 tipGui_killTip:
 tipGui_killTipCounter++
 MouseGetPos,,, tipGui_outWm
 If(tipGui_outWm != tipGui_ID) or (tipGui_killTipCounter >= 8)	;(A_TimeIdle >= 4000)
 {	SetTimer, tipGui_killTip, Off
 	ToolTip,,,, 20
  TipActive = 0
 	tipGui_killTipCounter=0
 }
 Return
}

tipGui_getClassNN(tipControl, g=1)   ;tipControl = text/var,Hwnd	;g = gui number, default=1
{
	Gui,%g%:+LastFound
	guiID := WinExist()   ;get the id for the gui
	WinGet, List_controls, ControlList
	StringReplace, List_controls, List_controls, `n, `,, All
	;if id supplied do nothing special
	IfNotInString, tipControl, %List_controls%	;must be the text/var - get the ID
	{	mm := A_TitleMatchMode
		SetTitleMatchMode, 3   ;exact match only
		ControlGet, o, hWnd,, %tipControl%	;get the id
		SetTitleMatchMode, %mm%   ;restore previous setting
		If(o)   ;found match
		{	tipControl := o   ;set sought-after id
		}
	}
	Loop, Parse, List_controls, CSV
	{	ControlGet, o, hWnd,, %A_LoopField%   ;get the id of current classnn
		If(o = tipControl)   ;if it is the one we want
		{	Return A_Loopfield   ;return the classnn
		}
	}
}