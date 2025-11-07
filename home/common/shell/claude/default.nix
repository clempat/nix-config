{ config, pkgs, ... }:
{
  programs.claude-code = {
    enable = true;

    memory.source = ./memory.md;
    agentsDir = ./agents;

    package = pkgs.unstable.claude-code;

    settings = {
      theme = "dark";
      preferredNotifChannel = "native";
    };

    mcpServers = {
      nixos = {
        type = "stdio";
        command = "nix";
        args = [
          "run"
          "github:utensils/nixos-mcp"
          "--"
        ];
      };

      figma-desktop = {
        enable = false;
        type = "http";
        url = "http://127.0.0.1:3845/mcp";
      };

      atlassian = {
        enable = false;
        type = "http";
        url = "https://mcp.patout.app/mcp/atlassian";
        headers = {
          Authorization = "Bearer wH0wuvH41jffjE1aFO7qlcl0OX7TtvWj";
        };
      };

      github = {
        enable = false;
        type = "http";
        url = "https://mcp.patout.app/mcp/github";
        headers = {
          Authorization = "Bearer wH0wuvH41jffjE1aFO7qlcl0OX7TtvWj";
        };
      };

      brave-search = {
        enable = false;
        type = "http";
        url = "https://mcp.patout.app/mcp/brave-search";
        headers = {
          Authorization = "Bearer wH0wuvH41jffjE1aFO7qlcl0OX7TtvWj";
        };
      };

      sentry = {
        enable = false;
        type = "http";
        url = "https://mcp.patout.app/mcp/sentry";
        headers = {
          Authorization = "Bearer wH0wuvH41jffjE1aFO7qlcl0OX7TtvWj";
        };
      };

      n8n = {
        enable = false;
        type = "http";
        url = "https://mcp.patout.app/mcp/n8n";
        headers = {
          Authorization = "Bearer wH0wuvH41jffjE1aFO7qlcl0OX7TtvWj";
        };
      };

      todoist = {
        enable = false;
        type = "http";
        url = "https://mcp.patout.app/mcp/todoist";
        headers = {
          Authorization = "Bearer wH0wuvH41jffjE1aFO7qlcl0OX7TtvWj";
        };
      };

      playwright = {
        enable = false;
        type = "stdio";
        command = "npx";
        args = [
          "@playwright/mcp@latest "
          "--headless"
        ];
      };

      context7 = {
        type = "http";
        url = "https://mcp.patout.app/mcp/context7";
        headers = {
          Authorization = "Bearer wH0wuvH41jffjE1aFO7qlcl0OX7TtvWj";
        };
      };
    };
  };

  # Skills are not yet supported in home-manager module, so we symlink manually
  home.file.".claude/skills/lint-with-conform".source = ./skills/lint-with-conform;
}
