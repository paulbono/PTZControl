Attribute VB_Name = "TestHarness"
Option Explicit

Sub testGetTransitionTag()
    'Arrange
    Dim testString As String
    Dim testResult As String
    testString = "some [words]" & vbCrLf & " [word] "

    
    
    'Act
    testResult = GetTransitionTag(testString)
    
    'Assert
    Debug.Assert testResult = "[words]"
    
    Debug.Assert "Test" = "Passed!"
End Sub
