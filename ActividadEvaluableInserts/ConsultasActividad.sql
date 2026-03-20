-- Creación de la tabla de productos
CREATE TABLE productos_u4 (
    product_id          NUMBER(6) PRIMARY KEY,
    product_name        VARCHAR2(50),
    product_description VARCHAR2(1000),
    category_id         NUMBER(2),
    list_price          NUMBER(8,2),
    min_price           NUMBER(8,2),
    product_status      VARCHAR2(20)
);

-- Datos base de productos
INSERT INTO productos_u4 VALUES (10, 'Monitor 24', 'FHD LED', 1, 150.00, 130.00, 'available');
INSERT INTO productos_u4 VALUES (20, 'Teclado Mecánico', 'RGB Switch Blue', 1, 80.00, 60.00, 'available');
INSERT INTO productos_u4 VALUES (30, 'Smartphone X', '128GB 5G', 2, 1200.00, 1000.00, 'available');

-- Creación de la tabla de inventario
CREATE TABLE inventario_u4 (
    product_id       NUMBER(6),
    warehouse_id     NUMBER(3),
    quantity_on_hand NUMBER(8),
    CONSTRAINT pk_inv PRIMARY KEY (product_id, warehouse_id)
);

-- Datos base de inventario
INSERT INTO inventario_u4 VALUES (10, 1, 50);
INSERT INTO inventario_u4 VALUES (20, 1, 0); 
COMMIT;

--Bloque 2
INSERT INTO productos_u4 (product_id, product_name, list_price, product_status) 
VALUES (7000, 'Raton Gaming', 45.50, 'available');

INSERT INTO productos_u4 VALUES (7001, 'Webcam 4K', 'Camara con microfono', 1, 120.00, 100.00, 'available');

INSERT INTO productos_u4 (product_id, product_name) 
VALUES (7002, 'Alfombrilla XL');

INSERT INTO productos_u4 (product_id, product_name, list_price) 
VALUES (7003, 'Cable HDMI', 10 * 1.21);

INSERT INTO productos_u4 (product_id, product_name, list_price)
SELECT 7004, 'Producto Medio', AVG(list_price) 
FROM productos_u4;

INSERT INTO productos_u4 (product_id, product_name, category_id)
SELECT 7005, product_name || ' v2', category_id 
FROM productos_u4 WHERE product_id = 10;

INSERT INTO productos_u4 (product_id, product_name, product_status) 
VALUES (7006, 'Disquete', 'obsolete');

INSERT INTO productos_u4 (product_id, product_name, min_price)
SELECT 7007, 'Producto Barato', MIN(min_price) 
FROM productos_u4;

INSERT INTO productos_u4 (product_id, product_name, list_price)
SELECT product_id + 5000, product_name, list_price 
FROM productos_u4 
WHERE list_price > 100;

-- Creamos la tabla destino
CREATE TABLE precios_altos (
    product_id NUMBER(6) PRIMARY KEY,
    product_name VARCHAR2(50),
    list_price NUMBER(8,2)
);

-- Inserción masiva
INSERT INTO precios_altos (product_id, product_name, list_price)
SELECT product_id, product_name, list_price 
FROM productos_u4 
WHERE list_price > 1000;

--Bloque 3 
INSERT INTO productos_u4 (product_id, product_name, list_price, product_status) 
VALUES (7000, 'Raton Gaming', 45.50, 'available');

INSERT INTO productos_u4 VALUES (7001, 'Webcam 4K', 'Camara con microfono', 1, 120.00, 100.00, 'available');

INSERT INTO productos_u4 (product_id, product_name) 
VALUES (7002, 'Alfombrilla XL');

INSERT INTO productos_u4 (product_id, product_name, list_price) 
VALUES (7003, 'Cable HDMI', 10 * 1.21);

INSERT INTO productos_u4 (product_id, product_name, list_price)
SELECT 7004, 'Producto Medio', AVG(list_price) 
FROM productos_u4;

INSERT INTO productos_u4 (product_id, product_name, category_id)
SELECT 7005, product_name || ' v2', category_id 
FROM productos_u4 WHERE product_id = 10;

INSERT INTO productos_u4 (product_id, product_name, product_status) 
VALUES (7006, 'Disquete', 'obsolete');

INSERT INTO productos_u4 (product_id, product_name, min_price)
SELECT 7007, 'Producto Barato', MIN(min_price) 
FROM productos_u4;

