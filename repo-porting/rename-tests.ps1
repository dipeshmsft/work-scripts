Param(
    [string][Alias('s')]$searchName,
    [string][Alias('n')]$regressionId
)

$changedName = "RegressionTest" + $regressionId

Get-ChildItem *$searchName* -Recurse | ForEach-Object { Rename-Item -Path $_.PSPath -NewName $_.Name.Replace($searchName, $changedName) }

ForEach ($file in (Get-ChildItem -Recurse -File))
{
    $contains = Select-String -Path $file -Pattern $searchName
    if ($null -ne $contains)
    {
        (Get-Content $file) -Replace $searchName,$changedName | Set-Content $file
    }
}

Write-Output("Renamed $searchName to $changedName")