CREATE TYPE ventas.item_pedido AS (
    id_producto INTEGER,
    cantidad INTEGER
);

CREATE OR REPLACE PROCEDURE ventas.agregar_items_pedido(
    IN p_id_pedido INTEGER,
    IN p_items ventas.item_pedido[],
    OUT p_total_pedido NUMERIC(12,2),
    OUT p_mensaje VARCHAR(200)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_item RECORD;
    v_estado_pedido VARCHAR(30);
    v_stock_actual INTEGER;
    v_precio_producto NUMERIC(12,2);
    v_subtotal NUMERIC(12,2);
BEGIN
    p_total_pedido := 0;

    -- Verificar si el pedido existe
    SELECT estado_pedido INTO v_estado_pedido
    FROM ventas.pedidos
    WHERE id_pedido = p_id_pedido;

    IF NOT FOUND THEN
        p_mensaje := 'Pedido no existe';
        p_total_pedido := 0;
        RETURN;
    END IF;

    -- Verificar si el estado es PENDIENTE
    IF v_estado_pedido <> 'PENDIENTE' THEN
        p_mensaje := 'El pedido no puede modificarse';
        p_total_pedido := 0;
        RETURN;
    END IF;

    -- Recorrer el arreglo de ítems
    FOR v_item IN SELECT * FROM unnest(p_items)
    LOOP
        -- Consultar el producto correspondiente
        SELECT stock_producto, precio_producto 
        INTO v_stock_actual, v_precio_producto
        FROM ventas.productos
        WHERE id_producto = v_item.id_producto;

        -- Validaciones con IF / ELSIF
        IF NOT FOUND THEN
            RAISE EXCEPTION 'El producto con ID % no existe', v_item.id_producto;
        ELSIF v_item.cantidad <= 0 THEN
            RAISE EXCEPTION 'La cantidad solicitada debe ser mayor a 0';
        ELSIF v_stock_actual < v_item.cantidad THEN
            RAISE EXCEPTION 'No hay suficiente stock para el producto ID %', v_item.id_producto;
        ELSE
            -- Descontar stock
            UPDATE ventas.productos
            SET stock_producto = stock_producto - v_item.cantidad
            WHERE id_producto = v_item.id_producto;

            -- Calcular subtotal
            v_subtotal := v_item.cantidad * v_precio_producto;

            -- Insertar incluyendo el precio unitario faltante
            INSERT INTO ventas.detalle_pedido (id_pedido, id_producto, precio_unitario_detalle, cantidad_detalle, subtotal_detalle)
            VALUES (p_id_pedido, v_item.id_producto, v_precio_producto, v_item.cantidad, v_subtotal);

            -- Acumular el subtotal
            p_total_pedido := p_total_pedido + v_subtotal;
        END IF;
    END LOOP;

    -- Actualizar el total del pedido
    UPDATE ventas.pedidos
    SET total_pedido = p_total_pedido
    WHERE id_pedido = p_id_pedido;

    -- Mensaje de éxito
    p_mensaje := 'Productos agregados correctamente';
END;
$$;

CALL ventas.agregar_items_pedido(
    1,
    ARRAY[
        ROW(1, 1)::ventas.item_pedido,
        ROW(2, 2)::ventas.item_pedido,
        ROW(3, 1)::ventas.item_pedido
    ],
    NULL,
    NULL
);

-- Consultas de verificación
SELECT * FROM ventas.detalle_pedido
WHERE id_pedido = 1;

SELECT id_pedido, estado_pedido, total_pedido FROM ventas.pedidos
WHERE id_pedido = 1;

SELECT id_producto, nombre_producto, stock_producto FROM ventas.productos
ORDER BY id_producto;