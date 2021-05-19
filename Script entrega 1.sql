USE [GD1C2021]
GO

--CREATE SCHEMA [BREAKFAST_CLUB]
--GO

CREATE TABLE [CLIENTE] (
   [COD_CLIENTE] decimal(18,0),
   [NOMBRE] nvarchar(255),
   [APELLIDO] nvarchar(255),
   [DNI] decimal(18,0),
   [FECHA_NAC] datetime2(3),
   [MAIL] nvarchar(255),
   [TELEFONO] int,
   [DIRECCION] nvarchar(255),
   CONSTRAINT COD_CLIENTE_PK PRIMARY KEY ([COD_CLIENTE])
);


CREATE TABLE [FACTURA](
	[NRO_FACTURA] decimal (18,0), 
	[FECHA] datetime2 (3),
	[COD_SUCURSAL] decimal (18,0),
	[COD_CLIENTE] decimal (18,0),
	CONSTRAINT NRO_FACTURA_PK PRIMARY KEY ([NRO_FACTURA])
);

CREATE TABLE [BREAKFAST_CLUB].[ACCESORIO] (
   [CANT_HILOS] decimal(18,0),
   [COD_CPU] nvarchar(255),
   CONSTRAINT cod_accesorio_pk PRIMARY KEY ([CANT_HILOS])
);

CREATE TABLE [ACCESORIO_X_FACTURA](
	[COD_ACCES_FACTURA] nvarchar(255),
	[NRO_FACTURA] decimal (18,0),
	[COD_ACCES] decimal (18,0),
	[PRECIO] decimal (18,2),
	[CANTIDAD] decimal (18,0),
	CONSTRAINT COD_ACCES_FACTURA_PK PRIMARY KEY ([COD_ACCES_FACTURA])
);


CREATE TABLE [CIUDAD](
	[COD_CIUDAD] decimal (18,0),
	[NOMBRE] nvarchar(255),
	CONSTRAINT COD_CIUDAD_PK PRIMARY KEY ([COD_CIUDAD])
);

CREATE TABLE [SUCURSAL](
	[COD_SUCURSAL] decimal (18,0),
	[COD_CIUDAD] decimal (18,0),
	[MAIL] nvarchar(255),
	[TELEFONO] decimal (18,0),
	[DIRECCION] nvarchar(255),
	CONSTRAINT COD_SUCURSAL_PK PRIMARY KEY ([COD_SUCURSAL])
);

CREATE TABLE [GPU](
    [COD_GPU] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
    [MODELO] nvarchar(255),
    [FABRICANTE] nvarchar(255),
    [CHIPSET] nvarchar(50),
    [VELOCIDAD] nvarchar(50),
    CONSTRAINT GPU_PK PRIMARY KEY ([COD_GPU])
);

CREATE TABLE [CPU] (
    [COD_CPU] nvarchar(50),
    [CACHE] nvarchar(50),
    [CANT_HILOS] nvarchar(50),
    [FABRICANTES] nvarchar(255),
    [VELOCIDAD] decimal(18,0),
    CONSTRAINT CPU_PK PRIMARY KEY ([COD_CPU])
);

CREATE TABLE [DISCO_RIGIDO] (
    [COD_DISCO] nvarchar(255),
    [TIPO] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
    [FABRICANTE] nvarchar(255),
    [VELOCIDAD] nvarchar(255),
    CONSTRAINT DISCO_RIGIDO_PK PRIMARY KEY ([COD_DISCO])
);

CREATE TABLE [RAM] (
    [COD_RAM] nvarchar(255),
    [TIPO] nvarchar(255),
    [CAPACIDAD] nvarchar(255),
    [FABRICANTE] nvarchar(255),
    [VELOCIDAD] nvarchar(255),
    CONSTRAINT COD_RAM_PK PRIMARY KEY ([COD_RAM])
);

CREATE TABLE [PC] (
    [COD_PC] nvarchar(50),
    [ALTO] decimal(18,2),
    [ANCHO] decimal(18,2),
    [PROFUNDIDAD] decimal(18,2),
    [COD_CPU] nvarchar(50),
    [COD_GPU] nvarchar(255),
    [COD_RAM] nvarchar(255),
    [COD_DISCO] nvarchar(255),
    CONSTRAINT COD_PC_PK PRIMARY KEY ([COD_PC])
);


