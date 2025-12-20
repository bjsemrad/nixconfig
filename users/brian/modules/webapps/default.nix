{
  home.file = {
    ".local/share/applications/gmail.desktop".source = ./gmail.desktop;
    ".local/share/applications/protonmail.desktop".source = ./protonmail.desktop;
    ".local/share/applications/chatgpt.desktop".source = ./chatgpt.desktop;
    ".local/share/applications/applemusic.desktop".souce = ./applemusic.desktop;

    ".local/share/icons/hicolor" = {
      source = ./hicolor;
      recursive = true;
    };
  };
}
