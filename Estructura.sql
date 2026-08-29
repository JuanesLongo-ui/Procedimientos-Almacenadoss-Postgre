-- crear el schema ventas y eliminar el publixc

CREATE SCHEMA IF NOT EXISTS ventas;


CREATE TABLE IF NOT EXISTS ventas.clientes (

id_cliente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nombre_cliente VARCHAR(100) NOT NULL,
correo_cliente VARCHAR(120) NOT NULL UNIQUE,
ciudad_cliente VARCHAR(80) NOT NULL,
activo_cliente BOOLEAN NOT NULL DEFAULT TRUE

);


CREATE TABLE IF NOT EXISTS ventas.productos (

id_producto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nombre_producto VARCHAR(120) NOT NULL,
precio_producto NUMERIC(12, 2) NOT NULL CHECK (precio_producto > 0),
stock_producto INTEGER NOT NULL CHECK (stock_producto >= 0),
activo_producto BOOLEAN NOT NULL DEFAULT TRUE

);


CREATE TABLE IF NOT EXISTS ventas.pedidos (

id_pedido INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
fecha_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
estado_pedido VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE' CHECK (estado_pedido IN ('PENDIENTE', 'PAGADO', 'CANCELADO')),
total_pedido NUMERIC(12, 2) NOT NULL DEFAULT 0,
id_cliente INTEGER NOT NULL,

CONSTRAINT fk_pedido_cliente 
FOREIGN KEY (id_cliente)
REFERENCES ventas.clientes (id_cliente)

);


CREATE TABLE IF NOT EXISTS ventas.detalle_pedido (

id_detalle INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
cantidad_detalle INTEGER NOT NULL CHECK (cantidad_detalle > 0),
precio_unitario_detalle NUMERIC(12, 2) NOT NULL CHECK (precio_unitario_detalle > 0),
subtotal_detalle NUMERIC(12, 2) NOT NULL CHECK (subtotal_detalle >= 0),
id_pedido INTEGER NOT NULL,
id_producto INTEGER NOT NULL,

CONSTRAINT fk_detalle_pedido
FOREIGN KEY (id_pedido)
REFERENCES ventas.pedidos (id_pedido),

CONSTRAINT fk_detalle_producto
FOREIGN KEY (id_producto)
REFERENCES ventas.productos (id_producto)

);