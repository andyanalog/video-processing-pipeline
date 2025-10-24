-- ==========================================
-- VIDEO PROCESSING PIPELINE
-- ==========================================
-- Descripción: Vistas, Funciones, Stored Procedures y Triggers
-- Orden de ejecución: Ejecutar ANTES de insercion_datos.sql
-- ==========================================

USE video_processing_pipeline;

-- ==========================================
-- SECCIÓN 1: VISTAS
-- ==========================================

-- Vista 1: VW_DASHBOARD_TRABAJOS_ACTIVOS
-- Objetivo: Proporcionar una vista consolidada del estado actual de todos los trabajos en procesamiento
DROP VIEW IF EXISTS vw_dashboard_trabajos_activos;

CREATE VIEW vw_dashboard_trabajos_activos AS
SELECT 
    ej.job_id,
    ej.job_status,
    ej.job_priority,
    sf.filename AS archivo_origen,
    sf.duration_seconds AS duracion_video,
    sf.file_size_bytes / 1024 / 1024 AS tamaño_mb,
    ep.profile_name AS perfil_codificacion,
    ep.target_resolution AS resolucion_destino,
    ep.target_codec AS codec_destino,
    pw.worker_name AS worker_asignado,
    pw.worker_status AS estado_worker,
    ej.progress_percentage AS progreso,
    ej.queued_timestamp AS fecha_encolado,
    ej.started_timestamp AS fecha_inicio,
    TIMESTAMPDIFF(MINUTE, ej.started_timestamp, CURRENT_TIMESTAMP) AS minutos_procesando,
    ej.estimated_duration AS duracion_estimada_seg,
    ej.retry_count AS reintentos,
    ej.created_by_user AS usuario_creador,
    c.client_name AS cliente,
    p.project_name AS proyecto
FROM encoding_jobs ej
INNER JOIN source_files sf ON ej.source_file_id = sf.source_file_id
INNER JOIN encoding_profiles ep ON ej.profile_id = ep.profile_id
LEFT JOIN processing_workers pw ON ej.worker_id = pw.worker_id
LEFT JOIN clients c ON sf.client_id = c.client_id
LEFT JOIN projects p ON sf.project_id = p.project_id
WHERE ej.job_status IN ('queued', 'processing')
ORDER BY ej.job_priority DESC, ej.queued_timestamp ASC;


-- Vista 2: VW_METRICAS_CALIDAD_COMPLETAS
-- Objetivo: Consolidar todas las métricas de calidad con información del trabajo y archivo original
DROP VIEW IF EXISTS vw_metricas_calidad_completas;

CREATE VIEW vw_metricas_calidad_completas AS
SELECT 
    qm.metric_id,
    sf.filename AS archivo_original,
    sf.original_codec AS codec_original,
    sf.original_resolution AS resolucion_original,
    sf.original_bitrate AS bitrate_original,
    ep.profile_name AS perfil_usado,
    ep.target_codec AS codec_final,
    ep.target_resolution AS resolucion_final,
    tro.output_filename AS archivo_salida,
    tro.output_size_bytes / 1024 / 1024 AS tamaño_salida_mb,
    tro.actual_bitrate AS bitrate_final,
    tro.compression_ratio AS ratio_compresion,
    tro.encoding_time_seconds AS tiempo_codificacion_seg,
    qm.psnr_value AS psnr,
    qm.ssim_value AS ssim,
    qm.vmaf_score AS vmaf,
    qm.visual_quality_score AS calidad_visual,
    qm.audio_quality_score AS calidad_audio,
    qm.bitrate_efficiency AS eficiencia_bitrate,
    qm.analysis_timestamp AS fecha_analisis,
    c.client_name AS cliente,
    p.project_name AS proyecto,
    CASE 
        WHEN qm.vmaf_score >= 95 THEN 'Excelente'
        WHEN qm.vmaf_score >= 85 THEN 'Muy Buena'
        WHEN qm.vmaf_score >= 70 THEN 'Buena'
        WHEN qm.vmaf_score >= 50 THEN 'Aceptable'
        ELSE 'Baja'
    END AS categoria_calidad
