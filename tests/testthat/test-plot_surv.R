test_that("plot fails with non-survfit objects", {
  expect_error(plot_surv(fit = "1", data = 2))
})

test_that("error if type is not survival or mortality", {
  # Create a simple survival table
  dat <- dplyr::tribble(
    ~condition, ~day, ~ status,
    "WT", 10, 1,
    "WT", 20, 1,
    "Mut", 2, 1,
    "Mut", 3, 1
  )

  # Fit survival object
  surv_fit <- survival::survfit(Surv(day, status) ~ condition,
                                data = dat)

  # Plot
  expect_error(plot_surv(fit = surv_fit, type = "cumhaz", data = dat))
})

test_that("survfit object passes", {
  # Create a simple survival table
  dat <- dplyr::tribble(
    ~condition, ~day, ~ status,
    "WT", 10, 1,
    "WT", 20, 1,
    "Mut", 2, 1,
    "Mut", 3, 1
  )

  # Fit survival object
  surv_fit <- survival::survfit(Surv(day, status) ~ condition,
                           data = dat)

  # Plot
  expect_no_error(plot_surv(fit = surv_fit, type = "survival", data = dat))
})
