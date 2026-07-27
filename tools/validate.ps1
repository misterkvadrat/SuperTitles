$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$required = @(
    'descriptor.mod'
    'common\decisions\st_agot_restoration_decisions.txt'
    'common\decisions\st_supertitles_decisions.txt'
    'common\decisions\zz_supertitles\00_st_agot_petty_kingdom_overrides.txt'
    'common\flavorization\st_western_essos_titles.txt'
    'common\landed_titles\st_restoration_titles.txt'
    'common\on_action\st_title_on_actions.txt'
    'common\scripted_effects\st_title_effects.txt'
    'common\traits\st_augustus_trait.txt'
    'common\traits\zzzz_st_prince_of_princes_trait.txt'
    'events\st_western_essos_events.txt'
    'localization\english\st_supertitles_l_english.yml'
    'localization\russian\st_supertitles_l_russian.yml'
)

foreach ($relative in $required) {
    $path = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing required file: $relative"
    }
}

$scripts = Get-ChildItem -LiteralPath $root -Recurse -File |
    Where-Object { $_.Extension -eq '.txt' }
$scriptText = ($scripts | ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw }) -join "`n"
$descriptor = Get-Content -LiteralPath (Join-Path $root 'descriptor.mod') -Raw

if ($descriptor -notmatch 'name="SuperTitles"') {
    throw 'Descriptor does not use the SuperTitles name.'
}
if ($scriptText -notmatch 'create_dynamic_title\s*=\s*\{') {
    throw 'No dynamic title creation effect found.'
}
if ($scriptText -notmatch 'tier\s*=\s*hegemony') {
    throw 'Dynamic title is not hegemony tier.'
}
if ($scriptText -match 'replace_path') {
    throw 'replace_path found; vanilla/AGOT safety check failed.'
}
if ($scriptText -notmatch 'set_variable\s*=\s*st_western_essos_title') {
    throw 'Western Essos title marker is missing.'
}
if ($scriptText -notmatch 'has_variable\s*=\s*st_western_essos_title' -or
    $scriptText -notmatch 'add_trait\s*=\s*st_prince_of_princes') {
    throw 'Western Essos succession event is incomplete.'
}
if ($scriptText -notmatch 'st_prince_of_princes\s*=\s*\{' -or
    $scriptText -notmatch 'icon\s*=\s*augustus\.dds' -or
    $scriptText -notmatch 'monthly_influence\s*=\s*1\.5') {
    throw 'Prince of Princes trait is incomplete.'
}
if ($scriptText -notmatch 'quarterly_playable_pulse\s*=\s*\{' -or
    $scriptText -notmatch 'st_hoare_claims_initialized') {
    throw 'Existing-save migration is missing.'
}
if ($scriptText -notmatch 'st_high_prince_male\s*=\s*\{' -or
    $scriptText -notmatch 'flag\s*=\s*st_western_essos_ruler') {
    throw 'Western Essos ruler style is missing.'
}

$restorations = @(
    @{ Decision = 'st_restore_gulltown_lordship_decision'; Duchy = 'd_gulltown'; Title = 'k_gulltown'; Gold = 2000; Prestige = 750; Renown = 1000 }
    @{ Decision = 'st_restore_flints_finger_lordship_decision'; Duchy = 'd_flints_finger'; Title = 'k_flints_finger'; Gold = 600; Prestige = 750; Renown = 350 }
    @{ Decision = 'st_restore_bear_island_lordship_decision'; Duchy = 'd_bear_island'; Title = 'k_bear_island'; Gold = 500; Prestige = 1000; Renown = 400 }
    @{ Decision = 'st_restore_bronze_lordship_decision'; Duchy = 'd_runestone'; Title = 'k_runestone'; Gold = 1250; Prestige = 1500; Renown = 500 }
    @{ Decision = 'st_restore_sisters_lordship_decision'; Duchy = 'd_the_sisters'; Title = 'k_the_sisters'; Gold = 500; Prestige = 750; Renown = 250 }
    @{ Decision = 'st_restore_fair_isle_lordship_decision'; Duchy = 'd_fair_isle'; Title = 'k_fair_isle'; Gold = 750; Prestige = 1000; Renown = 500 }
)
foreach ($restoration in $restorations) {
    $decisionPattern = [regex]::Escape($restoration.Decision) + '\s*=\s*\{'
    if ($scriptText -notmatch $decisionPattern -or
        $scriptText -notmatch "has_title\s*=\s*title:$([regex]::Escape($restoration.Duchy))" -or
        $scriptText -notmatch "get_title\s*=\s*title:$([regex]::Escape($restoration.Title))" -or
        $scriptText -notmatch "gold\s*=\s*$($restoration.Gold)" -or
        $scriptText -notmatch "prestige\s*=\s*$($restoration.Prestige)" -or
        $scriptText -notmatch "add_dynasty_prestige\s*=\s*$($restoration.Renown)") {
        throw "Incomplete lordship restoration: $($restoration.Decision)"
    }
}

