CREATE DATABASE CINE
GO
USE CINE
-- Ejercicio 2: Instrucciones de SQL para la creación de las tablas
CREATE TABLE Sucursal (
	ID_Suc smallint PRIMARY KEY IDENTITY,
	ciudadSuc varchar(20));

CREATE TABLE Sala (
	ID_Sala smallint PRIMARY KEY IDENTITY,
	ID_Suc smallint NOT NULL,
	cantBut smallint,
	FOREIGN KEY (ID_Suc) REFERENCES Sucursal(ID_Suc));

CREATE TABLE Pelicula (
	nombrePel varchar(50) PRIMARY KEY,
	APT BIT,
	Genero varchar(20));

CREATE TABLE Funcion (
	ID_Func smallint PRIMARY KEY IDENTITY,
	nombrePel varchar(50),
	fecha date NOT NULL,
	hora time NOT NULL,
	ID_Sala smallint NOT NULL,

	FOREIGN KEY (ID_Sala) REFERENCES Sala(ID_Sala),
	FOREIGN KEY (nombrePel) REFERENCES Pelicula(nombrePel)
	);


CREATE TABLE Butaca (
	ID_Butaca smallint PRIMARY KEY IDENTITY,
	ubicacion smallint NOT NULL,
	vendida BIT,
	fecha date NOT NULL,
	hora time NOT NULL,
	ID_Sala smallint NOT NULL,
	FOREIGN KEY (ID_Sala) REFERENCES Sala(ID_Sala));

-- Agregado de CONSTRAINT UNIQUE, ya que no pueden haber dos funciones con mismo horario y sala
ALTER TABLE Funcion
ADD UNIQUE(fecha, hora, ID_Sala);

ALTER TABLE Butaca
ADD UNIQUE(ubicacion, fecha, hora, ID_Sala);

-- Ejercicio 3: Inserción de datos
--a) Las tres sucursales
INSERT INTO Sucursal (ciudadSuc)
VALUES ('Rosario'), ('Córdoba'), ('La Plata');

--b) Al menos 3 salas por sucursal
INSERT INTO Sala (ID_Suc, cantBut)
VALUES (1, 20), (1, 25), (1, 30), (1,30), (2, 30), (2, 25), (2,25), (3, 20), (3,25) , (3,20)
--c) Al menos 5 películas
INSERT INTO Pelicula
VALUES 
	('Argentina, 1985', 0, 'Drama'),
	('Star Wars III', 1, 'Ciencia ficción'),
	('Batman: El Caballero de la noche', 0, 'Acción'),
	('Rio', 1, 'Comedia'),
	('Scarface', 0, 'Acción'),
	('Chucky', 0, 'Suspenso');
-- 0 = no ATP, 1 = ATP


--e) Al menos 5 funciones
INSERT INTO Funcion 
VALUES 
	('Argentina, 1985','2022-10-26','15:00:00',1),
	('Argentina, 1985','2022-10-26','12:00:00',6),
	('Star Wars III','2022-11-03','23:00:00',5),
	('Star Wars III','2022-11-01','13:00:00',10),
	('Batman: El Caballero de la noche','2022-11-03','21:00:00',4),
	('Batman: El Caballero de la noche','2022-11-07','11:00:00',7),
	('Rio','2022-10-29','19:00:00',9),
	('Rio','2022-10-27','12:00:00',8),
	('Scarface','2022-10-15','10:00:00',2),
	('Scarface','2022-10-18','22:00:00',9),
	('Chucky','2022-11-03','22:00:00',7),
	('Chucky','2022-11-05','22:00:00',9)


-- Ejercicio 4: Consultas

--a) Funciones en la sucursal de La Plata (ID de sucursal 3)
SELECT COUNT(*) AS 'Cantidad total de funciones en La Plata'
FROM Funcion
WHERE ID_Sala IN (
	SELECT ID_Sala
	FROM Sala
	WHERE ID_Suc = 3)

--b)
SELECT nombrePel
FROM Funcion
WHERE ID_Sala IN (
	SELECT ID_Sala
	FROM Sala
	WHERE ID_Suc = 2)
	AND fecha = '2022-11-03'

