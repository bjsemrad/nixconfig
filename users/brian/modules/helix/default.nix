{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
    nil
    jdt-language-server
    gopls
    delve
  ];

  programs.helix = {
    enable = true;
    languages = {
      language = [{
    	   name = "rust";
	       auto-format = true;
    	}     
      {
    	   name = "nix";
	       auto-format = true;
    	}
      
      {
    	   name = "go";
	       auto-format = true;
    	}
      
      {
    	   name = "java";
	       auto-format = true;
    	}
      {
    	   name = "nu";
	       auto-format = true;
    	}];
    };
    settings = {
      theme = "onedark";
      editor = {
        cursor-shape = {
          insert = "bar";
        };
        bufferline = "multiple";
     };
       keys.normal."C-c" = "normal_mode";
       keys.insert."C-c" = "normal_mode";
       keys.select."C-c" = "normal_mode";
       keys.normal."C-/" = "toggle_comments";
       keys.insert."C-/" = "toggle_comments";
    };
  };
}
