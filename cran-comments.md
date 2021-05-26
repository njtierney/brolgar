## Test environments
* local R installation, R 4.0.5 (MacOS)
* GitHub Actions: Windows, R 4.1.0
* GitHub Actions: MacOS, R 4.1.0
* GitHub Actions: Ubuntu-20.04, R 4.1.0
* GitHub Actions: Ubuntu-20.04, R (devel)
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 3 notes

* New submission
* Package was archived on CRAN
* Possibly mis-spelled words in DESCRIPTION:
  Prvan (35:22)
  Tierney (34:66)
  brolgar (33:33)

* CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2021-02-28 as check problems were not
    corrected in time.
  Problem first reported was with ATLAS, 2 FAIL in "test-keys-near.R".

I was away on leave this year, and during this time my package was archived. The issue with ATLAS was in tests on "test-keys-near.R". These functions were examined and a bug was sending off many many warnings due to taking min or max of `numeric(0)`. This has now been resolved/

There were also some spelling mistakes flagged for the words, "Prvan", 
"Tierney", and "brolgar". The first two words are the last names of co-authors
of the package, whose names are mentioned in the prescribed format for referring
to existing authored work. The last work, "brolgar", is the name of the R 
package, which appears in the title of the authored work.