--c)
SELECT hora
FROM Funcion
WHERE nombrePel = 'Argentina, 1985' 
AND fecha = '2022-10-26' 
AND ID_Sala IN (
	SELECT ID_Sala
	FROM Sala
	WHERE ID_Suc = 1)

--d)

SELECT ID_Suc,hora
FROM Funcion AS F, Sala AS S
WHERE nombrePel = 'Argentina, 1985'
AND
fecha =  '2022-10-26'
AND F.ID_Sala = S.ID_Sala
ORDER BY hora ASC

--e)

SELECT *
FROM Funcion
WHERE fecha BETWEEN '2022-10-24' AND '2022-10-31'
AND ID_Sala IN (
	SELECT ID_Sala
	FROM Sala
	WHERE ID_Suc = 1)
AND nombrePel IN (
	SELECT nombrePel
	FROM Pelicula
	WHERE Genero = 'Ciencia Ficcion')

--f)
SELECT *
FROM Butaca
WHERE 
	(vendida = 1
	and
	ID_Sala IN (SELECT ID_Sala FROM Sala WHERE (ID_Suc = 2))
	and
	ID_Sala IN (SELECT ID_Sala FROM Funcion WHERE (nombrePel = 'Argentina, 1985'))
	)

--g)

SELECT *
FROM Butaca
WHERE 
	(vendida = 0
	and
	ID_Sala IN (SELECT ID_Sala FROM Sala WHERE (ID_Suc = 2))
	and
	ID_Sala IN (SELECT ID_Sala FROM Funcion WHERE (nombrePel = 'Argentina, 1985'))
	)


--h)

SELECT Genero, COUNT(*)
FROM Pelicula
GROUP BY Genero

-- Ejercicio 5:
--Modificaciones:

--a)

alter table sucursal
add precio float

UPDATE Sucursal
SET precio = 200
where ciudadSuc = 'Rosario'
UPDATE Sucursal
SET precio = 250
where ciudadSuc = 'Córdoba'
UPDATE Sucursal
SET precio = 300
where ciudadSuc = 'la Plata'

--b)

alter table Pelicula
add precio float;

UPDATE Pelicula
SET precio = 200
where nombrePel= 'Argentina, 1985'
UPDATE Pelicula
SET precio = 280
where nombrePel= 'Star Wars III'
UPDATE Pelicula
SET precio = 300
where nombrePel= 'Batman: El Caballero de la noche'
UPDATE Pelicula
SET precio = 205
where nombrePel= 'Rio'
UPDATE Pelicula
SET precio = 210
where nombrePel= 'Scarface'
UPDATE Pelicula
SET precio = 400
where nombrePel= 'Chucky'

--c)

--Para resolver este problema hay que alterar la tabla de butacas y agregar dos precios
--diferentes de butacas dependiendo si esta o no dentro de un rango de butacas "premium"

-- Ejercicio 6:
-- a) Total recaudado por función

