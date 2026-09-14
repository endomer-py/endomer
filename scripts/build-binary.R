source("endomer/scripts/bootstrap.R")
workspace<-normalizePath(".",winslash="/")
root<-file.path(normalizePath(Sys.getenv("ENDOMER_RELEASE_DIR","artifacts/endomer-engih-release"),winslash="/"),"package")
lib<-file.path(root,"binary-library");dir.create(lib,showWarnings=FALSE)
setwd(root)
version<-read.dcf(file.path(workspace,"endomer/DESCRIPTION"))[1,"Version"]
r<-file.path(R.home("bin"),"R.exe")
status<-system2(r,c("CMD","INSTALL","--build",paste0("--library=",shQuote(lib)),paste0("endomer_",version,".tar.gz")))
if(status!=0L)stop("Binary build failed")
installed<-file.path(root,"zip-installed");dir.create(installed,showWarnings=FALSE)
install.packages(paste0("endomer_",version,".zip"),repos=NULL,type="win.binary",lib=installed)
.libPaths(c(installed,.libPaths()));library(endomer)
stopifnot(normalizePath(find.package("endomer"))==normalizePath(file.path(installed,"endomer")))
report<-endomer_deps()
stopifnot(all(report$meets_requirement),all(report$action=="none"),
 all(paste0("package:",report$package) %in% search()))
enft<-enftr::ft_peri_vars(data.frame(EFT_PERIODO=c("1/2005","2/2005")))
encft<-encftr::ftc_factor_expansion_anual(data.frame(FACTOR_EXPANSION=c(100,200)),periods=4)
ehg<-enhogar::ehg_inactivo(enhogar::enhogar_example(2022),min_edad=10,edition=2022)
stopifnot(identical(enft$semestre,c(1L,2L)),all(enft$ano==2005),
 identical(encft$factor_expansion_anual,c(25,50)),nrow(ehg)==12,all(ehg$pet==1))
jsonlite::write_json(list(package="endomer",version=as.character(packageVersion("endomer")),
 r=as.character(getRversion()),library=find.package("endomer"),report=report,
 integrated_surveys=c("ENFT","ENCFT","ENHOGAR 2022","ENGIH 2018")),"binary-install-audit.json",pretty=TRUE,auto_unbox=TRUE)
stopifnot(nrow(engihr::egi_modules())==25L,
 setequal(engihr::egi_dict_versions("b1")$version,c("baseline-1","coverage-2")),
 labeler::dict_revision(engihr::egi_dict("b1"))$version=="coverage-2")
cat("Verified installed binary and all four survey entry points\n")
