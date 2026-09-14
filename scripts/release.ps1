param(
  [string]$OutputDirectory = ('artifacts/endomer-build-' + (Get-Date -Format 'yyyyMMdd-HHmmss')),
  [string]$Rscript = 'Rscript',
  [string]$Python = 'python',
  [string]$AssetCache
)
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
Set-Location -LiteralPath $workspace
$output = [IO.Path]::GetFullPath((Join-Path $workspace $OutputDirectory))
$packageRoot = [IO.Path]::GetFullPath((Join-Path $workspace 'endomer'))
if (!$output.StartsWith($workspace + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase) -or
    $output.Equals($packageRoot,[StringComparison]::OrdinalIgnoreCase) -or
    $output.StartsWith($packageRoot + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) {
  throw 'Choose an output folder inside ENDOM and outside the endomer source directory'
}
if (Test-Path -LiteralPath $output) { throw 'Choose a new output directory; previous builds are preserved' }
if (!(Test-Path -LiteralPath artifacts/endom-closure-release/engihr/package/engihr_0.3.0.tar.gz)) {
  throw 'The verified ENGIH release artifacts are required; see prepare-bundle.R for the seven package sources'
}
New-Item -ItemType Directory -Path $output | Out-Null
$env:ENDOMER_RELEASE_DIR = $output
$env:RENV_CONFIG_AUTOLOADER_ENABLED = 'false'
$env:LC_ALL = 'English_United States.utf8'
$env:PYTHONUTF8 = '1'
if ($AssetCache) {
  $cache = Join-Path $output 'sites/cache'
  New-Item -ItemType Directory -Path $cache -Force | Out-Null
  Get-ChildItem -LiteralPath $AssetCache | Copy-Item -Destination $cache -Recurse -Force
}
function Invoke-ReleaseStep([string]$Name,[string]$Executable,[string[]]$StepArguments) {
  Write-Output ('Running ' + $Name)
  & $Executable @StepArguments *> (Join-Path $output ($Name + '.log'))
  if ($LASTEXITCODE -ne 0) { throw ('Failed: ' + $Name + '; inspect ' + $output) }
}
Invoke-ReleaseStep 'author-docs' $Python @('endomer/scripts/author-docs.py')
Invoke-ReleaseStep 'test-local' $Rscript @('endomer/scripts/test-local.R')
Invoke-ReleaseStep 'reference' $Rscript @('endomer/scripts/export-reference.R')
Invoke-ReleaseStep 'translate-reference' $Python @('endomer/scripts/build-reference.py')
Invoke-ReleaseStep 'r-check' $Rscript @('endomer/scripts/check-release.R')
foreach ($step in @('build-binary','prepare-bundle','verify-bundle')) {
  Invoke-ReleaseStep $step $Rscript @('endomer/scripts/' + $step + '.R')
}
foreach ($mode in @('source','binary')) {
  Invoke-ReleaseStep ('integration-' + $mode) $Rscript @('endomer/scripts/verify-installed.R',$mode)
}
Invoke-ReleaseStep 'r-docs' $Rscript @('endomer/scripts/build-docs.R',(Join-Path $output 'sites/r'))
Invoke-ReleaseStep 'site-check' $Python @('endomer/scripts/check-sites.py',(Join-Path $output 'sites/r'),'--kind','r')
Invoke-ReleaseStep 'distribution' $Python @('endomer/scripts/audit-distribution.py')
Invoke-ReleaseStep 'delivery' $Python @('endomer/scripts/assemble-delivery.py')
Invoke-ReleaseStep 'zip-verification' $Python @('endomer/scripts/verify-delivery.py',$Rscript)
Write-Output ('Delivery verified in ' + $output + '. Review the new site in a browser before publication.')
