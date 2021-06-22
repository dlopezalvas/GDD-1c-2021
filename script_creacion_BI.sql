USE [GD1C2021]
GO


CREATE TABLE [BREAKFAST_CLUB].[BI_TIEMPO] (
  [COD_TIEMPO] decimal(18,0) IDENTITY (1,1),
  [MES] decimal(2,0),
  [ANIO] decimal(4,0),
  PRIMARY KEY ([COD_TIEMPO]),
  CONSTRAINT ck_tiempo_mes CHECK ([MES] BETWEEN 1 AND 12)
);

CREATE TABLE [BREAKFAST_CLUB].[BI_CLIENTE] (
  [COD_CLIENTE] decimal(18,0) NOT NULL,
  [NOMBRE] nvarchar(255) NOT NULL,
  [APELLIDO] nvarchar(255) NOT NULL,
  [DNI] decimal(18,0) NOT NULL,
  [EDAD] nvarchar(255) NOT NULL,
  [MAIL] nvarchar(255) ,
  [TELEFONO] int ,
  [DIRECCION] nvarchar(255),
  PRIMARY KEY ([COD_CLIENTE]),
  CONSTRAINT ck_cliente_edad CHECK ([EDAD] IN ('18-30anios','31-50anios', '>50anios'))
);

CREATE TABLE [BREAKFAST_CLUB].[BI_SUCURSAL](
	[COD_SUCURSAL] decimal (18,0),
	[COD_CIUDAD] decimal (18,0),
	[MAIL] nvarchar(255),
	[TELEFONO] decimal (18,0),
	[DIRECCION] nvarchar(255),
	CONSTRAINT COD_SUCURSAL_PK PRIMARY KEY ([COD_SUCURSAL])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_PC] (
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

CREATE TABLE [BREAKFAST_CLUB].[BI_FABRICANTE](
	[COD_FABRICANTE] decimal (18,0),
	[NOMBRE] nvarchar(255),
	CONSTRAINT FABRICANTE_PK PRIMARY KEY ([COD_FABRICANTE])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_GPU](
    [COD_GPU] decimal (18,0),
    [CAPACIDAD] nvarchar(255),
    [MODELO] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0),
    [CHIPSET] nvarchar(50),
    [VELOCIDAD] nvarchar(50),
    CONSTRAINT GPU_PK PRIMARY KEY ([COD_GPU])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_CPU] (
    [COD_CPU] nvarchar(50),
    [CACHE] nvarchar(50),
    [CANT_HILOS] nvarchar(50),
	[COD_FABRICANTE] decimal(18,0),
    [VELOCIDAD] varchar(50),
    CONSTRAINT CPU_PK PRIMARY KEY ([COD_CPU])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_DISCO_RIGIDO] (
    [COD_DISCO] nvarchar(255),
    [TIPO] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0),
    [VELOCIDAD] nvarchar(255),
    CONSTRAINT DISCO_RIGIDO_PK PRIMARY KEY ([COD_DISCO])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_RAM] (
    [COD_RAM] nvarchar(255),
    [TIPO] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0),
    [VELOCIDAD] nvarchar(255),
    CONSTRAINT COD_RAM_PK PRIMARY KEY ([COD_RAM])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_ACCESORIO] (
   [COD_ACCES] decimal(18,0),
   [DESCRIPCION] nvarchar(255),
   CONSTRAINT cod_accesorio_pk PRIMARY KEY ([COD_ACCES])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_HECHOS_PC] (
  [TIPO_TRANSACCION] nvarchar(50),
  [COD_PC] nvarchar(50),
  [COD_RAM] nvarchar(255),
  [COD_DISCO] nvarchar(255),
  [COD_GPU] decimal (18,0),
  [COD_CPU] nvarchar(50),
  [COD_SUCURSAL] decimal (18,0),
  [COD_CLIENTE] decimal(18,0),
  [COD_TIEMPO] decimal(18,0),
  [PRECIO] decimal(18,2) ,
  [CANTIDAD] decimal(18,0),
  [STOCK_DISPONIBLE] decimal(18,0) NULL,
  [TIEMPO_EN_STOCK] decimal(18,0)
  CONSTRAINT ck_tipo_transaccion_pc CHECK ([TIPO_PRODUCTO] IN ('Compra','Venta'))
);

