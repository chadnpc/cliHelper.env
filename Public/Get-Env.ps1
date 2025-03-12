function Get-Env {
  # .SYNOPSIS
  #   Gets an Environment Variable.
  # .DESCRIPTION
  #   This will will get an environment variable based on the variable name and scope.
  # .PARAMETER Name
  #   The environment variable you want to get the value from.
  # .PARAMETER source
  #   .env file path from which to read variables.
  # .PARAMETER Scope
  #   The environment variable target scope. This is `Process`, `User`, or `Machine`.
  # .EXAMPLE
  #   Get-Env *User_Id* -source ./.env
  #   > Name                                       Value
  #     ----                                       -----
  #     NEXT_PUBLIC_MTN_API_COLLECTION_USER_ID     lorem331acb
  #     NEXT_PUBLIC_MTN_API_DISBURSEMENT_USER_ID   ipsum110102
  #
  #   Reads all env variables from .env file and only returns those with User_Id in their name
  # .EXAMPLE
  #   Get-Env '*DISPLAY*' -Scope Process
  #   > Name                       Value
  #     ----                       -----
  #     DISPLAY                    :1
  #     ELM_DISPLAY                wl
  #     WAYLAND_DISPLAY            wayland-1
  #   Reads all env variables from Process scope and only returns those with DISPLAY in their name
  # .EXAMPLE
  #   Get-Env -File (Get-EnvFile).FullName
  # .LINK
  #   https://github.com/chadnpc/cliHelper.env/Public/Get-Env.ps1
  [CmdletBinding(DefaultParameterSetName = 'session')]
  [OutputType([dotEntry[]])]
  param(
    [Parameter(Mandatory = $false, Position = 0, ParameterSetName = '__AllparameterSets')]
    [ValidateNotNullOrWhiteSpace()]
    [string]$Name = "*",

    [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'file')]
    [ValidateScript({
        if (![IO.File]::Exists(($_ | dotEnv GetUnResolvedPath))) {
          throw [System.IO.FileNotFoundException]::new("Please path to existing file", $_)
        } else {
          $true
        }
      }
    )][Alias('File')]
    [string]$Path,

    [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'session')]
    [System.EnvironmentVariableTarget]$Scope = 'Process',

    [Parameter(Mandatory = $false, ParameterSetName = 'file')]
    [switch]$Persist,

    [Parameter(Mandatory = $false, ParameterSetName = '__AllparameterSets')]
    [switch]$Force
  )

  begin {
    $PsCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { Set-Variable -Name $_.Key -Value $_.Value -ea 'SilentlyContinue' }
    $results = @(); $File = [IO.FileInfo]::new(($Path | dotEnv GetUnResolvedPath))
  }

  Process {
    $fromFile = $PSCmdlet.ParameterSetName -eq "file"
    $vars = $fromFile ? (Get-Enties $File) : (Get-Enties)
    if ($PSBoundParameters.ContainsKey('scope')) { $vars = $vars.$scope }
    if ($Persist -and $fromFile) {
      if (![dotEnv]::IsPersisted($File.FullName) -or $Force) {
        [dotEnv]::Persist($File.FullName);
        if ($vars.count -gt 0) {
          Set-Env -Entries $vars
        }
      }
    }
    $results = $(if ($Name.Contains('*')) {
        $vars.Where({ $_.Name -like $Name })
      } else {
        $vars.Where({ $_.Name -eq $Name })
      }
    )
  }

  end {
    if (!$results -and !$fromFile) {
      # ie: When not found in scope, so we use (one-time) those from .env file
      if (![IO.File]::Exists([dotEnv]::Config.fallBack)) {
        [dotEnv]::Config.Set("fallBack", (Get-EnvFile).FullName)
        $results = Get-Env -Name $Name -Scope $Scope
      } else {
        $results = Get-Env -Name $Name -source ([dotEnv]::Config.fallBack) -Persist
        [dotEnv]::Config.Remove("fallback")
      }
    }
    return $results
  }
}