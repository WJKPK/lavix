{
  pkgs,
  makeBinaryWrapper,
  symlinkJoin,
  lib
}:
 symlinkJoin {
    name = "opencode";
    paths = with pkgs; [ opencode ];
    nativeBuildInputs = [ makeBinaryWrapper ];
    postBuild = let
      jsonfile = builtins.toFile "opencode.json" /*json*/''
        {
          "$schema": "https://opencode.ai/config.json",
          "provider": {
            "ollama": {
              "npm": "@ai-sdk/openai-compatible",
              "name": "Ollama (local)",
              "options": {
                "baseURL": "http://localhost:11434/v1"
              },
              "models": {
                "gpt-oss:20b": {
                  "name": "gpt-oss:20b"
                },
                "qwen3-coder:30b": {
                  "name": "qwen3-coder:30b"
                },
                "qwen3:3b": {
                  "name": "qwen3:3b"
                },
                "devstral:24b": {
                  "name": "devstral:24b"
                },
              }
            }
          },
          "mode": {
            "build": {
              "tools": {
                "write": true,
                "edit": true,
                "bash": true
              }
            },
            "plan": {
              "tools": {
                "write": false,
                "edit": false,
                "bash": false
              }
            },
            "review": {
              "tools": {
                "write": false,
                "edit": false,
                "bash": false
              }
            }
          }
        }
      '';
      wrapperArgs = [
        "--set-default" "OPENCODE_CONFIG" "${jsonfile}"
      ];
    in ''
      wrapProgram "$out/bin/opencode" ${lib.escapeShellArgs wrapperArgs}
    '';
  }
