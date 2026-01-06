# Downloads
curl -s -o login.sh -L "https://raw.githubusercontent.com/JohnnyNetsec/github-vm/main/mac/login.sh"

# Disable spotlight indexing
sudo mdutil -i off -a

# Create new account
sudo dscl . -create /Users/runneradmin
sudo dscl . -create /Users/runneradmin UserShell /bin/bash
sudo dscl . -create /Users/runneradmin RealName Runner_Admin
sudo dscl . -create /Users/runneradmin UniqueID 1001
sudo dscl . -create /Users/runneradmin PrimaryGroupID 80
sudo dscl . -create /Users/runneradmin NFSHomeDirectory /Users/tcv
sudo dscl . -passwd /Users/runneradmin P@ssw0rd!
sudo dscl . -passwd /Users/runneradmin P@ssw0rd!
sudo createhomedir -c -u runneradmin > /dev/null
sudo dscl . -append /Groups/admin GroupMembership runneradmin

# Enable Screen Sharing
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

sudo defaults write /Library/Preferences/com.apple.RemoteManagement ScreenSharingAllowed -bool YES
sudo defaults write /Library/Preferences/com.apple.RemoteManagement ARD_AllLocalUsers -bool TRUE

# Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -allUsers -privs -all -clientopts -setvnclegacy -vnclegacy yes

echo runnerrdp | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

sudo /usr/local/bin/screenresolution set 1920x1080x32 || echo "Resolution utility not found, skipping..."

# Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console -activate

# Install ngrok
brew install --cask ngrok

# Configure ngrok and start it
ngrok authtoken $1
ngrok tcp 5900 --region=in &