INSERT INTO Butaca (ubicacion, vendida, fecha, hora, ID_Sala)
VALUES
	(1, 1,'2022-10-26','15:00:00', 1),
	(2, 1,'2022-10-26','15:00:00', 1),
	(3, 1,'2022-10-26','15:00:00', 1),
	(4, 1,'2022-10-26','15:00:00', 1),
	(5, 1,'2022-10-26','15:00:00', 1),
	(6, 0,'2022-10-26','15:00:00', 1),
	(7, 1,'2022-10-26','15:00:00', 1),
	(8, 1,'2022-10-26','15:00:00', 1),
	(9, 1,'2022-10-26','15:00:00', 1),
	(10, 1, '2022-10-26','15:00:00', 1),
	(11, 0,'2022-10-26','15:00:00', 1),
	(12, 1,'2022-10-26','15:00:00', 1),
	(13, 1,'2022-10-26','15:00:00', 1),
	(14, 0,'2022-10-26','15:00:00', 1),
	(15, 1, '2022-10-26','15:00:00', 1),
	(16, 1,'2022-10-26','15:00:00', 1),
	(17, 0,'2022-10-26','15:00:00', 1),
	(18, 1,'2022-10-26','15:00:00', 1),
	(19, 1, '2022-10-26','15:00:00', 1),
	(20, 0, '2022-10-26','15:00:00', 1),
	(1, 1,'2022-10-26','12:00:00', 6),
	(2, 1,'2022-10-26','12:00:00', 6),
	(3, 1,'2022-10-26','12:00:00', 6),
	(4, 1,'2022-10-26','12:00:00', 6),
	(5, 1,'2022-10-26','12:00:00', 6),
	(6, 0,'2022-10-26','12:00:00', 6),
	(7, 1,'2022-10-26','12:00:00', 6),
	(8, 1,'2022-10-26','12:00:00', 6),
	(9, 1,'2022-10-26','12:00:00', 6),
	(10, 1, '2022-10-26','12:00:00', 6),
	(11, 0,'2022-10-26','12:00:00', 6),
	(12, 0,'2022-10-26','12:00:00', 6),
	(13, 1,'2022-10-26','12:00:00', 6),
	(14, 0,'2022-10-26','12:00:00', 6),
	(15, 1, '2022-10-26','12:00:00', 6),
	(16, 1,'2022-10-26','12:00:00', 6),
	(17, 0,'2022-10-26','12:00:00', 6),
	(18, 0,'2022-10-26','12:00:00', 6),
	(19, 1, '2022-10-26','12:00:00', 6),
	(20, 0, '2022-10-26','12:00:00', 6),
	(21, 0,'2022-10-26','12:00:00', 6),
	(22, 0,'2022-10-26','12:00:00', 6),
	(23, 0,'2022-10-26','12:00:00', 6),
	(24, 0, '2022-10-26','12:00:00', 6),
	(25, 0, '2022-10-26','12:00:00', 6),
	(1, 1,'2022-11-03','23:00:00', 5),
	(2, 1,'2022-11-03','23:00:00', 5),
	(3, 1,'2022-11-03','23:00:00', 5),
	(4, 1,'2022-11-03','23:00:00', 5),
	(5, 1,'2022-11-03','23:00:00', 5),
	(6, 1,'2022-11-03','23:00:00', 5),
	(7, 1,'2022-11-03','23:00:00', 5),
	(8, 1,'2022-11-03','23:00:00', 5),
	(9, 1,'2022-11-03','23:00:00', 5),
	(10, 1, '2022-11-03','23:00:00', 5),
	(11, 1,'2022-11-03','23:00:00', 5),
	(12, 1,'2022-11-03','23:00:00', 5),
	(13, 1,'2022-11-03','23:00:00', 5),
	(14, 1,'2022-11-03','23:00:00', 5),
	(15, 1, '2022-11-03','23:00:00', 5),
	(16, 1,'2022-11-03','23:00:00', 5),
	(17, 1,'2022-11-03','23:00:00', 5),
	(18, 0,'2022-11-03','23:00:00', 5),
	(19, 1, '2022-11-03','23:00:00', 5),
	(20, 0, '2022-11-03','23:00:00', 5),
	(21, 1,'2022-11-03','23:00:00', 5),
	(22, 1,'2022-11-03','23:00:00', 5),
	(23, 1,'2022-11-03','23:00:00', 5),
	(24, 1, '2022-11-03','23:00:00', 5),
	(25, 1, '2022-11-03','23:00:00', 5),
	(26, 1,'2022-11-03','23:00:00', 5),
	(27, 1,'2022-11-03','23:00:00', 5),
	(28, 0,'2022-11-03','23:00:00', 5),
	(29, 1, '2022-11-03','23:00:00', 5),
	(30, 1, '2022-11-03','23:00:00', 5),
	(1, 1,'2022-11-01','13:00:00', 10),
	(2, 0,'2022-11-01','13:00:00', 10),
	(3, 1,'2022-11-01','13:00:00', 10),
	(4, 0,'2022-11-01','13:00:00', 10),
	(5, 1,'2022-11-01','13:00:00', 10),
	(6, 0,'2022-11-01','13:00:00', 10),
	(7, 0,'2022-11-01','13:00:00', 10),
	(8, 0,'2022-11-01','13:00:00', 10),
	(9, 0,'2022-11-01','13:00:00', 10),
	(10, 0, '2022-11-01','13:00:00', 10),
	(11, 1,'2022-11-01','13:00:00', 10),
	(12, 0,'2022-11-01','13:00:00', 10),
	(13, 0,'2022-11-01','13:00:00', 10),
	(14, 0,'2022-11-01','13:00:00', 10),
	(15, 0, '2022-11-01','13:00:00', 10),
	(16, 0,'2022-11-01','13:00:00', 10),
	(17, 0,'2022-11-01','13:00:00', 10),
	(18, 0,'2022-11-01','13:00:00', 10),
	(19, 0, '2022-11-01','13:00:00', 10),
	(20, 0, '2022-11-01','13:00:00', 10),
	(1, 1,'2022-11-03','21:00:00', 4),
	(2, 1,'2022-11-03','21:00:00', 4),
	(3, 1,'2022-11-03','21:00:00', 4),
	(4, 1,'2022-11-03','21:00:00', 4),
	(5, 1,'2022-11-03','21:00:00', 4),
	(6, 1,'2022-11-03','21:00:00', 4),
	(7, 1,'2022-11-03','21:00:00', 4),
	(8, 1,'2022-11-03','21:00:00', 4),
	(9, 1,'2022-11-03','21:00:00', 4),
	(10, 1, '2022-11-03','21:00:00', 4),
	(11, 0,'2022-11-03','21:00:00', 4),
	(12, 0,'2022-11-03','21:00:00', 4),
	(13, 1,'2022-11-03','21:00:00', 4),
	(14, 0,'2022-11-03','21:00:00', 4),
	(15, 1, '2022-11-03','21:00:00', 4),
	(16, 0,'2022-11-03','21:00:00', 4),
	(17, 1,'2022-11-03','21:00:00', 4),
	(18, 0,'2022-11-03','21:00:00', 4),
	(19, 1, '2022-11-03','21:00:00', 4),
	(20, 0, '2022-11-03','21:00:00', 4),
	(21, 1,'2022-11-03','21:00:00', 4),
	(22, 0,'2022-11-03','21:00:00', 4),
	(23, 1,'2022-11-03','21:00:00', 4),
	(24, 0, '2022-11-03','21:00:00', 4),
	(25, 0, '2022-11-03','21:00:00', 4),
	(26, 1,'2022-11-03','21:00:00', 4),
	(27, 1,'2022-11-03','21:00:00', 4),
	(28, 0,'2022-11-03','21:00:00', 4),
	(29, 1, '2022-11-03','2:00:00', 4),
	(30, 1, '2022-11-03','21:00:00', 4),
	(1, 0,'2022-11-07','11:00:00', 7),
	(2, 0,'2022-11-07','11:00:00', 7),
	(3, 0,'2022-11-07','11:00:00', 7),
	(4, 1,'2022-11-07','11:00:00', 7),
	(5, 0,'2022-11-07','11:00:00', 7),
	(6, 1,'2022-11-07','11:00:00', 7),
	(7, 0,'2022-11-07','11:00:00', 7),
	(8, 1,'2022-11-07','11:00:00', 7),
	(9, 0,'2022-11-07','11:00:00', 7),
	(10, 1, '2022-11-07','11:00:00', 7),
	(11, 1,'2022-11-07','11:00:00', 7),
	(12, 0,'2022-11-07','11:00:00', 7),
	(13, 1,'2022-11-07','11:00:00', 7),
	(14, 0,'2022-11-07','11:00:00', 7),
	(15, 1, '2022-11-07','11:00:00', 7),
	(16, 0,'2022-11-07','11:00:00', 7),
	(17, 1,'2022-11-07','11:00:00', 7),
	(18, 0,'2022-11-07','11:00:00', 7),
	(19, 1, '2022-11-07','11:00:00', 7),
	(20, 0, '2022-11-07','11:00:00', 7),
	(21, 1,'2022-11-07','11:00:00', 7),
	(22, 0,'2022-11-07','11:00:00', 7),
	(23, 1,'2022-11-07','11:00:00', 7),
	(24, 0, '2022-11-07','11:00:00', 7),
	(25, 0, '2022-11-07','11:00:00', 7),
	(1, 0,'2022-10-29','19:00:00', 9),
	(2, 0,'2022-10-29','19:00:00', 9),
	(3, 0,'2022-10-29','19:00:00', 9),
	(4, 1,'2022-10-29','19:00:00', 9),
	(5, 0,'2022-10-29','19:00:00', 9),
	(6, 1,'2022-10-29','19:00:00', 9),
	(7, 0,'2022-10-29','19:00:00', 9),
	(8, 1,'2022-10-29','19:00:00', 9),
	(9, 0,'2022-10-29','19:00:00', 9),
	(10, 1, '2022-10-29','19:00:00', 9),
	(11, 1,'2022-10-29','19:00:00', 9),
	(12, 0,'2022-10-29','19:00:00', 9),
	(13, 1,'2022-10-29','19:00:00', 9),
	(14, 0,'2022-10-29','19:00:00', 9),
	(15, 1, '2022-10-29','19:00:00', 9),
	(16, 0,'2022-10-29','19:00:00', 9),
	(17, 1,'2022-10-29','19:00:00', 9),
	(18, 0,'2022-10-29','19:00:00', 9),
	(19, 1, '2022-10-29','19:00:00', 9),
	(20, 0, '2022-10-29','19:00:00', 9),
	(21, 1,'2022-10-29','19:00:00', 9),
	(22, 0,'2022-10-29','19:00:00', 9),
	(23, 1,'2022-10-29','19:00:00', 9),
	(24, 0, '2022-10-29','19:00:00', 9),
	(25, 0, '2022-10-29','19:00:00', 9),
	(1, 0,'2022-10-27','12:00:00', 8),
	(2, 0,'2022-10-27','12:00:00', 8),
	(3, 0,'2022-10-27','12:00:00', 8),
	(4, 0,'2022-10-27','12:00:00', 8),
	(5, 0,'2022-10-27','12:00:00', 8),
	(6, 0,'2022-10-27','12:00:00', 8),
	(7, 0,'2022-10-27','12:00:00', 8),
	(8, 1,'2022-10-27','12:00:00', 8),
	(9, 0,'2022-10-27','12:00:00', 8),
	(10, 0, '2022-10-27','12:00:00', 8),
	(11, 0,'2022-10-27','12:00:00', 8),
	(12, 0,'2022-10-27','12:00:00', 8),
	(13, 0,'2022-10-27','12:00:00', 8),
	(14, 0,'2022-10-27','12:00:00', 8),
	(15, 0, '2022-10-27','12:00:00', 8),
	(16, 0,'2022-10-29','12:00:00', 8),
	(17, 0,'2022-10-29','12:00:00', 8),
	(18, 0,'2022-10-29','12:00:00', 8),
	(19, 0, '2022-10-29','12:00:00', 8),
	(20, 0, '2022-10-29','12:00:00', 8),
	(1, 1,'2022-10-15','10:00:00', 2),
	(2, 1,'2022-10-15','10:00:00', 2),
	(3, 1,'2022-10-15','10:00:00', 2),
	(4, 1,'2022-10-15','10:00:00', 2),
	(5, 1,'2022-10-15','10:00:00', 2),
	(6, 1,'2022-10-15','10:00:00', 2),
	(7, 1,'2022-10-15','10:00:00', 2),
	(8, 1,'2022-10-15','10:00:00', 2),
	(9, 1,'2022-10-15','10:00:00', 2),
	(10, 1, '2022-10-15','10:00:00', 2),
	(11, 1,'2022-10-15','10:00:00', 2),
	(12, 1,'2022-10-15','10:00:00', 2),
	(13, 1,'2022-10-15','10:00:00', 2),
	(14, 1,'2022-10-15','10:00:00', 2),
	(15, 1, '2022-10-15','10:00:00',2),
	(16, 1,'2022-10-15','10:00:00', 2),
	(17, 1,'2022-10-15','10:00:00', 2),
	(18, 1,'2022-10-15','10:00:00', 2),
	(19, 1, '2022-10-15','10:00:00', 2),
	(20, 1, '2022-10-15','10:00:00', 2),
	(21, 1,'2022-10-15','10:00:00', 2),
	(22, 1,'2022-10-15','10:00:00', 2),
	(23, 1,'2022-10-15','10:00:00', 2),
	(24, 0, '2022-10-15','10:00:00', 2),
	(25, 1, '2022-10-15','10:00:00', 2),
	(1, 0,'2022-10-18','22:00:00', 9),
	(2, 0,'2022-10-18','22:00:00', 9),
	(3, 0,'2022-10-18','22:00:00', 9),
	(4, 1,'2022-10-18','22:00:00', 9),
	(5, 0,'2022-10-18','22:00:00', 9),
	(6, 1,'2022-10-18','22:00:00', 9),
	(7, 0,'2022-10-18','22:00:00', 9),
	(8, 1,'2022-10-18','22:00:00', 9),
	(9, 0,'2022-10-18','22:00:00', 9),
	(10, 1, '2022-10-18','22:00:00', 9),
	(11, 0,'2022-10-18','22:00:00', 9),
	(12, 0,'2022-10-18','22:00:00', 9),
	(13, 1,'2022-10-18','22:00:00', 9),
	(14, 0,'2022-10-18','22:00:00', 9),
	(15, 1, '2022-10-18','22:00:00', 9),
	(16, 0,'2022-10-18','22:00:00', 9),
	(17, 0,'2022-10-18','22:00:00', 9),
	(18, 0,'2022-10-18','22:00:00', 9),
	(19, 0, '2022-10-18','22:00:00', 9),
	(20, 0, '2022-10-18','22:00:00', 9),
	(21, 1,'2022-10-18','22:00:00', 9),
	(22, 0,'2022-10-18','22:00:00', 9),
	(23, 1,'2022-10-18','22:00:00', 9),
	(24, 0, '2022-10-18','22:00:00', 9),
	(25, 0, '2022-10-18','22:00:00', 9),
	(1, 1,'2022-11-03','22:00:00', 7),
	(2, 0,'2022-11-03','22:00:00', 7),
	(3, 1,'2022-11-03','22:00:00', 7),
	(4, 1,'2022-11-03','22:00:00', 7),
	(5, 1,'2022-11-03','22:00:00', 7),
	(6, 1,'2022-11-03','22:00:00', 7),
	(7, 0,'2022-11-03','22:00:00', 7),
	(8, 1,'2022-11-03','22:00:00', 7),
	(9, 1,'2022-11-03','22:00:00', 7),
	(10, 1, '2022-11-03','22:00:00', 7),
	(11, 1,'2022-11-03','22:00:00', 7),
	(12, 1,'2022-11-03','22:00:00', 7),
	(13, 1,'2022-11-03','22:00:00', 7),
	(14, 0,'2022-11-03','22:00:00', 7),
	(15, 1, '2022-11-03','22:00:00', 7),
	(16, 1,'2022-11-03','22:00:00', 7),
	(17, 1,'2022-11-03','22:00:00', 7),
	(18, 1,'2022-11-03','22:00:00', 7),
	(19, 1, '2022-11-03','22:00:00', 7),
	(20, 0, '2022-11-03','22:00:00', 7),
	(21, 1,'2022-11-03','22:00:00', 7),
	(22, 1,'2022-11-03','22:00:00', 7),
	(23, 1,'2022-11-03','22:00:00', 7),
	(24, 0, '2022-11-03','22:00:00', 7),
	(25, 1, '2022-11-03','22:00:00', 7),
	(1, 0,'2022-11-05','22:00:00', 9),
	(2, 0,'2022-11-05','22:00:00', 9),
	(3, 0,'2022-11-05','22:00:00', 9),
	(4, 1,'2022-11-05','22:00:00', 9),
	(5, 0,'2022-11-05','22:00:00', 9),
	(6, 1,'2022-11-05','22:00:00', 9),
	(7, 0,'2022-11-05','22:00:00', 9),
	(8, 0,'2022-11-05','22:00:00', 9),
	(9, 0,'2022-11-05','22:00:00', 9),
	(10, 1, '2022-11-05','22:00:00', 9),
	(11, 1,'2022-11-05','22:00:00', 9),
	(12, 0,'2022-11-05','22:00:00', 9),
	(13, 1,'2022-11-05','22:00:00', 9),
	(14, 0,'2022-11-05','22:00:00', 9),
	(15, 1, '2022-11-05','22:00:00', 9),
	(16, 1,'2022-11-05','22:00:00', 9),
	(17, 1,'2022-11-05','22:00:00', 9),
	(18, 0,'2022-11-05','22:00:00', 9),
	(19, 1, '2022-11-05','22:00:00', 9),
	(20, 1, '2022-11-05','22:00:00', 9),
	(21, 1,'2022-11-05','22:00:00', 9),
	(22, 0,'2022-11-05','22:00:00', 9),
	(23, 1,'2022-11-05','22:00:00', 9),
	(24, 0, '2022-11-05','22:00:00', 9),
	(25, 0, '2022-11-05','22:00:00', 9)


