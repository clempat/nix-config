{ config, ... }:
{
  programs.ai-tools = {
    enable = true;

    # Unified MCP servers (claude-code format)
    mcpServers = {
      nixos = {
        type = "stdio";
        command = "nix";
        args = [
          "run"
          "github:utensils/mcp-nixos"
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

    # Unified agents (metadata in Nix, content in markdown)
    agents = {
      frontend-developer = {
        content = ./agent-content/frontend-developer.md;
        description = "Modern frontend developer specializing in Vue.js, TypeScript, and web technologies. Expertise in component design, state management, build tooling, and performance optimization.";
        tools = [
          "Glob"
          "Grep"
          "Read"
          "Write"
          "Edit"
          "MultiEdit"
          "WebSearch"
          "WebFetch"
          "TodoWrite"
          "Bash"
        ];
        model = "sonnet";
        color = "blue";
        mode = "all";
      };

      senior-code-reviewer = {
        content = ./agent-content/senior-code-reviewer.md;
        description = "Senior code reviewer focusing on code quality, architecture, security, and best practices. Provides constructive feedback and improvement suggestions.";
        tools = [
          "Glob"
          "Grep"
          "Read"
        ];
        model = "sonnet";
        color = "purple";
        mode = "subagent";
      };

      ui-engineer = {
        content = ./agent-content/ui-engineer.md;
        description = "UI/UX engineer specializing in component design, accessibility, responsive layouts, and design systems. Focuses on user experience and visual polish.";
        tools = [
          "Glob"
          "Grep"
          "Read"
          "Write"
          "Edit"
          "MultiEdit"
          "WebSearch"
          "WebFetch"
          "TodoWrite"
          "Bash"
        ];
        model = "sonnet";
        color = "cyan";
        mode = "all";
      };
    };

    # Shared memory
    memory = ../claude/memory.md;

    # Enable both tools
    enableClaudeCode = true;
    enableOpencode = true;
  };

  # Skills still need manual symlinking (not supported in module yet)
  home.file.".claude/skills/lint-with-conform".source = ../claude/skills/lint-with-conform;
}
