#' Asigna etiquetas de datos a las variables especificadas
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param tbl [data.frame]: Conexión a base de datos o dataframe con los datos
#' @param vars [character]: Si especificado, solo se asignaran las etiquetas a esas variables.
#' @param dict [data.frame]: Diccionario con todas las etiquetas de datos a utilizar
#'
#' @return Los datos introducidos en el argumento \code{tbl} pero con etiquetas de datos
#'
#' @details
#'   Esta función permite asignar etiquetas de datos a las variables de un data.frame
#'   o equivalente, a partir de un diccionario suministrado. En tal sentido,
#'   puedes utilizar esta función suministrando un diccionario peronal o utilizar
#'   las funciones equivalentes en los paquetes ENDOMER que traen un diccionario
#'   predefinido.
#'
#' @seealso
#'   Etiquetas de datos \code{vignette("labels", package = "endomer")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   dict <- list(
#'     S2_P8 = list(
#'       lab = "¿Tiene esta vivienda instalación para agua corriente por tubería
#'        conectada a la red pública?",
#'       labs = c("Si" = 1, "No" = 2)
#'     )
#'    ) # enftr::dict
#'   enft <- data.frame(S2_P8 = c(1, 2))
#'   str(enft)
#'   str(setLabels(enft, dict = dict))
#'}
setLabels <- function(tbl, vars = NULL, dict) {
  if(!is.null(vars)){
    names <- vars
  } else if(!is.null(tbl)){ # Validar luego las clases de tbl admitidas
    names <- names(tbl)
  } else {
    names <- NULL
  }
  if (all(!is.null(tbl), !is.null(names))) {
    for (name in names) {
      lab <- dict[[name]]$lab
      labs <- dict[[name]]$labs
      lab <- validateLab(lab, dict)
      labs <- validateLabs(labs, dict)
      tbl <- labellize(tbl, name, lab, labs)
    }
  }
  tbl
}



validateLab <- function(lab, dict) {
  if (all(!is.null(lab), is.character(lab))) {
    if (startsWith(lab, "link::")) {
      link <- strsplit(lab, "::")[[1]][[2]]
      lab <- dict[[link]]$lab
      lab <- validateLab(lab, dict)
    }
  } else {
    lab <- NULL
  }
  lab
}

validateLabs <- function(labs, dict) {
  if (!is.null(labs)) {
    if (all(length(labs) == 1, is.character(labs))) {
      if (startsWith(labs, "link::")) {
        link <- strsplit(labs, "::")[[1]][[2]]
        labs <- dict[[link]]$labs
        labs <- validateLabs(labs, dict)
      }
    }
    if (is.null(names(labs))) {
      labs <- NULL
    }
  }
  labs
}


labellize <- function(tbl, var_name, lab, labs) {
  if (!is.null(lab)) {
    tbl[[var_name]] <- sjlabelled::set_label(tbl[[var_name]], label = lab)
  }
  if (!is.null(labs)) {
    tbl[[var_name]] <- sjlabelled::set_labels(tbl[[var_name]], labels = labs)
  }
  tbl
}





#' Utiliza las etiquetas de datos de una variable
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param tbl [data.frame]: Conexión a base de datos o dataframe con los datos
#' @param vars [character]: Si especificado, solo se asignaran las etiquetas a esas variables.
#' @param dict [data.frame]: Diccionario con todas las etiquetas de datos a utilizar
#'   si aún no han sido asignadas. Vea \code{Details}.
#'
#' @return Los datos suministrados en el argumento \code{tbl}, pero en lugar de
#'   valores utilizando las etiquetas de datos correspondientes
#'
#' @details Esta función asume que las etiquetas de datos han sido asignadas a
#'   los datos con anterioridad, a menos que se suministre un \code{dict}, en cuyo
#'   caso se utilizará este último para asignar y utilizar las etiquetas de datos.
#'   En tal sentido, es recomendable utilizar las funciones equivalentes en los
#'   paquetes ENDOMER que vienen con un diccionario
#'
#' @seealso
#'   Etiquetas de datos \code{vignette("labels", package = "endomer")}
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   dict <- list(
#'     S2_P8 = list(
#'       lab = "¿Tiene esta vivienda instalación para agua corriente por tubería
#'        conectada a la red pública?",
#'       labs = c("Si" = 1, "No" = 2)
#'     )
#'    ) # enftr::dict
#'   enft <- data.frame(S2_P8 = c(1, 2))
#'   enft
#'   useLabels(enft, dict = dict)
#'}
useLabels <- function(tbl, vars = NULL, dict = NULL) {
  if(!is.null(dict)){
    tbl <- setLabels(tbl, vars, dict)
  }
  if(!is.null(vars)){
    names <- vars
  } else if(!is.null(tbl)){ # Validar luego las clases de tbl admitidas
    names <- names(tbl)
  } else {
    names <- NULL
  }
  if (all(!is.null(tbl), !is.na(vars))) {
    for (name in names) {
      tbl[, name] <- asLabels(tbl[, name])
    }
    tbl
  }
}




asLabels <- function(var) {
  tryCatch(
    {
      sjlabelled::as_label(var)
    },
    error = function(e) {
      var
    }
  )
}




