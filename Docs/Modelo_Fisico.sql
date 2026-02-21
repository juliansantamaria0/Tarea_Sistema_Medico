CREATE DATABASE IF NOT EXISTS sistema_medico;
USE sistema_medico;

DROP TABLE IF EXISTS cita_medicamento;
DROP TABLE IF EXISTS citas;
DROP TABLE IF EXISTS medico_facultad;
DROP TABLE IF EXISTS medicamentos;
DROP TABLE IF EXISTS tipos_diagnosticos;
DROP TABLE IF EXISTS hospital;
DROP TABLE IF EXISTS facultad;
DROP TABLE IF EXISTS medico;
DROP TABLE IF EXISTS paciente;

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
    medico_id VARCHAR(10),
    id_facultad VARCHAR(10),
    PRIMARY KEY (medico_id, id_facultad),
    FOREIGN KEY (medico_id) REFERENCES medico(medico_id),
    FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
);

CREATE TABLE citas (
    cod_cita VARCHAR(10) PRIMARY KEY,
    paciente_id VARCHAR(10) NOT NULL,
    medico_id VARCHAR(10) NOT NULL,
    fecha_cita DATE NOT NULL,
    id_diagnostico VARCHAR(10) NOT NULL,
    id_hospital VARCHAR(10) NOT NULL,

    FOREIGN KEY (paciente_id) REFERENCES paciente(paciente_id),
    FOREIGN KEY (medico_id) REFERENCES medico(medico_id),
    FOREIGN KEY (id_diagnostico) REFERENCES tipos_diagnosticos(id_diagnostico),
    FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
);

CREATE TABLE cita_medicamento (
    cod_cita VARCHAR(10),
    medicamentos_id VARCHAR(10),
    dosis_medicamento VARCHAR(20) NOT NULL,

    PRIMARY KEY (cod_cita, medicamentos_id),
    FOREIGN KEY (cod_cita) REFERENCES citas(cod_cita),
    FOREIGN KEY (medicamentos_id) REFERENCES medicamentos(medicamentos_id)
);

