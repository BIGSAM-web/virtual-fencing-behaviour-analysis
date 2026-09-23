# Methodology, Evidence and Limitations

## Project purpose

This project investigates whether virtual-fencing interaction data can be used to describe learning progression and identify animals whose response patterns may warrant further investigation.

The project uses simulated data and publicly available information about virtual-fencing concepts. It does not use or attempt to reproduce proprietary Halter data, algorithms or decision rules.

## Research questions

The analysis addresses four questions:

1. Does herd-level response to audio cues improve across the seven-day training period?
2. How much individual variation exists in cue-response patterns?
3. Can event data identify animals whose response patterns differ enough to warrant further investigation?
4. What can collar-event data explain, and when is additional animal, environmental or system information needed?

## Analytical approach

### RQ1: Herd learning progression

Learning progression was assessed using complete direct cue events.

The primary metric was:

**Audio-only response proportion = audio-only responses / complete direct cue events**

A rising audio-only response proportion indicates that a greater share of direct cue events were resolved following the audio cue without a pulse being delivered.

The analysis showed an increase from 33.3% on training day 1 to 83.0% on training day 7, with some day-to-day variation.

Across all complete direct cue events:

- 285 complete direct cue events were observed
- 199 were audio-only responses
- 86 involved a pulse
- overall audio-only response was 69.8%
- overall pulse requirement was 30.2%

A simple logistic regression was also used as a descriptive check of the relationship between training day and audio-only response. The estimated odds ratio was approximately 1.42 per training day (p < 0.001). Because the dataset is simulated, this is treated as a descriptive analytical result rather than a biological effect estimate.

### RQ2: Individual variation

Complete direct cue events were summarised by animal to examine differences in:

- exposure to direct cues
- audio-only responses
- pulse events
- overall audio-only response proportion
- early and later training response patterns
- data completeness

Exposure varied considerably between animals. This is important because a response percentage based on only a few observations should not be interpreted in the same way as a percentage based on greater exposure.

Individual response metrics are therefore interpreted alongside the number of complete direct cues.

### RQ3: Investigation triage

A statistical outlier approach was initially considered, but the individual exposure counts were too sparse to support confident classification of animals as statistical outliers.

Rather than forcing an outlier result, transparent operational triage rules were used:

| Category | Rule |
|---|---|
| Limited evidence | Fewer than 3 complete direct cues |
| Monitor | Exactly 3 complete direct cues and audio-only response at or below 33.3% |
| Priority review | At least 4 complete direct cues and audio-only response at or below 50% |
| No flag | All other cases |

These rules identified:

- 3 Priority review animals
- 5 Monitor animals
- 34 Limited evidence animals
- 30 No flag animals

These categories are analyst-defined portfolio rules. They are not biological, welfare or commercial thresholds and should not be interpreted as proprietary virtual-fencing decision rules.

Their purpose is to demonstrate how event data could support transparent investigation prioritisation while accounting for exposure.

### RQ4: Interpretation boundary

Event data can help identify:

- cue exposure
- cue-response patterns
- pulse occurrence
- timing and training day
- group information
- social-response records
- data completeness

However, event data alone cannot establish why an animal responded differently.

A real investigation would need additional context such as:

- animal health and welfare
- collar or system status
- connectivity or diagnostic information
- paddock and boundary conditions
- feed availability and motivation
- management activity
- potentially weather and social context

The analysis therefore treats unusual response patterns as signals for investigation rather than diagnoses.

## Data quality

The analyst-facing dataset contains:

- 72 animals
- 6 groups
- 504 possible animal-days
- 678 observed event records
- 26 incomplete animal-days, representing 5.16% of animal-days

Validation checks found:

- no duplicate event IDs
- no pulse events recorded without an audio cue
- no invalid cue records among social-response events

Missingness is retained as part of the analysis rather than silently treated as successful or unsuccessful response.

## Evidence base

The project design was informed by publicly available virtual-fencing literature and industry information.

The literature supports several broad concepts relevant to this project:

- virtual fencing commonly uses an audio cue followed by an electrical stimulus when required
- animals can learn the association between the audio cue and virtual boundary
- response patterns can change during training
- individual animals may differ in their responses
- social learning and group behaviour may influence responses
- welfare and behavioural interpretation requires more information than collar-event counts alone

Published research systems and commercial implementations are not assumed to be identical. Findings from one virtual-fencing system are therefore used to inform the analytical concept rather than being treated as direct evidence of another system's proprietary operation.

## Simulation assumptions

The dataset was created specifically for this portfolio project and is simulated.

The simulation represents:

- 72 lactating dairy cattle
- 6 groups of 12 animals
- a seven-day training period
- direct and social-response events
- audio cues
- pulse delivery
- animal-level variation
- changing response patterns across training
- incomplete records

Simulation assumptions were used to create a realistic analytical problem. They should not be interpreted as measured biological parameters or estimates of real-world system performance.

The analysis itself uses only the analyst-facing datasets in the `data/` directory. Hidden simulation parameters are not used to classify animals or calculate the reported analytical results.

## Limitations

This project has several important limitations.

First, the data are simulated and therefore cannot establish real-world biological, welfare or commercial outcomes.

Second, individual exposure is sparse for many animals. This limits confidence in animal-level comparisons and is why exposure is considered alongside response proportion.

Third, event records describe what occurred but cannot independently explain the cause of an animal's response.

Fourth, the project uses publicly available virtual-fencing concepts and does not reproduce proprietary algorithms, thresholds or operational processes.

Finally, the investigation categories are transparent analytical rules designed for this portfolio exercise. They demonstrate a possible triage workflow rather than validated intervention thresholds.

## Interpretation principle

The central analytical principle of this project is:

> Event data can identify patterns worth investigating, but additional animal, system and management context is required before deciding why those patterns occurred or what action should follow.
