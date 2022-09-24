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
    
    'If you got to this line, the test passed!
    Debug.Print "testGetTransitionTag: Passed."
End Sub
