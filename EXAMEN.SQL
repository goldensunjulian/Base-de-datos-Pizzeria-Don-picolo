-- Consulta SQL que muestre el nombre del cliente, el ID del pedido, el total y el estado del pedido.
select p.id as id_pedido, c.nombre, p.total, p.estado from pedido p join cliente c on cliente_fk = c.id;

-- Mostrar los pedidos con estado entregado cuya fecha esté entre dos fechas dadas (usa BETWEEN).
SELECT * from pedido WHERE estado='entregado' and fecha BETWEEN '2023-10-01 00:00:00' AND '2023-10-31 23:59:59';

-- Mostrar cuántos pedidos se hicieron por cada método de pago y el total acumulado (GROUP BY).


select metodo_pago,count(metodo_pago) as cantidad_usos, sum(total) from pedido GROUP BY metodo_pago;

-- Mostrar los clientes que tengan más de 5 pedidos en total (usa HAVING COUNT(*) > 5).
SELECT id, nombre, telefono, CantidadPedidos
FROM cliente 
WHERE id IN (
    SELECT id 
    FROM cliente 
    WHERE CantidadPedidos > 5
);


