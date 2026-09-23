# Data

This folder contains the simulated analyst-facing datasets used in the Virtual Fencing Behaviour Investigation.

> **Data disclosure:** All data in this folder are simulated for this independent portfolio project. They do not contain or attempt to reproduce proprietary Halter data.

## Dataset overview

The simulated dataset represents:

- 72 cattle
- 6 groups of 12 animals
- 7 training days
- 504 possible animal-days
- 678 observed event records

Three datasets are provided.

### `animals.csv`

Animal-level reference table containing the animals and their assigned groups.

Key fields:

- `animal_id` - unique animal identifier
- `group_id` - group assignment

### `vf_events.csv`

Event-level dataset containing observed virtual-fencing interactions.

Key fields include:

- `animal_event_id` - unique event identifier
- `group_event_id` - group-event identifier
- `animal_id` and `group_id` - animal and group identifiers
- `date` and `training_day` - timing within the training period
- `event_time` - event timestamp
- `event_type` - Direct or Social interaction
- `audio_cue` - whether an audio cue was recorded
- `pulse_delivered` - whether a pulse followed
- `audio_only` - audio cue without a subsequent pulse
- `previous_direct_exposures` - prior direct exposure count
- `initiator_id` - initiating animal where relevant
- `data_complete` - record completeness indicator

### `daily_summary.csv`

Animal-by-day summary table derived from the event data.

Key fields include:

- `animal_id` and `group_id`
- `date` and `training_day`
- `data_complete`
- `total_interactions`
- `direct_interactions`
- `audio_events`
- `pulse_events`
- `audio_only_events`
- `audio_only_proportion`
- `pulse_audio_ratio`
- `social_responses`
- `missing_records`

## Data relationships

`animal_id` is the primary field used to relate the three analyst-facing datasets.

The event-level data support detailed investigation of individual interactions, while the daily summary provides aggregated animal-day metrics for learning progression and response analysis.

## Data completeness

The dataset contains 26 incomplete animal-days out of 504 possible animal-days, representing 5.16%.

Incomplete records are retained explicitly so that missing information can be distinguished from animal response.

## Analysis use

The reproducible analysis in [`../analysis/`](../analysis/) uses these analyst-facing datasets to assess:

- herd-level learning progression
- individual exposure and response variation
- data completeness
- animals whose response patterns may warrant further investigation

Simulation parameters used to construct the dataset are intentionally excluded from the analyst-facing data and are not used to determine the reported investigation categories.
