USE [GD1C2021]
GO

CREATE SCHEMA [BREAKFAST_CLUB]
GO

CREATE TABLE [BREAKFAST_CLUB].[CLIENTE] (
   [COD_CLIENTE] decimal(18,0) IDENTITY(1,1),
   [NOMBRE] nvarchar(255),
   [APELLIDO] nvarchar(255),
   [DNI] decimal(18,0),
   [FECHA_NAC] datetime2(3),
   [MAIL] nvarchar(255),
   [TELEFONO] int,
   [DIRECCION] nvarchar(255),
   CONSTRAINT COD_CLIENTE_PK PRIMARY KEY ([COD_CLIENTE])
);


CREATE TABLE [BREAKFAST_CLUB].[FACTURA](
	[NRO_FACTURA] decimal (18,0), 
	[FECHA] datetime2 (3),
	[COD_SUCURSAL] decimal (18,0),
	[COD_CLIENTE] decimal (18,0),
	CONSTRAINT NRO_FACTURA_PK PRIMARY KEY ([NRO_FACTURA])
);

CREATE TABLE [BREAKFAST_CLUB].[ACCESORIO] (
   [COD_ACCES] decimal(18,0),
   [DESCRIPCION] nvarchar(255),
   CONSTRAINT cod_accesorio_pk PRIMARY KEY ([COD_ACCES])
);

CREATE TABLE [BREAKFAST_CLUB].[ACCESORIO_X_FACTURA](
	[COD_ACCES_FACTURA] decimal (18,0) IDENTITY(1,1), 
	[NRO_FACTURA] decimal (18,0),
	[COD_ACCES] decimal (18,0),
	[PRECIO] decimal (18,2),
	[CANTIDAD] decimal (18,0),
	CONSTRAINT COD_ACCES_FACTURA_PK PRIMARY KEY ([COD_ACCES_FACTURA])
);


CREATE TABLE [BREAKFAST_CLUB].[CIUDAD](
	[COD_CIUDAD] decimal (18,0) IDENTITY(1,1),
	[NOMBRE] nvarchar(255),
	CONSTRAINT COD_CIUDAD_PK PRIMARY KEY ([COD_CIUDAD])
);

CREATE TABLE [BREAKFAST_CLUB].[SUCURSAL](
	[COD_SUCURSAL] decimal (18,0) IDENTITY(1,1),
	[COD_CIUDAD] decimal (18,0),
	[MAIL] nvarchar(255),
	[TELEFONO] decimal (18,0),
	[DIRECCION] nvarchar(255),
	CONSTRAINT COD_SUCURSAL_PK PRIMARY KEY ([COD_SUCURSAL])
);

CREATE TABLE [BREAKFAST_CLUB].[FABRICANTE](
	[COD_FABRICANTE] decimal (18,0) IDENTITY(1,1),
	[NOMBRE] nvarchar(255),
	CONSTRAINT FABRICANTE_PK PRIMARY KEY ([COD_FABRICANTE])
);

CREATE TABLE [BREAKFAST_CLUB].[GPU](
    [COD_GPU] decimal (18,0) IDENTITY(1,1),
    [CAPACIDAD] nvarchar(255),
    [MODELO] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0),
    [CHIPSET] nvarchar(50),
    [VELOCIDAD] nvarchar(50),
    CONSTRAINT GPU_PK PRIMARY KEY ([COD_GPU])
);

CREATE TABLE [BREAKFAST_CLUB].[CPU] (
    [COD_CPU] nvarchar(50),
    [CACHE] nvarchar(50),
    [CANT_HILOS] nvarchar(50),
	[COD_FABRICANTE] decimal(18,0),
    [VELOCIDAD] varchar(50),
    CONSTRAINT CPU_PK PRIMARY KEY ([COD_CPU])
);

CREATE TABLE [BREAKFAST_CLUB].[DISCO_RIGIDO] (
    [COD_DISCO] nvarchar(255),
    [TIPO] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0),
    [VELOCIDAD] nvarchar(255),
    CONSTRAINT DISCO_RIGIDO_PK PRIMARY KEY ([COD_DISCO])
);

