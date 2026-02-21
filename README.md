# 🏥 Sistema Médico — Base de Datos Relacional Normalizada (MySQL)

> Base de datos relacional diseñada e implementada en **MySQL 8.0+**, normalizada hasta **Cuarta Forma Normal (4FN)**, incorporando procedimientos almacenados, funciones SQL, transacciones y manejo centralizado de errores.

---

## 🎯 Objetivo del Proyecto

Diseñar e implementar una base de datos relacional completamente normalizada para un **Sistema Médico**, aplicando principios formales de modelado entidad–relación, normalización hasta 4FN y buenas prácticas de programación SQL avanzada.

Este proyecto demuestra dominio en:

* Modelado conceptual y lógico
* Normalización progresiva (1FN–4FN)
* Implementación física en MySQL
* Programación SQL (Stored Procedures y Functions)
* Control de integridad y manejo de errores.

---

## 📌 Descripción General

El sistema gestiona información relacionada con:

* Pacientes
* Médicos
* Facultades
* Hospitales
* Tipos de Diagnóstico
* Medicamentos
* Citas médicas
* Relaciones muchos a muchos (N:M)

El diseño garantiza:

* ✔ Integridad referencial completa
* ✔ Eliminación de redundancias
* ✔ Ausencia de dependencias parciales, transitivas y multivaluadas
* ✔ Arquitectura modular y escalable

---

## 🛠 Tecnologías Utilizadas

| Tecnología            | Uso                                |
| --------------------- | ---------------------------------- |
| MySQL 8.0+            | Motor de base de datos             |
| SQL (DDL / DML)       | Definición y manipulación de datos |
| Stored Procedures     | Lógica CRUD encapsulada            |
| SQL Functions         | Reportes y métricas reutilizables  |
| Transacciones         | Control de consistencia            |
| Normalización 1FN–4FN | Eliminación de anomalías           |

---

## 📂 Estructura del Proyecto

```
TAREA_SISTEMA_MEDICO/
│
├── README.md
│
├── Docs/
│   ├── El diagrama UML ER.png
│   ├── Modelo_Entidad_Relacion.png
│   ├── Modelo_Fisico.sql
│   └── Normalizacion/
│       ├── Normalizacion(1FN-2FN).png
│       └── Normalizacion(3FN-4FN).png
│
├── Sql/
│   ├── 01_schema.sql
│   ├── 02_inserts.sql
│   ├── 03_procedimientos.sql
│   ├── 04_funciones.sql
│   └── script_completo.sql
│
└── Ejemplos/
    └── Consultas_Prueba.sql
```

---

## 🧠 Modelo Entidad–Relación

La entidad central del sistema es **Cita**, que se relaciona con:

* Paciente (1:N)
* Médico (1:N)
* Hospital (1:N)
* Tipo de Diagnóstico (1:N)

Relaciones adicionales:

* Médico ↔ Facultad (N:M)
* Cita ↔ Medicamento (N:M)

📄 Diagramas disponibles en:

* `Docs/El diagrama UML ER.png`
* `Docs/Modelo_Entidad_Relacion.png`
            o   
## 🧠 Modelo Entidad–Relación

