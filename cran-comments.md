## Test environments
* local R installation, R 4.0.5 (MacOS)
* GitHub Actions, R 4.1.0
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

I was away on leave this year, and during this time my package was archived. I no longer have the errors failing on "test-keys-near.R", although I'm not sure if ATLAS is a special system or option/flag I need to trigger.

There were also some spelling mistakes flagged for the words, "Prvan", 
"Tierney", and "brolgar". The first two words are the last names of co-authors
of the package, whose names are mentioned in the prescribed format for referring
to existing authored work. The last work, "brolgar", is the name of the R 
package, which appears in the title of the authored work.
