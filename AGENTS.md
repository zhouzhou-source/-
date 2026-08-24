# AGENTS.md

## Cursor Cloud specific instructions

This repository is **PowerShell dotfiles / notes** (originally authored for Windows + VS Code), not a
buildable client/server application. There are no services, no package manifest, and no build step.
The only meaningful "application" is the PowerShell profile `Microsoft.PowerShell_profile.ps1`, which
customizes the interactive prompt (renders the current path, substituting `C:\Users\WJD` with `~`, then `> `).

The startup update script installs the PowerShell runtime (`pwsh`, from Microsoft's apt repo) and the
`PSScriptAnalyzer` linter, so both are available by the time an agent starts. Notes for working here:

- Run scripts / interactive shell: `pwsh` (PowerShell 7.x on Linux). Start a session with `pwsh`; it
  auto-loads the repo profile only if it has been copied to `$PROFILE`
  (`~/.config/powershell/Microsoft.PowerShell_profile.ps1`). Use `pwsh -NoProfile` to run without the profile.
- To exercise the profile the way a user would, copy it into place first:
  `pwsh -NoProfile -Command 'Copy-Item -Force /workspace/Microsoft.PowerShell_profile.ps1 $PROFILE.CurrentUserCurrentHost'`
  (the parent dir may need creating). This is a run-time action, intentionally NOT in the update script.
- Lint: `pwsh -NoProfile -Command 'Invoke-ScriptAnalyzer -Path . -Recurse'`. Existing files only emit
  style Warnings/Information (e.g. `PSAvoidUsingWriteHost`, trailing whitespace) — no errors. Do not treat
  these as failures; they are inherent to the existing profile and should not be "fixed" unless requested.
- Syntax-only check: parse with `[System.Management.Automation.Language.Parser]::ParseFile(...)`.
- Gotcha: the profile's `oh-my-posh` / `posh-git` block is gated behind `$env:TERM_PROGRAM -eq "vscode"`,
  so those Windows-only tools are NOT required and will not run in a normal Linux terminal.
- Gotcha: the prompt prints the path with `-ForegroundColor White`, so on a light/white terminal background
  the path is invisible and only `> ` shows. The path IS being rendered — check output in a dark terminal
  or via captured text if you need to see it.
