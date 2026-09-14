"""Assemble a local delivery only after package, installation and site checks pass."""
from pathlib import Path
import hashlib,json,os,re,shutil,zipfile
root=Path(__file__).resolve().parents[2];pkg=root/'endomer'
out=Path(os.environ.get('ENDOMER_RELEASE_DIR',root/'artifacts/endomer-engih-release')).resolve()
assert out.is_relative_to(root) and out!=root and not out.is_relative_to(pkg)
bundle=out/'bundle'
def read(name):return json.loads((out/name).read_text(encoding='utf-8'))
check=(out/'package/endomer.Rcheck/00check.log').read_text(encoding='utf-8')
assert 'Status: OK' in check and not re.search(r'\b(?:ERROR|WARNING|NOTE)\b',check)
tests=read('r-tests.json');assert all(tests[k]==0 for k in ('failed','warnings','skipped'))
site=read('sites/r/site-check.json');assert site['errors']==[] and site['indexed_guides']==10
assert all(read('bundle-install-audit.json').values())
distribution=read('distribution-audit.json');assert distribution['differences']==[]
for mode in ('binary','source'):assert read(f'integration-{mode}-audit.json')['success']
browser=read('browser-audit.json') if (out/'browser-audit.json').exists() else {'completed':False}
external=(bundle/'external-dependencies.txt').read_text().splitlines()
closure=f'''# Cierre de endomer 0.5.0

Metapaquete R actualizado para ENFT, ENCFT, ENHOGAR y ENGIH. Incluye instalación conjunta de siete paquetes propios, código fuente de mantenimiento, pkgdown bilingüe y evidencias locales. No se ha publicado ni ejecutado CI remoto.

## Alcance

- library(endomer) carga las cuatro interfaces. El catálogo agrega engihr >= 0.3.0 y conserva enftr >= 0.9.0, encftr >= 0.10.0 y enhogar >= 0.5.0.
- Los informes conservan las columnas y estados existentes. ENGIH aparece si está ausente, por debajo del mínimo, fuera del índice consultado o cargada con una versión distinta de la instalada.
- Actualizar el metapaquete no modifica registros de diccionarios del usuario. La guía separa versión del paquete, edición, módulo y revisión; un cambio de una variable de B1 conserva las otras tres definiciones.
- La guía Python refleja endompy 0.8.0 y sus cuatro módulos de encuestas, incluido endompy.engihr. Esta entrega instala paquetes R; la entrega Python 0.8.0 se mantiene separada.
- Los iconos existentes se reutilizan en ambos idiomas; el sitio no consulta CRAN para inventar fechas de publicación. Búsqueda y cambio de idioma funcionan con la ruta donde se sirve el sitio.

## Evidencia local

| Comprobación | Resultado |
|---|---|
| R CMD check, Windows/R 4.5.1, --no-manual --no-multiarch | 0 errores, 0 advertencias, 0 notas |
| Suite | {tests['tests']} grupos, {tests['expectations']} comprobaciones, sin fallos ni omisiones |
| Instalación de siete paquetes desde fuente y desde binarios | Bibliotecas nuevas; rutas reales de los siete namespaces verificadas |
| Suite contra ambas instalaciones | {tests['expectations']} comprobaciones en cada una |
| Guías contra ambas instalaciones | 10 guías ejecutadas por instalación, cinco por idioma |
| Integración de encuestas | ENFT: semestres; ENCFT: divisor anual; ENHOGAR 2022: inactividad; ENGIH: códigos, etiquetas, 25 módulos y revisión de una variable |
| Preflight del instalador | Archivo dañado, dependencia ausente, versión incompatible y biblioteca existente rechazados sin modificar el destino |
| Distribución fuente | {distribution['source_files_verified']} archivos contrastados con el código; cero diferencias |
| pkgdown | {site['pages']} páginas, {site['language_pairs']} pares, {site['local_links_and_assets']} enlaces/recursos locales y {site['verified_search_targets']} destinos de búsqueda válidos |
| Navegador | {'Verificado en el navegador integrado de escritorio; detalles en validation/browser-audit.json' if browser['completed'] else 'Pendiente de revisión manual en este build'} |

Ejemplos sintéticos. Esta certificación corresponde a la integración del metapaquete en Windows/R 4.5.1; no amplía la cobertura de los diccionarios ni certifica estimaciones nacionales u otros sistemas operativos.

## Instalación

packages/r contiene fuente tar.gz y binario Windows ZIP para labeler 0.11.0, Dmisc 0.4.0, enftr 0.9.0, encftr 0.10.0, enhogar 0.5.0, engihr 0.3.0 y endomer 0.5.0, en ese orden.

Desde la carpeta extraída y una sesión R nueva:

```text
Rscript install.R ruta/a/biblioteca-nueva
```

Añada source como segundo argumento para instalar desde fuentes. La biblioteca de destino debe ser nueva o estar vacía. Las {len(external)} dependencias externas enumeradas en external-dependencies.txt deben estar disponibles en las bibliotecas de R. external-constraints.dcf conserva sus restricciones declaradas; las versiones observadas no se convierten en mínimos inventados. El instalador comprueba archivos y requisitos antes de escribir; no descarga dependencias automáticamente. No es un instalador completo para una máquina sin dependencias R.

Después, en una sesión nueva:

```r
.libPaths(c("ruta/a/biblioteca-nueva", .libPaths()))
library(endomer)
endomer_packages()
endomer_deps()[c("package", "required", "local", "status")]
engihr::egi_dict_versions("b1")
```

Desde 0.3.0, el catálogo devuelve cuatro filas. Seleccione por package en vez de posiciones fijas. Use nombres calificados para los objetos dict de enftr, encftr y engihr; egi_dict() selecciona un módulo y una revisión ENGIH explícitos.

## Documentación y reconstrucción

Sirva sites/r por HTTP; en/ contiene inglés. Incluye inicio, informes de versiones, revisiones de diccionarios, instalación/despliegue y relación con Python, más toda la referencia API.

source/endomer contiene scripts y fuentes bilingües. scripts/README.md explica el flujo de reconstrucción; requiere las dependencias declaradas y los artefactos de los paquetes de ENDOM indicados en prepare-bundle.R. Los workflows conservan publicación explícita; las dependencias mínimas deben estar publicadas en sus repositorios antes de ejecutar CI remoto.

SHA256SUMS.json permite comprobar todos los archivos incluidos. packages.dcf registra además sumas MD5 utilizadas para detectar archivos dañados durante la instalación. Las sumas de comprobación no acreditan la autenticidad del remitente.
'''
(out/'CIERRE.md').write_text(closure,encoding='utf-8');shutil.copy2(out/'CIERRE.md',bundle/'CIERRE.md')
shutil.copytree(out/'sites/r',bundle/'sites/r',dirs_exist_ok=True)
shutil.copytree(pkg,bundle/'source/endomer',dirs_exist_ok=True,
 ignore=shutil.ignore_patterns('.git','.Rproj.user','docs','__pycache__','.Rhistory','.RData'))
