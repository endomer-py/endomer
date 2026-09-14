\name{endomer_deps}
\alias{endomer_deps}
\title{Inspect installed and target versions}
\usage{
endomer_deps(
  recursive = FALSE,
  repos = NULL,
  available = NULL,
  lib.loc = .libPaths()
)
}
\arguments{
\item{recursive}{TRUE follows mandatory Depends, Imports and LinkingTo edges from available and installed metadata. Excludes R, base packages and Suggests. This inventory does not resolve every transitive version constraint.}
\item{repos}{Explicit R source repositories, or NULL for offline operation. Does not query GitHub. Cannot be combined with available.}
\item{available}{Optional matrix or data.frame with unique Package names and valid Version strings. Optional Depends, Imports, LinkingTo and Priority fields support graph traversal. Avoids network requests.}
\item{lib.loc}{Installed libraries in precedence order, default .libPaths(). Loaded versions are reported independently.}
}
\value{A data.frame with package, required, local, loaded, target, cran, behind, meets_requirement, target_compatible, status, action, restart_required, source and repository. endomer_update returns it invisibly.}
\description{Compare installed packages against bundled minimum versions by default. Alternatively provide an explicit repository or an in-memory Package/Version index. Neither endomer nor its surveys need to appear on CRAN. Missing targets remain unknown. Reports distinguish installed and loaded versions, recommended actions and the comparison source.}
\details{behind is NA for unknown targets. required checks the four survey minimums only. meets_minimum confirms the bundled minimum; current means matching the supplied index, not the latest GitHub release. unavailable preserves missing-index information; installed_unchecked marks transitive dependencies without targets. cran is retained as a historical alias of the index target, not a claim about its provider. See the version guide for all states.}
\examples{
endomer_deps()
indice <- data.frame(Package=c("enftr","encftr","enhogar","engihr"),
                     Version=c("0.9.0","0.10.0","0.5.0","0.3.0"))
endomer_deps(available=indice)
}
