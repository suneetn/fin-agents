---
allowed-tools: Bash, Read, Write
description: Generate uber_email HTML without running agents - use mock data for rapid template iteration
argument-hint: [output_filename]
---

**MOCK VERSION:** Rapid HTML/CSS iteration with sample data - NO agent calls, instant output.

Generate the uber_email HTML report using mock data instead of running agents. Perfect for:
- 🎨 Iterating on template design/styling
- ⚡ Instant previews (seconds vs minutes)
- 🧪 Testing layouts with different data scenarios
- 🔧 CSS/HTML debugging without agent overhead

**Usage:**
```bash
/uber_email_mock                        # outputs/uber_email_mock.html
/uber_email_mock my-design.html          # outputs/my-design.html
```

**Steps:**

1. **Check for output filename** ($1)
   - If provided: use `outputs/$1`
   - If not: use `outputs/uber_email_mock.html`

2. **Install dependencies** (if needed):
   ```bash
   pip install jinja2 jsonschema
   ```

3. **Render template with mock data**:
   ```bash
   python3 src/renderer.py "layouts/email-compact.html" mocks/email-compact-sample.json -o "outputs/uber_email_mock.html"
   ```

4. **Open in browser**:
   ```bash
   open "outputs/uber_email_mock.html"  # macOS
   ```

5. **Show success message**:
   ```
   ✅ Mock email generated: outputs/uber_email_mock.html
   🎨 Edit templates/layouts/email-compact.html to iterate on design
   ⚡ Run /uber_email_mock again to see changes instantly
   ```

**Fast Iteration Workflow:**
1. Edit template (HTML/CSS)
2. Run `/uber_email_mock`
3. See results in browser (instant!)
4. Repeat until design is perfect
5. Switch to real `/uber_email` when ready

**Mock Data Scenarios:**
Generate different market scenarios for testing:
```bash
# Bullish market
python mocks/generate_mocks.py --scenario bull --stocks 10

# Bearish market
python mocks/generate_mocks.py --scenario bear --stocks 5

# Neutral market (default)
python mocks/generate_mocks.py --scenario neutral --stocks 8
```

**Key Benefits:**
- ⚡ **Instant** - No agent overhead, renders in <1 second
- 🎨 **Design-focused** - Perfect for HTML/CSS iteration
- 🧪 **Testable** - Try different data scenarios easily
- 💰 **Cost-free** - No API calls during design phase
