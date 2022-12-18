#NoTrayIcon
#RequireAdmin
#AutoIt3Wrapper_icon=iicon.ico
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Res_LegalCopyright=mrHalfer
#AutoIt3Wrapper_Res_Description=The Witcher 3 Ultra Wide Fix
#AutoIt3Wrapper_Res_Comment=http://el-mods.ru
#AutoIt3Wrapper_Res_Field=ProductName|Ultra Wide Fix
#AutoIt3Wrapper_Res_Field=OriginalFilename|witcher3UWfix.exe
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Change2CUI=y

Dim $res = ["","2560x1080","3440x1440","3840x1600","5120x1440","5120x2160","6880x2880"]
Dim $ba = ["","26B41740","8EE31840","9A991940","398E6340","26B41740","8EE31840"]
If UBound($res) <> UBound($ba) Then
	myMessage("DEBUG: System Arrays are NOT the same length!")
	Exit
EndIf
For $i = 1 To UBound($ba) - 1
	$ckBA = StringSplit($ba[$i],"")
	If UBound($ckBA) <> 9 Then
		myMessage('DEBUG: Bad byte value: "'& $ba[$i] & '" (' & UBound($ckBA) - 1 & ')')
		Exit
	EndIf
Next

If Not FileExists(@ScriptDir & "\witcher3.exe") Then
	myMessage('ERROR: File "witcher3.exe" not found!' & @CRLF & 'Please put the patcher into "bin/x64" or "bin/x64_dx12" directory.')
	Exit
EndIf

$hFile = FileOpen(@ScriptDir & "\witcher3.exe",16)
$bFileContent = FileRead($hFile)
FileClose($hFile)

ConsoleWrite ("INFO: Checking file, please wait..." & @CRLF)
$ckOriginal = StringInStr($bFileContent,"398EE33F")
If $ckOriginal == 0 Then
	myMessage("ERROR: Exe file is not Original resolution or unsupported version.")
	Exit
EndIf

ConsoleWrite("OK: Exe file is Original resolution." & @CRLF)
$conText = "Input your resolution end press Enter:" & @CRLF
For $i = 1 To UBound($res) - 1
	$conText = $conText & "  " & $i & " - " & $res[$i] & @CRLF
Next
ConsoleWrite(@CRLF & $conText & @CRLF)

While 1
	Sleep(100)
	$var = StringReplace(ConsoleRead(), $conText, "")

	For $i = 1 To UBound($res) - 1
		If $var == $i & @CRLF Then
			patch($var)
		EndIf
	Next

	If StringRight($var, 1) == @CRLF Then
		$conText = $var
	EndIf
WEnd

Func patch($num)
	ConsoleWrite(@CRLF & "Creating a backup file..." & @CRLF)
	FileWrite(@ScriptDir & "\witcher3_BAK.exe", Binary($bFileContent))
	ConsoleWrite("Backup is " & @ScriptDir & "\witcher3_BAK.exe" & @CRLF & @CRLF)
	ConsoleWrite("Patching original file, please wait..." & @CRLF)
	$newFileContent = StringReplace($bFileContent, "398EE33F", $ba[$num])
	FileDelete(@ScriptDir & "\witcher3.exe")
	FileWrite(@ScriptDir & "\witcher3.exe", Binary($newFileContent))
	myMessage("OK: Patch has been applied for " & $res[$num])
	Exit
EndFunc

Func myMessage($text)
	ConsoleWrite($text)
	MsgBox(0,@ScriptName,$text)
EndFunc