CREATE TABLE [BREAKFAST_CLUB].[BI_HECHOS_ACCESORIOS] (
  [TIPO_TRANSACCION] nvarchar(50),
  [COD_ACCESORIO] nvarchar(255),
  [COD_SUCURSAL] decimal (18,0),
  [COD_TIEMPO] decimal(18,0),
  [PRECIO] decimal(18,2) ,
  [CANTIDAD] decimal(18,0),
  [COD_CLIENTE] decimal(18,0),
  [STOCK_DISPONIBLE] decimal(18,0) NULL,
  [TIEMPO_EN_STOCK] decimal(18,0)
  CONSTRAINT ck_tipo_transaccion_acc CHECK ([TIPO_PRODUCTO] IN ('Compra','Venta'))
);

GO


CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_CLIENTE
AS
BEGIN TRANSACTION

/* CLIENTE */

INSERT INTO [BREAKFAST_CLUB].[BI_CLIENTE] SELECT COD_CLIENTE, NOMBRE, APELLIDO, DNI, 
[BREAKFAST_CLUB].obtener_rango_edad(FECHA_NACIMIENTO), MAIL, TELEFONO, DIRECCION 
FROM [BREAKFAST_CLUB].[CLIENTE]

COMMIT;
GO

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_TIEMPO
AS
BEGIN TRANSACTION

INSERT INTO [BREAKFAST_CLUB].[BI_Tiempo] 
SELECT DISTINCT *
FROM 
(SELECT YEAR (F.FECHA) AS ANIO  , MONTH(F.FECHA) AS MES
FROM [BREAKFAST_CLUB].FACTURA F
UNION 
SELECT YEAR (C.FECHA) AS ANIO  , MONTH(C.FECHA) AS MES 
FROM [BREAKFAST_CLUB].COMPRA C) A ORDER BY ANIO, MES ASC

COMMIT;
GO


CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_HECHOS_PC
AS
BEGIN TRANSACTION

/*COMPRAS ACCESORIOS POR SUCURSAL POR MES */

BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_HECHOS_ACCESORIOS]
SELECT 'Compra', AxC.COD_ACCES, S.COD_SUCURSAL, [BREAKFAST_CLUB].obtener_codigo_tiempo(C.FECHA) AS COD_TIEMPO, AxC.PRECIO, SUM(CANTIDAD) AS CANTIDAD, NULL, NULL, NULL
FROM [BREAKFAST_CLUB].ACCESORIO_X_COMPRA AxC 
INNER JOIN [BREAKFAST_CLUB].COMPRA C ON AxC.NRO_COMPRA = C.NRO_COMPRA
INNER JOIN [BREAKFAST_CLUB].SUCURSAL S ON S.COD_SUCURSAL = C.COD_SUCURSAL
GROUP BY AxC.COD_ACCES, S.COD_SUCURSAL, AxC.PRECIO, C.FECHA
COMMIT;

BEGIN TRANSACTION
/*VENTAS ACCESORIOS POR SUCURSAL POR CLIENTE POR MES*/
INSERT INTO [BREAKFAST_CLUB].[BI_HECHOS_ACCESORIOS]
SELECT 'Venta', AxF.COD_ACCES, S.COD_SUCURSAL, [BREAKFAST_CLUB].obtener_codigo_tiempo(F.FECHA) AS COD_TIEMPO, AxF.PRECIO, SUM(CANTIDAD) AS CANT, COD_CLIENTE, NULL, NULL
FROM [BREAKFAST_CLUB].ACCESORIO_X_FACTURA AxF
INNER JOIN [BREAKFAST_CLUB].FACTURA F ON AxF.NRO_FACTURA = F.NRO_FACTURA
INNER JOIN [BREAKFAST_CLUB].SUCURSAL S ON S.COD_SUCURSAL = F.COD_SUCURSAL
GROUP BY S.COD_SUCURSAL, COD_CLIENTE,  AxF.COD_ACCES, AxF.PRECIO, F.FECHA
COMMIT;