CREATE TABLE [BREAKFAST_CLUB].[RAM] (
    [COD_RAM] nvarchar(255),
    [TIPO] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0),
    [VELOCIDAD] nvarchar(255),
    CONSTRAINT COD_RAM_PK PRIMARY KEY ([COD_RAM])
);

CREATE TABLE [BREAKFAST_CLUB].[PC] (
    [COD_PC] nvarchar(50),
    [ALTO] decimal(18,2),
    [ANCHO] decimal(18,2),
    [PROFUNDIDAD] decimal(18,2),
    [COD_CPU] nvarchar(50),
    [COD_GPU] decimal(18,0),
    [COD_RAM] nvarchar(255),
    [COD_DISCO] nvarchar(255),
    CONSTRAINT COD_PC_PK PRIMARY KEY ([COD_PC])
);


CREATE TABLE [BREAKFAST_CLUB].[ACCESORIO_X_COMPRA] (
   [COD_ACCES_COMPRA] decimal (18,0) IDENTITY(1,1),
   [NRO_COMPRA] decimal(18, 0),
   [COD_ACCES] decimal(18,0),
   [PRECIO] decimal(18,2),
   [CANTIDAD] decimal(18,0),
   CONSTRAINT cod_accesorio_x_compra_pk PRIMARY KEY ([COD_ACCES_COMPRA])
);


CREATE TABLE [BREAKFAST_CLUB].[COMPRA] (
   [NRO_COMPRA] decimal(18,0),
   [COD_SUCURSAL] decimal(18,0),
   [FECHA] DATETIME2 (3),
	CONSTRAINT nro_compra_pk PRIMARY KEY ([NRO_COMPRA])
);


CREATE TABLE [BREAKFAST_CLUB].[PC_X_COMPRA] (
   [COD_PC_COMPRA] decimal (18,0) IDENTITY(1,1),
   [NRO_COMPRA] decimal(18,0),
   [COD_PC] nvarchar(50),
   [PRECIO] decimal(18,2),
   [CANTIDAD] decimal(18,0),
   CONSTRAINT cod_pc_compra_pk PRIMARY KEY ([COD_PC_COMPRA])
);


CREATE TABLE [BREAKFAST_CLUB].[PC_X_FACTURA] (
   [COD_PC_FACTURA] decimal (18,0) IDENTITY(1,1),
   [NRO_FACTURA] decimal(18,0),
   [COD_PC] nvarchar(50),
   [PRECIO] decimal(18,2),
   [CANTIDAD] decimal(18,0),
   CONSTRAINT cod_pc_factura_pk PRIMARY KEY ([COD_PC_FACTURA])
);


ALTER TABLE [BREAKFAST_CLUB].[FACTURA]
ADD CONSTRAINT COD_SUCURSAL_FK FOREIGN KEY ([COD_SUCURSAL])
REFERENCES [BREAKFAST_CLUB].[SUCURSAL]([COD_SUCURSAL]);

ALTER TABLE [BREAKFAST_CLUB].[FACTURA]
ADD CONSTRAINT COD_CLIENTE_FK FOREIGN KEY ([COD_CLIENTE])
REFERENCES [BREAKFAST_CLUB].[CLIENTE]([COD_CLIENTE]);

ALTER TABLE [BREAKFAST_CLUB].[ACCESORIO_X_FACTURA]
ADD CONSTRAINT NRO_FACTURA_FK FOREIGN KEY ([NRO_FACTURA])
REFERENCES [BREAKFAST_CLUB].[FACTURA]([NRO_FACTURA]);

ALTER TABLE [BREAKFAST_CLUB].[ACCESORIO_X_FACTURA]
ADD CONSTRAINT COD_ACCES_FK FOREIGN KEY ([COD_ACCES])
REFERENCES [BREAKFAST_CLUB].[ACCESORIO]([COD_ACCES]);

ALTER TABLE [BREAKFAST_CLUB].[SUCURSAL]
ADD CONSTRAINT COD_CIUDAD_FK FOREIGN KEY ([COD_CIUDAD])
REFERENCES [BREAKFAST_CLUB].[CIUDAD]([COD_CIUDAD]);

