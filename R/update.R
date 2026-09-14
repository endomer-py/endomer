#' Paquetes de encuestas incluidos en endomer
#'
#' El catalogo versionado declara las versiones minimas de las cuatro encuestas.
#' No consulta Internet ni representa las versiones mas recientes de GitHub.
#' @return data.frame con package, required, repository y documentation.
#' @export
#' @examples
#' endomer_packages()
endomer_packages <- function() {
  as.data.frame(read.dcf(system.file("packages.dcf", package = "endomer")),
                stringsAsFactors = FALSE)
}
.endomer_flag <- function(x, name) {
  if (!is.logical(x) || length(x) != 1L || is.na(x))
    stop(name, " must be TRUE or FALSE", call. = FALSE)
}
.endomer_index <- function(x) {
  if (!(is.matrix(x) || is.data.frame(x)) || !all(c("Package", "Version") %in% colnames(x)))
    stop("available must contain Package and Version columns", call. = FALSE)
  x <- as.data.frame(x, stringsAsFactors = FALSE)
  for (n in names(x)) x[[n]] <- as.character(x[[n]])
  if (anyNA(x$Package) || any(!nzchar(x$Package)) || anyDuplicated(x$Package))
    stop("Package names must be nonmissing and unique", call. = FALSE)
  if (anyNA(x$Version) || any(!grepl("^[0-9]+([.-][0-9]+)*$", x$Version)))
    stop("Version values must be valid numeric R package versions", call. = FALSE)
  for (n in c("Depends", "Imports", "LinkingTo", "Priority"))
    if (!n %in% names(x)) x[[n]] <- rep(NA_character_, nrow(x))
  rownames(x) <- x$Package
  x
}
.endomer_installed <- function(lib.loc) {
  x <- utils::installed.packages(lib.loc = lib.loc, noCache = TRUE)
  .endomer_index(x[!duplicated(x[, "Package"]), , drop = FALSE])
}
.endomer_available <- function(repos) {
  x <- utils::available.packages(repos = repos, type = "source")
  if (!nrow(x)) stop("No usable repository index; supply available or use repos=NULL", call. = FALSE)
  .endomer_index(x)
}
.endomer_loaded <- function(package) {
  if (package %in% loadedNamespaces()) as.character(getNamespaceVersion(package)) else NA_character_
}
.endomer_compare <- function(a, b) utils::compareVersion(a, b)

