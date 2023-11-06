test_that("Pivoting works", {
  df <- tibble::tribble(
    ~day, ~condition, ~dead, ~censored,
    10,   "WT",       2,    1,
    10,   "Drug1",    1,    2,
    10,   "Drug2",    1,    0,
    10,   "Drug2",    2,    0,
    12,   "WT",       1,    0
  )

  df_prism <- tibble::tribble(
    ~day, ~Drug1, ~Drug2, ~WT,
    "10",   1,      1,     1,
    "10",   0,      1,     1,
    "10",   0,      1,     0,
    "12",  NA,     NA,     1
  )

  expect_equal(pivot_prism(df), df_prism)
})