ALTER TABLE [BREAKFAST_CLUB].[GPU]
ADD CONSTRAINT GPU_FABRICANTE_fk FOREIGN KEY ([COD_FABRICANTE])
REFERENCES [BREAKFAST_CLUB].[FABRICANTE]([COD_FABRICANTE]);

ALTER TABLE [BREAKFAST_CLUB].[CPU]
ADD CONSTRAINT CPU_FABRICANTE_fk FOREIGN KEY ([COD_FABRICANTE])
REFERENCES [BREAKFAST_CLUB].[FABRICANTE]([COD_FABRICANTE]);

ALTER TABLE [BREAKFAST_CLUB].[RAM]
ADD CONSTRAINT RAM_FABRICANTE_fk FOREIGN KEY ([COD_FABRICANTE])
REFERENCES [BREAKFAST_CLUB].[FABRICANTE]([COD_FABRICANTE]);

ALTER TABLE [BREAKFAST_CLUB].[DISCO_RIGIDO]
ADD CONSTRAINT DISCO_RIGIDO_FABRICANTE_fk FOREIGN KEY ([COD_FABRICANTE])
REFERENCES [BREAKFAST_CLUB].[FABRICANTE]([COD_FABRICANTE]);

ALTER TABLE [BREAKFAST_CLUB].[PC]
ADD CONSTRAINT COD_GPU_fk FOREIGN KEY ([COD_GPU])
REFERENCES [BREAKFAST_CLUB].[GPU]([COD_GPU]);

ALTER TABLE [BREAKFAST_CLUB].[PC]
ADD CONSTRAINT cod_cpu_fk FOREIGN KEY ([COD_CPU])
REFERENCES [BREAKFAST_CLUB].[CPU]([COD_CPU]);

ALTER TABLE [BREAKFAST_CLUB].[PC]
ADD CONSTRAINT cod_ram_fk FOREIGN KEY ([COD_RAM])
REFERENCES [BREAKFAST_CLUB].[RAM]([COD_RAM]);

ALTER TABLE [BREAKFAST_CLUB].[PC]
ADD CONSTRAINT cod_disco_fk FOREIGN KEY ([COD_DISCO])
REFERENCES [BREAKFAST_CLUB].[DISCO_RIGIDO]([COD_DISCO]);

ALTER TABLE [BREAKFAST_CLUB].[COMPRA]
ADD CONSTRAINT compra_cod_sucursal_fk FOREIGN KEY ([COD_SUCURSAL])
REFERENCES [BREAKFAST_CLUB].[SUCURSAL]([COD_SUCURSAL]);

ALTER TABLE [BREAKFAST_CLUB].[PC_X_COMPRA]
ADD CONSTRAINT pc_nro_compra_fk FOREIGN KEY ([NRO_COMPRA])
REFERENCES [BREAKFAST_CLUB].[COMPRA]([NRO_COMPRA]);

ALTER TABLE [BREAKFAST_CLUB].[PC_X_COMPRA]
ADD CONSTRAINT cod_pc_fk FOREIGN KEY ([COD_PC])
REFERENCES [BREAKFAST_CLUB].[PC]([COD_PC]);

ALTER TABLE [BREAKFAST_CLUB].[ACCESORIO_X_COMPRA]
ADD CONSTRAINT acc_nro_compra_fk FOREIGN KEY ([NRO_COMPRA])
REFERENCES [BREAKFAST_CLUB].[COMPRA]([NRO_COMPRA]);

ALTER TABLE [BREAKFAST_CLUB].[ACCESORIO_X_COMPRA]
ADD CONSTRAINT cod_accesorio_fk FOREIGN KEY ([COD_ACCES])
REFERENCES [BREAKFAST_CLUB].[ACCESORIO]([COD_ACCES]);


ALTER TABLE [BREAKFAST_CLUB].[PC_X_FACTURA]
ADD CONSTRAINT pc_nro_factura_fk FOREIGN KEY ([NRO_FACTURA])
REFERENCES [BREAKFAST_CLUB].[FACTURA]([NRO_FACTURA]);

ALTER TABLE [BREAKFAST_CLUB].[PC_X_FACTURA]
ADD CONSTRAINT pc_cod_pc_fk FOREIGN KEY ([COD_PC])
REFERENCES [BREAKFAST_CLUB].[PC]([COD_PC]);

