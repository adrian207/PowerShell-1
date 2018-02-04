#Requires -Version 2 
function Get-ScreenShot { 
<#   
.SYNOPSIS
    Used to take a screenshot of the desktop or the active window.

.DESCRIPTION
    Used to take a screenshot of the desktop or the active window and save to an image file if needed.

.PARAMETER Screen
    Screenshot of the entire screen

.PARAMETER ActiveWindow
    Screenshot of the active window

.PARAMETER Path
    Name of the file to save as. Default is yyyy-MM-dd-HHmmss.png

.PARAMETER ImageType
    Type of image being saved. Can use jpeg, bmp, or png. Default is png.

.EXAMPLE
    Get-ScreenShot -ActiveWindow

    Takes a screen shot of the active window.

.EXAMPLE
    Get-ScreenShot -Screen

    Takes a screenshot of the entire desktop.

.EXAMPLE
    Get-ScreenShot -ActiveWindow -Path C:\image.png -ImageType bmp

    Takes a screenshot of the active window and saves the file named image.png with the image being bitmap.

.EXAMPLE
    Get-ScreenShot -Screen -Path "C:\image.png" -ImageType png

    Takes a screenshot of the entire desktop and saves the file named image.png with the image being png.

#>

    [CmdletBinding(
        DefaultParameterSetName = "Screen")]

    param (
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Screen",
            ValueFromPipeline = $true)]
        [switch]$Screen,
        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Window",
            ValueFromPipeline = $false)]
        [switch]$ActiveWindow,
        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "",
            ValueFromPipeline = $false)]
        [string]$Path,
        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "",
            ValueFromPipeline = $false)]
        [ValidateSet("bmp","jpeg","png")]
        [string]$ImageType = "png"
    )

    process {

# C# code
$Source = @'
using System;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Drawing.Imaging;

namespace ScreenShotDemo {

    public class ScreenCapture {
        /// <summary>
        /// Provides functions to capture the entire screen, or a particular window, and save it to a file.
        /// </summary>

        private Image CaptureWindow(IntPtr handle) {
            /// <summary>
            /// Creates an Image object containing a screen shot of a specific window
            /// </summary>
            /// <param name="handle">The handle to the window. (In windows forms, this is obtained by the Handle property)</param> 
            /// <returns></returns>
        
            // get the DC of the target window
            IntPtr hdcSrc = User32.GetWindowDC(handle);

            // get the size
            User32.RECT windowRect = new User32.RECT();
            User32.GetWindowRect(handle,ref windowRect);
            int width = windowRect.right - windowRect.left;
            int height = windowRect.bottom - windowRect.top;

            // create a device context we can copy to
            IntPtr hdcDest = GDI32.CreateCompatibleDC(hdcSrc);

            // create a bitmap we can copy it to,
            // using GetDeviceCaps to get the width/height
            IntPtr hBitmap = GDI32.CreateCompatibleBitmap(hdcSrc,width,height);

            // select the bitmap object
            IntPtr hOld = GDI32.SelectObject(hdcDest,hBitmap);

            // bitblt over
            GDI32.BitBlt(hdcDest,0,0,width,height,hdcSrc,0,0,GDI32.SRCCOPY);

            // restore selection
            GDI32.SelectObject(hdcDest,hOld);

            // clean up
            GDI32.DeleteDC(hdcDest);
            User32.ReleaseDC(handle,hdcSrc);

            // get a .NET image object for it
            Image img = Image.FromHbitmap(hBitmap);
            
            // free up the Bitmap object
            GDI32.DeleteObject(hBitmap);
            return img;
        }

        public void CaptureActiveWindow(string filename, ImageFormat format) {
            /// <summary>
            /// Captures a screen shot of the active window, and saves it to a file
            /// </summary>
            /// <param name="filename"></param>
            /// <param name="format"></param>

            Image img = CaptureWindow( User32.GetForegroundWindow() );
            img.Save(filename,format);
        }

        public void CaptureScreen(string filename, ImageFormat format) {
            /// <summary>
            /// Captures a screen shot of the entire desktop, and saves it to a file
            /// </summary>
            /// <param name="filename"></param>
            /// <param name="format"></param>

            Image img = CaptureWindow( User32.GetDesktopWindow() );
            img.Save(filename,format);
        }
        
        private class GDI32 {
            /// <summary>
            /// Helper class containing Gdi32 API functions
            /// </summary>

            public const int SRCCOPY = 0x00CC0020; // BitBlt dwRop parameter
            
            [DllImport("gdi32.dll")]
            public static extern bool BitBlt(IntPtr hObject,int nXDest,int nYDest,
                int nWidth,int nHeight,IntPtr hObjectSource,
                int nXSrc,int nYSrc,int dwRop);
            
            [DllImport("gdi32.dll")]
            public static extern IntPtr CreateCompatibleBitmap(IntPtr hDC,int nWidth,
                int nHeight);
            
            [DllImport("gdi32.dll")]
            public static extern IntPtr CreateCompatibleDC(IntPtr hDC);
            
            [DllImport("gdi32.dll")]
            public static extern bool DeleteDC(IntPtr hDC);
            
            [DllImport("gdi32.dll")]
            public static extern bool DeleteObject(IntPtr hObject);
            
            [DllImport("gdi32.dll")]
            public static extern IntPtr SelectObject(IntPtr hDC,IntPtr hObject);
        }

        private class User32 {
            /// <summary>
            /// Helper class containing User32 API functions
            /// </summary>

            [StructLayout(LayoutKind.Sequential)]
            public struct RECT {
                public int left;
                public int top;
                public int right;
                public int bottom;
            }

            [DllImport("user32.dll")]
            public static extern IntPtr GetDesktopWindow();
            
            [DllImport("user32.dll")]
            public static extern IntPtr GetWindowDC(IntPtr hWnd);
            
            [DllImport("user32.dll")]
            public static extern IntPtr ReleaseDC(IntPtr hWnd,IntPtr hDC);
            
            [DllImport("user32.dll")]
            public static extern IntPtr GetWindowRect(IntPtr hWnd,ref RECT rect);
            
            [DllImport("user32.dll")]
            public static extern IntPtr GetForegroundWindow();
        }
    }
}
'@
        Add-Type -TypeDefinition $Source -ReferencedAssemblies 'System.Windows.Forms','System.Drawing'
        $Capture = New-Object -TypeName 'ScreenShotDemo.ScreenCapture'

        $Format = Get-Date -Format "yyyyMMdd-HHmmss"
        $OutFile = -join( $Format,".",$ImageType )

        if ($Path -eq "") {
            $Path = Join-Path -Path $pwd -ChildPath $OutFile
        }

        if ($Screen) {
            Write-Verbose -Message ( "Creating screenshot of the desktop: {0}" -f $Path )

            $Capture.CaptureScreen($Path,$ImageType)
        }

        if ($ActiveWindow) {
            Write-Verbose -Message ( "Creating screenshot of the active window: {0}" -f $Path )

            $Capture.CaptureActiveWindow($Path,$ImageType)
        }
    }
}
