// Clear the screen and switch to ship directory
clearScreen.
switch to 1.

// Print welcome message
print(" ").
print("Welcome to ASEC Flight Computer").
print("Developed by GATC").

// Copy files from KSC to boot directory on drive 1
copyPath("0:/boot/ASECFC/ASECFC/", "1:/boot/").

// Change directory to the ASECFC boot directory on drive 1
cd("1:/boot/ASECFC/").

// Run startup scripts for loading libraries and managing programs
run "libloader.ks".
run "programhandler.ks".
