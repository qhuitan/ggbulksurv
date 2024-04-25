test_that("default call works", {

  expect_no_error(
    p <- run_bulksurv(sample_data)
  )

})


test_that("complex formula works", {
  expect_no_error(
    p <- run_bulksurv(sample_data,
                     formula = "Surv(day, status) ~ condition + sex")
  )
})

test_that("Complex condition, split color and linetype works", {
  expect_no_error(
    p <- run_bulksurv(sample_data,
                      formula = "Surv(day, status) ~ condition + sex",
                      color = "condition",
                      linetype = "sex")
  )
})

test_that("subsetting works in complex conditions", {
  expect_no_error(
    p <- run_bulksurv(subset(sample_data, condition %in% c("WT", "Drug1")),
                      formula = "Surv(day, status) ~ condition + sex")
  )
})

test_that("subsetting and reordering works in complex conditions", {
  # this fails.
  # need to manually reorder the data
  # also need this to throw an error.
  expect_no_error(
    p <- run_bulksurv(subset(sample_data, condition %in% c("WT", "Drug1")),
                      formula = "Surv(day, status) ~ condition + sex",
                      legend.labs = c("WT, M",
                                      "WT, F",
                                      "Drug1, F",
                                      "Drug1, M"))
  )
})
