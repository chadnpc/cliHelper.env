function Publish-Env {
  <#
  .NOTES
    This function is not supported in Linux
  .LINK
    https://github.com/prefix-dev/pixi/pull/692
  #>
  [CmdletBinding()]
  param()
  process {
    if ([xcrypt]::Get_Host_Os() -eq "Windows") {
      $IsnmLoaded = [bool]("win32.nativemethods" -as [type])
      $IswxLoaded = [bool]("Win32API.Explorer" -as [type])
      if (!$IsnmLoaded -or !$IswxLoaded) { Write-Verbose "🔵 ⏳ Loading required namespaces ..."; [Console]::WriteLine() }
      if (!$IsnmLoaded) {
        Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition '[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)] public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);'
      }
      if (!$IswxLoaded) {
        Add-Type 'using System; using System.Runtime.InteropServices; namespace Win32API { public class Explorer { private static readonly IntPtr HWND_BROADCAST = new IntPtr (0xffff); private static readonly IntPtr HWND_KEYBOARD = new IntPtr (65535); private static readonly UIntPtr WM_USER = new UIntPtr (41504); private const Int32 WM_SETTINGCHANGE = 0x1a; private const Int32 SMTO_ABORTIFHUNG = 0x0002; private const Int32 VK_F5 = 273; [DllImport ("shell32.dll", CharSet = CharSet.Auto, SetLastError = false)] private static extern Int32 SHChangeNotify (Int32 eventId, Int32 flags, IntPtr item1, IntPtr item2); [DllImport ("user32.dll", CharSet = CharSet.Auto, SetLastError = false)] private static extern IntPtr SendMessageTimeout (IntPtr hWnd, Int32 Msg, IntPtr wParam, String lParam, Int32 fuFlags, Int32 uTimeout, IntPtr lpdwResult); [DllImport ("user32.dll", CharSet = CharSet.Auto, SetLastError = false)] static extern bool SendNotifyMessage (IntPtr hWnd, UInt32 Msg, IntPtr wParam, String lParam); [DllImport ("user32.dll", CharSet = CharSet.Auto, SetLastError = false)] private static extern Int32 PostMessage (IntPtr hWnd, UInt32 Msg, UIntPtr wParam, IntPtr lParam); public static void RefreshEnvironment () { SHChangeNotify (0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero); SendMessageTimeout (HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, "Environment", SMTO_ABORTIFHUNG, 100, IntPtr.Zero); SendNotifyMessage (HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, "TraySettings"); } public static void RefreshShell () { PostMessage (HWND_KEYBOARD, VK_F5, WM_USER, IntPtr.Zero);}}}'
      } # Tiddy and updated version lives here: https://gist.github.com/chadnpc/e75089c849ccf5b02d0d1cfa6618fc3a/raw/2cdac0da416ea9f25a2e273d445c6a2d725bc6b7/Win32API.Explorer.cs
      # Refresh all objects using Win32API. ie: sometimes explorer.exe just doesn't get the message that things were updated.
      # RefreshEnvironment, RefreshShell and Notify all windows of environment block change
      [scriptblock]::Create("[Win32API.Explorer]::RefreshEnvironment(); [Win32API.Explorer]::RefreshShell()").Invoke()
      [scriptblock]::Create("`$HWND_BROADCAST = [intptr]0xffff; `$WM_SETTINGCHANGE = 0x1a; `$result = [uintptr]::zero; [void][win32.nativemethods]::SendMessageTimeout(`$HWND_BROADCAST, `$WM_SETTINGCHANGE, [uintptr]::Zero, 'Environment', 2, 5000, [ref]`$result)").Invoke()
    }
  }
}
