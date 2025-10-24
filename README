# Video Processing Pipeline - Base de Datos

---

## DESCRIPCIÓN DEL PROYECTO

El **Video Processing Pipeline** es un sistema de base de datos diseñado para automatizar y gestionar la transcodificación de archivos multimedia a gran escala. 

El sistema permite:
- Recibir videos en diversos formatos
- Procesarlos según diferentes perfiles de calidad
- Generar múltiples versiones optimizadas para distintos dispositivos y plataformas de streaming
- Gestionar clientes, usuarios, proyectos y cuotas de almacenamiento
- Mantener auditoría completa de todas las operaciones
- Notificar eventos relevantes automáticamente

**Tipo de organización objetivo**: Plataformas de streaming (Netflix, YouTube, HBO Max, Disney+, Amazon Prime Video), productoras de contenido multimedia, agencias de publicidad, estudios de animación.

---

## OBJETIVO

Diseñar e implementar una base de datos relacional que permita:

 **Gestión de clientes y usuarios** - Sistema multiusuario con roles y permisos  
 **Gestión de proyectos** - Organización de archivos por proyectos y clientes  
 **Gestión de archivos fuente** - Almacenar metadatos de videos en múltiples ubicaciones  
 **Control de trabajos de codificación** - Administrar cola de procesamiento con prioridades  
 **Seguimiento de calidad** - Registrar métricas (PSNR, SSIM, VMAF)  
 **Monitoreo de recursos** - Controlar utilización de servidores de procesamiento  
 **Trazabilidad completa** - Desde archivo original hasta versiones finales  
 **Auditoría** - Registro de todas las acciones realizadas  
 **Notificaciones** - Alertas automáticas sobre eventos importantes  

---

## SITUACIÓN PROBLEMÁTICA

### Necesidad del Negocio

Las empresas de streaming y producción multimedia enfrentan desafíos al procesar grandes volúmenes de video:

**Problemas sin sistema estructurado:**
- Pérdida de trazabilidad en el procesamiento
- Duplicación de trabajo por falta de control de estado
- Ineficiencia en asignación de recursos computacionales
- Dificultad para medir calidad y rendimiento
- Falta de visibilidad en tiempos de procesamiento
- Ausencia de control sobre cuotas y facturación
- Imposibilidad de auditar acciones

### Solución Propuesta

La base de datos implementada permite:
- Centralizar información del pipeline de procesamiento
- Automatizar gestión de colas con prioridades
- Proporcionar métricas detalladas de calidad
- Optimizar utilización de recursos
- Gestionar clientes, proyectos y cuotas
- Mantener auditoría completa
- Notificar eventos relevantes automáticamente

---

## MODELO DE NEGOCIO

### Tipos de Usuarios

| Rol | Descripción | Responsabilidades |
|-----|-------------|-------------------|
| **Admin** | Administrador del sistema | Configuración global, gestión de workers, supervisión |
| **Encoder** | Operador de codificación | Crear y gestionar trabajos, configurar perfiles |
| **Analyst** | Analista de calidad | Revisar métricas, generar reportes de rendimiento |
| **Client** | Cliente del servicio | Subir archivos, crear proyectos, monitorear cuota |
| **Viewer** | Usuario de solo lectura | Consultar estado de trabajos y métricas |

### Flujo de Trabajo

```
1. Registro de Cliente → Cliente se registra con suscripción
2. Creación de Proyecto → Cliente crea proyectos para organizar archivos
3. Ingesta → Archivos se cargan y analizan automáticamente
4. Encolado → Se crean trabajos de codificación según perfiles
5. Asignación → Sistema asigna trabajos a workers disponibles
6. Procesamiento → Workers procesan videos usando FFmpeg
7. Análisis → Se calculan métricas de calidad (PSNR, SSIM, VMAF)
8. Notificación → Usuarios reciben alertas sobre trabajos
9. Distribución → Archivos procesados listos para distribución
10. Auditoría → Todas las acciones registradas
```

