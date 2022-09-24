Attribute VB_Name = "MainModule"
Option Explicit

'Main Sub
Sub OnSlideShowPageChange()
    On Error GoTo ErrHandler
    
    Dim i As Integer
    Dim tag As String
    Dim subjectString As String
    
    i = ActivePresentation.SlideShowWindow.View.CurrentShowPosition
    subjectString = ActivePresentation.Slides(i).NotesPage.Shapes(2).TextFrame.TextRange.text
    tag = GetTransitionTag(subjectString)
    
    If tag <> "" Then
        Call PublishTag(tag)
    End If
    
    On Error GoTo 0
    Exit Sub
ErrHandler:
    Call LogError("OnSlideShowPageChange", Err, Error$) ' passes name of current routine '
End Sub

Sub PublishTag(tag As String)
    Dim myMSXML As Variant
    Dim URLPath As String
    
    On Error GoTo ErrHandler
    'Call Log("info", "PublishTag", 0, tag)
    
    Dim textJSON As String
    
    textJSON = "{""id"": 60,""category"": {""id"": 1,""name"": """ & tag & """},""name"": ""yolt"",""photoUrls"": [""https://en.wikipedia.org/wiki/Puppy#/media/File:Golde33443.jpg""],""tags"": [{""id"": 0,""name"": ""string""}],""status"": ""available""}"
    URLPath = "https://petstore.swagger.io/v2/pet"
    
    Set myMSXML = CreateObject("Microsoft.XmlHttp")
    myMSXML.Open "POST", URLPath, False
    myMSXML.setRequestHeader "Content-Type", "application/json"
    myMSXML.setRequestHeader "User-Agent", "Firefox 3.6.4"
    myMSXML.send textJSON
    'Call Log("info", "Publish", 0, myMSXML.responseText)
    Debug.Print myMSXML.responseText
    
    On Error GoTo 0
    Exit Sub
ErrHandler:
    Call LogError("PublishTag", Err, Error$) ' passes name of current routine '
End Sub

'Had to go to Tools > References and found `Microsoft VBScript Regular Expressions 5.5`
Function GetTransitionTag(subjectString As String) As String
    On Error GoTo ErrHandler
    Dim myRegExp As RegExp
    Dim myMatches As MatchCollection
    Dim myMatch As Match

    'Call Log("info", "GetTransitionTag", 1, subjectString)

    Set myRegExp = New RegExp
    myRegExp.IgnoreCase = True
    myRegExp.Global = True
    myRegExp.Multiline = True
    myRegExp.Pattern = "\[.*\]"
    
    Set myMatches = myRegExp.Execute(subjectString)
    
    If (myMatches.Count > 0) Then
        GetTransitionTag = myMatches.Item(0)
    End If
    
    On Error GoTo 0
    Exit Function
ErrHandler:
    Call LogError("GetTransitionTag", Err, Error$) ' passes name of current routine '
    
End Function



