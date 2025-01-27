{pkgs, input, ...}: 
{
	home.packages = with pkgs; [
		python312Packages.pip
  	];
}
