# Contributing

We welcome security-first improvements, tests and clearer documentation.

1. Fork or branch; never include private environment files, credentials, model weights or real system logs.
2. Prefer small, focused pull requests with reproduction steps and before/after test results.
3. New skills must use frontmatter with name and description and have a clear safety boundary and validation criteria.
4. Submit any external skill as a **review candidate**, not an automatically installed dependency.
5. Run: python tools/validate_skills.py skills && python tools/scan_secrets.py . && python -m unittest discover -s tests -v
6. Document what was actually run, which runtime/OS was tested, and where a command was not verified.
7. Respect original licensing and attribution; do not copy an external repository wholesale without checking its license.

No unsupported claims that a model is perfectly secure, uncensored, accurate, or compatible are allowed.
