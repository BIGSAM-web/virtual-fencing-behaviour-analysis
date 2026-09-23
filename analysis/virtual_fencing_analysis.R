# Virtual Fencing Behaviour Investigation
# Reproducible analysis using only analyst-facing simulated datasets.
# No proprietary system data or algorithms are used.
#
# Run from the repository root:
#   Rscript analysis/virtual_fencing_analysis.R
#
# Inputs:
#   data/animals.csv
#   data/vf_events.csv
#   data/daily_summary.csv
#
# Outputs:
#   analysis/outputs/daily_learning_summary.csv
#   analysis/outputs/animal_response_summary.csv
#   analysis/outputs/investigation_flags.csv

options(stringsAsFactors = FALSE)

# ---------- Paths ----------
data_dir <- "data"
output_dir <- file.path("analysis", "outputs")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

required_files <- file.path(data_dir, c("animals.csv", "vf_events.csv", "daily_summary.csv"))
missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) {
  stop(
    "Missing required input file(s): ",
    paste(missing_files, collapse = ", "),
    ". Run this script from the repository root."
  )
}

# ---------- Load data ----------
animals <- read.csv(file.path(data_dir, "animals.csv"), check.names = FALSE)
events <- read.csv(file.path(data_dir, "vf_events.csv"), check.names = FALSE, na.strings = c("", "NA"))
daily <- read.csv(file.path(data_dir, "daily_summary.csv"), check.names = FALSE, na.strings = c("", "NA"))

# ---------- Basic validation ----------
required_animal_cols <- c("animal_id", "group_id")
required_event_cols <- c(
  "animal_event_id", "group_event_id", "animal_id", "group_id", "date",
  "training_day", "event_time", "event_type", "audio_cue", "pulse_delivered",
  "audio_only", "previous_direct_exposures", "initiator_id", "data_complete"
)
required_daily_cols <- c(
  "animal_id", "group_id", "date", "training_day", "data_complete",
  "total_interactions", "direct_interactions", "audio_events", "pulse_events",
  "audio_only_events", "audio_only_proportion", "pulse_audio_ratio",
  "social_responses", "missing_records"
)

check_columns <- function(df, required, name) {
  missing <- setdiff(required, names(df))
  if (length(missing) > 0) {
    stop(name, " is missing required column(s): ", paste(missing, collapse = ", "))
  }
}

check_columns(animals, required_animal_cols, "animals.csv")
check_columns(events, required_event_cols, "vf_events.csv")
check_columns(daily, required_daily_cols, "daily_summary.csv")

if (anyDuplicated(animals$animal_id) > 0) stop("animals.csv contains duplicate animal_id values.")
if (anyDuplicated(events$animal_event_id) > 0) stop("vf_events.csv contains duplicate animal_event_id values.")
if (!all(events$animal_id %in% animals$animal_id)) stop("vf_events.csv contains animal IDs absent from animals.csv.")
if (!all(daily$animal_id %in% animals$animal_id)) stop("daily_summary.csv contains animal IDs absent from animals.csv.")
if (any(events$pulse_delivered == 1 & events$audio_cue != 1, na.rm = TRUE)) stop("Found pulse event without an audio cue.")
if (any(events$event_type == "Social" & (events$audio_cue != 0 | events$pulse_delivered != 0), na.rm = TRUE)) {
  stop("Found Social event with a direct audio/pulse response recorded.")
}

# Analysis denominator: complete Direct events with an audio cue.
complete_direct <- events[
  events$event_type == "Direct" &
    events$data_complete == 1 &
    events$audio_cue == 1 &
    !is.na(events$audio_only),
]

# ---------- RQ1: herd learning progression ----------
days <- sort(unique(events$training_day))
daily_learning <- do.call(rbind, lapply(days, function(day) {
  x <- complete_direct[complete_direct$training_day == day, ]
  cues <- nrow(x)
  audio_only <- sum(x$audio_only == 1, na.rm = TRUE)
  pulses <- sum(x$pulse_delivered == 1, na.rm = TRUE)
  data.frame(
    training_day = day,
    complete_direct_cues = cues,
    audio_only_events = audio_only,
    pulse_events = pulses,
    audio_only_proportion = if (cues > 0) audio_only / cues else NA_real_,
    pulse_audio_ratio = if (cues > 0) pulses / cues else NA_real_
  )
}))

write.csv(
  daily_learning,
  file.path(output_dir, "daily_learning_summary.csv"),
  row.names = FALSE,
  na = ""
)

