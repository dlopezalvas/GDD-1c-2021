USE GD1C2021
GO

/* creo que esto va a ser una vista*/

CREATE FUNCTION [BREAKFAST_CLUB].obtener_cant_comprada_por_mes_accesorio(@mes decimal(18,0), @cod_accesorio decimal(18,0), @cod_sucursal decimal(18,0))
RETURNS decimal(18,0) AS
BEGIN 
	declare @retorno decimal(18,0) = (select CANTIDAD from [BREAKFAST_CLUB].bi_hechos_accesorios 
	where tipo_transaccion = 'Compra' and cod_accesorio = @cod_accesorio and COD_SUCURSAL = @cod_sucursal AND cod_tiempo = @mes)
	
	return @retorno
END 
GO

CREATE FUNCTION [BREAKFAST_CLUB].obtener_cod_mes_siguiente(@cod_tiempo decimal(18,0))
RETURNS decimal(18,0) AS
BEGIN
	DECLARE @RETURN DECIMAL(18,0)
	DECLARE @ANIO_ACTUAL DECIMAL(4,0) = (SELECT ANIO FROM [BREAKFAST_CLUB].BI_TIEMPO WHERE COD_TIEMPO = @cod_tiempo)
	DECLARE @MES_ACTUAL DECIMAL(2,0) = (SELECT MES FROM [BREAKFAST_CLUB].BI_TIEMPO WHERE COD_TIEMPO = @cod_tiempo)
	SET @RETURN = (SELECT COD_TIEMPO FROM [BREAKFAST_CLUB].BI_TIEMPO WHERE ANIO = @ANIO_ACTUAL AND MES = @MES_ACTUAL +1)
	
	RETURN @RETURN
END 
GO



CREATE FUNCTION [BREAKFAST_CLUB].obtener_cant_vendida_accesorio_entre(@mes_inicial decimal(18,0), @mes_final decimal(18,0), @cod_accesorio decimal(18,0), @cod_sucursal decimal(18,0))
RETURNS decimal(18,0) AS
BEGIN 
	declare @retorno decimal(18,0) = (SELECT SUM(CANTIDAD) FROM [BREAKFAST_CLUB].BI_HECHOS_accesorios 
	WHERE TIPO_TRANSACCION = 'Venta' AND COD_TIEMPO BETWEEN @mes_inicial AND @mes_final
	AND cod_accesorio = @cod_accesorio AND COD_SUCURSAL = @cod_sucursal)
	
	return @retorno

END 
GO




