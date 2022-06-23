Param(     
    [string][Alias('n')]$ctpBranchName,
    [string[]][Alias('p')]$prs 
)


git checkout $ctpBranchName

#Check if PR merged status file is present
$mergedPrs=@()
if( -not(Test-Path -Path "..\merged.txt" -PathType Leaf ))
{
    New-Item -Path "..\merged.txt" -ItemType File;
    Write-Output("Created file ..\merged.txt");
}
else
{
    $file = Get-Content "..\merged.txt";
    foreach ( $line in $file ) 
    {
        $mergedPrs+=$line;
    }
}
Write-Output("Read the ..\merged.txt file");

#Start Recusrive Merging
foreach( $pr in $prs ) 
{
    if($pr -in $mergedPrs)
    {
        Write-Output("PR $pr laready merged")
        continue
    }
    
    Add-Content "..\merged.txt" "`n$pr";
    $mergedPrs+=$pr;

    git merge pr-$pr;
    
    if ( -not $? )
    {
        Write-Output("Merging failed here. Manually merge it, and run the command again")
        exit
    }
}