COMMIT;
GO


CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_HECHOS_ACCESORIOS
AS
BEGIN TRANSACTION

/* COMPRAS PC POR SUCURSAL POR MES */
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_HECHOS_PC]
SELECT 'Compra', PC.COD_PC, COD_RAM, COD_DISCO, COD_GPU, COD_CPU, S.COD_SUCURSAL, NULL, [BREAKFAST_CLUB].obtener_codigo_tiempo(C.FECHA) AS COD_TIEMPO, PxC.PRECIO, SUM(CANTIDAD) AS CANTIDAD,  NULL, NULL
FROM [BREAKFAST_CLUB].PC_X_COMPRA PxC 
INNER JOIN [BREAKFAST_CLUB].COMPRA C ON PxC.NRO_COMPRA = C.NRO_COMPRA
INNER JOIN [BREAKFAST_CLUB].SUCURSAL S ON S.COD_SUCURSAL = C.COD_SUCURSAL
INNER JOIN [BREAKFAST_CLUB].PC PC ON PC.COD_PC = PxC.COD_PC
GROUP BY PC.COD_PC, COD_GPU,  COD_RAM, COD_DISCO, COD_CPU, S.COD_SUCURSAL, PxC.PRECIO, C.FECHA

COMMIT;

/* VENTAS PC POR SUCURSAL POR CLIENTE POR MES */
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_HECHOS_PC]
SELECT 'Venta', PC.COD_PC, COD_RAM, COD_DISCO, COD_GPU, COD_CPU, S.COD_SUCURSAL, F.COD_CLIENTE, [BREAKFAST_CLUB].obtener_codigo_tiempo(F.FECHA) AS COD_TIEMPO, PxF.PRECIO, SUM(CANTIDAD) AS CANTIDAD, NULL, NULL
FROM [BREAKFAST_CLUB].PC_X_FACTURA PxF 
INNER JOIN [BREAKFAST_CLUB].FACTURA F ON PxF.NRO_FACTURA = F.NRO_FACTURA
INNER JOIN [BREAKFAST_CLUB].SUCURSAL S ON S.COD_SUCURSAL = F.COD_SUCURSAL
INNER JOIN [BREAKFAST_CLUB].PC PC ON PC.COD_PC = PxF.COD_PC
GROUP BY PC.COD_PC, COD_GPU,  COD_RAM, COD_DISCO, COD_CPU, S.COD_SUCURSAL, PxF.PRECIO, F.FECHA
COMMIT;

COMMIT;
GO

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_SUCURSAL
AS
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_SUCURSAL]
SELECT * FROM [BREAKFAST_CLUB].[SUCURSAL]

COMMIT;
GO

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_PC
AS
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_PC]
SELECT * FROM [BREAKFAST_CLUB].[PC]

COMMIT;
GO

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_FABRICANTE
AS
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_FABRICANTE]
SELECT * FROM [BREAKFAST_CLUB].[FABRICANTE]

COMMIT;
GO
	
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_GPU
AS
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_GPU]
SELECT * FROM [BREAKFAST_CLUB].[GPU]

COMMIT;
GO
   
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_CPU
AS
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_CPU]
SELECT * FROM [BREAKFAST_CLUB].[CPU]

COMMIT;
GO
	
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_DISCO_RIGIDO
AS
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_DISCO_RIGIDO]
SELECT * FROM [BREAKFAST_CLUB].[DISCO_RIGIDO]

COMMIT;
GO
    
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_RAM
AS
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_RAM]
SELECT * FROM [BREAKFAST_CLUB].[RAM]

COMMIT;
GO
    
CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_ACCESORIO
AS
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_ACCESORIO]
SELECT * FROM [BREAKFAST_CLUB].[ACCESORIO]

