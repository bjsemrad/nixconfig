{ pkgs, ...}:
{
	services.flatpak = {
		packages = [
			"com.bambulab.BambuStudio"
			"org.fedoraproject.MediaWriter"
			"me.proton.Mail"
			"com.jetbrains.IntelliJ-IDEA-Ultimate"
			"com.jetbrains.RustRover"
			"com.github.tchx84.Flatseal"
			"io.missioncenter.MissionCenter"
		];
		update.auto.enable = true;
  		uninstallUnmanaged = true;
	};
}
