package target;

import Config.*;
import System.*;
import haxe.io.Path;
import sys.FileSystem;

class Hl {

	static var hlSrc = Sys.getCwd() + "/hashlink";

	static public function getHlDependencies() {
		if (commandSucceed("hl", ["--version"])) {
			infoMsg('hl has already been installed.');
			return;
		}

		switch (systemName) {
			case "Linux":
				Linux.requireAptPackages([
					"ninja-build",
					"libpng-dev",
					"libjpeg-turbo8-dev",
					"libturbojpeg",
					"zlib1g-dev",
					"libvorbis-dev",
					"libopenal-dev",
					"libsdl2-dev",
					"libmbedtls-dev",
					"libuv1-dev",
				]);
			case "Mac":
				Sys.command('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'); //setup homebrew
			case "Windows":
				// pass
		}

		switch systemName {
			case "Windows":
				if (!FileSystem.exists(hlSrc)) {
					Sys.command('powershell.exe -Command wget -O hashlink.zip https://github.com/HaxeFoundation/hashlink/releases/download/1.11/hl-1.11.0-win.zip');
					Sys.command("powershell.exe -Command Expand-Archive hashlink.zip");
				} else
					infoMsg("Reusing hashlink binary");
				addToPATH("hashlink/hl-1.11.0-win");
			default:
				Sys.putEnv("LD_LIBRARY_PATH","/usr/local/lib");
				if (!FileSystem.exists(hlSrc)) {
					runCommand("git", ["clone", "https://github.com/HaxeFoundation/hashlink.git", hlSrc]);
				} else
					infoMsg("Reusing hashlink repository");
				Sys.setCwd(hlSrc);
				if (systemName == "Mac")
					Sys.command("brew bundle");

				Sys.command("sudo make all");
				Sys.command("sudo make install");
				addToPATH(hlSrc);
		}

		runCommand("hl", ["--version"]);
	}
}
