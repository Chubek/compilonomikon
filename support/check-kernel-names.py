"""Check canonical kernel names, filenames, and references in chapter sources."""

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parent.parent
CHAPTERS = ROOT / "chapters"
DECLARATION = re.compile(r"\\begin\{kernel\}\{([^}]+)\}")
REFERENCE = re.compile(r"\\kernelref\{([^}]+)\}")
VALID_NAME = re.compile(r"[a-z][a-z0-9]*(?:-[a-z0-9]+)*\Z")


def main() -> int:
    errors = []
    names = set()
    sources = list(CHAPTERS.rglob("*.ltx"))
    for path in sources:
        content = path.read_text(encoding="utf-8")
        for name in DECLARATION.findall(content):
            if not VALID_NAME.fullmatch(name):
                errors.append(f"{path}: invalid kernel name {name!r}")
            if path.name != f"kernel-{name}.ltx":
                errors.append(f"{path}: name {name!r} does not match filename")
            if name in names:
                errors.append(f"{path}: duplicate kernel name {name!r}")
            names.add(name)
        if path.name.startswith("kernel-") and len(DECLARATION.findall(content)) != 1:
            errors.append(f"{path}: expected exactly one kernel declaration")
    for path in [ROOT / "main.ltx", ROOT / "preamble.ltx", *sources]:
        for name in REFERENCE.findall(path.read_text(encoding="utf-8")):
            if name not in names:
                errors.append(f"{path}: unknown kernel reference {name!r}")
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print(f"Kernel names: {len(names)} declarations checked")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
