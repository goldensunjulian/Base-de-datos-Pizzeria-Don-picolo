--ifnull para darle un default y no falle a lo bestia xdxdxdxd
DELIMITER //

-- Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).
CREATE FUNCTION CalcularTotalIva(id_pedido INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE TotalPizzas DECIMAL(10,2) DEFAULT 0.00;
    DECLARE CostoEnvio DECIMAL(10,2) DEFAULT 0.00;
--
    SELECT IFNULL(SUM(p.precio * dp.cantidad), 0) INTO TotalPizzas
    FROM detalle_pedido dp
    JOIN pizza p ON dp.pizza_fk = p.id
    WHERE dp.pedido_fk = id_pedido;
--
    SELECT IFNULL(costo_envio, 0) INTO CostoEnvio
    FROM domicilio
    WHERE pedido_fk = id_pedido;
--
    RETURN (TotalPizzas + CostoEnvio) * 1.19;
END //

-- Función para calcular la ganancia neta diaria (ventas - costos de ingredientes).
CREATE FUNCTION GananciaDiariaNeta(fechaPedido DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE ventas DECIMAL(10,2) DEFAULT 0.00;
    DECLARE costos DECIMAL(10,2) DEFAULT 0.00;
--
    SELECT IFNULL(SUM(total), 0) INTO ventas
    FROM pedido
    WHERE DATE(fecha) = fechaPedido AND estado = 'entregado';
--
    SELECT IFNULL(SUM(r.cantidad * dp.cantidad * i.precio_unitario), 0) INTO costos
    FROM pedido ped
    JOIN detalle_pedido dp ON ped.id = dp.pedido_fk JOIN receta r ON dp.pizza_fk = r.pizza_fk JOIN ingrediente i ON r.ingrediente_fk = i.id
    WHERE DATE(ped.fecha) = fechaPedido AND ped.estado = 'entregado';
    
    RETURN (ventas - costos);
END //
-- Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega.
CREATE PROCEDURE domicilioEntregado(IN idDomicilio INT)
BEGIN

    IF (SELECT hora_entrega FROM domicilio WHERE id = idDomicilio) IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Este domicilio ya figura como entregado.';
    ELSE
        UPDATE domicilio 
        SET hora_entrega = NOW() 
        WHERE id = idDomicilio;
--
        UPDATE pedido p
        JOIN domicilio d ON p.id = d.pedido_fk
        SET p.estado = 'entregado'
        WHERE d.id = idDomicilio;
    END IF;
END //
DELIMITER ;