if ($scriptText -notmatch 'e_the_bite\s*=\s*\{' -or
    $scriptText -notmatch 'st_create_bite_empire_decision\s*=\s*\{' -or
    $scriptText -notmatch 'prestige_level\s*>=\s*4' -or
    $scriptText -notmatch 'has_title\s*=\s*title:k_the_white_knife' -or
    $scriptText -notmatch 'has_title\s*=\s*title:k_the_neck' -or
    $scriptText -notmatch 'has_title\s*=\s*title:k_the_bite' -or
    $scriptText -notmatch 'title:k_the_sisters\s*=\s*\{\s*is_title_created\s*=\s*no' -or
    $scriptText -notmatch 'set_de_jure_liege_title\s*=\s*title:h_the_iron_throne' -or
    $scriptText -notmatch 'set_primary_title_to\s*=\s*title:e_the_bite') {
    throw 'Bite empire decision is incomplete.'
}

if ($scriptText -match '(?<![A-Za-z0-9_])e_stepstones\s*=\s*\{' -or
    $scriptText -notmatch 'h_hand_kingdom\s*=\s*\{' -or
    $scriptText -notmatch 'completely_controls\s*=\s*title:k_the_stepstones' -or
    $scriptText -notmatch 'government_is_pirate_trigger_check' -or
    $scriptText -notmatch 'set_variable\s*=\s*st_dornish_stepstones_restored' -or
    $scriptText -notmatch 'set_de_jure_liege_title\s*=\s*title:e_dorne' -or
    $scriptText -notmatch 'completely_controls\s*=\s*title:e_narrow_sea' -or
    $scriptText -notmatch 'set_primary_title_to\s*=\s*title:h_hand_kingdom') {
    throw 'Dornish Stepstones/Kingdom of the Hand chain is incomplete.'
}

$claims = @{
    'dynn_Reyne' = 'e_the_westerlands'
    'dynn_Gardener' = 'e_the_reach'
    'dynn_Durrandon' = 'e_the_stormlands'
    'dynn_Hoare' = 'e_the_iron_islands'
}
foreach ($entry in $claims.GetEnumerator()) {
    if ($scriptText -notmatch [regex]::Escape($entry.Key) -or
        $scriptText -notmatch "add_pressed_claim\s*=\s*title:$([regex]::Escape($entry.Value))") {
        throw "Missing revival claim mapping: $($entry.Key) -> $($entry.Value)"
    }
}
if ($scriptText -notmatch 'add_pressed_claim\s*=\s*title:e_the_riverlands') {
    throw 'House Hoare lacks its Riverlands pressed claim.'
}

foreach ($file in $scripts) {
    $text = Get-Content -LiteralPath $file.FullName -Raw
    $balance = 0
    foreach ($char in $text.ToCharArray()) {
        if ($char -eq '{') { $balance++ }
        elseif ($char -eq '}') { $balance-- }
        if ($balance -lt 0) {
            throw "Closing brace without matching opening brace: $($file.FullName)"
        }
    }
    if ($balance -ne 0) {
        throw "Unbalanced braces ($balance): $($file.FullName)"
    }
}

$encodedFiles = $scripts + @(
    Get-Item -LiteralPath (Join-Path $root 'localization\english\st_supertitles_l_english.yml')
    Get-Item -LiteralPath (Join-Path $root 'localization\russian\st_supertitles_l_russian.yml')
)
foreach ($file in $encodedFiles) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($bytes.Length -lt 3 -or $bytes[0] -ne 0xEF -or $bytes[1] -ne 0xBB -or $bytes[2] -ne 0xBF) {
        throw "CK3 script/localization must be UTF-8 BOM: $($file.FullName)"
    }
}

Write-Host 'OK: structure, braces, encoding, claims, lordship restorations, Dorne chain, ruler style, migration, and succession validated.'
