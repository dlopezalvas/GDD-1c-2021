USE [GD1C2021]
GO


CREATE TABLE [BREAKFAST_CLUB].[BI_TIEMPO] (
  [COD_TIEMPO] decimal(18,0) IDENTITY (1,1),
  [ANIO] int,
  [MES] int,
  PRIMARY KEY ([COD_TIEMPO]),
  /*CONSTRAINT ck_tiempo_mes CHECK ([MES] BETWEEN 0 AND 12) no se porque no anda*/
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
	[COD_CIUDAD] decimal (18,0) REFERENCES [BREAKFAST_CLUB].CIUDAD,
	[MAIL] nvarchar(255),
	[TELEFONO] decimal (18,0),
	[DIRECCION] nvarchar(255),
	CONSTRAINT COD_BI_SUCURSAL_PK PRIMARY KEY ([COD_SUCURSAL])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_PC] (
    [COD_PC] nvarchar(50),
    [ALTO] decimal(18,2),
    [ANCHO] decimal(18,2),
    [PROFUNDIDAD] decimal(18,2),
    CONSTRAINT COD_BI_PC_PK PRIMARY KEY ([COD_PC])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_FABRICANTE](
	[COD_FABRICANTE] decimal (18,0),
	[NOMBRE] nvarchar(255),
	CONSTRAINT FABRICANTE_BI_PK PRIMARY KEY ([COD_FABRICANTE])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_GPU](
    [COD_GPU] decimal (18,0),
    [CAPACIDAD] nvarchar(255),
    [MODELO] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_FABRICANTE],
    [CHIPSET] nvarchar(50),
    [VELOCIDAD] nvarchar(50),
    CONSTRAINT GPU_BI_PK PRIMARY KEY ([COD_GPU])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_CPU] (
    [COD_CPU] nvarchar(50),
    [CACHE] nvarchar(50),
    [CANT_HILOS] nvarchar(50),
	[COD_FABRICANTE] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_FABRICANTE],
    [VELOCIDAD] varchar(50),
    CONSTRAINT CPU_BI_PK PRIMARY KEY ([COD_CPU])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_DISCO_RIGIDO] (
    [COD_DISCO] nvarchar(255),
    [TIPO] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_FABRICANTE],
    [VELOCIDAD] nvarchar(255),
    CONSTRAINT DISCO_RIGIDO_BI_PK PRIMARY KEY ([COD_DISCO])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_RAM] (
    [COD_RAM] nvarchar(255),
    [TIPO] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
	[COD_FABRICANTE] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_FABRICANTE],
    [VELOCIDAD] nvarchar(255),
    CONSTRAINT COD_RAM_BI_PK PRIMARY KEY ([COD_RAM])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_ACCESORIO] (
   [COD_ACCES] decimal(18,0),
   [DESCRIPCION] nvarchar(255),
   CONSTRAINT cod_accesorio_BI_pk PRIMARY KEY ([COD_ACCES])
);

CREATE TABLE [BREAKFAST_CLUB].[BI_HECHOS_PC] (
  [TIPO_TRANSACCION] nvarchar(50),
  [COD_PC] nvarchar(50) REFERENCES [BREAKFAST_CLUB].[BI_PC],
  [COD_RAM] nvarchar(255) REFERENCES [BREAKFAST_CLUB].[BI_RAM],
  [COD_DISCO] nvarchar(255) REFERENCES [BREAKFAST_CLUB].[BI_DISCO_RIGIDO],
  [COD_GPU] decimal (18,0) REFERENCES [BREAKFAST_CLUB].[BI_GPU],
  [COD_CPU] nvarchar(50) REFERENCES [BREAKFAST_CLUB].[BI_CPU],
  [COD_SUCURSAL] decimal (18,0) REFERENCES [BREAKFAST_CLUB].[BI_SUCURSAL],
  [COD_CLIENTE] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_CLIENTE],
  [COD_TIEMPO] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_TIEMPO],
  [PRECIO] decimal(18,2) ,
  [CANTIDAD] decimal(18,0),
  [STOCK_DISPONIBLE] decimal(18,0) NULL,
  [TIEMPO_EN_STOCK] decimal(18,0),
  CONSTRAINT ck_tipo_transaccion_BI_pc CHECK ([TIPO_TRANSACCION] IN ('Compra','Venta'))
);

