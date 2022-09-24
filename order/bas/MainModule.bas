Attribute VB_Name = "MainModule"
Option Explicit

'Main Sub
Sub OnSlideShowPageChange()
    On Error GoTo ErrHandler
    
    Dim i As Integer
    Dim notes As String
    Dim subjectString As String
    i = ActivePresentation.SlideShowWindow.View.CurrentShowPosition
    subjectString = ActivePresentation.Slides(slideId).NotesPage.Shapes(2).TextFrame.TextRange.text

    'Call Log("info", "OnSlideShowPageChange", 0, "test " & i)

    notes = GetTransitionTag(subjectString)
    
    If notes <> "" Then
        Proc2 notes
    End If
    
    On Error GoTo 0
    Exit Sub
ErrHandler:
    Call LogError("OnSlideShowPageChange", Err, Error$) ' passes name of current routine '
End Sub

Sub Proc2(text As String)
    MsgBox text
    'Debug.Print "Hello " & text
End Sub

'Had to go to Tools > References and found `Microsoft VBScript Regular Expressions 5.5`
Function GetTransitionTag(subjectString As String) As String
    Dim myRegExp As RegExp
    Dim myMatches As MatchCollection
    Dim myMatch As Match

    Call Log("info", "GetTransitionTag", 1, subjectString)

    Set myRegExp = New RegExp
    myRegExp.IgnoreCase = True
    myRegExp.Global = True
    myRegExp.Multiline = True
    myRegExp.Pattern = "\[.*\]"
    
    Set myMatches = myRegExp.Execute(subjectString)
    
    If (myMatches.Count > 0) Then
        GetTransitionTag = myMatches.Item(0)
    End If
    
    
End Function


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

