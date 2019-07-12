.onLoad <- function(...) {
  fablelite::register_feature(feat_three_num, c("summary"))
  fablelite::register_feature(feat_five_num, c("summary"))
  fablelite::register_feature(feat_ranges, c("summary", "range", "spread"))
  fablelite::register_feature(feat_spread, c("summary", "spread"))
  fablelite::register_feature(feat_brolgar, c("summary", "all"))
  fablelite::register_feature(feat_monotonic, c("summary", "monotonic"))
  invisible()
}