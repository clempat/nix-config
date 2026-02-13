import json
import sys


def fmt_num(x):
    try:
        if isinstance(x, str):
            x = float(x)
        x = float(x)
        if abs(x - int(x)) < 1e-9:
            return str(int(x))
        return f"{x:.1f}"
    except Exception:
        return None


def walk(obj):
    if isinstance(obj, dict):
        yield obj
        for v in obj.values():
            yield from walk(v)
    elif isinstance(obj, list):
        for v in obj:
            yield from walk(v)


input_json = """
[{"source":"openai-web","provider":"codex","usage":{"updatedAt":"2026-01-21T09:55:36Z","loginMethod":"Plus","secondary":{"resetDescription":"Resets 11:51 PM","usedPercent":100,"windowMinutes":10080},"accountEmail":"ai.unread@patmail.app","primary":{"usedPercent":0,"windowMinutes":300},"identity":{"loginMethod":"Plus","accountEmail":"ai.unread@patmail.app","providerID":"codex"}},"openaiDashboard":{"updatedAt":"2026-01-21T09:55:36Z","creditEvents":[],"dailyBreakdown":[],"accountPlan":"Plus","codeReviewRemainingPercent":100,"secondaryLimit":{"usedPercent":100,"windowMinutes":10080,"resetDescription":"Resets 11:51 PM"},"signedInEmail":"ai.unread@patmail.app","usageBreakdown":[],"creditsRemaining":0,"primaryLimit":{"usedPercent":0,"windowMinutes":300}},"credits":{"updatedAt":"2026-01-21T09:55:36Z","events":[],"remaining":0}}]
"""

try:
    data = json.loads(input_json)
except Exception as e:
    print(f"JSON load failed: {e}")
    sys.exit(1)

best = None

for d in walk(data):
    keys = {k.lower(): k for k in d.keys()}
    for k in ("percent", "percentage", "pct", "usedpercent"):
        if k in keys:
            print(f"Found key: {k} -> {keys[k]} = {d[keys[k]]}")
            v = fmt_num(d[keys[k]])
            if v is not None:
                best = f"{v}%"
                break
    if best is not None:
        break

print(f"Result: {best}")
