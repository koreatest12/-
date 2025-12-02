# Copilot Installation & MCP Server Workflow (Korean)

이 문서는 **GitHub Copilot**과 **GitHub MCP Server**를 설치하고 설정하는 워크플로우를 안내합니다.

## 1. 개요 (Overview)

이 워크플로우는 두 가지 주요 구성 요소를 설치합니다.
1.  **Copilot Installation**: VS Code 확장 프로그램 설치.
2.  **Server Installation**: GitHub Model Context Protocol (MCP) 서버 설치 (Docker 또는 Node.js 사용).

이 구성을 통해 Copilot이 GitHub 리포지토리의 내용을 더 잘 이해하고, 이슈 검색, PR 검토 등의 작업을 수행할 수 있습니다.

## 2. 사전 준비 (Prerequisites)

*   **VS Code**: 최신 버전 설치 (1.101 이상 권장)
*   **GitHub 계정**: Copilot 사용 권한 필요
*   **Docker** 또는 **Node.js**: 서버 실행용

## 3. 설치 단계 (Installation Steps)

### Step 1: GitHub Copilot 설치
1.  VS Code를 엽니다.
2.  확장 프로그램(Extensions) 탭(`Ctrl+Shift+X`)으로 이동합니다.
3.  `GitHub Copilot`을 검색하고 설치합니다.

### Step 2: GitHub PAT (Personal Access Token) 생성
MCP 서버가 GitHub API와 통신하기 위해 토큰이 필요합니다.
1.  [GitHub Tokens](https://github.com/settings/tokens?type=beta) 페이지로 이동합니다.
2.  **Generate new token (fine-grained)**을 클릭합니다.
3.  Repository access를 **All repositories** (또는 원하는 리포지토리)로 설정합니다.
4.  Permissions에서 `Contents`, `Pull requests`, `Issues` 등에 **Read & Write** 권한을 부여합니다.
5.  생성된 토큰을 복사합니다.

### Step 3: MCP 서버 설정 (자동 스크립트 사용)
이 저장소에 포함된 스크립트를 사용하여 설정을 생성할 수 있습니다.

\`\`\`bash
chmod +x setup_mcp.sh
./setup_mcp.sh
\`\`\`

이 스크립트는 PAT를 입력받아 VS Code `settings.json`에 붙여넣을 수 있는 설정 코드를 생성해줍니다.

### Step 4: MCP 서버 설정 (수동)
스크립트를 사용하지 않을 경우, 아래 설정을 `settings.json`에 추가하세요.

**Docker 사용 시:**
\`\`\`json
"vs-code.mcpServers": {
    "github": {
        "command": "docker",
        "args": [
            "run",
            "-i",
            "--rm",
            "-e",
            "GITHUB_PERSONAL_ACCESS_TOKEN",
            "mcp/github"
        ],
        "env": {
            "GITHUB_PERSONAL_ACCESS_TOKEN": "여기에_토큰_입력"
        }
    }
}
\`\`\`

**NPX (Node.js) 사용 시:**
\`\`\`json
"vs-code.mcpServers": {
    "github": {
        "command": "npx",
        "args": [
            "-y",
            "@modelcontextprotocol/server-github"
        ],
        "env": {
            "GITHUB_PERSONAL_ACCESS_TOKEN": "여기에_토큰_입력"
        }
    }
}
\`\`\`

## 4. 확인 (Verification)
1.  설정 후 VS Code를 재시작합니다.
2.  Copilot Chat을 엽니다.
3.  `@github` 명령어를 사용하거나, "Show me open PRs in this repo"와 같이 질문하여 GitHub 서버와 통신이 되는지 확인합니다.
