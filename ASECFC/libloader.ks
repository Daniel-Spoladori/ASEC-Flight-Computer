// Notify that the Lib Loader Program is starting
print(" ").
print("Running Lib Loader Program.").

// Load configuration settings
run "configs/configs.ks".

// Store the Prefix used for logging
local Prefix is CFG_Libldr_Prefix.

// Confirm that configurations have been loaded
print(Prefix + " Loaded " + "Configs").

// Switch to the "libs" directory
cd(CFG_Path_Libs).

// List files in "libs" and store in 'toLoadFiles'
LIST FILES IN toLoadFiles.

// If no files are found, print an error and halt execution
if toLoadFiles:length() = 0 {
    print(" ").
    print("ERROR: NO FILES TO READ FROM CHECK /configs/configs.ks").
    print("EXECUTION HALTED").
    
    // Infinite loop to stop program
    until false {
        wait(0).
    }
}

// Load each file listed in 'toLoadFiles'
for index in toLoadFiles {
    runPath(index).
    print(Prefix + " Loaded " + index).
}

// Return to the home directory
cd(CFG_Path_Home).