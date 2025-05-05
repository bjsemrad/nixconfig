{pkgs, inputs,...}:
{
	programs.wezterm = {
		enable = true;
		enableZshIntegration = true;
	};
}