### Modelo de Suscripción

| Tier | Cuota Mensual | Características |
|------|---------------|-----------------|
| **Basic** | 100-500 GB | Productoras pequeñas e independientes |
| **Professional** | 500-2000 GB | Empresas medianas con necesidades regulares |
| **Enterprise** | 3000-5000 GB | Grandes plataformas de streaming |


---

## LISTADO DE TABLAS

### Resumen General

El sistema cuenta con **15 tablas** que cumplen todos los requisitos:

| # | Tabla | Tipo | Registros | Descripción |
|---|-------|------|-----------|-------------|
| 1 | users | Dimensión | 10 | Usuarios del sistema |
| 2 | clients | Dimensión | 6 | Clientes/Empresas |
| 3 | projects | Dimensión | 8 | Proyectos de video |
| 4 | storage_locations | Dimensión | 6 | Ubicaciones de almacenamiento |
| 5 | source_files | **Transaccional** | 15 | Archivos de video originales |
| 6 | encoding_profiles | Dimensión | 12 | Perfiles de codificación |
| 7 | processing_workers | Dimensión | 10 | Servidores de procesamiento |
| 8 | encoding_jobs | **Transaccional** | 18 | Trabajos de codificación |
| 9 | transcoded_outputs | Dimensión | 11 | Archivos transcodificados |
| 10 | quality_metrics | **Hechos** | 11 | Métricas de calidad |
| 11 | ffmpeg_commands | Dimensión | 11 | Comandos FFmpeg ejecutados |
| 12 | processing_errors | Dimensión | 3 | Errores de procesamiento |
| 13 | codec_performance | **Hechos** | 25 | Benchmarks de rendimiento |
| 14 | audit_logs | Transaccional | 12 | Registro de auditoría |
| 15 | notifications | Transaccional | 14 | Notificaciones a usuarios |

### Descripción Detallada de Tablas

#### 🔹 TABLA 1: USERS
**Propósito:** Gestiona los usuarios que interactúan con el sistema.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| user_id | INT (PK) | Identificador único |
| username | VARCHAR(100) UNIQUE | Nombre de usuario |
| email | VARCHAR(255) UNIQUE | Correo electrónico |
| full_name | VARCHAR(255) | Nombre completo |
| password_hash | VARCHAR(255) | Contraseña encriptada |
| user_role | ENUM | Rol: admin, encoder, analyst, client, viewer |
| is_active | BOOLEAN | Usuario activo |
| last_login | TIMESTAMP | Último inicio de sesión |
| created_at, updated_at | TIMESTAMP | Fechas de auditoría |

---

#### 🔹 TABLA 2: CLIENTS
**Propósito:** Administra empresas/organizaciones que usan el servicio.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| client_id | INT (PK) | Identificador único |
| client_name | VARCHAR(255) | Nombre del cliente |
| company_name | VARCHAR(255) | Nombre de la empresa |
| subscription_tier | ENUM | Tipo: basic, professional, enterprise |
| monthly_quota_gb | INT | Cuota mensual en GB |
| used_quota_gb | DECIMAL(10,2) | Cuota utilizada |
| account_manager_id | INT (FK→users) | Account manager asignado |
| contract_start_date | DATE | Inicio de contrato |
| contract_end_date | DATE | Fin de contrato |
| is_active | BOOLEAN | Cliente activo |

---

#### 🔹 TABLA 3: PROJECTS
**Propósito:** Agrupa archivos de video organizados por cliente.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| project_id | INT (PK) | Identificador único |
| project_name | VARCHAR(255) | Nombre del proyecto |
| project_code | VARCHAR(50) UNIQUE | Código único del proyecto |
| client_id | INT (FK→clients) | Cliente propietario |
| project_status | ENUM | Estado: active, on_hold, completed, cancelled |
| priority_level | TINYINT | Prioridad (1-10) |
| budget_allocated | DECIMAL(12,2) | Presupuesto asignado |
| budget_spent | DECIMAL(12,2) | Presupuesto gastado |
| created_by_user_id | INT (FK→users) | Usuario creador |

