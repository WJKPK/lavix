{
  vimPlugins,
  writeTextFile,
  linkFarm,
  symlinkJoin,
  runCommandLocal,
  lib,
}:
let
  parsers =
    let
      parsers = symlinkJoin {
        name = "treesitter-parsers";
        paths = (vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
          rust
          cpp
          cmake
          python
          nix
          latex
          typst
          yaml
        ])).dependencies;
      };
    in
    "${parsers}";

  baseLuaConfigDir = builtins.path {
    name = "neovim-lua-config";
    path = ./lua;
  };

  treesitterWithParser = runCommandLocal "nvim-treesitter-with-parser" { } ''
    mkdir -p $out
    cp -r ${vimPlugins.nvim-treesitter}/* $out/
    mkdir -p $out/parser
    cp -r ${parsers}/* $out/
  '';

  plugins = with vimPlugins; [
    lazy-nvim
    lspkind-nvim
    blink-cmp
    friendly-snippets
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-lspconfig
    plenary-nvim
    telescope-fzf-native-nvim
    telescope-live-grep-args-nvim
    telescope-nvim
    which-key-nvim
    leap-nvim
    yazi-nvim
    snacks-nvim
    nvim-web-devicons
    nvim-gdb
    #themes
    gruvbox-nvim
    { name = "nvim-treesitter"; path = treesitterWithParser; }
    { name = "mini.statusline"; path = mini-nvim; }
    { name = "mini.trailspace"; path = mini-nvim; }
    { name = "mini.pairs"; path = mini-nvim; }
    { name = "mini.icons"; path = mini-nvim; }
  ];

  mkEntryFromDrv = drv:
    if lib.isDerivation drv then
      { name = "${lib.getName drv}"; path = drv; }
    else
      drv;

  lazyPath = linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);

  initContent = ''
    vim.opt.rtp:prepend("${lazyPath}/lazy.nvim")
    require("config.general")
    require("lazy").setup({
      defaults = { lazy = true },
      rocks = { enabled = false },
      dev = {
        path = "${lazyPath}",
        patterns = { "" },
        fallback = false,
        install = { missing = false },
      },
      spec = {
        { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
        { import = "plugins" },
        { "williamboman/mason-lspconfig.nvim", enabled = false },
        { "williamboman/mason.nvim", enabled = false },
      },
      performance = {
        reset_packpath = false,
        rtp = { reset = false },
      },
    })
    require("config.lsp")
    vim.o.background = "dark"
    vim.cmd([[colorscheme gruvbox]])
  '';

  initFile = writeTextFile {
    name = "init.lua";
    text = initContent;
  };

  # Combine baseLuaConfigDir and initFile into a single directory
  neovimConfigDir = runCommandLocal "neovim-config" { } ''
    mkdir -p $out
    ln -s ${baseLuaConfigDir}/* $out/
    ln -s ${initFile} $out/init.lua
  '';
in
neovimConfigDir