CREATE TABLE [BREAKFAST_CLUB].[BI_HECHOS_ACCESORIOS] (
  [TIPO_TRANSACCION] nvarchar(50),
  [COD_ACCESORIO] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_ACCESORIO],
  [COD_SUCURSAL] decimal (18,0) REFERENCES [BREAKFAST_CLUB].[BI_SUCURSAL],
  [COD_TIEMPO] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_TIEMPO],
  [PRECIO] decimal(18,2) ,
  [CANTIDAD] decimal(18,0),
  [COD_CLIENTE] decimal(18,0) REFERENCES [BREAKFAST_CLUB].[BI_CLIENTE],
  [STOCK_DISPONIBLE] decimal(18,0) NULL,
  [TIEMPO_EN_STOCK] decimal(18,0),
  CONSTRAINT ck_tipo_transaccion_BI_acc CHECK ([TIPO_TRANSACCION] IN ('Compra','Venta'))
);

GO

/* FUNCIONES*/

CREATE FUNCTION [BREAKFAST_CLUB].obtener_cod_mes_anterior(@cod_tiempo decimal(18,0))
RETURNS decimal(18,0) AS
BEGIN
	DECLARE @RETURN DECIMAL(18,0)
	DECLARE @ANIO_ACTUAL DECIMAL(4,0) = (SELECT ANIO FROM [BREAKFAST_CLUB].BI_TIEMPO WHERE COD_TIEMPO = @cod_tiempo)
	DECLARE @MES_ACTUAL DECIMAL(2,0) = (SELECT MES FROM [BREAKFAST_CLUB].BI_TIEMPO WHERE COD_TIEMPO = @cod_tiempo)
		SET @RETURN = (SELECT COD_TIEMPO FROM [BREAKFAST_CLUB].BI_TIEMPO WHERE ANIO = @ANIO_ACTUAL AND MES = @MES_ACTUAL -1)
	RETURN @RETURN
END 
GO

CREATE FUNCTION [BREAKFAST_CLUB].obtener_stock_disponible_accesorio(@cod_tiempo decimal(18,0), @cod_accesorio decimal(18,0), @cod_sucursal decimal(18,0))
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE @RETURN DECIMAL(18,0);
	DECLARE @COD_MES_ANTERIOR DECIMAL(18,0) = [BREAKFAST_CLUB].obtener_cod_mes_anterior(@cod_tiempo);
	DECLARE @COMPRAS_ANTERIORES DECIMAL(18,0);
	DECLARE @VENTAS_ANTERIORES DECIMAL(18,0);
		
	SET @VENTAS_ANTERIORES = (SELECT SUM(CANTIDAD) FROM [BREAKFAST_CLUB].BI_HECHOS_ACCESORIOS WHERE TIPO_TRANSACCION = 'Venta' AND (COD_TIEMPO BETWEEN 1 AND @COD_MES_ANTERIOR) AND (COD_ACCESORIO = @cod_accesorio) AND (COD_SUCURSAL = @cod_sucursal));

	SET @COMPRAS_ANTERIORES = (SELECT SUM(CANTIDAD) FROM [BREAKFAST_CLUB].BI_HECHOS_ACCESORIOS	WHERE TIPO_TRANSACCION = 'Compra' AND COD_ACCESORIO = @cod_accesorio AND (COD_TIEMPO BETWEEN 1 AND @cod_tiempo) AND COD_SUCURSAL = @cod_sucursal);

	SET @RETURN = ISNULL(@COMPRAS_ANTERIORES, 0) - ISNULL(@VENTAS_ANTERIORES, 0) ;

	RETURN @RETURN

END
GO

