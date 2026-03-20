# godo_codex_skills

Godot 工作流用的開源 Codex skills 套件。

## Included Skills

- `godot-headless`: 可重用的 Godot headless 啟動/場景檢查，支援錯誤 allow-list。

## Clone 後安裝方式（給使用者）

```bash
cd godo_codex_skills
./install.sh
```

重啟 Codex。

## 使用說明

列出此套件可安裝的 skills：

```bash
./install.sh --list
```

只安裝單一 skill：

```bash
./install.sh --skill godot-headless
```

覆蓋已安裝版本：

```bash
./install.sh --skill godot-headless --force
```

預覽安裝動作（不實際寫入）：

```bash
./install.sh --dry-run
```

安裝到自訂目錄：

```bash
./install.sh --dest "$HOME/.codex/skills"
```

## 在 Codex 中使用

安裝並重啟後，可在提示裡直接要求使用 skill，例如：

- `使用 $godot-headless 幫我做這個 Godot 專案的 headless 檢查`
- `使用 $godot-headless 跑 res://tscn/tween_preview.tscn，quit-after 180`

## 直接用 GitHub URL 安裝（可選）

如果你把此 repo 發到 GitHub，使用者也可不 clone、直接安裝：

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --url https://github.com/<owner>/<repo>/tree/main/godo_codex_skills/skills/godot-headless
```

安裝後同樣要重啟 Codex。

## Best Practices（建議）

- 每個 skill 維持在 `skills/<skill-name>/` 且包含 `SKILL.md`。
- 腳本放在各 skill 的 `scripts/` 內，保持自包含。
- 用 Git tag/release 發版，讓使用者可 pin 穩定版本。
- 儘量做向後相容更新；需要覆蓋時再讓使用者使用 `--force`。
