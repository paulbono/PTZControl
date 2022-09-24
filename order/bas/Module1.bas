Attribute VB_Name = "Module1"
Sub OnSlideShowPageChange()
    Dim i As Integer
    Dim j As Integer
    Dim notes As String
    i = ActivePresentation.SlideShowWindow.View.CurrentShowPosition
    
    notes = ActivePresentation.Slides(i).NotesPage.Shapes(2).TextFrame.TextRange.Text
    '.Shapes(2).TextFrame.TextRange.Text
    MsgBox notes
    
    'j = ActivePresentation.SlideShowWindow.
    
    'i = ActivePresentation.NotesMaster.
        
    ' If i > j Then MsgBox "Insert your code here"
End Sub
