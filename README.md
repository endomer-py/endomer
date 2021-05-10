
<!-- README.md is generated from README.Rmd. Please edit that file -->

# endomer <img src='man/figures/logo.png' align="right" height="138" />

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/endomer/endomer/workflows/R-CMD-check/badge.svg)](https://github.com/endomer/endomer/actions)
[![Codecov test
coverage](https://codecov.io/gh/endomer/endomer/branch/main/graph/badge.svg)](https://codecov.io/gh/endomer/endomer?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/endomer)](https://CRAN.R-project.org/package=endomer)
<!-- badges: end -->

El objetivo de este paquete es el de proveer funciones comunes a todos
los paquetes del econsistema endomer.

## Instalación

`endomer` no está disponible en CRAN.

`endomer` se instala cuando instalas otro de los paquetes del
ecosistema.

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
remotes::install_github("endomer/endomer")
```

## Roadmap

1.  Escribir tests
2.  Escribir la Guía de inicio rápido
3.  Escribir viñeta de etiquetas de datos

## Contribuye

Tienes comentarios o quieres contribuir?

Por favor, revisa las [gias de contribución (en
inglés)](https://endomer.github.io/endomer/CONTRIBUTING.html) antes de
iniciar un issue o pull request.

Por favor, observa que el proyecto endomer está sujeto a un [Código del
contribuyente](https://contributor-covenant.org/es/version/2/0/CODE_OF_CONDUCT.html).
Contribuyendo con el proyecto aceptas las términos y condiciones.

<hr/>
<a href="./articles/endomer.html"><button type="button"
style = "
    border: 1px solid transparent;
    background-color: #00a65a;
    display: block;
    padding: 10px 16px;
    font-size: 18px;
    line-height: 1.3333333;
    color: #fff;
    cursor: pointer;
    margin-left: 35%;
    margin-top: 10px;
    font-weight: 900;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;">
    Guía de inicio rápido</button></a>