---

#### 🔹 TABLA 4: STORAGE_LOCATIONS
**Propósito:** Gestiona ubicaciones de almacenamiento (cloud y local).

| Campo | Tipo | Descripción |
|-------|------|-------------|
| location_id | INT (PK) | Identificador único |
| location_name | VARCHAR(100) UNIQUE | Nombre de ubicación |
| location_type | ENUM | Tipo: local, s3, azure, gcp, nas |
| base_path | VARCHAR(500) | Ruta base |
| total_capacity_gb | BIGINT | Capacidad total |
| used_capacity_gb | DECIMAL(12,2) | Capacidad usada |
| is_default | BOOLEAN | Ubicación por defecto |

---

#### 🔹 TABLA 5: SOURCE_FILES ⭐ TRANSACCIONAL
**Propósito:** Almacena información de archivos de video originales.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| source_file_id | BIGINT (PK) | Identificador único |
| filename | VARCHAR(255) | Nombre del archivo |
| file_path | VARCHAR(500) UNIQUE | Ruta del archivo |
| file_size_bytes | BIGINT | Tamaño en bytes |
| duration_seconds | DECIMAL(10,3) | Duración del video |
| checksum_md5 | CHAR(32) UNIQUE | Hash MD5 |
| original_codec | VARCHAR(50) | Códec original |
| original_resolution | VARCHAR(20) | Resolución original |
| original_bitrate | BIGINT | Bitrate original |
| **client_id** | **INT (FK→clients)** | **Cliente propietario** |
| **project_id** | **INT (FK→projects)** | **Proyecto asociado** |
| **uploaded_by_user_id** | **INT (FK→users)** | **Usuario que subió** |
| **storage_location_id** | **INT (FK→storage_locations)** | **Ubicación almacenamiento** |

---

#### 🔹 TABLA 6: ENCODING_PROFILES
**Propósito:** Define perfiles de codificación disponibles.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| profile_id | INT (PK) | Identificador único |
| profile_name | VARCHAR(100) UNIQUE | Nombre del perfil |
| target_codec | VARCHAR(50) | Códec destino |
| target_resolution | VARCHAR(20) | Resolución objetivo |
| target_bitrate | BIGINT | Bitrate objetivo |
| quality_setting | DECIMAL(4,2) | Configuración calidad (CRF) |
| ffmpeg_preset | VARCHAR(20) | Preset FFmpeg |
| is_active | BOOLEAN | Perfil activo |

---

#### 🔹 TABLA 7: PROCESSING_WORKERS
**Propósito:** Servidores disponibles para procesamiento de video.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| worker_id | INT (PK) | Identificador único |
| worker_name | VARCHAR(100) UNIQUE | Nombre del worker |
| cpu_cores | TINYINT | Núcleos CPU |
| ram_gb | SMALLINT | Memoria RAM en GB |
| gpu_model | VARCHAR(100) | Modelo de GPU |
| max_concurrent_jobs | TINYINT | Máximo trabajos concurrentes |
| current_load | TINYINT | Carga actual |
| worker_status | ENUM | Estado: active, maintenance, offline |
| worker_type | ENUM | Tipo: cpu, gpu, hybrid |
| supported_codecs | JSON | Códecs soportados |

**Constraint:** `current_load <= max_concurrent_jobs`

---

#### 🔹 TABLA 8: ENCODING_JOBS ⭐ TRANSACCIONAL
**Propósito:** Tabla central que gestiona trabajos de codificación.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| job_id | BIGINT (PK) | Identificador único |
| source_file_id | BIGINT (FK→source_files) | Archivo fuente |
| profile_id | INT (FK→encoding_profiles) | Perfil de codificación |
| worker_id | INT (FK→processing_workers) | Worker asignado |
| job_priority | TINYINT | Prioridad (1-10) |
| job_status | ENUM | Estado: queued, processing, completed, failed, cancelled |
| queued_timestamp | TIMESTAMP | Momento encolado |
| started_timestamp | TIMESTAMP | Momento inicio |
| completed_timestamp | TIMESTAMP | Momento finalización |
| actual_duration | INT | Duración real (segundos) |
| retry_count | TINYINT | Número de reintentos |
| progress_percentage | DECIMAL(5,2) | Porcentaje progreso |
| **created_by_user_id** | **INT (FK→users)** | **Usuario creador** |

