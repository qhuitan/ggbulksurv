test_that("error if input is not a data.frame", {
  expect_error(get_indiv_surv("1"))
})


test_that("error if columns are missing", {
  foo <- data.frame(1, 2)
  colnames(foo) <- c("condition", "day")

  expect_error(get_indiv_surv(foo))
})


test_that("cleaning names works", {
  # A data.frame with poorly formatted colnames
  foo <- data.frame("WT", 1, 10, 0)
  colnames(foo) <- c("Condition ", "day", "dead   ", "censored")

  expect_no_error(get_indiv_surv(foo, sample_order = c("WT")))
})

test_that("extra columns are not deleted", {
  # original data
  df <- tidyr::tribble(
    ~condition, ~day, ~dead, ~censored, ~strain,
    "WT", 1, 2, 0, "N2",
    "Drug1", 10, 1, 1, "daf-2"
  )

  # expected result
  df_combined <- tidyr::tribble(
    ~condition, ~day, ~strain, ~status,
    "WT", 1, "N2", 1,
    "WT", 1, "N2", 1,
    "Drug1", 10, "daf-2", 0,
    "Drug1", 10, "daf-2", 1
  )

  df_combined$condition = factor(df_combined$condition,
                                 levels = c("WT", "Drug1"))

  expect_equal(get_indiv_surv(df), df_combined)
})

test_that("error when sample_order not in condition ", {

  expect_error(get_indiv_surv(sample_data,
                              sample_order = c("WT, F", "WT, M")))

})








