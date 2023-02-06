Param(
    [string][Alias('p')]$privateBuildRoot,
    [string[]][Alias('b')]$branches
)

$binaryRoot="E:\dd\binaries"
$builds=@('amd64ret', 'x86ret')

$assemblies=@("PresentationFramework", "PresentationCore", "WindowsBase")

$currLocation = Get-Location

if( -not(Test-Path -Path $privateBuildRoot -PathType Container))
{
    New-Item -Path $privateBuildRoot -ItemType Directory
}

# Creating the directory structure
foreach($branch in $branches)
{
    foreach($build in $builds){
        $leafDir = Join-Path $privateBuildRoot $branch $build
        if( -not(Test-Path -Path $leafDir -PathType Container))
        {
            New-Item -Path $leafDir -ItemType Directory
        }
    }
}

# Copying the binaries and symbols
foreach($branch in $branches)
{
    $branchFullName = -Join ($branch, "rel1last_c")
    foreach($build in $builds){
        $leafDir = Join-Path $privateBuildRoot $branch $build
        if( -not(Test-Path -Path $leafDir -PathType Container))
        {
            Write-Output("Directory not present : $leafDir")
        }

        $binaryPath = Join-Path $binaryRoot $branchFullName $build "wpf"
        Set-Location $binaryPath
        foreach($assembly in $assemblies)
        {
            $assemblyName = -Join ($assembly, ".dll")
            Copy-Item $assemblyName $leafDir
        }

        $symbolPath = Join-Path $binaryRoot $branchFullName $build "Symbols.pri\retail\dll"
        Set-Location $symbolPath
        foreach($assembly in $assemblies)
        {
            $assemblyName = -Join ($assembly, ".pdb")
            Copy-Item $assemblyName $leafDir
        }
    }
}

Set-Location $currLocation