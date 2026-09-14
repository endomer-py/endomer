\name{endomer_update}
\alias{endomer_update}
\title{Prepare an update report without installing packages}
\usage{
endomer_update(
  recursive = FALSE,
  repos = NULL,
  available = NULL,
  lib.loc = .libPaths(),
  quiet = FALSE
)
}
\arguments{
\item{recursive}{TRUE follows mandatory Depends, Imports and LinkingTo edges from available and installed metadata. Excludes R, base packages and Suggests. This inventory does not resolve every transitive version constraint.}
\item{repos}{Explicit R source repositories, or NULL for offline operation. Does not query GitHub. Cannot be combined with available.}
\item{available}{Optional matrix or data.frame with unique Package names and valid Version strings. Optional Depends, Imports, LinkingTo and Priority fields support graph traversal. Avoids network requests.}
\item{lib.loc}{Installed libraries in precedence order, default .libPaths(). Loaded versions are reported independently.}
\item{quiet}{TRUE omits messages and printing; the report is still returned invisibly.}
}
\value{A data.frame with package, required, local, loaded, target, cran, behind, meets_requirement, target_compatible, status, action, restart_required, source and repository. endomer_update returns it invisibly.}
\description{Return the endomer_deps report invisibly, optionally displaying recommended actions. It never installs packages, requests confirmation or changes libraries. Meeting a bundled minimum does not imply having the latest published version.}
\details{behind is NA for unknown targets. required checks the four survey minimums only. meets_minimum confirms the bundled minimum; current means matching the supplied index, not the latest GitHub release. unavailable preserves missing-index information; installed_unchecked marks transitive dependencies without targets. cran is retained as a historical alias of the index target, not a claim about its provider. See the version guide for all states.}
\examples{
plan <- endomer_update(quiet=TRUE)
plan[c("package","local","required","action")]
}
