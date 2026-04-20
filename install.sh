#!/usr/bin/env bash
# AIBTI · One-line installer
# Usage:
#   curl -sL https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main/install.sh | bash
#
# What it does:
#   1. Downloads the aibti Skill to ~/.claude/skills/aibti/
#   2. (Optional) Installs the UserPromptSubmit hook for future prompts
#
# What it does NOT do:
#   - Send any data anywhere
#   - Install global dependencies
#   - Modify anything outside ~/.claude/ and ~/.aibti/

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
REPO_RAW="https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main"
SKILL_DIR="$HOME/.claude/skills/aibti"
AIBTI_DATA="$HOME/.aibti"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  AIBTI Installer · ${NC}Your AI Conversation Personality"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 1. Verify Claude Code is installed
if [ ! -d "$HOME/.claude" ]; then
    echo -e "${YELLOW}⚠ ~/.claude not found. Install Claude Code first:${NC}"
    echo "   https://docs.claude.com/claude-code"
    exit 1
fi

# 2. Install Skill
echo -e "${YELLOW}[1/2] Installing skill to ${SKILL_DIR}...${NC}"
mkdir -p "$SKILL_DIR"
curl -sfL "$REPO_RAW/skills/aibti/SKILL.md" -o "$SKILL_DIR/SKILL.md"
echo -e "${GREEN}  ✓ Skill installed.${NC}"

# 3. Prepare data dir
mkdir -p "$AIBTI_DATA"
chmod 700 "$AIBTI_DATA"
echo -e "${GREEN}  ✓ Data dir ready at $AIBTI_DATA (mode 700, only you can read).${NC}"

# 4. Optional: hook for future prompts
echo ""
echo -e "${YELLOW}[2/2] (Optional) Install hook to capture future prompts in a unified format?${NC}"
echo "   - Without hook: AIBTI still works by reading existing ~/.claude/projects/"
echo "   - With hook:    Future prompts are additionally recorded to ~/.aibti/prompts.jsonl"
echo ""
read -p "   Install hook? [y/N]: " install_hook

if [[ "$install_hook" =~ ^[Yy]$ ]]; then
    HOOK_SCRIPT="$AIBTI_DATA/record.py"
    curl -sfL "$REPO_RAW/hooks/record.py" -o "$HOOK_SCRIPT"
    chmod +x "$HOOK_SCRIPT"
    echo -e "${GREEN}  ✓ Hook script installed at $HOOK_SCRIPT${NC}"
    echo ""
    echo -e "${YELLOW}  Add this to ~/.claude/settings.json (merge under 'hooks'):${NC}"
    cat <<EOF
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [{"type":"command","command":"python3 $HOOK_SCRIPT","timeout":2}]
      }
    ]
EOF
    echo ""
else
    echo -e "${BLUE}  (skipped — you can re-run this installer anytime)${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ AIBTI installed.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Restart Claude Code (or open a new session)"
echo "  2. In any conversation, just say:"
echo -e "     ${GREEN}Analyze my AIBTI${NC}    (English)"
echo -e "     ${GREEN}测一下我的 AIBTI${NC}    (中文)"
echo ""
echo -e "${BLUE}Privacy:${NC} AIBTI is 100% local. See https://github.com/leefufufufufu-rgb/aibti/blob/main/PRIVACY.md"
echo -e "${BLUE}Uninstall:${NC} rm -rf $SKILL_DIR $AIBTI_DATA"
