#!/usr/bin/env python3
import pathlib
import re

root = pathlib.Path(__file__).resolve().parent
expected = {
    "Dockerfile",
    "README.md",
    "requirements.lock",
    "verify_publication.py",
    ".github/workflows/publish.yml",
}
actual = {
    str(path.relative_to(root))
    for path in root.rglob("*")
    if path.is_file() and ".git" not in path.parts
}
if actual != expected:
    raise SystemExit(f"PUBLICATION_ALLOWLIST_DRIFT:{sorted(actual ^ expected)}")
text = "\n".join((root / name).read_text(errors="replace") for name in expected)
for pattern in (
    r"-----BEGIN [A-Z ]*PRIVATE KEY-----",
    r"(?i)(?:runpod|github|hf)[_-]?(?:token|api[_-]?key)\s*=",
    r"(?i)authorization\s*:\s*bearer",
):
    if re.search(pattern, text):
        raise SystemExit("FORBIDDEN_PUBLICATION_MATERIAL")
if "@sha256:856891fd5e66237a5107ddc06fd6a3f212ed4a93b735263986aa25fbced02900" not in text:
    raise SystemExit("PINNED_BASE_DIGEST_MISSING")
requirements = set((root / "requirements.lock").read_text().splitlines())
for runtime_pin in (
    "torch==2.13.0",
    "transformers==5.17.0",
    "vllm==0.31.0",
):
    if runtime_pin not in requirements:
        raise SystemExit(f"CANONICAL_RUNTIME_PIN_MISSING:{runtime_pin}")
print("PUBLICATION_PRIVACY_SCAN_PASS")
