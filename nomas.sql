--------------------------------------------------------------------------------------------
----------------------------Crear Tablas----------------------------------------------------
--------------------------------------------------------------------------------------------
CREATE TABLE CIUDAD(
	idCiudad NUMBER NOT NULL,
	descripcion VARCHAR(30) NOT NULL,
	CONSTRAINT ciudad_pk PRIMARY KEY (idCiudad)
);

CREATE TABLE COMUNA(
	idComuna NUMBER NOT NULL,
	descripcion VARCHAR2(30) NOT NULL,
	idCiudad NUMBER NOT NULL,
	CONSTRAINT comuna_pk PRIMARY KEY (idComuna),
	CONSTRAINT comuna_ciudad_fk FOREIGN KEY (idCiudad) REFERENCES CIUDAD(idCiudad)
);

CREATE TABLE TIPOUSUARIO(
	idTipoUsuario NUMBER NOT NULL,
	descripcion VARCHAR2(30),
	CONSTRAINT tipo_usuario_pk PRIMARY KEY(idTipoUsuario)
);

CREATE TABLE USUARIO(
	idUsuario NUMBER NOT NULL,
	usu VARCHAR2(30) NOT NULL,
	pass VARCHAR2(255) NOT NULL,
	estadoUsuario NUMBER NOT NULL,
	idTipoUsuario NUMBER NOT NULL,
	CONSTRAINT usuario_pk PRIMARY KEY (idUsuario),
	CONSTRAINT tipo_usuario_fk FOREIGN KEY (idTipoUsuario) REFERENCES TIPOUSUARIO(idTipoUsuario)
);

CREATE TABLE PROFESIONAL(
	idProfesional NUMBER NOT NULL,
	rut VARCHAR2(11) NOT NULL,
	nombre VARCHAR2(30) NOT NULL,
	apePaterno VARCHAR2(30) NOT NULL,
	apeMaterno VARCHAR2(30) NOT NULL,
	telefono VARCHAR2(12) NOT NULL,
	fecNacimiento DATE NOT NULL,
	idComuna NUMBER NOT NULL,
	idUsuario NUMBER NOT NULL,
	CONSTRAINT profesional_pk PRIMARY KEY(idProfesional),
	CONSTRAINT prof_usuario_fk FOREIGN KEY(idUsuario) REFERENCES USUARIO(idUsuario),
	CONSTRAINT prof_comuna_fk FOREIGN KEY (idComuna) REFERENCES COMUNA(idComuna)
);

CREATE TABLE UBICACION(
	idUbicacion NUMBER,
	direccion VARCHAR2(50) NOT NULL,
	fecha DATE NOT NULL,
	idProfesional NUMBER NOT NULL,
	CONSTRAINT ubicacion_pk PRIMARY KEY(idUbicacion),
	CONSTRAINT profecional_fk FOREIGN KEY(idProfesional) REFERENCES PROFESIONAL(idProfesional)
);

CREATE TABLE RUBRO(
	idRubro NUMBER NOT NULL,
	descripcion VARCHAR2(30) NOT NULL,
	CONSTRAINT rubro_pk PRIMARY KEY(idRubro)
);

CREATE TABLE CLIENTE(
	idCliente NUMBER NOT NULL,
	rut VARCHAR2(11) NOT NULL,
	nombre VARCHAR2(30) NOT NULL,
	apePaterno VARCHAR2(30) NOT NULL,
	apeMaterno VARCHAR2(30) NOT NULL,
	direccion VARCHAR2(50) NOT NULL,
	email VARCHAR2(100) NOT NULL,
	telefono VARCHAR2(12) NOT NULL,
	idComuna NUMBER NOT NULL,
	idRubro NUMBER NOT NULL,
	idUsuario NUMBER NOT NULL,
	CONSTRAINT cliente_pk PRIMARY KEY(idCliente),
	CONSTRAINT rubro_fk FOREIGN KEY(idRubro) REFERENCES RUBRO(idRubro),
	CONSTRAINT cli_usuario_fk FOREIGN KEY (idUsuario) REFERENCES USUARIO(idUsuario),
	CONSTRAINT cli_comuna_fk FOREIGN KEY (idComuna) REFERENCES COMUNA(idComuna)
);

--Estado 0-Cancelado 1-Disponible
CREATE TABLE PLANCONTRATADO(
	idPlan NUMBER NOT NULL,
	fecPlan DATE NOT NULL,
	precio NUMBER NOT NULL,
	sucursal VARCHAR2(100) NOT NULL,
	estado NUMBER NOT NULL,
	idCliente NUMBER NOT NULL,
	idProfesional NUMBER NOT NULL,
	CONSTRAINT plan_pk PRIMARY KEY(idPlan),
	CONSTRAINT cliente_fk FOREIGN KEY(idCliente) REFERENCES CLIENTE(idCliente),
	CONSTRAINT profesional_fk FOREIGN KEY(idProfesional) REFERENCES PROFESIONAL(idProfesional)
);

CREATE TABLE BOLETA(
	idBoleta NUMBER NOT NULL,
	fecPago DATE NOT NULL,
	fecLimite DATE NOT NULL, 
	monto NUMBER NOT NULL,
	estadoBoleta NUMBER NOT NULL,
	idPlan NUMBER NOT NULL,
	CONSTRAINT boleta_pk PRIMARY KEY(idBoleta),
	CONSTRAINT plan_fk FOREIGN KEY(idPlan) REFERENCES PLANCONTRATADO(idPlan)
);

CREATE TABLE SERVICIO(
	idServicio NUMBER NOT NULL,
	descripcion NUMBER NOT NULL,
	CONSTRAINT servicio_pk PRIMARY KEY (idServicio)
);

