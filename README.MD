# 🍕 Sistema de Gestión - Pizzería Don Piccolo

## 📋 Descripción del Proyecto
El sistema de gestión para la **Pizzería Don Piccolo** es una solución basada en bases de datos relacionales (MySQL) diseñada para administrar integralmente las operaciones del negocio. Permite registrar clientes, inventario de ingredientes, catálogo y recetas de pizzas, facturación de pedidos, y gestión de domicilios y repartidores.

## 🗄️ Estructura de la Base de Datos
El esquema `PizzeriaDonPiccolo` consta de las siguientes tablas principales:
- **cliente**: Almacena información personal y un contador de pedidos para fidelización.
- **pizza**: Catálogo de pizzas disponibles, cuyo precio se calcula dinámicamente con base en sus ingredientes.
- **ingrediente**: Control de inventario con alertas de stock mínimo.
- **receta**: Tabla puente que define los ingredientes y proporciones de cada pizza.
- **pedido** y **detalle_pedido**: Registro de ventas, vinculados al cliente y a los productos comprados.
- **repartidor** y **domicilio**: Logística de envíos, tiempos de entrega y costos asociados.
- **historial_precios**: Tabla de auditoría para rastrear los cambios en los precios de las pizzas.

## ⚙️ Lógica de Negocio Implementada

### ⚡ Triggers
1. **CalcularPrecioPizza / actualizarPrecioPizzaIngrediente**: Calculan y actualizan automáticamente el precio de venta de una pizza agregando un 50% de rentabilidad sobre el costo de los ingredientes.
2. **validarDescuentoMateriales**: Descuenta los ingredientes del inventario al confirmar un pedido y bloquea la operación si el stock es insuficiente.
3. **CambioPrecioPizzaRegistro**: Guarda un registro histórico ante cualquier modificación del precio de una pizza.
4. **LiberarRepartidor**: Vuelve a poner en estado "disponible" a un repartidor una vez completa su entrega.
5. **sumaPedidosCliente**: Aumenta el contador mensual de pedidos del cliente al registrar una nueva venta.

### 🛠️ Funciones y Procedimientos (Stored Procedures)
- `CalcularTotalIva`: Calcula el monto total del pedido sumando las pizzas, el domicilio y un 19% de IVA.
- `GananciaDiariaNeta`: Retorna el balance neto diario (Ventas totales - Costo de ingredientes).
- `domicilioEntregado`: Marca la hora de entrega, actualiza el estado del pedido a "entregado" y libera al repartidor.
- `BuscarClientePorMonto` / `BuscarPizza`: Procedimientos para realizar búsquedas parametrizadas rápidas.

### 📅 Eventos
- `reiniciar_contador_pedidos`: Tarea automatizada que limpia el contador de pedidos de todos los clientes cada mes para gestionar la fidelidad de forma recurrente.

### 👁️ Vistas
- **vista_resumen_clientes**: Consolida la cantidad de pedidos y el total gastado por cliente.
- **vista_desempeno_repartidores**: Muestra los tiempos promedio de entrega por repartidor.
- **vista_stock_critico**: Identifica los ingredientes cuyo stock está por debajo del límite mínimo.

## 🚀 Instrucciones de Despliegue
Para inicializar el sistema correctamente, ejecuta los scripts SQL en el siguiente orden:
1. `DB.SQL` (Creación de esquema y tablas).
2. `FUNCION.SQL` (Funciones y procedimientos almacenados).
3. `TRIGGERS.SQL` (Disparadores lógicos).
4. `EVENT.SQL` (Eventos programados).
5. `VISTAS.SQL` (Vistas de reportes).
6. Ejecutar el script de Inserción de Datos de Prueba (Mock Data).
7. `CONSULTAS.SQL` (Para verificar el correcto funcionamiento).

---

## ⚠️ ADVERTENCIA IMPORTANTE: Flujo de Registro de Pizzas
Para que los triggers calculen el precio de manera automática correctamente, se debe seguir este orden estricto al registrar un nuevo producto:
1. **Crear la pizza** en la tabla `pizza` (se puede inicializar con precio `0`).
2. **Crear o verificar los ingredientes** en la tabla `ingrediente` asegurándose de que tengan su precio unitario.
3. **Vincularlos en la tabla `receta`** agregando los ingredientes correspondientes a la pizza. 

*Nota: Solo al hacer la inserción en la tabla `receta`, el sistema calculará y actualizará el precio de la pizza de manera automática en base a sus costos.*