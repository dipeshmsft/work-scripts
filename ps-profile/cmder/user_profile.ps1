# Use this file to run your own startup commands

## Prompt Customization
<#
.SYNTAX
    <PrePrompt><CMDER DEFAULT>
    λ <PostPrompt> <repl input>
.EXAMPLE
    <PrePrompt>N:\Documents\src\cmder [master]
    λ <PostPrompt> |
#>

$kaomojis=@("^_^", "*_*", "+_+", "~_~", "#_#", ":-P", "@_@", "=_=", ";-P", "o_o")

[ScriptBlock]$PrePrompt = {

  # Get Kaomoji for the previous command
  $kIndex=((Get-Date).Second % 10)
  $kaomoji=($kaomojis[$kIndex])
  $kaomojitring=("$kaomoji || ")
  Write-Host $kaomojitring -NoNewLine -ForegroundColor White

  # Get Execution Time for the last command
  $executionTime = ((Get-History)[-1].EndExecutionTime - (Get-History)[-1].StartExecutionTime).TotalSeconds
  $time = [math]::Round($executionTime,2)
  $promptString = ("$time s || ")
  Write-Host $promptString -NoNewline -ForegroundColor yellow
  return " "
}

# Replace the cmder prompt entirely with this.
# [ScriptBlock]$CmderPrompt = {}

[ScriptBlock]$PostPrompt = {

}

## <Continue to add your own>

# # Delete default powershell aliases that conflict with bash commands
# if (get-command git) {
#     del -force alias:cat
#     del -force alias:clear
#     del -force alias:cp
#     del -force alias:diff
#     del -force alias:echo
#     del -force alias:kill
#     del -force alias:ls
#     del -force alias:mv
#     del -force alias:ps
#     del -force alias:pwd
#     del -force alias:rm
#     del -force alias:sleep
#     del -force alias:tee
# }


## Add path to your custom PowerShell Profile

$PsProfile="C:\tools\powershell\profile.ps1"
. $PsProfile

