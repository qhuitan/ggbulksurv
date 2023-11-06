test_that("summation works", {

  df <- tibble::tribble(
    ~day, ~condition, ~dead, ~censored,
    10,   "Drug1",    5,    4,
    10,   "Drug2",    1,    0,
    10,   "Drug2",    2,    0,
    10,   "WT",       2,    3,
  )

  df_collapsed <- tibble::tribble(
    ~day, ~condition, ~dead, ~censored,
    10,   "Drug1",    5,    4,
    10,   "Drug2",    3,    0,
    10,   "WT",       2,    3
  )
  expect_equal(sum_vials(df), df_collapsed)
})

test_that("summation works with multiple days", {

  df <- tibble::tribble(
    ~day, ~condition, ~dead, ~censored,
    10,   "Drug1",    5,    4,
    10,   "Drug2",    1,    0,
    10,   "Drug2",    2,    0,
    10,   "WT",       2,    3,
    12, "Drug1",      1,    2,
    12, "Drug1",      4,    1
  )

  df_collapsed <- tibble::tribble(
    ~day, ~condition, ~dead, ~censored,
    10,   "Drug1",    5,    4,
    10,   "Drug2",    3,    0,
    10,   "WT",       2,    3,
    12,   "Drug1",    5,    3
  )
  expect_equal(sum_vials(df), df_collapsed)
})

