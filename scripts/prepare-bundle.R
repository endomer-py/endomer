source("endomer/scripts/bootstrap.R")
pkgload::load_all("endomer",quiet=TRUE)
root<-file.path(Sys.getenv("ENDOMER_RELEASE_DIR","artifacts/endomer-engih-release"),"bundle")
dir.create(file.path(root,"packages/r"),recursive=TRUE,showWarnings=FALSE)
packages<-data.frame(Package=c("labeler","Dmisc","enftr","encftr","enhogar","engihr","endomer"),
 Version=c("0.11.0","0.4.0","0.9.0","0.10.0","0.5.0","0.3.0","0.5.0"),
 path=c("artifacts/labeler/bilingual/package","artifacts/dmisc-release/package", "artifacts/enft-release/package",
        "artifacts/encft-integration/package",Sys.getenv("ENDOMER_ENHOGAR_ARCHIVES","artifacts/endom-closure-release/enhogar/package"),Sys.getenv("ENDOMER_ENGIHR_ARCHIVES","artifacts/endom-closure-release/engihr/package"),
        file.path(Sys.getenv("ENDOMER_RELEASE_DIR","artifacts/endomer-engih-release"),"package")))
for(i in seq_len(nrow(packages))) {
  for(ext in c("tar.gz","zip")) {
    name<-paste0(packages$Package[i],"_",packages$Version[i],".",ext)
    file<-file.path(packages$path[i],name)
    stopifnot(file.exists(file),file.copy(file,file.path(root,"packages/r",name),overwrite=TRUE))
    field<-if(ext=="zip") "Binary" else "Source"
    packages[i,field]<-name;packages[i,paste0(field,"MD5")]<-unname(tools::md5sum(file))
  }
}
write.dcf(packages[setdiff(names(packages),"path")],file.path(root,"packages.dcf"))
report<-endomer_deps(recursive=TRUE)
external<-sort(setdiff(report$package,packages$Package))
stopifnot(all(external %in% rownames(utils::installed.packages())))
writeLines(external,file.path(root,"external-dependencies.txt"))
# Preserve every mandatory version constraint, including transitively required
# packages. Keep constraints separately; an observed version is not a minimum.
constraints<-list()
for(package in c(packages$Package,external)) {
  description<-if(package=="endomer") as.list(read.dcf("endomer/DESCRIPTION")[1,]) else
    as.list(utils::packageDescription(package))
  for(field in c("Depends","Imports","LinkingTo")) {
    value<-description[[field]]
    if(is.null(value)||is.na(value))next
    for(dep in strsplit(value,",",fixed=TRUE)[[1]]) {
      m<-regmatches(trimws(dep),regexec("^([A-Za-z][A-Za-z0-9.]*)[[:space:]]*(\\(([><=]+)[[:space:]]*([0-9.-]+)\\))?$",trimws(dep)))[[1]]
      if(!length(m))stop("Unrecognized dependency: ",dep)
      if(m[2] %in% packages$Package)next
      operator<-if(length(m)>=4L && nzchar(m[4])) m[4] else "*"
      required<-if(operator=="*") "0" else m[5]
      constraints[[length(constraints)+1L]]<-data.frame(Package=m[2],Operator=operator,Required=required,RequestedBy=package)
    }
  }
}
write.dcf(unique(do.call(rbind,constraints)),file.path(root,"external-constraints.dcf"))
file.copy("endomer/scripts/install-bundle.R",file.path(root,"install.R"),overwrite=TRUE)
cat("Prepared",nrow(packages),"project packages and",length(external),"external dependencies\n")
