Sys.setenv(RENV_CONFIG_AUTOLOADER_ENABLED="false",LC_ALL="English_United States.utf8")
source("endomer/scripts/bootstrap.R")
pkgload::load_all("endomer",quiet=TRUE)
plain <- function(x) paste(unlist(x),collapse="")
docs <- list()
for (file in list.files("endomer/man","\\.Rd$",full.names=TRUE)) {
  fields<-list()
  for(node in tools::parse_Rd(file)) {
    tag<-attr(node,"Rd_tag")
    if(!is.null(tag)&& tag %in% c("\\name","\\alias","\\usage","\\examples")) fields[[substring(tag,2)]]<-c(fields[[substring(tag,2)]],plain(node))
  }
  docs[[basename(file)]]<-fields
}
api<-list()
for(name in getNamespaceExports("endomer")) {
  fn<-get(name,asNamespace("endomer"))
  if(is.function(fn)&&name!="%>%") api[[name]]<-list(parameters=names(formals(fn)),body=paste(deparse(body(fn),width.cutoff=100),collapse="\n"))
}
out<-Sys.getenv("ENDOMER_RELEASE_DIR","artifacts/endomer-engih-release")
dir.create(out,recursive=TRUE,showWarnings=FALSE)
jsonlite::write_json(list(docs=docs,api=api),file.path(out,"reference.json"),auto_unbox=TRUE,pretty=TRUE)
cat(length(api),"public functions exported\n")
