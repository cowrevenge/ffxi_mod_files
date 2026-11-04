<#
    Resolve Pivot's overlay configuration the way Pivot does, and report which overlay
    actually supplies a given DAT path.

    Pivot's rule: the LOWEST-numbered overlay that contains the file wins.

    .PARAMETER DatPath
        Path under the overlay root to look for, e.g. ROM\5\15.DAT

    .PARAMETER ExpectHash
        Optional. If given, the winning file's SHA-256 is compared against it and the
        script exits non-zero on mismatch.

    Exits non-zero if no overlay provides the file, or an expected hash does not match.

    Example:
        powershell -File verify-pivot.ps1 -DatPath ROM\5\15.DAT
        powershell -File verify-pivot.ps1 -DatPath ROM\5\15.DAT -ExpectHash 50091102...
#>
[CmdletBinding()]
param(
    [string] $DatPath    = 'ROM\5\15.DAT',
    [string] $ExpectHash,
    [string] $IniPath    = 'C:\PhoenixXI\config\pivot\pivot.ini'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $IniPath)) {
    Write-Host "FAIL: Pivot config not found at $IniPath"
    exit 1
}

$root = $null
$ovl  = New-Object System.Collections.Generic.List[object]

foreach ($l in [IO.File]::ReadAllLines($IniPath)) {
    if ($l -match '^\s*root_path\s*=\s*(.+?)\s*$') {
        $root = $Matches[1]
    }
    elseif ($l -match '^\s*(\d+)\s*=\s*(.+?)\s*$') {
        $ovl.Add([pscustomobject]@{ Index = [int]$Matches[1]; Name = $Matches[2] })
    }
}

if ([string]::IsNullOrWhiteSpace($root)) {
    Write-Host "FAIL: no root_path in $IniPath"
    exit 1
}

Write-Host "config    = $IniPath"
Write-Host "root_path = $root"
Write-Host "looking for $DatPath"
Write-Host ''

$winner = $null
foreach ($o in ($ovl | Sort-Object Index)) {
    $p   = Join-Path $root (Join-Path $o.Name $DatPath)
    $has = Test-Path -LiteralPath $p
    $tag = if ($has) { 'PRESENT' } else { '-' }
    Write-Host ('  [{0}] {1,-22} -> {2}' -f $o.Index, $o.Name, $tag)
    if ($has -and $null -eq $winner) {
        $winner = [pscustomobject]@{ Index = $o.Index; Name = $o.Name; Path = $p }
    }
}

Write-Host ''
if ($null -eq $winner) {
    Write-Host "FAIL: no enabled overlay supplies $DatPath"
    exit 1
}

$hash = (Get-FileHash -LiteralPath $winner.Path -Algorithm SHA256).Hash.ToLower()
Write-Host ('WINNER (lowest index holding the file): [{0}] {1}' -f $winner.Index, $winner.Name)
Write-Host "  path : $($winner.Path)"
Write-Host "  size : $((Get-Item -LiteralPath $winner.Path).Length) bytes"
Write-Host "  hash : $hash"

# Warn about anything that would shadow the winner if reordered above it.
$shadowers = $ovl | Where-Object {
    $_.Index -gt $winner.Index -and
    (Test-Path -LiteralPath (Join-Path $root (Join-Path $_.Name $DatPath)))
}
if ($shadowers) {
    Write-Host ''
    Write-Host ('  also carrying this file, currently below: ' +
        (($shadowers | ForEach-Object { "[$($_.Index)] $($_.Name)" }) -join ', '))
}

if ($PSBoundParameters.ContainsKey('ExpectHash')) {
    $want = $ExpectHash.ToLower()
    Write-Host "  want : $want"
    if ($hash -ne $want) {
        Write-Host ''
        Write-Host 'FAIL: winning file does not match the expected hash'
        exit 1
    }
}

Write-Host ''
Write-Host 'ALL CHECKS PASSED'
