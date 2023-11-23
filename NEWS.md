# ggbulksurv 0.2.1

## Bug fixes
* Fixed bug in `run_bulksurv()` - `returnData` now returns data as a list

## Enhancements
* `returnData = TRUE` in `run_bulksurv()` returns pivoted data as a list item

# ggbulksurv 0.2.0

## Bug fixes
* Fixed bug in `pivot_prism()` that erroneously expanded the first column

## Enhancements
* `run_bulksurv()` now supports subsetting via the `sample_order` parameter. `run_bulksurv(df)` now runs a default analysis for all conditions.
* Survival plots now start at (0,0)

## What's new
* Added a "Getting started with R" vignette for beginner R users

# ggbulksurv 0.1.0

## Enhancements

* `run_bulksurv()` has a `print_plot` parameter that allows plots to be turned off. 
* `p_adjust_method` can now be customized in `run_bulksurv()` and `summary_stats()`.

## New features
s
* Deployed website on GitHub pages. 
* New `pivot_prism()` function to transform bulk survival data into GraphPad PRISM compatible format
* Split README file into three vignette articles for easier navigation. 

# ggbulksurv 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
