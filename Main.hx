function main() {
    trace("Installing Hashlink...");
    switch Sys.systemName() {
        case "Windows": setupWindows();
        case "Mac": setupMac();
        default: setupLinux();
    }
}
private function setupWindows() {
    Sys.command("powershell.exe -Command wget -O hl.zip https://github.com/HaxeFoundation/hashlink/releases/download/1.11/hl-1.11.0-win.zip");
    Sys.command("powershell.exe -Command Expand-Archive -LiteralPath hl.zip -DestinationPath ..");
    Sys.command("$env:Path += " + Sys.getCwd() + "/hl-1.11.0-win");
}
private function setupLinux() {
    Sys.command("sudo apt-get update -qqy & sudo apt-get install -qqy libpng-dev libturbojpeg-dev libvorbis-dev libopenal-dev libsdl2-dev libmbedtls-dev libuv1-dev"); //dependencies
    Sys.command("git clone https://github.com/HaxeFoundation/hashlink");
    Sys.command("cd hashlink");
    Sys.command("make install");
    Sys.command("export PATH=$PATH:/" + Sys.getCwd() + "/hashlink");
}
private function setupMac() {
    Sys.command('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'); //setup homebrew
    Sys.command("brew install hashlink");
}