CREATE TABLE [BREAKFAST_CLUB].[ACCESORIO_X_COMPRA] (
   [COD_ACCES_COMPRA] decimal(18,0),
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
   [COD_PC_COMPRA] decimal(18,0),
   [NRO_COMPRA] nvarchar(255),
   [COD_PC] nvarchar(50),
   [PRECIO] decimal(18,2),
   [CANTIDAD] decimal(18,0),
   CONSTRAINT cod_pc_compra_pk PRIMARY KEY ([COD_PC_COMPRA])
);


CREATE TABLE [BREAKFAST_CLUB].[PC_X_FACTURA] (
   [COD_PC_FACTURA] decimal(18,0),
   [NRO_FACTURA] nvarchar(255),
   [COD_PC] nvarchar(50),
   [PRECIO] decimal(18,2),
   [CANTIDAD] decimal(18,0),
   CONSTRAINT cod_pc_factura_pk PRIMARY KEY ([COD_PC_FACTURA])
);


ALTER TABLE [FACTURA]
ADD CONSTRAINT COD_SUCURSAL_FK FOREIGN KEY ([COD_SUCURSAL])
REFERENCES [SUCURSAL]([COD_SUCURSAL]);

ALTER TABLE [FACTURA]
ADD CONSTRAINT COD_CLIENTE_FK FOREIGN KEY ([COD_CLIENTE])
REFERENCES [CLIENTE]([COD_CLIENTE]);

ALTER TABLE [ACCESORIO_X_FACTURA]
ADD CONSTRAINT NRO_FACTURA_FK FOREIGN KEY ([NRO_FACTURA])
REFERENCES [FACTURA]([NRO_FACTURA]);

ALTER TABLE [ACCESORIO_X_FACTURA]
ADD CONSTRAINT COD_ACCES_FK FOREIGN KEY ([COD_ACCES])
REFERENCES [ACCESORIO]([COD_ACCES]);

ALTER TABLE [SUCURSAL]
ADD CONSTRAINT COD_CIUDAD_FK FOREIGN KEY ([COD_CIUDAD])
REFERENCES [CIUDAD]([COD_CIUDAD]);

ALTER TABLE [PC]
ADD CONSTRAINT COD_GPU_fk FOREIGN KEY ([COD_GPU])
REFERENCES [GPU]([COD_GPU]);

ALTER TABLE [PC]
ADD CONSTRAINT cod_cpu_fk FOREIGN KEY ([COD_CPU])
REFERENCES [CPU]([COD_CPU]);

ALTER TABLE [PC]
ADD CONSTRAINT cod_ram_fk FOREIGN KEY ([COD_RAM])
REFERENCES [RAM]([COD_RAM]);

ALTER TABLE [PC]
ADD CONSTRAINT cod_disco_fk FOREIGN KEY ([COD_DISCO])
REFERENCES [DISCO_RIGIDO]([COD_DISCO]);

ALTER TABLE [COMPRA]
ADD CONSTRAINT cod_sucursal_fk FOREIGN KEY ([COD_SUCURSAL])
REFERENCES [SUCURSAL]([COD_SUCURSAL]);

ALTER TABLE [PC_X_COMPRA]
ADD CONSTRAINT nro_compra_fk FOREIGN KEY ([NRO_COMPRA])
REFERENCES [COMPRA]([NRO_COMPRA]);

ALTER TABLE [PC_X_COMPRA]
ADD CONSTRAINT cod_pc_fk FOREIGN KEY ([COD_PC])
REFERENCES [PC]([COD_PC]);

ALTER TABLE [ACCESORIO_X_COMPRA]
ADD CONSTRAINT nro_compra_fk FOREIGN KEY ([NRO_COMPRA])
REFERENCES [COMPRA]([NRO_COMPRA]);

ALTER TABLE [ACCESORIO_X_COMPRA]
ADD CONSTRAINT cod_accesorio_fk FOREIGN KEY ([COD_ACCES])
REFERENCES [ACCESORIO]([COD_ACCES]);
ALTER TABLE [PC_X_FACTURA]
ADD CONSTRAINT nro_factura_fk FOREIGN KEY ([NRO_FACTURA])
REFERENCES [FACTURA]([NRO_FACTURA]);

ALTER TABLE [PC_X_FACTURA]
ADD CONSTRAINT cod_pc_fk FOREIGN KEY ([COD_PC])
REFERENCES [PC]([COD_PC]);