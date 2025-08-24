<#
WinForms Mega Demo in PowerShell
- Shows many common Windows Forms controls
- Organized into tabs; each tab focuses on a group of controls
- Everything is self-contained (no external files)
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

function New-Label($text, $x, $y, $w=120, $h=24){
    $lbl = New-Object Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Location = New-Object Drawing.Point($x,$y)
    $lbl.AutoSize = $true
    $lbl.BackColor = [System.Drawing.Color]::Transparent
    return $lbl
}
function New-Button($text, $x, $y, $w=120, $h=30){ $btn = New-Object Windows.Forms.Button; $btn.Text=$text; $btn.Location=New-Object Drawing.Point($x,$y); $btn.Size=New-Object Drawing.Size($w,$h); return $btn }
function New-Textbox($text, $x, $y, $w=160, $h=24){ $tb=New-Object Windows.Forms.TextBox; $tb.Text=$text; $tb.Location=New-Object Drawing.Point($x,$y); $tb.Size=New-Object Drawing.Size($w,$h); return $tb }
function New-GroupBox($text, $x, $y, $w, $h){ $g=New-Object Windows.Forms.GroupBox; $g.Text=$text; $g.Location=New-Object Drawing.Point($x,$y); $g.Size=New-Object Drawing.Size($w,$h); return $g }
function New-Panel($x,$y,$w,$h){ $p=New-Object Windows.Forms.Panel; $p.Location=New-Object Drawing.Point($x,$y); $p.Size=New-Object Drawing.Size($w,$h); return $p }

# --- Form --------------------------------------------------------------------
$form = New-Object Windows.Forms.Form
$form.Text = "WinForms Mega Demo (PowerShell)"
$form.StartPosition = 'CenterScreen'
$form.Size = New-Object Drawing.Size(1100, 720)
$form.MinimumSize = New-Object Drawing.Size(900,600)
$form.BackColor = [System.Drawing.Color]::LightGray

# MenuStrip -------------------------------------------------------------------
$menu = New-Object Windows.Forms.MenuStrip
$fileMenu = New-Object Windows.Forms.ToolStripMenuItem('File')
$miOpen = New-Object Windows.Forms.ToolStripMenuItem('Open...')
$miSave = New-Object Windows.Forms.ToolStripMenuItem('Save As...')
$miExit = New-Object Windows.Forms.ToolStripMenuItem('Exit')
$fileMenu.DropDownItems.AddRange(@($miOpen,$miSave,(New-Object Windows.Forms.ToolStripSeparator),$miExit))

$viewMenu = New-Object Windows.Forms.ToolStripMenuItem('View')
$miToggleStatus = New-Object Windows.Forms.ToolStripMenuItem('Toggle Status Bar')
$miToggleStatus.Checked=$true; $viewMenu.DropDownItems.Add($miToggleStatus)

$helpMenu = New-Object Windows.Forms.ToolStripMenuItem('Help')
$miAbout = New-Object Windows.Forms.ToolStripMenuItem('About')
$helpMenu.DropDownItems.Add($miAbout)

$menu.Items.AddRange(@($fileMenu,$viewMenu,$helpMenu))
$form.MainMenuStrip=$menu
$form.Controls.Add($menu)

# StatusStrip -----------------------------------------------------------------
$status=New-Object Windows.Forms.StatusStrip
$sbReady=New-Object Windows.Forms.ToolStripStatusLabel('Ready')
$sbSpring=New-Object Windows.Forms.ToolStripStatusLabel; $sbSpring.Spring=$true
$sbTime=New-Object Windows.Forms.ToolStripStatusLabel
$status.Items.AddRange(@($sbReady,$sbSpring,$sbTime))
$form.Controls.Add($status)

# ToolTip ---------------------------------------------------------------------
$toolTip = New-Object Windows.Forms.ToolTip
$toolTip.IsBalloon = $true
$toolTip.AutoPopDelay = 8000
$toolTip.InitialDelay = 400
$toolTip.ReshowDelay  = 100
$toolTip.ShowAlways   = $true