**Constraint:** `retry_count <= max_retries`

---

#### 🔹 TABLA 9: TRANSCODED_OUTPUTS
**Propósito:** Archivos generados tras la codificación.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| output_id | BIGINT (PK) | Identificador único |
| job_id | BIGINT (FK→encoding_jobs) | Trabajo asociado |
| output_filename | VARCHAR(255) | Nombre archivo generado |
| output_path | VARCHAR(500) UNIQUE | Ruta del archivo |
| output_size_bytes | BIGINT | Tamaño en bytes |
| actual_bitrate | BIGINT | Bitrate real alcanzado |
| encoding_time_seconds | INT | Tiempo de codificación |
| compression_ratio | DECIMAL(8,4) | Ratio de compresión |
| output_checksum | CHAR(32) UNIQUE | Hash MD5 del output |

---

#### 🔹 TABLA 10: QUALITY_METRICS ⭐ TABLA DE HECHOS
**Propósito:** Métricas de calidad calculadas para cada video.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| metric_id | BIGINT (PK) | Identificador único |
| output_id | BIGINT (FK→transcoded_outputs) | Salida asociada |
| psnr_value | DECIMAL(6,3) | PSNR - Peak Signal-to-Noise Ratio |
| ssim_value | DECIMAL(6,4) | SSIM - Structural Similarity Index (0-1) |
| vmaf_score | DECIMAL(6,3) | VMAF - Video Multimethod Assessment (0-100) |
| visual_quality_score | DECIMAL(5,2) | Calidad visual (0-10) |
| audio_quality_score | DECIMAL(5,2) | Calidad audio (0-10) |
| analysis_timestamp | TIMESTAMP | Momento del análisis |

**Notas sobre métricas:**
- **PSNR**: Valores típicos 30-50 dB (mayor es mejor)
- **SSIM**: 0-1, donde 1 es idéntico al original
- **VMAF**: 0-100, métrica desarrollada por Netflix

---

#### 🔹 TABLA 11: FFMPEG_COMMANDS
**Propósito:** Comandos FFmpeg ejecutados para cada trabajo.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| command_id | BIGINT (PK) | Identificador único |
| job_id | BIGINT (FK→encoding_jobs) UNIQUE | Trabajo asociado |
| full_command_string | TEXT | Comando completo ejecutado |
| input_filters | JSON | Filtros de entrada |
| video_filters | JSON | Filtros de video |
| hardware_acceleration | VARCHAR(50) | Aceleración hardware usada |

---

#### 🔹 TABLA 12: PROCESSING_ERRORS
**Propósito:** Registro de errores durante procesamiento.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| error_id | BIGINT (PK) | Identificador único |
| job_id | BIGINT (FK→encoding_jobs) | Trabajo afectado |
| error_code | VARCHAR(50) | Código de error |
| error_message | TEXT | Mensaje de error |
| error_timestamp | TIMESTAMP | Momento del error |
| recovery_action | VARCHAR(100) | Acción de recuperación |
| is_resolved | BOOLEAN | Error resuelto |

---

#### 🔹 TABLA 13: CODEC_PERFORMANCE ⭐ TABLA DE HECHOS
**Propósito:** Métricas de rendimiento de códecs en workers.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| performance_id | BIGINT (PK) | Identificador único |
| codec_name | VARCHAR(50) | Nombre del códec |
| worker_id | INT (FK→processing_workers) | Worker ejecutor |
| encoding_speed_fps | DECIMAL(8,3) | Velocidad codificación (FPS) |
| cpu_utilization | DECIMAL(5,2) | Utilización CPU (%) |
| gpu_utilization | DECIMAL(5,2) | Utilización GPU (%) |
| benchmark_date | TIMESTAMP | Fecha del benchmark |

