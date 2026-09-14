# Run: Rscript install.R path/to/library [source|win.binary]
# Uses local archives only. External R dependencies must already be installed.
args<-commandArgs(trailingOnly=TRUE)
if(!length(args)||length(args)>2L||!nzchar(args[[1]]))stop("Usage: Rscript install.R library [source|win.binary]")
script<-normalizePath(sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE)),winslash="/")
root<-dirname(script)
type<-if(length(args)==2L) args[[2]] else if(.Platform$OS.type=="windows") "win.binary" else "source"
if(!type %in% c("source","win.binary"))stop("Type must be source or win.binary")
if(type=="win.binary" && .Platform$OS.type!="windows")stop("Windows binaries require Windows")
if(getRversion()<"4.1.0")stop("R >= 4.1.0 is required")
inventory<-read.dcf(file.path(root,"packages.dcf"))
required<-c("Package","Version","Source","SourceMD5","Binary","BinaryMD5")
if(!all(required %in% colnames(inventory))||anyNA(inventory[,required])||
   !identical(unname(inventory[,"Package"]),c("labeler","Dmisc","enftr","encftr","enhogar","engihr","endomer")))stop("Invalid bundle inventory")
field<-if(type=="source") "Source" else "Binary"
names<-inventory[,field]
if(any(basename(names)!=names))stop("Artifact names must be plain file names")
files<-file.path(root,"packages/r",names)
if(!all(file.exists(files)))stop("Incomplete bundle: missing package archives")
if(!identical(unname(tools::md5sum(files)),unname(inventory[,paste0(field,"MD5")])))stop("Artifact checksum mismatch")
lib<-path.expand(args[[1]])
if(file.exists(lib) && (!dir.exists(lib) || length(list.files(lib,all.files=TRUE,no..=TRUE))))
  stop("Destination library must be new or empty")
.libPaths(c(lib,.libPaths()))
external<-readLines(file.path(root,"external-dependencies.txt"),warn=FALSE)
missing<-setdiff(external,utils::installed.packages()[,"Package"])
if(length(missing))stop("Install these external dependencies first: ",paste(missing,collapse=", "))
constraints<-read.dcf(file.path(root,"external-constraints.dcf"))
if(!all(c("Package","Operator","Required","RequestedBy") %in% colnames(constraints)) ||
   anyNA(constraints) || any(!constraints[,"Operator"] %in% c("*",">=",">","==","<=","<")))
  stop("Invalid external dependency constraints")
for(i in seq_len(nrow(constraints))) {
  package<-constraints[i,"Package"]
  version<-if(package=="R") as.character(getRversion()) else
    tryCatch(as.character(utils::packageVersion(package)),error=function(e) NA_character_)
  if(is.na(version))stop("Missing external dependency: ",package)
  compare<-utils::compareVersion(version,constraints[i,"Required"])
  valid<-switch(constraints[i,"Operator"],"*"=TRUE,">="=compare>=0L,">"=compare>0L,
    "=="=compare==0L,"<="=compare<=0L,"<"=compare<0L)
  if(!valid)stop("External dependency version does not satisfy ",package," ",constraints[i,"Operator"]," ",constraints[i,"Required"])
}
if(!dir.exists(lib) && !dir.create(lib,recursive=TRUE))stop("Cannot create destination library")
lib<-normalizePath(lib,winslash="/",mustWork=TRUE)
.libPaths(c(lib,.libPaths()))
Sys.setenv(R_LIBS=paste(.libPaths(),collapse=.Platform$path.sep))
for(i in seq_along(files)) {
  utils::install.packages(files[i],repos=NULL,type=type,lib=lib)
  installed<-utils::packageDescription(inventory[i,"Package"],lib.loc=lib)$Version
  if(!identical(unname(installed),unname(inventory[i,"Version"])))stop("Installed version verification failed: ",inventory[i,"Package"])
}
library(endomer,lib.loc=lib)
resolved<-vapply(inventory[,"Package"],function(package) getNamespaceInfo(asNamespace(package),"path"),character(1))
if(!all(normalizePath(resolved)==normalizePath(file.path(lib,inventory[,"Package"]))))stop("A namespace was loaded outside the destination library")
report<-endomer_deps(lib.loc=.libPaths())
stopifnot(all(report$meets_requirement),all(report$action=="none"),
 all(paste0("package:",report$package) %in% search()))
jsonlite::write_json(list(r=as.character(getRversion()),type=type,library=lib,
 installed=as.data.frame(inventory[,c("Package","Version"),drop=FALSE]),resolved=as.list(resolved),report=report),
 file.path(lib,"install-audit.json"),auto_unbox=TRUE,pretty=TRUE)
cat("Installed and verified all",nrow(inventory),"local packages in",lib,"\n")