# TabControl ------------------------------------------------------------------
$tabs=New-Object Windows.Forms.TabControl; $tabs.Dock='Fill'; $tabs.Padding=New-Object Drawing.Point(12,4)
$form.Controls.Add($tabs); $tabs.BringToFront()

# ===================== Tab 1: Inputs ========================================
$tabInputs=New-Object Windows.Forms.TabPage; $tabInputs.Text='Inputs'; $tabInputs.BackColor=[System.Drawing.Color]::LightGray; $tabs.TabPages.Add($tabInputs)
$lblName=New-Label 'Name:' 20 24; $txtName=New-Textbox '' 100 20 200
$toolTip.SetToolTip($lblName,'Type your name'); $toolTip.SetToolTip($txtName,'Type your name')
$lblRole=New-Label 'Role:' 20 60; $cmbRole=New-Object Windows.Forms.ComboBox; $cmbRole.Location=New-Object Drawing.Point(100,56); $cmbRole.Size=New-Object Drawing.Size(200,24); $cmbRole.DropDownStyle='DropDownList'; [void]$cmbRole.Items.AddRange(@('Administrator','Engineer','Analyst','Guest')); $cmbRole.SelectedIndex=1
$toolTip.SetToolTip($lblRole,'Choose your role'); $toolTip.SetToolTip($cmbRole,'Choose your role')
$lblBio=New-Label 'Bio:' 20 96; $txtBio=New-Object Windows.Forms.RichTextBox; $txtBio.Location=New-Object Drawing.Point(100,96); $txtBio.Size=New-Object Drawing.Size(320,120); $txtBio.Text="This RichTextBox supports formatting (Ctrl+B/I/U)."
$toolTip.SetToolTip($lblBio,'Short self description'); $toolTip.SetToolTip($txtBio,'Short self description')
# Options
$gbOptions=New-GroupBox 'Options' 450 20 400 140
$chk1=New-Object Windows.Forms.CheckBox; $chk1.Text='Enable feature X'; $chk1.Location=New-Object Drawing.Point(16,28); $chk1.AutoSize=$false; $chk1.Width=220; $toolTip.SetToolTip($chk1,'Toggle feature X')
$chk2=New-Object Windows.Forms.CheckBox; $chk2.Text='Enable feature Y'; $chk2.Checked=$true; $chk2.Location=New-Object Drawing.Point(16,56); $chk2.AutoSize=$false; $chk2.Width=220; $toolTip.SetToolTip($chk2,'Toggle feature Y')
$rb1=New-Object Windows.Forms.RadioButton; $rb1.Text='Mode A'; $rb1.Location=New-Object Drawing.Point(16,84); $rb1.AutoSize=$true; $toolTip.SetToolTip($rb1,'Use mode A')
$rb2=New-Object Windows.Forms.RadioButton; $rb2.Text='Mode B'; $rb2.Checked=$true; $rb2.Location=New-Object Drawing.Point(120,84); $rb2.AutoSize=$true; $toolTip.SetToolTip($rb2,'Use mode B')
$gbOptions.Controls.AddRange(@($chk1,$chk2,$rb1,$rb2))
$btnHello=New-Button 'Say Hello' 100 230 120 32; $toolTip.SetToolTip($btnHello,'Compose greeting')
$btnClear=New-Button 'Clear' 230 230 80 32;  $toolTip.SetToolTip($btnClear,'Clear inputs')
$lblOutput=New-Object Windows.Forms.Label; $lblOutput.AutoSize=$true; $lblOutput.Location=New-Object Drawing.Point(20,280); $lblOutput.Font=New-Object Drawing.Font('Segoe UI',10,[Drawing.FontStyle]::Bold)
$tabInputs.Controls.AddRange(@($lblName,$txtName,$lblRole,$cmbRole,$lblBio,$txtBio,$gbOptions,$btnHello,$btnClear,$lblOutput))
$btnHello.Add_Click({ $mode=if($rb1.Checked){'A'}else{'B'}; $flags=@(); if($chk1.Checked){$flags+='X'}; if($chk2.Checked){$flags+='Y'}; $lblOutput.Text="Hello $($txtName.Text)! Role: $($cmbRole.Text). Mode: $mode. Flags: $([string]::Join(',', $flags))"; $sbReady.Text='Greeted user.'})
$btnClear.Add_Click({$txtName.Clear(); $txtBio.Clear(); $lblOutput.Text=''})