CREATE TABLE DETALLEBOLETA(
	idDetalleBoleta NUMBER NOT NULL,
	precio NUMBER NOT NULL,
	idBoleta NUMBER NOT NULL,
	idServicio NUMBER NOT NULL,
	CONSTRAINT idDetalleBoleta PRIMARY KEY(idDetalleBoleta),
	CONSTRAINT boleta_fk FOREIGN KEY (idBoleta) REFERENCES BOLETA(idBoleta),
	CONSTRAINT servicio_fk FOREIGN KEY (idServicio) REFERENCES SERVICIO(idServicio)
);

CREATE TABLE CHECKLIST(
	idCheck NUMBER NOT NULL,
	descripcion VARCHAR2(30) NOT NULL,
	idPlan NUMBER NOT NULL,
	CONSTRAINT check_pk PRIMARY KEY(idCheck),
	CONSTRAINT check_plan_fk FOREIGN KEY (idPlan) REFERENCES PLANCONTRATADO(idPlan)
);

CREATE TABLE MODIFICACIONCHECK(
	idModificacion NUMBER NOT NULL,
	fecha DATE NOT NULL,
	idCheck NUMBER NOT NULL,
	CONSTRAINT modcheck_pk PRIMARY KEY(idModificacion),
	CONSTRAINT mod_check_fk FOREIGN KEY (idCheck) REFERENCES CHECKLIST(idCheck)
);

--estado 0-Reprobado 1-Aprob
CREATE TABLE CHECKLISTREPORTE(
	idCheckReporte NUMBER NOT NULL,
	estadoCheck NUMBER NOT NULL,
	fecha DATE NOT NULL,
	mejora VARCHAR2(150) NOT NULL,
	idCheckList NUMBER NOT NULL,
	CONSTRAINT check_reporte_pk PRIMARY KEY(idCheckReporte),
	CONSTRAINT checklist_fk FOREIGN KEY(idCheckList) REFERENCES CHECKLIST(idCheck)
);

--descripcion: capacitacion extintores
CREATE TABLE CAPACITACION(
	idCapacitacion NUMBER NOT NULL,
	fecha DATE NOT NULL,
	descripcion VARCHAR2(200) NOT NULL,
	cantAsistentes NUMBER NOT NULL,
	idPlan NUMBER NOT NULL,
	CONSTRAINT capacitacion_pk PRIMARY KEY(idCapacitacion),
	CONSTRAINT capacitacion_plan_fk FOREIGN KEY (idPlan) REFERENCES PLANCONTRATADO(idPlan)
);

CREATE TABLE TIPOEVENTO(
	idTipoEvento NUMBER NOT NULL,
	descripcion VARCHAR2(30) NOT NULL,
	CONSTRAINT tipo_evento_pk PRIMARY KEY(idTipoEvento)
);

CREATE TABLE EVENTO(
	idEvento NUMBER NOT NULL,
	asesoria VARCHAR2(255) NOT NULL,
	fecha DATE NOT NULL,
	idTipoEvento NUMBER NOT NULL,
	idPlan NUMBER NOT NULL,
	CONSTRAINT evento_pk PRIMARY KEY(idEvento),
	CONSTRAINT tipo_evento_fk FOREIGN KEY (idTipoEvento) REFERENCES TIPOEVENTO(idTipoEvento),
	CONSTRAINT evento_plan_fk FOREIGN KEY (idPlan) REFERENCES PLANCONTRATADO(idPlan)
);

CREATE TABLE REPORTE(
	idReporte NUMBER NOT NULL,
	visitas NUMBER NOT NULL,
	capacitacion NUMBER NOT NULL,
	accidentes NUMBER NOT NULL,
	multas NUMBER NOT NULL,
	idUsuAdmin NUMBER NOT NULL,
	idCliente NUMBER NOT NULL,
	CONSTRAINT reporte_pk PRIMARY KEY(idReporte),
	CONSTRAINT reporte_usu_fk FOREIGN KEY (idUsuAdmin) REFERENCES USUARIO(idUsuario),
	CONSTRAINT reporte_cli_fk FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente)
);


  CREATE OR REPLACE PACKAGE "PKG_BOLETA" 
IS
PROCEDURE INSERTAR_BOLETA(idBoleta_c NUMBER,fecPago_c DATE,fecLimite_c DATE,monto_c NUMBER,estadoBoleta_c NUMBER,idPlan_c NUMBER);
PROCEDURE MODIFICAR_BOLETA(idBoleta_c NUMBER,fecPago_c DATE,fecLimite_c DATE,monto_c NUMBER,estadoBoleta_c NUMBER,idPlan_c NUMBER);
PROCEDURE ELIMINAR_BOLETA(idBoleta_c NUMBER);
END PKG_BOLETA;

/
--------------------------------------------------------
--  DDL for Package PKG_CAPACITACION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_CAPACITACION" 
IS
PROCEDURE INSERTAR_CAPACITACION(idCapacitacion_c NUMBER,fecha_c DATE,descripcion_c VARCHAR2,cantAsistentes_c NUMBER,idPlan_c NUMBER);
PROCEDURE MODIFICAR_CAPACITACION(idCapacitacion_c NUMBER,fecha_c DATE,descripcion_c VARCHAR2,cantAsistentes_c NUMBER,idPlan_c NUMBER);
PROCEDURE ELIMINAR_CAPACITACION(idCapacitacion_c NUMBER);
END PKG_CAPACITACION;

/
--------------------------------------------------------
--  DDL for Package PKG_CHECKLIST
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_CHECKLIST" 
IS
PROCEDURE INSERTAR_CHECKLIST(idCheck_c NUMBER,descripcion_c VARCHAR2,idPlan_c NUMBER);
PROCEDURE MODIFICAR_CHECKLIST(idCheck_c NUMBER,descripcion_c VARCHAR2,idPlan_c NUMBER);
PROCEDURE ELIMINAR_CHECKLIST(idCheck_c NUMBER);
END PKG_CHECKLIST;

