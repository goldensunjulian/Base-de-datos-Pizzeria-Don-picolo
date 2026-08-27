-- Limpia cada mes el contador de pedidos para tener una logica limpia xdxd
CREATE EVENT reiniciar_contador_pedidos
ON SCHEDULE EVERY 1 MONTH STARTS CURRENT_TIMESTAMP
DO
UPDATE cliente SET CantidadPedidos = 0;