# Descriptive logistic trend across training days.
# This is a trend estimate for the simulated event data, not a causal biological effect.
learning_model <- glm(audio_only ~ training_day, data = complete_direct, family = binomial())
training_day_or <- unname(exp(coef(learning_model)["training_day"]))
training_day_p <- unname(summary(learning_model)$coefficients["training_day", "Pr(>|z|)"])

# ---------- RQ2: individual response variation ----------
animal_response <- do.call(rbind, lapply(seq_len(nrow(animals)), function(i) {
  id <- animals$animal_id[i]
  group <- animals$group_id[i]
  x <- complete_direct[complete_direct$animal_id == id, ]
  n_cues <- nrow(x)
  n_audio_only <- sum(x$audio_only == 1, na.rm = TRUE)
  n_pulses <- sum(x$pulse_delivered == 1, na.rm = TRUE)

  early <- x[x$training_day %in% 1:2, ]
  late <- x[x$training_day %in% 6:7, ]

  incomplete_days <- sum(daily$animal_id == id & daily$data_complete == 0, na.rm = TRUE)

  data.frame(
    animal_id = id,
    group_id = group,
    complete_direct_cues = n_cues,
    audio_only_events = n_audio_only,
    pulse_events = n_pulses,
    audio_only_proportion = if (n_cues > 0) n_audio_only / n_cues else NA_real_,
    early_complete_direct_cues = nrow(early),
    early_audio_only_proportion = if (nrow(early) > 0) mean(early$audio_only) else NA_real_,
    late_complete_direct_cues = nrow(late),
    late_audio_only_proportion = if (nrow(late) > 0) mean(late$audio_only) else NA_real_,
    incomplete_animal_days = incomplete_days
  )
}))

write.csv(
  animal_response,
  file.path(output_dir, "animal_response_summary.csv"),
  row.names = FALSE,
  na = ""
)

# ---------- RQ3: operational investigation triage ----------
# These thresholds are analyst-defined portfolio rules for prioritising review.
# They are NOT biological cut-offs, welfare diagnoses, or source-derived thresholds.
triage <- animal_response
triage$investigation_flag <- ifelse(
  triage$complete_direct_cues < 3,
  "Limited evidence",
  ifelse(
    triage$complete_direct_cues == 3 & triage$audio_only_proportion <= (1 / 3),
    "Monitor",
    ifelse(
      triage$complete_direct_cues >= 4 & triage$audio_only_proportion <= 0.50,
      "Priority review",
      "No flag"
    )
  )
)

flag_order <- c("Priority review", "Monitor", "Limited evidence", "No flag")
triage$flag_order <- match(triage$investigation_flag, flag_order)
triage <- triage[order(triage$flag_order, triage$audio_only_proportion, -triage$complete_direct_cues, na.last = TRUE), ]
triage$flag_order <- NULL

write.csv(
  triage,
  file.path(output_dir, "investigation_flags.csv"),
  row.names = FALSE,
  na = ""
)

# ---------- RQ4: interpretation boundary ----------
# Event data can describe exposure, cue-response pattern, training-day timing,
# group/social records and data completeness. It cannot establish WHY an animal
# responds differently. Follow-up should consider animal health/welfare,
# collar/system status, paddock/boundary context, feed/motivation and management.

# ---------- Console summary ----------
total_cues <- nrow(complete_direct)
total_audio_only <- sum(complete_direct$audio_only == 1)
total_pulses <- sum(complete_direct$pulse_delivered == 1)
incomplete_animal_days <- sum(daily$data_complete == 0)
total_animal_days <- nrow(daily)

cat("Virtual Fencing Behaviour Investigation\n")
cat("---------------------------------------\n")
cat("Animals:", nrow(animals), "\n")
cat("Observed event rows:", nrow(events), "\n")
cat("Complete direct cues:", total_cues, "\n")
cat("Audio-only events:", total_audio_only, "\n")
cat("Pulse events:", total_pulses, "\n")
cat(sprintf("Overall audio-only response: %.1f%%\n", 100 * total_audio_only / total_cues))
cat(sprintf("Overall pulse requirement: %.1f%%\n", 100 * total_pulses / total_cues))
cat(sprintf("Incomplete animal-days: %d/%d (%.2f%%)\n", incomplete_animal_days, total_animal_days, 100 * incomplete_animal_days / total_animal_days))
cat(sprintf("Training-day odds ratio: %.4f (p = %.3g)\n", training_day_or, training_day_p))
cat("\nInvestigation flags:\n")
print(table(factor(triage$investigation_flag, levels = flag_order)))
cat("\nOutputs written to:", output_dir, "\n")