# ===================== Tab 2: Lists & Trees =================================
$tabLists=New-Object Windows.Forms.TabPage; $tabLists.Text='Lists & Trees'; $tabLists.BackColor=[System.Drawing.Color]::LightGray; $tabs.TabPages.Add($tabLists)
$split=New-Object Windows.Forms.SplitContainer; $split.Dock='Fill'; $split.SplitterDistance=300; $tabLists.Controls.Add($split)
# Left: TreeView
$tree=New-Object Windows.Forms.TreeView; $tree.Dock='Fill'; $toolTip.SetToolTip($tree,'Browse groups and items')
$nodeRoot=$tree.Nodes.Add('Root'); 1..3|%{ $child=$nodeRoot.Nodes.Add("Group $_"); 1..4|%{[void]$child.Nodes.Add("Item $_")} } ; $split.Panel1.Controls.Add($tree)
# Right: ListView + CheckedListBox
$lv=New-Object Windows.Forms.ListView; $lv.View='Details'; $lv.FullRowSelect=$true; $lv.Dock='Top'; $lv.Height=260; [void]$lv.Columns.Add('Name',160); [void]$lv.Columns.Add('Type',80); [void]$lv.Columns.Add('Size',80); 1..8|%{ $item=New-Object Windows.Forms.ListViewItem("File$_.txt"); [void]$item.SubItems.Add('Text'); [void]$item.SubItems.Add("$($_*10) KB"); [void]$lv.Items.Add($item) }
$toolTip.SetToolTip($lv,'Right-click for context options')
$clb=New-Object Windows.Forms.CheckedListBox; $clb.Dock='Fill'; [void]$clb.Items.AddRange(@('Alpha','Bravo','Charlie','Delta','Echo')); $clb.CheckOnClick=$true; $toolTip.SetToolTip($clb,'Check items to select')
$cms=New-Object Windows.Forms.ContextMenuStrip; $cms.Items.Add('Select All').Add_Click({foreach($i in 0..($lv.Items.Count-1)){$lv.Items[$i].Selected=$true}})|Out-Null; $cms.Items.Add('Invert Selection').Add_Click({foreach($it in $lv.Items){$it.Selected=-not $it.Selected}})|Out-Null; $lv.ContextMenuStrip=$cms
$split.Panel2.Controls.Add($clb); $split.Panel2.Controls.Add($lv)
$tree.Add_AfterSelect({ $sel=$tree.SelectedNode; if($sel -and $sel.Level -eq 1){ $lv.Items.Clear(); 1..5|%{ $it=New-Object Windows.Forms.ListViewItem("$($sel.Text)-$_"); [void]$it.SubItems.Add('Generated'); [void]$it.SubItems.Add("$($_*5) KB"); [void]$lv.Items.Add($it) } } })

