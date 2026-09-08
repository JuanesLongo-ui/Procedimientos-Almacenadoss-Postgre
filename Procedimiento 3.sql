CREATE OR REPLACE PROCEDURE ventas.clasificar_inventario_producto (
    IN p_id_producto INTEGER,
    OUT p_nombre_producto VARCHAR(120),
    OUT p_stock INTEGER,
    OUT p_clasificacion VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    SELECT nombre_producto, stock_producto 
    INTO p_nombre_producto, p_stock
    FROM ventas.productos
    WHERE id_producto = p_id_producto;

    IF NOT FOUND THEN
        p_nombre_producto := NULL;
        p_stock := NULL;
        p_clasificacion := 'NO EXISTE';
		
    ELSIF p_stock = 0 THEN
        p_clasificacion := 'AGOTADO';

	ELSIF p_stock >= 1  AND p_stock <= 5 THEN
        p_clasificacion := 'STOCK CRITICO';

	ELSIF p_stock >= 6  AND p_stock <= 15 THEN
        p_clasificacion := 'STOCK BAJO';
		
    ELSE
        p_clasificacion := 'STOCK SUFICIENTE';
		
    END IF;
	
END;
$$;

SELECT * FROM ventas.productos;

CALL ventas.clasificar_inventario_producto(5, NULL, NULL, NULL);
CALL ventas.clasificar_inventario_producto(4, NULL, NULL, NULL);
CALL ventas.clasificar_inventario_producto(3, NULL, NULL, NULL);
CALL ventas.clasificar_inventario_producto(2, NULL, NULL, NULL);
