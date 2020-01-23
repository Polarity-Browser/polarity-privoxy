<#
    Get block lists.
#>
$files = ""
rm -r data
If(!(test-path ".\data")) {
    mkdir data
}
foreach ($line in Get-Content .\block-lists.txt) {
    if ($line -match '\/[a-zA-Z-]+\.txt') {
        $name = $matches[0].substring(1)
        $res=Invoke-WebRequest $line
        New-Item -Path . -Name (".\data\" + $name)-ItemType "file" -Value $res.ParsedHtml.body.innerText
        $files = $files + ".\data\" + $name + " "
    }
}
$files = $files.substring(0, $files.length - 1)

<#
    Generate actions and filters.
#>
If(!(test-path ".\out")) {
    mkdir out
}
$cmd = "& bin/adblock2privoxy.exe -p .\out $files"
iex $cmd