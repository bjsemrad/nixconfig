{  lib, ... }:

{
  programs.starship.enable = true;
  programs.starship.settings = {
    format = lib.concatStrings [
   #   "$os "
      " "
      "$username"
      "$hostname"
      "$localip"
      "$shlvl"
      "$singularity"
      "$kubernetes"
      "$directory"
      "$vcsh"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_metrics"
      "$git_status"
      "$nix_shell"
      "$hg_branch"
      "$docker_context"
      "$package"
      "$c"
      "$cmake"
      "$cobol"
      "$daml"
      "$dart"
      "$deno"
      "$dotnet"
      "$elixir"
      "$elm"
      "$erlang"
      "$golang"
      "$haskell"
      "$helm"
      "$julia"
      "$kotlin"
      "$lua"
      "$nim"
      "$nodejs"
      "$ocaml"
      "$perl"
      "$php"
      "$pulumi"
      "$purescript"
      "$raku"
      "$rlang"
      "$red"
      "$ruby"
      "$rust"
      "$scala"
      "$swift"
      "$vlang"
      "$zig"
      "$buf"
      "$nix_shell"
      "$conda"
      "$meson"
      "$spack"
      "$memory_usage"
      "$aws"
      "$gcloud"
      "$openstack"
      "$azure"
      "$crystal"
      "$custom"
      "$sudo"
      "$jobs"
      "$battery"
      "$status"
      "$container"
      "$shell"
      "$fill"
      "$java"
      "$terraform"
      "$cmd_duration"
      "$python"
      "$vagrant"
      "$time"
      "$line_break"
      "$character"
    ];
    palette = "onedark";

    palettes = {
      rose-pine = {
        overlay = "#26233a";
        love = "#eb6f92";
        gold = "#f6c177";
        rose = "#ebbcba";
        pine = "#3e8fb0"; #override #31748f";
        foam = "#9ccfd8";
        iris = "#c4a7e7";
      };
      onedark = {
        black = "#0e1013";
        bgDark = "#1E2127";
	bg0 = "#1f2329";
	bg1 = "#282c34";
	bg2 = "#30363f";
	bg3 = "#323641";
	bg_d = "#181b20";
	bg_blue = "#61afef";
	bg_yellow = "#e8c88c";
	fg = "#a0a8b7";
        fg_dark = "#abb2bf";
	purple = "#bf68d9";
	green = "#8ebd6b";
	orange = "#cc9057";
	blue = "#4fa6ed";
	yellow = "#e2b86b";
	cyan = "#48b0bd";
	red = "#e55561";
	grey = "#535965";
	light_grey = "#7a818e";
	dark_cyan = "#266269";
	dark_red = "#8b3434";
	dark_yellow = "#835d1a";
	dark_purple = "#7e3992";
	diff_add = "#272e23";
        diff_delete = "#2d2223";
	diff_change = "#172a3a";
	diff_text = "#274964";
      };

    };

    add_newline = true;

    os = {
      disabled = false;
      
    };

    memory_usage = {
      disabled = true;
      threshold = -1;
    };

    aws = {
      style = "bold fg:@orange";
    };

    character = {
      error_symbol = "[>](bold fg:red)";
      success_symbol = "[>](bold fg:green)";
    };

    cmd_duration = {
      style = "bold fg:yellow";
    };

    directory = {
      style = "bold fg:blue";
      truncation_symbol = "…/";
      truncate_to_repo = false;
    };


    git_branch = {
      style = "bold fg:red";
    };

    git_status = {
      style = "bold fg:orange";
    };

    hostname = {
      style = "bold fg:cyan";
    };

    username = {
      #format = "[\$user](\$style) on ";
      style_user = "bold fg:purple"; 
    };

    nodejs = {
      disabled = true;
      format = "[$symbol($version )]($style)";
    };

    python = {
      format = "[$symbol]($style)";
    };

    terraform = {
      format = "[$symbol $version ]($style)";
    };

    time = {
      disabled = false;
      use_12hr = true;
      style = "bold fg:yello"; #rosepine #f6c177";
    };

    fill = {
      style = "bold fg:bgDark";
      symbol = " ";
    };

    java = {
      symbol = "";
      format = "[\${symbol}(\${version} )]($style)";
      style = "bold fg:red";
    };

    package = {
      disabled = true;
    };

    vagrant = {
      format = "[$symbol($version )]($style)";
    };
  };
}
