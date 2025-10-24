-- ==========================================
-- VIDEO PROCESSING PIPELINE - INSERCIÓN DE DATOS
-- ==========================================
-- Descripción: Script para poblar todas las tablas con datos de prueba
-- Orden de ejecución: Ejecutar DESPUÉS de vistas_funciones_sp_triggers.sql
-- ==========================================

USE video_processing_pipeline;

-- ==========================================
-- SECCIÓN 1: USERS
-- ==========================================
INSERT INTO users (
    username, email, full_name, password_hash, user_role, is_active,
    last_login, phone_number
) VALUES
('admin001', 'admin@videopipeline.com', 'Carlos Martínez', 'hash_admin_001', 'admin', TRUE, '2025-10-17 09:00:00', '+1-555-0101'),
('encoder001', 'encoder@videopipeline.com', 'Ana García', 'hash_encoder_001', 'encoder', TRUE, '2025-10-17 08:30:00', '+1-555-0102'),
('analyst001', 'analyst@videopipeline.com', 'Roberto Silva', 'hash_analyst_001', 'analyst', TRUE, '2025-10-17 10:00:00', '+1-555-0103'),
('client_netflix', 'netflix@client.com', 'Sarah Johnson', 'hash_client_001', 'client', TRUE, '2025-10-16 15:00:00', '+1-555-0104'),
('client_youtube', 'youtube@client.com', 'Michael Chen', 'hash_client_002', 'client', TRUE, '2025-10-16 14:00:00', '+1-555-0105'),
('encoder002', 'maria.lopez@videopipeline.com', 'María López', 'hash_encoder_002', 'encoder', TRUE, '2025-10-17 07:45:00', '+1-555-0106'),
('analyst002', 'david.kim@videopipeline.com', 'David Kim', 'hash_analyst_002', 'analyst', TRUE, '2025-10-17 09:30:00', '+1-555-0107'),
('viewer001', 'john.viewer@videopipeline.com', 'John Viewer', 'hash_viewer_001', 'viewer', TRUE, '2025-10-16 16:00:00', '+1-555-0108'),
('client_hbo', 'hbo@client.com', 'Patricia Wong', 'hash_client_003', 'client', TRUE, '2025-10-15 11:00:00', '+1-555-0109'),
('admin002', 'laura.admin@videopipeline.com', 'Laura Fernández', 'hash_admin_002', 'admin', TRUE, '2025-10-17 08:00:00', '+1-555-0110');

-- ==========================================
-- SECCIÓN 2: CLIENTS
-- ==========================================
INSERT INTO clients (
    client_name, company_name, industry, contact_email, contact_phone,
    billing_address, tax_id, account_manager_id, subscription_tier,
    monthly_quota_gb, used_quota_gb, is_active, contract_start_date, contract_end_date
) VALUES
('Netflix Originals', 'Netflix Inc.', 'Streaming', 'originals@netflix.com', '+1-408-540-3700',
 '100 Winchester Circle, Los Gatos, CA 95032', 'TAX-NETFLIX-001', 1, 'enterprise',
 5000, 3250.50, TRUE, '2024-01-01', '2025-12-31'),

('YouTube Premium', 'Google LLC', 'Video Platform', 'premium@youtube.com', '+1-650-253-0000',
 '901 Cherry Ave, San Bruno, CA 94066', 'TAX-YOUTUBE-001', 1, 'enterprise',
 3000, 1890.75, TRUE, '2024-03-15', '2025-03-14'),

('HBO Max Productions', 'Warner Bros. Discovery', 'Entertainment', 'production@hbomax.com', '+1-212-275-6000',
 '230 Park Avenue South, New York, NY 10003', 'TAX-HBO-001', 10, 'professional',
 2000, 1150.25, TRUE, '2024-06-01', '2025-05-31'),

('Disney+ Content', 'The Walt Disney Company', 'Entertainment', 'content@disneyplus.com', '+1-818-560-1000',
 '500 South Buena Vista Street, Burbank, CA 91521', 'TAX-DISNEY-001', 1, 'enterprise',
 4000, 2680.90, TRUE, '2024-02-01', '2026-01-31'),

('Amazon Prime Video', 'Amazon.com Inc.', 'E-commerce & Streaming', 'primevideo@amazon.com', '+1-206-266-1000',
 '410 Terry Avenue North, Seattle, WA 98109', 'TAX-AMAZON-001', 10, 'enterprise',
 3500, 2100.45, TRUE, '2024-04-01', '2025-03-31'),

('Indie Film Studio', 'Creative Productions LLC', 'Independent Film', 'info@indiefilms.com', '+1-310-555-0150',
 '1234 Sunset Blvd, Los Angeles, CA 90028', 'TAX-INDIE-001', 1, 'basic',
 500, 245.80, TRUE, '2024-09-01', '2025-08-31');

-- ==========================================
-- SECCIÓN 3: PROJECTS
-- ==========================================
INSERT INTO projects (
    project_name, project_code, client_id, project_description, project_status,
    priority_level, budget_allocated, budget_spent, start_date, expected_end_date,
    created_by_user_id
) VALUES
('Stranger Things Season 5', 'NETF-ST5-2024', 1, 'Quinta temporada de la serie Stranger Things', 'active',
 9, 250000.00, 180000.00, '2024-01-15', '2025-12-31', 2),

('Netflix Documentary Series', 'NETF-DOC-2024', 1, 'Serie documental sobre naturaleza', 'active',
 7, 150000.00, 95000.00, '2024-03-01', '2025-06-30', 2),

('YouTube Originals Q4', 'YT-ORIG-Q4-2024', 2, 'Contenido original para YouTube Premium', 'active',
 8, 180000.00, 120000.00, '2024-10-01', '2024-12-31', 6),

('HBO Drama Series', 'HBO-DRAMA-2024', 3, 'Nueva serie dramática para HBO Max', 'active',
 8, 200000.00, 145000.00, '2024-06-15', '2025-08-30', 2),

('Disney Animation Project', 'DIS-ANIM-2024', 4, 'Película animada para Disney+', 'active',
 10, 300000.00, 215000.00, '2024-02-01', '2025-11-30', 6),