validation=bundle/'validation';validation.mkdir(exist_ok=True)
for name in ('r-tests.json','test-local.log','bundle-install-audit.json','distribution-audit.json',
 'integration-source-audit.json','integration-binary-audit.json','install-source.log','install-binary.log',
 'corrupt-preflight.log','dependency-preflight.log','version-preflight.log','existing-preflight.log',
 'package/endomer.Rcheck/00check.log','package/binary-install-audit.json','sites/r/site-check.json'):
    shutil.copy2(out/name,validation/Path(name).name)
if browser['completed']:shutil.copy2(out/'browser-audit.json',validation/'browser-audit.json')
for mode in ('binary','source'):
    shutil.copy2(out/f'install-{mode}/install-audit.json',validation/f'installed-{mode}-audit.json')
manifest={p.relative_to(bundle).as_posix():hashlib.sha256(p.read_bytes()).hexdigest()
 for p in sorted(bundle.rglob('*')) if p.is_file() and p.name!='SHA256SUMS.json'}
(bundle/'SHA256SUMS.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
archive=out/'ENDOMER-0.5.0-diccionarios-entrega-completa.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
    for name in [*manifest,'SHA256SUMS.json']:z.write(bundle/name,name)
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    assert set(z.namelist())==set(manifest)|{'SHA256SUMS.json'}
    for name,digest in manifest.items():assert hashlib.sha256(z.read(name)).hexdigest()==digest,name
report={'archive':archive.name,'bytes':archive.stat().st_size,'sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),
 'verified_files':len(manifest),'r_tests':tests,'site':site,'project_packages':7,'external_dependencies':len(external),
 'source_and_binary_verified':True,'browser_verified':browser['completed'],'published':False}
(out/'delivery-audit.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(report,indent=2))
