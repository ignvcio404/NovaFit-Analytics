# Registro priorizado de correcciones

Fecha: 29-10-2026. Base: commit `d86a6b6a0836335a0be06f9d2cd37d24383551bc`. Se revisaron los **19 archivos de Fase 2**, incluyendo el contenido del ZIP, y se contrastaron con Acta, ERS, Gantt y requisitos de Fase 1.

**Estado documental corregido** significa que la afirmación fue ajustada en la copia. No significa que se haya ejecutado una prueba, subsanado el software o aprobado el cambio. Todas las rutas siguientes son relativas a `Fase 2/correcciones/`.

| Prioridad | Inconsistencia o falta | Archivo / sección corregida | Corrección aplicada y condición restante |
|---|---|---|---|
| P1 | 35/34/25 tablas frente al snapshot real | `Evidencias Grupales/Diccionario_Datos_corregido.docx`, catálogo completo; `DAS_corregido_v2.2.docx`, §5; PPT, diap. 9 | 32 tablas funcionales + Alembic = 33. Se incluyen los 346 campos y 51 FK del snapshot. Verificar producción por separado. |
| P1 | Entidades y atributos que no corresponden al SQL | Diccionario, `users`, `user_roles`, `memberships`, `invoices`, `transactions`; PPT, diap. 10 | UUID, relación de roles, `user_id`, componentes de `total` y `gateway_reference`. Se elimina la presentación de tablas inexistentes como `acwr_records` o `device_tokens`. |
| P1 | 16/16 pruebas y 100% de aprobación sin respaldo por caso | Guías 2.4/2.6, calidad y evidencias; `Cierre_Fase2_corregido.docx`, §3; PPT, diap. 14 | Se identifica la declaración histórica como no acreditada. `Gestion/Plan_Pruebas_y_Evidencias.xlsx`, `Plan QA!A5:J21`, contiene 16 casos propuestos, todos pendientes. Recuperar el plan original y ejecutar resultados. |
| P1 | ACWR como RPE × volumen o suma crónica sin normalización | DAS, §4; Procesos, §4; PPT, diap. 7; plan QA, QA-12 a QA-14 | Se documenta peso × repeticiones, exclusión de calentamiento, ventanas 7/28, normalización semanal, historial insuficiente y denominador cero. RPE se usa por separado en el puntaje. |
| P1 | Verificación de firma presentada como obligatoria | DAS, §4 y §8; Procesos, §2; PPT, diap. 6; QA-05 a QA-08 | Se señala la rama actual que continúa sin firma completa. **Pendiente en software**: rechazar autenticación incompleta/inválida y demostrar efecto único bajo reintentos y concurrencia. |
| P1 | Ruta errónea del webhook | Procesos, §2; DAS, §4 | Endpoint documentado: `/api/v1/webhooks/mercadopago`. |
| P1 | SQL contextual presentado como respaldo ejecutable | `Evidencias Proyecto/LEEME_Respaldo_Tecnico.md`; DAS, §5.1 y §8 | La copia se llama `schema_referencia_no_ejecutar.sql`. Faltan tipos/secuencias y una restauración demostrada. ZIP y migraciones no equivalen a respaldo de datos. |
| P1 | APK sin archivo, build ni correspondencia con fuente | Plan de evidencias, EV-01/EV-02; guías, evidencias; PPT, diap. 14 | Se requiere APK/AAB, build EAS, versión, firma, SHA-256 y commit de origen. No se certifica Android 8+ sin paquete y prueba de compatibilidad. |
| P1 | Hosting $15.000/año y servicios $285.000 sin base consistente | `Gestion/Flujo_de_Caja_NovaFit.xlsx`, `Supuestos!B5:B12`, `Flujo de caja!A27:H28`; PPT, diap. 15 | Se utiliza Acta: cloud $45.000/mes, cuentas $120.000/año y desarrollo $12.500.000. Los cuatro meses son supuesto explícito para conciliar $12.800.000. Cotizaciones pendientes. |
| P1 | Falta de flujo de caja y condiciones de soporte | Excel, hojas `Flujo de caja`, `Supuestos`, `Alcance y beneficios`; `Alcance_y_Flujo_de_Caja.docx`, §1–6; PPT, diap. 16–18 | Se incorpora flujo mensual editable, caja negra, alcance, beneficios, exclusiones, tarifa mensual única y déficit de financiación. Precio de soporte y calendario son hipótesis pendientes de acuerdo. |
| P1 | Porcentajes de mejora, eficacia y tiempos sin mediciones | Procesos, §5; guías, resultados; cierre, §3; reflexiones; PPT, diap. 12 y 19 | Se retiran como logros 80%, 92%, 95%, −65%, 99,9%, <100 ms y mejora de GIF. Se distinguen metas del Acta y plan de medición. Sin eficacia clínica acreditada. |
| P2 | SC-02/03/04 reasignados a decisiones distintas; 10 cambios reportados | `Matriz_Control_Cambios_corregida.xlsx`, `Hoja1!A3:L8`, `Notas!A5:A7`; guías y cierre | Se conservan SC-01 web/móvil, SC-02 Gantt, SC-03 honorarios y SC-04 roles. SC-05 Zoho y SC-06 ACWR son propuestas de regularización del 29-10, sin retroaprobar. |
| P2 | «Aceptado» inferido por incorporación documental | Matriz de cambios, `L3:L8`; minutas, fe de erratas | Se diferencia incorporación, propuesta y ratificación pendiente. No se crea aprobación del docente ni del PM. |
| P2 | 12 riesgos mitigados sin evidencia de cierre | `Matriz_Riesgos_corregida.xlsx`, `MATRIZ!J3:L15`; PPT, diap. 14 | Estado de verificación, evidencia requerida y riesgo residual. Se aclara ausencia de prueba de offline-first y fijación incompleta de dependencias Python. Se agrega Seguridad al diccionario. |
| P2 | Filas RACI sin A y actividades desactualizadas | `Matriz_RACI_corregida.xlsx`, B8, B11, B13, B30, B35, B37, C37:C39, fila 40 y nota 42 | Se propone A/R para PM en gestión, actualiza conteos y nombres. RACI no demuestra ejecución. Ratificar asignaciones. |
| P2 | Stack y versiones discordantes; repetición en la PPT | DAS, §6; PPT, diap. 11 | React web 19.2.8, Recharts 3.10.1, React Native 0.81.5 y Expo 54.0.37 según lockfiles. Stack concentrado en una diapositiva. PostgreSQL desplegado por verificar. |
| P2 | C4/microservicios frente a estructura modular 4+1 | DAS, §1, §6 y anexo; guía 2.6, metodología/desarrollo | Se describe una API modular en tres capas y vistas 4+1. Diagrama editable en `Diagramas/Diagramas_Fase2.drawio`. |
| P2 | Fechas, cinco semanas y fases mezcladas | Cierre, §1/§5; guías, metodología; PPT, diap. 13 | Ciclo 07-09 a 11-10, cierre reportado 12-10, edición retrospectiva 29-10. Se distinguen 3 fases académicas y 5 etapas económicas del ERS. Hitos del Acta por reconciliar con Gantt. |
| P2 | Minutas históricas con referencias erróneas y cierre APT-02 duplicado | `Minutas_con_fe_de_erratas.docx`, primera sección; `Cierre_Fase2_corregido.docx`, identificación | Se preserva la transcripción histórica y se antepone aclaración vigente. El cierre se referencia como CIERRE-F2-01, indicando el identificador original. |
| P2 | Pautas genéricas, identidad incompleta, respuesta 6 dentro de 5 y omisión de QA | `Evidencias individuales/`, cinco pautas; Felipe, preguntas 5 y 6 | Identificación, referencias por rol y separación de las respuestas. Se incorpora QA a la propuesta de tareas. Aportes personales y conformidad deben verificarse por cada autor. |
| P2 | País/moneda/zona operativa no reconciliados | DAS, §8; plan de evidencias EV-11; respaldo técnico | Se documentan referencias ARG/ARS/Argentina encontradas. **Pendiente técnico**: confirmar la configuración para operación en Chile y comprobarla en pruebas. |
| P3 | Fuentes con sufijo `(3)`, sección errónea, sigla ACER y documentación poco navegable | PPT y documentos reconstruidos; README y guion | Referencias a archivos reales, ACWR correcto y fuentes en notas. Se añaden diagramas y presentación editable. |