FROM quality_metrics qm
INNER JOIN transcoded_outputs tro ON qm.output_id = tro.output_id
INNER JOIN encoding_jobs ej ON tro.job_id = ej.job_id
INNER JOIN source_files sf ON ej.source_file_id = sf.source_file_id
INNER JOIN encoding_profiles ep ON ej.profile_id = ep.profile_id
LEFT JOIN clients c ON sf.client_id = c.client_id
LEFT JOIN projects p ON sf.project_id = p.project_id
WHERE ej.job_status = 'completed';


-- Vista 3: VW_RENDIMIENTO_WORKERS
-- Objetivo: Analizar el rendimiento y utilización de cada worker en el sistema
DROP VIEW IF EXISTS vw_rendimiento_workers;

CREATE VIEW vw_rendimiento_workers AS
SELECT 
    pw.worker_id,
    pw.worker_name,
    pw.server_hostname,
    pw.worker_type,
    pw.cpu_cores,
    pw.ram_gb,
    pw.gpu_model,
    pw.max_concurrent_jobs AS capacidad_maxima,
    pw.current_load AS carga_actual,
    pw.worker_status AS estado,
    COUNT(DISTINCT ej.job_id) AS total_trabajos_procesados,
    SUM(CASE WHEN ej.job_status = 'completed' THEN 1 ELSE 0 END) AS trabajos_exitosos,
    SUM(CASE WHEN ej.job_status = 'failed' THEN 1 ELSE 0 END) AS trabajos_fallidos,
    ROUND(AVG(CASE WHEN ej.job_status = 'completed' THEN ej.actual_duration END), 2) AS tiempo_promedio_seg,
    ROUND(AVG(CASE WHEN ej.job_status = 'completed' THEN tro.encoding_time_seconds END), 2) AS tiempo_codificacion_promedio,
    ROUND(SUM(CASE WHEN ej.job_status = 'completed' THEN tro.encoding_time_seconds END) / 3600, 2) AS horas_totales_procesamiento,
    ROUND((SUM(CASE WHEN ej.job_status = 'completed' THEN 1 ELSE 0 END) * 100.0) / 
          NULLIF(COUNT(ej.job_id), 0), 2) AS tasa_exito_porcentaje,
    pw.last_heartbeat AS ultimo_heartbeat,
    TIMESTAMPDIFF(MINUTE, pw.last_heartbeat, CURRENT_TIMESTAMP) AS minutos_desde_heartbeat
FROM processing_workers pw
LEFT JOIN encoding_jobs ej ON pw.worker_id = ej.worker_id
LEFT JOIN transcoded_outputs tro ON ej.job_id = tro.job_id
GROUP BY pw.worker_id, pw.worker_name, pw.server_hostname, pw.worker_type, 
         pw.cpu_cores, pw.ram_gb, pw.gpu_model, pw.max_concurrent_jobs, 
         pw.current_load, pw.worker_status, pw.last_heartbeat;


-- Vista 4: VW_HISTORIAL_ERRORES_RECIENTES
-- Objetivo: Monitorear errores recientes para identificar patrones y problemas sistemáticos
DROP VIEW IF EXISTS vw_historial_errores_recientes;

CREATE VIEW vw_historial_errores_recientes AS
SELECT 
    pe.error_id,
    pe.error_code AS codigo_error,
    pe.error_message AS mensaje_error,
    pe.error_timestamp AS fecha_error,
    ej.job_id,
    sf.filename AS archivo_afectado,
    pw.worker_name AS worker_afectado,
    ej.retry_count AS intentos_realizados,
    pe.recovery_action AS accion_recuperacion,
    pe.is_resolved AS resuelto,
    pe.resolved_timestamp AS fecha_resolucion,
    pe.resolved_by AS resuelto_por,
    TIMESTAMPDIFF(HOUR, pe.error_timestamp, 
                  COALESCE(pe.resolved_timestamp, CURRENT_TIMESTAMP)) AS horas_sin_resolver
