{{define "error.html"}}
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${portal_title} — {{.StatusCode}} {{.Title}}</title>
  <style>
    :root {
      --bg: #111827;
      --window-bg: #1f2937;
      --window-header: #374151;
      --border: #4b5563;
      --text: #f9fafb;
      --text-muted: #9ca3af;
      --accent: #a3e635;
      --accent-glow: rgba(163, 230, 53, 0.35);
      --danger: #f87171;
      --danger-bg: rgba(248, 113, 113, 0.12);
      --danger-border: rgba(248, 113, 113, 0.3);
      --danger-glow: rgba(248, 113, 113, 0.35);
      --btn-secondary: #374151;
      --btn-secondary-hover: #4b5563;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      background-color: var(--bg);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    .window {
      background: var(--window-bg);
      border: 1px solid var(--border);
      border-radius: 12px;
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
      max-width: 480px;
      width: 100%;
      overflow: hidden;
      transition: box-shadow 0.3s;
    }

    .window:hover {
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.8), 0 0 20px var(--danger-glow);
    }

    /* Terminal/macOS Window Header */
    .window-header {
      background: var(--window-header);
      padding: 12px 16px;
      display: flex;
      align-items: center;
      gap: 12px;
      border-bottom: 1px solid var(--border);
    }

    .traffic-lights {
      display: flex;
      gap: 6px;
    }

    .light {
      width: 11px;
      height: 11px;
      border-radius: 50%;
    }

    .light-red { background-color: #f87171; }
    .light-yellow { background-color: #facc15; }
    .light-green { background-color: #4ade80; }

    .window-title {
      flex: 1;
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
      font-size: 11px;
      color: var(--text-muted);
      letter-spacing: 0.04em;
    }

    /* Content Area */
    .window-body {
      padding: 36px 32px;
      text-align: center;
    }

    .badge-icon {
      width: 52px;
      height: 52px;
      border-radius: 12px;
      background: var(--danger-bg);
      border: 1px solid var(--danger-border);
      color: var(--danger);
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 16px;
      box-shadow: 0 0 15px var(--danger-glow);
    }

    .status-code {
      display: inline-block;
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
      font-size: 12px;
      font-weight: 700;
      color: var(--danger);
      background: var(--danger-bg);
      border: 1px solid var(--danger-border);
      padding: 3px 10px;
      border-radius: 9999px;
      margin-bottom: 12px;
      letter-spacing: 0.05em;
    }

    h1 {
      font-size: 22px;
      font-weight: 700;
      letter-spacing: -0.02em;
      margin-bottom: 10px;
    }

    .description {
      font-size: 13px;
      color: var(--text-muted);
      line-height: 1.6;
      margin-bottom: 24px;
    }

    /* Monospace Terminal Box for Error Message */
    .terminal-box {
      background: #0f172a;
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 12px 14px;
      text-align: left;
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
      font-size: 12px;
      color: #e2e8f0;
      margin-bottom: 24px;
      word-break: break-all;
      line-height: 1.5;
    }

    .terminal-prompt {
      color: var(--accent);
      margin-right: 6px;
    }

    .actions {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      width: 100%;
      padding: 11px 18px;
      border-radius: 8px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      transition: all 0.2s ease-in-out;
    }

    .btn-primary {
      background-color: var(--accent);
      color: #0f172a;
      border: 1px solid var(--accent);
      box-shadow: 0 0 15px var(--accent-glow);
    }

    .btn-primary:hover {
      background-color: #bef264;
      transform: translateY(-1px);
      box-shadow: 0 0 20px var(--accent-glow);
    }

    .btn-secondary {
      background-color: var(--btn-secondary);
      color: var(--text);
      border: 1px solid var(--border);
    }

    .btn-secondary:hover {
      background-color: var(--btn-secondary-hover);
      transform: translateY(-1px);
    }

    .btn:active {
      transform: translateY(0);
    }

    .footer {
      margin-top: 28px;
      padding-top: 18px;
      border-top: 1px solid var(--border);
      font-size: 11px;
      color: var(--text-muted);
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    }

    .req-id {
      margin-top: 4px;
      color: #6b7280;
    }
  </style>
</head>
<body>
  <div class="window">
    <div class="window-header">
      <div class="traffic-lights">
        <div class="light light-red"></div>
        <div class="light light-yellow"></div>
        <div class="light light-green"></div>
      </div>
      <div class="window-title">access-denied</div>
    </div>

    <div class="window-body">
      <div class="badge-icon">
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"></line>
        </svg>
      </div>

      <div>
        <span class="status-code">ERROR {{.StatusCode}}</span>
      </div>

      <h1>Access Denied</h1>

      <p class="description">
        Your account was authenticated, but it is not listed among authorized users for this application. Please contact the administrator to request access.
      </p>

      {{if .Message}}
      <div class="terminal-box">
        <span class="terminal-prompt">&gt;</span>{{.Message}}
      </div>
      {{end}}

      <div class="actions">
        <a href="{{.ProxyPrefix}}/sign_in?rd={{.Redirect}}" class="btn btn-primary">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
            <polyline points="10 17 15 12 10 7"></polyline>
            <line x1="15" y1="12" x2="3" y2="12"></line>
          </svg>
          <span>Sign In with Another Account</span>
        </a>

        <a href="/" class="btn btn-secondary">
          Return to Homepage
        </a>
      </div>

      <div class="footer">
        <div>${portal_title} • Identity &amp; Access Gateway</div>
        {{if .RequestID}}
        <div class="req-id">request_id: {{.RequestID}}</div>
        {{end}}
      </div>
    </div>
  </div>
</body>
</html>
{{end}}