SELECT ID_Func , Pelicula.nombrePel, sum(precio) as 'Total_recaudado'
FROM Funcion , Butaca, Pelicula
WHERE
(Funcion.nombrePel = Pelicula.nombrePel) and
(Funcion.ID_Sala = Butaca.ID_Sala) and
(Funcion.fecha = Butaca.fecha) and
(Funcion.hora = Butaca.hora) and
(Butaca.vendida = 1)
GROUP BY ID_Func , Pelicula.nombrePel

-- b Determinar promedio recaudado por funcion para cada película.
-- Respecto del id de la película, hallar el promedio tomando todas las funciones sobre esa película

SELECT nombrePel , AVG(Funcion_Promedio.Total_recaudado) as 'Promedio recaudado por función'
FROM
(SELECT ID_Func , Pelicula.nombrePel, sum(precio) as 'Total_recaudado'
FROM Funcion , Butaca, Pelicula
WHERE
(Funcion.nombrePel = Pelicula.nombrePel) and
(Funcion.ID_Sala = Butaca.ID_Sala) and
(Funcion.fecha = Butaca.fecha) and
(Funcion.hora = Butaca.hora) and
(Butaca.vendida = 1)
GROUP BY ID_Func , Pelicula.nombrePel) as Funcion_Promedio
GROUP BY nombrePel

