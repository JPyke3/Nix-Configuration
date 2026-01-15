# Installed plugins configuration for Claude Code
# These are the plugins that are enabled by default
{config, ...}: {
  version = 2;
  plugins = {
    "frontend-design@claude-code-plugins" = [
      {
        scope = "user";
        installPath = "${config.home.homeDirectory}/.claude/plugins/cache/claude-code-plugins/frontend-design/1.0.0";
        version = "1.0.0";
        installedAt = "2025-12-03T06:14:11.920Z";
        lastUpdated = "2025-12-10T02:55:21.116Z";
        gitCommitSha = "4928f2cdcac40e7e684f5102e3818513e70eb8a1";
        isLocal = true;
      }
    ];
    "security-guidance@claude-code-plugins" = [
      {
        scope = "user";
        installPath = "${config.home.homeDirectory}/.claude/plugins/cache/claude-code-plugins/security-guidance/1.0.0";
        version = "1.0.0";
        installedAt = "2025-12-08T06:12:49.112Z";
        lastUpdated = "2025-12-10T02:55:21.116Z";
        gitCommitSha = "de49a076792f56beefb78b18fa60015145532808";
        isLocal = true;
      }
    ];
    "payload@payload-marketplace" = [
      {
        scope = "user";
        installPath = "${config.home.homeDirectory}/.claude/plugins/cache/payload-marketplace/payload/0.0.1";
        version = "0.0.1";
        installedAt = "2025-12-08T06:12:49.112Z";
        lastUpdated = "2025-12-10T02:55:21.116Z";
        gitCommitSha = "617311a88380bfadc9fc99d4b613bf7930cc70ba";
        isLocal = true;
      }
    ];
    "frontend-mobile-development@claude-code-workflows" = [
      {
        scope = "user";
        installPath = "${config.home.homeDirectory}/.claude/plugins/cache/claude-code-workflows/frontend-mobile-development/ddbd034ca35c";
        version = "ddbd034ca35c";
        installedAt = "2025-12-08T06:12:49.112Z";
        lastUpdated = "2025-12-10T02:55:21.116Z";
        gitCommitSha = "ddbd034ca35c6e76af6e54891d83a646e7837b1c";
        isLocal = true;
      }
    ];
  };
}
