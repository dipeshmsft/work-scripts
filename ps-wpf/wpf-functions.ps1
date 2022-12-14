
### Cloner - Clone various WPF and related repos directly
function cloner {
    Param(
        [Parameter(Mandatory=$true)][string]$repoKey,
        [Parameter(Mandatory=$true)][string]$dirName
    )

    switch ($repoKey) {
        "wpf" { $repoUrl="https://github.com/dotnet/wpf.git" }
        "winforms" { $repoUrl="https://github.com/dotnet/winforms.git" }
        "wpf-int" { $repoUrl="https://dnceng@dev.azure.com/dnceng/internal/_git/dotnet-wpf-int" }
        "wpf-test" { $repoUrl="https://github.com/dotnet/wpf-test.git" }
        "int-test" { $repoUrl="https://dnceng@dev.azure.com/dnceng/internal/_git/dotnet-wpf-test-internal" }
        "pub-test" {  $repoUrl="https://dnceng@dev.azure.com/dnceng/internal/_git/dotnet-wpf-test-public"  }
        "wpf-samples" {  $repoUrl="https://github.com/Microsoft/WPF-Samples.git" }
        "default" { $repoUrl="" }
    }

    if ($repoUrl){
        git clone $repoUrl $dirName
    }
    else {
        throw "No entry for the name : $repoKey. Options : [ wpf, winforms, wpf-int, wpf-test, int-test, pub-test, wpf-samples ]"
    }
}

### Razzle - Runs the razzle window given the parameters
function razzle {
	Param(
		[Parameter(Mandatory=$true)][string]$enlistmentName,
		[Parameter(Mandatory=$true)][string]$configuration,
		[Parameter(Mandatory=$true)][string]$platform
	)

	$razzlePathParts = ("E:\dd\", $enlistmentName, "\src\Tools\razzle.cmd")
	$razzlePath = $razzlePathParts -join ""

	C:\Windows\SysWOW64\cmd.exe /k $razzlePath $configuration $platform no_oacr title "NetFxDev1-x86"
}

function zipfxbins {
    # To be tested
    # Add fxcode in the zip as well 
    Param(
		[Parameter(Mandatory=$true)][string]$enlistmentName,
		[Parameter(Mandatory=$true)][string]$configuration,
        [Parameter(Mandatory=$true)][string]$archivePath
	)
    
    $binPathParts = ("E:\dd\binaries\", $enlistmentName, "\*{$configuration}")
    $binPath = $binPathParts -join ""

    Compress-Archive $binPath $archivePath
}

## TODO Items :

### Replace Binaries - Run this function to copy the debug binaries to the right .NET SDK shared destination
# What is the funtion of this ?
# Input : repo-root , net-tfm , destination-dir
# Helpers : wdk-dirs ( Utility function to see all the installed sdk in windowsdesktop )
# How to use it ?
#   1. Use wdk-dirs to get all the installed directory. Choose one as destination-dir
#   2. Use replace binary to replace the build 
#       a. this makes a new dir 
#       b. copies original binaries to new dir
#       c. replace debug binaries in the original location

### Revert Binaries - Run this function to revert the steps taken by the Replace binaries function

### Utility to replace/switch directory from a parent directory
# Purpose : 
#   Current : E:\dd\binaries\netfxdev1\amd64ret\wpf\
#   New     : E:\dd\binaries\net472rel1last_c\x86chk\wpf
#
# Rather than this, we should set some environment variables to switching to these paths.
#   netfx-binary-root , netfx-enlistment-root ??
#   shared-location of installation ??
