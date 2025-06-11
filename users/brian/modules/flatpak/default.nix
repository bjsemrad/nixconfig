{ pkgs, ...}:
{
	services.flatpak = {
		packages = [
			"com.bambulab.BambuStudio"
			"org.fedoraproject.MediaWriter"
			"me.proton.Mail"
			"com.jetbrains.IntelliJ-IDEA-Ultimate"
			"com.jetbrains.RustRover"
		];
		update.auto.enable = true;
  		uninstallUnmanaged = true;
	};
}
