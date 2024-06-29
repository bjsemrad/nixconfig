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

    add_newline = true;

    os = {
      disabled = false;
      
    };

    memory_usage = {
      disabled = true;
      threshold = -1;
    };

    aws = {
      style = "bold #f6c177"; #ffb86c";
    };

    character = {
      error_symbol = "[>](bold #ee99a0)";  #eb6f92 rosepine
      success_symbol = "[>](bold #a6da95)"; #c4a7e7 rosepine  50fa7b)";
    };

    cmd_duration = {
      style = "bold #eed49f"; #f6c177 rosepine
    };

    directory = {
      style = "bold #89b4fa"; #9ccfd8" rosepine; #50fa7b";   
      truncation_symbol = "…/";
      truncate_to_repo = false;
    };


    git_branch = {
      style = "bold #fab387"; #rose pine ebbcba"; #ff79c6";
    };

    git_status = {
      style = "bold #74c7ec"; #rosepoine c4a7e7"; #ff5555";
    };

    hostname = {
      style = "bold #bd93f9";
    };

    username = {
      #format = "[\$user](\$style) on ";
      style_user = "bold #8be9fd"; #TODO
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
      style = "bold #eed49f"; #rosepine #f6c177";
    };

    fill = {
      style = "bold #50FA7B";
      symbol = " ";
    };

    java = {
      symbol = "";
      format = "[\${symbol}(\${version} )]($style)";
      style = "bold #e0def4"; #white";
    };

    package = {
      disabled = true;
    };

    vagrant = {
      format = "[$symbol($version )]($style)";
    };
  };
}
