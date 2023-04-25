cd $PSScriptRoot
$Core = 'Value at core'

$Shell = '$Core'

# start - 'here string' declaration
$DynPS = @"
$Shell
`$Shell
$Shell = 'Shell value changed'
$Shell
"@
# end - 'here string'
$DynPS > tmp.ps1
. .\tmp.ps1