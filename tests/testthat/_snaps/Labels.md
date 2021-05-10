# labels

    Code
      str(set_labels(datos, dict = dict))
    Output
      'data.frame':	10 obs. of  3 variables:
       $ SEXO  : num  1 1 1 1 1 2 2 2 2 2
        ..- attr(*, "label")= chr "Sexo de la persona"
        ..- attr(*, "labels")= Named num [1:2] 1 2
        .. ..- attr(*, "names")= chr [1:2] "Hombre" "Mujer"
       $ ESTADO: num  1 1 1 1 2 2 2 2 3 3
        ..- attr(*, "label")= chr "Estado marital de la persona"
        ..- attr(*, "labels")= Named num [1:3] 1 2 3
        .. ..- attr(*, "names")= chr [1:3] "Soltero" "Casado" "Viudo"
       $ Altura: num  1 1 1 1 2 2 2 2 3 3

---

    Code
      str(setLabels(datos, dict = dict))
    Warning <lifecycle_warning_deprecated>
      `setLabels()` was deprecated in endomer 0.1.1.
      Please use `set_labels()` instead.
      This warning is displayed once every 8 hours.
      Call `lifecycle::last_warnings()` to see where this warning was generated.
    Output
      'data.frame':	10 obs. of  3 variables:
       $ SEXO  : num  1 1 1 1 1 2 2 2 2 2
        ..- attr(*, "label")= chr "Sexo de la persona"
        ..- attr(*, "labels")= Named num [1:2] 1 2
        .. ..- attr(*, "names")= chr [1:2] "Hombre" "Mujer"
       $ ESTADO: num  1 1 1 1 2 2 2 2 3 3
        ..- attr(*, "label")= chr "Estado marital de la persona"
        ..- attr(*, "labels")= Named num [1:3] 1 2 3
        .. ..- attr(*, "names")= chr [1:3] "Soltero" "Casado" "Viudo"
       $ Altura: num  1 1 1 1 2 2 2 2 3 3

---

    Code
      str(set_labels(datos, vars = c("SEXO"), dict = dict))
    Output
      'data.frame':	10 obs. of  3 variables:
       $ SEXO  : num  1 1 1 1 1 2 2 2 2 2
        ..- attr(*, "label")= chr "Sexo de la persona"
        ..- attr(*, "labels")= Named num [1:2] 1 2
        .. ..- attr(*, "names")= chr [1:2] "Hombre" "Mujer"
       $ ESTADO: num  1 1 1 1 2 2 2 2 3 3
       $ Altura: num  1 1 1 1 2 2 2 2 3 3

---

    Code
      str(set_labels(datos, dict = dict, ignore_case = T))
    Output
      'data.frame':	10 obs. of  3 variables:
       $ SEXO  : num  1 1 1 1 1 2 2 2 2 2
        ..- attr(*, "label")= chr "Sexo de la persona"
        ..- attr(*, "labels")= Named num [1:2] 1 2
        .. ..- attr(*, "names")= chr [1:2] "Hombre" "Mujer"
       $ ESTADO: num  1 1 1 1 2 2 2 2 3 3
        ..- attr(*, "label")= chr "Estado marital de la persona"
        ..- attr(*, "labels")= Named num [1:3] 1 2 3
        .. ..- attr(*, "names")= chr [1:3] "Soltero" "Casado" "Viudo"
       $ Altura: num  1 1 1 1 2 2 2 2 3 3
        ..- attr(*, "label")= chr "Altura de la persona"
        ..- attr(*, "labels")= Named num [1:3] 1 2 3
        .. ..- attr(*, "names")= chr [1:3] "Baja" "Media" "Alta"

---

    Code
      use_labels(datos, dict = dict)
    Output
           SEXO  ESTADO Altura
      1  Hombre Soltero      1
      2  Hombre Soltero      1
      3  Hombre Soltero      1
      4  Hombre Soltero      1
      5  Hombre  Casado      2
      6   Mujer  Casado      2
      7   Mujer  Casado      2
      8   Mujer  Casado      2
      9   Mujer   Viudo      3
      10  Mujer   Viudo      3

---

    Code
      useLabels(datos, dict = dict)
    Warning <lifecycle_warning_deprecated>
      `useLabels()` was deprecated in endomer 0.1.1.
      Please use `use_labels()` instead.
      This warning is displayed once every 8 hours.
      Call `lifecycle::last_warnings()` to see where this warning was generated.
    Output
           SEXO  ESTADO Altura
      1  Hombre Soltero      1
      2  Hombre Soltero      1
      3  Hombre Soltero      1
      4  Hombre Soltero      1
      5  Hombre  Casado      2
      6   Mujer  Casado      2
      7   Mujer  Casado      2
      8   Mujer  Casado      2
      9   Mujer   Viudo      3
      10  Mujer   Viudo      3

---

    Code
      use_labels(datos, vars = c("SEXO"), dict = dict)
    Output
           SEXO ESTADO Altura
      1  Hombre      1      1
      2  Hombre      1      1
      3  Hombre      1      1
      4  Hombre      1      1
      5  Hombre      2      2
      6   Mujer      2      2
      7   Mujer      2      2
      8   Mujer      2      2
      9   Mujer      3      3
      10  Mujer      3      3

---

    Code
      use_labels(set_labels(datos, dict = dict, ignore_case = T))
    Output
           SEXO  ESTADO Altura
      1  Hombre Soltero   Baja
      2  Hombre Soltero   Baja
      3  Hombre Soltero   Baja
      4  Hombre Soltero   Baja
      5  Hombre  Casado  Media
      6   Mujer  Casado  Media
      7   Mujer  Casado  Media
      8   Mujer  Casado  Media
      9   Mujer   Viudo   Alta
      10  Mujer   Viudo   Alta

