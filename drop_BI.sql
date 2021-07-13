USE [GD1C2021]
GO

/* DROP VIEWS */
DROP VIEW [BREAKFAST_CLUB].BI_PROMEDIO_TIEMPO_EN_STOCK_PC
DROP VIEW [BREAKFAST_CLUB].BI_PRECIO_PROMEDIO_PC
DROP VIEW [BREAKFAST_CLUB].BI_CANT_COMPRAS_VENTAS_PC_X_SUCURSAL_X_MES
DROP VIEW [BREAKFAST_CLUB].BI_GANANCIAS_PC_X_SUCURSAL_X_MES

DROP VIEW [BREAKFAST_CLUB].BI_PRECIO_PROMEDIO_ACCESORIO
DROP VIEW [BREAKFAST_CLUB].BI_GANANCIAS_ACCESORIO_X_SUCURSAL_X_MES
DROP VIEW [BREAKFAST_CLUB].BI_PROMEDIO_TIEMPO_EN_STOCK_ACCESORIO
DROP VIEW [BREAKFAST_CLUB].BI_CANT_MAXIMA_EN_STOCK_X_SUCURSAL_X_ANIO

/* DROP FUNCTIONS*/

DROP FUNCTION [BREAKFAST_CLUB].OBTENER_RANGO_EDAD
DROP FUNCTION [BREAKFAST_CLUB].OBTENER_CODIGO_TIEMPO
DROP FUNCTION [BREAKFAST_CLUB].OBTENER_STOCK_DISPONIBLE_SUCURSAL_ACCESORIO
DROP FUNCTION [BREAKFAST_CLUB].STOCK_MAX_EN_ANIO
DROP FUNCTION [BREAKFAST_CLUB].DIFERENCIA_TIEMPO_ACCES_SUCURSAL
DROP FUNCTION [BREAKFAST_CLUB].TIEMPO_PROMEDIO_EN_STOCK_ACCESORIO
DROP FUNCTION [BREAKFAST_CLUB].DIFERENCIA_TIEMPO_PC_SUCURSAL
DROP FUNCTION [BREAKFAST_CLUB].TIEMPO_PROMEDIO_EN_STOCK_PC
DROP FUNCTION [BREAKFAST_CLUB].PRECIO_PROMEDIO_COMPRA_PC
DROP FUNCTION [BREAKFAST_CLUB].PRECIO_PROMEDIO_VENTAS_PC
DROP FUNCTION [BREAKFAST_CLUB].PRECIO_PROMEDIO_COMPRA_ACC
DROP FUNCTION [BREAKFAST_CLUB].PRECIO_PROMEDIO_VENTA_ACC
DROP FUNCTION [BREAKFAST_CLUB].GANANCIAS_ACCESORIOS
DROP FUNCTION [BREAKFAST_CLUB].GANANCIAS_PC
DROP FUNCTION [BREAKFAST_CLUB].TOTAL_VENDIDO_X_MES_SUC_ACC
DROP FUNCTION [BREAKFAST_CLUB].TOTAL_VENDIDO_X_MES_SUC_PC


/* DROP PROCEDURES */

--DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_CLIENTE
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_TIEMPO
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_SUCURSAL
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_GPU
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_CPU
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_DISCO_RIGIDO
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_RAM
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_FABRICANTE
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_HECHOS_PC
DROP PROCEDURE [BREAKFAST_CLUB].PRC_INSERT_BI_HECHOS_ACCESORIOS

/* DROP TABLES */

DROP TABLE [BREAKFAST_CLUB].[BI_HECHOS_COMPRAS_PC]
DROP TABLE [BREAKFAST_CLUB].[BI_HECHOS_COMPRAS_ACCESORIOS]
DROP TABLE [BREAKFAST_CLUB].[BI_HECHOS_VENTAS_PC]
DROP TABLE [BREAKFAST_CLUB].[BI_HECHOS_VENTAS_ACCESORIOS]
DROP TABLE [BREAKFAST_CLUB].[BI_TIEMPO]
--DROP TABLE [BREAKFAST_CLUB].[BI_CLIENTE]
DROP TABLE [BREAKFAST_CLUB].[BI_SUCURSAL]
DROP TABLE [BREAKFAST_CLUB].[BI_PC]
DROP TABLE [BREAKFAST_CLUB].[BI_GPU]
DROP TABLE [BREAKFAST_CLUB].[BI_CPU]
DROP TABLE [BREAKFAST_CLUB].[BI_DISCO_RIGIDO]
DROP TABLE [BREAKFAST_CLUB].[BI_RAM]
DROP TABLE [BREAKFAST_CLUB].[BI_ACCESORIO]
DROP TABLE [BREAKFAST_CLUB].[BI_FABRICANTE]

