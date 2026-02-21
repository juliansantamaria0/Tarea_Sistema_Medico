CREATE DATABASE IF NOT EXISTS sistema_medico;
USE sistema_medico;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS cita_medicamento;
DROP TABLE IF EXISTS citas;
DROP TABLE IF EXISTS medico_facultad;
DROP TABLE IF EXISTS medicamentos;
DROP TABLE IF EXISTS tipos_diagnosticos;
DROP TABLE IF EXISTS hospital;
DROP TABLE IF EXISTS facultad;
DROP TABLE IF EXISTS medico;
DROP TABLE IF EXISTS paciente;
DROP TABLE IF EXISTS log_errores;

SET FOREIGN_KEY_CHECKS = 1;

-- ========================
-- 1) TABLAS
-- ========================
CREATE TABLE paciente (
    paciente_id VARCHAR(10) PRIMARY KEY,
    nombre_paciente VARCHAR(50) NOT NULL,
    apellido_paciente VARCHAR(50) NOT NULL,
    telefono_paciente VARCHAR(20)
);

CREATE TABLE medico (
    medico_id VARCHAR(10) PRIMARY KEY,
    nombre_medico VARCHAR(100) NOT NULL
);

CREATE TABLE facultad (
    id_facultad VARCHAR(10) PRIMARY KEY,
    facultad_origen VARCHAR(100) NOT NULL,
    decano_facultad VARCHAR(100) NOT NULL
);

CREATE TABLE hospital (
    id_hospital VARCHAR(10) PRIMARY KEY,
    hospital_sede VARCHAR(100) NOT NULL,
    dir_sede VARCHAR(150) NOT NULL
);

CREATE TABLE tipos_diagnosticos (
    id_diagnostico VARCHAR(10) PRIMARY KEY,
    diagnostico VARCHAR(100) NOT NULL
);

CREATE TABLE medicamentos (
    medicamentos_id VARCHAR(10) PRIMARY KEY,
    nombre_medicamento VARCHAR(100) NOT NULL
);

CREATE TABLE medico_facultad (
    medico_id VARCHAR(10) NOT NULL,
    id_facultad VARCHAR(10) NOT NULL,
    PRIMARY KEY (medico_id, id_facultad),
    CONSTRAINT fk_mf_medico FOREIGN KEY (medico_id) REFERENCES medico(medico_id),
    CONSTRAINT fk_mf_facultad FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
);

CREATE TABLE citas (
    cod_cita VARCHAR(10) PRIMARY KEY,
    paciente_id VARCHAR(10) NOT NULL,
    medico_id VARCHAR(10) NOT NULL,
    fecha_cita DATE NOT NULL,
    id_diagnostico VARCHAR(10) NOT NULL,
    id_hospital VARCHAR(10) NOT NULL,
    CONSTRAINT fk_citas_paciente FOREIGN KEY (paciente_id) REFERENCES paciente(paciente_id),
    CONSTRAINT fk_citas_medico FOREIGN KEY (medico_id) REFERENCES medico(medico_id),
    CONSTRAINT fk_citas_diag FOREIGN KEY (id_diagnostico) REFERENCES tipos_diagnosticos(id_diagnostico),
    CONSTRAINT fk_citas_hosp FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
);

CREATE TABLE cita_medicamento (
    cod_cita VARCHAR(10) NOT NULL,
    medicamentos_id VARCHAR(10) NOT NULL,
    dosis_medicamento VARCHAR(20) NOT NULL,
    PRIMARY KEY (cod_cita, medicamentos_id),
    CONSTRAINT fk_cm_cita FOREIGN KEY (cod_cita) REFERENCES citas(cod_cita),
    CONSTRAINT fk_cm_medicamento FOREIGN KEY (medicamentos_id) REFERENCES medicamentos(medicamentos_id)
);

-- =========================
-- 2) DATOS DE PRUEBA
-- =========================
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
-- 3) LOG DE ERRORES
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

-- =========================================================
-- 4) CRUD POR ENTIDAD
-- =========================================================