CREATE FUNCTION [BREAKFAST_CLUB].obtener_tiempo_en_stock_accesorio(@mes_actual decimal(18,0), @cod_accesorio decimal(18,0), @cod_sucursal decimal(18,0), @cant_vendida decimal(18,0))
RETURNS decimal(18,4) AS
BEGIN 
	declare @tiempo_en_stock decimal(18,0)
	declare @mes_stock decimal(18,0) = (select top 1 cod_tiempo from [BREAKFAST_CLUB].bi_hechos_accesorios where tipo_transaccion = 'Compra' and cod_accesorio = @cod_accesorio and COD_SUCURSAL = @cod_sucursal order by cod_tiempo)
	declare @stock_restante_mes decimal(18,0) = [BREAKFAST_CLUB].obtener_cant_comprada_por_mes_accesorio(@mes_stock, @cod_accesorio, @cod_sucursal)
	declare @retorno decimal(18,4)

	declare @ventas_hasta_mes_actual decimal (18,0) = [BREAKFAST_CLUB].obtener_cant_vendida_accesorio_entre(@mes_stock, [BREAKFAST_CLUB].obtener_cod_mes_siguiente(@mes_actual) , @cod_accesorio, @cod_sucursal)

	WHILE (@ventas_hasta_mes_actual > 0) 
	BEGIN  
		IF(@ventas_hasta_mes_actual > @stock_restante_mes)
		BEGIN
			SET @ventas_hasta_mes_actual = @ventas_hasta_mes_actual - @stock_restante_mes
			SET @mes_stock = [BREAKFAST_CLUB].obtener_cod_mes_siguiente(@mes_stock) 
			SET @stock_restante_mes = [BREAKFAST_CLUB].obtener_cant_comprada_por_mes_accesorio(@mes_stock, @cod_accesorio, @cod_sucursal)
		END
		ELSE
		BEGIN
			SET @stock_restante_mes = @stock_restante_mes - @ventas_hasta_mes_actual
			SET @ventas_hasta_mes_actual = 0
		END
		BREAK;  
	END  

	declare @total_meses decimal(18,4) = 0
	DECLARE @CANT_VENDIDA_MES DECIMAL (18,4) = @cant_vendida

	WHILE (@CANT_VENDIDA_MES > 0)
	BEGIN  
		IF(@CANT_VENDIDA_MES > @stock_restante_mes)
		BEGIN
			SET @total_meses = @total_meses + @stock_restante_mes * [BREAKFAST_CLUB].obtener_cant_meses_entre(@mes_stock, @mes_actual)
			/* cant vendida en ese mes * cant de meses entre el mes y ahora*/
			SET @CANT_VENDIDA_MES = @CANT_VENDIDA_MES - @stock_restante_mes
			SET @mes_stock = [BREAKFAST_CLUB].obtener_cod_mes_siguiente(@mes_stock)
			SET @stock_restante_mes = [BREAKFAST_CLUB].obtener_cant_comprada_por_mes_accesorio(@mes_stock, @cod_accesorio, @cod_sucursal)
		END
		ELSE
		BEGIN
			SET @total_meses = @total_meses + @CANT_VENDIDA_MES * [BREAKFAST_CLUB].obtener_cant_meses_entre(@mes_stock, @mes_actual)
			SET @CANT_VENDIDA_MES = 0
		END
		BREAK;  
	END  
	SET @retorno = CONVERT(decimal(12,4),@total_meses)  /  CONVERT(decimal(12,4),@cant_vendida) 

	return @retorno

END 
GO



CREATE PROCEDURE [BREAKFAST_CLUB].PRC_BI_SET_TIEMPO_EN_STOCK_ACCESORIOS
AS 
BEGIN TRANSACTION

UPDATE [BREAKFAST_CLUB].BI_HECHOS_ACCESORIOS SET TIEMPO_EN_STOCK = [BREAKFAST_CLUB].obtener_tiempo_en_stock_accesorio(COD_TIEMPO, COD_ACCESORIO, COD_SUCURSAL, CANTIDAD)
WHERE TIPO_TRANSACCION = 'Venta'

COMMIT;
GO

exec [BREAKFAST_CLUB].PRC_BI_SET_TIEMPO_EN_STOCK_ACCESORIOS


/*cosas de pruebas*/

select * from BREAKFAST_CLUB.BI_HECHOS_ACCESORIOS WHERE TIPO_TRANSACCION = 'VENTA'

SELECT [BREAKFAST_CLUB].obtener_tiempo_en_stock_accesorio(23, 1001, 3, 388)

select cod_tiempo, cantidad, cod_accesorio, cod_sucursal from BREAKFAST_CLUB.bi_hechos_accesorios 
where cod_accesorio = 1001 and cod_sucursal = 3 and tipo_transaccion = 'Compra' order by cod_tiempo

SELECT COD_TIEMPO, SUM(CANTIDAD) AS CANTIDAD, COD_ACCESORIO, COD_SUCURSAL FROM [BREAKFAST_CLUB].BI_HECHOS_accesorios 
WHERE TIPO_TRANSACCION = 'Venta' AND cod_accesorio = 1001 AND COD_SUCURSAL = 3 GROUP BY COD_TIEMPO, COD_ACCESORIO, COD_SUCURSAL


/*borrar todo esto*/

DROP FUNCTION [BREAKFAST_CLUB].obtener_tiempo_en_stock_accesorio
DROP FUNCTION [BREAKFAST_CLUB].obtener_cant_comprada_por_mes_accesorio
DROP FUNCTION [BREAKFAST_CLUB].obtener_cod_mes_siguiente
DROP FUNCTION [BREAKFAST_CLUB].obtener_cant_vendida_accesorio_entre

DROP PROCEDURE [BREAKFAST_CLUB].PRC_BI_SET_TIEMPO_EN_STOCK_ACCESORIOS