--c)


SELECT S.ID_Sala,F.nombrePel,B.fecha,B.hora, (SUM(CAST(B.vendida AS INT)*100/S.cantBut)) AS PORCENTAJE
FROM Sala AS S, Butaca AS B,Funcion AS F
WHERE S.ID_Sala = B.ID_Sala
AND S.ID_Sala = F.ID_Sala
AND F.fecha = B.fecha
AND F.hora = B.hora
GROUP BY  S.ID_Sala,F.nombrePel,B.fecha,B.hora
HAVING (SUM(CAST(B.vendida AS INT)*100/S.cantBut)) < 50

--d)

SELECT Funcion_Total.*
FROM
(
SELECT ID_Func , Pelicula.nombrePel , sum(precio) as Total_recaudado
FROM Funcion , Butaca, Pelicula
WHERE 
	(Funcion.nombrePel = Pelicula.nombrePel) and
	(Funcion.ID_Sala = Butaca.ID_Sala) and
	(Funcion.fecha = Butaca.fecha) and
	(Funcion.hora = Butaca.hora) and
	(Butaca.vendida = 1)
GROUP BY ID_Func, Pelicula.nombrePel
) AS Funcion_Total

LEFT JOIN

(
SELECT ID_Func , Pelicula.nombrePel , sum(precio) as Total_recaudado
FROM Funcion , Butaca, Pelicula
WHERE 
	(Funcion.nombrePel = Pelicula.nombrePel) and
	(Funcion.ID_Sala = Butaca.ID_Sala) and
	(Funcion.fecha = Butaca.fecha) and
	(Funcion.hora = Butaca.hora) and
	(Butaca.vendida = 1)
GROUP BY ID_Func, Pelicula.nombrePel
) tmp
	
	ON Funcion_Total.nombrePel = tmp.nombrePel AND Funcion_Total.Total_recaudado < tmp.Total_Recaudado
