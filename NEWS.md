# brolgar 0.0.0.9100

* Renamed `l_d1` to `l_diff` and added a lag argument. This makes `l_diff` more flexible and the function more clearly describes its purpose.
* Rename `l_length` to `l_n_obs` to more clearly indicate that this counts the number of observations.
* Create `lognosticise` function to create lognostic functions to package up 
 reproduced code inside the `l_` functions.
* Added a `NEWS.md` file to track changes to the package.
