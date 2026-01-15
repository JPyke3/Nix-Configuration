# Plugin marketplace definitions for Claude Code
# These define where plugins can be fetched from
{config, ...}: {
  "claude-code-plugins" = {
    source = {
      source = "git";
      url = "https://github.com/anthropics/claude-code.git";
    };
    installLocation = "${config.home.homeDirectory}/.claude/plugins/marketplaces/claude-code-plugins";
    lastUpdated = "2026-01-07T00:19:56.490Z";
  };
  "payload-marketplace" = {
    source = {
      source = "git";
      url = "https://github.com/payloadcms/payload.git";
    };
    installLocation = "${config.home.homeDirectory}/.claude/plugins/marketplaces/payload-marketplace";
    lastUpdated = "2025-12-25T11:27:33.547Z";
  };
  "claude-code-workflows" = {
    source = {
      source = "git";
      url = "https://github.com/wshobson/agents.git";
    };
    installLocation = "${config.home.homeDirectory}/.claude/plugins/marketplaces/claude-code-workflows";
    lastUpdated = "2025-12-08T06:12:47.438Z";
  };
  "claude-plugins-official" = {
    source = {
      source = "github";
      repo = "anthropics/claude-plugins-official";
    };
    installLocation = "${config.home.homeDirectory}/.claude/plugins/marketplaces/claude-plugins-official";
    lastUpdated = "2026-01-07T00:25:37.485Z";
  };
}
