Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "List Comparison Tool"
$form.Size = New-Object System.Drawing.Size(820, 650)
$form.StartPosition = "CenterScreen"

# Left Label TextBox
$leftLabelBox = New-Object System.Windows.Forms.TextBox
$leftLabelBox.Size = New-Object System.Drawing.Size(350, 20)
$leftLabelBox.Location = New-Object System.Drawing.Point(20, 10)
$leftLabelBox.Text = "Left List"

# Right Label TextBox
$rightLabelBox = New-Object System.Windows.Forms.TextBox
$rightLabelBox.Size = New-Object System.Drawing.Size(350, 20)
$rightLabelBox.Location = New-Object System.Drawing.Point(400, 10)
$rightLabelBox.Text = "Right List"

# Left List TextArea
$leftBox = New-Object System.Windows.Forms.TextBox
$leftBox.Multiline = $true
$leftBox.ScrollBars = "Vertical"
$leftBox.Size = New-Object System.Drawing.Size(350, 400)
$leftBox.Location = New-Object System.Drawing.Point(20, 40)

# Right List TextArea
$rightBox = New-Object System.Windows.Forms.TextBox
$rightBox.Multiline = $true
$rightBox.ScrollBars = "Vertical"
$rightBox.Size = New-Object System.Drawing.Size(350, 400)
$rightBox.Location = New-Object System.Drawing.Point(400, 40)

# Case Sensitive Checkbox
$caseCheckbox = New-Object System.Windows.Forms.CheckBox
$caseCheckbox.Text = "Case Sensitive"
$caseCheckbox.AutoSize = $true
$caseCheckbox.Location = New-Object System.Drawing.Point(20, 460)
$caseCheckbox.Checked = $false

# Compare Button
$compareButton = New-Object System.Windows.Forms.Button
$compareButton.Text = "Compare"
$compareButton.Size = New-Object System.Drawing.Size(100, 30)
$compareButton.Location = New-Object System.Drawing.Point(250, 460)

# Export Button
$exportButton = New-Object System.Windows.Forms.Button
$exportButton.Text = "Export CSV"
$exportButton.Size = New-Object System.Drawing.Size(100, 30)
$exportButton.Location = New-Object System.Drawing.Point(370, 460)
$exportButton.Enabled = $false

# Global comparison results
$global:comparisonResults = @()

# Compare Button logic
$compareButton.Add_Click({
    $labelA = if ($leftLabelBox.Text.Trim()) { $leftLabelBox.Text.Trim() } else { "Left List" }
    $labelB = if ($rightLabelBox.Text.Trim()) { $rightLabelBox.Text.Trim() } else { "Right List" }

    $listA = $leftBox.Lines | Where-Object { $_.Trim() -ne "" } | ForEach-Object { $_.Trim() }
    $listB = $rightBox.Lines | Where-Object { $_.Trim() -ne "" } | ForEach-Object { $_.Trim() }

    $caseSensitive = $caseCheckbox.Checked

    if (-not $caseSensitive) {
        $lookupA = $listA | ForEach-Object { $_.ToLowerInvariant() }
        $lookupB = $listB | ForEach-Object { $_.ToLowerInvariant() }
        $originalMap = @{}
        foreach ($item in $listA + $listB) {
            $key = $item.ToLowerInvariant()
            if (-not $originalMap.ContainsKey($key)) {
                $originalMap[$key] = $item
            }
        }

        $allItems = ($lookupA + $lookupB) | Sort-Object -Unique

        $comparisonResults = foreach ($item in $allItems) {
            [PSCustomObject]@{
                Value        = $originalMap[$item]
                ("In $labelA") = $lookupA -contains $item
                ("In $labelB") = $lookupB -contains $item
            }
        }
    } else {
        $allItems = ($listA + $listB) | Sort-Object -Unique

        $comparisonResults = foreach ($item in $allItems) {
            [PSCustomObject]@{
                Value        = $item
                ("In $labelA") = $listA -contains $item
                ("In $labelB") = $listB -contains $item
            }
        }
    }

    $global:comparisonResults = $comparisonResults
    $exportButton.Enabled = $true
    $comparisonResults | Out-GridView -Title "Comparison Results"
})

# Export Button logic
$exportButton.Add_Click({
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "CSV files (*.csv)|*.csv"
    $saveDialog.Title = "Save Comparison Results"

    if ($saveDialog.ShowDialog() -eq "OK") {
        $global:comparisonResults | Export-Csv -Path $saveDialog.FileName -NoTypeInformation
        [System.Windows.Forms.MessageBox]::Show("Exported to: $($saveDialog.FileName)", "Export Successful")
    }
})

# Add controls to the form
$form.Controls.AddRange(@(
    $leftLabelBox, $rightLabelBox,
    $leftBox, $rightBox,
    $caseCheckbox, $compareButton, $exportButton
))

# Show the form
[void]$form.ShowDialog()