---

#### 🔹 TABLA 14: AUDIT_LOGS ⭐ TRANSACCIONAL
**Propósito:** Trazabilidad completa de acciones en el sistema.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| log_id | BIGINT (PK) | Identificador único |
| user_id | INT (FK→users) | Usuario que realizó acción |
| action_type | ENUM | Tipo: create, update, delete, login, upload, etc. |
| table_name | VARCHAR(100) | Tabla afectada |
| record_id | BIGINT | ID del registro afectado |
| old_values | JSON | Valores anteriores |
| new_values | JSON | Valores nuevos |
| ip_address | VARCHAR(45) | Dirección IP |
| action_timestamp | TIMESTAMP | Momento de la acción |

---

#### 🔹 TABLA 15: NOTIFICATIONS ⭐ TRANSACCIONAL
**Propósito:** Sistema de notificaciones para eventos relevantes.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| notification_id | BIGINT (PK) | Identificador único |
| user_id | INT (FK→users) | Usuario destinatario |
| notification_type | ENUM | Tipo: job_completed, job_failed, quota_warning, etc. |
| title | VARCHAR(255) | Título notificación |
| message | TEXT | Mensaje completo |
| related_job_id | BIGINT (FK→encoding_jobs) | Trabajo relacionado |
| priority | ENUM | Prioridad: low, medium, high, critical |
| is_read | BOOLEAN | Notificación leída |
| notification_timestamp | TIMESTAMP | Momento de creación |

---

## OBJETOS DE BASE DE DATOS

### Resumen de Objetos Creados

| Tipo | Cantidad |
|------|----------|
| **Vistas** | 5 |
| **Funciones** | 3 |
| **Stored Procedures** | 3 |
| **Triggers** | 4 |

---

### VISTAS (VIEWS)

#### VISTA 1: VW_DASHBOARD_TRABAJOS_ACTIVOS
**Objetivo:** Vista consolidada de trabajos en procesamiento para monitoreo en tiempo real.

**Tablas involucradas:** encoding_jobs, source_files, encoding_profiles, processing_workers, clients, projects

**Campos principales:**
- Estado del trabajo y progreso
- Información del archivo origen
- Perfil de codificación aplicado
- Worker asignado
- Cliente y proyecto asociados

**Ejemplo de uso:**
```sql
SELECT * FROM vw_dashboard_trabajos_activos;
SELECT * FROM vw_dashboard_trabajos_activos WHERE cliente = 'Netflix Originals';
```

---

#### VISTA 2: VW_METRICAS_CALIDAD_COMPLETAS
**Objetivo:** Consolidar métricas de calidad con información contextual para análisis comparativo.

**Tablas involucradas:** quality_metrics, transcoded_outputs, encoding_jobs, source_files, encoding_profiles, clients, projects

**Campos principales:**
- Métricas PSNR, SSIM, VMAF
- Comparación original vs transcodificado
- Ratio de compresión y eficiencia
- **Categoría de calidad automática:**
  - VMAF ≥ 95: **Excelente**
  - VMAF ≥ 85: **Muy Buena**
  - VMAF ≥ 70: **Buena**
  - VMAF ≥ 50: **Aceptable**
  - VMAF < 50: **Baja**

**Ejemplo de uso:**
```sql
SELECT * FROM vw_metricas_calidad_completas WHERE categoria_calidad = 'Excelente';
```

---

#### VISTA 3: VW_RENDIMIENTO_WORKERS
**Objetivo:** Analizar rendimiento y utilización de cada worker.

**Tablas involucradas:** processing_workers, encoding_jobs, transcoded_outputs

**Campos principales:**
- Especificaciones del worker (CPU, RAM, GPU)
- Total trabajos procesados
- Tasa de éxito/fallo
- Tiempos promedio de codificación
- Estado de disponibilidad

