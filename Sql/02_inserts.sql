INSERT INTO paciente VALUES
('P-501', 'Juan', 'Rivas', '600-111'),
('P-502', 'Ana', 'Soto',  '600-222'),
('P-503', 'Luis','Paz',   '600-333');

INSERT INTO medico VALUES
('M-10', 'Dr. House'),
('M-22', 'Dra. Grey'),
('M-30', 'Dr. Strange');

INSERT INTO facultad VALUES
('F01', 'Medicina', 'Dr. Wilson'),
('F02', 'Ciencias', 'Dr. Palmer');

INSERT INTO medico_facultad VALUES
('M-10', 'F01'),
('M-22', 'F01'),
('M-30', 'F02');

INSERT INTO hospital VALUES
('H01', 'Centro Médico', 'Calle 5 #10'),
('H02', 'Clínica Norte', 'Av. Libertador');

INSERT INTO tipos_diagnosticos VALUES
('TD01', 'Gripe Fuerte'),
('TD02', 'Infección'),
('TD03', 'Arritmia'),
('TD04', 'Migraña');

INSERT INTO medicamentos VALUES
('M01', 'Paracetamol'),
('M02', 'Ibuprofeno'),
('M03', 'Amoxicilina'),
('M04', 'Aspirina'),
('M05', 'Ergotamina');

INSERT INTO citas VALUES
('C-001', 'P-501', 'M-10', '2024-05-10', 'TD01', 'H01'),
('C-002', 'P-502', 'M-10', '2024-05-11', 'TD02', 'H01'),
('C-003', 'P-503', 'M-22', '2024-05-12', 'TD03', 'H02'),
('C-004', 'P-501', 'M-30', '2024-05-15', 'TD04', 'H02');

INSERT INTO cita_medicamento VALUES
('C-001', 'M01', '500mg'),
('C-001', 'M02', '400mg'),
('C-002', 'M03', '875mg'),
('C-003', 'M04', '100mg'),
('C-004', 'M05', '1mg');

-- =========================
-- LOG DE ERRORES
-- =========================
CREATE TABLE log_errores (
  id_log INT AUTO_INCREMENT PRIMARY KEY,
  proc_o_func VARCHAR(120) NOT NULL,
  nombre_tabla VARCHAR(120) NULL,
  codigo_error INT NULL,
  mensaje TEXT NULL,
  fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS sp_log_error;
DELIMITER $$

CREATE PROCEDURE sp_log_error(
  IN p_proc_o_func VARCHAR(120),
  IN p_nombre_tabla VARCHAR(120),
  IN p_codigo_error INT,
  IN p_mensaje TEXT
)
BEGIN
  INSERT INTO log_errores(proc_o_func, nombre_tabla, codigo_error, mensaje, fecha_hora)
  VALUES (p_proc_o_func, p_nombre_tabla, p_codigo_error, p_mensaje, NOW());
END$$

DELIMITER ;