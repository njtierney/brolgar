# keys_near returns the same dimension and names etc

    Code
      summarise_ln_wages
    Output
      # A tibble: 71 x 5
            id ln_wages stat  stat_value stat_diff
         <int>    <dbl> <fct>      <dbl>     <dbl>
       1   223     2.14 q_75        2.14         0
       2   304     1.84 med         1.84         0
       3   470     1.84 med         1.84         0
       4   537     1.84 med         1.84         0
       5   630     1.84 med         1.84         0
       6   700     1.59 q_25        1.59         0
       7   735     4.30 max         4.30         0
       8   767     1.84 med         1.84         0
       9   871     1.84 med         1.84         0
      10  1150     1.84 med         1.84         0
      # i 61 more rows

---

    Code
      summarise_slope
    Output
      # A tibble: 5 x 5
           id .slope_xp stat  stat_value stat_diff
        <int>     <dbl> <fct>      <dbl>     <dbl>
      1  2594  -0.00768 q_25    -0.00769 0.0000127
      2  7918  -4.58    min     -4.58    0        
      3 10380   0.0479  med      0.0480  0.0000498
      4 12178   0.0946  q_75     0.0947  0.0000579
      5 12455  13.2     max     13.2     0        

