"""Offline standard-library tests for manifest and credential checks."""
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from validate_skills import validate_skill, validate_skills  # noqa: E402
from scan_secrets import scan_path, scan_text  # noqa: E402


class ValidatorTests(unittest.TestCase):
    def test_valid_skill(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            skill = Path(tmp) / "sample-skill"
            skill.mkdir()
            (skill / "SKILL.md").write_text(
                "---\nname: sample-skill\ndescription: Helps with a well-defined support workflow.\n---\n"
                + ("Safe repeatable diagnostic instructions. " * 8),
                encoding="utf-8",
            )
            self.assertEqual(validate_skill(skill), [])
            self.assertEqual(validate_skills(Path(tmp)), [])

    def test_missing_manifest(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            folder = Path(tmp) / "missing"
            folder.mkdir()
            self.assertTrue(validate_skill(folder))

    def test_rejects_mismatch(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            folder = Path(tmp) / "expected"
            folder.mkdir()
            (folder / "SKILL.md").write_text(
                "---\nname: unexpected\ndescription: Documented workflow for testing only.\n---\n"
                + ("Procedure step. " * 30),
                encoding="utf-8",
            )
            self.assertTrue(any("mismatches" in p for p in validate_skill(folder)))

    def test_known_token_pattern(self) -> None:
        example = "x=" + "ghp_" + ("A" * 36)
        matches = scan_text(example, "synthetic.txt")
        self.assertEqual(len(matches), 1)
        self.assertNotIn("ghp_", matches[0])

    def test_secret_filename(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            (Path(tmp) / ".env").write_text("NOT_A_SECRET=1\n", encoding="utf-8")
            self.assertTrue(any("risky filename" in x for x in scan_path(Path(tmp))))

    def test_env_example_allowed(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            (Path(tmp) / ".env.example").write_text("GEMINI_API_KEY=\n", encoding="utf-8")
            self.assertEqual(scan_path(Path(tmp)), [])


if __name__ == "__main__":
    unittest.main()
