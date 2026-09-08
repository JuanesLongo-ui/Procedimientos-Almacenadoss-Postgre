CREATE OR REPLACE PROCEDURE ventas.crear_pedido (
    IN p_id_cliente INTEGER,
    OUT p_id_pedido INTEGER,
    OUT p_mensaje VARCHAR(150)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_activo BOOLEAN;
BEGIN
    
    SELECT activo_cliente 
    INTO v_activo
    FROM ventas.clientes
    WHERE id_cliente = p_id_cliente;

    IF NOT FOUND THEN
        p_id_pedido := NULL;
        p_mensaje := 'Cliente no existe';
		
    ELSIF v_activo = FALSE THEN
        p_id_pedido := NULL;
        p_mensaje := 'Cliente inactivo';
		
    ELSE
      
        INSERT INTO ventas.pedidos (id_cliente, estado_pedido, total_pedido)
        VALUES (p_id_cliente, 'PENDIENTE', 0)
        RETURNING id_pedido INTO p_id_pedido;

        p_mensaje := 'Pedido creado correctamente';
    END IF;
END;
$$;


CALL ventas.crear_pedido(1, NULL, NULL);
CALL ventas.crear_pedido(2, NULL, NULL);
CALL ventas.crear_pedido(6, NULL, NULL);
CALL ventas.crear_pedido(30, NULL, NULL);
CALL ventas.crear_pedido(999, NULL, NULL);

SELECT * FROM ventas.clientes;

SELECT * FROM ventas.pedidos
ORDER BY id_pedido DESC;