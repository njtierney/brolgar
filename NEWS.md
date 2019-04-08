# brolgar 0.0.0.9400

* calculate all longnostics (#4)
* use the word `longnostic` instead of `lognostic` (#9)
* `l_slope` now returns `l_intercept` and `l_slope` instead of `intercept` and `slope`.
* `l_slope` now takes bare variable names
* Renamed `l_d1` to `l_diff` and added a lag argument. This makes `l_diff` more flexible and the function more clearly describes its purpose.
* Rename `l_length` to `l_n_obs` to more clearly indicate that this counts the number of observations.
* Create `longnostic` function to create longnostic functions to package up 
 reproduced code inside the `l_` functions.
* Added a `NEWS.md` file to track changes to the package.
