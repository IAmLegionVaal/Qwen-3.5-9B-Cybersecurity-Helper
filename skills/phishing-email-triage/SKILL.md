---
name: phishing-email-triage
description: Analyzes suspicious email metadata, URLs, attachments and identity signs for defensive response.
---

# Phishing email and BEC triage

## Procedure
1. Preserve the original MIME message with headers under an approved evidence process.
2. Parse sender display name versus envelope sender, Return-Path, Message-ID, Received chain, SPF/DKIM/DMARC outcomes and link rewriting.
3. Evaluate spoofing, lookalike domains, conversation hijacking and unusual sending infrastructure. A passed SPF alone does not prove legitimacy.
4. Extract URLs and attachment hashes without opening suspicious links or executing attachments.
5. Check mailbox rules, forwarding, OAuth grants, sign-ins and audit events where account compromise is suspected.
6. Correlate with other recipient reports and mail-security telemetry; determine scope and risk.
7. Recommend approved actions: quarantine, user notification, sender/domain protections, account containment and targeted credential rotation.
8. Report uncertainty and avoid pasting raw messages with personal data or sensitive links into public AI contexts.

## Output
Message metadata, authentication evidence, sender inconsistency, indicators, affected scope, confidence, response recommendation and retrospective searches.

## Guardrails
Do not click phishing links on production machines. Safe URL enrichment can be done with sandboxed or passive threat-intelligence services and proper data-sharing approval.
