test_that("browse_dict and labels", {
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
  expect_snapshot(
    browse_dict(dict)
    )
})
