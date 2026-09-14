fixture <- function(versions=c("0.9.0","0.10.0","0.5.0","0.3.0")) {
  .endomer_index(data.frame(Package=c("enftr","encftr","enhogar","engihr"),Version=versions))
}
mock_local <- function(db=fixture(), loaded=function(package) NA_character_, .local_envir=parent.frame()) {
  testthat::local_mocked_bindings(.endomer_installed=function(lib.loc) db,
    .endomer_loaded=loaded, .endomer_available=function(repos) stop("Unexpected network request"),
    .package="endomer", .env=.local_envir)
}
