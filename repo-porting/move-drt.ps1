# /*
#  * This is an archived script that combined sanitize and codeformatter. However, it doesn't seem to work on my system.
#  * Therefore developed other scripts to do the same thing.
#  */

[CmdletBinding(PositionalBinding=$false)]
Param(
    [string][Alias('b')]$branchName,
    [string][Alias('t')]$relativeTestDirPath,
    [string][Alias('r')]$repoPortingDir
)

$cleanDir = "D:\repos\public-test\clean\";
$publicDir = "D:\repos\public-test\";
$intDir = "D:\repos\int-test\";

$sourcePath = Join-Path $intDir $relativeTestDirPath;
$destinationPath = Join-Path $publicDir $relativeTestDirPath;
$cleanPath = Join-Path $cleanDir $branchName;

Write-Output $relativeTestDirPath, $destinationPath, $cleanPath;

# Process
Set-Location $publicDir;
git checkout main;
# git pull origin main;
git branch $branchName;
git checkout $branchName;
Write-Output("Branch $branchName created");

xcopy.exe $sourcePath $destinationPath /S;
Write-Output( "File copied to public directory ");

$commitMsg = -Join ("Added ", $branchName.replace('-',' ').replace('_', ' '));
git stage --all;
git reset ".\move-drt.ps1";
git commit -m $commitMsg;
Write-Output( "Initial commit of files done ");

$sanitizeToolDir = Join-Path $repoPortingDir "Sanitize";
Write-Output("In $sanitizeToolDir");

Set-Location $sanitizeToolDir;

$trimmedDestinationPath = $destinationPath.TrimEnd('\');
$trimmedCleanPath = $cleanPath.TrimEnd('\');
.\sanitize.ps1 $trimmedDestinationPath $trimmedCleanPath;

# $codeFormattingDir = Join-Path $repoPortingDir "CodeFormatter";
# $formattingProjFile = Join-Path $codeFormattingDir "CodeFormatting.csproj";

# Set-Location $codeFormattingDir;
# .\CodeFormatter.exe  $formattingProjFile /verbose /rule-:BraceNewLine,NewLineAbove,UnicodeLiterals,UsingLocation,ExplicitThis,ExplicitVisibility,FormatDocument,ReadonlyFields,FieldNames,CustomCopyright /copyright+;

Remove-Item $destinationPath -Recurse;
xcopy.exe $cleanPath $destinationPath /S;
Remove-Item $cleanPath -Recurse
Set-Location $publicDir;