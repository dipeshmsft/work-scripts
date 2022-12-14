# Need to use the functions the right way
# For now it is in working state
# There are some issues as well : what if the build fails due to flaky reasons ?
# There is no way to handle this right now.

Param(
    [string][Alias('r')]$repoPath,
    [string][Alias('p')]$platform = "x86",
    [string][Alias('c')]$configuration = "Debug",
    [string][Alias('d')]$destinationBasePath,
    [string][Alias('h')]$commitsList
)

# Helper Functions
function Build-Wpf {
    param (
        [Parameter(Mandatory=$True, Position=0)][string] $repoPath,
        [Parameter(Mandatory=$True, Position=1)][string] $platform,
        [Parameter(Mandatory=$True, Position=2)][string] $configuration
    )

    Push-Location $repoPath;
    # git clean -xdf
    .\build.cmd -plat $platform -conf $configuration;
    Pop-Location;
}

function Copy-Binaries {
    param(
        [Parameter(Mandatory=$True, Position=0)][string] $repoPath,
        [Parameter(Mandatory=$True, Position=1)][string] $platform,
        [Parameter(Mandatory=$True, Position=2)][string] $configuration,
        [Parameter(Mandatory=$True, Position=3)][string] $destinationPath        
    )

    $binariesPath = $repoPath + "\artifacts\packaging\" + $configuration;
    if ($platform -eq "x64") {
        $binariesPath = $binariesPath + "\x64"
    } 
    $binariesPath = $binariesPath + "\Microsoft.DotNet.Wpf.GitHub.Debug\lib\*"
    Copy-Item $binariesPath $destinationPath -Recurse
}

function Build-And-Copy-Recursively {
    param (
        [Parameter(Mandatory=$True, Position=0)][string] $repoPath,
        [Parameter(Mandatory=$True, Position=1)][string] $platform,
        [Parameter(Mandatory=$True, Position=2)][string] $configuration,
        [Parameter(Mandatory=$True, Position=3)][string] $destinationBasePath,
        [Parameter(Mandatory=$True, Position=4)][string] $commitsList
    )

    Push-Location $repoPath
    git clean -xdf

    $commitHashes=@()
    if( -not(Test-Path -Path $commitsList -PathType Leaf)){
        Write-Error "{$commitsList} is not present"
        exit;
    }
    else {
        $file = Get-Content $commitsList;
        foreach ( $line in $file){
            $commitHashes+=$line;
        }
    }
    
    $count = $commitHashes.Length;

    $i=0;
    foreach($commit in $commitHashes){
        $order = $count - $i;
        $destinationPath = $destinationBasePath + "{$order}_{$commit}\";
        mkdir $destinationPath;
        # Build-Wpf($repoPath, $platform, $configuration);
        # Copy-Binaries($repoPath, $platform, $configuration,$destinationPath)
        $i += 1;
    }

    Pop-Location;   
}


if ( -not(Test-Path -Path $repoPath -PathType Container)){
    Write-Error "Repository does not exist at {$repoPath}"
    exit
}

if( -not(Test-Path -Path $destinationBasePath -PathType Container)){
    mkdir $destinationBasePath
}

# Build-And-Copy-Recursively($repoPath, $platform, $configuration, $destinationBasePath, $commitsList)
Push-Location $repoPath
git clean -xdf

$commitHashes=@()
if( -not(Test-Path -Path $commitsList -PathType Leaf)){
    Write-Error "$commitsList is not present"
    exit;
}
else {
    $file = Get-Content $commitsList;
    foreach ( $line in $file){
        $commitHashes+=$line;
    }
}

$count = $commitHashes.Length;

$binariesPath = $repoPath + "\artifacts\packaging\" + $configuration;
if ($platform -eq "x64") {
    $binariesPath = $binariesPath + "\x64"
} 
$binariesPath = $binariesPath + "\Microsoft.DotNet.Wpf.GitHub.Debug\lib\*"

$i=0;
foreach($commit in $commitHashes){
    $order = $count - $i;
    $dirName  = $order.ToString() + "_" + $commit.ToString();
    $destinationPath = Join-Path $destinationBasePath $dirName;
    if( -not(Test-Path $destinationPath)){
        mkdir $destinationPath;
    }
    # Build-Wpf($repoPath, $platform, $configuration);
    .\build.cmd -plat $platform -conf $configuration;

    # Copy-Binaries($repoPath, $platform, $configuration,$destinationPath)
    Copy-Item $binariesPath $destinationPath -Recurse

    $i += 1;
}

Pop-Location; 