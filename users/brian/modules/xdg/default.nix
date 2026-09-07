{ pkgs, ... }:
{
  xdg = {
    enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "text/plain" = "org.gnome.TextEditor.desktop";
      "text/*" = "org.gnome.TextEditor.desktop";
      "application/xml" = "org.gnome.TextEditor.desktop";
      "application/json" = "org.gnome.TextEditor.desktop";
      "text/html" = "brave.desktop";
      "application/pdf" = "brave.desktop";
      "image/*" = "pinta.desktop";
    };
  };

  home.packages = with pkgs; [ gnome-text-editor ];
}