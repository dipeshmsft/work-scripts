[CmdletBinding(PositionalBinding=$false)]
Param(
    [string][Alias('p')]$templatePath,
    [string][Alias('n')]$templateName,
    [string][Alias('d')]$testRootDir,
    [string[]][Alias('f')]$frameworkVersions

)

#### Testing Templates

# 1. Installing template 
try{
    dotnet new -i $templatePath
}
catch {
    Write-Output "Trouble installing $templateName template !! Still breaking things :-( !! Not expected -_-"
    Exit
}

# 2. Create Applications or controls for different framework version
Push-Location $testRootDir


if ( -not(Test-Path -Path "TestTemplates.sln" )){
    dotnet new sln --name "TestTemplates"
}

foreach($framework in $frameworkVersions){
    $projectName = $templateName + "-" + $framework
    dotnet new $templateName -n $projectName --framework $framework
    dotnet sln $slnFile add $projectName
}

Pop-Location

# 3. Uninstalling the templates
dotnet new -u $templatePath