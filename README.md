
<!-- README.md is generated from README.Rmd. Please edit that file -->

# endomer <img src='man/figures/logo.png' align="right" height="138" />

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/endomer-py/endomer/workflows/R-CMD-check/badge.svg)](https://github.com/endomer-py/endomer/actions)
[![Codecov test
coverage](https://codecov.io/gh/endomer-py/endomer/branch/main/graph/badge.svg)](https://codecov.io/gh/endomer-py/endomer?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/endomer)](https://CRAN.R-project.org/package=endomer)
<!-- badges: end -->

Es un metapaquete. Su función principal es facilitar la instalación y
carga de los demás paquetes R del proyecto **endomer+py**.

## Instalación

Al instalar `endomer` instalas todos los demás paquetes R del proyecto
**endomer+py**.

<!-- You can install the released version of endomer from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("endomer") -->
<!-- ``` -->

`endomer` no está dispobible en CRAN. Pero puedes instalar la versión de
desarrollo desde [GitHub](https://github.com/) con:

``` r
tryCatch(
  library(remotes),
  error = function(e){
    install.packages('remotes')
  }
)
remotes::install_github("endomer-py/endomer")
```

## Contribuye

Tienes comentarios o quieres contribuir?

Por favor, revisa las [gias de contribución (en
inglés)](https://endomer-py.github.io/endomer/CONTRIBUTING.html) antes
de iniciar un issue o pull request.

Por favor, observa que el proyecto endomer está sujeto a un [Código del
contribuyente](https://contributor-covenant.org/es/version/2/0/CODE_OF_CONDUCT.html).
Contribuyendo con el proyecto aceptas las términos y condiciones.

<hr/>

<a href="https://endomer-py.github.io/endomer/articles/endomer.html">
  <svg width="50%" height="30" xmlns="http://www.w3.org/2000/svg">
  <linearGradient id="a" x2="0" y2="100%">
    <stop offset="0" stop-color="#bbb" stop-opacity="0.2"/>
  <stop offset="1" stop-opacity="0.1"/>
    </linearGradient>
    <rect rx="4" x="0" width="50%" height="30" fill="#555"/>
    <rect rx="4" x="0" width="50%" height="30" fill="#00a65a"/>
    <rect rx="4" width="50%" height="30" fill="url(#a)"/>
    <g fill="#fff" text-anchor="middle" font-size="18">
    <text x="25%" y="21">Guía de inicio rápido</text>
    </g>
    </svg>
    </a>
