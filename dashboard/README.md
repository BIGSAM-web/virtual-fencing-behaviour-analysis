# Power BI Dashboard

This folder contains the Power BI dashboard output developed for the **Virtual Fencing Behaviour Investigation**.

> **Portfolio disclosure:** This dashboard was developed using simulated data and publicly available virtual-fencing concepts. It does not use or attempt to reproduce proprietary Halter data, algorithms or decision rules.

## Dashboard

![Virtual Fencing Behaviour Investigation dashboard](virtual_fencing_dashboard.png)

The dashboard was designed to support both herd-level monitoring and investigation of individual animal response patterns.

## Dashboard components

### Herd-level KPIs

The dashboard reports:

- complete direct cues
- audio-only events
- pulse events
- audio-only response percentage
- pulse requirement percentage
- incomplete animal-days

These provide a concise view of response behaviour and data completeness.

### Training progression

The **Training Progression: Audio-Only Response** chart shows herd-level audio-only response across the seven-day training period.

The herd-level progression remains visible when an individual animal is selected, allowing the overall pattern to act as a consistent benchmark.

### Individual animal investigation

The **Select Animal** control allows individual animals to be investigated.

For the selected animal, the dashboard displays:

- complete direct cue exposure
- audio-only responses
- pulse events
- audio-only response percentage
- pulse requirement percentage
- event history by training day, date and time

The **Selected Animal vs Herd** visual compares the selected animal's audio-only response with the overall herd response.

### Data completeness

Incomplete animal-days are monitored separately from response behaviour.

This prevents missing information from being interpreted as either a successful or unsuccessful animal response.

## Example shown

The dashboard image shows animal **C066** selected.

C066 recorded:

- **4 complete direct cues**
- **0 audio-only responses**
- **4 pulse events**
- **0.0% audio-only response**
- **100.0% pulse requirement**

The four complete direct interactions occurred on training Days **1, 2 and 7**.

The herd-level audio-only response across the full training period was **69.8%**.

Under the analyst-defined triage rules used in this portfolio project, C066 is classified for **Priority review**. This classification identifies a response pattern worth investigating. It does not diagnose the reason for that pattern.

## Investigation context

Event data can identify exposure, cue-response patterns, timing and animals that may warrant further review. It cannot independently determine why an animal responds differently.

Further investigation could therefore consider:

- animal health and welfare
- collar or system status
- connectivity or diagnostics
- paddock and boundary conditions
- feed availability and motivation
- management activity
- relevant environmental or social context

## Design principle

The dashboard is designed around a simple decision-support principle:

**Use event data to prioritise investigation, not to make a diagnosis from a single metric.**

Animal-level response is therefore considered alongside exposure, data completeness and the wider investigation context.

## Related project files

- [`../data/`](../data/) contains the analyst-facing simulated datasets
- [`../analysis/`](../analysis/) contains the reproducible R analysis and derived outputs
- [`../docs/README.md`](../docs/README.md) documents the methodology, assumptions, evidence base and limitations
- [`../README.md`](../README.md) provides the full project overview
