# Day 7 — Azure DevOps CI Troubleshooting

**Project:** Azure ThreatShield  
**Date:** November 21, 2026  
**Components:** Azure DevOps, Python, Ruff, GitHub  
**Status:** Troubleshooting in progress

## Issue 1 — Ruff I001: Import Sorting

### Error

During the first Azure DevOps CI execution, Ruff reported:

```text
I001 [*] Import block is un-sorted or un-formatted
--> app/api/main.py:1:1
```

### Root Cause

Python import statements were not organized according to Ruff's configured import-sorting rules.

### Investigation

The issue was initially identified in the Azure DevOps pipeline logs.

Ruff was then installed locally to reproduce the issue.

### Resolution

Executed:

```bash
ruff check app --select I --fix
```

### Verification

```text
All checks passed!
```

The import-sorting check passed locally after the correction.

### Key Learning

CI quality gates help enforce consistent coding standards across environments.

Running the same tools locally makes it easier to reproduce and investigate pipeline failures.

---

## Issue 2 — Ruff BLE001: Broad Exception Handling

### Error

```text
BLE001 Do not catch blind exception: Exception
```

**Affected file:** `app/api/main.py`  
**Locations:** Lines 25 and 51  
**Findings:** 2

### Root Cause

The application contains broad exception handlers:

```python
except Exception:
    raise HTTPException(
        status_code=503,
        ...
    )
```

Catching every ordinary exception can hide unexpected application errors and complicate debugging.

### Proposed Remediation

- Identify the expected exceptions raised by the underlying functions.
- Catch specific exceptions where appropriate.
- Preserve useful diagnostic information in application logs.
- Avoid exposing sensitive internal details through API responses.

### Status

Pending code review and remediation.

---

## Issue 3 — Ruff TRY004: Exception Type

### Error

```text
TRY004 Prefer TypeError exception for invalid type
```

**Affected file:** `app/collector/threatfox.py`  
**Locations:** Lines 49 and 57  
**Findings:** 2

### Root Cause

The ThreatFox collector uses `RuntimeError` when validating response data types.

Example:

```python
if not isinstance(data, dict):
    raise RuntimeError("Unexpected ThreatFox response format")
```

### Proposed Remediation

Review whether `TypeError` is more appropriate for invalid response types.

Verify that changing exception types does not break existing error handling or tests.

### Status

Pending code review and remediation.

---

## Lessons Learned

1. A failed CI quality gate can indicate that automated validation is working correctly.
2. Import sorting is a code-quality requirement rather than a security vulnerability.
3. Exception handling should distinguish expected failures from unexpected programming errors.
4. Automated fixes should be reviewed before committing changes.
5. Local testing helps shorten the CI troubleshooting cycle.
