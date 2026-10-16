# Security and compliance guardrails

This is a synthetic-data prototype, not a production collections system.
- No real borrower data, dialing or payments.
- RLS enabled by default; policies are intentionally absent until auth checks are tested.
- Fail closed for missing policy, identity verification, contact permission or uncertain write outcome.
- Record structured consent and recording notices before retaining audio.
- Mask sensitive values and ensure secrets never appear in logs, source control, or prompts.
- Validate compliance policies and calling limits for each specific lender and jurisdiction before external use.
