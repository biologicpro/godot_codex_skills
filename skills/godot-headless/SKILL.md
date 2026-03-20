---
name: godot-headless
description: Run reusable Godot Engine headless validation for project startup checks or scene smoke tests. Use when a user asks to run Godot without GUI, verify that a project boots in CI/headless mode, validate a specific scene with --quit-after, or triage runtime/script/resource errors from command-line Godot runs.
---

# Godot Headless

Run headless Godot checks via `scripts/run_headless_check.sh`.

## Workflow

1. Select check mode.
- Startup check: verify project boot only.
- Scene check: run a specific `res://...` scene for a bounded number of frames.

2. Run the script with explicit project path when possible.

```bash
# Startup check
scripts/run_headless_check.sh --project /path/to/project

# Scene smoke test
scripts/run_headless_check.sh \
  --project /path/to/project \
  --scene res://tscn/tween_preview.tscn \
  --quit-after 180
```

3. Handle expected project-specific errors with allow patterns.

```bash
scripts/run_headless_check.sh \
  --project /path/to/project \
  --scene res://tscn/tween_preview.tscn \
  --allow-error "Cannot open file 'res://poem/assets/poem.en.translation'." \
  --allow-error "Failed loading resource: res://poem/assets/poem.en.translation." \
  --allow-error "Unable to open file: res://.godot/imported/Board_NightMarket.png-"
```

4. Review exit behavior.
- Exit `0`: headless run succeeded and no unexpected errors were found.
- Non-zero exit: Godot process failed or unexpected errors were detected.

## Script Behavior

- Default binary resolution order:
1. `$GODOT_BIN`
2. `godot` found in `PATH`
3. `~/Documents/Godot.app/Contents/MacOS/Godot`

- Default mode is strict error scanning: any `ERROR:` / `SCRIPT ERROR:` line fails unless matched by ignore patterns.
- Default mode isolates `HOME` per run to avoid user-data/log collisions in frequent headless runs.
- A known macOS isolated-HOME certificate lookup error is ignored by default.
- Use `--no-isolate-home` if a project needs persistent user data from the normal HOME.
- Use `--no-strict-errors` if only process exit status matters.
- Pass additional Godot flags with repeated `--extra-arg`.

## Resources

### scripts/
- `run_headless_check.sh`: parameterized Godot headless validator for startup and scene checks.
