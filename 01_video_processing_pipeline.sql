-- ==========================================
-- VIDEO PROCESSING PIPELINE DATABASE SCHEMA
-- ==========================================
-- Proyecto: Sistema de Procesamiento de Video
-- Descripción: Base de datos para gestión de pipeline de transcodificación
-- ==========================================

-- Crear base de datos
CREATE DATABASE video_processing_pipeline;

USE video_processing_pipeline;

-- ==========================================
-- CREACIÓN DE TABLAS - SECCIÓN 1: GESTIÓN DE USUARIOS
-- ==========================================

-- Tabla: USERS
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_role ENUM('admin', 'encoder', 'analyst', 'client', 'viewer') DEFAULT 'viewer',
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    failed_login_attempts TINYINT DEFAULT 0,
    account_locked BOOLEAN DEFAULT FALSE,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================================
-- CREACIÓN DE TABLAS - SECCIÓN 2: GESTIÓN DE CLIENTES
-- ==========================================

-- Tabla: CLIENTS
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(255) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    industry VARCHAR(100),
    contact_email VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(20),
    billing_address TEXT,
    tax_id VARCHAR(50),
    account_manager_id INT,
    subscription_tier ENUM('basic', 'professional', 'enterprise') DEFAULT 'basic',
    monthly_quota_gb INT DEFAULT 100,
    used_quota_gb DECIMAL(10,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    contract_start_date DATE,
    contract_end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (account_manager_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Tabla: PROJECTS
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(255) NOT NULL,
    project_code VARCHAR(50) NOT NULL UNIQUE,
    client_id INT NOT NULL,
    project_description TEXT,
    project_status ENUM('active', 'on_hold', 'completed', 'cancelled') DEFAULT 'active',
    priority_level TINYINT DEFAULT 5 CHECK (priority_level BETWEEN 1 AND 10),
    budget_allocated DECIMAL(12,2),
    budget_spent DECIMAL(12,2) DEFAULT 0.00,
    start_date DATE,
    expected_end_date DATE,
    actual_end_date DATE NULL,
    created_by_user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- ==========================================
-- CREACIÓN DE TABLAS - SECCIÓN 3: GESTIÓN DE ALMACENAMIENTO
-- ==========================================

-- Tabla: STORAGE_LOCATIONS
CREATE TABLE storage_locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    location_name VARCHAR(100) NOT NULL UNIQUE,
    location_type ENUM('local', 's3', 'azure', 'gcp', 'nas') NOT NULL,
    base_path VARCHAR(500) NOT NULL,
    region VARCHAR(50),
    bucket_name VARCHAR(255),
    access_key_encrypted VARCHAR(500),
    total_capacity_gb BIGINT,
    used_capacity_gb DECIMAL(12,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    is_default BOOLEAN DEFAULT FALSE,
    priority_order TINYINT DEFAULT 1,
    connection_string TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================================
-- CREACIÓN DE TABLAS - SECCIÓN 4: ARCHIVOS FUENTE
-- ==========================================

-- Tabla: SOURCE_FILES
CREATE TABLE source_files (
    source_file_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL UNIQUE,
    file_size_bytes BIGINT NOT NULL CHECK (file_size_bytes > 0),
    duration_seconds DECIMAL(10,3) CHECK (duration_seconds > 0),
    upload_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    checksum_md5 CHAR(32) NOT NULL UNIQUE,
    original_codec VARCHAR(50) NOT NULL,
    original_resolution VARCHAR(20) NOT NULL,
    original_bitrate BIGINT CHECK (original_bitrate > 0),
    original_framerate DECIMAL(5,2) CHECK (original_framerate > 0),
    audio_channels TINYINT CHECK (audio_channels >= 0 AND audio_channels <= 32),
    audio_sample_rate INT CHECK (audio_sample_rate > 0),
    container_format VARCHAR(20) NOT NULL,
    metadata_json JSON,
    --
    client_id INT,
    project_id INT,
    uploaded_by_user_id INT,
    storage_location_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    --
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE SET NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE SET NULL,
    FOREIGN KEY (uploaded_by_user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (storage_location_id) REFERENCES storage_locations(location_id) ON DELETE SET NULL
);

-- ==========================================
-- CREACIÓN DE TABLAS - SECCIÓN 5: AUDITORÍA
-- ==========================================

-- Tabla: AUDIT_LOGS
CREATE TABLE audit_logs (
    log_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action_type ENUM('create', 'update', 'delete', 'login', 'logout', 'upload', 'download', 'assign', 'cancel') NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT,
    action_description TEXT,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_action_timestamp (action_timestamp),
    INDEX idx_user_action (user_id, action_type),
    INDEX idx_table_record (table_name, record_id)
);

-- ==========================================
-- CREACIÓN DE TABLAS - SECCIÓN 6: NOTIFICACIONES
-- ==========================================

-- Tabla: NOTIFICATIONS
CREATE TABLE notifications (
    notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    notification_type ENUM('job_completed', 'job_failed', 'quota_warning', 'system_alert', 'maintenance', 'quality_issue') NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    related_job_id BIGINT,
    related_file_id BIGINT,
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    is_read BOOLEAN DEFAULT FALSE,
    read_timestamp TIMESTAMP NULL,
    notification_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (related_job_id) REFERENCES encoding_jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (related_file_id) REFERENCES source_files(source_file_id) ON DELETE CASCADE,
    INDEX idx_user_unread (user_id, is_read),
    INDEX idx_notification_timestamp (notification_timestamp)
);

-- ==========================================
-- TABLAS ORIGINALES
-- ==========================================

-- Tabla: ENCODING_PROFILES
CREATE TABLE encoding_profiles (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    profile_name VARCHAR(100) NOT NULL UNIQUE,
    target_codec VARCHAR(50) NOT NULL,
    target_resolution VARCHAR(20) NOT NULL,
    target_bitrate BIGINT CHECK (target_bitrate > 0),
    target_framerate DECIMAL(5,2) CHECK (target_framerate > 0),
    audio_codec VARCHAR(50),
    audio_bitrate INT CHECK (audio_bitrate > 0),
    container_format VARCHAR(20) NOT NULL,
    ffmpeg_preset VARCHAR(20),
    quality_setting DECIMAL(4,2),
    profile_description TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla: PROCESSING_WORKERS
CREATE TABLE processing_workers (
    worker_id INT PRIMARY KEY AUTO_INCREMENT,
    worker_name VARCHAR(100) NOT NULL UNIQUE,
    server_hostname VARCHAR(255) NOT NULL,
    cpu_cores TINYINT NOT NULL CHECK (cpu_cores > 0),
    ram_gb SMALLINT NOT NULL CHECK (ram_gb > 0),
    gpu_model VARCHAR(100),
    gpu_memory_gb SMALLINT CHECK (gpu_memory_gb >= 0),
    max_concurrent_jobs TINYINT NOT NULL DEFAULT 1 CHECK (max_concurrent_jobs > 0),
    current_load TINYINT DEFAULT 0 CHECK (current_load >= 0),
    worker_status ENUM('active', 'maintenance', 'offline') DEFAULT 'active',
    supported_codecs JSON,
    last_heartbeat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    worker_type ENUM('cpu', 'gpu', 'hybrid') DEFAULT 'cpu',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_load_limit CHECK (current_load <= max_concurrent_jobs)
);

-- Tabla: ENCODING_JOBS
CREATE TABLE encoding_jobs (
    job_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    source_file_id BIGINT NOT NULL,
    profile_id INT NOT NULL,
    worker_id INT,
    job_priority TINYINT DEFAULT 5 CHECK (job_priority BETWEEN 1 AND 10),
    job_status ENUM('queued', 'processing', 'completed', 'failed', 'cancelled') DEFAULT 'queued',
    queued_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_timestamp TIMESTAMP NULL,
    completed_timestamp TIMESTAMP NULL,
    estimated_duration INT,
    actual_duration INT,
    retry_count TINYINT DEFAULT 0 CHECK (retry_count >= 0),
    max_retries TINYINT DEFAULT 3 CHECK (max_retries >= 0),
    created_by_user VARCHAR(100),
    created_by_user_id INT,
    error_message TEXT,
    progress_percentage DECIMAL(5,2) DEFAULT 0.00 CHECK (progress_percentage BETWEEN 0 AND 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (source_file_id) REFERENCES source_files(source_file_id) ON DELETE CASCADE,
    FOREIGN KEY (profile_id) REFERENCES encoding_profiles(profile_id) ON DELETE RESTRICT,
    FOREIGN KEY (worker_id) REFERENCES processing_workers(worker_id) ON DELETE SET NULL,
    FOREIGN KEY (created_by_user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    
    CONSTRAINT chk_retry_limit CHECK (retry_count <= max_retries)
);

-- Tabla: TRANSCODED_OUTPUTS
CREATE TABLE transcoded_outputs (
    output_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    job_id BIGINT NOT NULL,
    output_filename VARCHAR(255) NOT NULL,
    output_path VARCHAR(500) NOT NULL UNIQUE,
    output_size_bytes BIGINT NOT NULL CHECK (output_size_bytes > 0),
    actual_bitrate BIGINT CHECK (actual_bitrate > 0),
    actual_resolution VARCHAR(20) NOT NULL,
    actual_framerate DECIMAL(5,2) CHECK (actual_framerate > 0),
    encoding_time_seconds INT NOT NULL CHECK (encoding_time_seconds > 0),
    compression_ratio DECIMAL(8,4) CHECK (compression_ratio > 0),
    output_checksum CHAR(32) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (job_id) REFERENCES encoding_jobs(job_id) ON DELETE CASCADE
);

-- Tabla: QUALITY_METRICS
CREATE TABLE quality_metrics (
    metric_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    output_id BIGINT NOT NULL,
    psnr_value DECIMAL(6,3) CHECK (psnr_value >= 0),
    ssim_value DECIMAL(6,4) CHECK (ssim_value BETWEEN 0 AND 1),
    vmaf_score DECIMAL(6,3) CHECK (vmaf_score BETWEEN 0 AND 100),
    bitrate_efficiency DECIMAL(8,4) CHECK (bitrate_efficiency > 0),
    visual_quality_score DECIMAL(5,2) CHECK (visual_quality_score BETWEEN 0 AND 10),
    audio_quality_score DECIMAL(5,2) CHECK (audio_quality_score BETWEEN 0 AND 10),
    analysis_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metric_version VARCHAR(20) DEFAULT '1.0',
    analysis_duration_seconds INT CHECK (analysis_duration_seconds > 0),

    FOREIGN KEY (output_id) REFERENCES transcoded_outputs(output_id) ON DELETE CASCADE
);

-- Tabla: FFMPEG_COMMANDS
CREATE TABLE ffmpeg_commands (
    command_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    job_id BIGINT NOT NULL UNIQUE,
    full_command_string TEXT NOT NULL,
    input_filters JSON,
    video_filters JSON,
    audio_filters JSON,
    output_parameters JSON,
    hardware_acceleration VARCHAR(50),
    thread_count TINYINT CHECK (thread_count > 0),
    memory_usage_mb INT CHECK (memory_usage_mb > 0),
    command_version VARCHAR(20) DEFAULT '1.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (job_id) REFERENCES encoding_jobs(job_id) ON DELETE CASCADE
);

-- Tabla: PROCESSING_ERRORS
CREATE TABLE processing_errors (
    error_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    job_id BIGINT NOT NULL,
    error_code VARCHAR(50) NOT NULL,
    error_message TEXT NOT NULL,
    error_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ffmpeg_output TEXT,
    system_resources_at_error JSON,
    recovery_action VARCHAR(100),
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_timestamp TIMESTAMP NULL,
    resolved_by VARCHAR(100),

    FOREIGN KEY (job_id) REFERENCES encoding_jobs(job_id) ON DELETE CASCADE
);

-- Tabla: CODEC_PERFORMANCE
CREATE TABLE codec_performance (
    performance_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    codec_name VARCHAR(50) NOT NULL,
    worker_id INT NOT NULL,
    input_resolution VARCHAR(20) NOT NULL,
    encoding_speed_fps DECIMAL(8,3) NOT NULL CHECK (encoding_speed_fps > 0),
    cpu_utilization DECIMAL(5,2) CHECK (cpu_utilization BETWEEN 0 AND 100),
    memory_usage_mb INT CHECK (memory_usage_mb > 0),
    gpu_utilization DECIMAL(5,2) CHECK (gpu_utilization BETWEEN 0 AND 100),
    benchmark_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    test_duration_seconds INT NOT NULL CHECK (test_duration_seconds > 0),
    quality_setting DECIMAL(4,2),
    sample_file_type VARCHAR(50),

    FOREIGN KEY (worker_id) REFERENCES processing_workers(worker_id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_benchmark (codec_name, worker_id, input_resolution, quality_setting, sample_file_type)
);

-- ==========================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- ==========================================

-- Índices en source_files
CREATE INDEX idx_source_client ON source_files(client_id);
CREATE INDEX idx_source_project ON source_files(project_id);
CREATE INDEX idx_source_uploaded_by ON source_files(uploaded_by_user_id);
CREATE INDEX idx_source_storage ON source_files(storage_location_id);

-- Índices en encoding_jobs
CREATE INDEX idx_jobs_created_by ON encoding_jobs(created_by_user_id);
CREATE INDEX idx_jobs_status ON encoding_jobs(job_status);

-- Índices en projects
CREATE INDEX idx_project_client ON projects(client_id);
CREATE INDEX idx_project_status ON projects(project_status);

-- Índices en clients
CREATE INDEX idx_client_manager ON clients(account_manager_id);
CREATE INDEX idx_client_active ON clients(is_active);