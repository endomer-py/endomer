#' Navegar diccionario
#'
#'  Permite navegar el diccionario de las encuestas en una interfaz web donde
#'  se pueden consultar el nombre y etiquitada de las variables, así como las
#'  etiquetas de los datos.
#'
#' @param dict diccionario de base de datos
#'
#' @return una interfaz web con los datos contenidos en el diccionario suministrado
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   browse_dict(enhogar::dict)
#' }
browse_dict <- function(dict){
  datos <- data.frame(var = character(), lab = character(), labs = character())
  for (name in names(dict)) {
    datos[nrow(datos)+1, "var"] <- name
    datos[nrow(datos), "lab"] <- stringi::stri_unescape_unicode(dict[[name]]$lab)
    labs <- dict[[name]]$labs
    labs2 <- "<div>"
    for (lab in seq_along(labs)){
      labs2 <- paste0(labs2, labs[[lab]], ": ", stringi::stri_unescape_unicode(names(labs)[[lab]]), "<br />")
    }
    datos[nrow(datos), "labs"] <- paste0(labs2, "</div>")
  }
  DT::datatable(datos, escape = FALSE, width = "100%",
                options = list(
                  autoWidth = FALSE,
                  columnDefs = list(
                    list(width = '40%', targets = c(2, 3)),
                    list(targets = c(2), className = 'dt-top')
                    )
                ))
}