# ===================== Tab 3: Data & Dates ==================================
$tabData=New-Object Windows.Forms.TabPage; $tabData.Text='Data & Dates'; $tabData.BackColor=[System.Drawing.Color]::LightGray; $tabs.TabPages.Add($tabData)
$grid=New-Object Windows.Forms.DataGridView; $grid.Dock='Top'; $grid.Height=250; $grid.AllowUserToAddRows=$false; $grid.AutoSizeColumnsMode='Fill'; $toolTip.SetToolTip($grid,'Editable data grid (double-click cells)')
$table=New-Object System.Data.DataTable 'Demo'; [void]$table.Columns.Add('ID',[int]); [void]$table.Columns.Add('Name',[string]); [void]$table.Columns.Add('Active',[bool]); [void]$table.Columns.Add('When',[datetime]); for($i=1;$i -le 10;$i++){ $row=$table.NewRow(); $row['ID']=[int]$i; $row['Name']="Row $i"; $row['Active']=($i%2 -eq 0); $row['When']=(Get-Date).AddDays(-$i); [void]$table.Rows.Add($row) } ; $grid.DataSource=$table
$lblDate=New-Label 'Date:' 20 270; $dtp=New-Object Windows.Forms.DateTimePicker; $dtp.Location=New-Object Drawing.Point(80,266); $dtp.Width=180; $dtp.Format='Long'; $toolTip.SetToolTip($dtp,'Pick a date')
$lblNum=New-Label 'Quantity:' 280 270; $num=New-Object Windows.Forms.NumericUpDown; $num.Location=New-Object Drawing.Point(360,266); $num.Maximum=1000; $num.Minimum=-100; $num.Value=10; $toolTip.SetToolTip($num,'Choose a number')
$lblTrack=New-Label 'TrackBar:' 500 270; $track=New-Object Windows.Forms.TrackBar; $track.Location=New-Object Drawing.Point(570,262); $track.Width=220; $track.Minimum=0; $track.Maximum=100; $toolTip.SetToolTip($track,'Slide to change value')
$prog=New-Object Windows.Forms.ProgressBar; $prog.Location=New-Object Drawing.Point(20,310); $prog.Width=770; $prog.Style='Continuous'; $toolTip.SetToolTip($prog,'Shows progress of simulated work')
$btnLoad=New-Button 'Simulate Work' 20 350 140 32; $toolTip.SetToolTip($btnLoad,'Runs a short progress demo')
$tabData.Controls.AddRange(@($grid,$lblDate,$dtp,$lblNum,$num,$lblTrack,$track,$prog,$btnLoad))
$btnLoad.Add_Click({ $prog.Value=0; for($i=0;$i -le 100;$i+=5){ Start-Sleep -Milliseconds 40; $prog.Value=$i; $sbReady.Text="Working... $i%"; [System.Windows.Forms.Application]::DoEvents() } ; $sbReady.Text='Done.' })
$track.Add_Scroll({ $sbReady.Text="Track value: $($track.Value)" })

# ===================== Tab 4: Layouts =======================================
$tabLayout=New-Object Windows.Forms.TabPage; $tabLayout.Text='Layouts'; $tabLayout.BackColor=[System.Drawing.Color]::LightGray; $tabs.TabPages.Add($tabLayout)
$tlp=New-Object Windows.Forms.TableLayoutPanel; $tlp.Dock='Top'; $tlp.Height=220; $tlp.ColumnCount=3; $tlp.RowCount=3; $tlp.CellBorderStyle='Single';
$tlp.ColumnStyles.Add((New-Object Windows.Forms.ColumnStyle([Windows.Forms.SizeType]::Percent,33)))|Out-Null; $tlp.ColumnStyles.Add((New-Object Windows.Forms.ColumnStyle([Windows.Forms.SizeType]::Percent,34)))|Out-Null; $tlp.ColumnStyles.Add((New-Object Windows.Forms.ColumnStyle([Windows.Forms.SizeType]::Percent,33)))|Out-Null; 1..3|%{ $tlp.RowStyles.Add((New-Object Windows.Forms.RowStyle([Windows.Forms.SizeType]::Percent,33)))|Out-Null }
foreach($r in 0..2){ foreach($c in 0..2){ $b=New-Object Windows.Forms.Button; $b.Dock='Fill'; $b.Text="R$r C$c"; $null=$tlp.Controls.Add($b,$c,$r) } }
$flp=New-Object Windows.Forms.FlowLayoutPanel; $flp.Dock='Top'; $flp.Height=90; $flp.WrapContents=$true; 1..12|%{ $chip=New-Object Windows.Forms.Button; $chip.Margin='3,3,3,3'; $chip.AutoSize=$true; $chip.Text="Chip $_"; $flp.Controls.Add($chip)|Out-Null }

