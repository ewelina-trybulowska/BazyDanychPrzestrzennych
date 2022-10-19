CREATE DATABASE lab2;

CREATE EXTENSION postgis;

CREATE TABLE buildings (id INTEGER PRIMARY KEY, geometry GEOMETRY, name VARCHAR);
CREATE TABLE roads (id INTEGER PRIMARY KEY, geometry GEOMETRY, name VARCHAR);
CREATE TABLE poi (id INTEGER PRIMARY KEY, geometry GEOMETRY, name VARCHAR);


INSERT INTO buildings(id, geometry, name) VALUES 
	(1, ST_GeomFromText('POLYGON ((8 1.5, 10.5 1.5, 10.5 4, 8 4, 8 1.5))', 0), 'BuildingA'),
	(2, ST_GeomFromText('POLYGON ((4 5, 6 5, 6 7, 4 7, 4 5))', 0), 'BuildingB'),
	(3, ST_GeomFromText('POLYGON ((3 6, 5 6, 5 8, 3 8, 3 6))', 0), 'BuildingC'),
	(4, ST_GeomFromText('POLYGON ((9 8, 10 8, 10 9, 9 9, 9 8))', 0), 'BuildingD'),
	(5, ST_GeomFromText('POLYGON ((1 1, 2 1, 2 2, 1 2, 1 1))', 0), 'BuildingF');


INSERT INTO roads(id, geometry, name) VALUES 
	(1, ST_GeomFromText('LINESTRING (0 4.5, 12 4.5)', 0),'RoadX'),
	(2, ST_GeomFromText('LINESTRING (7.5 0, 7.5 10.5)', 0),'RoadY');

INSERT INTO poi(id, geometry, name) VALUES
	(1, ST_GeomFromText('POINT(1 3.5)', 0), 'G'),
	(2, ST_GeomFromText('POINT(5.5 1.5)', 0), 'H'),
	(3, ST_GeomFromText('POINT(9.5 6)', 0), 'I'),
	(4, ST_GeomFromText('POINT(6.5 6)', 0), 'J'),
	(5, ST_GeomFromText('POINT(6 9.5)', 0), 'K');




--6. Na bazie przygotowanych tabel wykonaj poniższe polecenia:

--a. Wyznacz całkowitą długość dróg w analizowanym mieście. 
SELECT SUM(ST_Length(geometry)) FROM roads


--b. Wypisz geometrię (WKT), pole powierzchni oraz obwód poligonu reprezentującego 
	--budynek o nazwie BuildingA. 

SELECT geometry, ST_Area(geometry), ST_Perimeter(geometry)
FROM buildings
WHERE name = 'BuildingA'


--c. Wypisz nazwy i pola powierzchni wszystkich poligonów w warstwie budynki. Wyniki 
	--posortuj alfabetycznie. 
SELECT name, ST_Area(geometry)
FROM buildings
ORDER BY name


--d. Wypisz nazwy i obwody 2 budynków o największej powierzchni. 
SELECT name, ST_Perimeter(geometry)
FROM buildings
ORDER BY ST_Area(geometry) desc
LIMIT 2


--e. Wyznacz najkrótszą odległość między budynkiem BuildingC a punktem K. 
SELECT MIN(ST_Distance(buildings.geometry, poi.geometry))
FROM buildings, poi
WHERE buildings.name = 'BuildingC' AND poi.name = 'K'


--f. Wypisz pole powierzchni tej części budynku BuildingC, która znajduje się w odległości 
	--większej niż 0.5 od budynku BuildingB. 

--ST_Intersection->zwraca część geometrii A i geometrii B, która jest dzielona między dwie geometrie.
--ST_Buffer — Oblicza geometrię obejmującą wszystkie punkty,których odległość od geometrii jest mniejsza lub równa danej odległości


SELECT ST_Area(ST_Intersection((SELECT geometry FROM buildings WHERE name = 'BuildingC'),
								ST_Buffer((SELECT geometry FROM buildings WHERE name='BuildingB'), 0.5)));

																
--g. Wybierz te budynki, których centroid (ST_Centroid) znajduje się powyżej drogi 
	--o nazwie RoadX. 
	
SELECT buildings.name, ST_Centroid(buildings.geometry)
FROM buildings, roads
WHERE ST_Y(ST_Centroid(buildings.geometry)) > ST_Y(ST_Centroid(roads.geometry)) 
AND roads.name = 'RoadX';



--8. Oblicz pole powierzchni tych części budynku BuildingC i poligonu 
	--o współrzędnych (4 7, 6 7, 6 8, 4 8, 4 7), które nie są wspólne dla tych dwóch 
	--obiektów.

--ST_SymDifference(geometry geomA, geometry geomB)-zwraca geometrię reprezentującą części geometrii A i B, które się nie przecinają.

SELECT ST_Area(ST_SymDifference((SELECT geometry FROM buildings WHERE name='BuildingC'),
								 ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))',0)
								 ));
								 
								
