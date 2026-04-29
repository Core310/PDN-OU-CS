# Architecture Patterns

**Domain:** Utility Function
**Researched:** 2024-10-24

## Recommended Architecture

The system follows a functional pipeline: **Split -> Sanitize -> Validate -> Reduce**.

### Component Boundaries

| Component | Responsibility | Communicates With |
|-----------|---------------|-------------------|
| Input Handler | Takes the raw string. | Sanitizer |
| Sanitizer | Splits by delimiter and strips whitespace. | Validator |
| Validator | Checks if tokens are numeric. | Reducer |
| Reducer | Calculates the product. | Caller |

### Data Flow

1. **Raw String** ` " 1, 2.5 , 3 " `
2. **Split/Strip** `["1", "2.5", "3"]`
3. **Conversion** `[1.0, 2.5, 3.0]`
4. **Reduction** `7.5`

## Patterns to Follow

### Pattern 1: Fail-Fast Validation
Raise exceptions immediately when an invalid token is encountered to prevent partial or incorrect calculations.

**Example:**
```python
import math

def calculate_product(input_str: str) -> float:
    # Use a generator for memory efficiency
    tokens = (t.strip() for t in input_str.split(',') if t.strip())
    
    try:
        numbers = [float(t) for t in tokens]
    except ValueError as e:
        raise ValueError(f"Invalid input: {e}") from None

    if not numbers:
         raise ValueError("No valid numbers found in input.")

    return math.prod(numbers)
```

## Anti-Patterns to Avoid

### Anti-Pattern 1: Silently Skipping Errors
**What:** Using `try-except` inside the loop to ignore non-numeric tokens.
**Why bad:** The user receives a product of only some numbers without knowing others were ignored, leading to data integrity issues.
**Instead:** Raise a descriptive exception.

## Scalability Considerations

| Concern | At 100 numbers | At 10K numbers | At 1M numbers |
|---------|--------------|--------------|-------------|
| Memory | Minimal | Negligible | Use generators to avoid large lists. |
| Overflow | Fine | Likely `inf` | Use `decimal.Decimal` if overflow is a concern. |

## Sources
- [Clean Code: Principles of Error Handling](https://en.wikipedia.org/wiki/Fail-fast)
