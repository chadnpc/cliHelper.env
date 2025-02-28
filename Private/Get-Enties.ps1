function Get-Enties {
  [CmdletBinding()][OutputType([dotEntry[]])]
  Param([IO.FileInfo]$File)
  if ($File.Exists) {
    # [IO.File]::Exists([dotEnv]::Config.fallBack)
    if (![dotEnv]::IsPersisted($File.FullName)) {
      return [dotEnv]::Read($File.FullName)
    } else {
      return [dotEnv]::vars.Process
    }
  }
  return [enum]::GetNames([EnvironmentVariableTarget]).ForEach({ [dotEnv]::vars.$_ })
}