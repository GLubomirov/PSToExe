###########################################################Overview

PSToExe is a Visual Studio project allowing you to run PowerShell Scripts as Executables. Appart from that it encrypts the PowerShell Script
so it is unreadable to the user.

###########################################################Steps to Build

You write your script as any other PS Script.

You run the PowerShell script located at ExePS/Encrypt/Encrypt_Decrypt.ps1. The Command should look like this:

.Encrypt_Decrypt.ps1 -key "gT4XPfvcJmHkQ5tYjY3fNgi7uwG4FB9j" -action "protect"

When you run the script you will be promted to point to the PS script you written and want to encrypt. Change the key to some other key.

Encrypt_Decrypt.ps1 will produce a TXT file with the same name as your script.

You put this TXT file into the PSExe project with "Embedded Resource" build action. After that change the Key and Script filename in Program.cs.

Build your project and your exe is ready.

###########################################################Result

The Exe will unpack three files to the directory it is run in. (You can change that to a directory in Program data in Program.cs)

The code of your powershell script will not be visible since it is encrypted.