('Amazon Action Series', 'AMZ-ACT-2024', 5, 'Serie de acción para Prime Video', 'active',
 7, 175000.00, 98000.00, '2024-05-01', '2025-07-31', 2),

('Indie Film Festival', 'IND-FEST-2024', 6, 'Compilación para festival de cine independiente', 'on_hold',
 5, 25000.00, 12000.00, '2024-09-15', '2025-03-15', 6),

('Netflix Comedy Special', 'NETF-COM-2024', 1, 'Especial de comedia stand-up', 'completed',
 6, 50000.00, 48500.00, '2024-01-10', '2024-09-30', 2);

-- ==========================================
-- SECCIÓN 4: STORAGE_LOCATIONS
-- ==========================================
INSERT INTO storage_locations (
    location_name, location_type, base_path, region, bucket_name,
    total_capacity_gb, used_capacity_gb, is_active, is_default, priority_order
) VALUES
('AWS S3 US-East', 's3', 's3://videopipeline-us-east/', 'us-east-1', 'videopipeline-us-east',
 100000, 45230.75, TRUE, TRUE, 1),

('AWS S3 US-West', 's3', 's3://videopipeline-us-west/', 'us-west-2', 'videopipeline-us-west',
 80000, 32150.50, TRUE, FALSE, 2),

('Azure Blob Storage', 'azure', 'https://videopipeline.blob.core.windows.net/', 'East US', 'videopipeline-container',
 60000, 28900.25, TRUE, FALSE, 3),

('Local NAS Primary', 'nas', '/mnt/nas/videopipeline/primary/', NULL, NULL,
 50000, 38500.00, TRUE, FALSE, 4),

('Google Cloud Storage', 'gcp', 'gs://videopipeline-storage/', 'us-central1', 'videopipeline-storage',
 70000, 31200.80, TRUE, FALSE, 5),

('Local NAS Archive', 'nas', '/mnt/nas/videopipeline/archive/', NULL, NULL,
 100000, 72500.50, TRUE, FALSE, 6);

-- ==========================================
-- SECCIÓN 5: ENCODING_PROFILES
-- ==========================================
INSERT INTO encoding_profiles (
    profile_name, target_codec, target_resolution, target_bitrate, target_framerate,
    audio_codec, audio_bitrate, container_format, ffmpeg_preset, quality_setting,
    profile_description, is_active
) VALUES
('4K_H265_High', 'h265', '3840x2160', 15000000, 29.97, 'aac', 192000, 'mp4', 'slow', 22.00,
 'Ultra High Definition for premium streaming', TRUE),

('4K_H265_Medium', 'h265', '3840x2160', 10000000, 29.97, 'aac', 192000, 'mp4', 'medium', 24.00,
 'High Definition 4K for standard streaming', TRUE),

('FullHD_H264_High', 'h264', '1920x1080', 8000000, 29.97, 'aac', 128000, 'mp4', 'medium', 21.00,
 'Full HD for wide compatibility', TRUE),

('FullHD_H264_Medium', 'h264', '1920x1080', 5000000, 29.97, 'aac', 128000, 'mp4', 'fast', 23.00,
 'Full HD optimized for mobile devices', TRUE),

('HD_H264_Low', 'h264', '1280x720', 2500000, 29.97, 'aac', 96000, 'mp4', 'veryfast', 25.00,
 'HD for low bandwidth streaming', TRUE),

('SD_H264', 'h264', '854x480', 1000000, 29.97, 'aac', 64000, 'mp4', 'veryfast', 26.00,
 'Standard Definition for minimal bandwidth', TRUE),

('WebM_VP9_FullHD', 'vp9', '1920x1080', 6000000, 30.00, 'opus', 128000, 'webm', 'medium', 31.00,
 'WebM format for web streaming', TRUE),

('HLS_H264_Adaptive', 'h264', '1920x1080', 7000000, 29.97, 'aac', 128000, 'ts', 'medium', 22.00,
 'HLS format for adaptive streaming', TRUE),

('Archive_ProRes', 'prores', '3840x2160', 200000000, 25.00, 'pcm_s24le', 1536000, 'mov', 'medium', 10.00,
 'High quality archival format', FALSE),

('YouTube_4K', 'h264', '3840x2160', 35000000, 60.00, 'aac', 192000, 'mp4', 'slow', 20.00,
 'Optimized for YouTube 4K uploads', TRUE),

('Facebook_HD', 'h264', '1920x1080', 4000000, 30.00, 'aac', 128000, 'mp4', 'fast', 23.00,
 'Optimized for Facebook video', TRUE),

('Instagram_Stories', 'h264', '1080x1920', 3000000, 30.00, 'aac', 128000, 'mp4', 'veryfast', 24.00,
 'Vertical format for Instagram Stories', TRUE);

-- ==========================================
-- SECCIÓN 6: PROCESSING_WORKERS
-- ==========================================
INSERT INTO processing_workers (
    worker_name, server_hostname, cpu_cores, ram_gb, gpu_model, gpu_memory_gb,
    max_concurrent_jobs, current_load, worker_status, supported_codecs,
    last_heartbeat, worker_type
) VALUES
('worker-gpu-01', 'encode-server-01.local', 32, 128, 'NVIDIA RTX 4090', 24,
 4, 0, 'active', '["h264", "h265", "vp9", "av1"]', '2025-10-17 10:00:00', 'gpu'),

('worker-gpu-02', 'encode-server-02.local', 32, 128, 'NVIDIA RTX 4090', 24,
 4, 0, 'active', '["h264", "h265", "vp9", "av1"]', '2025-10-17 10:00:00', 'gpu'),

('worker-cpu-01', 'encode-server-03.local', 64, 256, NULL, 0,
 8, 0, 'active', '["h264", "h265", "vp9", "prores"]', '2025-10-17 10:00:00', 'cpu'),

('worker-cpu-02', 'encode-server-04.local', 64, 256, NULL, 0,
 8, 0, 'active', '["h264", "h265", "vp9", "prores"]', '2025-10-17 10:00:00', 'cpu'),

('worker-hybrid-01', 'encode-server-05.local', 48, 192, 'NVIDIA RTX 3090', 24,
 6, 0, 'active', '["h264", "h265", "vp9", "av1", "prores"]', '2025-10-17 10:00:00', 'hybrid'),

