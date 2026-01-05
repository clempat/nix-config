{ inputs, pkgs, ... }:
{
  programs.ai-tools.enable = true;

  home.packages = [
    pkgs.spec-kit
  ];

  # Install Claude skills manually (until module supports them)
  home.file.".claude/skills/lint-with-conform".source =
    "${inputs.ai-tools}/skills/lint-with-conform";
  home.file.".claude/skills/nixos-advisor".source =
    "${inputs.ai-tools}/skills/nixos-advisor";
  home.file.".claude/skills/obsidian-worklog".source =
    "${inputs.ai-tools}/skills/obsidian-worklog";
}
