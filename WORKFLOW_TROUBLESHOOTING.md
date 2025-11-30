# GitHub Actions Workflow Troubleshooting Guide

## Overview
This guide addresses common issues encountered in CI/CD pipelines with security scanning and SARIF uploads.

---

## 🔴 SARIF Upload Errors

### Error: "Resource not accessible by integration"

**Full Error Message:**
```
Warning: This run of the CodeQL Action does not have permission to access the CodeQL Action API endpoints. 
This could be because the Action is running on a pull request from a fork. If not, please ensure the workflow 
has at least the 'security-events: read' permission.
```

**Root Cause:**
- GitHub Actions workflows need explicit permissions to upload SARIF results to the Security tab
- Default `GITHUB_TOKEN` has read-only permissions for security events

**Solution:**
Add permissions block at the workflow level:

```yaml
name: CI Pipeline

on:
  push:
    branches-ignore: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read
  security-events: write  # Required for SARIF uploads
  actions: read

jobs:
  # ... rest of workflow
```

**Why This Works:**
- `security-events: write` grants permission to upload security findings
- `contents: read` allows checking out code
- `actions: read` enables workflow status checks

---

### Error: "Path does not exist: trivy-results.sarif"

**Full Error Message:**
```
Error: Path does not exist: trivy-results.sarif
```

**Root Cause:**
- Upload step runs even when the scan step fails or is skipped
- SARIF file only created when scan completes successfully
- Using `if: always()` runs upload regardless of previous step status

**Solution:**
Add file existence check to upload condition:

```yaml
- name: Run Trivy container scan
  uses: aquasecurity/trivy-action@master
  continue-on-error: true
  with:
    image-ref: 'taskflow:${{ github.sha }}'
    format: 'sarif'
    output: 'trivy-results.sarif'
    severity: 'CRITICAL,HIGH'
    exit-code: '0'

- name: Upload Trivy scan results to GitHub Security
  uses: github/codeql-action/upload-sarif@v4
  if: always() && hashFiles('trivy-results.sarif') != ''  # Only if file exists
  continue-on-error: true
  with:
    sarif_file: 'trivy-results.sarif'
    category: 'container-security'
```

**Why This Works:**
- `hashFiles('trivy-results.sarif') != ''` returns true only if file exists
- `always()` ensures we try to upload even if previous steps failed
- `continue-on-error: true` prevents workflow failure if upload fails

---

### Warning: "CodeQL Action v3 will be deprecated in December 2026"

**Full Warning Message:**
```
Warning: CodeQL Action v3 will be deprecated in December 2026. 
Please update all occurrences of the CodeQL Action in your workflow files to v4.
```

**Root Cause:**
- Using outdated version: `github/codeql-action/upload-sarif@v3`
- GitHub deprecating older API versions

**Solution:**
Update to v4:

```yaml
# OLD - Deprecated
- name: Upload Trivy results
  uses: github/codeql-action/upload-sarif@v3
  
# NEW - Current
- name: Upload Trivy results
  uses: github/codeql-action/upload-sarif@v4
```

**Migration Checklist:**
- [ ] Update CI workflow (`ci.yml`)
- [ ] Update CD workflow (`cd.yml`)
- [ ] Search for all instances: `grep -r "codeql-action.*@v3" .github/`
- [ ] Test workflow runs successfully

---

## 🔵 Multiple SARIF Uploads

### Issue: Multiple scanners uploading to same category

**Problem:**
When multiple security scanners upload results, they can overwrite each other in the Security tab.

**Solution:**
Use different categories for each scanner:

```yaml
# Trivy container scan in CI
- name: Upload Trivy scan results
  uses: github/codeql-action/upload-sarif@v4
  with:
    sarif_file: 'trivy-results.sarif'
    category: 'container-security'  # Unique category

# Checkov IaC scan
- name: Upload Checkov results
  uses: github/codeql-action/upload-sarif@v4
  with:
    sarif_file: 'checkov-results.sarif'
    category: 'iac-security'  # Different category

# Trivy in CD pipeline
- name: Upload Trivy results
  uses: github/codeql-action/upload-sarif@v4
  with:
    sarif_file: 'trivy-results.sarif'
    category: 'container-security-cd'  # Separate from CI
```