CREATE FUNCTION [BREAKFAST_CLUB].obtener_stock_disponible_pc(@cod_tiempo decimal(18,0), @cod_pc nvarchar(50), @cod_sucursal decimal(18,0))
RETURNS DECIMAL(18,0) AS
BEGIN
	DECLARE @RETURN DECIMAL(18,0);
	DECLARE @COD_MES_ANTERIOR DECIMAL(18,0) = [BREAKFAST_CLUB].obtener_cod_mes_anterior(@cod_tiempo);
	DECLARE @COMPRAS_ANTERIORES DECIMAL(18,0);
	DECLARE @VENTAS_ANTERIORES DECIMAL(18,0);
		
	SET @VENTAS_ANTERIORES = (SELECT SUM(CANTIDAD) FROM [BREAKFAST_CLUB].BI_HECHOS_PC 
	WHERE TIPO_TRANSACCION = 'Venta' AND (COD_TIEMPO BETWEEN 1 AND @COD_MES_ANTERIOR) AND (COD_PC = @cod_pc) AND (COD_SUCURSAL = @cod_sucursal));

	SET @COMPRAS_ANTERIORES = (SELECT SUM(CANTIDAD) FROM [BREAKFAST_CLUB].BI_HECHOS_PC	
	WHERE TIPO_TRANSACCION = 'Compra' AND COD_PC = @cod_pc AND (COD_TIEMPO BETWEEN 1 AND @cod_tiempo) AND COD_SUCURSAL = @cod_sucursal);

	SET @RETURN = ISNULL(@COMPRAS_ANTERIORES, 0) - ISNULL(@VENTAS_ANTERIORES, 0) ;

	RETURN @RETURN

END
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
	SET @RETORNO = (SELECT COD_TIEMPO from [BREAKFAST_CLUB].BI_TIEMPO WHERE ANIO = YEAR((@fecha)) AND MES = MONTH((@fecha)))

	RETURN @RETORNO

END
GO

CREATE FUNCTION [BREAKFAST_CLUB].obtener_cant_meses_entre(@fechaInicialCod decimal(18,0), @fechaFinalCod decimal(18,0))
RETURNS decimal(18,0) AS
BEGIN
	DECLARE @MES_INICIAL decimal(18,0) = (SELECT MES FROM BREAKFAST_CLUB.BI_TIEMPO WHERE COD_TIEMPO = @fechaInicialCod)
	DECLARE @ANIO_INICIAL decimal(18,0) = (SELECT ANIO FROM BREAKFAST_CLUB.BI_TIEMPO WHERE COD_TIEMPO = @fechaInicialCod)
	
	DECLARE @ANIO_FINAL decimal(18,0) = IIF (@FechaFinalCOd = 0, YEAR(GETDATE()), (SELECT ANIO FROM BREAKFAST_CLUB.BI_TIEMPO WHERE COD_TIEMPO = @fechaFinalCod))
	DECLARE @MES_FINAL decimal(18,0) = IIF(@FechaFinalCOd = 0, MONTH(GETDATE()), (SELECT MES FROM BREAKFAST_CLUB.BI_TIEMPO WHERE COD_TIEMPO = @fechaFinalCod))
	
	DECLARE @RETORNO decimal(18,0) = 0

	SET @RETORNO = (@ANIO_FINAL - @ANIO_INICIAL) * 12 + (@MES_FINAL - @MES_INICIAL)

	RETURN @RETORNO

END 
GO



/* PROCEDURES */

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_CLIENTE
AS
BEGIN TRANSACTION

/* CLIENTE */

INSERT INTO [BREAKFAST_CLUB].[BI_CLIENTE] SELECT COD_CLIENTE, NOMBRE, APELLIDO, DNI, 
[BREAKFAST_CLUB].obtener_rango_edad(FECHA_NAC), MAIL, TELEFONO, DIRECCION 
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
SELECT COD_PC, ALTO, ANCHO, PROFUNDIDAD FROM [BREAKFAST_CLUB].[PC]

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

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_BI_SET_STOCK_PC
AS
BEGIN TRANSACTION

UPDATE [BREAKFAST_CLUB].BI_HECHOS_PC
SET STOCK_DISPONIBLE = ([BREAKFAST_CLUB].obtener_stock_disponible_pc(COD_TIEMPO, COD_PC, COD_SUCURSAL))
WHERE TIPO_TRANSACCION = 'Compra'

COMMIT;
GO


CREATE PROCEDURE [BREAKFAST_CLUB].PRC_BI_SET_STOCK_ACCESORIOS
AS
BEGIN TRANSACTION

UPDATE [BREAKFAST_CLUB].BI_HECHOS_ACCESORIOS
SET STOCK_DISPONIBLE = ([BREAKFAST_CLUB].obtener_stock_disponible_accesorio(COD_TIEMPO, COD_ACCESORIO, COD_SUCURSAL))
WHERE TIPO_TRANSACCION = 'Compra'

COMMIT;
GO



CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_HECHOS_ACCESORIOS
AS
BEGIN TRANSACTION