('worker-gpu-03', 'encode-server-06.local', 32, 128, 'NVIDIA RTX 4080', 16,
 3, 0, 'active', '["h264", "h265", "vp9"]', '2025-10-17 10:00:00', 'gpu'),

('worker-cpu-03', 'encode-server-07.local', 48, 128, NULL, 0,
 6, 0, 'active', '["h264", "h265", "vp9", "mpeg2"]', '2025-10-17 10:00:00', 'cpu'),

('worker-maintenance', 'encode-server-08.local', 32, 128, 'NVIDIA RTX 3080', 12,
 4, 0, 'maintenance', '["h264", "h265"]', '2025-10-16 18:00:00', 'gpu'),

('worker-gpu-04', 'encode-server-09.local', 32, 128, 'NVIDIA RTX 4070', 12,
 3, 0, 'active', '["h264", "h265", "vp9"]', '2025-10-17 10:00:00', 'gpu'),

('worker-cpu-04', 'encode-server-10.local', 64, 256, NULL, 0,
 8, 0, 'active', '["h264", "h265", "vp9", "prores", "mpeg2"]', '2025-10-17 10:00:00', 'cpu');

-- ==========================================
-- SECCIÓN 7: SOURCE_FILES (ACTUALIZADA CON NUEVAS RELACIONES)
-- ==========================================
INSERT INTO source_files (
    filename, file_path, file_size_bytes, duration_seconds, upload_timestamp,
    checksum_md5, original_codec, original_resolution, original_bitrate,
    original_framerate, audio_channels, audio_sample_rate, container_format, metadata_json,
    client_id, project_id, uploaded_by_user_id, storage_location_id
) VALUES
('movie_2024_4k.mp4', '/storage/raw/movie_2024_4k.mp4', 5368709120, 7245.500, '2024-01-15 10:30:00',
 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6', 'h264', '3840x2160', 25000000, 29.97, 2, 48000, 'mp4',
 '{"producer": "Studio A", "genre": "Action", "language": "en"}', 1, 1, 4, 1),

('documentary_nature.mov', '/storage/raw/documentary_nature.mov', 8589934592, 5400.250, '2024-01-16 14:20:00',
 'b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7', 'prores', '3840x2160', 150000000, 23.98, 2, 48000, 'mov',
 '{"producer": "Nature Films", "genre": "Documentary", "language": "en"}', 1, 2, 2, 1),

('series_ep01.mkv', '/storage/raw/series_ep01.mkv', 3221225472, 2700.000, '2024-01-17 09:15:00',
 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8', 'h265', '1920x1080', 8000000, 25.00, 6, 48000, 'mkv',
 '{"producer": "TV Network", "genre": "Drama", "season": 1, "episode": 1}', 3, 4, 2, 2),

('commercial_ad.mp4', '/storage/raw/commercial_ad.mp4', 536870912, 30.000, '2024-01-18 16:45:00',
 'd4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9', 'h264', '1920x1080', 12000000, 30.00, 2, 48000, 'mp4',
 '{"producer": "Ad Agency", "genre": "Commercial", "client": "Brand X"}', 2, 3, 5, 1),

('music_video_hd.mp4', '/storage/raw/music_video_hd.mp4', 2147483648, 240.500, '2024-01-19 11:00:00',
 'e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', 'h264', '1920x1080', 15000000, 24.00, 2, 48000, 'mp4',
 '{"producer": "Music Label", "genre": "Music Video", "artist": "Artist Y"}', 2, 3, 6, 2),

('training_video.avi', '/storage/raw/training_video.avi', 4294967296, 3600.000, '2024-01-20 08:30:00',
 'f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1', 'mpeg2', '1280x720', 5000000, 25.00, 2, 44100, 'avi',
 '{"producer": "Corporate", "genre": "Training", "department": "HR"}', 4, 5, 2, 3),

('animation_short.mp4', '/storage/raw/animation_short.mp4', 1073741824, 600.000, '2024-01-21 13:20:00',
 'g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2', 'h264', '1920x1080', 10000000, 24.00, 2, 48000, 'mp4',
 '{"producer": "Animation Studio", "genre": "Animation", "type": "Short Film"}', 4, 5, 6, 1),

('sports_highlight.mp4', '/storage/raw/sports_highlight.mp4', 2684354560, 900.000, '2024-01-22 17:00:00',
 'h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3', 'h264', '1920x1080', 20000000, 59.94, 2, 48000, 'mp4',
 '{"producer": "Sports Network", "genre": "Sports", "event": "Championship 2024"}', 5, 6, 2, 2),

('interview_4k.mov', '/storage/raw/interview_4k.mov', 7516192768, 4500.000, '2024-01-23 10:45:00',
 'i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4', 'prores', '3840x2160', 180000000, 25.00, 2, 48000, 'mov',
 '{"producer": "News Channel", "genre": "Interview", "subject": "Celebrity"}', 3, 4, 9, 3),

('tutorial_cooking.mp4', '/storage/raw/tutorial_cooking.mp4', 1610612736, 1200.000, '2024-01-24 15:30:00',
 'j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5', 'h264', '1920x1080', 8000000, 30.00, 2, 48000, 'mp4',
 '{"producer": "Cooking Channel", "genre": "Tutorial", "cuisine": "Italian"}', 2, 3, 5, 1),

('concert_live.mkv', '/storage/raw/concert_live.mkv', 10737418240, 9000.000, '2024-01-25 19:00:00',
 'k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6', 'h265', '3840x2160', 35000000, 25.00, 6, 48000, 'mkv',
 '{"producer": "Music Production", "genre": "Concert", "artist": "Band Z"}', 5, 6, 2, 4),

('webinar_tech.mp4', '/storage/raw/webinar_tech.mp4', 2147483648, 5400.000, '2024-01-26 09:00:00',
 'l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7', 'h264', '1920x1080', 3000000, 30.00, 2, 48000, 'mp4',
 '{"producer": "Tech Company", "genre": "Webinar", "topic": "AI Development"}', 6, 7, 6, 1),

