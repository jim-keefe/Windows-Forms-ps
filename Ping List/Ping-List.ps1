#  Load required .NET assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#  Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Ping List"
$form.Size = New-Object System.Drawing.Size(300, 410)
$form.StartPosition = "CenterScreen"

# Create label
$label = New-Object Windows.Forms.Label
$label.Text = "Enter targets (one per line):"
$label.Location = New-Object Drawing.Point(10, 10)
$label.AutoSize = $true
$form.Controls.Add($label)

#  Create a multiline TextBox for server input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.ScrollBars = "Vertical"
$textBox.Size = New-Object System.Drawing.Size(260, 270)
$textBox.Location = New-Object System.Drawing.Point(10, 30)
$textBox.Font = New-Object System.Drawing.Font("Consolas",10)

#  Create a Button to trigger the ping process
$button = New-Object System.Windows.Forms.Button
$button.Text = "Ping List"
$button.Location = New-Object System.Drawing.Point(10, 320)
$button.Size = New-Object System.Drawing.Size(100, 30)

# Create status label
$statusLabel = New-Object Windows.Forms.Label
$statusLabel.Text = "Status: Idle"
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object Drawing.Point(120, 320)
$form.Controls.Add($statusLabel)

#  Add controls to the form
$form.Controls.Add($textBox)
$form.Controls.Add($button)

# Define the button click event to perform the ping

# Button click event
$button.Add_Click({
    $statusLabel.Text = "Status: Running..."
    $form.Refresh()

    $servers = $textBox.Text -split "`r?`n" | Where-Object { $_.Trim() -ne "" }
    $results = @()

    foreach ($server in $servers) {
        $result = [pscustomobject]@{
            Server       = $server
            Status       = "Offline"
            ResponseTime = "N/A"
            Error = ""
        }

        try {
            $ping = Test-Connection -ComputerName $server -Count 1 -ErrorAction Stop
            if ($ping) {
                $result.Status = "Online"
                $result.ResponseTime = "$($ping.ResponseTime) ms"
            }
        } catch {
            # $result.Status = "Error"
            $result.Error = $_.Exception.Message
        }

        $results += $result
    }

    # Display in GridView
    $results | Out-GridView -Title "Ping List Output $((Get-date).DateTime)"
    $statusLabel.Text = "Status: Completed at $(Get-Date -Format 'HH:mm:ss')"

})

# Show form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()