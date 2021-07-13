#' Asigna etiquetas de datos a las variables especificadas
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param tbl [data.frame]: Conexión a base de datos o dataframe con los datos
#' @param vars [character]: Si especificado, solo se asignaran las etiquetas a esas variables.
#' @param dict [data.frame]: Diccionario con todas las etiquetas de datos a utilizar
#' @param ignore_case [logical]: Indicate if case sensitive should be ignored.
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
#'   enft <- data.frame(S2_P8 = c(1, 2))
#'   str(enft)
#'   str(set_labels(enft, dict = dict))
#'}
set_labels <- function(tbl, vars = NULL, dict, ignore_case = FALSE) {
  if(!is.null(vars)){
    names <- vars
  } else if(!is.null(tbl)){ # Validar luego las clases de tbl admitidas
    names <- names(tbl)
  } else {
    names <- NULL
  }
  if (all(!is.null(tbl), !is.null(names))) {
    for (name in names) {
      if (ignore_case){
        name <- names(dict)[tolower(names(dict)) == tolower(name)]
      }
      tryCatch({
        lab <- dict[[name]]$lab
        labs <- dict[[name]]$labs
        lab <- validateLab(lab, dict)
        labs <- validateLabs(labs, dict)
        name <- names(tbl)[tolower(names(tbl)) == tolower(name)]
        tbl <- labellize(tbl, name, lab, labs)},
        error = function(e){

        })
    }
  }
  tbl
}

setLabels <- function(tbl, vars = NULL, dict, ignore_case = FALSE) {
  deprecate_warn("0.1.1", "endomer::setLabels()", "set_labels()")
  set_labels(tbl, vars, dict, ignore_case)
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
  stringi::stri_unescape_unicode(lab)
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
  if(!is.null(names(labs))){
    names(labs) <- stringi::stri_unescape_unicode(names(labs))
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
#' @param ignore_case [logical]: Indicate if case sensitive should be ignored.
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
#'   use_labels(enft, dict = dict)
#'}
use_labels <- function(tbl, vars = NULL, dict = NULL, ignore_case = F) {
  if(!is.null(dict)){
    tbl <- set_labels(tbl, vars, dict, ignore_case)
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

useLabels <- function(tbl, vars = NULL, dict = NULL) {
  deprecate_warn("0.1.1", "endomer::useLabels()", "use_labels()")
  use_labels(tbl, vars, dict)
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




