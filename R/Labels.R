#' Etiquetas de datos
#'
#' `r lifecycle::badge("experimental")`
#'
#'   Asigna etiquetas de datos a todas las variables que aplica.
#'
#' @param tbl Conexión a base de datos o dataframe con los datos de la ENCFT.
#' @param vars Si especificado, solo se asignaran las etiquetas a esas variables.
#' @param pattern patrón inicial del nombre de las funciones del paquete
#'
#' @return Conexión a base de datos o dataframe según input.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   encft <- setLabels(tbl = encft, pattern = "ftc")
#' }
setLabels <- function(tbl, vars = NULL, pattern){
  if(is.null(vars)){
    for (name in names(tbl)) {
      tryCatch({
        tbl <- get(paste0(pattern, '_setLabels_', tolower(name)))(tbl)
      }, error = function(e){
        NULL
      })
    }
    return(tbl)
  }
}



#' Utilizar etiquetas de datos de todas las variables
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param tbl Conexión a base de datos o dataframe con los datos
#' @param vars Si es especificado, solo estas variables serán asignadas como
#'   etiquetas de datos
#'
#' @return Conexión a base de datos o dataframe según input
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   encft <- useLabels(encft)
#' }
useLabels <- function(tbl, vars = NULL){
  if(is.null(vars)){
    for (name in names(tbl)) {
      tbl[,name] <- asLabels(tbl[,name])
    }
    return(tbl)
  }
}



#' Utilizar etiquetas de datos de la variable
#'
#' `r lifecycle::badge("stable")`
#'
#'   Reemplaza los valores de la variable por las etiquetas de esta
#'
#' @param var variable o vector de datos que contiene las etiquetas a ser empleadas
#'
#' @return vector de datos con los valores cambiados por etiquetas
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   tbl$var <- asLabels(tbl$var)
#' }
asLabels <- function(var){
  tryCatch({
    sjlabelled::as_label(var)
  }, error = function(e){
    var
  })
}