## Cobertura de los originales

| Archivo original | Copia o tratamiento |
|---|---|
| Guía 2.4 Desarrollo | `Evidencias Grupales/2.4_Desarrollo_Proyecto_APT_corregido.docx` |
| Guía 2.6 Informe Final | `Evidencias Grupales/2.6_Informe_Final_APT_corregido.docx` |
| DAS | `Evidencias Grupales/DAS_corregido_v2.2.docx` |
| Diccionario de Datos | `Evidencias Grupales/Diccionario_Datos_corregido.docx` |
| Documento Proceso Negocio | `Evidencias Grupales/Procesos_Negocio_corregido.docx` y diagramas |
| Documento de avance de sprint | `Evidencias Grupales/Cierre_Fase2_corregido.docx` |
| Matriz Control de Cambio | `Evidencias Grupales/Matriz_Control_Cambios_corregida.xlsx` |
| Matriz de Riesgo | `Evidencias Grupales/Matriz_Riesgos_corregida.xlsx` |
| Matriz RACI | `Evidencias Grupales/Matriz_RACI_corregida.xlsx` |
| Minuta de reunión Portafolio | `Evidencias Grupales/Minutas_con_fe_de_erratas.docx` |
| Diagrama Relacional.png | Copia idéntica `Evidencias Proyecto/Diagrama_Relacional_referencia.png` |
| Presentación PDF | PPTX editable y PDF corregidos en `Evidencias Proyecto/` |
| NovaFit-Analytics-Suite.zip | Revisión estática; original preservado, sin modificar el software |
| schema.sql | Copia idéntica `Evidencias Proyecto/schema_referencia_no_ejecutar.sql` |
| Pauta Antonio | `Evidencias individuales/Antonio_Reflexion_Fase2_corregida.docx` |
| Pauta Felipe | `Evidencias individuales/Felipe_Reflexion_Fase2_corregida.docx` |
| Pauta Yulian | `Evidencias individuales/Yulian_Reflexion_Fase2_corregida.docx` |
| Pauta Steven | `Evidencias individuales/Steven_Reflexion_Fase2_corregida.docx` |
| Pauta Vicente | `Evidencias individuales/Vicente_Reflexion_Fase2_corregida.docx` |

## Alcance de la verificación realizada

Se contrastaron texto, esquema, código y planillas. Se verificaron los cálculos del escenario financiero, la estructura de los archivos y su presentación visual. No se ejecutó el sistema contra producción, no se efectuaron pagos, no se instalaron APK inexistentes ni se simuló la aceptación de usuarios. Los pendientes técnicos quedan como condiciones de cierre, no como correcciones ya implementadas.
