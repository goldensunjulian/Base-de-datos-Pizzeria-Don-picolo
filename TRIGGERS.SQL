DELIMITER //
--- Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido.
CREATE TRIGGER validarDescuentoMateriales
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    DECLARE totalIngredientesReceta INT DEFAULT 0;
    DECLARE paso_actual INT DEFAULT 0;
    DECLARE idIngrediente INT;
    DECLARE cantidadNecesaria INT;
    DECLARE cantidadRestar INT;
    DECLARE stockDisponible INT;
--
    SELECT COUNT(*) INTO totalIngredientesReceta FROM receta WHERE pizza_fk = NEW.pizza_fk;
    WHILE paso_actual < totalIngredientesReceta DO

        SELECT ingrediente_fk, cantidad 
        INTO idIngrediente, cantidadNecesaria
        FROM receta 
        WHERE pizza_fk = NEW.pizza_fk 
        ORDER BY id ASC 
        LIMIT 1 OFFSET paso_actual;
        SET cantidadRestar = cantidadNecesaria * NEW.cantidad;
--
        SELECT stock INTO stockDisponible
        FROM ingrediente 
        WHERE id = idIngrediente;
--
        IF stockDisponible < cantidadRestar THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: No hay suficiente stock de ingredientes para preparar esta pizza.';
        ELSE
            UPDATE ingrediente 
            SET stock = stock - cantidadRestar 
            WHERE id = idIngrediente;
        END IF;
        SET paso_actual = paso_actual + 1; 
    END WHILE;
END //
--- funcion para calcular precio de pizza (Para que este funcione correctamente primero se debe agregar una pizza con valo 0 
--- y tener los ingredientes despues debemos relacionar las tablas por medio de receta para que calcule los precios)
CREATE TRIGGER CalcularPrecioPizza
AFTER INSERT ON receta
FOR EACH ROW
BEGIN
    DECLARE costoTotal DECIMAL(10,2);
--
    SELECT SUM(i.precio_unitario * r.cantidad) INTO costoTotal
    FROM receta r
    JOIN ingrediente i ON r.ingrediente_fk = i.id
    WHERE r.pizza_fk = NEW.pizza_fk;
--
    UPDATE pizza 
    SET precio = costoTotal * 1.50
    WHERE id = NEW.pizza_fk;
END //

--- funcion para actualizar precio de pizza si ingredientes cambian de precio (pense en usar ley de signos pero teniendo ya otro ejemplo con while use while para no complicarme)
CREATE TRIGGER actualizarPrecioPizzaIngrediente
AFTER UPDATE ON ingrediente
FOR EACH ROW
BEGIN
    DECLARE pizzasCambiaran INT DEFAULT 0;
    DECLARE paso_actual INT DEFAULT 0;
    DECLARE idPizzamamamia INT;
    DECLARE costoFinal DECIMAL(10,2);
--
    IF OLD.precio_unitario != NEW.precio_unitario THEN
        SELECT COUNT(*) INTO pizzasCambiaran
        FROM receta 
        WHERE ingrediente_fk = NEW.id;
--
        WHILE paso_actual < pizzasCambiaran DO
            SELECT pizza_fk INTO idPizzamamamia
            FROM receta 
            WHERE ingrediente_fk = NEW.id
            ORDER BY id ASC
            LIMIT 1 OFFSET paso_actual;
--
            SELECT SUM(r.cantidad * i.precio_unitario) INTO costoFinal
            FROM receta r
            JOIN ingrediente i ON r.ingrediente_fk = i.id
            WHERE r.pizza_fk = idPizzamamamia;
--
            UPDATE pizza 
            SET precio = costoFinal * 1.50
            WHERE id = idPizzamamamia;
--
            SET paso_actual = paso_actual + 1;      
        END WHILE;
    END IF;
END //

--- Trigger de auditoría que registre en una tabla historial_precios cada vez que se modifique el precio de una pizza.
CREATE TRIGGER CambioPrecioPizzaRegistro
AFTER UPDATE ON pizza
FOR EACH ROW
BEGIN
    IF OLD.precio != NEW.precio THEN
        INSERT INTO historial_precios (pizza_fk, precio_anterior, precio_nuevo, fecha_modificacion)
        VALUES (NEW.id, OLD.precio, NEW.precio, NOW());
    END IF;
END //

--- Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio.
CREATE TRIGGER LiberarRepartidor
AFTER UPDATE ON domicilio
FOR EACH ROW
BEGIN
    IF OLD.hora_entrega IS NULL AND NEW.hora_entrega IS NOT NULL THEN
        UPDATE repartidor 
        SET estado = 'disponible' 
        WHERE id = NEW.repartidor_fk;
    END IF;
END //

--- Aumentar en 1 el contador de pedidos mensuales de un cliente cada vez que hace una compra nueva
CREATE TRIGGER sumaPedidosCliente
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    UPDATE cliente 
    SET CantidadPedidos = CantidadPedidos + 1 
    WHERE id = NEW.cliente_fk;
END //
DELIMITER ;