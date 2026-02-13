{ inputs, pkgs, ... }:
{
  programs.ai-tools = {
    enable = true;
    opencode = {
      useRecommendedRouting = false;
      model = "anthropic/claude-opus-4-6";
      modelByAgent = {
        oracle = "anthropic/claude-opus-4-6";
        metis = "anthropic/claude-opus-4-6";
        momus = "anthropic/claude-opus-4-6";
        explore = "anthropic/claude-haiku-4-5-20251001";
        librarian = "anthropic/claude-haiku-4-5-20251001";
        atlas = "anthropic/claude-haiku-4-5-20251001";
        sisyphus-junior = "anthropic/claude-sonnet-4-5-20250929";
        multimodal-looker = "anthropic/claude-sonnet-4-5-20250929";
      };
      modelByCategory = {
        quick = "anthropic/claude-sonnet-4-5-20250929";
        writing = "anthropic/claude-sonnet-4-5-20250929";
        unspecified-low = "anthropic/claude-sonnet-4-5-20250929";
        unspecified-high = "anthropic/claude-opus-4-6";
        visual-engineering = "anthropic/claude-sonnet-4-5-20250929";
        deep = "anthropic/claude-opus-4-6";
        ultrabrain = "anthropic/claude-opus-4-6";
        artistry = "anthropic/claude-opus-4-6";
      };
    };
  };

  home.packages = [ pkgs.spec-kit ];

  # Install Claude skills manually (until module supports them)
  home.file.".claude/skills/lint-with-conform".source = "${inputs.ai-tools}/skills/lint-with-conform";
  home.file.".claude/skills/nixos-advisor".source = "${inputs.ai-tools}/skills/nixos-advisor";
  home.file.".claude/skills/obsidian-worklog".source = "${inputs.ai-tools}/skills/obsidian-worklog";
}