('game_trailer.mp4', '/storage/raw/game_trailer.mp4', 3221225472, 180.000, '2024-01-27 12:30:00',
 'm3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8', 'h264', '3840x2160', 40000000, 60.00, 2, 48000, 'mp4',
 '{"producer": "Game Studio", "genre": "Trailer", "game": "Epic Quest"}', 2, 3, 5, 2),

('news_segment.mxf', '/storage/raw/news_segment.mxf', 5368709120, 1800.000, '2024-01-28 18:00:00',
 'n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9', 'mpeg2', '1920x1080', 50000000, 25.00, 2, 48000, 'mxf',
 '{"producer": "News Network", "genre": "News", "segment": "Evening Edition"}', 3, 4, 9, 3),

('podcast_video.mp4', '/storage/raw/podcast_video.mp4', 1073741824, 3600.000, '2024-01-29 14:00:00',
 'o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0', 'h264', '1280x720', 2000000, 30.00, 2, 48000, 'mp4',
 '{"producer": "Podcast Network", "genre": "Podcast", "series": "Tech Talk"}', 1, 2, 4, 1);

-- ==========================================
-- SECCIÓN 8: ENCODING_JOBS
-- ==========================================
-- Trabajos completados exitosamente
INSERT INTO encoding_jobs (
    source_file_id, profile_id, worker_id, job_priority, job_status,
    queued_timestamp, started_timestamp, completed_timestamp,
    estimated_duration, actual_duration, retry_count, max_retries,
    created_by_user, created_by_user_id, progress_percentage
) VALUES
(1, 1, 1, 8, 'completed', '2025-01-15 11:00:00', '2025-01-15 11:05:00', '2025-01-15 13:25:00', 8400, 8400, 0, 3, 'admin@company.com', 1, 100.00),
(1, 3, 2, 7, 'completed', '2025-01-15 11:00:00', '2025-01-15 11:05:00', '2025-01-15 12:35:00', 5400, 5400, 0, 3, 'admin@company.com', 1, 100.00),
(2, 2, 3, 6, 'completed', '2025-01-16 15:00:00', '2025-01-16 15:10:00', '2025-01-16 18:40:00', 12600, 12600, 0, 3, 'encoder@company.com', 2, 100.00),
(3, 3, 1, 5, 'completed', '2025-01-17 10:00:00', '2025-01-17 10:05:00', '2025-01-17 11:20:00', 4500, 4500, 0, 3, 'admin@company.com', 1, 100.00),
(4, 4, 4, 9, 'completed', '2025-01-18 17:00:00', '2025-01-18 17:02:00', '2025-01-18 17:05:00', 180, 180, 0, 3, 'marketing@company.com', 5, 100.00),
(5, 3, 2, 7, 'completed', '2025-01-19 11:30:00', '2025-01-19 11:35:00', '2025-01-19 11:50:00', 900, 900, 0, 3, 'content@company.com', 5, 100.00),
(6, 5, 5, 4, 'completed', '2025-01-20 09:00:00', '2025-01-20 09:10:00', '2025-01-20 11:40:00', 9000, 9000, 0, 3, 'hr@company.com', 2, 100.00),
(7, 4, 1, 6, 'completed', '2025-01-21 14:00:00', '2025-01-21 14:05:00', '2025-01-21 14:35:00', 1800, 1800, 0, 3, 'animation@company.com', 6, 100.00),
(8, 3, 3, 8, 'completed', '2025-01-22 17:30:00', '2025-01-22 17:35:00', '2025-01-22 18:20:00', 2700, 2700, 0, 3, 'sports@company.com', 2, 100.00),
(9, 1, 2, 5, 'completed', '2025-01-23 11:00:00', '2025-01-23 11:10:00', '2025-01-23 14:20:00', 11400, 11400, 0, 3, 'news@company.com', 9, 100.00),
(10, 4, 4, 6, 'completed', '2025-01-24 16:00:00', '2025-01-24 16:05:00', '2025-01-24 16:45:00', 2400, 2400, 0, 3, 'cooking@company.com', 5, 100.00),

-- Trabajos en procesamiento
(11, 2, 5, 7, 'processing', '2025-10-17 08:00:00', '2025-10-17 08:10:00', NULL, 18000, NULL, 0, 3, 'music@company.com', 2, 45.50),
(12, 5, 6, 5, 'processing', '2025-10-17 09:00:00', '2025-10-17 09:15:00', NULL, 10800, NULL, 0, 3, 'tech@company.com', 6, 62.30),

-- Trabajos en cola
(13, 10, NULL, 9, 'queued', '2025-10-17 09:30:00', NULL, NULL, 600, NULL, 0, 3, 'gaming@company.com', 5, 0.00),
(14, 3, NULL, 8, 'queued', '2025-10-17 09:35:00', NULL, NULL, 3600, NULL, 0, 3, 'news@company.com', 9, 0.00),
(15, 4, NULL, 7, 'queued', '2025-10-17 09:40:00', NULL, NULL, 7200, NULL, 0, 3, 'podcast@company.com', 4, 0.00),

-- Trabajos fallidos
(1, 5, 7, 6, 'failed', '2025-10-16 14:00:00', '2025-10-16 14:05:00', '2025-10-16 14:30:00', 8400, NULL, 1, 3, 'admin@company.com', 1, 15.00),
(6, 3, 3, 5, 'failed', '2025-10-16 16:00:00', '2025-10-16 16:10:00', '2025-10-16 17:00:00', 9000, NULL, 2, 3, 'hr@company.com', 2, 42.00),

-- Trabajo cancelado
(14, 6, NULL, 3, 'cancelled', '2025-10-15 10:00:00', NULL, '2025-10-15 10:05:00', 3600, NULL, 0, 3, 'news@company.com', 9, 0.00);

