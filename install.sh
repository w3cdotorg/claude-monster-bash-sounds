#!/bin/bash
set -e

SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "=== Claude Code Monster Bash Sound Effects Installer ==="
echo ""

# Create sounds directory
mkdir -p "$SOUNDS_DIR"

# Copy sounds
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR"/sounds/*.wav "$SOUNDS_DIR/"
echo "[OK] Sounds copied to $SOUNDS_DIR"

# Hooks configuration
HOOKS='{
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Dracula_-_Welcome_to_the_Monster_Bash.mp3 &"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Bride_of_Frankenstein_-_Noooo.mp3 &"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Bride_of_Frankenstein_-_Get_your_grubby_paws_off_me.mp3 &"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "AskUserQuestion",
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Dracula_-_Get_on_your_feet_and_jam.mp3 &"
          }
        ]
      },
      {
        "matcher": "ExitPlanMode",
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Dracula_-_Form_the_moshpit.mp3 &"
          }
        ]
      }
    ],
    "Elicitation": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Dracula_-_Over_here_garlic_bread.mp3 &"
          }
        ]
      }
    ],
    "PostToolUseFailure": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Dracula_-_Ow.mp3 &"
          }
        ]
      }
    ],
    "SubagentStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Dracula_-_Lets_rock.mp3 &"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Wolfman_-_Im_outta_here.mp3 &"
          }
        ]
      }
    ],
    "PermissionRequest": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Mummy_-_I_wanna_jam.mp3 &"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Doctor_-_Get_ready_while_I_flip_the_switch.mp3 &"
          }
        ]
      }
    ],
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "afplay '"$SOUNDS_DIR"'/Dracula_-_Jackpot.mp3 &"
          }
        ]
      }
    ]
  }'

# Check if settings.json exists
if [ -f "$SETTINGS_FILE" ]; then
  # Check if hooks already exist
  if grep -q '"hooks"' "$SETTINGS_FILE"; then
    echo ""
    echo "[WARNING] Your settings.json already has a \"hooks\" section."
    echo "To avoid overwriting your config, the hooks have been saved to:"
    echo "  $SCRIPT_DIR/hooks.json"
    echo ""
    echo "Please merge them manually into: $SETTINGS_FILE"
    echo "$HOOKS" > "$SCRIPT_DIR/hooks.json"
  else
    # Add hooks to existing settings using a temp file
    TMP=$(mktemp)
    # Remove trailing } and add hooks
    sed '$ d' "$SETTINGS_FILE" > "$TMP"
    echo '  ,"hooks": '"$HOOKS" >> "$TMP"
    echo '}' >> "$TMP"
    mv "$TMP" "$SETTINGS_FILE"
    echo "[OK] Hooks added to $SETTINGS_FILE"
  fi
else
  # Create new settings.json
  mkdir -p "$HOME/.claude"
  echo '{"hooks": '"$HOOKS"'}' > "$SETTINGS_FILE"
  echo "[OK] Created $SETTINGS_FILE with hooks"
fi

echo ""
echo "=== Installation complete! ==="
echo "Restart Claude Code to activate the sounds."
echo ""
echo "Test a sound: afplay $SOUNDS_DIR/Dracula_-_Welcome_to_the_Monster_Bash.mp3"
