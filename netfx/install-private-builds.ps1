Param(
    [string][Alias('p')]$rootBinDir,
    [string[]][Alias('a')]$assemblies,
    [switch]$revert,
    [switch]$nativeonly
)

$locations=@("C:\Windows\assembly", "C:\Windows\Microsoft.NET\assembly")
$defaultAssemblies=@("PresentationFramework.dll", "PresentationCore.dll", "WindowsBase.dll")


# Check if the assemblies are not null
if($assemblies.count -eq 0){
    Write-Output("Assemblies list is empty. Setting to default ...")
    $assemblies = $defaultAssemblies
}

if(!$nativeonly)
{
    # Resolve rootBinDir
    if ($rootBinDir -eq "")
    {
        Write-Error("rootBinDir param is null. Use -p <rootBinDir>")
        exit
    }

    $rootBinDir = Resolve-Path $rootBinDir
    if( -not(Test-Path -Path $rootBinDir -PathType Container))
    {
        Write-Error("Directory doesn't exist : $rootBinDir")
        exit
    }

    Write-Output("Assemblies : $assemblies")
    foreach($assembly in $assemblies)
    {
        $asm = Join-Path $rootBinDir $assembly
        if( -not(Test-Path -Path $asm -PathType Leaf))
        {
            Write-Output("Private assembly not found : $asm ")
            exit
        }
    }
    Write-Output("  ")
}

Push-Location "C:\Windows\"

if ($revert) 
{
    Write-Output("Removing private binaries ...")
    foreach($location in $locations)
    {
        Write-Output("Looking in location : $location")
        Push-Location $location
        foreach($assembly in $assemblies)
        {
            $native = $assembly.Replace(".dll", ".ni.dll.orig")
            Write-Output("Renaming native assembly : $native" + " -> " + $native.Replace(".dll.orig", ".dll"))
            
            $nativeAsms = Get-ChildItem $native -Recurse -ErrorAction SilentlyContinue
            foreach($nativeAsm in $nativeAsms)
            {
                Write-Output("    " + $nativeAsm.PSPath)
                Rename-Item -Path $nativeAsm.PSPath -NewName $nativeAsm.Name.Replace(".ni.dll.orig", ".ni.dll")
            }
        }
        Pop-Location
    }
        
    Push-Location "C:\Windows\Microsoft.NET\assembly"

    if (!$nativeonly)
    {
        foreach($assembly in $assemblies)
        {
            $origAssembly = $assembly.Replace(".dll", ".dll.orig")
            $asms =  Get-ChildItem $origAssembly -Recurse -ErrorAction SilentlyContinue
            
            Write-Output("Removing private build : $assembly")
            Write-Output("Renaming original assembly : $origAssembly")
            foreach($asm in $asms)
            {
                Write-Output("    " + $asm.PSPath)
                $parentDir = Split-Path -Path $asm
                $privateAsm = Join-Path $parentDir $assembly
                
                Write-Output($privateAsm)
                if ( Test-Path -Path $privateAsm -PathType Leaf )
                {
                    Remove-Item $privateAsm
                }
                Rename-Item -Path $asm.PSPath -NewName $asm.Name.Replace(".dll.orig", ".dll")
            }
        }
    }
        
    Pop-Location
}
else
{
    Write-Output("Adding private binaries ...")

    foreach($location in $locations)
    {
        Write-Output("Looking in location : $location")
        Push-Location $location
        foreach($assembly in $assemblies)
        {
            $native = $assembly.Replace(".dll", ".ni.dll")
            Write-Output("Renaming native assembly : $native" + " -> " + $native.Replace(".dll", ".dll.orig"))

            $nativeAsms = Get-ChildItem $native -Recurse -ErrorAction SilentlyContinue
            foreach($nativeAsm in $nativeAsms)
            {
                Write-Output("    " + $nativeAsm.PSPath)
                Rename-Item -Path $nativeAsm.PSPath -NewName $nativeAsm.Name.Replace(".ni.dll", ".ni.dll.orig")
            }
        }
        Pop-Location
    }
    
    Push-Location "C:\Windows\Microsoft.NET\assembly"
    
    if (!$nativeonly)
    {
        Write-Output("Replacing original binaries with private build binaries ...")
        foreach($assembly in $assemblies)
        {
            $privateAsm = Join-Path $rootBinDir $assembly
            Write-Output("Renaming system assembly : $assembly")
            Write-Output("Copying private build : $privateAsm")

            $asms =  Get-ChildItem $assembly -Recurse -ErrorAction SilentlyContinue
            foreach($asm in $asms)
            {
                Write-Output("    " + $asm.PSPath)

                $parentDir = Split-Path -Path $asm
                $newAsmName = $asm.Name.Replace(".dll", ".dll.orig")
                $origAssembly = Join-Path $parentDir $newAsmName   
                
                if( -not(Test-Path -Path $origAssembly -PathType Leaf))
                {
                    Rename-Item -Path $asm.PSPath -NewName $newAsmName
                }

                Copy-Item $privateAsm -Destination $asm.PSPath
            }
        }
    }
    Pop-Location
}

Pop-Location