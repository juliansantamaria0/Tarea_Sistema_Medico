USE sistema_medico;

-- =========================================
--  CONSULTAS BÁSICAS
-- =========================================

-- Listar todos los pacientes
SELECT * FROM paciente;

-- Listar todos los médicos
SELECT * FROM medico;

-- Listar todas las citas con información relacionada
SELECT c.cod_cita,
       p.nombre_paciente,
       p.apellido_paciente,
       m.nombre_medico,
       h.hospital_sede,
       td.diagnostico,
       c.fecha_cita
FROM citas c
JOIN paciente p ON p.paciente_id = c.paciente_id
JOIN medico m ON m.medico_id = c.medico_id
JOIN hospital h ON h.id_hospital = c.id_hospital
JOIN tipos_diagnosticos td ON td.id_diagnostico = c.id_diagnostico
ORDER BY c.fecha_cita;

-- =========================================
--  CONSULTAS CON RELACIÓN N:M
-- =========================================

-- Ver medicamentos por cita
SELECT cm.cod_cita,
       me.nombre_medicamento,
       cm.dosis_medicamento
FROM cita_medicamento cm
JOIN medicamentos me ON me.medicamentos_id = cm.medicamentos_id
ORDER BY cm.cod_cita;

-- Ver facultades por médico
SELECT m.nombre_medico,
       f.facultad_origen
FROM medico_facultad mf
JOIN medico m ON m.medico_id = mf.medico_id
JOIN facultad f ON f.id_facultad = mf.id_facultad;

-- =========================================
--  PRUEBA DE PROCEDIMIENTOS ALMACENADOS
-- =========================================

-- Crear paciente
CALL sp_paciente_create('P-600', 'Carlos', 'Lopez', '600-999');

-- Listar pacientes
CALL sp_paciente_list();

-- Obtener un paciente específico
CALL sp_paciente_get('P-600');

-- Actualizar paciente
CALL sp_paciente_update('P-600', 'Carlos', 'Ramirez', '600-888');

-- Eliminar paciente
CALL sp_paciente_delete('P-600');

-- =========================================
--  PRUEBA DE FUNCIONES
-- =========================================

-- Número de doctores por facultad (por ID)
SELECT fn_num_doctores_por_facultad_id('F01') AS total_doctores_F01;

-- Número de doctores por especialidad
SELECT fn_num_doctores_por_especialidad('Medicina') AS total_doctores_medicina;

-- Total pacientes atendidos por médico
SELECT fn_total_pacientes_por_medico('M-10') AS pacientes_M10;

-- Total pacientes por hospital
SELECT fn_total_pacientes_por_hospital_id('H01') AS pacientes_H01;

-- Total pacientes por sede
SELECT fn_total_pacientes_por_sede('Centro Médico') AS pacientes_centro_medico;

-- =========================================
--  CONSULTAS DE VALIDACIÓN DE INTEGRIDAD
-- =========================================

-- Verificar que no existan citas sin paciente
SELECT *
FROM citas c
LEFT JOIN paciente p ON p.paciente_id = c.paciente_id
WHERE p.paciente_id IS NULL;

-- Verificar medicamentos sin cita asociada
SELECT *
FROM cita_medicamento cm
LEFT JOIN citas c ON c.cod_cita = cm.cod_cita
WHERE c.cod_cita IS NULL;