/*COMPRAS ACCESORIOS POR SUCURSAL POR MES */

BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_HECHOS_ACCESORIOS]
SELECT 'Compra', AxC.COD_ACCES, S.COD_SUCURSAL, [BREAKFAST_CLUB].obtener_codigo_tiempo(C.FECHA) AS COD_TIEMPO, AxC.PRECIO, SUM(CANTIDAD) AS CANTIDAD, NULL, NULL, NULL
FROM [BREAKFAST_CLUB].ACCESORIO_X_COMPRA AxC 
INNER JOIN [BREAKFAST_CLUB].COMPRA C ON AxC.NRO_COMPRA = C.NRO_COMPRA
INNER JOIN [BREAKFAST_CLUB].SUCURSAL S ON S.COD_SUCURSAL = C.COD_SUCURSAL
GROUP BY C.FECHA, AxC.COD_ACCES, S.COD_SUCURSAL, AxC.PRECIO
ORDER BY C.FECHA
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

CREATE PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_HECHOS_PC
AS
BEGIN TRANSACTION

/* COMPRAS PC POR SUCURSAL POR MES */
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_HECHOS_PC]
SELECT 'Compra', PxC.COD_PC, COD_RAM, COD_DISCO, COD_GPU, COD_CPU, S.COD_SUCURSAL, NULL, [BREAKFAST_CLUB].obtener_codigo_tiempo(C.FECHA) AS COD_TIEMPO, PxC.PRECIO, SUM(CANTIDAD) AS CANTIDAD,  NULL, NULL
FROM [BREAKFAST_CLUB].PC_X_COMPRA PxC 
INNER JOIN [BREAKFAST_CLUB].COMPRA C ON PxC.NRO_COMPRA = C.NRO_COMPRA
INNER JOIN [BREAKFAST_CLUB].SUCURSAL S ON S.COD_SUCURSAL = C.COD_SUCURSAL
INNER JOIN [BREAKFAST_CLUB].PC PC ON PC.COD_PC = PxC.COD_PC
GROUP BY C.FECHA, PxC.COD_PC, COD_GPU,  COD_RAM, COD_DISCO, COD_CPU, S.COD_SUCURSAL, PxC.PRECIO
ORDER BY C.FECHA

COMMIT;

/* VENTAS PC POR SUCURSAL POR CLIENTE POR MES */
BEGIN TRANSACTION
INSERT INTO [BREAKFAST_CLUB].[BI_HECHOS_PC] 
SELECT 'Venta', PxF.COD_PC, COD_RAM, COD_DISCO, COD_GPU, COD_CPU, S.COD_SUCURSAL, F.COD_CLIENTE, [BREAKFAST_CLUB].obtener_codigo_tiempo(F.FECHA) AS COD_TIEMPO, PxF.PRECIO, SUM(CANTIDAD) AS CANTIDAD, NULL, NULL
FROM [BREAKFAST_CLUB].PC_X_FACTURA PxF 
INNER JOIN [BREAKFAST_CLUB].FACTURA F ON PxF.NRO_FACTURA = F.NRO_FACTURA
INNER JOIN [BREAKFAST_CLUB].SUCURSAL S ON S.COD_SUCURSAL = F.COD_SUCURSAL
INNER JOIN [BREAKFAST_CLUB].PC PC ON PC.COD_PC = PxF.COD_PC
GROUP BY F.FECHA, PxF.COD_PC, COD_GPU,  COD_RAM, COD_DISCO, COD_CPU, S.COD_SUCURSAL, F.COD_CLIENTE, PxF.PRECIO
ORDER BY F.FECHA
COMMIT;

COMMIT;
GO



EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_TIEMPO
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_FABRICANTE
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_CLIENTE
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_SUCURSAL
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_PC
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_GPU
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_CPU
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_DISCO_RIGIDO
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_RAM
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_ACCESORIO

EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_HECHOS_ACCESORIOS
EXEC [BREAKFAST_CLUB].PRC_BI_SET_STOCK_ACCESORIOS
EXEC [BREAKFAST_CLUB].PRC_INSERT_BI_HECHOS_PC
EXEC [BREAKFAST_CLUB].PRC_BI_SET_STOCK_PC

GO


/* cosas que faltan:
- settear los tiempos en stock de accesorios y pc
- probar todo esto
- hacer las vistas
- hacer la estrategia
*/




