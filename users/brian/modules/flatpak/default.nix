{ pkgs, ...}:
{
	services.flatpak = {
		packages = [
			"com.bambulab.BambuStudio"
			"org.fedoraproject.MediaWriter"
		];
		update.auto.enable = true;
  		uninstallUnmanaged = true;
	};
}
