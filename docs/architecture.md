# Architectural Decision Record: MVP Foundation

## Product boundaries
**Collections runtime** is responsible for controlled conversation, domain reasoning, and tool requests. **Policy service** is responsible for authorization and validating structured actions. **Action service** is responsible for transactional persistence and idempotency. **Verification service** confirms committed state. **Independent QA service** checks transcript and action evidence against authoritative records.

## Security invariants
- Tools derive tenant identity from validated credentials, never model-provided identifiers.
- Never give browser clients service-role credentials.
- All monetary values are integer minor units, never floating point.
- Every consequential action uses an idempotency key and audit event.
- An uncertain backend outcome is never communicated as confirmed.
- Voice responses disclose debt information only after identity verification.
- No direct LLM database writes.
- No PSTN calls or real payment movement in the demo.

## Next milestone
Add Supabase Auth, tenant-scoped RLS SELECT policies, a synthetic seed loader and read-only account endpoints; then React portal and browser Voice Lab.