/
--------------------------------------------------------
--  DDL for Package PKG_CHECKLISTREPORTE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_CHECKLISTREPORTE" 
IS
PROCEDURE INSERTAR_CHECKLISTREPORTE(idCheckReporte_c NUMBER,estadoCheck_c NUMBER,fecha_c DATE,mejora_c VARCHAR2,idCheckList_c NUMBER);
PROCEDURE MODIFICAR_CHECKLISTREPORTE(idCheckReporte_c NUMBER,estadoCheck_c NUMBER,fecha_c DATE,mejora_c VARCHAR2,idCheckList_c NUMBER);
PROCEDURE ELIMINAR_CHECKLISTREPORTE(idCheckReporte_c NUMBER);
END PKG_CHECKLISTREPORTE;

/
--------------------------------------------------------
--  DDL for Package PKG_CIUDAD
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_CIUDAD" 
IS
PROCEDURE INSERTAR_CIUDAD(idCiudad_c NUMBER,descripcion_c VARCHAR); 
PROCEDURE MODIFICAR_CIUDAD(idCiudad_c NUMBER,descripcion_c VARCHAR);
PROCEDURE ELIMINAR_CIUDAD(idCiudad_c NUMBER);
END PKG_CIUDAD;
--cuerpo--

/
--------------------------------------------------------
--  DDL for Package PKG_CLIENTE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_CLIENTE" 
IS
PROCEDURE INSERTAR_CLIENTE(idCliente_c NUMBER,rut_c VARCHAR2,nombre_c VARCHAR2,apePaterno_c VARCHAR2,apeMaterno_c VARCHAR2,direccion_c VARCHAR2,email_c VARCHAR2,telefono_c VARCHAR2,idComuna_c NUMBER,idRubro_c NUMBER,idUsuario_c NUMBER);
PROCEDURE MODIFICAR_CLIENTE(idCliente_c NUMBER,rut_c VARCHAR2,nombre_c VARCHAR2,apePaterno_c VARCHAR2,apeMaterno_c VARCHAR2,direccion_c VARCHAR2,email_c VARCHAR2,telefono_c VARCHAR2,idComuna_c NUMBER,idRubro_c NUMBER,idUsuario_c NUMBER);
PROCEDURE ELIMINAR_CLIENTE(idCliente_c NUMBER);
END PKG_CLIENTE;

/
--------------------------------------------------------
--  DDL for Package PKG_COMUNA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_COMUNA" 
IS
PROCEDURE INSERTAR_COMUNA(idComuna_c NUMBER,descripcion_c VARCHAR2,idCiudad_c NUMBER);
PROCEDURE MODIFICAR_COMUNA(idComuna_c NUMBER,descripcion_c VARCHAR2,idCiudad_c NUMBER);
PROCEDURE ELIMINAR_COMUNA(idComuna_c NUMBER);
END PKG_COMUNA ;

/
--------------------------------------------------------
--  DDL for Package PKG_DETALLEBOLETA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_DETALLEBOLETA" 
IS
PROCEDURE INSERTAR_DETALLEBOLETA(idDetalleBoleta_c NUMBER,precio_c NUMBER,idBoleta_c NUMBER,idServicio_c NUMBER);
PROCEDURE MODIFICAR_DETALLEBOLETA(idDetalleBoleta_c NUMBER,precio_c NUMBER,idBoleta_c NUMBER,idServicio_c NUMBER);
PROCEDURE ELIMINAR_DETALLEBOLETA(idDetalleBoleta_c NUMBER);
END PKG_DETALLEBOLETA;

/
--------------------------------------------------------
--  DDL for Package PKG_EVENTO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_EVENTO" 
IS
PROCEDURE INSERTAR_EVENTO(idEvento_c NUMBER,asesoria_c VARCHAR2,fecha_c DATE,idTipoEvento_c NUMBER,idPlan_c NUMBER);
PROCEDURE MODIFICAR_EVENTO(idEvento_c NUMBER,asesoria_c VARCHAR2,fecha_c DATE,idTipoEvento_c NUMBER,idPlan_c NUMBER);
PROCEDURE ELIMINAR_EVENTO(idEvento_c NUMBER);
END PKG_EVENTO;

/
--------------------------------------------------------
--  DDL for Package PKG_MODIFICACIONCHECK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_MODIFICACIONCHECK" 
IS
PROCEDURE INSERTAR_MODIFICACIONCHECK(idModificacion_c NUMBER,fecha_c DATE,idCheck_c NUMBER);
PROCEDURE MODIFICAR_MODIFICACIONCHECK(idModificacion_c NUMBER,fecha_c DATE,idCheck_c NUMBER);
PROCEDURE ELIMINAR_MODIFICACIONCHECK(idModificacion_c NUMBER);
END PKG_MODIFICACIONCHECK;

/
--------------------------------------------------------
--  DDL for Package PKG_PLANCONTRATADO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_PLANCONTRATADO" 
IS
PROCEDURE INSERTAR_PLANCONTRATADO(idPlan_c NUMBER,fecPlan_c DATE,precio_c NUMBER,sucursal_c VARCHAR2,estado_c NUMBER,idCliente_c NUMBER,idProfesional_c NUMBER);
PROCEDURE MODIFICAR_PLANCONTRATADO(idPlan_c NUMBER,fecPlan_c DATE,precio_c NUMBER,sucursal_c VARCHAR2,estado_c NUMBER,idCliente_c NUMBER,idProfesional_c NUMBER);
PROCEDURE ELIMINAR_PLANCONTRATADO(idPlan_c NUMBER);
END PKG_PLANCONTRATADO;