-- ==========================================
-- SECCIÓN 9: TRANSCODED_OUTPUTS
-- ==========================================
INSERT INTO transcoded_outputs (
    job_id, output_filename, output_path, output_size_bytes, actual_bitrate,
    actual_resolution, actual_framerate, encoding_time_seconds, compression_ratio,
    output_checksum
) VALUES
(1, 'movie_2024_4k_h265_high.mp4', '/storage/output/movie_2024_4k_h265_high.mp4', 3221225472, 14800000, '3840x2160', 29.97, 8400, 0.6000, 'aa11bb22cc33dd44ee55ff66gg77hh88'),
(2, 'movie_2024_fullhd.mp4', '/storage/output/movie_2024_fullhd.mp4', 1610612736, 7900000, '1920x1080', 29.97, 5400, 0.3000, 'bb22cc33dd44ee55ff66gg77hh88ii99'),
(3, 'documentary_4k_medium.mp4', '/storage/output/documentary_4k_medium.mp4', 4294967296, 9800000, '3840x2160', 23.98, 12600, 0.5000, 'cc33dd44ee55ff66gg77hh88ii99jj00'),
(4, 'series_ep01_fullhd.mp4', '/storage/output/series_ep01_fullhd.mp4', 1879048192, 7850000, '1920x1080', 25.00, 4500, 0.5833, 'dd44ee55ff66gg77hh88ii99jj00kk11'),
(5, 'commercial_ad_medium.mp4', '/storage/output/commercial_ad_medium.mp4', 107374182, 4950000, '1920x1080', 30.00, 180, 0.2000, 'ee55ff66gg77hh88ii99jj00kk11ll22'),
(6, 'music_video_fullhd.mp4', '/storage/output/music_video_fullhd.mp4', 536870912, 7920000, '1920x1080', 24.00, 900, 0.2500, 'ff66gg77hh88ii99jj00kk11ll22mm33'),
(7, 'training_video_hd.mp4', '/storage/output/training_video_hd.mp4', 1073741824, 2480000, '1280x720', 25.00, 9000, 0.2500, 'gg77hh88ii99jj00kk11ll22mm33nn44'),
(8, 'animation_medium.mp4', '/storage/output/animation_medium.mp4', 268435456, 4980000, '1920x1080', 24.00, 1800, 0.2500, 'hh88ii99jj00kk11ll22mm33nn44oo55'),
(9, 'sports_fullhd.mp4', '/storage/output/sports_fullhd.mp4', 805306368, 7940000, '1920x1080', 59.94, 2700, 0.3000, 'ii99jj00kk11ll22mm33nn44oo55pp66'),
(10, 'interview_4k_high.mp4', '/storage/output/interview_4k_high.mp4', 5905580032, 14900000, '3840x2160', 25.00, 11400, 0.7857, 'jj00kk11ll22mm33nn44oo55pp66qq77'),
(11, 'tutorial_medium.mp4', '/storage/output/tutorial_medium.mp4', 402653184, 4970000, '1920x1080', 30.00, 2400, 0.2500, 'kk11ll22mm33nn44oo55pp66qq77rr88');

-- ==========================================
-- SECCIÓN 10: QUALITY_METRICS
-- ==========================================
INSERT INTO quality_metrics (
    output_id, psnr_value, ssim_value, vmaf_score, bitrate_efficiency,
    visual_quality_score, audio_quality_score, analysis_timestamp,
    metric_version, analysis_duration_seconds
) VALUES
(1, 42.850, 0.9845, 96.50, 1.2345, 9.50, 9.20, '2025-01-15 13:30:00', '1.0', 420),
(2, 40.250, 0.9720, 92.30, 1.1890, 9.00, 8.80, '2025-01-15 12:40:00', '1.0', 360),
(3, 43.100, 0.9865, 97.20, 1.2678, 9.70, 9.50, '2025-01-16 18:45:00', '1.0', 540),
(4, 39.850, 0.9685, 90.80, 1.1456, 8.80, 8.90, '2025-01-17 11:25:00', '1.0', 300),
(5, 41.500, 0.9780, 94.50, 1.2123, 9.20, 9.00, '2025-01-18 17:10:00', '1.0', 45),
(6, 40.900, 0.9750, 93.20, 1.1987, 9.10, 9.30, '2025-01-19 11:55:00', '1.0', 120),
(7, 38.450, 0.9620, 88.50, 1.0987, 8.50, 8.40, '2025-01-20 11:50:00', '1.0', 480),
(8, 41.200, 0.9765, 93.80, 1.2034, 9.15, 8.95, '2025-01-21 14:40:00', '1.0', 180),
(9, 40.650, 0.9735, 92.90, 1.1876, 9.05, 9.10, '2025-01-22 18:25:00', '1.0', 240),
(10, 43.500, 0.9880, 98.10, 1.2890, 9.80, 9.60, '2025-01-23 14:30:00', '1.0', 600),
(11, 40.550, 0.9740, 92.60, 1.1920, 9.00, 8.90, '2025-01-24 16:50:00', '1.0', 180);

-- ==========================================
-- SECCIÓN 11: FFMPEG_COMMANDS
-- ==========================================
INSERT INTO ffmpeg_commands (
    job_id, full_command_string, input_filters, video_filters, audio_filters,
    output_parameters, hardware_acceleration, thread_count, memory_usage_mb,
    command_version
) VALUES
(1, 'ffmpeg -i /storage/raw/movie_2024_4k.mp4 -c:v libx265 -preset slow -crf 22 -b:v 15M -c:a aac -b:a 192k /storage/output/movie_2024_4k_h265_high.mp4',
 '{"format": "mp4"}', '{"scale": "3840x2160", "fps": "29.97"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx265", "preset": "slow", "crf": "22"}', 'nvenc', 16, 8192, '1.0'),

(2, 'ffmpeg -i /storage/raw/movie_2024_4k.mp4 -c:v libx264 -preset medium -crf 21 -b:v 8M -vf scale=1920:1080 -c:a aac -b:a 128k /storage/output/movie_2024_fullhd.mp4',
 '{"format": "mp4"}', '{"scale": "1920x1080", "fps": "29.97"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx264", "preset": "medium", "crf": "21"}', 'nvenc', 12, 6144, '1.0'),

(3, 'ffmpeg -i /storage/raw/documentary_nature.mov -c:v libx265 -preset medium -crf 24 -b:v 10M -c:a aac -b:a 192k /storage/output/documentary_4k_medium.mp4',
 '{"format": "mov"}', '{"scale": "3840x2160", "fps": "23.98"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx265", "preset": "medium", "crf": "24"}', NULL, 24, 12288, '1.0'),

