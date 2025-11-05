
---

## SPEC.md

```markdown
# SPEC
name: locator
description: Resolve one or more topic labels/IDs to precise on-canvas locations within a specific DMX topic map, and return a normalized, copy-pastable result for humans and agents.

model: gpt-5-thinking
inputs:
  - topicmap (name or id)
  - topics (labels and/or topic_ids)
  - data source (DMX topicmap JSON; optional adapter for REST; or pasted subset)
tools:
  - JSON parser
  - optional: DMX REST adapter (if configured)
  - optional: Lepiter pages for examples & tests

# Responsibilities
- Accept **topicmap spec** (name/id) and **topics** (labels/ids).
- Read **coordinates** from supplied data (never invent x/y).
- Disambiguate by label similarity, type, or neighbors; report **ambiguity** explicitly.
- Return **normalized locations**:
  - `topicmap_id, topic_id, x, y, label`
  - optional: `topicmap_name, type_uri, neighbors[], zoom/scale`
- Provide both **machine JSON** and **human summary** outputs.
- Never mutate source data or write back to DMX.

# Triggers
- “locator: find …” or any request for **precise positions** of topics.
- Other agents needing stable anchors (e.g., falsifier referencing specific nodes).

# Process (internal)
1. **Resolve topicmap** (by id or by exact name).
2. **Index nodes** by `topic_id`, exact label, lowercase label, and n-gram tokens.
3. For each input topic:
   - If `topic_id` supplied: return exact node if present; else status=`not_found`.
   - Else attempt **exact label** match; if none, try **case-folded** and **fuzzy** (~0.85).
   - If multiple matches: mark status=`ambiguous` and include candidates with type hints.
4. Extract `x/y` (and other view props) from the node’s map placement.
5. Emit results; sort by input order.

# Output (contracts)

## JSON
```json
{
  "topicmap_id": 878581,
  "topicmap_name": "semantik",
  "results": [
    {
      "query": "Falsifying Khinsen's Synthesis",
      "status": "ok",
      "label": "Falsifying Khinsen's Synthesis",
      "topic_id": 123458,
      "x": 2310,
      "y": 940,
      "type_uri": "my.type/Falsification",
      "neighbors": [123457, 123459]
    },
    {
      "query": "Debating Top-Down vs. Bottom-Up Sensemaking Approaches",
      "status": "ambiguous",
      "candidates": [
        {"topic_id": 555001, "label": "Debating Top-Down … (note)", "type_uri": "dmx/text"},
        {"topic_id": 555117, "label": "Debating Top-Down … (index)", "type_uri": "dmx/index"}
      ]
    }
  ]
}
