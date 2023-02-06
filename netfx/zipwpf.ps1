Param(
    [string][Alias('d')]$destinationDirName
)

$binaryRoot="E:\dd\binaries"
$branchBinaryRoot="E:\dd\binaries\netfxdev1"
$srcPath="E:\dd\NetFXDev1\src\wpf\src"

$builds=@('amd64chk', 'x86chk')

$destinationDir = Join-Path $binaryRoot $destinationDirName

if( -not(Test-Path -Path $destinationDir -PathType Container))
{
    New-Item -Path $destinationDir -ItemType Directory
}

foreach($build in $builds)
{
    $leafDir = Join-Path $branchBinaryRoot $build
    if( -not(Test-Path -Path $leafDir -PathType Container))
    {
        Write-Error("Build : $build not present...")
    }
    Write-Output("Copying build from $leafDir ...")
    Copy-Item $leafDir $destinationDir -Recurse    
}

Write-Output("Copying source files from $srcPath ...")
Copy-Item $srcPath $destinationDir -Recurse

$archiveName = -Join ($destinationDirName, ".zip")
$archivePath = Join-Path $binaryRoot $archiveName

Write-Output("Compressing to zip file $archiveName")
Compress-Archive $destinationDir $archivePath

Write-Output("Removing $destinationDir ...")
Remove-Item $destinationDir -Recurse