# SplitContainer: left PictureBox, right custom paint Panel (side-by-side)
$split2=New-Object Windows.Forms.SplitContainer; $split2.Dock='Fill'
$split2.SplitterWidth   = 6
$split2.Panel1MinSize   = 360

# PictureBox (left) — scale image to fit
$pic=New-Object Windows.Forms.PictureBox; $pic.Dock='Fill'; $pic.SizeMode='Zoom'; $pic.BorderStyle='FixedSingle'
$bmp=New-Object Drawing.Bitmap 800,480; $g=[Drawing.Graphics]::FromImage($bmp); $g.Clear([Drawing.Color]::White); $pen=New-Object Drawing.Pen ([Drawing.Color]::DarkSlateBlue),3; for($i=0;$i -lt 10;$i++){ $g.DrawEllipse($pen,20+$i*20,20+$i*12,260,140) } ; $g.DrawString('PictureBox (generated image)',(New-Object Drawing.Font('Segoe UI',10)),(New-Object Drawing.SolidBrush([Drawing.Color]::Black)),20,10); $g.Dispose(); $pen.Dispose(); $pic.Image=$bmp
$split2.Panel1.Controls.Add($pic)

# Custom Paint Panel (right)
$drawPanel=New-Panel 0 0 100 100; $drawPanel.Dock='Fill'; $drawPanel.BackColor=[Drawing.Color]::White; $drawPanel.AutoScroll=$true; $drawPanel.AutoScrollMinSize=New-Object Drawing.Size(360,260)
$drawPanel.Add_Paint({ param($s,$e); $e.Graphics.SmoothingMode='AntiAlias'; $rect=New-Object Drawing.Rectangle(40,40,260,140); $e.Graphics.FillRectangle([Drawing.Brushes]::AliceBlue,$rect); $e.Graphics.DrawRectangle([Drawing.Pens]::Navy,$rect); $e.Graphics.DrawString('Custom Paint on Panel',(New-Object Drawing.Font('Consolas',10)),[Drawing.Brushes]::Black,50,80) })
$split2.Panel2.Controls.Add($drawPanel)

# Safe proportional split (set Panel2MinSize dynamically)
$tabLayout.Add_Resize({
    $split2.Panel2MinSize = 300
    $desired = [int]($tabLayout.ClientSize.Width * 0.55)
    $maxAllowed = $tabLayout.ClientSize.Width - $split2.Panel2MinSize
    if ($desired -lt $split2.Panel1MinSize) { $desired = $split2.Panel1MinSize }
    if ($desired -gt $maxAllowed) { $desired = $maxAllowed }
    if ($desired -gt 0) { $split2.SplitterDistance = $desired }
})

$tabLayout.Controls.AddRange(@($split2,$flp,$tlp))

