Sub CompareColumns()
    Dim ws1 As Worksheet, ws2 As Worksheet, wsResult As Worksheet
    Dim col1 As Range, col2 As Range
    Dim cell As Range
    Dim outputRowA As Integer, outputRowB As Integer, outputRowC As Integer
    Dim dict1 As Object, dict2 As Object
 
    ' Set references to the sheets (Modify these sheet names if needed)
    Set ws1 = ThisWorkbook.Sheets("Sheet1")  ' First sheet
    Set ws2 = ThisWorkbook.Sheets("Sheet2")  ' Second sheet
 
    ' Set the columns to compare (Change "A" if another column is used)
    Set col1 = ws1.Range("A1:A" & ws1.Cells(ws1.Rows.Count, 1).End(xlUp).Row)
    Set col2 = ws2.Range("A1:A" & ws2.Cells(ws2.Rows.Count, 1).End(xlUp).Row)
 
    ' Create dictionaries to store values for faster lookup
    Set dict1 = CreateObject("Scripting.Dictionary")
    Set dict2 = CreateObject("Scripting.Dictionary")
 
    ' Read values from Sheet1 into dict1
    For Each cell In col1
        If Not IsEmpty(cell.Value) Then dict1(cell.Value) = True
    Next cell
 
    ' Read values from Sheet2 into dict2
    For Each cell In col2
        If Not IsEmpty(cell.Value) Then dict2(cell.Value) = True
    Next cell
 
    ' Create or clear the output sheet
    On Error Resume Next
    Application.DisplayAlerts = False
    Sheets("ComparisonResults").Delete
    Application.DisplayAlerts = True
    On Error GoTo 0
    Set wsResult = ThisWorkbook.Sheets.Add
    wsResult.Name = "ComparisonResults"
 
    ' Set headers
    wsResult.Cells(1, 1).Value = "Common Values"
    wsResult.Cells(1, 2).Value = "Not Contained in Sheet1"
    wsResult.Cells(1, 3).Value = "Not Contained in Sheet2"
 
    ' Initialize output row counters
    outputRowA = 2
    outputRowB = 2
    outputRowC = 2
 
    ' Compare values and classify them
    For Each cell In col1
        If Not IsEmpty(cell.Value) Then
            If dict2.exists(cell.Value) Then
                wsResult.Cells(outputRowA, 1).Value = cell.Value  ' Common values
                outputRowA = outputRowA + 1
            Else
                wsResult.Cells(outputRowB, 2).Value = cell.Value  ' Not in File2
                outputRowB = outputRowB + 1
            End If
        End If
    Next cell
 
    For Each cell In col2
        If Not IsEmpty(cell.Value) And Not dict1.exists(cell.Value) Then
            wsResult.Cells(outputRowC, 3).Value = cell.Value  ' Not in File1
            outputRowC = outputRowC + 1
        End If
    Next cell
 
    ' Auto-fit columns
    wsResult.Columns("A:C").AutoFit
 
    MsgBox "Comparison completed! Results saved in the 'ComparisonResults' sheet.", vbInformation
End Sub
