# Correcciones de Fase 2 · NovaFit Analytics Suite

Edición documental del **29 de octubre de 2026**, basada en el commit [`d86a6b6`](https://github.com/ignvcio404/NovaFit-Analytics/commit/d86a6b6a0836335a0be06f9d2cd37d24383551bc).

Esta carpeta contiene las versiones revisadas y los nuevos respaldos de gestión. **Los 19 archivos originales de Fase 2 se conservan intactos.** Los documentos corregidos no constituyen una aprobación del docente ni una certificación de pruebas o de operación en producción.

## Archivos principales

- [Presentación editable](Evidencias%20Proyecto/Presentacion_Fase2_corregida.pptx) y [versión PDF](Evidencias%20Proyecto/Presentacion_Fase2_corregida.pdf): 20 diapositivas, stack concentrado en una sola sección, recorridos visuales, costos y flujo de caja.
- [Flujo de caja editable](Gestion/Flujo_de_Caja_NovaFit.xlsx): proyección mensual de 12 meses, fórmulas, gráfico, supuestos y necesidad de financiación.
- [Alcance económico y condiciones de soporte](Gestion/Alcance_y_Flujo_de_Caja.docx): alcance, beneficios, exclusiones y un solo servicio mensual de soporte y mantenimiento.
- [Registro priorizado de correcciones](Gestion/Registro_Correcciones.md): localización exacta de cada ajuste y pendientes de cierre.
- [Plan de pruebas y registro de evidencias](Gestion/Plan_Pruebas_y_Evidencias.xlsx): 16 casos **propuestos y sin ejecutar**, más criterios para recuperar los respaldos faltantes.
- [Guion de defensa](Gestion/Guion_Defensa.md): recorrido y notas para una exposición fluida.

## Documentos revisados

En `Evidencias Grupales/` están las dos guías APT, DAS v2.2, diccionario físico completo, procesos de negocio, cierre de construcción, minutas con fe de erratas y las tres matrices. En `Evidencias individuales/` están las cinco pautas con identificación, aclaraciones de evidencia y correcciones de consistencia; cada autor debe revisar su reflexión antes de presentarla.

El diccionario describe **33 tablas: 32 funcionales y `alembic_version`**, con **346 campos y 51 claves foráneas** del snapshot. Los procesos incorporan diagramas corregidos y una [fuente editable para diagrams.net](Evidencias%20Proyecto/Diagramas/Diagramas_Fase2.drawio).

## Supuestos que requieren acuerdo

El Excel adopta la perspectiva del **proveedor de NovaFit**, en CLP, antes de impuestos y financiación. El precio de desarrollo de $20.480.000 proviene del Acta, pero no acredita un contrato. La distribución de cobros 30%/40%/30%, cuatro meses de construcción y el servicio de soporte de $250.000/mes desde M5 son supuestos ilustrativos, identificados en la hoja `Supuestos`.

Hosting: $45.000/mes, equivalente a $540.000 por 12 meses, según la referencia histórica del Acta. Cuentas de desarrollador: $120.000/año, condicional al canal de distribución. Confirmar cotizaciones y necesidad de cuentas antes de aprobar el presupuesto. El soporte incluye hosting comercialmente; este no se vuelve a cobrar al cliente como un segundo servicio.

En ese escenario: entradas $22.480.000, salidas $13.960.000 y flujo neto $8.520.000 antes de impuestos y financiación. La caja inicial cero produce un déficit de $271.250 en M2. Son proyecciones, no resultados obtenidos ni utilidad contable.

## Condiciones pendientes antes de certificar una entrega

1. Corregir y probar el rechazo de webhooks sin firma o con firma inválida, además de concurrencia e idempotencia.
2. Adjuntar resultados de QA, APK identificado, prueba de restauración, mediciones y aceptación UAT.
3. Confirmar país, moneda, zona horaria, versiones desplegadas y estado de servicios externos.
4. Ratificar cambios, presupuesto, condiciones de soporte y contenidos personales de las reflexiones.

El ZIP original del sistema no se modifica. El SQL y diagrama dentro de esta carpeta son copias de referencia, no un nuevo respaldo restaurable. Véase [LEEME_Respaldo_Tecnico.md](Evidencias%20Proyecto/LEEME_Respaldo_Tecnico.md).

## Protección de los originales

El archivo `Gestion/Originales_SHA256.json` registra la huella de los 19 archivos originales revisados. La publicación añade únicamente rutas bajo `Fase 2/correcciones/`.
