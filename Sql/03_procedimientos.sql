-- =========================================================
-- 3) CRUD POR ENTIDAD
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
-- G) MEDICO_FACULTAD 
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