**Benefits:**
- Each scanner's results visible separately
- No overwriting of results
- Clear source identification in Security tab
- Better tracking of scan history

---

## 🟢 Pull Request from Fork Issues

### Issue: SARIF uploads fail on fork PRs

**Problem:**
GitHub restricts permissions for PRs from forked repositories for security reasons.

**Expected Behavior:**
- Fork PRs: SARIF upload fails (expected and acceptable)
- Direct branch PRs: SARIF upload succeeds

**Solution:**
Add `continue-on-error: true` for graceful degradation:

```yaml
- name: Upload Trivy scan results
  uses: github/codeql-action/upload-sarif@v4
  if: always() && hashFiles('trivy-results.sarif') != ''
  continue-on-error: true  # Don't fail workflow if upload fails
  with:
    sarif_file: 'trivy-results.sarif'
    category: 'container-security'
```

**Why This Matters:**
- Workflow completes successfully
- Security scans still run and show in logs
- SARIF upload is best-effort, not critical for pipeline success

---

## 🔧 Complete Working Example

### Full CI Workflow with All Fixes Applied

```yaml
name: CI Pipeline

on:
  push:
    branches-ignore: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read
  security-events: write
  actions: read

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: false
          tags: taskflow:${{ github.sha }}

      - name: Run Trivy container scan
        uses: aquasecurity/trivy-action@master
        continue-on-error: true
        with:
          image-ref: 'taskflow:${{ github.sha }}'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'
          exit-code: '0'

      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v4
        if: always() && hashFiles('trivy-results.sarif') != ''
        continue-on-error: true
        with:
          sarif_file: 'trivy-results.sarif'
          category: 'container-security'

  security-scan:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Checkov for IaC
        uses: bridgecrewio/checkov-action@master
        with:
          directory: terraform
          framework: terraform
          output_format: sarif
          output_file_path: checkov-results.sarif
          soft_fail: true

      - name: Upload Checkov results
        uses: github/codeql-action/upload-sarif@v4
        if: always() && hashFiles('checkov-results.sarif') != ''
        continue-on-error: true
        with:
          sarif_file: checkov-results.sarif
          category: 'iac-security'
```

---

## 📊 Verification Steps

After applying fixes, verify:

1. **Check Workflow Syntax:**
   ```bash
   # Use GitHub Actions extension in VS Code
   # Or validate with actionlint
   actionlint .github/workflows/*.yml
   ```

2. **Test Locally (if possible):**
   ```bash
   # Install act for local testing
   act pull_request
   ```

3. **Monitor First Run:**
   - Push changes to a branch
   - Open PR to main
   - Watch Actions tab for successful run
   - Check Security tab for uploaded results

4. **Verify Security Tab:**
   - Navigate to repository Security > Code scanning alerts
   - Should see results from Trivy and Checkov
   - Each in its own category

---

## 📚 Additional Resources

- [GitHub Actions Permissions](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token)
- [SARIF Upload Action](https://github.com/github/codeql-action/tree/main/upload-sarif)
- [Trivy GitHub Action](https://github.com/aquasecurity/trivy-action)
- [Checkov GitHub Action](https://github.com/bridgecrewio/checkov-action)

---

## 🎯 Key Takeaways

1. **Always set permissions explicitly** - Don't rely on defaults
2. **Check file existence before upload** - Prevent "file not found" errors
3. **Use latest action versions** - Stay current with deprecations
4. **Allow graceful failures** - Use `continue-on-error` appropriately
5. **Categorize SARIF uploads** - Separate results by scanner type
6. **Document your decisions** - Help future maintainers understand why

---

## ✅ Success Criteria

Your SARIF uploads are working correctly when:

- ✅ No permission errors in workflow logs
- ✅ No "file not found" errors
- ✅ No deprecation warnings for CodeQL action
- ✅ Security tab shows scan results
- ✅ Workflow completes successfully even if SARIF upload fails
- ✅ Each scanner's results visible in separate categories
