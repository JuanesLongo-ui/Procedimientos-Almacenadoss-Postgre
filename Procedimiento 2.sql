CREATE OR REPLACE PROCEDURE ventas.consultar_stock_producto (

    IN p_id_producto INTEGER,
    OUT p_nombre_producto VARCHAR(120),
    OUT p_stock_producto INTEGER,
    OUT p_activo_producto VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    
	-- Buscar el producto y asignar valores a los parámetros OUT usando la columna correcta stock_producto
    
	SELECT nombre_producto, stock_producto 
    INTO p_nombre_producto, p_stock_producto
    FROM ventas.productos
    WHERE id_producto = p_id_producto;

 
 IF NOT FOUND THEN
 
        p_nombre_producto := NULL;
        p_stock_producto := NULL;
        p_activo_producto := FALSE;
		
    ELSIF p_stock = 0 THEN
        p_activo_producto := FALSE;
		
    ELSE
        p_activo_producto := TRUE;
		
    END IF;
	
END;
$$;

-- Pruebas esperadas

CALL ventas.consultar_stock_producto(1, NULL, NULL, NULL);
CALL ventas.consultar_stock_producto(999, NULL, NULL, NULL);