## Helper scripts for WPF ( .NET Fx ) processes
Some information about the helper scripts for .NET Fx processes

### **install-private-builds.ps1**
  
```
.\install-private-builds.ps1 -nativeonly -revert -p <path-to-bin-dir> -a
```

The script 'install-private-build.ps1' works as follows:
1. Rename all the nativeimages for specified assemblies. On renaming native images, applications will load dlls from GAC_xx ( 64 \ MSIL \ 32 ) directories.
2. Renames assemblies in GAC and replaces them with private build assemblies.

#### **Parameters**
- **-nativeonly** : On setting this parameter, only the native assemblies will be renamed.
- **-revert** : Allows revering the process of renaming. Use this to revert to the original state.
- **-p path-to-bin-dir** : Specifies the directory from where to copy the private assemblies. 
- **-a asm1.dll, asm2.dll, ...**: List of assemblies that we want to replace. If we don't provide this parameter, a default list of assemblies is considered which includes : PresentationFramework.dll, PresentationCore.dll, WindowsBase.dll

#### **Usage Examples**

1. **Renaming native images and reverting**

    `.\install-private-builds.ps1 -nativeonly`

    `.\install-private-builds.ps1 -nativeonly -a PresentationFramework.dll`

    Renames the native assemblies from _asm.ni.dll_ to _asm.ni.dll.orig_
    
    Add the `-revert` parameter to reverse the renaming process ( i.e. from _asm.ni.dll.orig_ to _asm.ni.dll_ ). 
    ```
    .\install-private-builds.ps1 -nativeonly -revert
    .\install-private-builds.ps1 -nativeonly -revert -a PresentationFramework.dll
    ```

2. **Replacing GAC binaries with private builds**

    `.\install-private-builds.ps1 -r E:\dts-fixes\1655943\net481\amd64ret\`

    Replaces the assemblies in GAC with the ones present in `E:\dts-fixes\1655943\net481\amd64ret\`. Assemblies in GAC will be renamed to ".dll.orig".
    Since, we have not passed the assemblies, PresentationFramework.dll, PresentationCore.dll, WindowsBase.dll will be replaced.

    `.\install-private-builds.ps1 -r E:\dts-fixes\1655943\net481\amd64ret\ -a PresentationFramework.dll`

    Renames the PresentationFramework.dll in GAC_MSIL and copies the private assembly from `E:\dts-fixes\1655943\net481\amd64ret\` to GAC_MSIL.



    Adding the `-revert` parameter to reverse the process. We delete the private assembly and rename the original assembly from ".dll.orig" to ".dll".

    ```
    .\install-private-builds.ps1 -r E:\dts-fixes\1655943\net481\amd64ret\ -revert
    .\install-private-builds.ps1 -r E:\dts-fixes\1655943\net481\amd64ret\ -a PresentationFramework.dll -revert
    ```

