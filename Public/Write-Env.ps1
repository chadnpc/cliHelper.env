function Write-Env {
  # .SYNOPSIS
  #   same as: Add-Env -outFile
  # .DESCRIPTION
  #   Write environment Variable(s) to a .env or a .cfg file, but does not set it.
  # .PARAMETER Path
  #   The path to the pyvenv.cfg file
  # .PARAMETER Name
  #   The key to edit
  # .PARAMETER Value
  #   The new value for the key
  # .EXAMPLE
  #  Edit-Env -Path ./.env -Key "PIPENV_CUSTOM_VENV_NAME" -Value "pipenvtools"
  #  Changes the value
  # .EXAMPLE
  #  Edit-Confg -Path "pyvenv.cfg" -Key "NEW_KEY" -Value "new-value"
  #  Adds a new key
  [CmdletBinding(DefaultParameterSetName = "path")]
  [Alias('Edit-Confg', 'Edit-Env')]
  param (
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'keyvalue')]
    [ValidateScript({
        if (![IO.File]::Exists(($_ | dotEnv GetUnResolvedPath))) {
          throw [System.IO.FileNotFoundException]::new("Please path to existing file", $_)
        } else {
          $true
        }
      }
    )]
    [string]$Path,

    [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'keyvalue')]
    [ValidateNotNullOrWhiteSpace()]
    [string]$Name,

    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'entries')]
    [dotEntry[]]$Entries,

    [Parameter(Mandatory = $true, Position = 2, ParameterSetName = '__AllparameterSets')]
    [string]$Value
  )
  begin {
    $File = [IO.FileInfo]::new(($Path | dotEnv GetUnResolvedPath))
  }

  process {
    if ($PSCmdlet.ParameterSetName -eq "keyvalue") {
      [dotEnv]::Update($File, $Name, $Value)
    } else {
      $c = [dotEnv]::Update($Entries, $Name, $Value)
      [IO.File]::WriteAllText($File.FullName, ($c.ForEach({ $_.ToString() }) | Out-String).Trim(), [System.Text.Encoding]::UTF8)
    }
  }
}