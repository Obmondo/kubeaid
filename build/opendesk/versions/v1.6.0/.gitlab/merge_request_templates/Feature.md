## 📌 Summary

Briefly describe what this feature MR does and why it’s needed.

> Example:
> Adds user profile editing capabilities to the dashboard. This enables users to update their personal information without admin intervention.*

---

## ✅ Changes

List the key changes made in this MR:

- Added new route /profile/edit
- Created `ProfileEditForm` component
- Integrated with backend API for user updates
- Added unit tests and basic form validation

---

## 🧪 Tests

Provide steps for QA or reviewers to test the feature.

1. Login as any user
2. Navigate to `/profile/edit`
3. Update profile info and save
4. Verify changes are persisted and reflected in the UI

---

## 📚 Related Issue(s)

- Closes #[issue number]
- Depends on #[merge request or issue, if any]

---

## 🕵️ Notes for Reviewer

Mention anything reviewers should be aware of:

- Known issues or limitations
- Code sections that may need special attention
- Design considerations or edge cases handled

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