GO

/* ACCESORIO */
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_ACCESORIO
AS
BEGIN TRANSACTION


INSERT INTO [BREAKFAST_CLUB].ACCESORIO 
SELECT DISTINCT  ACCESORIO_CODIGO, AC_DESCRIPCION 
FROM gd_esquema.Maestra 
WHERE ACCESORIO_CODIGO IS NOT NULL

COMMIT;
GO

/* FABRICANTES */
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_FABRICANTE
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].FABRICANTE 
SELECT DISTINCT DISCO_RIGIDO_FABRICANTE FROM gd_esquema.Maestra WHERE DISCO_RIGIDO_FABRICANTE IS NOT NULL
UNION 
SELECT DISTINCT MICROPROCESADOR_FABRICANTE FROM gd_esquema.Maestra WHERE MICROPROCESADOR_FABRICANTE IS NOT NULL
UNION
SELECT DISTINCT PLACA_VIDEO_FABRICANTE FROM gd_esquema.Maestra WHERE PLACA_VIDEO_FABRICANTE IS NOT NULL
UNION
SELECT DISTINCT MEMORIA_RAM_FABRICANTE FROM gd_esquema.Maestra WHERE MEMORIA_RAM_FABRICANTE IS NOT NULL

COMMIT;
GO


/* CIUDAD */
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_CIUDAD
AS
BEGIN TRANSACTION


INSERT INTO [BREAKFAST_CLUB].CIUDAD 
SELECT DISTINCT CIUDAD 
FROM gd_esquema.Maestra 
WHERE CIUDAD IS NOT NULL

COMMIT;
GO

/* SUCURSAL */
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_SUCURSAL
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].SUCURSAL 
SELECT CIUDAD.COD_CIUDAD,  MAESTRA.SUCURSAL_MAIL, MAESTRA.SUCURSAL_TEL,  MAESTRA.SUCURSAL_DIR
FROM   GD_ESQUEMA.MAESTRA MAESTRA, [BREAKFAST_CLUB].CIUDAD CIUDAD
WHERE  MAESTRA.CIUDAD = CIUDAD.NOMBRE AND MAESTRA.CIUDAD IS NOT NULL
GROUP BY CIUDAD.COD_CIUDAD,  MAESTRA.SUCURSAL_MAIL, MAESTRA.SUCURSAL_TEL,  MAESTRA.SUCURSAL_DIR

COMMIT;
GO

/* CLIENTE */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_CLIENTE
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].CLIENTE
SELECT DISTINCT CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DNI, CLIENTE_FECHA_NACIMIENTO, CLIENTE_MAIL, CLIENTE_TELEFONO, CLIENTE_DIRECCION 
FROM gd_esquema.Maestra
WHERE CLIENTE_NOMBRE IS NOT NULL AND CLIENTE_APELLIDO IS NOT NULL AND CLIENTE_DNI IS NOT NULL AND CLIENTE_FECHA_NACIMIENTO IS NOT NULL AND CLIENTE_MAIL IS NOT NULL 

COMMIT;
GO

/* DISCO RIGIDO */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_DISCO_RIGIDO
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].DISCO_RIGIDO 
SELECT DISTINCT M.DISCO_RIGIDO_CODIGO, M.DISCO_RIGIDO_TIPO, M.DISCO_RIGIDO_CAPACIDAD, F.COD_FABRICANTE, M.DISCO_RIGIDO_VELOCIDAD
FROM gd_esquema.Maestra M, BREAKFAST_CLUB.FABRICANTE F
WHERE  M.DISCO_RIGIDO_FABRICANTE = F.NOMBRE AND DISCO_RIGIDO_CODIGO IS NOT NULL

COMMIT;
GO

/* CPU */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_CPU
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].CPU 
SELECT DISTINCT M.MICROPROCESADOR_CODIGO, M.MICROPROCESADOR_CACHE, M.MICROPROCESADOR_CANT_HILOS, F.COD_FABRICANTE, M.MICROPROCESADOR_VELOCIDAD
FROM gd_esquema.Maestra M, BREAKFAST_CLUB.FABRICANTE F
WHERE  M.MICROPROCESADOR_FABRICANTE = F.NOMBRE AND MICROPROCESADOR_CODIGO IS NOT NULL

