Attribute VB_Name = "Module1"
Sub OnSlideShowPageChange()
    Dim i As Integer
    Dim j As Integer
    i = ActivePresentation.SlideShowWindow.View.CurrentShowPosition
    j = ActivePresentation.SlideShowWindow.
    If i > j Then MsgBox "Insert your code here"
End Sub