#' Comprobar versiones instaladas y disponibles
#'
#' Por defecto compara con el catalogo incluido, sin consultar Internet. Los
#' paquetes no tienen que estar publicados en CRAN para aparecer en el informe.
#' @param recursive TRUE incluye Depends, Imports y LinkingTo transitivos segun
#'   el indice suministrado y los metadatos instalados; excluye R y paquetes base.
#'   required solo declara minimos para las cuatro encuestas, no resuelve todas
#'   las restricciones de dependencias transitivas.
#' @param repos Repositorios R explicitos para consultar indices fuente, o NULL
#'   para trabajar sin red. No consulta GitHub automaticamente.
#' @param available Indice local opcional, matriz o data.frame con Package y
#'   Version. Puede incluir Depends, Imports, LinkingTo y Priority. Es alternativo
#'   a repos y permite comprobar repositorios sin hacer consultas de red.
#' @param lib.loc Bibliotecas instaladas, en orden de prioridad. Por defecto
#'   .libPaths(). La version cargada se informa aparte de la instalada.
#' @return data.frame con versiones requeridas, instaladas, cargadas y objetivo,
#'   estado, acciones recomendadas y procedencia. behind es NA si el objetivo
#'   es desconocido. cran conserva el nombre historico para la version del
#'   indice consultado; no implica que el repositorio sea CRAN.
#' @details meets_minimum confirma el minimo incluido, no que se tenga la ultima
#'   version publicada. unavailable significa que el indice no contiene el
#'   paquete. Con recursive=TRUE, las dependencias sin objetivo verificable se
#'   marcan installed_unchecked. No instala, descarga ni carga paquetes.
#' @export
#' @examples
#' endomer_deps()
#' indice <- data.frame(Package=c("enftr","encftr","enhogar","engihr"),
#'                      Version=c("0.9.0","0.10.0","0.5.0","0.3.0"))
#' endomer_deps(available=indice)
endomer_deps <- function(recursive = FALSE, repos = NULL, available = NULL,
                         lib.loc = .libPaths()) {
  .endomer_flag(recursive, "recursive")
  if (!is.character(lib.loc) || anyNA(lib.loc) || any(!nzchar(lib.loc)))
    stop("lib.loc must contain nonempty library paths", call. = FALSE)
  if (!is.null(repos) && (!is.character(repos) || !length(repos) || anyNA(repos) ||
                        any(!nzchar(repos)) || any(repos == "@CRAN@")))
    stop("repos must contain explicit repositories or be NULL", call. = FALSE)
  if (!is.null(repos) && !is.null(available))
    stop("Supply repos or available, not both", call. = FALSE)
  catalog <- endomer_packages()
  installed <- .endomer_installed(lib.loc)
  index <- if (!is.null(available)) .endomer_index(available) else
    if (!is.null(repos)) .endomer_available(repos) else NULL
  packages <- catalog$package
  if (recursive) {
    fields <- c("Package", "Version", "Depends", "Imports", "LinkingTo", "Priority")
    db <- installed[fields]
    if (!is.null(index)) db <- rbind(index[fields], db[!db$Package %in% index$Package, , drop = FALSE])
    graph <- tools::package_dependencies(packages, db=as.matrix(db),
      which=c("Depends", "Imports", "LinkingTo"), recursive=TRUE)
    base <- db$Package[!is.na(db$Priority) & db$Priority == "base"]
    packages <- c(packages, sort(setdiff(unique(unlist(graph, use.names=FALSE)), c(packages, "R", base))))
  }
  required <- catalog$required[match(packages, catalog$package)]
  local <- installed$Version[match(packages, installed$Package)]
  loaded <- vapply(packages, .endomer_loaded, character(1), USE.NAMES=FALSE)
  target <- if (is.null(index)) required else index$Version[match(packages, index$Package)]
  source <- if (is.null(index)) "bundled_minimum" else if (is.null(repos)) "supplied_index" else "repository_index"
  meets <- compatible <- behind <- rep(NA, length(packages))
  status <- action <- rep(NA_character_, length(packages))
  for (i in seq_along(packages)) {
    if (!is.na(required[i])) {
      meets[i] <- !is.na(local[i]) && .endomer_compare(local[i], required[i]) >= 0L
      if (!is.na(target[i])) compatible[i] <- .endomer_compare(target[i], required[i]) >= 0L
    }
    if (!is.na(target[i])) behind[i] <- is.na(local[i]) || .endomer_compare(local[i], target[i]) < 0L
    status[i] <- if (is.na(local[i])) "not_installed" else
      if (identical(meets[i], FALSE)) "below_minimum" else
      if (identical(compatible[i], FALSE)) "repository_below_minimum" else
      if (is.na(target[i])) { if (is.null(index)) "installed_unchecked" else "unavailable" } else
      if (behind[i]) "update_available" else
      if (is.null(index)) "meets_minimum" else
      if (.endomer_compare(local[i], target[i]) > 0L) "newer_than_target" else "current"
    action[i] <- if (status[i] %in% c("not_installed", "below_minimum", "update_available")) {
      if (is.na(target[i]) || identical(compatible[i], FALSE)) "resolve_source" else
        if (is.na(local[i])) "install" else "update"
    } else if (status[i] %in% c("unavailable", "repository_below_minimum")) "resolve_source" else
      if (status[i] == "installed_unchecked") "inspect" else "none"
  }
  restart <- !is.na(loaded) & (is.na(local) | loaded != local)
  action[restart & action == "none"] <- "restart_session"
  data.frame(package=packages, required=required, local=local, loaded=loaded,
    target=target, cran=if (is.null(index)) rep(NA_character_, length(packages)) else target,
    behind=behind, meets_requirement=meets, target_compatible=compatible,
    status=status, action=action, restart_required=restart, source=source,
    repository=catalog$repository[match(packages,catalog$package)], stringsAsFactors=FALSE)
}

#' Preparar un informe de actualizacion sin instalar paquetes
#' @inheritParams endomer_deps
#' @param quiet TRUE omite los mensajes; siempre devuelve el informe invisible.
#' @return El mismo data.frame de endomer_deps(), de forma invisible.
#' @details La funcion conserva su nombre historico pero prepara un informe.
#'   No solicita confirmaciones ni modifica bibliotecas. Con el catalogo local
#'   informa cumplimiento de minimos; no afirma estar actualizado en Internet.
#'   Los indices incompletos y objetivos inferiores al minimo permanecen visibles.
#' @export
#' @examples
#' plan <- endomer_update(quiet=TRUE)
#' plan[c("package","local","required","action")]
endomer_update <- function(recursive = FALSE, repos = NULL, available = NULL,
                           lib.loc = .libPaths(), quiet = FALSE) {
  .endomer_flag(quiet, "quiet")
  report <- endomer_deps(recursive, repos, available, lib.loc)
  if (!quiet) {
    if (is.null(repos) && is.null(available))
      message("Comparacion con los minimos incluidos; no se consulto Internet.") else
      message("Comparacion con el indice indicado; no verifica versiones de GitHub.")
    pending <- report[report$action != "none", c("package","local","target","status","action"), drop=FALSE]
    if (nrow(pending)) print(pending, row.names=FALSE) else
      message("Los paquetes cumplen el objetivo de esta comprobacion.")
    message("Informe preparado. Use los artefactos verificados o el repositorio indicado para instalar; reinicie R despues de una actualizacion.")
  }
  invisible(report)
}