**Ejemplo de uso:**
```sql
SELECT * FROM vw_rendimiento_workers ORDER BY tasa_exito_porcentaje DESC;
```

---

#### VISTA 4: VW_HISTORIAL_ERRORES_RECIENTES
**Objetivo:** Monitorear errores recientes para identificar patrones.

**Tablas involucradas:** processing_errors, encoding_jobs, source_files, processing_workers

**Descripción:** Muestra errores de los últimos 30 días con información contextual.

**Ejemplo de uso:**
```sql
SELECT * FROM vw_historial_errores_recientes WHERE resuelto = FALSE;
```

---

#### VISTA 5: VW_DASHBOARD_CLIENTES ⭐ NUEVA
**Objetivo:** Vista consolidada de actividad y uso por cliente para gestión de cuentas.

**Tablas involucradas:** clients, users, projects, source_files, encoding_jobs, transcoded_outputs, quality_metrics

**Campos principales:**
- Información del cliente y suscripción
- Account manager asignado
- Control de cuota mensual (GB usados vs disponibles)
- Estadísticas de proyectos y archivos
- Trabajos procesados (completados, fallidos, activos)
- Métricas de calidad promedio
- **Estado de cuenta con alertas automáticas:**
  - `"Alerta: Cuota casi agotada"` (≥90% usado)
  - `"Advertencia: 75% de cuota usada"` (≥75% usado)
  - `"Renovación próxima"` (≤30 días para vencimiento)
  - `"Normal"` (sin alertas)

**Ejemplo de uso:**
```sql
SELECT * FROM vw_dashboard_clientes WHERE estado_cuenta LIKE '%Alerta%';
SELECT nombre_cliente, porcentaje_cuota_usada, trabajos_completados 
FROM vw_dashboard_clientes 
ORDER BY porcentaje_cuota_usada DESC;
```

---

### FUNCIONES (FUNCTIONS)

#### FUNCIÓN 1: FN_CALCULAR_EFICIENCIA_COMPRESION
**Retorna:** DECIMAL(5,2) - Porcentaje de reducción de tamaño

**Parámetro:** `p_job_id` (BIGINT)

**Descripción:** Calcula el porcentaje de reducción de tamaño tras la compresión.

**Fórmula:** `((tamaño_original - tamaño_comprimido) / tamaño_original) * 100`

**Ejemplo:**
```sql
SELECT job_id, fn_calcular_eficiencia_compresion(job_id) AS eficiencia_porcentaje
FROM encoding_jobs WHERE job_status = 'completed' LIMIT 10;
```

---

#### FUNCIÓN 2: FN_OBTENER_TIEMPO_ESPERA_ESTIMADO
**Retorna:** INT - Minutos estimados de espera

**Parámetro:** `p_prioridad` (TINYINT 1-10)

**Descripción:** Estima tiempo de espera para trabajos en cola según prioridad.

**Lógica:**
1. Cuenta trabajos en cola con prioridad >= especificada
2. Obtiene capacidad total de workers activos
3. Calcula tiempo promedio (últimos 7 días)
4. Estima: `(trabajos_adelante * tiempo_promedio) / (capacidad_total * 60)`

**Ejemplo:**
```sql
SELECT fn_obtener_tiempo_espera_estimado(8) AS minutos_espera_prioridad_8;
```

---

#### FUNCIÓN 3: FN_VERIFICAR_DISPONIBILIDAD_WORKER
**Retorna:** TINYINT - 1 (disponible) o 0 (no disponible)

**Parámetro:** `p_worker_id` (INT)

**Descripción:** Verifica si un worker está disponible para nuevos trabajos.

**Criterios:** Estado='active' AND carga_actual < max_jobs

**Ejemplo:**
```sql
SELECT worker_id, worker_name, fn_verificar_disponibilidad_worker(worker_id) AS disponible
FROM processing_workers;
```

---

### STORED PROCEDURES

