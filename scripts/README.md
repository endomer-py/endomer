# Construcción local de endomer 0.5.0

Ejecute desde el workspace ENDOM que contiene los siete proyectos y sus artefactos verificados. `prepare-bundle.R` enumera las ubicaciones exactas de las seis dependencias propias. Las dependencias externas de R, las herramientas de documentación y Python con Beautiful Soup deben estar instaladas.

```powershell
./endomer/scripts/release.ps1 -OutputDirectory artifacts/mi-nuevo-build `
  -Rscript 'C:/Program Files/R/R-4.5.1/bin/Rscript.exe' `
  -Python ruta/a/python.exe
```

El destino debe ser nuevo, dentro del workspace y fuera del código del paquete. `-AssetCache ruta/a/sites/cache` permite reutilizar los recursos de pkgdown de una construcción anterior si no hay conexión. Los iconos se incluyen en el proyecto; las fechas de publicación en CRAN están desactivadas porque este metapaquete se distribuye desde sus repositorios.

El flujo genera ayudas, ejecuta pruebas, construye y comprueba el paquete, crea el binario Windows, prepara siete paquetes, instala fuente y binarios en bibliotecas nuevas, ejecuta pruebas y diez guías contra ambas instalaciones, construye y audita ambos sitios, verifica la distribución y comprueba la instalación desde el ZIP final extraído. Conserva los logs y se detiene ante el primer fallo. La construcción del binario requiere Windows.

La revisión visual se realiza en el navegador después del flujo automático. El informe no afirma haber revisado el navegador si no existe evidencia de esa revisión para el build. Ningún script publica, sube archivos ni instala en las bibliotecas globales. Los workflows de CI verifican el paquete en otras plataformas cuando se ejecutan; su configuración no constituye evidencia de haberlos ejecutado.

`prepare-release.py` es un punto de entrada histórico que ahora remite a este flujo; ya no copia scripts de otra encuesta sobre los mantenidos aquí.
