--- Clientes con pedidos entre dos fechas (BETWEEN).
SELECT DISTINCT c.nombre, c.telefono 
FROM cliente c 
JOIN pedido p ON c.id = p.cliente_fk 
WHERE p.fecha BETWEEN '2023-10-01 00:00:00' AND '2023-10-31 23:59:59';

--- Pizzas más vendidas (GROUP BY y COUNT).
SELECT p.nombre, SUM(dp.cantidad) AS VendidasTotal 
FROM pizza p 
JOIN detalle_pedido dp ON p.id = dp.pizza_fk 
GROUP BY p.id ORDER BY VendidasTotal DESC;

--- Pedidos por repartidor (JOIN).
SELECT r.nombre AS repartidor, p.id AS IdPedido, p.estado 
FROM repartidor r 
JOIN domicilio d ON r.id = d.repartidor_fk JOIN pedido p ON d.pedido_fk = p.id;

--- Promedio de entrega por zona (AVG y JOIN).
SELECT r.zona_asignada, AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS PromedioTiempo
FROM repartidor r 
JOIN domicilio d ON r.id = d.repartidor_fk WHERE d.hora_entrega IS NOT NULL GROUP BY r.zona_asignada;

--- Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).
SELECT nombre, telefono 
FROM cliente 
WHERE id IN (
    SELECT id 
    FROM cliente 
    WHERE CantidadPedidos > 5
);
--- Clientes que gastaron más de un monto (HAVING). En estos 2 casos use un
--- procedure para dejar mas libertad al usuario al momento de hacer la consulta
DELIMITER //
CREATE PROCEDURE BuscarClientePorMonto(IN cantidad DECIMAL(10,2))
BEGIN
    SELECT c.nombre, SUM(p.total) AS gastado 
    FROM cliente c 
    JOIN pedido p ON c.id = p.cliente_fk 
    GROUP BY c.id 
    HAVING gastado > cantidad;
END //
--- Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
CREATE PROCEDURE BuscarPizza(IN buscar VARCHAR(50))
BEGIN
    SELECT * FROM pizza 
    WHERE nombre LIKE CONCAT('%', buscar, '%');
END //
DELIMITER ;