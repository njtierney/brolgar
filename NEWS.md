# brolgar 0.1.1 "Formerly known as the 'native companion'"

## Bug fixes

* Address bug with not creating equal strata
* Address warnings when using b_diff_summary, which now returns NA if there is 
only one observation, as we can't take the difference of one observation, and 
a difference of 0 in these cases would be misleading.

# brolgar 0.1.0 "Antigone rubicunda"

* fix warning bug in `keys_near` related to factors
* Add `feat_diff_summary()` functions to help summarise diff(). Useful for exploring the time gaps in the `index`. (#100)
* sample functions now work with multiple keys (#85, #89) (Thanks to @earowang and @deanmarchiori for their help with this.)
* `facet_sample()` now has a default of 3 per plot
* resolve features(data ,.key, n_obs) error (#71) 
* For `near_quantile()`, the `tol` argument now defaults to 0.01.
* provide an S3 generic for `tbl_ts` objects for `keys_near()` - #76
* Add new dataset, `pisa` containing a short summary of the PISA dataset from
 https://github.com/ropenscilabs/learningtower for three (of 99) countries
* add helper functions `index_regular()` and `index_summary()` to help identify
index variables

# brolgar 0.0.4.9000

* remove `feasts` from dependencies as the functions required in `brolgar` are
  actually in `fabletools`.
* add `nearest_lgl` and `nearest_qt_lgl`
* Gave more verbose names to the `wages_ts` data.
* renamed `sample_n_obs()` to `sample_n_keys()` and `sample_frac_keys()`
* renamed `add_k_groups()` to `stratify_keys()`
* removed many of the `l_<summary>` functions in favour of the `features` approach.
* rename `l_summarise_fivenum` to `l_summarise`, and have an option to pass a list of functions.
* rename `l_n_obs()` to `n_key_obs()`
* rename `l_slope()` to `key_slope()`
* added `monotonic` summaries and `feat_monotonic`
* rename `l_summarise()` to `keys_near()`
* make monotonic functions return FALSE if length == 1. 
* add `monotonic` function, which returns TRUE if increasing or decreasing, and false otherwise.
* re export `as_tsibble()` and `n_keys()` from `tsibble
* Data `world_heights` gains a continent column
* Implement `facet_strata()` to create a random group of size `n_strata` to put the data into (#32). Add support for `along`, and `fun`.
* Implement `facet_sample()` to create facetted plots with a set number of keys inside each facet. (#32). 
* `add_` functions now return a `tsibble()` (#49).
* Fixed bug where `stratify_keys()` didn't assign an equal number of keys per strata (#55)
* Update `wages_ts` dataset to now just be `wages` data, and remove previous `tibble()` version of `wages` (#39).
* Add `top_n` argument to `keys_near` to provide control over the number of observations near a stat that are returned.
* change `world_heights` to `heights`.
* remove function `n_key_obs()` in favour of using `n_obs()` (#62)
* remove function `filter_n_obs()` in favour of cleaner workflow with `add_n_obs()` (#63)

# brolgar 0.0.1.9000

* Made brolgar integrate with `tsibble`.

# brolgar 0.0.0.9990

* Added the `world_heights` dataset, which contains average male height in 
  centimetres for many countries. #28
* created `near_` family of functions to find values near to a quantile or percentile. So far there are `near_quantile()`, `near_middle()`, and `near_between()` (#11). 
    * `near_quantile()` Specify some quantile and then find those values around
      it (within some specified tolerance).
    * `near_middle()` Specify some middle percentile value and find values 
      within given percentiles.
    * `near_between()` Extract percentile values from a given percentile to 
      another percentile.
* Create `add_k_groups()` (#20) to randomly split the data into groups to 
  explore the data.
* Add `sample_n_obs()` and `sample_frac_obs()` (#19) to select a random group 
  of ids.
* Add `filter_n_obs()` to filter the data by the number of observations #15
* Remove unnecessary use of `var`, in `l_n_obs()`, since it only needs
  information on the `id`. Also gets a nice 5x speedup with simpler code
* calculate all longnostics (#4)
* use the word `longnostic` instead of `lognostic` (#9)
* `l_slope` now returns `l_intercept` and `l_slope` instead of `intercept` and
  `slope`.
* `l_slope` now takes bare variable names
* Renamed `l_d1` to `l_diff` and added a lag argument. This makes `l_diff` more
  flexible and the function more clearly describes its purpose.
* Rename `l_length` to `l_n_obs` to more clearly indicate that this counts the
  number of observations.
* Create `longnostic` function to create longnostic functions to package up 
 reproduced code inside the `l_` functions.
* Added a `NEWS.md` file to track changes to the package.