#### PROCEDIMIENTO 1: SP_ASIGNAR_TRABAJO_A_WORKER
**Parámetro:** `p_job_id` (BIGINT)

**Objetivo:** Asignar automáticamente un trabajo al worker más apropiado.

**Criterios de selección:**
1. Estado activo
2. Capacidad disponible
3. Soporte del códec requerido
4. Mayor capacidad disponible
5. Mayor número de CPU cores

**Tablas afectadas:**
- encoding_jobs (UPDATE)
- processing_workers (UPDATE - incrementa current_load)

**Ejemplo:**
```sql
CALL sp_asignar_trabajo_a_worker(13);
-- Salida: "Trabajo 13 asignado exitosamente al worker 5"
```

---

#### PROCEDIMIENTO 2: SP_REPORTE_RENDIMIENTO_PERIODO
**Parámetros:** `p_fecha_inicio` (DATETIME), `p_fecha_fin` (DATETIME)

**Objetivo:** Generar reporte completo de rendimiento del sistema.

**Retorna 4 conjuntos de resultados:**
1. **RESUMEN_TRABAJOS** - Total, completados, fallidos, tasa de éxito
2. **METRICAS_CALIDAD** - Promedios de VMAF, PSNR, SSIM
3. **RENDIMIENTO_POR_PERFIL** - Estadísticas por perfil de codificación
4. **TOP_WORKERS** - Top 5 workers más productivos

**Ejemplo:**
```sql
CALL sp_reporte_rendimiento_periodo('2025-01-01 00:00:00', '2025-10-17 23:59:59');
```

---

#### PROCEDIMIENTO 3: SP_REINTENTAR_TRABAJOS_FALLIDOS
**Parámetro:** `p_horas_limite` (INT)

**Objetivo:** Reintentar automáticamente trabajos fallidos elegibles.

**Acciones:**
- Cambia status a 'queued'
- Limpia worker_id
- Incrementa retry_count
- Resetea progress_percentage a 0
- Solo procesa si retry_count < max_retries

**Ejemplo:**
```sql
CALL sp_reintentar_trabajos_fallidos(48);
-- Salida: "Se reintentarán 2 trabajos fallidos"
```

---

### TRIGGERS

#### TRIGGER 1: TRG_VALIDAR_WORKER_ANTES_ASIGNACION
**Tipo:** BEFORE UPDATE  
**Tabla:** encoding_jobs

**Objetivo:** Validar que el worker asignado esté activo y tenga capacidad.

**Validaciones:**
- Worker tiene estado 'active'
- Worker tiene capacidad (current_load < max_concurrent_jobs)

**Acción:** Genera error (SQLSTATE '45000') si falla validación.

---

#### TRIGGER 2: TRG_ACTUALIZAR_CARGA_WORKER_COMPLETADO
**Tipo:** AFTER UPDATE  
**Tabla:** encoding_jobs

**Objetivo:** Decrementar carga del worker cuando trabajo finaliza.

**Condición:** Trabajo pasa de 'processing' a estado final (completed, failed, cancelled)

**Acción:** Decrementa current_load del worker en 1.

---

#### TRIGGER 3: TRG_REGISTRAR_ERROR_TRABAJO_FALLIDO
**Tipo:** AFTER UPDATE  
**Tabla:** encoding_jobs

**Objetivo:** Registrar automáticamente error cuando trabajo falla.

**Acción:** Crea registro en processing_errors con:
- error_code, error_message
- recovery_action según retry_count
- is_resolved = FALSE

---

#### TRIGGER 4: TRG_VALIDAR_METRICAS_CALIDAD
**Tipo:** BEFORE INSERT  
**Tabla:** quality_metrics

**Objetivo:** Validar métricas dentro de rangos válidos.

**Validaciones:**
- PSNR: 0-100
- SSIM: 0-1
- VMAF: 0-100

**Acción:** Genera error si valores fuera de rango.

---

## SCRIPTS DE INSTALACIÓN

