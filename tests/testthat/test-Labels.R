test_that("labels", {
  local_edition(3)
  dict <- list(
    SEXO = list(
      lab = "Sexo de la persona",
      labs = c("Hombre" = 1, "Mujer" = 2)
    ),
    ESTADO = list(
      lab = "Estado marital de la persona",
      labs = c("Soltero" = 1, "Casado" = 2, "Viudo" = 3)
    ),
    ALTURA = list(
      lab = "Altura de la persona",
      labs = c("Baja" = 1, "Media" = 2, "Alta" = 3)
    )
  )
  datos <- data.frame(
    SEXO = c(rep(1, 5), rep(2, 5)),
    ESTADO = c(rep(1, 4), rep(2, 4), 3, 3),
    Altura = c(rep(1, 4), rep(2, 4), 3, 3)
  )
  expect_snapshot(str(set_labels(datos, dict = dict)))
  expect_snapshot(str(setLabels(datos, dict = dict)))
  expect_snapshot(str(set_labels(datos, vars = c("SEXO"), dict = dict)))
  expect_snapshot(str(set_labels(datos, dict = dict, ignore_case = T)))

  expect_snapshot(use_labels(datos, dict = dict))
  expect_snapshot(useLabels(datos, dict = dict))
  expect_snapshot(use_labels(datos, vars = c("SEXO"), dict = dict))
  expect_snapshot(use_labels(set_labels(datos, dict = dict, ignore_case = T)))
})
