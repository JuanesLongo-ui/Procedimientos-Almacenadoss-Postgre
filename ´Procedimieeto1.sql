-- procedimiento almacenado de de tipo in, se realiza cuando la cardinalida es 1:N
-- cuando es in la informacion se queda en la bd porque estoy ingresando

CREATE OR REPLACE PROCEDURE ventas.registrar_cliente (

IN p_nombre_cliente VARCHAR(120),
IN p_correo_cliente VARCHAR(100),
IN p_ciudad_cliente VARCHAR(80)

)

LANGUAGE plpgsql
AS $$
BEGIN

	INSERT INTO ventas.clientes (nombre_cliente,correo_cliente,ciudad_cliente)
	VALUES (p_nombre_cliente,p_correo_cliente,p_ciudad_cliente);
	
	RAISE NOTICE 'cliente registrado registrado %', p_nombre_cliente;

END
$$;

CALL ventas.registrar_cliente('Carlos Pérez','carlos@correo.com','Palmira');

SELECT * FROM ventas.clientes
WHERE correo_cliente = 'carlos@correo.com';