INSERT INTO productos_u4 (product_id, product_name, list_price)
SELECT product_id + 5000, product_name, list_price 
FROM productos_u4 
WHERE list_price > 100;

-- Creamos la tabla destino
CREATE TABLE precios_altos (
    product_id NUMBER(6) PRIMARY KEY,
    product_name VARCHAR2(50),
    list_price NUMBER(8,2)
);

-- Inserción masiva
INSERT INTO precios_altos (product_id, product_name, list_price)
SELECT product_id, product_name, list_price 
FROM productos_u4 
WHERE list_price > 1000;

--Bloque 4 
DELETE FROM productos_u4 WHERE product_id = 7000;

DELETE FROM productos_u4 WHERE product_status = 'discontinued';

DELETE FROM productos_u4 WHERE list_price < 50;

DELETE FROM productos_u4 WHERE product_name LIKE '%Raton%';

DELETE FROM productos_u4 WHERE product_id IN (7001, 7002);

DELETE FROM productos_u4 
WHERE list_price > (SELECT AVG(list_price) FROM productos_u4);

DELETE FROM inventario_u4 WHERE quantity_on_hand = 0;

DELETE FROM productos_u4 
WHERE product_id NOT IN (SELECT product_id FROM inventario_u4);

DELETE FROM productos_u4 WHERE product_id >= 5000;

-- Bloque 5
--Apartado 1 
CREATE TABLE cuenta_bancaria (
id NUMBER PRIMARY KEY,
titular VARCHAR2(50),
saldo NUMBER(10,2)
);

INSERT INTO cuenta_bancaria VALUES (1, 'Usuario A', 1000);
INSERT INTO cuenta_bancaria VALUES (2, 'Usuario B', 2000);
COMMIT;

-- 1. Verificamos el saldo inicial de la cuenta 1 (Debería ser 1000)
SELECT * FROM cuenta_bancaria WHERE id_cuenta = 1;

-- 2. Iniciamos la transacción: Restamos 100€ de la cuenta 1
UPDATE cuenta_bancaria 
SET saldo = saldo - 100 
WHERE id_cuenta = 1;

-- 3. Verificamos que el saldo ha bajado a 900 temporalmente
SELECT * FROM cuenta_bancaria WHERE id_cuenta = 1;

-- 4. Simulamos un fallo del sistema. Para que el dinero no "desaparezca", deshacemos el cambio:
ROLLBACK;

-- 5. Comprobamos que el saldo ha vuelto de forma segura a 1000
SELECT * FROM cuenta_bancaria WHERE id_cuenta = 1;


-- Escenario 2 
-- Paso 1: Comprobamos el estado inicial de nuestras cuentas
SELECT * FROM cuenta_bancaria;

-- Paso 2: Hacemos una operación correcta (Ej. Ingresamos 200€ a la cuenta 2)
UPDATE cuenta_bancaria 
SET saldo = saldo + 200 
WHERE id_cuenta = 2;

-- Paso 3: Creamos un punto de guardado (SAVEPOINT) porque hasta aquí todo está bien
SAVEPOINT punto_seguro;

-- Paso 4: Hacemos una segunda operación simulando un error grave (Ej. Vaciamos la cuenta 1 por accidente)
UPDATE cuenta_bancaria 
SET saldo = 0 
WHERE id_cuenta = 1;

-- Paso 5: Comprobamos el desastre (La cuenta 1 está a 0)
SELECT * FROM cuenta_bancaria;

-- Paso 6: Deshacemos SOLO hasta el punto de guardado, salvando la operación de la cuenta 2
ROLLBACK TO punto_seguro;

-- Paso 7: Confirmamos definitivamente los cambios correctos en la base de datos
COMMIT;

-- Paso 8: Comprobamos que la cuenta 2 tiene sus 200€ extra, pero la cuenta 1 recuperó su saldo original
SELECT * FROM cuenta_bancaria;



-- Escenario 3
SELECT * FROM cuenta_bancaria WHERE id_cuenta = 1;

UPDATE cuenta_bancaria 
SET saldo = saldo - 50 
WHERE id_cuenta = 1;

UPDATE cuenta_bancaria 
SET saldo = saldo + 50 
WHERE id_cuenta = 1;


COMMIT;



SELECT * FROM cuenta_bancaria WHERE id_cuenta = 1;