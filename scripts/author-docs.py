"""Author paired guides and English API help for endomer's three public functions."""
from pathlib import Path
root=Path(__file__).resolve().parents[1]
def write(p,s):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s.strip()+'\n',encoding='utf-8')
guides={
'endomer':('Inicio: las cuatro encuestas','Start: the four surveys',
'''`endomer 0.5.0` reúne **enftr >= 0.9.0**, **encftr >= 0.10.0**, **enhogar >= 0.5.0** y **engihr >= 0.3.0**. Al instalarlo, R exige esas dependencias; `library(endomer)` carga las cuatro interfaces. El paquete no modifica sus cálculos ni combina cuestionarios.

## Paquetes incluidos

| Paquete | Encuesta y alcance |
|---|---|
| enftr | ENFT tradicional; contratos semestrales y pobreza histórica 2005–2016 |
| encftr | ENCFT continua; indicadores e ICV SIUBEN histórico integrado |
| enhogar | ENHOGAR 2018 y 2022; indicadores y diccionarios por edición |
| engihr | ENGIH 2018; 25 módulos con cobertura de diccionario documentada |

Este metapaquete incluye esas cuatro encuestas. labeler y Dmisc se incorporan como dependencias de sus interfaces; no se adjuntan todos los proyectos del directorio ENDOM. Cada encuesta conserva sus límites metodológicos y cobertura de diccionario.

## Un recorrido verificable

Los ejemplos siguientes son inventados. Separan períodos de ENFT, calculan un factor de un extracto ENCFT con divisor explícito y calculan inactividad ENHOGAR 2022. No producen estimaciones nacionales. Use nombres de paquete cuando haya nombres compartidos: `enftr::dict`, `encftr::dict` y `engihr::dict` son objetos distintos. Para ENGIH seleccione el módulo y la revisión con `engihr::egi_dict()`. La documentación por encuesta explica la preparación y sus reglas.''',
'''`endomer 0.5.0` brings together **enftr >= 0.9.0**, **encftr >= 0.10.0**, **enhogar >= 0.5.0** and **engihr >= 0.3.0**. R requires those dependencies when installing the package; `library(endomer)` attaches the four interfaces. The metapackage does not change their calculations or combine questionnaires.

## Included packages

| Package | Survey and scope |
|---|---|
| enftr | Traditional ENFT; semester contracts and historical poverty for 2005–2016 |
| encftr | Continuous ENCFT; indicators and integrated historical SIUBEN ICV |
| enhogar | ENHOGAR 2018 and 2022; indicators and edition-specific dictionaries |
| engihr | ENGIH 2018; 25 modules with documented dictionary coverage |

The metapackage covers these four surveys. labeler and Dmisc are dependencies of their interfaces; it does not attach every project in the ENDOM directory. Each survey retains its methodological limits and dictionary coverage.

## A verifiable workflow

The examples below are invented. They separate ENFT periods, calculate an ENCFT extract weight with an explicit divisor, and calculate ENHOGAR 2022 inactivity. They do not produce national estimates. Use qualified names for shared objects: `enftr::dict`, `encftr::dict` and `engihr::dict` are different dictionaries. For ENGIH, select the module and revision with `engihr::egi_dict()`. Each survey guide explains its preparation and rules.'''),
'versiones':('Versiones, estados y procedencia','Versions, states and provenance',
'''## Consulta sin red

`endomer_packages()` devuelve el catálogo de las cuatro encuestas y sus mínimos. `endomer_deps()` inspecciona las bibliotecas de `.libPaths()` y compara con ese catálogo. No requiere que endomer o sus encuestas estén en CRAN. `endomer_update()` devuelve el mismo informe y muestra las acciones recomendadas; **no instala ni solicita confirmaciones**. Use `quiet=TRUE` para obtenerlo sin mensajes.

Cumplir el mínimo incluido no significa tener la última versión publicada. El informe identifica el origen de comparación en `source`: bundled_minimum, supplied_index o repository_index. `local` es la versión instalada según el orden de bibliotecas; `loaded` es la versión cargada en la sesión. Si difieren, `restart_required=TRUE` evita confundir código nuevo en disco con código ya cargado.

## Estados y acciones

| Estado | Interpretación | Acción habitual |
|---|---|---|
| meets_minimum | Cumple el mínimo del catálogo incluido | none |
| current | Coincide con el objetivo del índice indicado | none |
| newer_than_target | La instalación es posterior al objetivo | none; no propone degradar |
| below_minimum | La instalación no cumple el mínimo | update o resolve_source |
| update_available | El índice ofrece una versión posterior compatible | update |
| not_installed | No aparece en las bibliotecas inspeccionadas | install o resolve_source |
| unavailable | El índice no ofrece ese paquete | resolve_source |
| repository_below_minimum | El índice ofrece una versión inferior al mínimo | resolve_source |
| installed_unchecked | Dependencia transitiva instalada sin objetivo verificable | inspect |

`behind` es NA cuando el objetivo es desconocido. `required` y `meets_requirement` solo evalúan los mínimos de las cuatro encuestas. `target_compatible` indica si el objetivo cumple ese mínimo. La columna histórica `cran` se conserva como alias del objetivo del índice; puede proceder de otro repositorio y queda NA al comparar con el catálogo incluido.

## Índices explícitos y recursión

Puede pasar `available` como matriz/data.frame con Package y Version para una comparación reproducible. `repos` consulta un índice fuente de un repositorio R, incluido uno local; **no consulta GitHub**. Son alternativas: no se aceptan juntas. Un error de consulta o un índice remoto vacío detiene la operación, y los paquetes ausentes no se presentan como actualizados.

`recursive=TRUE` recorre Depends, Imports y LinkingTo usando el índice suministrado y metadatos instalados. Excluye R, paquetes base y Suggests. Evita ciclos y duplicados. Es un inventario: no sustituye la resolución completa de restricciones del instalador R. No se inventan versiones objetivo para dependencias sin evidencia.''',
'''## Offline inspection

`endomer_packages()` returns the four-survey catalog and minimum versions. `endomer_deps()` inspects `.libPaths()` libraries and compares against that catalog. Neither endomer nor its surveys need to appear on CRAN. `endomer_update()` returns the same report and displays recommended actions; **it does not install or request confirmation**. Use `quiet=TRUE` to omit messages.

Meeting a bundled minimum does not mean having the latest published version. The report identifies the comparison source in `source`: bundled_minimum, supplied_index or repository_index. `local` is the installed version according to library precedence; `loaded` is the version loaded in the session. A difference sets `restart_required=TRUE`, distinguishing new code on disk from code already in memory.

## States and actions

| State | Meaning | Typical action |
|---|---|---|
| meets_minimum | Meets the bundled catalog minimum | none |
| current | Matches the supplied index target | none |
| newer_than_target | Installation is newer than the target | none; no downgrade suggested |
| below_minimum | Installation fails the minimum | update or resolve_source |
| update_available | Index offers a newer compatible version | update |
| not_installed | Absent from the inspected libraries | install or resolve_source |
| unavailable | Index does not offer the package | resolve_source |
| repository_below_minimum | Index offers a version below the minimum | resolve_source |
| installed_unchecked | Installed transitive dependency without a verified target | inspect |

`behind` is NA when the target is unknown. `required` and `meets_requirement` evaluate only the four survey minimums. `target_compatible` states whether a target satisfies that minimum. The historical `cran` column remains an alias of the index target; that index may come from another repository, and the field is NA for bundled-catalog comparisons.

## Explicit indexes and recursion

Pass `available` as a matrix/data.frame with Package and Version for a reproducible comparison. `repos` reads a source index from an R repository, including a local one; **it does not query GitHub**. These arguments are alternatives and cannot be combined. Failed requests or an empty remote index stop the operation; missing packages are never reported as current.

`recursive=TRUE` follows Depends, Imports and LinkingTo using the supplied index and installed metadata. It excludes R, base packages and Suggests, and handles cycles and duplicates. This is an inventory, not a replacement for the R installer's full dependency constraint resolution. Dependencies without evidence receive no invented target version.'''),
'deployment':('Instalación y despliegue','Installation and deployment',
'''## Instalar la entrega

La entrega contiene fuentes y binarios Windows de endomer 0.5.0, enftr 0.9.0, encftr 0.10.0, enhogar 0.5.0, engihr 0.3.0, labeler 0.11.0 y Dmisc 0.4.0. Las otras dependencias declaradas deben estar instaladas. El binario está verificado en Windows/R 4.5.1; otras plataformas deben instalar desde fuente y ejecutar sus comprobaciones.

Desde la carpeta extraída puede ejecutar `Rscript install.R ruta/a/biblioteca`. El instalador comprueba el inventario y las sumas de los siete artefactos antes de instalar, usa únicamente archivos locales y escribe en la biblioteca indicada. La biblioteca debe ser nueva o estar vacía y necesita permisos de escritura. El instalador comprueba también las restricciones de versión declaradas en external-constraints.dcf. Consulte external-dependencies.txt para las dependencias externas; si faltan, el instalador se detiene antes de modificar la biblioteca. No descarga automáticamente dependencias.

La instalación manual sigue este orden: labeler, Dmisc, enftr, encftr, enhogar, engihr y endomer. Use `install.packages(archivo, repos=NULL, type="win.binary")` para ZIP en Windows o `type="source"` para tar.gz. Reinicie R después de actualizar paquetes que ya estaban cargados y añada la biblioteca a `.libPaths()` antes de `library(endomer)`.

## Construcción y publicación

Desde el workspace que contiene endomer, ejecute `Rscript endomer/scripts/check-release.R`. Para el sitio use `Rscript endomer/scripts/build-docs.R` y `python endomer/scripts/check-sites.py artifacts/endomer-engih-release/sites/r --kind r`. Requiere las dependencias del paquete, pkgdown, roxygen2 y Beautiful Soup para la auditoría. pkgdown puede consultar metadatos públicos durante la compilación.

El sitio estático sirve español en la raíz e inglés en en/. Incluye referencia de todas las funciones, búsqueda por idioma y navegación recíproca. El workflow permite construir y publicar solo cuando se activa explícitamente publish. Publique primero las versiones mínimas de las dependencias en sus repositorios; los artefactos de esta entrega ya permiten instalación local. No se ha ejecutado CI ni publicación remota.

## Migración desde 0.3.0

La carga conjunta agrega engihr >= 0.3.0 y el catálogo devuelve cuatro filas. Adapte cualquier código que suponga tres filas; seleccione por package. Use funciones prefijadas egi_ y nombres calificados para diccionarios compartidos.

## Migración desde 0.2.0

La consulta predeterminada pasa a ser sin red. `repos` sigue aceptándose explícitamente y se conservan recursive, package, local, cran y behind. La ausencia de un paquete en un índice queda visible, y se eliminan los mensajes engañosos de estar al día. La función endomer_update entrega un informe utilizable sin imprimir comandos de instalación incompletos. La carga conjunta conserva las cuatro encuestas y evita importar todos sus nombres al namespace del metapaquete.''',
'''## Install the delivery

The delivery includes sources and Windows binaries for endomer 0.5.0, enftr 0.9.0, encftr 0.10.0, enhogar 0.5.0, engihr 0.3.0, labeler 0.11.0 and Dmisc 0.4.0. Other declared dependencies must already be installed. Binaries were verified on Windows/R 4.5.1; other platforms should install from source and run their own checks.

From the extracted folder run `Rscript install.R path/to/library`. The installer verifies the inventory and checksums of all seven artifacts before installation, uses local files only and writes to the specified library. The library must be new or empty and writable. The installer also checks declared version constraints in external-constraints.dcf. See external-dependencies.txt for external dependencies; if any are missing, installation stops before modifying the library. Dependencies are not downloaded automatically.

Manual installation order is labeler, Dmisc, enftr, encftr, enhogar, engihr and endomer. Use `install.packages(file, repos=NULL, type="win.binary")` for Windows ZIP files, or `type="source"` for tar.gz. Restart R after upgrading loaded packages and add the library to `.libPaths()` before `library(endomer)`.

## Build and publish

From the workspace containing endomer, run `Rscript endomer/scripts/check-release.R`. Build the site with `Rscript endomer/scripts/build-docs.R` and audit it with `python endomer/scripts/check-sites.py artifacts/endomer-engih-release/sites/r --kind r`. Package dependencies, pkgdown, roxygen2 and Beautiful Soup for auditing are required. pkgdown may read public metadata while building.

The static site serves Spanish at root and English in en/. It contains complete function reference, language-specific search and reciprocal navigation. The workflow builds and publishes only when its publish input is explicitly enabled. Publish the minimum dependency versions to their repositories before remote CI; this delivery already supports local installation. No remote CI or publication was performed.

## Migration from 0.3.0

Joint attachment adds engihr >= 0.3.0 and the catalog returns four rows. Update code that assumes three rows; select by package instead. Use egi_ functions and qualified names for shared dictionaries.

## Migration from 0.2.0

Default inspection is now offline. Explicit repos is still supported, and recursive, package, local, cran and behind are retained. Packages missing from an index remain visible, and misleading up-to-date messages are removed. endomer_update returns a usable report without printing incomplete installation commands. Joint attachment retains the four surveys while avoiding imports of every survey name into the metapackage namespace.'''),
'python':('Relación con Python','Relationship with Python',
'''`endomer` es el metapaquete de **R**. En Python, el punto de entrada conjunto ya es **endompy 0.8.0**: `endompy.enftr`, `endompy.encftr`, `endompy.enhogar` y `endompy.engihr`. No hace falta otra capa que instale o cargue módulos Python automáticamente.

| R | Python | Alcance del contrato compartido |
|---|---|---|
| enftr 0.9.0 | endompy.enftr | ENFT tradicional |
| encftr 0.10.0 | endompy.encftr | ENCFT e ICV histórico |
| enhogar 0.5.0 | endompy.enhogar | ENHOGAR 2018 y 2022 |
| engihr 0.3.0 | endompy.engihr | Diccionarios ENGIH 2018; 25 módulos |

Esta entrega no cambia endompy ni sus cálculos. endomer_deps y endomer_update inspeccionan bibliotecas R; no se presentan como verificadores de entornos Python. Use las herramientas de instalación de Python para esos entornos. Las revisiones de diccionarios siguen siendo independientes de las versiones de paquetes en ambos lenguajes.''',
'''`endomer` is the **R** metapackage. Python already has a joint entry point in **endompy 0.8.0**: `endompy.enftr`, `endompy.encftr`, `endompy.enhogar` and `endompy.engihr`. It does not need another layer that automatically installs or imports Python modules.

| R | Python | Shared contract scope |
|---|---|---|
| enftr 0.9.0 | endompy.enftr | Traditional ENFT |
| encftr 0.10.0 | endompy.encftr | ENCFT and historical ICV |
| enhogar 0.5.0 | endompy.enhogar | ENHOGAR 2018 and 2022 |
| engihr 0.3.0 | endompy.engihr | ENGIH 2018 dictionaries; 25 modules |

This release does not change endompy or its calculations. endomer_deps and endomer_update inspect R libraries and are not Python environment checkers. Use Python's installation tools for those environments. Dictionary revisions remain independent of package versions in both languages.''')}
examples={
'endomer':'''library(endomer)
endomer_packages()
enftr::ft_peri_vars(data.frame(EFT_PERIODO=c("1/2005","2/2005")))
encftr::ftc_factor_expansion_anual(data.frame(FACTOR_EXPANSION=c(100,200)), periods=4)
enhogar::ehg_inactivo(enhogar::enhogar_example(2022), min_edad=10, edition=2022)[c("case_id","pet","inactivo")]
engih <- engihr::egi_example()
labelled <- engihr::egi_set_labels(engih, version="baseline-1")
stopifnot(identical(as.numeric(labelled$A201), engih$A201))
engihr::egi_validate(labelled)
engihr::egi_dict_versions("b1")[c("dictionary_id","version")]''',
'versiones':'''library(endomer)
endomer_deps()[c("package","required","local","status")]
index <- data.frame(Package=c("enftr","encftr"), Version=c("0.9.0","0.10.0"))
report <- endomer_deps(available=index)
report[c("package","target","behind","status","action")]
stopifnot(is.na(report$behind[report$package=="enhogar"]))
plan <- endomer_update(quiet=TRUE)'''}
guides['diccionarios']=('Paquetes, ediciones y revisiones','Packages, editions and revisions',
'La versión de endomer fija requisitos de instalación; la de engihr identifica su código. La edición ENGIH es 2018 y `baseline-1` identifica una revisión inmutable de un módulo. Son selecciones distintas: actualizar endomer no cambia los diccionarios registrados por el usuario.\n\nPara reproducir un análisis registre paquete, edición, módulo, revisión y huella de contenido. `endomer_deps()` inspecciona paquetes R; `engihr::egi_dict_versions()` inspecciona revisiones. Los selectores de fecha requieren vigencias documentadas; no se infieren del año de la encuesta.\n\nEl ejemplo usa B1, con cuatro definiciones. Cambia una etiqueta en SQLite en memoria y comprueba que las otras tres referencias permanecen idénticas. El registro sigue siendo propiedad del usuario. Los 25 módulos incluidos tienen cobertura desigual: consulte `egi_schema()` y `egi_validate()` antes de aplicar etiquetas.\n\nEl registro interoperable conserva revisiones entre labeler en R y labelerpy en Python. La entrega de endompy 0.8.0 contiene la validación de ida y vuelta; el metapaquete no administra entornos Python.\n\n',
'The endomer version sets installation requirements; the engihr version identifies its code. ENGIH edition 2018 and immutable module revision `baseline-1` are separate selections. Upgrading endomer does not change user-registered dictionaries.\n\nRecord the package, edition, module, revision and content hash to reproduce an analysis. `endomer_deps()` inspects R packages; `engihr::egi_dict_versions()` inspects revisions. Date selectors require documented validity intervals; the survey year does not establish them.\n\nThis example uses B1, with four definitions. It changes one label in an in-memory SQLite registry and checks that the other three references remain identical. The connection belongs to the caller. The 25 bundled modules have different coverage: inspect `egi_schema()` and `egi_validate()` before applying labels.\n\nThe interoperable registry preserves revisions between R labeler and Python labelerpy. The endompy 0.8.0 delivery includes round-trip validation; this metapackage does not manage Python environments.\n\n')
examples['diccionarios']="""library(endomer)
if (requireNamespace("RSQLite", quietly=TRUE)) local({
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  on.exit(DBI::dbDisconnect(con))
  original <- engihr::egi_dict("b1", version="baseline-1")
  labeler::db_import_dict_version(con, original)
  draft <- labeler::dict_draft(original)
  draft$FREC_COMPRA_ALIMENTOS$label <- "Frecuencia revisada / Revised frequency"
  revised <- engihr::egi_register_dict(con, draft, "review-2", module="b1", parent_version="baseline-1")
  before <- labeler::dict_revision(original)$variable_refs
  after <- labeler::dict_revision(revised)$variable_refs
  unchanged <- setdiff(names(before), "FREC_COMPRA_ALIMENTOS")
  stopifnot(length(unchanged)==3L, identical(before[unchanged], after[unchanged]))
  stopifnot(!identical(before$FREC_COMPRA_ALIMENTOS, after$FREC_COMPRA_ALIMENTOS))
  print(engihr::egi_dict_versions("b1", con=con)[c("version","parent_version")])
})"""

