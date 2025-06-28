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
			"org.signal.Signal"
		];
		update.auto.enable = true;
  		uninstallUnmanaged = true;
	};

	home.file =  {
		".local/share/flatpak/overrides/org.signal.Signal".source = ./overrides/org.signal.Signal;
	};
}
