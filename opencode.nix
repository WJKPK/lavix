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
                  "name": "gpt-oss:20b",
                  "tools": true,
                  "tool_call": true
                },
                "devstral:24b": {
                  "name": "devstral:24b",
                  "tools": true,
                  "tool_call": true
                },
                "cogito:32b": {
                  "name": "cogito:32b",
                  "tools": true,
                  "tool_call": true
                },
                "qwen2.5-coder:3b": {
                  "name": "qwen2.5-coder:3b",
                  "tools": true,
                  "tool_call": true
                },
                "cogito:3b": {
                  "name": "cogito:3b",
                  "tools": true,
                  "tool_call": true
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