COMMIT;
GO

EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_CLIENTE
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_SUCURSAL
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_PC
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_GPU
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_CPU
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_DISCO_RIGIDO
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_RAM
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_ACCESORIO
EXEC [BREAKFAST_CLUB].PRC_INSERT_HECHOS_PC
EXEC [BREAKFAST_CLUB].PRC_INSERT_HECHOS_ACCESORIOS

GO

CREATE FUNCTION [BREAKFAST_CLUB].obtener_rango_edad(@fecha DATETIME2(3))
RETURNS NVARCHAR(255) AS
BEGIN

	DECLARE @EDAD decimal(18,0) = year(getdate()) - year(@fecha)
	DECLARE @RETORNO NVARCHAR(255) = ' '
	
	SET @RETORNO = CASE
	WHEN (@EDAD >= 18 and @EDAD <= 30) THEN '18-30anios'
	WHEN @EDAD >= 31 and @EDAD <= 50 THEN '31-50anios'
	ELSE '>50anios'
	END

	RETURN @RETORNO

END
GO

CREATE FUNCTION [BREAKFAST_CLUB].obtener_codigo_tiempo(@fecha DATETIME2(3))
RETURNS decimal(18,0) AS
BEGIN

	DECLARE @RETORNO decimal(18,0) = 0
	
	SET @RETORNO =	(SELECT COD_TIEMPO from [BREAKFAST_CLUB].BI_TIEMPO 
					WHERE MES = MONTH(@fecha) AND ANIO = YEAR(@fecha))

	RETURN @RETORNO

END
GO







/*CPSAS QUE HAY QUE VER QUE ONDA*/

CREATE FUNCTION [BREAKFAST_CLUB].fx_obtener_tiempo_en_stock(@fechaInicialCod decimal(18,0), @fechaFinalCod decimal(18,0))
RETURNS decimal(18,0) AS
BEGIN
	DECLARE @MES_INICIAL decimal(18,0) = (SELECT TIEMPO_MES FROM BREAKFAST_CLUB.DIM_TIEMPO WHERE TIEMPO_CODIGO = @fechaInicialCod)
	DECLARE @ANIO_INICIAL decimal(18,0) = (SELECT TIEMPO_ANIO FROM BREAKFAST_CLUB.DIM_TIEMPO WHERE TIEMPO_CODIGO = @fechaInicialCod)
	
	DECLARE @ANIO_FINAL decimal(18,0) = IIF (@FechaFinalCOd = 0, YEAR(GETDATE()), (SELECT TIEMPO_ANIO FROM BREAKFAST_CLUB.DIM_TIEMPO WHERE TIEMPO_CODIGO = @fechaFinalCod))
	DECLARE @MES_FINAL decimal(18,0) = IIF(@FechaFinalCOd = 0, MONTH(GETDATE()), (SELECT TIEMPO_MES FROM BREAKFAST_CLUB.DIM_TIEMPO WHERE TIEMPO_CODIGO = @fechaFinalCod))
	
	DECLARE @RETORNO decimal(18,0) = 0

	SET @RETORNO = (@ANIO_FINAL - @ANIO_INICIAL) * 12 + (@MES_FINAL - @MES_INICIAL)

	RETURN @RETORNO

END 
GO

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_DIM_TIEMPO
AS
BEGIN TRANSACTION

/* TIEMPO */

INSERT INTO [BREAKFAST_CLUB].[BI_TIEMPO] VALUES (1,2018),(2,2018),(3,2018),(4,2018),(5,2018),(6,2018),(7,2018),(8,2018),(9,2018),(10,2018),(11,2018),(12,2018),
(1,2019),(2,2019),(3,2019),(4,2019),(5,2019),(6,2019),(7,2019),(8,2019),(9,2019),(10,2019),(11,2019),(12,2019),
(1,2020),(2,2020),(3,2020),(4,2020),(5,2020),(6,2020),(7,2020),(8,2020),(9,2020),(10,2020),(11,2020),(12,2020)

COMMIT;
GO