function Protect-Env {
  # .SYNOPSIS
  #     Enable AES encrypted Environment Variables
  # .DESCRIPTION
  #    Configures/activates AES encryption in Environment Variables.
  #    ie: Once run, all cmdlets of dotEnv PsModule will use AES when seting environment variables.
  #    How does the protection work?
  #    Well, suppose NEXT_PUBLIC_SUPER_SECRET_KEY 's value is "hellokitty123"
  #    Obfuscation, back and forth example:
  #    ("hellokitty123" | xconvert ToObfuscated | xconvert FromObfuscated, ToUTF8str) | Should -be 'hellokitty123'
  #    Protect-Env will encrypt the obfuscated value and store it in the .env file
  # .NOTES
  #     Information or caveats about the function e.g. 'This function is not supported in Linux'
  # .LINK
  #     Unprotect-Env
  # .LINK
  #     https://github.com/alainQtec/cliHelper.env/blob/main/Public/Protect-Env.ps1
  # .EXAMPLE
  #     Protect-Env NEXT_PUBLIC_SUPER_SECRET_KEY
  #     Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
  [CmdletBinding(DefaultParameterSetName = 'withPasswordStr')]
  param (
    # The .env or .config path
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateScript({
        if (![IO.File]::Exists(([dotEnv]::GetUnResolvedPath($_)))) {
          throw [System.IO.FileNotFoundException]::new("Please path to existing file", $_)
        } else {
          $true
        }
      }
    )]
    [string]$Path,

    # The key name, whose value will be encrypted
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Name,

    [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'withPassword')]
    [securestring]$Password,

    [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'withPasswordStr')]
    [Alias('PasswordStr', 'securestring')]
    [string]$Passw0rdStr
  )

  begin {
    $File = [IO.FileInfo]::new(([dotEnv]::GetUnResolvedPath($Path)))
    $pass = ($PSCmdlet.parameterSetName -eq 'withPasswordStr') ? $($Passw0rdStr | xconvert ToSecureString) : $Password
  }

  process {
    $value = Get-Env -File $Path -Name $Name | Select-Object -Expand Value
    if (![string]::IsNullOrWhiteSpace($value)) {
      [dotEnv]::Update($File, $Name, [AesGCM]::Encrypt(($value | xconvert ToObfuscated, ToGuid).Guid, $Pass, 3))
    }
  }
}