COMMIT;
GO

/* GPU */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_GPU
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].GPU
SELECT DISTINCT M.PLACA_VIDEO_CAPACIDAD, M.PLACA_VIDEO_MODELO, F.COD_FABRICANTE, M.PLACA_VIDEO_CHIPSET, M.PLACA_VIDEO_VELOCIDAD
FROM gd_esquema.Maestra M, BREAKFAST_CLUB.FABRICANTE F
WHERE  M.PLACA_VIDEO_FABRICANTE = F.NOMBRE AND PLACA_VIDEO_MODELO IS NOT NULL

COMMIT;
GO

/* RAM */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_RAM
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].RAM
SELECT DISTINCT M.MEMORIA_RAM_CODIGO, M.MEMORIA_RAM_TIPO, M.MEMORIA_RAM_CAPACIDAD, F.COD_FABRICANTE, M.MEMORIA_RAM_VELOCIDAD
FROM gd_esquema.Maestra M, BREAKFAST_CLUB.FABRICANTE F
WHERE  M.MEMORIA_RAM_FABRICANTE = F.NOMBRE AND MEMORIA_RAM_CODIGO IS NOT NULL

COMMIT;
GO

/* PC */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_PC
AS
BEGIN TRANSACTION 

INSERT INTO [BREAKFAST_CLUB].PC
SELECT MAESTRA.PC_CODIGO, MAESTRA.PC_ALTO, MAESTRA.PC_ANCHO, MAESTRA.PC_PROFUNDIDAD, MAESTRA.MICROPROCESADOR_CODIGO, GPU.COD_GPU, MAESTRA.MEMORIA_RAM_CODIGO, MAESTRA.DISCO_RIGIDO_CODIGO
FROM gd_esquema.Maestra MAESTRA, [BREAKFAST_CLUB].GPU GPU
WHERE MAESTRA.PLACA_VIDEO_MODELO = GPU.MODELO AND MAESTRA.PLACA_VIDEO_CAPACIDAD = GPU.CAPACIDAD
AND MAESTRA.PLACA_VIDEO_CHIPSET = GPU.CHIPSET AND MAESTRA.PLACA_VIDEO_VELOCIDAD = GPU.VELOCIDAD AND MAESTRA.PC_CODIGO IS NOT NULL
GROUP BY MAESTRA.PC_CODIGO, MAESTRA.PC_ALTO, MAESTRA.PC_ANCHO, MAESTRA.PC_PROFUNDIDAD, MAESTRA.MICROPROCESADOR_CODIGO, GPU.COD_GPU, MAESTRA.MEMORIA_RAM_CODIGO, MAESTRA.DISCO_RIGIDO_CODIGO

COMMIT;
GO

/* COMPRA */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_COMPRA
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].COMPRA
SELECT MAESTRA.COMPRA_NUMERO, SUCURSAL.COD_SUCURSAL, MAESTRA.COMPRA_FECHA
FROM gd_esquema.Maestra MAESTRA, [BREAKFAST_CLUB].SUCURSAL SUCURSAL 
WHERE MAESTRA.SUCURSAL_DIR = SUCURSAL.DIRECCION AND MAESTRA.COMPRA_NUMERO IS NOT NULL
GROUP BY MAESTRA.COMPRA_NUMERO, SUCURSAL.COD_SUCURSAL, MAESTRA.COMPRA_FECHA

COMMIT;
GO


/* FACTURA */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_FACTURA
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].FACTURA
SELECT MAESTRA.FACTURA_NUMERO, MAESTRA.FACTURA_FECHA, SUCURSAL.COD_SUCURSAL, CLIENTE.COD_CLIENTE
FROM gd_esquema.Maestra MAESTRA, [BREAKFAST_CLUB].SUCURSAL SUCURSAL, [BREAKFAST_CLUB].CLIENTE CLIENTE
WHERE MAESTRA.SUCURSAL_DIR = SUCURSAL.DIRECCION AND MAESTRA.CLIENTE_DNI = CLIENTE.DNI AND MAESTRA.CLIENTE_APELLIDO = CLIENTE.APELLIDO AND MAESTRA.FACTURA_NUMERO IS NOT NULL
GROUP BY MAESTRA.FACTURA_NUMERO, SUCURSAL.COD_SUCURSAL, MAESTRA.FACTURA_FECHA, CLIENTE.COD_CLIENTE

