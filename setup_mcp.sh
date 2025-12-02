#!/bin/bash

# Copilot & MCP Server Setup Helper Script
# This script helps generate the configuration needed to use GitHub MCP Server with VS Code Copilot.

echo "=========================================================="
echo "   GitHub Copilot & MCP Server Setup Workflow Helper"
echo "=========================================================="

# 1. Check Prerequisites
echo ""
echo "[Step 1] Checking prerequisites..."

if command -v node &> /dev/null; then
    echo "✅ Node.js is installed ($(node -v))"
    HAS_NODE=true
else
    echo "⚠️ Node.js is not installed. You may need it if running via NPX."
    HAS_NODE=false
fi

if command -v docker &> /dev/null; then
    echo "✅ Docker is installed"
    HAS_DOCKER=true
else
    echo "⚠️ Docker is not installed."
    HAS_DOCKER=false
fi

if [ "$HAS_NODE" = false ] && [ "$HAS_DOCKER" = false ]; then
    echo "❌ Neither Node.js nor Docker found. Please install one of them to run MCP Server."
    exit 1
fi

# 2. GitHub PAT Input
echo ""
echo "[Step 2] GitHub Personal Access Token (PAT) Setup"
echo "You need a GitHub PAT with 'repo' scope."
echo "If you don't have one, generate it here: https://github.com/settings/tokens?type=beta"
echo ""
read -sp "Enter your GitHub PAT: " GITHUB_PAT
echo ""

if [ -z "$GITHUB_PAT" ]; then
    echo "❌ No token entered. Exiting."
    exit 1
fi

# 3. Generate Configuration
echo ""
echo "[Step 3] Configuration for VS Code"
echo "Add the following to your VS Code 'settings.json' (or search for 'MCP Servers' in settings):"
echo ""

echo "----------------------------------------------------------"
echo "Option A: Using NPX (Requires Node.js)"
echo "----------------------------------------------------------"
cat <<EOF
"vs-code.mcpServers": {
    "github": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-github"],
        "env": {
            "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_PAT"
        }
    }
}
EOF

echo ""
echo "----------------------------------------------------------"
echo "Option B: Using Docker"
echo "----------------------------------------------------------"
cat <<EOF
"vs-code.mcpServers": {
    "github": {
        "command": "docker",
        "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "mcp/github"],
        "env": {
            "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_PAT"
        }
    }
}
EOF

echo ""
echo "----------------------------------------------------------"
echo "Instructions:"
echo "1. Open VS Code."
echo "2. Open Command Palette (Cmd+Shift+P / Ctrl+Shift+P)."
echo "3. Type 'Preferences: Open User Settings (JSON)'."
echo "4. Paste one of the blocks above into the JSON file."
echo "5. Reload VS Code."
echo "=========================================================="
