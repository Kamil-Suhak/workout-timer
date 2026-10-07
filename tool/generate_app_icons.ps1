Add-Type -AssemblyName System.Drawing

function Draw-Icon {
    param (
        [int]$Size,
        [string]$Path
    )

    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # 1. Background Rounded Squircle / Circle
    $margin = [float]($Size * 0.04)
    $bgSize = [float]($Size - (2 * $margin))
    $cornerRadius = [float]($Size * 0.22)

    $bgPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $rect = New-Object System.Drawing.RectangleF $margin, $margin, $bgSize, $bgSize
    $diam = $cornerRadius * 2
    $bgPath.AddArc($rect.X, $rect.Y, $diam, $diam, 180, 90)
    $bgPath.AddArc($rect.Right - $diam, $rect.Y, $diam, $diam, 270, 90)
    $bgPath.AddArc($rect.Right - $diam, $rect.Bottom - $diam, $diam, $diam, 0, 90)
    $bgPath.AddArc($rect.X, $rect.Bottom - $diam, $diam, $diam, 90, 90)
    $bgPath.CloseFigure()

    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 18, 20, 24))
    $g.FillPath($bgBrush, $bgPath)

    # Subtle inner border
    $borderPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 42, 46, 56)), ([Math]::Max(1.0, [float]($Size * 0.02)))
    $g.DrawPath($borderPen, $bgPath)

    # 2. Outer Timer Track (Subtle Muted Slate)
    $center = [float]($Size / 2.0)
    $radius = [float]($Size * 0.30)
    $strokeWidth = [float]($Size * 0.065)

    $trackPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 38, 42, 50)), $strokeWidth
    $trackPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $trackPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $dialRect = New-Object System.Drawing.RectangleF ($center - $radius), ($center - $radius), ($radius * 2), ($radius * 2)
    $g.DrawEllipse($trackPen, $dialRect)

    # 3. Active Interval Arc (Vermilion #FF5222)
    $arcPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 255, 82, 34)), $strokeWidth
    $arcPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $arcPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawArc($arcPen, $dialRect, -90, 240)

    # 4. Center Minimal Pulse Dot / Tick (Crisp White #F3F4F6)
    $centerDotRadius = [float]($Size * 0.075)
    $dotBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 243, 244, 246))
    $g.FillEllipse($dotBrush, ($center - $centerDotRadius), ($center - $centerDotRadius), ($centerDotRadius * 2), ($centerDotRadius * 2))

    # Top Crown / Stopwatch Button minimal accent
    $topTickPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 243, 244, 246)), ([Math]::Max(1.5, [float]($Size * 0.035)))
    $topTickPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $topTickPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $topY1 = [float]($margin + ($Size * 0.03))
    $topY2 = [float]($margin + ($Size * 0.07))
    $g.DrawLine($topTickPen, $center, $topY1, $center, $topY2)

    # Clean up and save
    $parent = [System.IO.Path]::GetDirectoryName($Path)
    if (-not [System.IO.Directory]::Exists($parent)) {
        [System.IO.Directory]::CreateDirectory($parent) | Out-Null
    }

    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

$resolutions = @{
    "android/app/src/main/res/mipmap-mdpi/ic_launcher.png" = 48
    "android/app/src/main/res/mipmap-hdpi/ic_launcher.png" = 72
    "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png" = 96
    "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png" = 144
    "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" = 192
    "assets/icon/app_icon.png" = 512
}

foreach ($entry in $resolutions.GetEnumerator()) {
    Write-Output "Generating $($entry.Key) ($($entry.Value)x$($entry.Value))..."
    Draw-Icon -Size $entry.Value -Path $entry.Key
}
Write-Output "App icon generation completed!"