COMMIT;
GO

/* PC X COMPRA */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_PC_X_COMPRA
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].PC_X_COMPRA
SELECT MAESTRA.COMPRA_NUMERO, MAESTRA.PC_CODIGO, MAESTRA.COMPRA_PRECIO, MAESTRA.COMPRA_CANTIDAD
FROM gd_esquema.Maestra MAESTRA
WHERE MAESTRA.PC_CODIGO IS NOT NULL AND MAESTRA.COMPRA_NUMERO IS NOT NULL


COMMIT;
GO

/* PC X FACTURA */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_PC_X_FACTURA
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].PC_X_FACTURA
SELECT MAESTRA.FACTURA_NUMERO, MAESTRA.PC_CODIGO, PC_COMPRA.PRECIO * 1.2, 1
FROM gd_esquema.Maestra MAESTRA, (SELECT DISTINCT PRECIO, COD_PC
FROM [BREAKFAST_CLUB].PC_X_COMPRA) PC_COMPRA
WHERE MAESTRA.PC_CODIGO = PC_COMPRA.COD_PC AND MAESTRA.FACTURA_NUMERO IS NOT NULL

COMMIT;
GO

/* ACCESORIO X COMPRA */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_ACCESORIO_X_COMPRA
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].ACCESORIO_X_COMPRA
SELECT MAESTRA.COMPRA_NUMERO, MAESTRA.ACCESORIO_CODIGO, MAESTRA.COMPRA_PRECIO, MAESTRA.COMPRA_CANTIDAD
FROM gd_esquema.Maestra MAESTRA
WHERE MAESTRA.ACCESORIO_CODIGO IS NOT NULL AND MAESTRA.COMPRA_NUMERO IS NOT NULL


COMMIT;
GO

/* ACCESORIO X FACTURA */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_ACCESORIO_X_FACTURA
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].ACCESORIO_X_FACTURA
SELECT MAESTRA.FACTURA_NUMERO, MAESTRA.ACCESORIO_CODIGO, ACC_COMPRA.PRECIO*1.2, 1
FROM gd_esquema.Maestra MAESTRA, (SELECT DISTINCT PRECIO, COD_ACCES
FROM [BREAKFAST_CLUB].ACCESORIO_X_COMPRA) ACC_COMPRA
WHERE MAESTRA.ACCESORIO_CODIGO = ACC_COMPRA.COD_ACCES AND MAESTRA.FACTURA_NUMERO IS NOT NULL


COMMIT;
GO




EXEC [BREAKFAST_CLUB].PRC_INSERT_ACCESORIO
EXEC [BREAKFAST_CLUB].PRC_INSERT_CIUDAD
EXEC [BREAKFAST_CLUB].PRC_INSERT_FABRICANTE
EXEC [BREAKFAST_CLUB].PRC_INSERT_SUCURSAL
EXEC [BREAKFAST_CLUB].PRC_INSERT_CLIENTE
EXEC [BREAKFAST_CLUB].PRC_INSERT_DISCO_RIGIDO
EXEC [BREAKFAST_CLUB].PRC_INSERT_CPU
EXEC [BREAKFAST_CLUB].PRC_INSERT_GPU
EXEC [BREAKFAST_CLUB].PRC_INSERT_RAM
EXEC [BREAKFAST_CLUB].PRC_INSERT_PC
EXEC [BREAKFAST_CLUB].PRC_INSERT_COMPRA
EXEC [BREAKFAST_CLUB].PRC_INSERT_FACTURA
EXEC [BREAKFAST_CLUB].PRC_INSERT_PC_X_COMPRA
EXEC [BREAKFAST_CLUB].PRC_INSERT_PC_X_FACTURA
EXEC [BREAKFAST_CLUB].PRC_INSERT_ACCESORIO_X_COMPRA
EXEC [BREAKFAST_CLUB].PRC_INSERT_ACCESORIO_X_FACTURA