-- -------------------------
-- A) PACIENTE
-- -------------------------
DROP PROCEDURE IF EXISTS sp_paciente_create;
DROP PROCEDURE IF EXISTS sp_paciente_update;
DROP PROCEDURE IF EXISTS sp_paciente_delete;
DROP PROCEDURE IF EXISTS sp_paciente_get;
DROP PROCEDURE IF EXISTS sp_paciente_list;

DELIMITER $$

CREATE PROCEDURE sp_paciente_create(
  IN p_paciente_id VARCHAR(10),
  IN p_nombre VARCHAR(50),
  IN p_apellido VARCHAR(50),
  IN p_telefono VARCHAR(20)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_paciente_create','paciente',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_paciente_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO paciente(paciente_id, nombre_paciente, apellido_paciente, telefono_paciente)
  VALUES (p_paciente_id, p_nombre, p_apellido, p_telefono);
END$$

CREATE PROCEDURE sp_paciente_update(
  IN p_paciente_id VARCHAR(10),
  IN p_nombre VARCHAR(50),
  IN p_apellido VARCHAR(50),
  IN p_telefono VARCHAR(20)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_paciente_update','paciente',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_paciente_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  UPDATE paciente
  SET nombre_paciente = p_nombre,
      apellido_paciente = p_apellido,
      telefono_paciente = p_telefono
  WHERE paciente_id = p_paciente_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_paciente_update','paciente',404,'No existe el paciente_id a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el paciente_id a actualizar';
  END IF;
END$$

CREATE PROCEDURE sp_paciente_delete(IN p_paciente_id VARCHAR(10))
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_paciente_delete','paciente',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_paciente_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM paciente WHERE paciente_id = p_paciente_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_paciente_delete','paciente',404,'No existe el paciente_id a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el paciente_id a eliminar';
  END IF;
END$$

CREATE PROCEDURE sp_paciente_get(IN p_paciente_id VARCHAR(10))
BEGIN
  SELECT * FROM paciente WHERE paciente_id = p_paciente_id;
END$$

CREATE PROCEDURE sp_paciente_list()
BEGIN
  SELECT * FROM paciente ORDER BY paciente_id;
END$$

DELIMITER ;

-- -------------------------
-- B) MEDICO
-- -------------------------
DROP PROCEDURE IF EXISTS sp_medico_create;
DROP PROCEDURE IF EXISTS sp_medico_update;
DROP PROCEDURE IF EXISTS sp_medico_delete;
DROP PROCEDURE IF EXISTS sp_medico_get;
DROP PROCEDURE IF EXISTS sp_medico_list;

DELIMITER $$

CREATE PROCEDURE sp_medico_create(
  IN p_medico_id VARCHAR(10),
  IN p_nombre VARCHAR(100)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medico_create','medico',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medico_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO medico(medico_id, nombre_medico) VALUES (p_medico_id, p_nombre);
END$$

CREATE PROCEDURE sp_medico_update(
  IN p_medico_id VARCHAR(10),
  IN p_nombre VARCHAR(100)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medico_update','medico',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medico_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  UPDATE medico SET nombre_medico = p_nombre WHERE medico_id = p_medico_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_medico_update','medico',404,'No existe el medico_id a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el medico_id a actualizar';
  END IF;
END$$

CREATE PROCEDURE sp_medico_delete(IN p_medico_id VARCHAR(10))
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medico_delete','medico',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medico_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM medico WHERE medico_id = p_medico_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_medico_delete','medico',404,'No existe el medico_id a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el medico_id a eliminar';
  END IF;
END$$

CREATE PROCEDURE sp_medico_get(IN p_medico_id VARCHAR(10))
BEGIN
  SELECT * FROM medico WHERE medico_id = p_medico_id;
END$$

CREATE PROCEDURE sp_medico_list()
BEGIN
  SELECT * FROM medico ORDER BY medico_id;
END$$

DELIMITER ;

-- -------------------------
-- C) FACULTAD
-- -------------------------
DROP PROCEDURE IF EXISTS sp_facultad_create;
DROP PROCEDURE IF EXISTS sp_facultad_update;
DROP PROCEDURE IF EXISTS sp_facultad_delete;
DROP PROCEDURE IF EXISTS sp_facultad_get;
DROP PROCEDURE IF EXISTS sp_facultad_list;

DELIMITER $$

CREATE PROCEDURE sp_facultad_create(
  IN p_id_facultad VARCHAR(10),
  IN p_origen VARCHAR(100),
  IN p_decano VARCHAR(100)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_facultad_create','facultad',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_facultad_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO facultad(id_facultad, facultad_origen, decano_facultad)
  VALUES (p_id_facultad, p_origen, p_decano);
END$$

CREATE PROCEDURE sp_facultad_update(
  IN p_id_facultad VARCHAR(10),
  IN p_origen VARCHAR(100),
  IN p_decano VARCHAR(100)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_facultad_update','facultad',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_facultad_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  UPDATE facultad
  SET facultad_origen = p_origen,
      decano_facultad = p_decano
  WHERE id_facultad = p_id_facultad;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_facultad_update','facultad',404,'No existe el id_facultad a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el id_facultad a actualizar';
  END IF;
END$$

CREATE PROCEDURE sp_facultad_delete(IN p_id_facultad VARCHAR(10))
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_facultad_delete','facultad',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_facultad_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM facultad WHERE id_facultad = p_id_facultad;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_facultad_delete','facultad',404,'No existe el id_facultad a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el id_facultad a eliminar';
  END IF;
END$$

CREATE PROCEDURE sp_facultad_get(IN p_id_facultad VARCHAR(10))
BEGIN
  SELECT * FROM facultad WHERE id_facultad = p_id_facultad;
END$$

CREATE PROCEDURE sp_facultad_list()
BEGIN
  SELECT * FROM facultad ORDER BY id_facultad;
END$$

DELIMITER ;

-- -------------------------
-- D) HOSPITAL
-- -------------------------
DROP PROCEDURE IF EXISTS sp_hospital_create;
DROP PROCEDURE IF EXISTS sp_hospital_update;
DROP PROCEDURE IF EXISTS sp_hospital_delete;
DROP PROCEDURE IF EXISTS sp_hospital_get;
DROP PROCEDURE IF EXISTS sp_hospital_list;

DELIMITER $$

CREATE PROCEDURE sp_hospital_create(
  IN p_id_hospital VARCHAR(10),
  IN p_sede VARCHAR(100),
  IN p_dir VARCHAR(150)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_hospital_create','hospital',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_hospital_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO hospital(id_hospital, hospital_sede, dir_sede)
  VALUES (p_id_hospital, p_sede, p_dir);
END$$

CREATE PROCEDURE sp_hospital_update(
  IN p_id_hospital VARCHAR(10),
  IN p_sede VARCHAR(100),
  IN p_dir VARCHAR(150)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_hospital_update','hospital',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_hospital_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  UPDATE hospital
  SET hospital_sede = p_sede,
      dir_sede = p_dir
  WHERE id_hospital = p_id_hospital;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_hospital_update','hospital',404,'No existe el id_hospital a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el id_hospital a actualizar';
  END IF;
END$$

CREATE PROCEDURE sp_hospital_delete(IN p_id_hospital VARCHAR(10))
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_hospital_delete','hospital',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_hospital_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM hospital WHERE id_hospital = p_id_hospital;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_hospital_delete','hospital',404,'No existe el id_hospital a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el id_hospital a eliminar';
  END IF;
END$$

CREATE PROCEDURE sp_hospital_get(IN p_id_hospital VARCHAR(10))
BEGIN
  SELECT * FROM hospital WHERE id_hospital = p_id_hospital;
END$$

CREATE PROCEDURE sp_hospital_list()
BEGIN
  SELECT * FROM hospital ORDER BY id_hospital;
END$$

DELIMITER ;

-- -------------------------
-- E) TIPOS_DIAGNOSTICOS
-- -------------------------
DROP PROCEDURE IF EXISTS sp_diagnostico_create;
DROP PROCEDURE IF EXISTS sp_diagnostico_update;
DROP PROCEDURE IF EXISTS sp_diagnostico_delete;
DROP PROCEDURE IF EXISTS sp_diagnostico_get;
DROP PROCEDURE IF EXISTS sp_diagnostico_list;

DELIMITER $$

CREATE PROCEDURE sp_diagnostico_create(
  IN p_id VARCHAR(10),
  IN p_diag VARCHAR(100)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_diagnostico_create','tipos_diagnosticos',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_diagnostico_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO tipos_diagnosticos(id_diagnostico, diagnostico)
  VALUES (p_id, p_diag);
END$$

CREATE PROCEDURE sp_diagnostico_update(
  IN p_id VARCHAR(10),
  IN p_diag VARCHAR(100)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_diagnostico_update','tipos_diagnosticos',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_diagnostico_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  UPDATE tipos_diagnosticos
  SET diagnostico = p_diag
  WHERE id_diagnostico = p_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_diagnostico_update','tipos_diagnosticos',404,'No existe el id_diagnostico a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el id_diagnostico a actualizar';
  END IF;
END$$

CREATE PROCEDURE sp_diagnostico_delete(IN p_id VARCHAR(10))
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_diagnostico_delete','tipos_diagnosticos',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_diagnostico_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM tipos_diagnosticos WHERE id_diagnostico = p_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_diagnostico_delete','tipos_diagnosticos',404,'No existe el id_diagnostico a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el id_diagnostico a eliminar';
  END IF;
END$$

CREATE PROCEDURE sp_diagnostico_get(IN p_id VARCHAR(10))
BEGIN
  SELECT * FROM tipos_diagnosticos WHERE id_diagnostico = p_id;
END$$

CREATE PROCEDURE sp_diagnostico_list()
BEGIN
  SELECT * FROM tipos_diagnosticos ORDER BY id_diagnostico;
END$$

DELIMITER ;

-- -------------------------
-- F) MEDICAMENTOS
-- -------------------------
DROP PROCEDURE IF EXISTS sp_medicamento_create;
DROP PROCEDURE IF EXISTS sp_medicamento_update;
DROP PROCEDURE IF EXISTS sp_medicamento_delete;
DROP PROCEDURE IF EXISTS sp_medicamento_get;
DROP PROCEDURE IF EXISTS sp_medicamento_list;

DELIMITER $$

CREATE PROCEDURE sp_medicamento_create(
  IN p_id VARCHAR(10),
  IN p_nombre VARCHAR(100)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medicamento_create','medicamentos',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medicamento_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO medicamentos(medicamentos_id, nombre_medicamento)
  VALUES (p_id, p_nombre);
END$$

CREATE PROCEDURE sp_medicamento_update(
  IN p_id VARCHAR(10),
  IN p_nombre VARCHAR(100)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medicamento_update','medicamentos',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medicamento_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  UPDATE medicamentos
  SET nombre_medicamento = p_nombre
  WHERE medicamentos_id = p_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_medicamento_update','medicamentos',404,'No existe el medicamentos_id a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el medicamentos_id a actualizar';
  END IF;
END$$

CREATE PROCEDURE sp_medicamento_delete(IN p_id VARCHAR(10))
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medicamento_delete','medicamentos',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medicamento_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM medicamentos WHERE medicamentos_id = p_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_medicamento_delete','medicamentos',404,'No existe el medicamentos_id a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el medicamentos_id a eliminar';
  END IF;
END$$

CREATE PROCEDURE sp_medicamento_get(IN p_id VARCHAR(10))
BEGIN
  SELECT * FROM medicamentos WHERE medicamentos_id = p_id;
END$$

CREATE PROCEDURE sp_medicamento_list()
BEGIN
  SELECT * FROM medicamentos ORDER BY medicamentos_id;
END$$

DELIMITER ;

-- -------------------------
-- G) MEDICO_FACULTAD (
-- -------------------------
DROP PROCEDURE IF EXISTS sp_medico_facultad_create;
DROP PROCEDURE IF EXISTS sp_medico_facultad_update;
DROP PROCEDURE IF EXISTS sp_medico_facultad_delete;
DROP PROCEDURE IF EXISTS sp_medico_facultad_get;
DROP PROCEDURE IF EXISTS sp_medico_facultad_list;

DELIMITER $$

CREATE PROCEDURE sp_medico_facultad_create(
  IN p_medico_id VARCHAR(10),
  IN p_id_facultad VARCHAR(10)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medico_facultad_create','medico_facultad',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medico_facultad_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO medico_facultad(medico_id, id_facultad)
  VALUES (p_medico_id, p_id_facultad);
END$$

-- UPDATE (tabla puente) = borrar + insertar
CREATE PROCEDURE sp_medico_facultad_update(
  IN p_medico_id_old VARCHAR(10),
  IN p_id_facultad_old VARCHAR(10),
  IN p_medico_id_new VARCHAR(10),
  IN p_id_facultad_new VARCHAR(10)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medico_facultad_update','medico_facultad',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medico_facultad_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM medico_facultad
  WHERE medico_id = p_medico_id_old AND id_facultad = p_id_facultad_old;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_medico_facultad_update','medico_facultad',404,'No existe la relación medico_facultad a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe la relación medico_facultad a actualizar';
  END IF;

  INSERT INTO medico_facultad(medico_id, id_facultad)
  VALUES (p_medico_id_new, p_id_facultad_new);
END$$

CREATE PROCEDURE sp_medico_facultad_delete(
  IN p_medico_id VARCHAR(10),
  IN p_id_facultad VARCHAR(10)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_medico_facultad_delete','medico_facultad',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_medico_facultad_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM medico_facultad
  WHERE medico_id = p_medico_id AND id_facultad = p_id_facultad;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_medico_facultad_delete','medico_facultad',404,'No existe la relación medico_facultad a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe la relación medico_facultad a eliminar';
  END IF;
END$$

CREATE PROCEDURE sp_medico_facultad_get(
  IN p_medico_id VARCHAR(10),
  IN p_id_facultad VARCHAR(10)
)
BEGIN
  SELECT mf.medico_id, m.nombre_medico, mf.id_facultad, f.facultad_origen
  FROM medico_facultad mf
  JOIN medico m ON m.medico_id = mf.medico_id
  JOIN facultad f ON f.id_facultad = mf.id_facultad
  WHERE mf.medico_id = p_medico_id AND mf.id_facultad = p_id_facultad;
END$$

CREATE PROCEDURE sp_medico_facultad_list()
BEGIN
  SELECT mf.medico_id, m.nombre_medico, mf.id_facultad, f.facultad_origen
  FROM medico_facultad mf
  JOIN medico m ON m.medico_id = mf.medico_id
  JOIN facultad f ON f.id_facultad = mf.id_facultad
  ORDER BY mf.medico_id, mf.id_facultad;
END$$

DELIMITER ;

-- -------------------------
-- H) CITAS 
-- -------------------------
DROP PROCEDURE IF EXISTS sp_cita_create;
DROP PROCEDURE IF EXISTS sp_cita_update;
DROP PROCEDURE IF EXISTS sp_cita_delete;
DROP PROCEDURE IF EXISTS sp_cita_get;
DROP PROCEDURE IF EXISTS sp_cita_list;

DELIMITER $$

CREATE PROCEDURE sp_cita_create(
  IN p_cod_cita VARCHAR(10),
  IN p_paciente_id VARCHAR(10),
  IN p_medico_id VARCHAR(10),
  IN p_fecha DATE,
  IN p_id_diagnostico VARCHAR(10),
  IN p_id_hospital VARCHAR(10)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_cita_create','citas',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_cita_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO citas(cod_cita, paciente_id, medico_id, fecha_cita, id_diagnostico, id_hospital)
  VALUES (p_cod_cita, p_paciente_id, p_medico_id, p_fecha, p_id_diagnostico, p_id_hospital);
END$$

CREATE PROCEDURE sp_cita_update(
  IN p_cod_cita VARCHAR(10),
  IN p_paciente_id VARCHAR(10),
  IN p_medico_id VARCHAR(10),
  IN p_fecha DATE,
  IN p_id_diagnostico VARCHAR(10),
  IN p_id_hospital VARCHAR(10)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_cita_update','citas',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_cita_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  UPDATE citas
  SET paciente_id = p_paciente_id,
      medico_id = p_medico_id,
      fecha_cita = p_fecha,
      id_diagnostico = p_id_diagnostico,
      id_hospital = p_id_hospital
  WHERE cod_cita = p_cod_cita;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_cita_update','citas',404,'No existe el cod_cita a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el cod_cita a actualizar';
  END IF;
END$$

CREATE PROCEDURE sp_cita_delete(IN p_cod_cita VARCHAR(10))
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_cita_delete','citas',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_cita_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  START TRANSACTION;

  DELETE FROM cita_medicamento WHERE cod_cita = p_cod_cita;
  DELETE FROM citas WHERE cod_cita = p_cod_cita;

  IF ROW_COUNT() = 0 THEN
    ROLLBACK;
    CALL sp_log_error('sp_cita_delete','citas',404,'No existe el cod_cita a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el cod_cita a eliminar';
  END IF;

  COMMIT;
END$$

CREATE PROCEDURE sp_cita_get(IN p_cod_cita VARCHAR(10))
BEGIN
  SELECT c.*,
         p.nombre_paciente, p.apellido_paciente,
         m.nombre_medico,
         h.hospital_sede,
         td.diagnostico
  FROM citas c
  JOIN paciente p ON p.paciente_id = c.paciente_id
  JOIN medico m ON m.medico_id = c.medico_id
  JOIN hospital h ON h.id_hospital = c.id_hospital
  JOIN tipos_diagnosticos td ON td.id_diagnostico = c.id_diagnostico
  WHERE c.cod_cita = p_cod_cita;
END$$

CREATE PROCEDURE sp_cita_list()
BEGIN
  SELECT * FROM citas ORDER BY fecha_cita, cod_cita;
END$$

DELIMITER ;

-- -------------------------
-- I) CITA_MEDICAMENTO 
-- -------------------------
DROP PROCEDURE IF EXISTS sp_cita_medicamento_create;
DROP PROCEDURE IF EXISTS sp_cita_medicamento_update;
DROP PROCEDURE IF EXISTS sp_cita_medicamento_delete;
DROP PROCEDURE IF EXISTS sp_cita_medicamento_get;
DROP PROCEDURE IF EXISTS sp_cita_medicamento_list;
DROP PROCEDURE IF EXISTS sp_cita_medicamento_list_by_cita;

DELIMITER $$

CREATE PROCEDURE sp_cita_medicamento_create(
  IN p_cod_cita VARCHAR(10),
  IN p_medicamentos_id VARCHAR(10),
  IN p_dosis VARCHAR(20)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_cita_medicamento_create','cita_medicamento',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_cita_medicamento_create: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  INSERT INTO cita_medicamento(cod_cita, medicamentos_id, dosis_medicamento)
  VALUES (p_cod_cita, p_medicamentos_id, p_dosis);
END$$

CREATE PROCEDURE sp_cita_medicamento_update(
  IN p_cod_cita VARCHAR(10),
  IN p_medicamentos_id VARCHAR(10),
  IN p_dosis VARCHAR(20)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_cita_medicamento_update','cita_medicamento',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_cita_medicamento_update: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  UPDATE cita_medicamento
  SET dosis_medicamento = p_dosis
  WHERE cod_cita = p_cod_cita AND medicamentos_id = p_medicamentos_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_cita_medicamento_update','cita_medicamento',404,'No existe el registro cita_medicamento a actualizar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el registro cita_medicamento a actualizar';
  END IF;
END$$

CREATE PROCEDURE sp_cita_medicamento_delete(
  IN p_cod_cita VARCHAR(10),
  IN p_medicamentos_id VARCHAR(10)
)
BEGIN
  DECLARE v_errno INT DEFAULT NULL;
  DECLARE v_msg TEXT DEFAULT NULL;
  DECLARE v_fullmsg TEXT DEFAULT NULL;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
    CALL sp_log_error('sp_cita_medicamento_delete','cita_medicamento',v_errno,v_msg);
    SET v_fullmsg = CONCAT('Error en sp_cita_medicamento_delete: ', v_msg);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_fullmsg;
  END;

  DELETE FROM cita_medicamento
  WHERE cod_cita = p_cod_cita AND medicamentos_id = p_medicamentos_id;

  IF ROW_COUNT() = 0 THEN
    CALL sp_log_error('sp_cita_medicamento_delete','cita_medicamento',404,'No existe el registro cita_medicamento a eliminar');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe el registro cita_medicamento a eliminar';
  END IF;
END$$

CREATE PROCEDURE sp_cita_medicamento_get(
  IN p_cod_cita VARCHAR(10),
  IN p_medicamentos_id VARCHAR(10)
)
BEGIN
  SELECT cm.cod_cita, cm.medicamentos_id, me.nombre_medicamento, cm.dosis_medicamento
  FROM cita_medicamento cm
  JOIN medicamentos me ON me.medicamentos_id = cm.medicamentos_id
  WHERE cm.cod_cita = p_cod_cita AND cm.medicamentos_id = p_medicamentos_id;
END$$

CREATE PROCEDURE sp_cita_medicamento_list()
BEGIN
  SELECT cm.cod_cita, cm.medicamentos_id, me.nombre_medicamento, cm.dosis_medicamento
  FROM cita_medicamento cm
  JOIN medicamentos me ON me.medicamentos_id = cm.medicamentos_id
  ORDER BY cm.cod_cita, cm.medicamentos_id;
END$$

CREATE PROCEDURE sp_cita_medicamento_list_by_cita(IN p_cod_cita VARCHAR(10))
BEGIN
  SELECT cm.cod_cita, cm.medicamentos_id, me.nombre_medicamento, cm.dosis_medicamento
  FROM cita_medicamento cm
  JOIN medicamentos me ON me.medicamentos_id = cm.medicamentos_id
  WHERE cm.cod_cita = p_cod_cita
  ORDER BY cm.medicamentos_id;
END$$

DELIMITER ;

-- =========================================================
-- 5) FUNCIONES 
-- =========================================================
DROP FUNCTION IF EXISTS fn_num_doctores_por_facultad_id;
DELIMITER $$

CREATE FUNCTION fn_num_doctores_por_facultad_id(p_id_facultad VARCHAR(10))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total INT DEFAULT 0;

  SELECT COUNT(DISTINCT medico_id)
    INTO v_total
  FROM medico_facultad
  WHERE id_facultad = p_id_facultad;

  RETURN v_total;
END$$

DELIMITER ;

DROP FUNCTION IF EXISTS fn_num_doctores_por_especialidad;
DELIMITER $$

CREATE FUNCTION fn_num_doctores_por_especialidad(p_facultad_origen VARCHAR(100))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total INT DEFAULT 0;

  SELECT COUNT(DISTINCT mf.medico_id)
    INTO v_total
  FROM medico_facultad mf
  JOIN facultad f ON f.id_facultad = mf.id_facultad
  WHERE f.facultad_origen = p_facultad_origen;

  RETURN v_total;
END$$

DELIMITER ;

DROP FUNCTION IF EXISTS fn_total_pacientes_por_medico;
DELIMITER $$

CREATE FUNCTION fn_total_pacientes_por_medico(p_medico_id VARCHAR(10))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total INT DEFAULT 0;

  SELECT COUNT(DISTINCT paciente_id)
    INTO v_total
  FROM citas
  WHERE medico_id = p_medico_id;

  RETURN v_total;
END$$

DELIMITER ;

DROP FUNCTION IF EXISTS fn_total_pacientes_por_hospital_id;
DELIMITER $$

CREATE FUNCTION fn_total_pacientes_por_hospital_id(p_id_hospital VARCHAR(10))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total INT DEFAULT 0;

  SELECT COUNT(DISTINCT paciente_id)
    INTO v_total
  FROM citas
  WHERE id_hospital = p_id_hospital;

  RETURN v_total;
END$$

DELIMITER ;

DROP FUNCTION IF EXISTS fn_total_pacientes_por_sede;
DELIMITER $$

CREATE FUNCTION fn_total_pacientes_por_sede(p_hospital_sede VARCHAR(100))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total INT DEFAULT 0;

  SELECT COUNT(DISTINCT c.paciente_id)
    INTO v_total
  FROM citas c
  JOIN hospital h ON h.id_hospital = c.id_hospital
  WHERE h.hospital_sede = p_hospital_sede;

  RETURN v_total;
END$$

DELIMITER ;

USE sistema_medico;

-- =========================================
-- CONSULTAS BÁSICAS
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
-- PRUEBA DE FUNCIONES
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
-- CONSULTAS DE VALIDACIÓN DE INTEGRIDAD
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