WHERE tmp.Total_recaudado IS NULL

----------------------------------------
--Trabajo Practico 2:
--2)
--  Nosotros lo penszamos de la manera que para cada plan hay que subscribirse, incluso en el plan gratuito
CREATE TABLE Usuarios (
	NombreUsuario varchar(50) PRIMARY KEY NOT NULL,
	Contraseña varchar(50) NOT NULL,
	TipoPlan varchar(10));

CREATE TABLE Pagos (
	IDPago int PRIMARY KEY IDENTITY NOT NULL,
	NombreUsuario varchar(50) NOT NULL,
	FechaComienzo date,
	PlazoPlan int, -- representa la cantidad de días a agregar a la fecha de comienzo
	TipoPlan varchar(10),
	FOREIGN KEY (NombreUsuario) REFERENCES Usuarios(NombreUsuario));


INSERT INTO Usuarios
VALUES
	('enzonob39','guemes','GRATUITO1'),
	('marisa23','hola123','GRATUITO1'),
	('mateoelmago','pelota','GRATUITO1'),
	('fabian123','123fabian','GRATUITO1'),
	('Usuario5','CONTRASENA5','GRATUITO1')

INSERT INTO Pagos(NombreUsuario, FechaComienzo, PlazoPlan, TipoPlan)
VALUES
	('Usuario5','2020-12-09',365,'PREMIUM'),
	('fabian123','2020-12-09',30,'FAMILIAR2'),
	('mateoelmago','2021-01-1', 365,'GRATUITO'),
	('marisa23','2022-5-2',30, 'FAMILIAR'),
	('enzonob39','2022-9-1', 30, 'GRATUITO'),
	('enzonob39','2022-8-1',30, 'PREMIUM'),
	('enzonob39','2022-12-2',30,'GRATUITO'),
	('marisa23','2022-12-2',30,'PREMIUM8'),
	('mateoelmago','2022-12-05',30,'PREMIUM'),
	('fabian123','2022-12-09',365,'FAMILIAR')


