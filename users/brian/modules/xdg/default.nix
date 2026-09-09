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
      # Without this, xdg-open falls back to the first mimeinfo.cache in XDG_DATA_DIRS that
      # claims inode/directory -- which is the IntelliJ flatpak's export directory, so every
      # "open this folder" landed in the IDE.
      "inode/directory" = "thunar.desktop";
    };
  };

  home.packages = with pkgs; [ gnome-text-editor ];
}