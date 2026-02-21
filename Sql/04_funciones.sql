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

