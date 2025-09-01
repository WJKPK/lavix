{
  pkgs,
  neovim-unwrapped,
  makeWrapper, callPackage,
  symlinkJoin,
}:
let
  packageName = "lavix";
  lavixConfigPath = callPackage ./lavixConfigGet.nix {};
  opencode_custom = callPackage ./opencode.nix {};
  runtime_deps = with pkgs; [
    #copying
    wl-clipboard
    xclip
    lazygit
    ripgrep
    fd
    #lsp
    clang-tools
    rust-analyzer
    ruff
    basedpyright
    nixd
    cmake-language-server
    zls
    tinymist
    lua-language-server
    #treesitter
    gcc
    tree-sitter
    yazi
    opencode_custom
  ];
  in 
    symlinkJoin {
     name = packageName;
     description = "Lavix";
     paths = [ neovim-unwrapped runtime_deps ];
     nativeBuildInputs = [ makeWrapper ];
     postBuild = ''
       wrapProgram $out/bin/nvim \
         --add-flags '--cmd' \
         --add-flags "'set runtimepath^=${lavixConfigPath}'" \
         --add-flags '-u' \
         --add-flags '${lavixConfigPath}/init.lua' \
         --prefix PATH : ${pkgs.lib.makeBinPath runtime_deps} \
         --set-default NVIM_APPNAME ${packageName} \
     '';
  }

