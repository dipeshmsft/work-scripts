[CmdletBinding(PositionalBinding=$false)]
Param(
    [string][Alias('p')]$repoRoot,
    [string][Alias('d')]$testRootDir,
    [string[]][Alias('f')]$frameworkVersions

)

#### List of all WPF Project Templates
$wpfTemplates = @(
    @("WpfApplication-CSharp", "wpf"),
    @("WpfApplication-VisualBasic", "wpf-vb"),
    @("WpfClassLibrary-CSharp", "wpflib"),
    @("WpfClassLibrary-VisualBasic", "wpflib-vb"),
    @("WpfCustomControlLibrary-CSharp", "wpfcustomcontrollib"),
    @("WpfCustomControlLibrary-VisualBasic", "wpfcustomcontrollib-vb"),
    @("WpfUserControlLibrary-CSharp", "wpfusercontrollib"),
    @("WpfUserControlLibrary-VisualBasic", "wpfusercontrollib-vb")
)

$templateRoot = Join-Path $repoRoot "packaging\Microsoft.Dotnet.Wpf.ProjectTemplates\content"

if( -not(Test-Path -Path $testRootDir -PathType Container))
{
    New-Item -Path $testRootDir -ItemType Directory
}

#### Testing Templates

# 1. Installing template 
foreach( $template in $wpfTemplates)
{

    $templatePath = Join-Path $templateRoot $template[0]
    $templateName = $template[1]

    $dotnetTemplateName = $templateName
    $language = "C#"

    if ($templateName.EndsWith("-vb"))
    {
        $dotnetTemplateName = $templateName.Replace("-vb", "")
        $language = "VB"
    }

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
        
        dotnet new $dotnetTemplateName -n $projectName --framework $framework --language $language
        dotnet sln $slnFile add $projectName
    }

    Pop-Location

    # 3. Uninstalling the templates
    dotnet new -u $templatePath
}