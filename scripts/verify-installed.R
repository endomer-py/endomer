source("endomer/scripts/bootstrap.R")
mode<-commandArgs(trailingOnly=TRUE)[[1]]
stopifnot(mode %in% c("binary","source","zip"))
out<-normalizePath(Sys.getenv("ENDOMER_RELEASE_DIR","artifacts/endomer-engih-release"),winslash="/")
lib<-file.path(out,paste0("install-",mode));.libPaths(c(lib,.libPaths()))
library(endomer)
packages<-c("labeler","Dmisc","enftr","encftr","enhogar","engihr","endomer")
resolved<-vapply(packages,function(n) getNamespaceInfo(asNamespace(n),"path"),character(1))
stopifnot(all(normalizePath(resolved)==normalizePath(file.path(lib,packages))))
enft<-enftr::ft_peri_vars(data.frame(EFT_PERIODO=c("1/2005","2/2005")))
encft<-encftr::ftc_factor_expansion_anual(data.frame(FACTOR_EXPANSION=c(100,200)),periods=4)
ehg<-enhogar::ehg_inactivo(enhogar::enhogar_example(2022),min_edad=10,edition=2022)
stopifnot(identical(enft$semestre,c(1L,2L)),all(enft$ano==2005),
 identical(encft$factor_expansion_anual,c(25,50)),nrow(ehg)==12,all(ehg$pet==1),ehg$inactivo[8]==1)
report<-endomer_deps();stopifnot(nrow(report)==4L,all(report$action=="none"),
 all(paste0("package:",report$package) %in% search()))
engih<-engihr::egi_example();labelled<-engihr::egi_set_labels(engih,version="baseline-1")
stopifnot(identical(as.numeric(labelled$A201),engih$A201),nrow(engihr::egi_modules())==25L)
# Run the complete suite against the installed namespace, then execute every
# paired guide against this same library, without loading source via pkgload.
r<-testthat::test_dir("endomer/tests/testthat",package="endomer",load_package="installed",reporter="summary",stop_on_failure=TRUE)
x<-as.data.frame(r)
stopifnot(sum(x$failed)==0L,sum(x$warning)==0L,sum(x$skipped)==0L)
guides<-c(list.files("endomer/vignettes","\\.Rmd$",full.names=TRUE),
 list.files("endomer/pkgdown/i18n/en/vignettes","\\.Rmd$",full.names=TRUE))
for(guide in guides) {
  code<-tempfile(fileext=".R")
  knitr::purl(guide,output=code,quiet=TRUE)
  source(code,local=new.env(parent=globalenv()))
}
jsonlite::write_json(list(mode=mode,resolved_libraries=as.list(resolved),versions=report,
 tests=list(groups=nrow(x),expectations=sum(x$nb),failed=sum(x$failed),warnings=sum(x$warning),skipped=sum(x$skipped)),
 executed_guides=guides,
 survey_examples=list(ENFT=enft[c("ano","semestre")],ENCFT=encft,
 ENHOGAR=ehg[c("case_id","pet","inactivo")],ENGIH=list(modules=nrow(engihr::egi_modules()),
 validation=engihr::egi_validate(labelled),revision=engihr::egi_dict_versions("b1"))),success=TRUE),
 file.path(out,paste0("integration-",mode,"-audit.json")),pretty=TRUE,auto_unbox=TRUE,na="null")
cat("Verified installed namespace paths and integrated survey examples:",mode,"\n")
