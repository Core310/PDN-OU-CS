# Feature Landscape

**Domain:** String Processing
**Researched:** 2024-10-24

## Table Stakes

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Comma Splitting | Primary format of input. | Low | Use `str.split(',')`. |
| Whitespace Trimming | Users often add spaces after commas. | Low | Use `str.strip()`. |
| Float/Int Support | Input can be decimal or whole numbers. | Low | `float()` handles both. |
| Error Reporting | Clear feedback on what went wrong. | Medium | Catch `ValueError` and provide context. |

## Differentiators

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Scientific Notation | Handles `1e3`, `2.5e-1`. | Low | Built-in to `float()`. |
| Empty Segment Handling | Gracefully skip or flag `1,,2`. | Low | Filter or conditional check. |
| Memory Efficiency | Use generators for large inputs. | Low | Avoid intermediate lists. |

## Anti-Features

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Custom Parser | Complex, bug-prone. | Use built-in `split` and `float`. |
| RegEx for Numbers | Hard to get right for all float forms. | Rely on `float()` conversion for validation. |

## Feature Dependencies

```
String Input → Split/Strip → Filter/Validate → Product Calculation
```

## MVP Recommendation

Prioritize:
1. Robust splitting and trimming.
2. Descriptive `ValueError` for non-numeric content.
3. Use of `math.prod` for the calculation.

Defer:
- Localized number formats (e.g., using commas for decimals).
- Financial precision (Decimal module).
