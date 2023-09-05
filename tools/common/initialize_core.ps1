# ---------------------------------------------------------
# Baserom initialization PowerShell script
# ---------------------------------------------------------
Clear-Host

# Directory Definitions
$WorkingDir = Get-Location
$ToolsDir = "$WorkingDir\tools"
$ListsDir = "$WorkingDir\resources\initial_lists\"

# Dot includes
. $ToolsDir\common\tool_defines.ps1

# Function to remove junk files
function Remove-Junk($Directory, $JunkFiles) {
    foreach ($item in $JunkFiles) {
        $itemPath = Join-Path -Path $Directory -ChildPath $item
        if (Test-Path -Path $itemPath) {
            if (Test-Path -Path $itemPath -PathType Leaf) {
                Remove-Item -Path $itemPath -Force
            } else {
                Remove-Item -Path $itemPath -Recurse -Force
            }
        }
    }
}

# Function to create .is_setup check file
function CheckFile-Create($Directory) {
    # Create is_setup checkfile
    New-Item -Path "$Directory.is_setup" -ItemType File | Out-Null
    Set-ItemProperty -Path "$Directory.is_setup" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
}

# Function to Download tool
function Download-Tool($Name, $Url) {
    Write-Host "$Name is not set up. `nDownloading..."
    Invoke-WebRequest -Uri $Url -OutFile "$env:temp\$Name.zip"
}

# Function to set up a tool
function SetupTool($ToolName, $DownloadUrl, $DestinationDir, $JunkFiles, $ListFile) {
    if (Test-Path "$DestinationDir.is_setup" -PathType Leaf) {
        Write-Host "-- $ToolName already is set up in: $DestinationDir"
    } else {
        try {
            # Download Tool
            Download-Tool $ToolName $DownloadUrl
            # Expand Archive
            Expand-Archive -Path "$env:temp\$ToolName.zip" -DestinationPath $DestinationDir -Force
            # Clean up junk files
            Remove-Junk $DestinationDir $JunkFiles
            # Copy pre-existing list file (if it exists)
            if ($ListFile -ne "") {
                Copy-Item -Path "$ListsDir\$ListFile" -Destination "$DestinationDir\list.txt"
            }
            # Create is_setup checkfile
            CheckFile-Create $DestinationDir
            # Done
            Write-Host "Done. `n"
        } catch {
            Write-Host "An error occurred setting up $ToolName."
        }
    }

    # Lunar Magic
    if ($ToolName -eq "Lunar Magic") {
        # copy usertoolbar files to Lunar Magic directory
        Copy-Item -Path "$ToolsDir\usertoolbar\usertoolbar.txt" -Destination $LunarMagic_Dir
        Copy-Item -Path "$ToolsDir\usertoolbar\usertoolbar_icons.bmp" -Destination $LunarMagic_Dir
        Copy-Item -Path "$ToolsDir\usertoolbar\usertoolbar_wrapper.bat" -Destination $LunarMagic_Dir
    }
}

# Function to set up a tool
function SetupAMK($ToolName, $DownloadUrl, $DestinationDir, $JunkFiles) {
    if (Test-Path "$DestinationDir.is_setup" -PathType Leaf) {
        Write-Host "-- $ToolName already is set up in: $DestinationDir"
    } else {
        try {
            # Download Tool
            Download-Tool $ToolName $DownloadUrl
            # AddMusicK specific actions because zip is subfolder >:(
            Expand-Archive -Path $env:temp\$ToolName.zip -DestinationPath $env:temp\ -Force
            Copy-Item "$env:temp\AddmusicK_*\*" -Destination $AddMusicK_Dir -Recurse -Force
            # Clean up junk files
            Remove-Junk $DestinationDir $JunkFiles
            # Copy AddMusicK list files to tool directory
            Copy-Item -Path "$ListsDir\Addmusic*" -Destination $DestinationDir
            # Create is_setup checkfile
            CheckFile-Create $DestinationDir
            # Done
            Write-Host "Done. `n"
        } catch {
            Write-Host "An error occurred setting up $ToolName."
        }
    }
}

