# Domain Pitfalls

**Domain:** Numeric Parsing and Arithmetic
**Researched:** 2024-10-24

## Critical Pitfalls

### Pitfall 1: Floating Point Precision
**What goes wrong:** `0.1 * 0.2` results in `0.020000000000000004` instead of `0.02`.
**Why it happens:** Computers represent floats in base 2, which cannot perfectly represent some base 10 decimals.
**Prevention:** Use `round()` on the final result or use the `decimal` module for financial/high-precision calculations.

### Pitfall 2: Unexpected Infinity
**What goes wrong:** Product of many large numbers exceeding `1.8e308` (max float).
**Why it happens:** Float overflow.
**Consequences:** Result becomes `inf`, losing all precision.
**Prevention:** Check for large inputs or use `math.isinf()` on results.

## Moderate Pitfalls

### Pitfall 1: Empty Tokens in String
**What goes wrong:** ` "1, , 2" ` causing a `ValueError` or unexpected result.
**Prevention:** Decide whether to skip empty tokens (robustness) or raise an error (strictness). Filtering out empty strings is usually preferred for user input.

### Pitfall 2: Different Delimiters
**What goes wrong:** User uses semicolons or spaces instead of commas.
**Prevention:** Hard-code the delimiter or use a flexible parser if the environment is unknown.

## Minor Pitfalls

### Pitfall 1: Leading/Trailing Delimiters
**What goes wrong:** ` ",1,2," ` results in empty tokens at start/end.
**Prevention:** Use a list comprehension with a truthy check: `[t for t in s.split(',') if t.strip()]`.

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| Parsing | Non-numeric tokens | Catch `ValueError` and provide the offending token in the message. |
| Calculation | Empty lists | `math.prod([])` returns `1.0`. Ensure this is desired or raise an error. |

## Sources
- [Python Docs: Floating Point Arithmetic](https://docs.python.org/3/tutorial/floatingpoint.html)
