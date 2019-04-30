[CmdletBinding()]
PARAM(
    [Parameter(Mandatory=$true)][String] $connectedServiceEndpoint,
    [Parameter(Mandatory=$true)][String] $packagePath,
    [Parameter()][String] $versionMode,
    [Parameter(HelpMessage="ApplicationVersion?")][String] $applicationVersion,
    [Parameter(HelpMessage="ServiceVersion?")][String] $serviceVersion,
    [Parameter(Mandatory=$true, HelpMessage="CodePackageMode?")][String] $codePackageMode,
    [Parameter(Mandatory=$true, HelpMessage="ConfigPackageMode?")][String] $configPackageMode,
    [Parameter(Mandatory=$true, HelpMessage="DataPackageMode?")][String] $dataPackageMode,
    [Parameter(HelpMessage="CodePackageVersion?")][String] $codePackageVersion,
    [Parameter(HelpMessage="ConfigPackageVersion?")][String] $configPackageVersion,
    [Parameter(HelpMessage="DataPackageVersion?")][String] $dataPackageVersion,
    [Parameter(HelpMessage="HashAlgorithm?")][String] $hashAlgorithm,
    [Parameter(Mandatory=$true, HelpMessage="HashExcludes?")][String] $hashExcludes,
    [Parameter(Mandatory=$true, HelpMessage="DifferentialPackage?")][String] $differentialPackage
)

    . "$PSScriptRoot/Update-ServiceFabricApplicationPackageVersions.ps1"
    . "$PSScriptRoot/Get-ServiceFabricApplicationPackageVersions.ps1"
    
    if ($differentialPackage -eq 'true')
    {
        Connect-ServiceFabricCluster -ConnectionEndpoint localhost:19000

        $applicationManifestPath = [IO.Path]::Combine($packagePath, 'ApplicationManifest.xml')
        $applicationManifest = [xml](Get-Content $applicationManifestPath)
        $versions = Get-ServiceFabricApplicationPackageVersions -ApplicationTypeName $applicationManifest.ApplicationManifest.ApplicationTypeName
    }

    Update-ServiceFabricApplicationPackageVersions `
        -PackagePath $packagePath `
		-VersionMode $versionMode `
        -ApplicationVersion $applicationVersion `
        -ServiceVersion $serviceVersion `
        -CodePackageHash:($codePackageMode -eq 'Hash') `
        -ConfigPackageHash:($configPackageMode -eq 'Hash') `
        -DataPackageHash:($dataPackageMode -eq 'Hash') `
        -CodePackageVersion $codePackageVersion `
        -ConfigPackageVersion $configPackageVersion `
        -DataPackageVersion $dataPackageVersion `
        -DiffPackageVersions $versions `
        -HashAlgorithm $hashAlgorithm `
        -HashExcludes $hashExcludes.Split(';')
