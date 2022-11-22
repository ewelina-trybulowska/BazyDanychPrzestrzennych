create database cwiczenia5
create extension postgis

--ZADANIE 1
CREATE TABLE obiekty(
	id SERIAL,
	nazwa VARCHAR(10),
	geom GEOMETRY
)
	
	
--a
INSERT INTO obiekty(nazwa, geom) VALUES(
	'obiekt1', ST_COLLECT(Array[
	'LINESTRING(0 1, 1 1)',
	'CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1)',
	'LINESTRING(5 1, 6 1)'])
)

--b
INSERT INTO obiekty(nazwa, geom) VALUES(
	'obiekt2', ST_COLLECT(Array[
	'LINESTRING(10 2, 10 6, 14 6)',
	'CIRCULARSTRING(14 6, 16 4, 14 2)',
	'CIRCULARSTRING(14 2, 12 0, 10 2)',
	'CIRCULARSTRING(13 2, 11 2, 13 2)'])
)

--c
INSERT INTO obiekty(nazwa, geom) VALUES
('obiekt3', 'POLYGON((10 17, 12 13, 7 15, 10 17))')

--d
INSERT INTO obiekty(nazwa, geom) VALUES
('obiekt4','LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')

--e
INSERT INTO obiekty(nazwa, geom) VALUES
('obiekt5', 'MULTIPOINT((30 30 59),(38 32 234))')

--f
INSERT INTO obiekty(nazwa, geom) VALUES(
	'obiekt6', ST_COLLECT(Array[
	'LINESTRING(1 1, 3 2)',
	'POINT(4 2)'])
)


--ZADANIE 2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(
	(SELECT geom FROM obiekty WHERE nazwa='obiekt3'),
	(SELECT geom FROM obiekty WHERE nazwa='obiekt4')), 5))
	
--ZADANIE 3 --Figura musi być zamknięta, trzeba połączyć niezłączone końce obiektu
UPDATE obiekty
SET geom = 'POLYGON((20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20))'
WHERE nazwa='obiekt4'

--ZADANIE 4 --update zrobic
INSERT INTO obiekty(nazwa, geom) VALUES (
	'obiekt7', ST_Collect((SELECT geom FROM obiekty WHERE nazwa='obiekt3'), 
						(SELECT geom FROM obiekty WHERE nazwa='obiekt4'))
)
							 
--ZADANIE 5
SELECT SUM(ST_Area(ST_Buffer(geom, 5)))
FROM obiekty 
WHERE ST_HasArc(geom) = false




