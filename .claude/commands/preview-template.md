---
allowed-tools: Bash, Read, Write
description: Preview template with mock data for fast design iteration
argument-hint: <template-name>
---

Preview the **$1** template using mock data - instant HTML rendering without running agents.

**Steps to execute:**

1. Check if template name was provided ($1)
   - If no argument: list available templates and exit

2. Set up paths:
   - Template: `layouts/$1.html` (if $1 doesn't include `.html`)
   - Mock data: `mocks/email-compact-sample.json` (default)
   - Output: `outputs/preview-$1.html`

3. Install dependencies if needed:
   ```bash
   pip install jinja2 jsonschema
   ```

4. Render the template:
   ```bash
   python3 src/renderer.py "layouts/$1.html" mocks/email-compact-sample.json -o "outputs/preview-$1.html"
   ```

5. Open in browser:
   ```bash
   open "outputs/preview-$1.html"  # macOS
   ```

**Example commands:**
- `/preview-template email-compact` - Preview compact email layout
- `/preview-template` - List available templates

**Fast Iteration Workflow:**
1. Edit template design (HTML/CSS)
2. Run `/preview-template email-compact`
3. See results instantly in browser
4. Iterate until satisfied
5. No agents needed - preview in seconds!