# ===================== Tab 5: Dialogs & Misc ================================
$tabDlg=New-Object Windows.Forms.TabPage; $tabDlg.Text='Dialogs & Misc'; $tabDlg.BackColor=[System.Drawing.Color]::LightGray; $tabs.TabPages.Add($tabDlg)
$btnOpen=New-Button 'OpenFileDialog' 20 20 160 32; $toolTip.SetToolTip($btnOpen,'Pick a file to open')
$btnSave=New-Button 'SaveFileDialog' 200 20 160 32; $toolTip.SetToolTip($btnSave,'Pick where to save a file')
$btnColor=New-Button 'ColorDialog' 380 20 140 32; $toolTip.SetToolTip($btnColor,'Pick a color')
$btnFont=New-Button 'FontDialog' 540 20 120 32; $toolTip.SetToolTip($btnFont,'Pick a font')
$btnFolder=New-Button 'FolderBrowser' 680 20 140 32; $toolTip.SetToolTip($btnFolder,'Pick a folder')
$dlgOut=New-Object Windows.Forms.TextBox; $dlgOut.Location=New-Object Drawing.Point(20,70); $dlgOut.Size=New-Object Drawing.Size(800,24); $toolTip.SetToolTip($dlgOut,'Shows chosen file/folder/color/font')
$notify=New-Object Windows.Forms.NotifyIcon; $notify.Icon=[System.Drawing.SystemIcons]::Information; $notify.Visible=$true; $notify.BalloonTipTitle='WinForms Demo'; $notify.BalloonTipText='Hello from NotifyIcon!'
$timer=New-Object Windows.Forms.Timer; $timer.Interval=1000; $timer.Add_Tick({ $sbTime.Text=(Get-Date).ToString('T') }); $timer.Start()
$pb=New-Object Windows.Forms.ProgressBar; $pb.Location=New-Object Drawing.Point(20,110); $pb.Width=500; $pb.Style='Marquee'; $pb.MarqueeAnimationSpeed=30; $toolTip.SetToolTip($pb,'Marquee/continuous demo')
$cbMarquee=New-Object Windows.Forms.CheckBox; $cbMarquee.Text='Marquee'; $cbMarquee.Checked=$true; $cbMarquee.Location=New-Object Drawing.Point(530,108); $cbMarquee.Add_CheckedChanged({ if($cbMarquee.Checked){ $pb.Style='Marquee'; $pb.MarqueeAnimationSpeed=30 } else { $pb.Style='Continuous'; $pb.Value=66 } }); $toolTip.SetToolTip($cbMarquee,'Toggle marquee mode')
$tabDlg.Controls.AddRange(@($btnOpen,$btnSave,$btnColor,$btnFont,$btnFolder,$dlgOut,$pb,$cbMarquee))
$btnOpen.Add_Click({ $ofd=New-Object Windows.Forms.OpenFileDialog; $ofd.Filter='All files (*.*)|*.*'; if($ofd.ShowDialog() -eq 'OK'){ $dlgOut.Text="Open: $($ofd.FileName)" } })
$btnSave.Add_Click({ $sfd=New-Object Windows.Forms.SaveFileDialog; $sfd.Filter='Text file (*.txt)|*.txt'; $sfd.FileName='demo.txt'; if($sfd.ShowDialog() -eq 'OK'){ $dlgOut.Text="Save: $($sfd.FileName)" } })
$btnColor.Add_Click({ $cd=New-Object Windows.Forms.ColorDialog; if($cd.ShowDialog() -eq 'OK'){ $form.BackColor=$cd.Color; $dlgOut.Text="Color: $($cd.Color)" } })
$btnFont.Add_Click({ $fd=New-Object Windows.Forms.FontDialog; $fd.FontMustExist=$true; if($fd.ShowDialog() -eq 'OK'){ $lblOutput.Font=$fd.Font; $dlgOut.Text='Font set on Output label' } })
$btnFolder.Add_Click({ $fb=New-Object Windows.Forms.FolderBrowserDialog; if($fb.ShowDialog() -eq 'OK'){ $dlgOut.Text="Folder: $($fb.SelectedPath)" } })

# -------------------- Menu item events --------------------------------------
$miOpen.Add_Click({ if($btnOpen){ $btnOpen.PerformClick() } })
$miSave.Add_Click({ if($btnSave){ $btnSave.PerformClick() } })
$miExit.Add_Click({ $form.Close() })
$miToggleStatus.Add_Click({ $miToggleStatus.Checked = -not $miToggleStatus.Checked; $status.Visible = $miToggleStatus.Checked })
$miAbout.Add_Click({ [Windows.Forms.MessageBox]::Show("PowerShell WinForms Mega Demo`n`nExamples: inputs, lists, trees, data grid, date & number pickers, trackbar/progress, layouts, dialogs, context menus, menu/status bars, timer, tooltips, notify icon.", 'About', 'OK', 'Information') | Out-Null })

# -------------------- Show form & cleanup -----------------------------------
$form.Add_Shown({ if($notify){ $notify.ShowBalloonTip(1500) } })
[void]$form.ShowDialog()
if($notify){ $notify.Dispose() }