(4, 'ffmpeg -i /storage/raw/series_ep01.mkv -c:v libx264 -preset medium -crf 21 -b:v 8M -vf scale=1920:1080 -c:a aac -b:a 128k /storage/output/series_ep01_fullhd.mp4',
 '{"format": "mkv"}', '{"scale": "1920x1080", "fps": "25.00"}', '{"sample_rate": "48000", "channels": "6"}',
 '{"codec": "libx264", "preset": "medium", "crf": "21"}', 'nvenc', 16, 8192, '1.0'),

(5, 'ffmpeg -i /storage/raw/commercial_ad.mp4 -c:v libx264 -preset fast -crf 23 -b:v 5M -c:a aac -b:a 128k /storage/output/commercial_ad_medium.mp4',
 '{"format": "mp4"}', '{"scale": "1920x1080", "fps": "30.00"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx264", "preset": "fast", "crf": "23"}', NULL, 8, 4096, '1.0'),

(6, 'ffmpeg -i /storage/raw/music_video_hd.mp4 -c:v libx264 -preset medium -crf 21 -b:v 8M -c:a aac -b:a 128k /storage/output/music_video_fullhd.mp4',
 '{"format": "mp4"}', '{"scale": "1920x1080", "fps": "24.00"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx264", "preset": "medium", "crf": "21"}', 'nvenc', 12, 6144, '1.0'),

(7, 'ffmpeg -i /storage/raw/training_video.avi -c:v libx264 -preset veryfast -crf 25 -b:v 2.5M -vf scale=1280:720 -c:a aac -b:a 96k /storage/output/training_video_hd.mp4',
 '{"format": "avi"}', '{"scale": "1280x720", "fps": "25.00"}', '{"sample_rate": "44100", "channels": "2"}',
 '{"codec": "libx264", "preset": "veryfast", "crf": "25"}', NULL, 16, 8192, '1.0'),

(8, 'ffmpeg -i /storage/raw/animation_short.mp4 -c:v libx264 -preset fast -crf 23 -b:v 5M -c:a aac -b:a 128k /storage/output/animation_medium.mp4',
 '{"format": "mp4"}', '{"scale": "1920x1080", "fps": "24.00"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx264", "preset": "fast", "crf": "23"}', 'nvenc', 16, 6144, '1.0'),

(9, 'ffmpeg -i /storage/raw/sports_highlight.mp4 -c:v libx264 -preset medium -crf 21 -b:v 8M -c:a aac -b:a 128k /storage/output/sports_fullhd.mp4',
 '{"format": "mp4"}', '{"scale": "1920x1080", "fps": "59.94"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx264", "preset": "medium", "crf": "21"}', NULL, 20, 10240, '1.0'),

(10, 'ffmpeg -i /storage/raw/interview_4k.mov -c:v libx265 -preset slow -crf 22 -b:v 15M -c:a aac -b:a 192k /storage/output/interview_4k_high.mp4',
 '{"format": "mov"}', '{"scale": "3840x2160", "fps": "25.00"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx265", "preset": "slow", "crf": "22"}', 'nvenc', 16, 8192, '1.0'),

(11, 'ffmpeg -i /storage/raw/tutorial_cooking.mp4 -c:v libx264 -preset fast -crf 23 -b:v 5M -c:a aac -b:a 128k /storage/output/tutorial_medium.mp4',
 '{"format": "mp4"}', '{"scale": "1920x1080", "fps": "30.00"}', '{"sample_rate": "48000", "channels": "2"}',
 '{"codec": "libx264", "preset": "fast", "crf": "23"}', NULL, 12, 6144, '1.0');

-- ==========================================
-- SECCIÓN 12: PROCESSING_ERRORS
-- ==========================================
INSERT INTO processing_errors (
    job_id, error_code, error_message, error_timestamp, ffmpeg_output,
    system_resources_at_error, recovery_action, is_resolved, resolved_timestamp, resolved_by
) VALUES
(16, 'CODEC_ERROR', 'Failed to initialize H264 encoder', '2025-10-16 14:30:00',
 'Error: libx264 initialization failed - invalid parameters',
 '{"cpu_usage": 45.5, "memory_usage": 62.3, "disk_space": 850}',
 'Reintento automático pendiente', FALSE, NULL, NULL),

(17, 'MEMORY_ERROR', 'Insufficient memory for encoding operation', '2025-10-16 17:00:00',
 'Error: malloc failed - cannot allocate buffer',
 '{"cpu_usage": 78.2, "memory_usage": 95.8, "disk_space": 750}',
 'Reintento automático pendiente', FALSE, NULL, NULL),

(18, 'USER_CANCELLED', 'Job cancelled by user request', '2025-10-15 10:05:00',
 NULL,
 '{"cpu_usage": 0, "memory_usage": 35.2, "disk_space": 890}',
 'Ninguna - cancelado por usuario', TRUE, '2025-10-15 10:05:00', 'news@company.com');

-- ==========================================
-- SECCIÓN 13: CODEC_PERFORMANCE
-- ==========================================
INSERT INTO codec_performance (
    codec_name, worker_id, input_resolution, encoding_speed_fps, cpu_utilization,
    memory_usage_mb, gpu_utilization, benchmark_date, test_duration_seconds,
    quality_setting, sample_file_type
) VALUES
('h264', 1, '3840x2160', 45.500, 65.30, 6144, 85.20, '2025-09-15 10:00:00', 300, 22.00, 'action_movie'),
('h265', 1, '3840x2160', 28.750, 78.50, 7168, 92.40, '2025-09-15 10:30:00', 300, 22.00, 'action_movie'),
('vp9', 1, '3840x2160', 18.250, 82.10, 6656, 88.60, '2025-09-15 11:00:00', 300, 31.00, 'action_movie'),

('h264', 2, '1920x1080', 125.300, 55.20, 4096, 75.30, '2025-09-16 09:00:00', 180, 21.00, 'documentary'),
('h265', 2, '1920x1080', 78.500, 68.40, 4608, 82.50, '2025-09-16 09:30:00', 180, 24.00, 'documentary'),
('vp9', 2, '1920x1080', 52.800, 72.80, 4352, 78.90, '2025-09-16 10:00:00', 180, 31.00, 'documentary'),

