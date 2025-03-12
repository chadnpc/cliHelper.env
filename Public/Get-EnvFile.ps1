function Get-EnvFile {
  # .SYNOPSIS
  #   gets .env Path
  # .EXAMPLE
  #   Get-EnvFile
  # .EXAMPLE
  #   Get-EnvFile .env
  [OutputType([System.IO.FileInfo])]
  param (
    [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true)]
    [string]$Path
  )
  process {
    if ([string]::IsNullOrWhiteSpace($Path)) {
      if ($null -eq [dotenv].EnvFile) { [dotenv]::SetEnvFile() }
      $Path = [dotenv].EnvFile
    }
    $p = Get-Item ($Path | dotEnv GetUnResolvedPath) -Force -ea Ignore
    if (!$p.Exists) {
      Write-Error "File not found: $Path"
    }
    return $p -as [System.IO.FileInfo]
  }
}