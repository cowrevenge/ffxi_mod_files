$ErrorActionPreference = 'Stop'
$ini  = 'C:\PhoenixXI\config\pivot\pivot.ini'
$root = $null
$ovl  = New-Object System.Collections.Generic.List[object]

foreach ($l in [IO.File]::ReadAllLines($ini)) {
    if ($l -match '^root_path\s*=\s*(.+?)\s*$') { $root = $Matches[1] }
    elseif ($l -match '^\s*(\d+)\s*=\s*(.+?)\s*$') {
        $ovl.Add([pscustomobject]@{ Index = [int]$Matches[1]; Name = $Matches[2] })
    }
}

Write-Host "root_path = $root"
Write-Host ""

$winner = $null
foreach ($o in ($ovl | Sort-Object Index)) {
    $p    = Join-Path $root (Join-Path $o.Name 'ROM\5\15.DAT')
    $has  = Test-Path -LiteralPath $p
    $mark = if ($has) { 'PRESENT' } else { '-' }
    Write-Host ("  [{0}] {1,-22} ROM\5\15.DAT -> {2}" -f $o.Index, $o.Name, $mark)
    if ($has -and $null -eq $winner) {
        $winner = [pscustomobject]@{ Index = $o.Index; Name = $o.Name; Path = $p }
    }
}

Write-Host ""
if ($null -eq $winner) {
    Write-Host 'FAIL: no overlay supplies ROM\5\15.DAT'
    exit 1
}

$hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $winner.Path).Hash.ToLower()
$want = '86f9a5b7c83614b49c3e7a71dd93e0143e157a2fd4b53c5c12ec46d6ff561ad3'

Write-Host "WINNER (lowest index holding the file): [$($winner.Index)] $($winner.Name)"
Write-Host "  path : $($winner.Path)"
Write-Host "  size : $((Get-Item -LiteralPath $winner.Path).Length) bytes"
Write-Host "  hash : $hash"
Write-Host "  want : $want"
Write-Host ""
if ($hash -ne $want) { Write-Host 'FAIL: hash mismatch'; exit 1 }

# NextHD must be strictly after the winner, or the mod is shadowed
$nx = $ovl | Where-Object { $_.Name -eq 'NextHD' } | Select-Object -First 1
if ($null -ne $nx) {
    if ($nx.Index -gt $winner.Index) { Write-Host "OK: NextHD [$($nx.Index)] is AFTER winner [$($winner.Index)], so the mod wins." }
    else { Write-Host "FAIL: NextHD [$($nx.Index)] would shadow the mod."; exit 1 }
}
Write-Host 'ALL CHECKS PASSED'