/
--------------------------------------------------------
--  DDL for Package PKG_PROFESIONAL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_PROFESIONAL" 
IS
PROCEDURE INSERTAR_PROFESIONAL(idProfesional_c NUMBER,rut_c VARCHAR2,nombre_c VARCHAR2,apePaterno_c VARCHAR2,apeMaterno_c VARCHAR2,telefono_c VARCHAR2,fecNacimiento_c DATE,idComuna_c NUMBER,idUbicacion_c NUMBER,idUsuario_c NUMBER);
PROCEDURE MODIFICAR_PROFESIONAL(idProfesional_c NUMBER,rut_c VARCHAR2,nombre_c VARCHAR2,apePaterno_c VARCHAR2,apeMaterno_c VARCHAR2,telefono_c VARCHAR2,fecNacimiento_c DATE,idComuna_c NUMBER,idUbicacion_c NUMBER,idUsuario_c NUMBER);
PROCEDURE ELIMINAR_PROFESIONAL(idProfesional_c NUMBER);
END PKG_PROFESIONAL;

/
--------------------------------------------------------
--  DDL for Package PKG_REPORTE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_REPORTE" 
IS
PROCEDURE INSERTAR_REPORTE(idReporte_c NUMBER,visitas_c NUMBER,capacitacion_c NUMBER,accidentes_c NUMBER,multas_c NUMBER,idUsuAdmin_c NUMBER,idCliente_c NUMBER);
PROCEDURE MODIFICAR_REPORTE(idReporte_c NUMBER,visitas_c NUMBER,capacitacion_c NUMBER,accidentes_c NUMBER,multas_c NUMBER,idUsuAdmin_c NUMBER,idCliente_c NUMBER);
PROCEDURE ELIMINAR_REPORTE(idReporte_c NUMBER);
END PKG_REPORTE;

/
--------------------------------------------------------
--  DDL for Package PKG_RUBRO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_RUBRO" 
IS
PROCEDURE INSERTAR_RUBRO(idRubro_c NUMBER,descripcion_c VARCHAR2);
PROCEDURE MODIFICAR_RUBRO(idRubro_c NUMBER,descripcion_c VARCHAR2);
PROCEDURE ELIMINAR_RUBRO(idRubro_c NUMBER);
END PKG_RUBRO;

/
--------------------------------------------------------
--  DDL for Package PKG_SERVICIO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_SERVICIO" 
IS
PROCEDURE INSERTAR_SERVICIO(idServicio_c NUMBER,descripcion_c NUMBER);
PROCEDURE MODIFICAR_SERVICIO(idServicio_c NUMBER,descripcion_c NUMBER);
PROCEDURE ELIMINAR_SERVICIO(idServicio_c NUMBER);
END PKG_SERVICIO;

/
--------------------------------------------------------
--  DDL for Package PKG_TIPOEVENTO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_TIPOEVENTO" 
IS
PROCEDURE INSERTAR_TIPOEVENTO(idTipoEvento_c NUMBER,descripcion_c VARCHAR2);
PROCEDURE MODIFICAR_TIPOEVENTO(idTipoEvento_c NUMBER,descripcion_c VARCHAR2);
PROCEDURE ELIMINAR_TIPOEVENTO(idTipoEvento_c NUMBER);
END PKG_TIPOEVENTO;

/
--------------------------------------------------------
--  DDL for Package PKG_TIPOUSUARIO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_TIPOUSUARIO" 
IS
PROCEDURE INSERTAR_TIPOUSUARIO(idTipoUsuario_c NUMBER,descripcion_c VARCHAR);
PROCEDURE MODIFICAR_TIPOUSUARIO(idTipoUsuario_c NUMBER,descripcion_c VARCHAR);
PROCEDURE ELIMINAR_TIPOUSUARIO(idTipoUsuario_c NUMBER);
END PKG_TIPOUSUARIO;

/
--------------------------------------------------------
--  DDL for Package PKG_UBICACION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_UBICACION" 
is
PROCEDURE INSERTAR_UBICACION(idUbicacion_c NUMBER,direccion_c VARCHAR2,fecha_c DATE);
PROCEDURE MODIFICAR_UBICACION(idUbicacion_c NUMBER,direccion_c VARCHAR2,fecha_c DATE);
PROCEDURE ELIMINAR_UBICACION(idUbicacion_c NUMBER);
END PKG_UBICACION;

/
--------------------------------------------------------
--  DDL for Package PKG_USUARIO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_USUARIO" 
IS
PROCEDURE INSERTAR_USUARIO(idUsuario_c NUMBER,user_c VARCHAR2,pass_c VARCHAR2,estadoUsuario_c NUMBER,idTipoUsuario_c NUMBER);
PROCEDURE MODIFICAR_USUARIO(idUsuario_c NUMBER,user_c VARCHAR2,pass_c VARCHAR2,estadoUsuario_c NUMBER,idTipoUsuario_c NUMBER);
PROCEDURE ELIMINAR_USUARIO(idUsuario_c NUMBER);
END PKG_USUARIO;

/
--------------------------------------------------------
--  DDL for Package Body PKG_BOLETA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_BOLETA" 
IS

