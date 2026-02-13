{ inputs, pkgs, ... }:
{
  programs.ai-tools = {
    enable = true;
    opencode = {
      useRecommendedRouting = false;
      model = "anthropic/claude-sonnet-4-20250514";
      modelByAgent = {
        oracle = "anthropic/claude-opus-4-20250514";
        metis = "anthropic/claude-opus-4-20250514";
        momus = "anthropic/claude-opus-4-20250514";
        explore = "anthropic/claude-sonnet-4-20250514";
        librarian = "anthropic/claude-sonnet-4-20250514";
        atlas = "anthropic/claude-sonnet-4-20250514";
        sisyphus-junior = "anthropic/claude-sonnet-4-20250514";
        multimodal-looker = "anthropic/claude-sonnet-4-20250514";
      };
      modelByCategory = {
        quick = "anthropic/claude-sonnet-4-20250514";
        writing = "anthropic/claude-sonnet-4-20250514";
        unspecified-low = "anthropic/claude-sonnet-4-20250514";
        unspecified-high = "anthropic/claude-opus-4-20250514";
        visual-engineering = "anthropic/claude-sonnet-4-20250514";
        deep = "anthropic/claude-opus-4-20250514";
        ultrabrain = "anthropic/claude-opus-4-20250514";
        artistry = "anthropic/claude-opus-4-20250514";
      };
    };
  };

  home.packages = [ pkgs.spec-kit ];

  # Install Claude skills manually (until module supports them)
  home.file.".claude/skills/lint-with-conform".source = "${inputs.ai-tools}/skills/lint-with-conform";
  home.file.".claude/skills/nixos-advisor".source = "${inputs.ai-tools}/skills/nixos-advisor";
  home.file.".claude/skills/obsidian-worklog".source = "${inputs.ai-tools}/skills/obsidian-worklog";
}
