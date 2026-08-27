CREATE SCHEMA IF NOT EXISTS PizzeriaDonPiccolo DEFAULT CHARACTER SET utf8mb4;
USE PizzeriaDonPiccolo;
CREATE TABLE IF NOT EXISTS cliente (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  direccion VARCHAR(150) NOT NULL,
  correo_electronico VARCHAR(100) NOT NULL,
  CantidadPedidos INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS pizza (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  tamaño VARCHAR(20) NOT NULL,
  precio DECIMAL(10,2) NOT NULL, -- <--- Cambiado de precio_base a precio
  tipo ENUM('vegetariana', 'especial', 'clásica') NOT NULL,
  PRIMARY KEY (id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS ingrediente (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  stock_minimo INT NOT NULL DEFAULT 10,
  precio_unitario DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (id)
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS receta (
  id INT NOT NULL AUTO_INCREMENT,
  pizza_fk INT NOT NULL,
  ingrediente_fk INT NOT NULL,
  cantidad INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (pizza_fk) REFERENCES pizza(id) ON DELETE CASCADE,
  FOREIGN KEY (ingrediente_fk) REFERENCES ingrediente(id) ON DELETE CASCADE
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS historial_precios (
  id INT NOT NULL AUTO_INCREMENT,
  pizza_fk INT NOT NULL,
  precio_anterior DECIMAL(10,2) NOT NULL,
  precio_nuevo DECIMAL(10,2) NOT NULL,
  fecha_modificacion DATETIME NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (pizza_fk) REFERENCES pizza(id) ON DELETE CASCADE
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS pedido (
  id INT NOT NULL AUTO_INCREMENT,
  cliente_fk INT NOT NULL,
  fecha DATETIME NOT NULL,
  metodo_pago ENUM('efectivo', 'tarjeta', 'app') NOT NULL,
  estado ENUM('pendiente', 'en preparación', 'entregado', 'cancelado') NOT NULL DEFAULT 'pendiente',
  total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (id),
  FOREIGN KEY (cliente_fk) REFERENCES cliente(id)
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS detalle_pedido (
  id INT NOT NULL AUTO_INCREMENT,
  pedido_fk INT NOT NULL,
  pizza_fk INT NOT NULL,
  cantidad INT NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  FOREIGN KEY (pedido_fk) REFERENCES pedido(id) ON DELETE CASCADE,
  FOREIGN KEY (pizza_fk) REFERENCES pizza(id)
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS repartidor (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  zona_asignada VARCHAR(50) NOT NULL,
  estado ENUM('disponible', 'no disponible') NOT NULL DEFAULT 'disponible',
  PRIMARY KEY (id)
) ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS domicilio (
  id INT NOT NULL AUTO_INCREMENT,
  pedido_fk INT NOT NULL,
  repartidor_fk INT NOT NULL,
  hora_salida DATETIME NULL,
  hora_entrega DATETIME NULL,
  distancia_aproximada DECIMAL(5,2) NOT NULL,
  costo_envio DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (pedido_fk) REFERENCES pedido(id) ON DELETE CASCADE,
  FOREIGN KEY (repartidor_fk) REFERENCES repartidor(id)
) ENGINE = InnoDB;
