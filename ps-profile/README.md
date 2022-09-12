## Powershell Profile Scripts ( Aliases / Functions )
Added the basic powershell profile that I am setting for increasing the speed of work using the CLI.

Here, you will find three main scripts : 
- **profile.ps1** : This is a wrapper script that enumerates over all the scripts in the directory. Rather than adding all the scripts one by one in the main profile, you can just include this Powershell profile in the main powershell profile.
- **psaliases.ps1** : In this script, I have defined some of the most common and ( IMO some other frequently used aliases ) in the script. The script consists of the following aliases :
    - Common Git Aliases 
    - Directory Navifation Aliases
    - Executable Based Aliases ( notepad, explorer, apps )
- **psfunctions.ps1** : This script is for storing some command and most used functions. ( For now, the functions already present were taken as it is from another repo. Will come back to it later.)

#### Something about my pwoershell setup :

As of now I am using **Powershell Core 7.2** alongwith **Cmder** as the terminal emulator. 
The current structure of my CLI setup can be visualized as : 
```
C:\tools
    |
    |-- cmder
    |   |...
    |   |-- config
    |           |
    |           |-- user_profile.ps1
    |
    |-- powershell ( contains the scripts that are mentioned above)
    |
    |-- neovim ( ** )
```

- `powershell` directory consists of the scripts present here ( profile.ps1, psaliases.ps1, psfunctions.ps1, .... )
- In `user_profile.ps1` I have added the reference to the profile.ps1 from this directory as follows :
    ```
        ## Add path to your custom PowerShell Profile
        
        $PsProfile="C:\tools\powershell\profile.ps1"
        . $PsProfile
    ```
- Neovim is optional. By that I mean you can directly install Neovim using `wiget install Neovim.Neovim`. ( I will be moving back to the custom configuration, as it is easy to modify it in that case. Maybe ?? )
  
#### Other customizations
I also spent some time configuring the prompt in Cmder and would hate to lose it. Therefore added it here in the `cmder` directory. The main changes you will find are in the PrePrompt variable/