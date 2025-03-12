function Read-Env {
  # .SYNOPSIS
  #   Reads environment Variable(s) from a .env file.
  # .LINK
  #   https://github.com/chadnpc/cliHelper.env/Public/Read-Env.ps1
  # .EXAMPLE
  #   Read-Env ./.env
  # .EXAMPLE
  #   Read-Env | Set-Env
  [CmdletBinding(DefaultParameterSetName = "path")][OutputType([dotEntry[]])]
  param (
    [Parameter(Mandatory = $false, Position = 0, ParameterSetName = 'path')]
    [ValidateScript({
        if (![IO.File]::Exists(($_ | dotEnv GetUnResolvedPath))) {
          throw [System.IO.FileNotFoundException]::new("Please path to existing file", $_)
        } else {
          $true
        }
      }
    )]
    [string]$Path = [dotenv].EnvFile,

    [Parameter(Mandatory = $false, Position = 0, ParameterSetName = 'file')]
    [ValidateScript({
        if (!$_.Exists) {
          throw [System.IO.FileNotFoundException]::new("Please provide a valid file path.", $_)
        } else {
          $true
        }
      }
    )]
    [IO.FileInfo]$File = [IO.FileInfo][dotenv].EnvFile
  )
  end {
    if ($PSCmdlet.ParameterSetName -eq "path") {
      return [dotenv]::Read($Path)
    }
    return [dotenv]::Read($File.FullName)
  }
}