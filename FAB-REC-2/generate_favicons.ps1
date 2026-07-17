Add-Type -AssemblyName System.Drawing
$outDir = "d:\FAB-REC\assets\icons"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

$sizes = @(
  @{ Name = "favicon-16x16.png"; Size = 16 },
  @{ Name = "favicon-32x32.png"; Size = 32 },
  @{ Name = "apple-touch-icon.png"; Size = 180 }
)

foreach ($s in $sizes) {
  $w = $s.Size; $h = $w
  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear([System.Drawing.Color]::Transparent)

  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $r = [int]($w * 0.2)
  if ($r -eq 0) { $r = 1 }
  $path.AddArc(0, 0, $r * 2, $r * 2, 180, 90)
  $path.AddArc($w - $r * 2, 0, $r * 2, $r * 2, 270, 90)
  $path.AddArc($w - $r * 2, $h - $r * 2, $r * 2, $r * 2, 0, 90)
  $path.AddArc(0, $h - $r * 2, $r * 2, $r * 2, 90, 90)
  $path.CloseFigure()

  $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(15, 61, 46))
  $g.FillPath($bgBrush, $path)

  $fontSize = [float]($w * 0.45)
  $font = New-Object System.Drawing.Font("Arial", $fontSize, [System.Drawing.FontStyle]::Bold)
  $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
  
  $rect = New-Object System.Drawing.RectangleF(0, 0, $w, $h)
  $g.DrawString("FR", $font, $textBrush, $rect, $sf)
  $bmp.Save("$outDir\$($s.Name)", [System.Drawing.Imaging.ImageFormat]::Png)
  
  $g.Dispose()
  $bmp.Dispose()
}

Copy-Item "$outDir\favicon-32x32.png" "$outDir\favicon.ico" -Force