('h264', 3, '3840x2160', 32.500, 72.30, 8192, NULL, '2025-09-17 14:00:00', 300, 22.00, 'nature'),
('h265', 3, '3840x2160', 22.100, 85.60, 9216, NULL, '2025-09-17 14:30:00', 300, 24.00, 'nature'),
('prores', 3, '3840x2160', 65.200, 58.20, 12288, NULL, '2025-09-17 15:00:00', 300, 10.00, 'nature'),

('h264', 4, '1920x1080', 95.800, 62.50, 5120, NULL, '2025-09-18 11:00:00', 180, 23.00, 'commercial'),
('h265', 4, '1920x1080', 68.400, 74.20, 5632, NULL, '2025-09-18 11:30:00', 180, 24.00, 'commercial'),

('h264', 5, '1920x1080', 110.500, 58.70, 4608, 70.20, '2025-09-19 13:00:00', 180, 21.00, 'music_video'),
('h265', 5, '1920x1080', 72.300, 68.90, 5120, 78.50, '2025-09-19 13:30:00', 180, 24.00, 'music_video'),
('vp9', 5, '1920x1080', 48.600, 74.40, 4864, 75.80, '2025-09-19 14:00:00', 180, 31.00, 'music_video'),

('h264', 6, '1280x720', 185.400, 48.20, 3072, 62.40, '2025-09-20 10:00:00', 120, 25.00, 'training'),
('h265', 6, '1280x720', 128.700, 56.80, 3584, 68.90, '2025-09-20 10:30:00', 120, 25.00, 'training'),

('h264', 7, '1920x1080', 102.300, 64.50, 4096, NULL, '2025-09-21 15:00:00', 180, 23.00, 'animation'),
('h265', 7, '1920x1080', 75.600, 72.30, 4608, NULL, '2025-09-21 15:30:00', 180, 24.00, 'animation'),
('mpeg2', 7, '1920x1080', 145.200, 52.10, 3584, NULL, '2025-09-21 16:00:00', 180, 20.00, 'animation'),

('h264', 9, '1920x1080', 118.500, 56.40, 4352, 72.60, '2025-09-22 12:00:00', 180, 21.00, 'sports'),
('h265', 9, '1920x1080', 82.300, 66.70, 4864, 79.40, '2025-09-22 12:30:00', 180, 24.00, 'sports'),

('h264', 10, '3840x2160', 35.800, 70.20, 8192, NULL, '2025-09-23 09:00:00', 300, 22.00, 'interview'),
('h265', 10, '3840x2160', 24.500, 82.50, 9216, NULL, '2025-09-23 09:30:00', 300, 24.00, 'interview'),
('prores', 10, '3840x2160', 68.900, 56.80, 12288, NULL, '2025-09-23 10:00:00', 300, 10.00, 'interview');

-- ==========================================
-- SECCIÓN 14: AUDIT_LOGS
-- ==========================================
INSERT INTO audit_logs (
    user_id, action_type, table_name, record_id, action_description,
    old_values, new_values, ip_address, user_agent, action_timestamp
) VALUES
(1, 'login', 'users', 1, 'Usuario admin001 inició sesión exitosamente',
 NULL, '{"login_time": "2025-10-17 09:00:00"}', '192.168.1.100', 'Mozilla/5.0', '2025-10-17 09:00:00'),

(2, 'upload', 'source_files', 1, 'Archivo movie_2024_4k.mp4 subido por encoder001',
 NULL, '{"filename": "movie_2024_4k.mp4", "size_gb": 5.0}', '192.168.1.105', 'Mozilla/5.0', '2024-01-15 10:30:00'),

(1, 'create', 'encoding_jobs', 1, 'Trabajo de codificación creado para archivo ID 1',
 NULL, '{"job_id": 1, "profile": "4K_H265_High", "priority": 8}', '192.168.1.100', 'Mozilla/5.0', '2025-01-15 11:00:00'),

(2, 'assign', 'encoding_jobs', 1, 'Trabajo asignado a worker-gpu-01',
 '{"worker_id": null, "status": "queued"}', '{"worker_id": 1, "status": "processing"}', '192.168.1.105', 'Mozilla/5.0', '2025-01-15 11:05:00'),

(4, 'login', 'users', 4, 'Cliente Netflix inició sesión',
 NULL, '{"login_time": "2025-10-16 15:00:00"}', '203.0.113.45', 'Mozilla/5.0', '2025-10-16 15:00:00'),

(5, 'upload', 'source_files', 4, 'Archivo commercial_ad.mp4 subido',
 NULL, '{"filename": "commercial_ad.mp4", "size_mb": 512}', '198.51.100.78', 'Chrome/120.0', '2024-01-18 16:45:00'),

(3, 'update', 'quality_metrics', 1, 'Métricas de calidad analizadas para output ID 1',
 NULL, '{"vmaf_score": 96.50, "psnr": 42.85}', '192.168.1.110', 'Mozilla/5.0', '2025-01-15 13:30:00'),

(9, 'cancel', 'encoding_jobs', 18, 'Trabajo cancelado por usuario',
 '{"status": "queued"}', '{"status": "cancelled"}', '198.51.100.90', 'Mozilla/5.0', '2025-10-15 10:05:00'),

(1, 'create', 'clients', 1, 'Nuevo cliente Netflix Originals creado',
 NULL, '{"client_name": "Netflix Originals", "tier": "enterprise"}', '192.168.1.100', 'Mozilla/5.0', '2024-01-01 10:00:00'),

(10, 'update', 'processing_workers', 8, 'Worker puesto en mantenimiento',
 '{"status": "active"}', '{"status": "maintenance"}', '192.168.1.115', 'Mozilla/5.0', '2025-10-16 18:00:00'),

(2, 'create', 'projects', 1, 'Nuevo proyecto Stranger Things Season 5 creado',
 NULL, '{"project_name": "Stranger Things Season 5", "client_id": 1}', '192.168.1.105', 'Mozilla/5.0', '2024-01-15 08:00:00'),

(6, 'upload', 'source_files', 7, 'Archivo animation_short.mp4 subido',
 NULL, '{"filename": "animation_short.mp4", "size_gb": 1.0}', '192.168.1.108', 'Chrome/120.0', '2024-01-21 13:20:00');

