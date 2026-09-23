# Analysis

This folder contains the reproducible analysis for the virtual fencing behaviour investigation. It uses only the three simulated analyst-facing datasets stored in `../data/`.

## Run the analysis

From the repository root, run:

```bash
Rscript analysis/virtual_fencing_analysis.R
```

The script uses base R only, so no additional R packages are required. It validates the input structure and key event rules before calculating results.

## What the script produces

The analysis addresses four questions:

1. **Herd learning progression:** calculates complete direct cues, audio-only responses, pulse events and response proportions by training day.
2. **Individual variation:** summarises complete direct exposure and response patterns for each animal, including early and late training windows.
3. **Investigation triage:** applies transparent analyst-defined rules to identify animals for review while separating low-exposure animals from stronger signals.
4. **Interpretation boundary:** documents what event data can describe and what additional animal, system and management context would be required to investigate why an animal differs.

The generated files in `outputs/` are:

- `daily_learning_summary.csv`
- `animal_response_summary.csv`
- `investigation_flags.csv`

## Reconciliation checks

Using the repository data, the script should reproduce:

- 72 animals
- 678 observed event rows
- 285 complete direct cue events
- 199 audio-only responses
- 86 pulse events
- 69.8% overall audio-only response
- 30.2% overall pulse requirement
- 26 of 504 incomplete animal-days (5.16%)

The daily audio-only response is 33.3%, 64.6%, 60.0%, 89.5%, 76.0%, 83.6% and 83.0% across training days 1 to 7.

## Investigation rule

The investigation categories are operational portfolio rules, not biological or welfare thresholds:

- **Limited evidence:** fewer than 3 complete direct cues
- **Monitor:** exactly 3 complete direct cues and audio-only response at or below one-third
- **Priority review:** at least 4 complete direct cues and audio-only response at or below 50%
- **No flag:** all other cases

This produces 3 Priority review animals, 5 Monitor animals, 34 Limited evidence animals and 30 No flag animals.

The rules are intentionally framed as triage. Event data can identify response patterns that warrant investigation, but cannot diagnose why an animal responded differently.
