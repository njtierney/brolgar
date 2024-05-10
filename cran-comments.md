## Test environments

* local OS X install, R 4.4.0
* github actions testing for devel, release, and ubuntu, windows, and macOSX
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 notes

```
* New submission
* Package was archived on CRAN
```

We have addressed the problems resulting in archival in this release

```
Possibly misspelled words in DESCRIPTION:
  Prvan (35:22)
  Tierney (34:66)
  brolgar (33:33)
  quantiles (30:42)
```

These spellings are all correct

```
Found the following (possibly) invalid URLs:
  URL: https://www.oecd.org/pisa/data/
    From: man/pisa.Rd
    Status: 403
    Message: Forbidden
```

I'm really not sure how to check this one - I've used {urlchecker} and the website opens for me, should I just remove this?

## revdepcheck results

There are no reverse dependencies as this package is not on CRAN