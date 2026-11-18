{{define "sign_in.html"}}
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${portal_title} — Authentication</title>
  <style>
    :root {
      --bg: #111827;
      --window-bg: #1f2937;
      --window-header: #374151;
      --border: #4b5563;
      --text: #f9fafb;
      --text-muted: #9ca3af;
      --accent: #a3e635;
      --accent-hover: #bef264;
      --accent-glow: rgba(163, 230, 53, 0.35);
      --accent-glow-strong: rgba(163, 230, 53, 0.6);
      --btn-github: #24292f;
      --btn-github-hover: #1b1f23;
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
      max-width: 440px;
      width: 100%;
      overflow: hidden;
      transition: box-shadow 0.3s;
    }

    .window:hover {
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.8), 0 0 20px var(--accent-glow);
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
      background: rgba(163, 230, 53, 0.12);
      border: 1px solid rgba(163, 230, 53, 0.3);
      color: var(--accent);
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 20px;
      box-shadow: 0 0 15px var(--accent-glow);
    }

    h1 {
      font-size: 22px;
      font-weight: 700;
      letter-spacing: -0.02em;
      margin-bottom: 8px;
    }

    .subtitle {
      font-size: 13px;
      color: var(--text-muted);
      line-height: 1.5;
      margin-bottom: 28px;
    }

    .btn-github {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      width: 100%;
      padding: 12px 20px;
      background-color: var(--btn-github);
      color: #ffffff;
      border: 1px solid var(--border);
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3);
      transition: all 0.2s ease-in-out;
    }

    .btn-github:hover {
      background-color: var(--btn-github-hover);
      border-color: var(--accent);
      box-shadow: 0 0 15px var(--accent-glow);
      transform: translateY(-1px);
    }

    .btn-github:active {
      transform: translateY(0);
    }

    .btn-github svg {
      width: 18px;
      height: 18px;
      fill: currentColor;
    }

    .footer {
      margin-top: 28px;
      padding-top: 18px;
      border-top: 1px solid var(--border);
      font-size: 11px;
      color: var(--text-muted);
      font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    }

    .footer-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      color: var(--accent);
      margin-top: 6px;
    }

    .dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background-color: var(--accent);
      box-shadow: 0 0 6px var(--accent);
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
      <div class="window-title">gateway</div>
    </div>

    <div class="window-body">
      <div class="badge-icon">
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
          <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
        </svg>
      </div>

      <h1>${portal_title}</h1>
      <p class="subtitle">${portal_description}</p>

      <form method="GET" action="{{.ProxyPrefix}}/start">
        <input type="hidden" name="rd" value="{{.Redirect}}">
        <button type="submit" class="btn-github">
          <svg viewBox="0 0 24 24">
            <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
          </svg>
          <span>Sign in with {{if .ProviderName}}{{.ProviderName}}{{else}}GitHub{{end}}</span>
        </button>
      </form>

      <div class="footer">
        <div>${portal_title} • Identity &amp; Access Gateway</div>
        <div class="footer-badge">
          <span class="dot"></span>
          <span>Encrypted Gateway Connection</span>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
{{end}}
