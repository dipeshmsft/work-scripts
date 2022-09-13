
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

## TODO Items :
## 1. razzle command
## 2. build parallel
## 3. replace binaries ( all / not all required )