# Function to set up a tool
function SetupCallisto($ToolName, $DownloadUrl, $DestinationDir, $JunkFiles) {
    if (Test-Path "$DestinationDir.is_setup" -PathType Leaf) {
        Write-Host "-- $ToolName already is set up in: $DestinationDir"
    } else {
        try {
            # Download Tool
            Download-Tool $ToolName $DownloadUrl
            # Expand Archive
            Expand-Archive -Path "$env:temp\$ToolName.zip" -DestinationPath $DestinationDir -Force
            # Install Callisto's modified asar dll.
            Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $GPS_Dir
            Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $AddMusicK_Dir | Remove-Item $AddMusicK_Dir\asar.exe
            Copy-Item -Path "$Callisto_Dir\asar\32-bit\asar.dll" -Destination $UberASMTool_Dir
            Copy-Item -Path "$Callisto_Dir\asar\64-bit\asar.dll" -Destination $PIXI_Dir
            # Clean up junk files
            Remove-Junk $DestinationDir $JunkFiles
            # Create is_setup checkfile
            CheckFile-Create $DestinationDir
            # Done
            Write-Host "Done. `n"
        } catch {
            Write-Host "An error occurred setting up $ToolName."
        }
    }
}

# Start the main menu loop
$UserChoice = $null
while ($UserChoice -ne "4") {
    Write-Host "`n------------------------------"
    Write-Host "Initialize Baserom"
    Write-Host "------------------------------`n"
    Write-Host "What would you like to do?`n"
    Write-Host "1. Download and Setup all Baserom Tools"
    Write-Host "2. Run first build of the Baserom"
    Write-Host "0. Exit`n"

    $UserChoice = Read-Host "Enter the number of your choice"

    if ($UserChoice -notin ("0", "1", "2")) {
        Write-Host "`n'$UserChoice' is not a valid option, please try again.`n"
        continue
    }

    switch ($UserChoice) {

        # Download and Setup all Baserom Tools
        "1" {
            Clear-Host
            Write-Host "Checking state of tools...`n"
            SetupAMK  "AddMusicK" $AddMusicK_Download $AddMusicK_Dir $AddMusicK_Junk ""
            SetupTool "Flips" $Flips_Download $Flips_Dir $Flips_Junk ""
            SetupTool "GPS" $GPS_Download $GPS_Dir $GPS_Junk "list_gps.txt" # name of list in initial_lists
            SetupTool "PIXI" $PIXI_Download $PIXI_Dir $PIXI_Junk "list_pixi.txt" # name of list in initial_lists
            SetupTool "Lunar Magic" $LunarMagic_Download $LunarMagic_Dir $LunarMagic_Junk ""
            SetupTool "UberASMTool" $UberASMTool_Download $UberASMTool_Dir $UberASMTool_Junk "list_uberasm.txt" # name of list in initial_lists
            SetupCallisto "Callisto" $Callisto_Download $Callisto_Dir $Callisto_Junk ""
            Write-Host "`nAll done."
        }

        # Run first build of the Baserom
        "2" {
            Clear-Host
            if (Test-Path "$Callisto_Dir.is_setup" -PathType Leaf) {
                if (Test-Path "$Callisto_Dir.first_build_done" -PathType Leaf) {
                    Write-Host "First build already performed.`n`nYou can now use Callisto for working on your project by running it from the 'buildtool' folder."
                } else {
                    try {
                        Write-Host "Running a first-build in Callisto...`n"
                        $command = "$Callisto_Dir\callisto.exe"
                        $args = "rebuild"
                        $process = Start-Process -FilePath $command -ArgumentList $args -Wait -PassThru
                        $exitCode = $process.ExitCode
                        if ($exitCode -eq 0) {
                            New-Item -Path "$Callisto_Dir.first_build_done" -ItemType File -Force | Out-Null
                            Set-ItemProperty -Path "$Callisto_Dir.first_build_done" -Name Attributes -Value ([System.IO.FileAttributes]::Hidden) | Out-Null
                            Write-Host "First build done."
                        } else {
                            Write-Host "Baserom failed to build. Please run Callisto manually from the 'buildtool' folder, and perform a 'Rebuild' to see any errors."
                        }
                    } catch {
                        Write-Host "First build did not complete successfully. Please try again."
                    }
                }
            } else {
                Write-Host "`nCallisto is not set up, please run Step 1 first."
            }
        }

        # Exit
        "0" {
            Clear-Host
            Write-Host "Exiting...`nHave a nice day ^_^`n"
            exit 0
        }
    }
}