FROM processing_errors pe
INNER JOIN encoding_jobs ej ON pe.job_id = ej.job_id
INNER JOIN source_files sf ON ej.source_file_id = sf.source_file_id
LEFT JOIN processing_workers pw ON ej.worker_id = pw.worker_id
WHERE pe.error_timestamp >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 30 DAY)
ORDER BY pe.error_timestamp DESC;


-- Vista 5: VW_DASHBOARD_CLIENTES
-- Objetivo: Proporcionar vista consolidada de actividad y uso por cliente
-- Descripción: Combina información de clientes, proyectos, archivos procesados y métricas de uso
DROP VIEW IF EXISTS vw_dashboard_clientes;

CREATE VIEW vw_dashboard_clientes AS
SELECT 
    c.client_id,
    c.client_name AS nombre_cliente,
    c.company_name AS empresa,
    c.subscription_tier AS tipo_suscripcion,
    c.is_active AS activo,
    CONCAT(u.full_name, ' (', u.email, ')') AS account_manager,
    c.monthly_quota_gb AS cuota_mensual_gb,
    c.used_quota_gb AS cuota_usada_gb,
    ROUND((c.used_quota_gb / c.monthly_quota_gb) * 100, 2) AS porcentaje_cuota_usada,
    COUNT(DISTINCT p.project_id) AS total_proyectos,
    COUNT(DISTINCT sf.source_file_id) AS total_archivos_subidos,
    COUNT(DISTINCT ej.job_id) AS total_trabajos_procesados,
    SUM(CASE WHEN ej.job_status = 'completed' THEN 1 ELSE 0 END) AS trabajos_completados,
    SUM(CASE WHEN ej.job_status = 'failed' THEN 1 ELSE 0 END) AS trabajos_fallidos,
    SUM(CASE WHEN ej.job_status IN ('queued', 'processing') THEN 1 ELSE 0 END) AS trabajos_activos,
    ROUND(SUM(sf.file_size_bytes) / 1024 / 1024 / 1024, 2) AS total_gb_almacenados,
    ROUND(AVG(qm.vmaf_score), 2) AS vmaf_promedio,
    MAX(sf.upload_timestamp) AS ultima_subida,
    DATEDIFF(CURRENT_DATE, c.contract_end_date) AS dias_hasta_renovacion,
    CASE 
        WHEN c.used_quota_gb >= c.monthly_quota_gb * 0.9 THEN 'Alerta: Cuota casi agotada'
        WHEN c.used_quota_gb >= c.monthly_quota_gb * 0.75 THEN 'Advertencia: 75% de cuota usada'
        WHEN DATEDIFF(c.contract_end_date, CURRENT_DATE) <= 30 THEN 'Renovación próxima'
        ELSE 'Normal'
    END AS estado_cuenta
FROM clients c
LEFT JOIN users u ON c.account_manager_id = u.user_id
LEFT JOIN projects p ON c.client_id = p.client_id
LEFT JOIN source_files sf ON c.client_id = sf.client_id
LEFT JOIN encoding_jobs ej ON sf.source_file_id = ej.source_file_id
LEFT JOIN transcoded_outputs tro ON ej.job_id = tro.job_id
LEFT JOIN quality_metrics qm ON tro.output_id = qm.output_id
GROUP BY c.client_id, c.client_name, c.company_name, c.subscription_tier, 
         c.is_active, u.full_name, u.email, c.monthly_quota_gb, c.used_quota_gb,
         c.contract_end_date;


-- ==========================================
-- SECCIÓN 2: FUNCIONES
-- ==========================================

-- Función 1: FN_CALCULAR_EFICIENCIA_COMPRESION
DELIMITER //

DROP FUNCTION IF EXISTS fn_calcular_eficiencia_compresion//

