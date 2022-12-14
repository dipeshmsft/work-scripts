Set-Alias vs devenv

## ------------------------ ##
##    Common Git Aliases    ##
## ------------------------ ##
Set-Alias -Name g -Value git

Function git-add { git add $args }
Set-Alias -Name ga -Value git-add

Function git-add-all { git add -A }
Set-Alias -Name gaa -Value git-add-all

Function git-log { git log --oneline $args }
Set-Alias -Name gll -Value git-log

Function git-del { git branch -D $args }
Set-Alias -Name gdel -Value git-del

Function git-branch { git branch $args }
Set-Alias -Name gb -Value git-branch

Function git-branch-all { git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate }
Set-Alias -Name gbr -Value git-branch-all

Function git-checkout { git checkout $args }
Set-Alias -Name gco -Value git-checkout

Function git-checkout-new-branch { git checkout -b $args }
Set-Alias -Name gcob -Value git-checkout-new-branch

Function git-fetch { git fetch $args }
Set-Alias -Name gf -Value git-fetch

Function git-commit { git commit -m $args }
Set-Alias -Name com -Value git-commit

Function git-cherrypick { git cherry-pick -r  $args }
Set-Alias -Name gcp -Value git-cherrypick

Function git-merge { git merge $args }
Set-Alias -Name merge -Value git-merge

Function git-merge-no-fast-forward { git merge --no-ff $args }
Set-Alias -Name gmnf -Value git-merge-no-fast-forward

Function git-pull { git pull $args }
Set-Alias -Name pull -Value git-pull

Function git-remote { git remote $args }
Set-Alias -Name gr -Value git-remote

Function git-status { git status -sb }
Set-Alias -Name gs -Value git-status

Function git-push { git push $args }
Set-Alias -Name push -Value git-push

## Git Diff Aliases ??

## --------------------------------------------------------------------------------------- ##
#### Common Aliases


## 1. File Manipulation Aliases
## ----------------------------------------- ##
Function touch-alias {
    foreach ( $arg in $args ) { Write-Output $NULL | Out-File $arg }
}
Set-Alias -Name touch -Value touch-alias


### 2. Directory Navigation Aliases
## ----------------------------------------- ##
Function mkcd-alias {
    mkdir $arg
    Set-Location $arg
}
Set-Alias -Name mkcd -Value mkcd-alias

Function cd.. { 
    [CmdletBinding()]
    Param(
        [int][Alias('times')]$arg = 1
    )
    $i=0
    while($i -lt $arg){
        cd ..
        $i+=1
    }
}
Set-Alias -Name .. -Value cd..

Function cd... { cd.. -times 2 }
Set-Alias -Name ... -Value cd...

Function cd.... { cd.. -times 3 }
Set-Alias -Name .... -Value cd....

Set-Alias -Name l -Value Get-ChildItem

Function Set-AndListLocation { Set-Location $arg | Get-ChildItem }
Set-Alias -Name cl -Value Set-AndListLocation

### 3. Executable-Based Aliases
## ----------------------------------------- ##
Function Open-ExplorerHere { explorer.exe . }
Set-Alias -Name e. -Value Open-ExplorerHere

Function Open-VSCodeHere { code . }
Set-Alias -Name c. -Value Open-VSCodeHere

Set-Alias -Name apps -Value appwiz.cpl
Set-Alias -Name note -Value notepad.exe

### 4. General Aliases
## ----------------------------------------- ##
Set-Alias -Name c -Value cls

## --------------------------------------------------------------------------------------- ##
# TODO : 
# 1. Formatting Output in Powershell ??
# 2. Sorting and manipulating data in powershell
# 3. grep ~~ Select-String
