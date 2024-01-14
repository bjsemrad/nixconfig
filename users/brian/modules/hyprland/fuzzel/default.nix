{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        layer = "overlay";
        prompt = "λ >   ";
        fields = "name,generic,comment,categories,filename,keywords";
        #icon-theme = "Mint-L";
        font = "Noto:size=15";
        fuzzy = "yes";
        width = 100;
      };
      colors = {
        background = "1d1f21aa";
        border = "333333aa";
        text = "c5c8c6ff";
        selection = "8B4000aa";
        selection-text = "c5c8c6ff";
      };
      border.radius = 16;
    };
  };
}