### Diagrama UML ER
![Diagrama UML ER](https://i.ibb.co/fYyP0BY2/El-diagrama-UML-ER.png)

### Diagrama Entidad–Relación
![Diagrama Entidad Relación](https://i.ibb.co/xKzHP9nJ/Modelo-Entidad-Relacion.png)
---

## 🗂 Modelo Físico

El modelo físico implementa:

* 9 tablas normalizadas
* Claves primarias y foráneas
* Restricciones de integridad
* Tablas puente para relaciones N:M

📄 Archivo del esquema físico:

`Docs/Modelo_Fisico.sql`

---

## 🔄 Proceso de Normalización

El esquema fue normalizado progresivamente desde una estructura desnormalizada.

### 🔹 Primera Forma Normal (1FN)

Problemas detectados:

* Medicamentos almacenados como lista en una sola celda.
* Nombre completo almacenado en un único campo.

Soluciones aplicadas:

* Separación en `nombre_paciente` y `apellido_paciente`.
* Creación de la tabla puente `cita_medicamento`.

---

### 🔹 Segunda Forma Normal (2FN)

Con clave compuesta `(cod_cita, medicamentos_id)`:

* `dosis_medicamento` depende de ambas columnas ✅
* `nombre_medicamento` dependía solo de `medicamentos_id` ❌

Solución: separación de entidades en tablas independientes.

---

### 🔹 Tercera Forma Normal (3FN)

Dependencia transitiva identificada:

```
medico_id → facultad_origen → decano_facultad
```

Solución:

* Creación de tabla `facultad`.
* Gestión de relación mediante `medico_facultad`.

---

### 🔹 Cuarta Forma Normal (4FN)

Se eliminaron dependencias multivaluadas independientes mediante:

* `medico_facultad`
* `cita_medicamento`

Cada relación multivaluada se gestiona en su propia tabla puente, evitando productos cartesianos y redundancia.

---

## 🧱 Archivos SQL

### `01_schema.sql`

* Creación de base de datos
* Creación de tablas
* Claves primarias y foráneas
* Tabla `log_errores`

---

### `02_inserts.sql`

Datos de prueba representativos para todas las entidades.

---

### `03_procedimientos.sql`

Incluye:

* CRUD por entidad
* `sp_log_error`
* `DECLARE ... HANDLER`
* `SIGNAL SQLSTATE`
* `ROW_COUNT()`
* `COMMIT / ROLLBACK`

---

### `04_funciones.sql`

Funciones implementadas:

| Función                                | Descripción                                |
| -------------------------------------- | ------------------------------------------ |
| `fn_num_doctores_por_facultad_id()`    | Cantidad de médicos por facultad           |
| `fn_num_doctores_por_especialidad()`   | Cantidad de médicos por nombre de facultad |
| `fn_total_pacientes_por_medico()`      | Total de pacientes atendidos por un médico |
| `fn_total_pacientes_por_hospital_id()` | Total de pacientes por hospital            |
| `fn_total_pacientes_por_sede()`        | Total de pacientes por sede                |

---

### `script_completo.sql`

Ejecuta en orden:

```
Schema → Inserts → Procedimientos → Funciones
```

Ideal para despliegue completo.

---

## 🧪 Consultas de Prueba

Archivo:

`Ejemplos/Consultas_Prueba.sql`

Incluye:

* SELECT con múltiples JOIN
* Llamadas a procedimientos almacenados
* Invocación de funciones
* Validaciones de integridad

Ejemplo de uso:

```sql
CALL sp_crear_paciente('Carlos', 'Perez', '1995-03-10');
SELECT fn_total_pacientes_por_hospital_id(1);
```

---

## 🚀 Cómo Ejecutar

Requisito: MySQL 8.0+

### Ejecución completa

```sql
SOURCE Sql/script_completo.sql;
```

---

## ✅ Características Técnicas Destacadas

| Característica         | Implementación                           |
| ---------------------- | ---------------------------------------- |
| Normalización          | 1FN, 2FN, 3FN y 4FN                      |
| Integridad referencial | Claves foráneas en todas las relaciones  |
| Transacciones          | Operaciones críticas protegidas          |
| Manejo de errores      | `log_errores` + `sp_log_error`           |
| Modularidad            | Separación por responsabilidad           |
| SQL avanzado           | Stored Procedures + Functions + Handlers |

---

## 👤 Autor

**Julian Andres Santamaria Bustamante**

Proyecto académico enfocado en demostrar dominio en:

* Modelado entidad–relación
* Normalización formal hasta 4FN
* Programación SQL avanzada
* Integridad referencial
* Arquitectura modular y escalable

---


