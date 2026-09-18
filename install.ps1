[CmdletBinding()]
param(
    [string]$Dest = (Join-Path $HOME '.agents/skills'),
    [switch]$List,
    [switch]$Help,
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Skills
)

$ErrorActionPreference = 'Stop'

function Fail([string]$Message) {
    throw $Message
}

function Copy-Contents([string]$Source, [string]$Target) {
    foreach ($item in Get-ChildItem -LiteralPath $Source -Force) {
        $itemTarget = Join-Path $Target $item.Name
        if ($item.PSIsContainer) {
            if (Test-Path -LiteralPath $itemTarget -PathType Leaf) {
                Fail "Destination is not a directory: $itemTarget"
            }
            New-Item -ItemType Directory -Path $itemTarget -Force | Out-Null
            Copy-Contents $item.FullName $itemTarget
        } else {
            Copy-Item -LiteralPath $item.FullName -Destination $itemTarget -Force
        }
    }
}

if ($Help) {
    @'
Usage: .\install.ps1 [-Dest DIRECTORY] [-List] [SKILL ...]

Install all bundled skills, or only the named skills.
Default destination: ~/.agents/skills

Options:
  -Dest DIRECTORY  Install into a different skills directory.
  -List            List available skills and exit.
  -Help            Show this help and exit.

Run again to update installed files. Matching files are overwritten;
extra destination files are preserved. No downloads are performed.
'@ | Write-Output
    return
}

$sourceRoot = Join-Path $PSScriptRoot 'skills'
$available = @(Get-ChildItem -LiteralPath $sourceRoot -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf
} | Select-Object -ExpandProperty Name)
if ($available.Count -eq 0) { Fail 'No bundled skills found.' }

if ($List) {
    $available | Write-Output
    return
}

if (-not $Skills -or $Skills.Count -eq 0) { $Skills = $available }
foreach ($skill in $Skills) {
    if ($available -cnotcontains $skill) {
        Fail "Unknown skill: $skill. Use -List to see available skills."
    }
}

if ([string]::IsNullOrWhiteSpace($Dest)) { Fail '-Dest requires a directory.' }
$destination = if ([IO.Path]::IsPathRooted($Dest)) {
    [IO.Path]::GetFullPath($Dest)
} else {
    [IO.Path]::GetFullPath((Join-Path (Get-Location).ProviderPath $Dest))
}
$sourcePath = [IO.Path]::GetFullPath($sourceRoot).TrimEnd([char[]]@('\', '/'))
if ($destination.Equals($sourcePath, [StringComparison]::OrdinalIgnoreCase) -or
    $destination.StartsWith($sourcePath + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    Fail "Choose a destination outside the repository's skills directory."
}

foreach ($skill in $Skills) {
    $target = Join-Path $destination $skill
    $existing = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    if ($null -ne $existing) {
        if ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            Fail "Installed skill is a link: $target"
        }
        if (-not $existing.PSIsContainer) {
            Fail "Destination is not a directory: $target"
        }
    }
}

New-Item -ItemType Directory -Path $destination -Force | Out-Null
foreach ($skill in $Skills) {
    $target = Join-Path $destination $skill
    New-Item -ItemType Directory -Path $target -Force | Out-Null
    Copy-Contents (Join-Path $sourceRoot $skill) $target
    Write-Output "Installed $skill -> $target"
}

Write-Output 'Start a new Codex session to use the installed skills.'
