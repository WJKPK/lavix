{
  pkgs,
  makeBinaryWrapper,
  symlinkJoin,
  lib
}:
let
  refactorMd = builtins.readFile ./refactor.md;
  reviewMd = builtins.readFile ./review.md;
in
symlinkJoin {
  name = "opencode";
  paths = with pkgs; [ opencode ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild = let
    config = {
      "$schema" = "https://opencode.ai/config.json";
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            "gpt-oss:20b" = {
              name = "gpt-oss:20b";
              tools = true;
              tool_call = true;
            };
          };
        };
      };
      mode = {
        review = {
          prompt = reviewMd;
          permission = {
            edit = "deny";
            bash = {
              "*" = "deny";
              "grep *" = "allow";
              "git diff*" = "allow";
              "git log*" = "allow";
              "git show*" = "allow";
              "git status" = "allow";
            };
          };
        };
        refactor = {
          prompt = refactorMd;
          permission = {
            edit = "ask";
            bash = {
              "*" = "ask";
              "grep *" = "allow";
              "git diff*" = "allow";
              "git log*" = "allow";
              "git show*" = "allow";
              "git status" = "allow";
            };
          };
        };
      };
    };
    jsonfile = builtins.toFile "opencode.json" (builtins.toJSON config);
    wrapperArgs = [
      "--set-default" "OPENCODE_CONFIG" "${jsonfile}"
    ];
  in ''
    wrapProgram "$out/bin/opencode" ${lib.escapeShellArgs wrapperArgs}
  '';
}