-- ==========================================
-- SECCIÓN 15: NOTIFICATIONS
-- ==========================================
INSERT INTO notifications (
    user_id, notification_type, title, message, related_job_id, related_file_id,
    priority, is_read, read_timestamp, notification_timestamp
) VALUES
(1, 'job_completed', 'Trabajo Completado', 'El trabajo #1 (movie_2024_4k.mp4) ha sido completado exitosamente',
 1, 1, 'medium', TRUE, '2025-01-15 13:30:00', '2025-01-15 13:25:00'),

(2, 'job_completed', 'Codificación Finalizada', 'El trabajo #3 (documentary_nature.mov) ha finalizado',
 3, 2, 'medium', TRUE, '2025-01-16 18:45:00', '2025-01-16 18:40:00'),

(1, 'job_failed', 'Trabajo Fallido', 'El trabajo #16 ha fallado. Error: CODEC_ERROR',
 16, 1, 'high', FALSE, NULL, '2025-10-16 14:30:00'),

(2, 'job_failed', 'Error en Codificación', 'El trabajo #17 falló por memoria insuficiente',
 17, 6, 'high', FALSE, NULL, '2025-10-16 17:00:00'),

(4, 'job_completed', 'Tu Video Está Listo', 'El video movie_2024_4k.mp4 ha sido procesado completamente',
 1, 1, 'medium', TRUE, '2025-01-15 14:00:00', '2025-01-15 13:25:00'),

(5, 'job_completed', 'Procesamiento Completo', 'El comercial commercial_ad.mp4 está listo',
 5, 4, 'medium', TRUE, '2025-01-18 17:15:00', '2025-01-18 17:05:00'),

(1, 'quota_warning', 'Advertencia de Cuota', 'El cliente Netflix ha usado el 65% de su cuota mensual',
 NULL, NULL, 'medium', TRUE, '2025-10-15 10:00:00', '2025-10-15 09:00:00'),

(1, 'system_alert', 'Worker en Mantenimiento', 'worker-maintenance ha sido puesto en modo mantenimiento',
 NULL, NULL, 'low', TRUE, '2025-10-16 18:05:00', '2025-10-16 18:00:00'),

(3, 'quality_issue', 'Calidad Baja Detectada', 'El trabajo #4 tiene un VMAF score de 90.8 (por debajo del umbral)',
 4, 3, 'medium', FALSE, NULL, '2025-01-17 11:25:00'),

(9, 'job_completed', 'Video Procesado', 'El segmento de noticias news_segment.mxf está listo',
 10, 14, 'medium', TRUE, '2025-01-23 14:30:00', '2025-01-23 14:20:00'),

(1, 'maintenance', 'Mantenimiento Programado', 'Se realizará mantenimiento en worker-gpu-03 el 2025-10-20',
 NULL, NULL, 'low', FALSE, NULL, '2025-10-17 08:00:00'),

(4, 'quota_warning', 'Cuota Próxima al Límite', 'Has usado el 75% de tu cuota mensual. Considera actualizar tu plan',
 NULL, NULL, 'high', FALSE, NULL, '2025-10-17 09:00:00'),

(6, 'job_completed', 'Proyecto Completado', 'El archivo animation_short.mp4 ha sido procesado',
 8, 7, 'medium', TRUE, '2025-01-21 14:40:00', '2025-01-21 14:35:00'),

(2, 'system_alert', 'Capacidad de Workers', 'Todos los workers GPU están al 80% de capacidad',
 NULL, NULL, 'medium', FALSE, NULL, '2025-10-17 10:00:00');

-- ==========================================
-- CONSULTAS DE VERIFICACIÓN
-- ==========================================

-- Verificar número de registros por tabla
SELECT 'users' AS tabla, COUNT(*) AS registros FROM users
UNION ALL
SELECT 'clients', COUNT(*) FROM clients
UNION ALL
SELECT 'projects', COUNT(*) FROM projects
UNION ALL
SELECT 'storage_locations', COUNT(*) FROM storage_locations
UNION ALL
SELECT 'audit_logs', COUNT(*) FROM audit_logs
UNION ALL
SELECT 'notifications', COUNT(*) FROM notifications
UNION ALL
SELECT 'source_files', COUNT(*) FROM source_files
UNION ALL
SELECT 'encoding_profiles', COUNT(*) FROM encoding_profiles
UNION ALL
SELECT 'processing_workers', COUNT(*) FROM processing_workers
UNION ALL
SELECT 'encoding_jobs', COUNT(*) FROM encoding_jobs
UNION ALL
SELECT 'transcoded_outputs', COUNT(*) FROM transcoded_outputs
UNION ALL
SELECT 'quality_metrics', COUNT(*) FROM quality_metrics
UNION ALL
SELECT 'ffmpeg_commands', COUNT(*) FROM ffmpeg_commands
UNION ALL
SELECT 'processing_errors', COUNT(*) FROM processing_errors
UNION ALL
SELECT 'codec_performance', COUNT(*) FROM codec_performance;

-- ==========================================
-- EJEMPLOS DE USO DE VISTAS Y FUNCIONES
-- ==========================================

-- Ejemplo 1: Consultar nueva vista de dashboard de clientes
-- SELECT * FROM vw_dashboard_clientes;

-- Ejemplo 2: Consultar trabajos activos con información de cliente y proyecto
-- SELECT * FROM vw_dashboard_trabajos_activos;

-- Ejemplo 3: Ver métricas de calidad completas con información de cliente
-- SELECT * FROM vw_metricas_calidad_completas WHERE cliente = 'Netflix Originals';

-- Ejemplo 4: Verificar eficiencia de compresión
-- SELECT job_id, fn_calcular_eficiencia_compresion(job_id) AS eficiencia_porcentaje
-- FROM encoding_jobs WHERE job_status = 'completed' LIMIT 5;

-- Ejemplo 5: Consultar notificaciones no leídas por usuario
-- SELECT * FROM notifications WHERE user_id = 1 AND is_read = FALSE;

-- Ejemplo 6: Ver audit logs recientes
-- SELECT * FROM audit_logs ORDER BY action_timestamp DESC LIMIT 10;

-- Ejemplo 7: Ejecutar SP de reporte de rendimiento
-- CALL sp_reporte_rendimiento_periodo('2025-01-15 00:00:00', '2025-10-17 23:59:59');