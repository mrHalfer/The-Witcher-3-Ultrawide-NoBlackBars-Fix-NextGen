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
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_ProductVersion=1.1.0.0
#AutoIt3Wrapper_Change2CUI=y

$Width = 0
$Height = 0
$CustomPatch = False
Dim $res = ["Custom",   "2560x1080 (21:9)", "3440x1440 (21:9)", "3840x1200 (32:10)", "3840x1600 (21:9)", "5120x1440 (32:9)", "5120x2160 (21:9)", "6880x2880 (21:9)"]
Dim $ba =  ["398EE33F", "26B41740",         "8EE31840",         "CDCC4C40",          "9A991940",         "398E6340",         "26B41740",         "8EE31840"        ]
$ByteOr = $ba[0]

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
$ckOriginal = StringInStr($bFileContent,$ByteOr)
If $ckOriginal == 0 Then
	myMessage("ERROR: Exe file is not Original resolution or unsupported version.")
	Exit
EndIf

ConsoleWrite("OK: Exe file is Original resolution." & @CRLF)
$conText = "Input your resolution end press Enter:" & @CRLF
For $i = 0 To UBound($res) - 1
	$conText = $conText & "  " & $i & " - " & $res[$i] & @CRLF
Next
ConsoleWrite(@CRLF & $conText & @CRLF)

While 1
	Sleep(100)
	$var = StringReplace(ConsoleRead(), $conText, "")
	ToolTip($var)

	If $CustomPatch == False Then
		If $var == "0" & @CRLF Then
			$CustomPatch = True
			ConsoleWrite(@CRLF & "Enter the Horizontal resolution your monitor (Width):" & @CRLF)
		EndIf

		For $i = 1 To UBound($res) - 1
			If $var == $i & @CRLF Then
				patch($var)
			EndIf
		Next
	Else
		If Int($var) <> 0 Then
			If $Width == 0 Then
				$Width = Int($var)
				ConsoleWrite(@CRLF & "Enter the Vertical resolution your monitor (Height):" & @CRLF)
			Else
				$Height = Int($var)
				customPatch($Width, $Height)
			EndIf
		ElseIf $var <> "" Then
			MsgBox(0,"",$var)
			ConsoleWrite("WARNING: Numeric value required!" & @CRLF)
		EndIf
	EndIf

	If StringRight($var, 1) == @CRLF Then
		$conText = $conText & $var
	EndIf
WEnd

Func patch($num)
	ToolTip("")
	ConsoleWrite(@CRLF & "Creating a backup file..." & @CRLF)
	FileDelete(@ScriptDir & "\witcher3_BAK.exe")
	FileWrite(@ScriptDir & "\witcher3_BAK.exe", Binary($bFileContent))
	ConsoleWrite("Backup is " & @ScriptDir & "\witcher3_BAK.exe" & @CRLF & @CRLF)
	ConsoleWrite("Patching original file, please wait..." & @CRLF)
	$newFileContent = StringReplace($bFileContent, $ByteOr, $ba[$num])
	FileDelete(@ScriptDir & "\witcher3.exe")
	FileWrite(@ScriptDir & "\witcher3.exe", Binary($newFileContent))
	myMessage("OK: Patch has been applied for " & $res[$num])
	Exit
EndFunc

Func customPatch($width, $height)
	$byte = ""
	$ratio = _FloatToHex($width / $height)
	For $i = 2 To 8 Step 2
		$byte = $byte & StringLeft(StringRight($ratio,$i),2)
	Next
	$ba[0] = $byte
	$res[0] = $width & "x" & $height & " (Custom " & $byte & ")"
	patch(0)
EndFunc

Func _FloatToHex ( $floatval )
    $sF = DllStructCreate("float")
    $sB = DllStructCreate("ptr", DllStructGetPtr($sF))
    If $floatval = "" Then Exit
    DllStructSetData($sF, 1, $floatval)
    $return=DllStructGetData($sB, 1)
    Return $return
EndFunc

Func myMessage($text)
	ConsoleWrite($text)
	MsgBox(0,@ScriptName,$text)
EndFunc
