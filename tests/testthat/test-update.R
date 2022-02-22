test_that("multiplication works", {
  local_edition(3)
  expect_snapshot(endomer_deps(repos = "http://cran.us.r-project.org"))
  expect_snapshot(endomer_update(repos = "http://cran.us.r-project.org"))
})
