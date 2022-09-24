Attribute VB_Name = "Logging"
Option Explicit

' General routine for logging errors '
Sub LogError(ProcName$, ErrNum&, ErrorMsg$)
    Call Log("Error", ProcName, ErrNum, ErrorMsg)
End Sub

Sub Log(Level$, ProcName$, ErrNum&, ErrorMsg$)
  On Error GoTo ErrHandler
  Dim nUnit As Integer
  nUnit = FreeFile
  ' This assumes write access to the directory containing the program '
  ' You will need to choose another directory if this is not possible '
  
  Open "C:\Temp\" & "Powerpoint_" & ActivePresentation.Name & ".log" For Append As nUnit
  Print #nUnit, Level & " in " & ProcName
  Print #nUnit, "  " & ErrNum & ", " & ErrorMsg
  Print #nUnit, "  " & Format$(Now)
  Print #nUnit, "  "
  Close nUnit
  Exit Sub

ErrHandler:
  'Failed to write log for some reason.'
  'Show MsgBox so error does not go unreported '
  MsgBox "Error in " & ProcName & vbNewLine & _
    ErrNum & ", " & ErrorMsg
End Sub ' General routine for logging errors '

