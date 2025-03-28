#
# Module manifest for module 'dotEnv'
#
# Generated by: Alain Herve
# Generated on: 06/10/2024
#

@{
  # Script module or binary module file associated with this manifest.
  RootModule            = 'cliHelper.env.psm1'
  ModuleVersion         = '<ModuleVersion>'
  GUID                  = '5b2d0876-9a8b-4aa5-bd54-ce47c534642e'
  Author                = 'alain'
  CompanyName           = 'chadnpc'
  Copyright             = "Alain Herve (c) <Year>. All rights reserved."
  Description           = 'A module for loading and editing environment variables. It also includes cmdlets for extra safety measures.'
  PowerShellVersion     = '3.0'
  # Name of the PowerShell host required by this module
  # PowerShellHostName = ''
  # Minimum version of the PowerShell host required by this module
  # PowerShellHostVersion = ''
  # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
  # DotNetFrameworkVersion = ''
  # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
  ClrVersion            = '2.0.50727'
  # Processor architecture (None, X86, Amd64) required by this module
  ProcessorArchitecture = 'None'
  RequiredAssemblies    = @()
  ScriptsToProcess      = @()
  TypesToProcess        = @()
  FormatsToProcess      = @()
  NestedModules         = @()
  FunctionsToExport     = @(
    '<FunctionsToExport>'
  )
  RequiredModules       = @(
    'clihelper.xcrypt',
    'PsModuleBase'
  )
  CmdletsToExport       = '*'
  VariablesToExport     = '*'
  AliasesToExport       = '*'
  # DscResourcesToExport = @()

  # List of all modules packaged with this module
  # ModuleList = @()

  # List of all files packaged with this module
  # FileList = @()

  # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
  PrivateData           = @{
    PSData = @{
      # Tags applied to this module. These help with module discovery in online galleries.
      Tags         = 'dotEnv', 'PowerShell'
      LicenseUri   = 'https://alain.mit-license.org/'
      ProjectUri   = 'https://github.com/chadnpc/cliHelper.env'
      # IconUri = ''
      ReleaseNotes = "
<ReleaseNotes>
"

      # Prerelease string of this module
      # Prerelease = ''

      # Flag to indicate whether the module requires explicit user acceptance for install/update/save
      # RequireLicenseAcceptance = $false

      # External dependent modules of this module
      # ExternalModuleDependencies = @()
    } # End of PSData hashtable
  } # End of PrivateData hashtable

  # HelpInfo URI of this module
  # HelpInfoURI = ''

  # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
  # DefaultCommandPrefix = ''
}

