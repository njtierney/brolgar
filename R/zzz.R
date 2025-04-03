.onLoad <- function(...) {
  fabletools::register_feature(feat_three_num, c("summary"))
  fabletools::register_feature(feat_five_num, c("summary"))
  fabletools::register_feature(feat_ranges, c("summary", "range", "spread"))
  fabletools::register_feature(feat_spread, c("summary", "spread"))
  fabletools::register_feature(feat_brolgar, c("summary", "all"))
  fabletools::register_feature(feat_monotonic, c("summary", "monotonic"))
  invisible()
}