### Orden de Ejecución

Los scripts deben ejecutarse en el siguiente orden:

```
1. 01_video_processing_pipeline.sql
   ✓ Crea la base de datos
   ✓ Crea las 15 tablas en orden correcto
   ✓ Crea índices de optimización

2. 02_vistas_funciones_sp_triggers.sql
   ✓ Crea 5 vistas
   ✓ Crea 3 funciones
   ✓ Crea 3 stored procedures
   ✓ Crea 4 triggers

3. 03_insercion_datos.sql
   ✓ Inserta datos de prueba en las 15 tablas
   ✓ Incluye consultas de verificación
   ✓ Incluye ejemplos de uso
```
---

## HERRAMIENTAS Y TECNOLOGÍAS

### Base de Datos
- **MySQL 8.0+** - Sistema de gestión de base de datos relacional
- **MySQL Workbench** - Herramienta visual para diseño y administración

### Características Utilizadas
- **Foreign Keys** - Integridad referencial entre tablas
- **Constraints** - CHECK, UNIQUE para validación
- **Indexes** - Optimización de consultas
- **JSON** - Almacenamiento de metadatos flexibles
- **ENUM** - Tipos de datos enumerados
- **Triggers** - Automatización de reglas de negocio
- **Stored Procedures** - Lógica de negocio en servidor
- **Views** - Vistas para reporting

### Herramientas Externas Integradas
- **FFmpeg** - Motor de transcodificación de video
- **VMAF** - Métrica de calidad de video (Netflix)
- **AWS S3, Azure Blob, Google Cloud Storage** - Almacenamiento cloud

### Glosario de Términos Técnicos

**Términos de Video:**
- **Bitrate:** Cantidad de datos por unidad de tiempo (bits/segundo)
- **Codec:** Algoritmo de compresión/descompresión (H.264, H.265, VP9)
- **CRF:** Constant Rate Factor - calidad constante
- **FFmpeg:** Suite de software para manipulación multimedia
- **FPS:** Frames Per Second - cuadros por segundo
- **Transcodificación:** Convertir video de un formato a otro

**Métricas de Calidad:**
- **PSNR:** Peak Signal-to-Noise Ratio (30-50 dB típico)
- **SSIM:** Structural Similarity Index (0-1, 1=idéntico)
- **VMAF:** Video Multimethod Assessment Fusion (0-100, Netflix)

---

## CASOS DE USO

### Caso 1: Netflix Sube Nuevo Contenido
1. Usuario Netflix inicia sesión (client role)
2. Crea proyecto "Stranger Things Season 6"
3. Sube archivo 4K original (15 GB)
4. Sistema registra en source_files con client_id=1
5. Crea 5 trabajos de codificación (4K, Full HD, HD, SD, Mobile)
6. SP_ASIGNAR_TRABAJO_A_WORKER asigna a workers
7. Workers procesan archivos
8. Sistema calcula métricas VMAF, PSNR, SSIM
9. Notificaciones enviadas cuando completa
10. Audit log registra todas las acciones

### Caso 2: Cliente Excede Cuota
1. Cliente procesa archivos regularmente
2. Sistema actualiza used_quota_gb
3. VW_DASHBOARD_CLIENTES detecta 91% usado
4. Estado_cuenta = "Alerta: Cuota casi agotada"
5. Notificación automática a cliente y account manager
6. Cliente actualiza plan de 'professional' a 'enterprise'
7. monthly_quota_gb incrementa de 2000 GB a 4000 GB

### Caso 3: Trabajo Falla y Se Reintenta
1. Trabajo #25 falla con "MEMORY_ERROR"
2. TRG_REGISTRAR_ERROR_TRABAJO_FALLIDO crea registro
3. Notificación enviada al encoder
4. Admin ejecuta SP_REINTENTAR_TRABAJOS_FALLIDOS(24)
5. Trabajo se reencola (retry_count = 1)
6. Worker con más memoria procesa exitosamente
7. Error marcado como resolved