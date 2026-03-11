{
  inputs,
  pkgs,
  aiProfile,
  ...
}:
let
  isWork = aiProfile == "work";
in
{
  programs.ai-tools = {
    enable = true;
    tmux.enable = true;
    opencode =
      if isWork then
        {
          useRecommendedRouting = false;
          model = "anthropic/claude-sonnet-4-6";
          modelByAgent = {
            orchestrator = "anthropic/claude-sonnet-4-6";
            oracle = "anthropic/claude-opus-4-6";
            explorer = "anthropic/claude-haiku-4-5-20251001";
            librarian = "anthropic/claude-haiku-4-5-20251001";
            designer = "anthropic/claude-sonnet-4-6";
            fixer = "anthropic/claude-sonnet-4-6";
          };
        }
      else
        {
          useRecommendedRouting = true;
        };
  };

  # ai-tools overlay currently selects upstream opencode when bun >= 1.3.10.
  # That revision fails in nix builds due to missing .github/TEAM_MEMBERS.
  programs.opencode.package = pkgs.unstable.opencode;

  home.packages = [ pkgs.spec-kit ];

  # Install Claude skills manually (until module supports them)
  home.file.".claude/skills/lint-with-conform".source = "${inputs.ai-tools}/skills/lint-with-conform";
  home.file.".claude/skills/nixos-advisor".source = "${inputs.ai-tools}/skills/nixos-advisor";
  home.file.".claude/skills/obsidian-worklog".source = "${inputs.ai-tools}/skills/obsidian-worklog";
}
