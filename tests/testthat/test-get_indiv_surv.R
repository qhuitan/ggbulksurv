test_that("error if input is not a data.frame", {
  expect_error(get_indiv_surv("1"))
})


test_that("error if columns are missing", {
  foo <- data.frame(1, 2)
  colnames(foo) <- c("condition", "day")

  expect_error(get_indiv_surv(foo))
})

# test_that("error if sample_order is not equal to all unique conditions", {
#   foo <- data.frame(condition = c("WT", "TRT"),
#                     day       = c(1, 1),
#                     dead      = c(2, 3),
#                     censored  = c(1, 0))
#
#   expect_error(get_indiv_surv(foo, sample_order = c("WT")))
# })


test_that("cleaning names works", {
  # A data.frame with poorly formatted colnames
  foo <- data.frame("WT", 1, 10, 0)
  colnames(foo) <- c("Condition ", "day", "dead   ", "censored")

  expect_no_error(get_indiv_surv(foo, sample_order = c("WT")))
})









