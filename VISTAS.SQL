-- Vista 1: Resumen de pedidos por cliente

CREATE VIEW vista_resumen_clientes AS
SELECT c.nombre AS cliente, COUNT(p.id) AS cantidad_pedidos, SUM(p.total) AS total_gastado
FROM cliente c
LEFT JOIN pedido p ON c.id = p.cliente_fk
GROUP BY c.id;

-- Vista 2: Desempeño de repartidores
CREATE VIEW vista_desempeno_repartidores AS
SELECT r.nombre AS repartidor, r.zona_asignada, 
       COUNT(d.id) AS numero_entregas, 
       AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS tiempo_promedio_minutos
FROM repartidor r
JOIN domicilio d ON r.id = d.repartidor_fk
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.id;

-- Vista 3: Stock de ingredientes por debajo del mínimo (¡Para esto era el ALTER TABLE!)
CREATE VIEW vista_stock_critico AS
SELECT nombre, stock AS stock_actual, stock_minimo
FROM ingrediente
WHERE stock < stock_minimo;