SELECT * FROM Usuarios


SELECT MAX(tmp.fecha) FROM
	(SELECT DATEADD(DAY,Pagos.PlazoPlan,Pagos.FechaComienzo) AS fecha from Pagos) as tmp

--3) AVANZANDO CON EL 3
GO
CREATE PROCEDURE pa_ActualizarPlanes

AS 

	

UPDATE Usuarios
SET TipoPlan = 'INACTIVO'
WHERE 
	(SELECT MAX(tmp.fecha) FROM
	(SELECT DATEADD(DAY,Pagos.PlazoPlan,Pagos.FechaComienzo) AS fecha from Pagos WHERE Pagos.NombreUsuario = Usuarios.NombreUsuario) as tmp)
	 < GETDATE()
-- Seleccionar la fecha del último pago realizado de cada usuario, chequear si vence hoy.

UPDATE Usuarios
SET TipoPlan = Pagos.TipoPlan
FROM Pagos
WHERE 
	(SELECT MAX(tmp.fecha) FROM
	(SELECT DATEADD(DAY,Pagos.PlazoPlan,Pagos.FechaComienzo) AS fecha from Pagos WHERE Pagos.NombreUsuario = Usuarios.NombreUsuario) as tmp)
	 > GETDATE()
	 AND
	(SELECT TipoPlan FROM 
	(SELECT TOP 1 TipoPlan, DATEADD(DAY,Pagos.PlazoPlan,Pagos.FechaComienzo) AS fecha from Pagos 
		WHERE Pagos.NombreUsuario = Usuarios.NombreUsuario
		ORDER BY fecha DESC) AS t)
	= Pagos.TipoPlan
	 

GO
--4)
GO

CREATE PROCEDURE pa_Login
@NombreUsuario varchar(50),
@Contraseña varchar(50),
@RESULTADO INT OUTPUT

AS

SELECT @RESULTADO = COUNT(*)
FROM Usuarios
WHERE NombreUsuario = @NombreUsuario and Contraseña = @Contraseña and TipoPlan is not NULL

RETURN;
GO

DECLARE @RESULTADO int
EXEC pa_Login 'enzonob39','guemes', @RESULTADO  OUTPUT
SELECT @RESULTADO
