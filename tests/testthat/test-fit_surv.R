test_that("error if colnames are wrong", {
  # Try a bulk survival object input
  dat <- data.frame(condition = c("WT", "TRT"),
                    day       = c(1, 1),
                    dead      = c(2, 3),
                    censored  = c(1, 0))

  expect_error(fit_surv(dat))
})


test_that("error if status is not 0 or 1", {

  dat <- data.frame(Condition = c("WT", "TRT"),
                    Day       = c(1, 1),
                    status    = c(1, 2))

  expect_error(fit_surv(dat))
})


test_that("cleaning names works", {

  dat <- data.frame(Condition = c("WT", "TRT"),
                    Day       = c(1, 1),
                    status    = c(1, 1))

  expect_no_error(fit_surv(dat))
})


test_that("Fitting custom survival formula works", {

  dat <- data.frame(condition = c("WT", "TRT"),
                    sex = c("M", "F"),
                    Day       = c(1, 1),
                    status    = c(1, 1))

  formula = "Surv(day, status) ~ condition + sex"

  expect_no_error(fit_surv(dat, formula = formula))
})