for _key in ('endomer', 'diccionarios'):
    _guide = guides[_key]
    guides[_key] = (*_guide[:2], _guide[2] + '\n\n' + 'ENHOGAR 2022 añade cinco módulos completos ONE REDATAM y una revisión combinada coverage-2 de 603 definiciones. ENGIH 2018 ofrece coverage-2 en 25 módulos, con 1700 descripciones de 1702 campos. La procedencia distingue diccionario oficial, cuestionarios y encabezados; HOLGURA y PERDIDA_TURISMO permanecen sin definición. baseline-1 se conserva en ambas encuestas.', _guide[3] + '\n\n' + 'ENHOGAR 2022 adds five complete ONE REDATAM modules and a combined coverage-2 revision with 603 definitions. ENGIH 2018 offers coverage-2 across 25 modules, with 1700 descriptions of 1702 fields. Provenance distinguishes official dictionary entries, questionnaires and headers; HOLGURA and PERDIDA_TURISMO remain undefined. Both surveys preserve baseline-1.')

for en in (False,True):
    base=root/'pkgdown/i18n/en' if en else root
    for key,t in guides.items():
        title=t[1] if en else t[0];body=t[3] if en else t[2]
        if key in examples:body+='\n\n```{r}\n'+examples[key]+'\n```'
        header=f'---\ntitle: "{title}"\noutput: rmarkdown::html_vignette\nvignette: >\n  %\\VignetteIndexEntry{{{title}}}\n  %\\VignetteEngine{{knitr::rmarkdown}}\n  %\\VignetteEncoding{{UTF-8}}\n---\n\n'
        write(base/f'vignettes/{key}.Rmd',header+body)
    write(base/'README.md','# endomer 0.5.0\n\n'+guides['endomer'][3 if en else 2]+'\n\n'+('[Start](articles/endomer.html) · [Version reports](articles/versiones.html) · [Install and deploy](articles/deployment.html) · [Python](articles/python.html) · [Dictionary revisions / Revisiones](articles/diccionarios.html).' if en else '[Inicio](articles/endomer.html) · [Informes de versiones](articles/versiones.html) · [Instalación y despliegue](articles/deployment.html) · [Python](articles/python.html) · [Dictionary revisions / Revisiones](articles/diccionarios.html).'))
    write(base/'_pkgdown.yml',f'''url: https://endomer-py.github.io/endomer/{'en/' if en else ''}
lang: {'en' if en else 'es'}
news:
  cran_dates: false
home:
  sidebar: false
template:
  bootstrap: 5
  bootswatch: flatly
navbar:
  structure:
    left: [intro, reference, articles, news]
    right: [search, github]
  components:
    intro:
      text: {'Home' if en else 'Inicio'}
      href: index.html
articles:
  - title: {'Guides' if en else 'Guías'}
    navbar: ~
    contents: [endomer, versiones, diccionarios, deployment, python]
''')
    if en:
        write(base/'CODE_OF_CONDUCT.md',(root/'CODE_OF_CONDUCT.md').read_text(encoding='utf-8'))
write(root/'README.Rmd','---\noutput: github_document\n---\n\n'+(root/'README.md').read_text(encoding='utf-8'))
print('Five paired guides and package narratives generated')
