# Alcance del respaldo técnico

La revisión corresponde al commit `d86a6b6a0836335a0be06f9d2cd37d24383551bc` del repositorio documental. No se atribuye ese mismo commit al origen del código contenido en el ZIP: su correspondencia debe demostrarse.

## Archivos disponibles

- `schema_referencia_no_ejecutar.sql` es una copia idéntica del snapshot original de 33 tablas. Su encabezado advierte que es contextual y no está destinado a ejecutarse. Contiene marcadores `USER-DEFINED`, referencias a secuencias y restricciones que requieren definición y orden correctos.
- `Diagrama_Relacional_referencia.png` es una copia idéntica del diagrama original, coincidente con las 33 tablas del snapshot. El detalle legible por entidad está en el diccionario corregido.
- El [ZIP original](../../Evidencias%20Proyecto/NovaFit-Analytics-Suite.zip) se conserva sin cambios. Incluye un esquema base en `backend/database/schema.sql`, modelos ORM y migraciones. El esquema base no debe confundirse con el snapshot externo ni ejecutarse indiscriminadamente junto a él.
- Los diagramas de `Diagramas/` son documentación funcional/arquitectónica. No constituyen evidencias de prueba ni archivos de ejecución del sistema.

## Restauración: trabajo pendiente

1. Identificar commit/tag de la aplicación y versión del motor PostgreSQL.
2. Inventariar extensiones, enums, secuencias, esquema base y cadena de migraciones. El esquema base del ZIP contiene 30 tablas; las migraciones y el estado actual deben reconciliarse hasta las 32 funcionales más la tabla técnica.
3. Obtener un respaldo autorizado de esquema y datos. Registrar fecha, origen, formato y SHA-256. Excluir credenciales y datos personales de una publicación pública.
4. Restaurar únicamente en una base aislada y vacía, usando el procedimiento elegido para esa versión. No mezclar a ciegas `create_all`, esquema base y migraciones.
5. Verificar cantidad de tablas, restricciones, secuencias, versión Alembic, conteos de filas y escenarios funcionales. Adjuntar logs sin secretos.
6. Documentar el procedimiento probado, tiempo de recuperación y resultado. Hasta entonces, registrar EV-04 como pendiente.

## Hallazgos que requieren intervención en código/configuración

| Ubicación en el ZIP | Acción concreta pendiente |
|---|---|
| `backend/app/integrations/mercadopago/webhook_router.py` | Rechazar eventos con firma/encabezados/identificador requeridos ausentes o inválidos antes de cualquier cambio financiero. Probar consulta al proveedor, importe, moneda, referencia y duplicados concurrentes. |
| `backend/app/analytics/fatigue_service.py` y pruebas | Verificar ventanas, historial parcial, denominador cero, puntaje y límites diarios con fixtures reproducibles. |
| `backend/requirements.txt` | Definir dependencias reproducibles y comprobar instalación limpia. |
| Esquema/modelos y configuración de integración | Confirmar país, moneda y zona horaria. Hay referencias a ARG, ARS y Argentina que requieren reconciliación con la operación chilena. |
| Aplicación móvil / compilación | Adjuntar APK, build EAS, versión y SHA-256; probar dispositivos y conectividad antes de afirmar compatibilidad u operación offline. |

Los originales y el código de la aplicación no se modificaron durante esta corrección documental. Las tareas anteriores se registran en el plan de evidencias y no se dan por implementadas.
