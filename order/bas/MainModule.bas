Attribute VB_Name = "Module1"
Sub OnSlideShowPageChange()
    On Error GoTo ErrHandler
    
    Dim i As Integer
    Dim j As Integer
    Dim notes As String
    i = ActivePresentation.SlideShowWindow.View.CurrentShowPosition
    
    notes = ActivePresentation.Slides(i).NotesPage.Shapes(2).TextFrame.TextRange.text
    
    Proc2 notes
    On Error GoTo 0
    Exit Sub
ErrHandler:
    Call LogError("OnSlideShowPageChange", Err, Error$) ' passes name of current routine '
End Sub

Sub Proc2(text As String)
    MsgBox text
    'Debug.Print "Hello " & text
End Sub

' General routine for logging errors '
Sub LogError(ProcName$, ErrNum&, ErrorMsg$)
  On Error GoTo ErrHandler
  Dim nUnit As Integer
  nUnit = FreeFile
  ' This assumes write access to the directory containing the program '
  ' You will need to choose another directory if this is not possible '
  
  Open "C:\Temp\" & "Powerpoint_" & ActivePresentation.Name & ".log" For Append As nUnit
  Print #nUnit, "Error in " & ProcName
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
End Sub

