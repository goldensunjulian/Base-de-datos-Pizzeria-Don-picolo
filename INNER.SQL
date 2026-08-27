
INSERT INTO cliente (nombre, telefono, direccion, correo_electronico, CantidadPedidos) VALUES
('Juan Pérez', '3101234567', 'Calle 10 # 5-20', 'juan.perez@mail.com', 6),
('Ana Gómez', '3209876543', 'Carrera 15 # 22-10', 'ana.gomez@mail.com', 2),
('Carlos Ruiz', '3156543210', 'Avenida 3 # 45-67', 'carlos.ruiz@mail.com', 0),
('Laura Torres', '3187654321', 'Calle 50 # 12-34', 'laura.torres@mail.com', 1);
INSERT INTO pizza (nombre, tamaño, precio, tipo) VALUES
('Margarita Clásica', 'Mediana', 0.00, 'clásica'),
('Pepperoni Especial', 'Grande', 0.00, 'especial'),
('Vegetariana Deluxe', 'Familiar', 0.00, 'vegetariana');

INSERT INTO ingrediente (nombre, stock, stock_minimo, precio_unitario) VALUES
('Masa de pizza', 100, 10, 2000.00),
('Salsa de tomate', 100, 15, 1500.00),
('Queso Mozzarella', 150, 20, 3500.00),
('Pepperoni', 80, 10, 4500.00),
('Champiñones', 50, 10, 2500.00),
('Pimientos', 60, 10, 1800.00);

-- Receta Margarita
INSERT INTO receta (pizza_fk, ingrediente_fk, cantidad) VALUES (1, 1, 1), (1, 2, 1), (1, 3, 2);
-- Receta Pepperoni
INSERT INTO receta (pizza_fk, ingrediente_fk, cantidad) VALUES (2, 1, 1), (2, 2, 1), (2, 3, 2), (2, 4, 2);
-- Receta Vegetariana
INSERT INTO receta (pizza_fk, ingrediente_fk, cantidad) VALUES (3, 1, 1), (3, 2, 1), (3, 3, 1), (3, 5, 2), (3, 6, 2);

INSERT INTO repartidor (nombre, zona_asignada, estado) VALUES
('Mario Bros', 'Norte', 'disponible'),
('Luigi Bros', 'Sur', 'disponible'),
('Toad', 'Centro', 'no disponible');

INSERT INTO pedido (cliente_fk, fecha, metodo_pago, estado, total) VALUES
(1, '2023-10-15 19:30:00', 'efectivo', 'entregado', 45000.00),
(2, '2023-10-20 20:15:00', 'tarjeta', 'entregado', 60000.00),
(1, '2023-10-28 21:00:00', 'app', 'entregado', 85000.00),
(3, '2023-11-02 18:45:00', 'efectivo', 'pendiente', 35000.00); 

INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 1),
(3, 2, 1),
(4, 1, 1);

INSERT INTO domicilio (pedido_fk, repartidor_fk, hora_salida, hora_entrega, distancia_aproximada, costo_envio) VALUES
(1, 1, '2023-10-15 19:40:00', '2023-10-15 20:10:00', 3.5, 4000.00),
(2, 2, '2023-10-20 20:25:00', '2023-10-20 21:10:00', 6.0, 6500.00),
(3, 1, '2023-10-28 21:15:00', '2023-10-28 21:35:00', 2.0, 3000.00);