PROCEDURE INSERTAR_BOLETA(idBoleta_c NUMBER,fecPago_c DATE,fecLimite_c DATE,monto_c NUMBER,estadoBoleta_c NUMBER,idPlan_c NUMBER)
IS
BEGIN
INSERT INTO BOLETA VALUES (idBoleta_c,fecPago_c,fecLimite_c,monto_c,estadoBoleta_c,idPlan_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_BOLETA;

PROCEDURE MODIFICAR_BOLETA(idBoleta_c NUMBER,fecPago_c DATE,fecLimite_c DATE,monto_c NUMBER,estadoBoleta_c NUMBER,idPlan_c NUMBER)
IS
BEGIN
UPDATE BOLETA
SET
fecPago = fecPago_c,
fecLimite = fecLimite_c,
monto = monto_c,
estadoBoleta = estadoBoleta_c,
idPlan = idPlan_c
WHERE
idBoleta = idBoleta_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_BOLETA;

PROCEDURE ELIMINAR_BOLETA(idBoleta_c NUMBER)
IS
BEGIN
DELETE FROM BOLETA
WHERE
idBoleta = idBoleta_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_BOLETA;

END PKG_BOLETA;

/
--------------------------------------------------------
--  DDL for Package Body PKG_CAPACITACION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_CAPACITACION" 
IS

PROCEDURE INSERTAR_CAPACITACION(idCapacitacion_c NUMBER,fecha_c DATE,descripcion_c VARCHAR2,cantAsistentes_c NUMBER,idPlan_c NUMBER)
IS
BEGIN
INSERT INTO CAPACITACION VALUES (idCapacitacion_c,fecha_c,descripcion_c,cantAsistentes_c,idPlan_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_CAPACITACION;

PROCEDURE MODIFICAR_CAPACITACION(idCapacitacion_c NUMBER,fecha_c DATE,descripcion_c VARCHAR2,cantAsistentes_c NUMBER,idPlan_c NUMBER)
IS
BEGIN
UPDATE CAPACITACION
SET
fecha = fecha_c,
descripcion = descripcion_c,
cantAsistentes = cantAsistentes_c,
idPlan = idPlan_c
WHERE
idCapacitacion = idCapacitacion_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_CAPACITACION;

PROCEDURE ELIMINAR_CAPACITACION(idCapacitacion_c NUMBER)
IS
BEGIN
DELETE FROM CAPACITACION
WHERE
idCapacitacion = idCapacitacion_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_CAPACITACION;

END PKG_CAPACITACION;

/
--------------------------------------------------------
--  DDL for Package Body PKG_CHECKLIST
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_CHECKLIST" 
IS

PROCEDURE INSERTAR_CHECKLIST(idCheck_c NUMBER,descripcion_c VARCHAR2,idPlan_c NUMBER)
IS
BEGIN
INSERT INTO CHECKLIST VALUES (idCheck_c,descripcion_c,idPlan_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_CHECKLIST;

PROCEDURE MODIFICAR_CHECKLIST(idCheck_c NUMBER,descripcion_c VARCHAR2,idPlan_c NUMBER)
IS
BEGIN
UPDATE CHECKLIST
SET
descripcion = descripcion_c,
idPlan = idPlan_c
WHERE
idCheck = idCheck_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_CHECKLIST;

PROCEDURE ELIMINAR_CHECKLIST(idCheck_c NUMBER)
IS
BEGIN
DELETE FROM CHECKLIST
WHERE
idCheck = idCheck_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_CHECKLIST;

END PKG_CHECKLIST;

/
--------------------------------------------------------
--  DDL for Package Body PKG_CHECKLISTREPORTE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_CHECKLISTREPORTE" 
IS

PROCEDURE INSERTAR_CHECKLISTREPORTE(idCheckReporte_c NUMBER,estadoCheck_c NUMBER,fecha_c DATE,mejora_c VARCHAR2,idCheckList_c NUMBER)
IS
BEGIN
INSERT INTO CHECKLISTREPORTE VALUES (idCheckReporte_c,estadoCheck_c,fecha_c,mejora_c,idCheckList_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_CHECKLISTREPORTE;

PROCEDURE MODIFICAR_CHECKLISTREPORTE(idCheckReporte_c NUMBER,estadoCheck_c NUMBER,fecha_c DATE,mejora_c VARCHAR2,idCheckList_c NUMBER)
IS
BEGIN
UPDATE CHECKLISTREPORTE
SET
estadoCheck = estadoCheck_c,
fecha = fecha_c,
mejora = mejora_c,
idCheckList = idCheckList_c
WHERE
idCheckReporte = idCheckReporte_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_CHECKLISTREPORTE;

PROCEDURE ELIMINAR_CHECKLISTREPORTE(idCheckReporte_c NUMBER)
IS
BEGIN
DELETE FROM CHECKLISTREPORTE
WHERE
idCheckReporte = idCheckReporte_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_CHECKLISTREPORTE;

END PKG_CHECKLISTREPORTE;

/
--------------------------------------------------------
--  DDL for Package Body PKG_CIUDAD
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_CIUDAD" 
IS
PROCEDURE INSERTAR_CIUDAD(idCiudad_c NUMBER,descripcion_c VARCHAR)
IS
BEGIN
INSERT INTO CIUDAD VALUES (
            idCiudad_c,descripcion_c
        ); 

COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_CIUDAD;

PROCEDURE MODIFICAR_CIUDAD(idCiudad_c NUMBER,descripcion_c VARCHAR)
IS
BEGIN
UPDATE CIUDAD
SET
descripcion = descripcion_c
WHERE
idCiudad = idCiudad_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_CIUDAD;



PROCEDURE ELIMINAR_CIUDAD(idCiudad_c NUMBER)
IS
BEGIN
DELETE FROM CIUDAD
WHERE
idCiudad = idCiudad_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_CIUDAD;

END PKG_CIUDAD;



/
--------------------------------------------------------
--  DDL for Package Body PKG_CLIENTE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_CLIENTE" 
IS

PROCEDURE INSERTAR_CLIENTE(idCliente_c NUMBER,rut_c VARCHAR2,nombre_c VARCHAR2,apePaterno_c VARCHAR2,apeMaterno_c VARCHAR2,direccion_c VARCHAR2,email_c VARCHAR2,telefono_c VARCHAR2,idComuna_c NUMBER,idRubro_c NUMBER,idUsuario_c NUMBER)
IS
BEGIN
INSERT INTO CLIENTE VALUES (idCliente_c,rut_c,nombre_c,apePaterno_c,apeMaterno_c,direccion_c,email_c,telefono_c,idComuna_c,idRubro_c,idUsuario_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_CLIENTE;

PROCEDURE MODIFICAR_CLIENTE(idCliente_c NUMBER,rut_c VARCHAR2,nombre_c VARCHAR2,apePaterno_c VARCHAR2,apeMaterno_c VARCHAR2,direccion_c VARCHAR2,email_c VARCHAR2,telefono_c VARCHAR2,idComuna_c NUMBER,idRubro_c NUMBER,idUsuario_c NUMBER)
IS
BEGIN
UPDATE CLIENTE
SET
rut = rut_c,
nombre = nombre_c,
apePaterno = apePaterno_c,
apeMaterno = apeMaterno_c,
direccion = direccion_c,
email = email_c,
telefono = telefono_c,
idComuna = idComuna_c,
idRubro = idRubro_c,
idUsuario = idUsuario_c
WHERE
idCliente = idCliente_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_CLIENTE;


PROCEDURE ELIMINAR_CLIENTE(idCliente_c NUMBER)
IS
BEGIN
DELETE FROM CLIENTE
WHERE
idCliente = idCliente_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_CLIENTE;

END PKG_CLIENTE;

/
--------------------------------------------------------
--  DDL for Package Body PKG_COMUNA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_COMUNA" 
IS
PROCEDURE INSERTAR_COMUNA(idComuna_c NUMBER,descripcion_c VARCHAR2,idCiudad_c NUMBER)
IS
BEGIN
INSERT INTO COMUNA VALUES (
		idComuna_c,descripcion_c,idCiudad_c
	     ); 

COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_COMUNA;

PROCEDURE MODIFICAR_COMUNA(idComuna_c NUMBER,descripcion_c VARCHAR2,idCiudad_c NUMBER)
IS
BEGIN
UPDATE COMUNA
SET
descripcion = descripcion_c,
idCiudad = idCiudad_c
WHERE
idComuna = idComuna_c;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_COMUNA;


PROCEDURE ELIMINAR_COMUNA(idComuna_c NUMBER)
IS
BEGIN
DELETE FROM COMUNA
WHERE
idComuna = idComuna_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_COMUNA;

END PKG_COMUNA;

/
--------------------------------------------------------
--  DDL for Package Body PKG_DETALLEBOLETA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_DETALLEBOLETA" 
IS

PROCEDURE INSERTAR_DETALLEBOLETA(idDetalleBoleta_c NUMBER,precio_c NUMBER,idBoleta_c NUMBER,idServicio_c NUMBER)
IS
BEGIN
INSERT INTO DETALLEBOLETA VALUES (idDetalleBoleta_c,precio_c,idBoleta_c,idServicio_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_DETALLEBOLETA;

PROCEDURE MODIFICAR_DETALLEBOLETA(idDetalleBoleta_c NUMBER,precio_c NUMBER,idBoleta_c NUMBER,idServicio_c NUMBER)
IS
BEGIN
UPDATE DETALLEBOLETA
SET
precio = precio_c,
idBoleta = idBoleta_c,
idServicio = idServicio_c
WHERE
idDetalleBoleta = idDetalleBoleta_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_DETALLEBOLETA;

PROCEDURE ELIMINAR_DETALLEBOLETA(idDetalleBoleta_c NUMBER)
IS
BEGIN
DELETE FROM DETALLEBOLETA
WHERE
idDetalleBoleta = idDetalleBoleta_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_DETALLEBOLETA;

END PKG_DETALLEBOLETA;

/
--------------------------------------------------------
--  DDL for Package Body PKG_EVENTO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_EVENTO" 
IS

PROCEDURE INSERTAR_EVENTO(idEvento_c NUMBER,asesoria_c VARCHAR2,fecha_c DATE,idTipoEvento_c NUMBER,idPlan_c NUMBER)
IS
BEGIN
INSERT INTO EVENTO VALUES (idEvento_c,asesoria_c,fecha_c,idTipoEvento_c,idPlan_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_EVENTO;

PROCEDURE MODIFICAR_EVENTO(idEvento_c NUMBER,asesoria_c VARCHAR2,fecha_c DATE,idTipoEvento_c NUMBER,idPlan_c NUMBER)
IS
BEGIN
UPDATE EVENTO
SET
asesoria = asesoria_c,
fecha = fecha_c,
idTipoEvento = idTipoEvento_c,
idPlan = idPlan_c
WHERE
idEvento = idEvento_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_EVENTO;

PROCEDURE ELIMINAR_EVENTO(idEvento_c NUMBER)
IS
BEGIN
DELETE FROM EVENTO
WHERE
idEvento = idEvento_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_EVENTO;

END PKG_EVENTO;

/
--------------------------------------------------------
--  DDL for Package Body PKG_MODIFICACIONCHECK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_MODIFICACIONCHECK" 
IS

PROCEDURE INSERTAR_MODIFICACIONCHECK(idModificacion_c NUMBER,fecha_c DATE,idCheck_c NUMBER)
IS
BEGIN
INSERT INTO MODIFICACIONCHECK VALUES (idModificacion_c,fecha_c,idCheck_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_MODIFICACIONCHECK;


PROCEDURE MODIFICAR_MODIFICACIONCHECK(idModificacion_c NUMBER,fecha_c DATE,idCheck_c NUMBER)
IS
BEGIN
UPDATE MODIFICACIONCHECK
SET
fecha = fecha_c,
idCheck = idCheck_c
WHERE
idModificacion = idModificacion_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_MODIFICACIONCHECK;


PROCEDURE ELIMINAR_MODIFICACIONCHECK(idModificacion_c NUMBER)
IS
BEGIN
DELETE FROM MODIFICACIONCHECK
WHERE
idModificacion = idModificacion_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_MODIFICACIONCHECK;

END PKG_MODIFICACIONCHECK;

/
--------------------------------------------------------
--  DDL for Package Body PKG_PLANCONTRATADO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_PLANCONTRATADO" 
IS
PROCEDURE INSERTAR_PLANCONTRATADO(idPlan_c NUMBER,fecPlan_c DATE,precio_c NUMBER,sucursal_c VARCHAR2,estado_c NUMBER,idCliente_c NUMBER,idProfesional_c NUMBER)
IS
BEGIN
INSERT INTO PLANCONTRATADO VALUES (idPlan_c,fecPlan_c,precio_c,sucursal_c,estado_c,idCliente_c,idProfesional_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_PLANCONTRATADO;

PROCEDURE MODIFICAR_PLANCONTRATADO(idPlan_c NUMBER,fecPlan_c DATE,precio_c NUMBER,sucursal_c VARCHAR2,estado_c NUMBER,idCliente_c NUMBER,idProfesional_c NUMBER)
IS
BEGIN
UPDATE PLANCONTRATADO
SET
fecPlan = fecPlan_c,
precio = precio_c,
sucursal = sucursal_c,
estado = estado_c,
idCliente = idCliente_c,
idProfesional = idProfesional_c
WHERE
idPlan = idPlan_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_PLANCONTRATADO;

PROCEDURE ELIMINAR_PLANCONTRATADO(idPlan_c NUMBER)
IS
BEGIN
DELETE FROM PLANCONTRATADO
WHERE
idPlan = idPlan_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_PLANCONTRATADO;

END PKG_PLANCONTRATADO;

/
--------------------------------------------------------
--  DDL for Package Body PKG_PROFESIONAL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_PROFESIONAL" 
IS
PROCEDURE INSERTAR_PROFESIONAL(idProfesional_c NUMBER,rut_c VARCHAR2,nombre_c VARCHAR2,apePaterno_c VARCHAR2,apeMaterno_c VARCHAR2,telefono_c VARCHAR2,fecNacimiento_c DATE,idComuna_c NUMBER,idUbicacion_c NUMBER,idUsuario_c NUMBER)
IS
BEGIN
INSERT INTO PROFESIONAL VALUES (idProfesional_c,rut_c,nombre_c,apePaterno_c,apeMaterno_c,telefono_c,fecNacimiento_c,idComuna_c,idUbicacion_c,idUsuario_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_PROFESIONAL;

PROCEDURE MODIFICAR_PROFESIONAL(idProfesional_c NUMBER,rut_c VARCHAR2,nombre_c VARCHAR2,apePaterno_c VARCHAR2,apeMaterno_c VARCHAR2,telefono_c VARCHAR2,fecNacimiento_c DATE,idComuna_c NUMBER,idUbicacion_c NUMBER,idUsuario_c NUMBER)
IS
BEGIN
UPDATE PROFESIONAL
SET
rut = rut_c,
nombre = nombre_c,
apePaterno = apePaterno_c,
apeMaterno = apeMaterno_c,
telefono = telefono_c,
fecNacimiento = fecNacimiento_c,
idComuna = idComuna_c,
idUbicacion = idUbicacion_c,
idUsuario = idUsuario_c
WHERE
idProfesional = idProfesional_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_PROFESIONAL;

PROCEDURE ELIMINAR_PROFESIONAL(idProfesional_c NUMBER)
IS
BEGIN
DELETE FROM PROFESIONAL
WHERE
idProfesional = idProfesional_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_PROFESIONAL;

END PKG_PROFESIONAL;

/
--------------------------------------------------------
--  DDL for Package Body PKG_REPORTE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_REPORTE" 
IS

PROCEDURE INSERTAR_REPORTE(idReporte_c NUMBER,visitas_c NUMBER,capacitacion_c NUMBER,accidentes_c NUMBER,multas_c NUMBER,idUsuAdmin_c NUMBER,idCliente_c NUMBER)
IS
BEGIN
INSERT INTO REPORTE VALUES (idReporte_c,visitas_c,capacitacion_c,accidentes_c,multas_c,idUsuAdmin_c,idCliente_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_REPORTE;

PROCEDURE MODIFICAR_REPORTE(idReporte_c NUMBER,visitas_c NUMBER,capacitacion_c NUMBER,accidentes_c NUMBER,multas_c NUMBER,idUsuAdmin_c NUMBER,idCliente_c NUMBER)
IS
BEGIN
UPDATE REPORTE
SET
visitas = visitas_c,
capacitacion = capacitacion_c,
accidentes = accidentes_c,
multas = multas_c,
idUsuAdmin = idUsuAdmin_c,
idCliente = idCliente_c
WHERE
idReporte = idReporte_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_REPORTE;


PROCEDURE ELIMINAR_REPORTE(idReporte_c NUMBER)
IS
BEGIN
DELETE FROM REPORTE
WHERE
idReporte = idReporte_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_REPORTE;

END PKG_REPORTE;

/
--------------------------------------------------------
--  DDL for Package Body PKG_RUBRO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_RUBRO" 
IS

PROCEDURE INSERTAR_RUBRO(idRubro_c NUMBER,descripcion_c VARCHAR2)
IS
BEGIN
INSERT INTO RUBRO VALUES (idRubro_c,descripcion_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_RUBRO;

PROCEDURE MODIFICAR_RUBRO(idRubro_c NUMBER,descripcion_c VARCHAR2)
IS
BEGIN
UPDATE RUBRO
SET
descripcion = descripcion_c
WHERE
idRubro = idRubro_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_RUBRO;

PROCEDURE ELIMINAR_RUBRO(idRubro_c NUMBER)
IS
BEGIN
DELETE FROM RUBRO
WHERE
idRubro = idRubro_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_RUBRO;

END PKG_RUBRO;

/
--------------------------------------------------------
--  DDL for Package Body PKG_SERVICIO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_SERVICIO" 
IS

PROCEDURE INSERTAR_SERVICIO(idServicio_c NUMBER,descripcion_c NUMBER)
IS
BEGIN
INSERT INTO SERVICIO VALUES (idServicio_c,descripcion_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_SERVICIO;

PROCEDURE MODIFICAR_SERVICIO(idServicio_c NUMBER,descripcion_c NUMBER)
IS
BEGIN
UPDATE SERVICIO
SET
descripcion = descripcion_c
WHERE
idServicio = idServicio_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_SERVICIO;

PROCEDURE ELIMINAR_SERVICIO(idServicio_c NUMBER)
IS
BEGIN
DELETE FROM SERVICIO
WHERE
idServicio = idServicio_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_SERVICIO;

END PKG_SERVICIO;

/
--------------------------------------------------------
--  DDL for Package Body PKG_TIPOEVENTO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_TIPOEVENTO" 
IS

PROCEDURE INSERTAR_TIPOEVENTO(idTipoEvento_c NUMBER,descripcion_c VARCHAR2)
IS
BEGIN
INSERT INTO TIPOEVENTO VALUES (idTipoEvento_c,descripcion_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_TIPOEVENTO;

PROCEDURE MODIFICAR_TIPOEVENTO(idTipoEvento_c NUMBER,descripcion_c VARCHAR2)
IS
BEGIN
UPDATE TIPOEVENTO
SET
descripcion = descripcion_c
WHERE
idTipoEvento = idTipoEvento_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_TIPOEVENTO;


PROCEDURE ELIMINAR_TIPOEVENTO(idTipoEvento_c NUMBER)
IS
BEGIN
DELETE FROM TIPOEVENTO
WHERE
idTipoEvento = idTipoEvento_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_TIPOEVENTO;

END PKG_TIPOEVENTO;

/
--------------------------------------------------------
--  DDL for Package Body PKG_TIPOUSUARIO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_TIPOUSUARIO" 
IS
PROCEDURE INSERTAR_TIPOUSUARIO(idTipoUsuario_c NUMBER,descripcion_c VARCHAR)
IS
BEGIN
INSERT INTO TIPOUSUARIO VALUES (
            idTipoUsuario_c,descripcion_c
        ); 

COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_TIPOUSUARIO;

PROCEDURE MODIFICAR_TIPOUSUARIO(idTipoUsuario_c NUMBER,descripcion_c VARCHAR)
IS
BEGIN
UPDATE TIPOUSUARIO
SET
descripcion = descripcion_c
WHERE
idTipoUsuario = idTipoUsuario_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_TIPOUSUARIO;

PROCEDURE ELIMINAR_TIPOUSUARIO(idTipoUsuario_c NUMBER)
IS
BEGIN
DELETE FROM TIPOUSUARIO
WHERE
idTipoUsuario = idTipoUsuario_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_TIPOUSUARIO;

END PKG_TIPOUSUARIO;

/
--------------------------------------------------------
--  DDL for Package Body PKG_UBICACION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_UBICACION" 
IS
PROCEDURE INSERTAR_UBICACION(idUbicacion_c NUMBER,direccion_c VARCHAR2,fecha_c DATE)
IS
BEGIN
INSERT INTO UBICACION VALUES (idUbicacion_c,direccion_c,fecha_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_UBICACION;

PROCEDURE MODIFICAR_UBICACION(idUbicacion_c NUMBER,direccion_c VARCHAR2,fecha_c DATE)
IS
BEGIN
UPDATE UBICACION
SET
direccion = direccion_c,
fecha = fecha_c
WHERE
idUbicacion = idUbicacion_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_UBICACION;

PROCEDURE ELIMINAR_UBICACION(idUbicacion_c NUMBER)
IS
BEGIN
DELETE FROM UBICACION
WHERE
idUbicacion = idUbicacion_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_UBICACION;

END PKG_UBICACION;

/
--------------------------------------------------------
--  DDL for Package Body PKG_USUARIO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_USUARIO" 
IS
PROCEDURE INSERTAR_USUARIO(idUsuario_c NUMBER,user_c VARCHAR2,pass_c VARCHAR2,estadoUsuario_c NUMBER,idTipoUsuario_c NUMBER)
IS
BEGIN
INSERT INTO USUARIO VALUES (idUsuario_c,user_c,pass_c,estadoUsuario_c,idTipoUsuario_c);
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END INSERTAR_USUARIO;

PROCEDURE MODIFICAR_USUARIO(idUsuario_c NUMBER,user_c VARCHAR2,pass_c VARCHAR2,estadoUsuario_c NUMBER,idTipoUsuario_c NUMBER)
IS
BEGIN
UPDATE USUARIO
SET
usu = user_c,
pass = pass_c,
estadoUsuario = estadoUsuario_c,
idTipoUsuario = idTipoUsuario_c
WHERE
idUsuario = idUsuario_c;
COMMIT;
EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END MODIFICAR_USUARIO;

PROCEDURE ELIMINAR_USUARIO(idUsuario_c NUMBER)
IS
BEGIN
DELETE FROM USUARIO
WHERE
idUsuario = idUsuario_c;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
            ROLLBACK;
END ELIMINAR_USUARIO;

END PKG_USUARIO;

/
