Param(
    [string][Alias('n')]$fileName
)

$file = Get-ITem $fileName

$failedTestFile = Join-Path $file.DirectoryName "failed-tests.txt"
$skippedTestFile = Join-Path $file.DirectoryName "skipped-tests.txt"

$collectionNodes = Select-Xml -Path $fileName -XPath "/assemblies/assembly/collection"


ForEach ($testNode in $collectionNodes)
{
    if($testNode.Node.failed -ne "0")
    {
        Add-Content -Path $failedTestFile -Value $testNode.Node.name
    }
    else
    {
        if($testNode.Node.passed -eq "0")
        {
            Add-Content -Path $skippedTestFile -Value $testNode.Node.name
        }
    }

}