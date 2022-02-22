#' Actualiza los paquetes ENDOMER
#'
#' Se valida si hay actualizaciones disponibles para los paquetes ENDOMER, y se
#' pregunta al usuario si desea actualizarlos.
#'
#' @inheritParams endomer_deps
#' @export
#' @examples
#' \dontrun{
#' endomer_update()
#' }
endomer_update <- function(recursive = FALSE, repos = getOption("repos")) {
  tryCatch({
    requireNamespace("cli")
  }, error = function(e){
    print("El paquete cli es necesario para utilizar esta funci\u00ef3n.")
  })

  deps <- endomer_deps(recursive, repos)
  behind <- deps[deps[["behind"]], ]

  if (nrow(behind) == 0) {
    cli::cat_line("Todos los paquetes ENDOMER est\u00e1n al d\u00eeda.")
    return(invisible())
  }

  cli::cat_line(cli::pluralize(
    "{?El/Los} siguientes {cli::qty(nrow(behind))}paquete{?s} {?no est\u00e1/no est\u00e1n} actualizados:"
  ))
  cli::cat_line()
  cli::cat_bullet(format(behind$package), " (", behind$local, " -> ", behind$cran, ")")

  cli::cat_line()
  cli::cat_line("Inicia una nueva sesi\u00ef3n R y luego ejecuta:")

  pkg_str <- paste0(deparse(behind$package), collapse = "\n")
  cli::cat_line("install.packages(", pkg_str, ")")

  invisible()
}

#' Lista todas las dependencias de ENDOMER
#'
#' @param recursive Si \code{TRUE}, incluso se listan las dependencias de las
#' dependencias de ENDOMER.
#' @param repos Los repositorios que se utilizarán para verificar las actualizaciones.
#'   Por defecto se toma \code{getOption("repos")}.
#' @export
endomer_deps <- function(recursive = FALSE, repos = getOption("repos")) {
  tryCatch({
    requireNamespace("purrr")
  }, error = function(e){
    print("El paquete purrr es necesario para utilizar esta funci\u00ef3n.")
  })

  pkgs <- utils::available.packages(repos = repos)
  deps <- tools::package_dependencies("endomer", pkgs, recursive = recursive)

  pkg_deps <- unique(sort(unlist(deps)))

  base_pkgs <- c()
  pkg_deps <- setdiff(pkg_deps, base_pkgs)

  tool_pkgs <- c()
  pkg_deps <- setdiff(pkg_deps, tool_pkgs)

  cran_version <- lapply(pkgs[pkg_deps, "Version"], base::package_version)
  local_version <- lapply(pkg_deps, packageVersion)

  behind <- purrr::map2_lgl(cran_version, local_version, `>`)

  data.frame(
    package = pkg_deps,
    cran = cran_version %>% purrr::map_chr(as.character),
    local = local_version %>% purrr::map_chr(as.character),
    behind = behind
  )
}

packageVersion <- function(pkg) {
  res <- 0
  tryCatch({
    res <- utils::packageVersion(pkg)
  }, error = function(e){
    res <- 0
  })
}
