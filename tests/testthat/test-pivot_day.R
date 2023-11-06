test_that("Pivoting works", {
  df <- tibble::tribble(
    ~day, ~condition, ~dead, ~censored,
    10,   "Drug1",    2,    2,
    10,   "Drug2",    1,    0,
    10,   "WT",       2,    1,
  )

  df_prism <- tibble::tribble(
    ~Drug1, ~Drug2, ~WT,
    1,      1,      1,
    1,      NA,     1,
    0,      NA,     0,
    0,      NA,     NA
  )
  expect_equal(pivot_day(df), df_prism)
})
