## 📌 Summary

Brief description of the issue and what this MR resolves.

> Example:
> Fixes a bug where users were unable to save their profile due to a missing field validation.

---

## ✅ Changes

Explain for the reviewer how the change addresses the issue:

- Fixed null check on user input
- Added unit test for edge case
- Updated error handling in the `ProfileService`

---

## 🧪 Analysis

Explain the **underlying cause** of the bug:

- What was the unexpected behavior?
- Why did it happen?
- Where in the code or logic did it occur?

---

## 📚 Related Issue(s)

- Should be listed as part of the commit message.
- Fixes #[issue-number]
- Related to #[optional additional issues]

## 🧪 How to Reproduce & Test

Link to issue or document the required details below.

### Before the Fix:

1. Go to `/profile/edit`
2. Leave the "email" field empty
3. Click "Save"
4. Observe 500 server error

### After the Fix:

1. Same steps as above
2. Now see appropriate validation message
3. No server error occurs

---

## Checklist / Sign-offs

### 💿 CI/CD

- [ ] CI pipeline passes for all jobs
- [ ] Linting and formatting checks pass
- [ ] Review app (if used) reflects fix correctly

### 🖥 QA & Product

Set related labels on the MR for

- [ ] `PO::👀`
- [ ] `Tech Lead::👀`
- [ ] `Testautomation::👀`
- [ ] `QA::👀`

---

## 👷 Developer Checklist

- [ ] Code builds and passes linting
- [ ] Tests added or updated
- [ ] Verified fix locally
- [ ] Regression testing done for related functionality
- [ ] No new warnings or errors in logs

