# locator — DMX Topic Locator Agent

**Goal:** Given one or more topic *labels* (or IDs), return **precise, copy-pastable
location tuples** for each topic inside a **specific DMX topic map**:
`{topicmap_id, topic_id, x, y, label}` — plus optional context like
`topicmap_name`, `type_uri`, and adjacency.

This agent exists so downstream tools (falsifier, docs-steward, runners) can
reference the **exact on-canvas position** of topics without opening the DMX UI.

---

## What counts as a “location”?

A **location** is the tuple:


## Installation

```st
Metacello new
	repository: '';
	baseline: 'Locator';
	load
```

## Load Lepiter

After installing with Metacello, you will be able to execute

```
#BaselineOfLocator asClass loadLepiter
```
