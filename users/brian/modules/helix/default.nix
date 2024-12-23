{ pkgs, inputs, ... }:
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
    };
  };
}