CREATE FUNCTION fn_calcular_eficiencia_compresion(p_job_id BIGINT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_tamaño_original BIGINT;
    DECLARE v_tamaño_comprimido BIGINT;
    DECLARE v_eficiencia DECIMAL(5,2);
    
    -- Obtener tamaño del archivo original
    SELECT sf.file_size_bytes INTO v_tamaño_original
    FROM source_files sf
    INNER JOIN encoding_jobs ej ON sf.source_file_id = ej.source_file_id
    WHERE ej.job_id = p_job_id;
    
    -- Obtener tamaño del archivo transcodificado
    SELECT output_size_bytes INTO v_tamaño_comprimido
    FROM transcoded_outputs
    WHERE job_id = p_job_id
    LIMIT 1;
    
    -- Calcular eficiencia de compresión
    IF v_tamaño_original IS NULL OR v_tamaño_comprimido IS NULL OR v_tamaño_original = 0 THEN
        RETURN 0.00;
    END IF;
    
    SET v_eficiencia = ((v_tamaño_original - v_tamaño_comprimido) / v_tamaño_original) * 100;
    
    RETURN v_eficiencia;
END//

DELIMITER ;


-- Función 2: FN_OBTENER_TIEMPO_ESPERA_ESTIMADO
DELIMITER //

DROP FUNCTION IF EXISTS fn_obtener_tiempo_espera_estimado//

CREATE FUNCTION fn_obtener_tiempo_espera_estimado(p_prioridad TINYINT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_trabajos_adelante INT;
    DECLARE v_capacidad_total INT;
    DECLARE v_tiempo_promedio INT;
    DECLARE v_tiempo_espera INT;
    
    -- Contar trabajos en cola con mayor o igual prioridad
    SELECT COUNT(*) INTO v_trabajos_adelante
    FROM encoding_jobs
    WHERE job_status = 'queued' 
    AND job_priority >= p_prioridad;
    
    -- Obtener capacidad total de workers activos
    SELECT COALESCE(SUM(max_concurrent_jobs), 1) INTO v_capacidad_total
    FROM processing_workers
    WHERE worker_status = 'active';
    
    -- Obtener tiempo promedio de procesamiento (últimos 100 trabajos)
    SELECT COALESCE(AVG(actual_duration), 600) INTO v_tiempo_promedio
    FROM encoding_jobs
    WHERE job_status = 'completed'
    AND completed_timestamp >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 7 DAY)
    LIMIT 100;
    
    -- Calcular tiempo de espera estimado
    SET v_tiempo_espera = CEIL((v_trabajos_adelante * v_tiempo_promedio) / (v_capacidad_total * 60));
    
    RETURN v_tiempo_espera;
END//

DELIMITER ;


-- Función 3: FN_VERIFICAR_DISPONIBILIDAD_WORKER
DELIMITER //

DROP FUNCTION IF EXISTS fn_verificar_disponibilidad_worker//

CREATE FUNCTION fn_verificar_disponibilidad_worker(p_worker_id INT)
RETURNS TINYINT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_disponible TINYINT;
    DECLARE v_carga_actual TINYINT;
    DECLARE v_max_jobs TINYINT;
    DECLARE v_estado VARCHAR(20);
    
    -- Obtener información del worker
    SELECT current_load, max_concurrent_jobs, worker_status
    INTO v_carga_actual, v_max_jobs, v_estado
    FROM processing_workers
    WHERE worker_id = p_worker_id;
    
    -- Verificar disponibilidad
    IF v_estado = 'active' AND v_carga_actual < v_max_jobs THEN
        SET v_disponible = 1;
    ELSE
        SET v_disponible = 0;
    END IF;
    
    RETURN v_disponible;
END//

DELIMITER ;


-- ==========================================
-- SECCIÓN 3: STORED PROCEDURES
-- ==========================================

-- Stored Procedure 1: SP_ASIGNAR_TRABAJO_A_WORKER
DELIMITER //

DROP PROCEDURE IF EXISTS sp_asignar_trabajo_a_worker//

CREATE PROCEDURE sp_asignar_trabajo_a_worker(
    IN p_job_id BIGINT
)
BEGIN
    DECLARE v_worker_seleccionado INT;
    DECLARE v_codec_requerido VARCHAR(50);
    DECLARE v_mensaje VARCHAR(255);
    
    -- Obtener el códec requerido para el trabajo
    SELECT ep.target_codec INTO v_codec_requerido
    FROM encoding_jobs ej
    INNER JOIN encoding_profiles ep ON ej.profile_id = ep.profile_id
    WHERE ej.job_id = p_job_id;
    
    -- Seleccionar el mejor worker disponible
    SELECT worker_id INTO v_worker_seleccionado
    FROM processing_workers
    WHERE worker_status = 'active'
    AND current_load < max_concurrent_jobs
    AND (
        supported_codecs IS NULL 
        OR JSON_CONTAINS(supported_codecs, JSON_QUOTE(v_codec_requerido))
    )
    ORDER BY 
        (max_concurrent_jobs - current_load) DESC,
        cpu_cores DESC,
        worker_id ASC
    LIMIT 1;
    
    -- Asignar el trabajo al worker
    IF v_worker_seleccionado IS NOT NULL THEN
        -- Actualizar el trabajo
        UPDATE encoding_jobs
        SET worker_id = v_worker_seleccionado,
            job_status = 'processing',
            started_timestamp = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP
        WHERE job_id = p_job_id;
        
        -- Incrementar la carga del worker
        UPDATE processing_workers
        SET current_load = current_load + 1,
            updated_at = CURRENT_TIMESTAMP
        WHERE worker_id = v_worker_seleccionado;
        
        SET v_mensaje = CONCAT('Trabajo ', p_job_id, ' asignado exitosamente al worker ', v_worker_seleccionado);
        SELECT v_mensaje AS resultado, v_worker_seleccionado AS worker_id;
    ELSE
        SET v_mensaje = CONCAT('No hay workers disponibles para el trabajo ', p_job_id);
        SELECT v_mensaje AS resultado, NULL AS worker_id;
    END IF;
    
END//

DELIMITER ;


-- Stored Procedure 2: SP_REPORTE_RENDIMIENTO_PERIODO
DELIMITER //

DROP PROCEDURE IF EXISTS sp_reporte_rendimiento_periodo//

CREATE PROCEDURE sp_reporte_rendimiento_periodo(
    IN p_fecha_inicio DATETIME,
    IN p_fecha_fin DATETIME
)
BEGIN
    -- Resumen general de trabajos
    SELECT 
        'RESUMEN_TRABAJOS' AS seccion,
        COUNT(*) AS total_trabajos,
        SUM(CASE WHEN job_status = 'completed' THEN 1 ELSE 0 END) AS trabajos_completados,
        SUM(CASE WHEN job_status = 'failed' THEN 1 ELSE 0 END) AS trabajos_fallidos,
        SUM(CASE WHEN job_status = 'cancelled' THEN 1 ELSE 0 END) AS trabajos_cancelados,
        ROUND(AVG(CASE WHEN job_status = 'completed' THEN actual_duration END), 2) AS duracion_promedio_seg,
        ROUND(SUM(CASE WHEN job_status = 'completed' THEN actual_duration END) / 3600, 2) AS horas_totales_procesamiento,
        ROUND((SUM(CASE WHEN job_status = 'completed' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS tasa_exito_porcentaje
    FROM encoding_jobs
    WHERE created_at BETWEEN p_fecha_inicio AND p_fecha_fin;
    
    -- Métricas de calidad promedio
    SELECT 
        'METRICAS_CALIDAD' AS seccion,
        COUNT(*) AS total_analisis,
        ROUND(AVG(vmaf_score), 2) AS vmaf_promedio,
        ROUND(AVG(psnr_value), 2) AS psnr_promedio,
        ROUND(AVG(ssim_value), 4) AS ssim_promedio,
        ROUND(AVG(visual_quality_score), 2) AS calidad_visual_promedio,
        ROUND(AVG(bitrate_efficiency), 4) AS eficiencia_bitrate_promedio
    FROM quality_metrics qm
    INNER JOIN transcoded_outputs tro ON qm.output_id = tro.output_id
    INNER JOIN encoding_jobs ej ON tro.job_id = ej.job_id
    WHERE ej.created_at BETWEEN p_fecha_inicio AND p_fecha_fin
    AND ej.job_status = 'completed';
    
    -- Rendimiento por perfil de codificación
    SELECT 
        'RENDIMIENTO_POR_PERFIL' AS seccion,
        ep.profile_name AS perfil,
        COUNT(*) AS trabajos_procesados,
        ROUND(AVG(tro.encoding_time_seconds), 2) AS tiempo_codificacion_promedio,
        ROUND(AVG(tro.compression_ratio), 4) AS ratio_compresion_promedio,
        ROUND(AVG(qm.vmaf_score), 2) AS vmaf_promedio
    FROM encoding_jobs ej
    INNER JOIN encoding_profiles ep ON ej.profile_id = ep.profile_id
    LEFT JOIN transcoded_outputs tro ON ej.job_id = tro.job_id
    LEFT JOIN quality_metrics qm ON tro.output_id = qm.output_id
    WHERE ej.created_at BETWEEN p_fecha_inicio AND p_fecha_fin
    AND ej.job_status = 'completed'
    GROUP BY ep.profile_id, ep.profile_name
    ORDER BY trabajos_procesados DESC;
    
    -- Top 5 workers más productivos
    SELECT 
        'TOP_WORKERS' AS seccion,
        pw.worker_name,
        COUNT(ej.job_id) AS trabajos_completados,
        ROUND(SUM(tto.encoding_time_seconds) / 3600, 2) AS horas_procesamiento,
        ROUND(AVG(tto.encoding_time_seconds), 2) AS tiempo_promedio_seg
    FROM processing_workers pw
    INNER JOIN encoding_jobs ej ON pw.worker_id = ej.worker_id
    LEFT JOIN transcoded_outputs tto ON ej.job_id = tto.job_id
    WHERE ej.created_at BETWEEN p_fecha_inicio AND p_fecha_fin
    AND ej.job_status = 'completed'
    GROUP BY pw.worker_id, pw.worker_name
    ORDER BY trabajos_completados DESC
    LIMIT 5;
    
END//

DELIMITER ;


-- Stored Procedure 3: SP_REINTENTAR_TRABAJOS_FALLIDOS
DELIMITER //

DROP PROCEDURE IF EXISTS sp_reintentar_trabajos_fallidos//

CREATE PROCEDURE sp_reintentar_trabajos_fallidos(
    IN p_horas_limite INT
)
BEGIN
    DECLARE v_trabajos_reintentados INT DEFAULT 0;
    
    -- Actualizar trabajos fallidos que pueden reintentarse
    UPDATE encoding_jobs
    SET job_status = 'queued',
        worker_id = NULL,
        started_timestamp = NULL,
        retry_count = retry_count + 1,
        progress_percentage = 0.00,
        updated_at = CURRENT_TIMESTAMP
    WHERE job_status = 'failed'
    AND retry_count < max_retries
    AND completed_timestamp >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL p_horas_limite HOUR);
    
    -- Obtener número de trabajos actualizados
    SET v_trabajos_reintentados = ROW_COUNT();
    
    -- Retornar resultado
    SELECT 
        v_trabajos_reintentados AS trabajos_reintentados,
        CONCAT('Se reintentarán ', v_trabajos_reintentados, ' trabajos fallidos') AS mensaje;
        
END//

DELIMITER ;


-- ==========================================
-- SECCIÓN 4: TRIGGERS
-- ==========================================

-- Trigger 1: TRG_VALIDAR_WORKER_ANTES_ASIGNACION
DELIMITER //

DROP TRIGGER IF EXISTS trg_validar_worker_antes_asignacion//

CREATE TRIGGER trg_validar_worker_antes_asignacion
BEFORE UPDATE ON encoding_jobs
FOR EACH ROW
BEGIN
    DECLARE v_worker_status VARCHAR(20);
    DECLARE v_current_load TINYINT;
    DECLARE v_max_jobs TINYINT;
    
    -- Solo validar si se está asignando un worker
    IF NEW.worker_id IS NOT NULL AND (OLD.worker_id IS NULL OR OLD.worker_id != NEW.worker_id) THEN
        
        -- Obtener información del worker
        SELECT worker_status, current_load, max_concurrent_jobs
        INTO v_worker_status, v_current_load, v_max_jobs
        FROM processing_workers
        WHERE worker_id = NEW.worker_id;
        
        -- Validar que el worker esté activo
        IF v_worker_status != 'active' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede asignar: el worker no está activo';
        END IF;
        
        -- Validar que el worker tenga capacidad
        IF v_current_load >= v_max_jobs THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede asignar: el worker ha alcanzado su capacidad máxima';
        END IF;
        
    END IF;
END//

DELIMITER ;


-- Trigger 2: TRG_ACTUALIZAR_CARGA_WORKER_COMPLETADO
DELIMITER //

DROP TRIGGER IF EXISTS trg_actualizar_carga_worker_completado//

CREATE TRIGGER trg_actualizar_carga_worker_completado
AFTER UPDATE ON encoding_jobs
FOR EACH ROW
BEGIN
    -- Si el trabajo pasó de processing a un estado final
    IF OLD.job_status = 'processing' 
       AND NEW.job_status IN ('completed', 'failed', 'cancelled')
       AND NEW.worker_id IS NOT NULL THEN
        
        -- Decrementar la carga del worker
        UPDATE processing_workers
        SET current_load = GREATEST(current_load - 1, 0),
            updated_at = CURRENT_TIMESTAMP
        WHERE worker_id = NEW.worker_id;
        
    END IF;
END//

DELIMITER ;


-- Trigger 3: TRG_REGISTRAR_ERROR_TRABAJO_FALLIDO
DELIMITER //

DROP TRIGGER IF EXISTS trg_registrar_error_trabajo_fallido//

CREATE TRIGGER trg_registrar_error_trabajo_fallido
AFTER UPDATE ON encoding_jobs
FOR EACH ROW
BEGIN
    -- Si el trabajo cambió a estado failed
    IF NEW.job_status = 'failed' AND OLD.job_status != 'failed' THEN
        
        -- Insertar registro de error
        INSERT INTO processing_errors (
            job_id,
            error_code,
            error_message,
            error_timestamp,
            recovery_action,
            is_resolved
        )
        VALUES (
            NEW.job_id,
            'JOB_FAILED',
            COALESCE(NEW.error_message, 'Trabajo marcado como fallido sin mensaje específico'),
            CURRENT_TIMESTAMP,
            CASE 
                WHEN NEW.retry_count < NEW.max_retries THEN 'Reintento automático pendiente'
                ELSE 'Revisar manualmente - límite de reintentos alcanzado'
            END,
            FALSE
        );
        
    END IF;
END//

DELIMITER ;


-- Trigger 4: TRG_VALIDAR_METRICAS_CALIDAD
DELIMITER //

DROP TRIGGER IF EXISTS trg_validar_metricas_calidad//

CREATE TRIGGER trg_validar_metricas_calidad
BEFORE INSERT ON quality_metrics
FOR EACH ROW
BEGIN
    -- Validar PSNR (típicamente entre 20 y 60 dB)
    IF NEW.psnr_value IS NOT NULL AND (NEW.psnr_value < 0 OR NEW.psnr_value > 100) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'PSNR fuera de rango válido (0-100)';
    END IF;
    
    -- Validar SSIM (debe estar entre 0 y 1)
    IF NEW.ssim_value IS NOT NULL AND (NEW.ssim_value < 0 OR NEW.ssim_value > 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SSIM debe estar entre 0 y 1';
    END IF;
    
    -- Validar VMAF (debe estar entre 0 y 100)
    IF NEW.vmaf_score IS NOT NULL AND (NEW.vmaf_score < 0 OR NEW.vmaf_score > 100) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'VMAF debe estar entre 0 y 100';
    END IF;
    
    -- Establecer versión por defecto si no se proporciona
    IF NEW.metric_version IS NULL THEN
        SET NEW.metric_version = '1.0';
    END IF;
END//

DELIMITER ;

-- ==========================================
-- RESUMEN
-- ==========================================

-- Resumen de objetos creados:
-- 5 Vistas (Views)
-- 3 Funciones (Functions)
-- 3 Stored Procedures
-- 4 Triggers