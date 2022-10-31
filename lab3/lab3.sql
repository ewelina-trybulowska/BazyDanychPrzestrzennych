create database cwiczenia3
create EXTENSION postgis

--1. Zaimportuj następujące pliki shapefile do bazy: T2018_KAR_BUILDINGS ,T2019_KAR_BUILDINGS
	--Pliki te przedstawiają zabudowę miasta Karlsruhe w latach 2018 i 2019.
	--Znajdź budynki, które zostały wybudowane lub wyremontowane na przestrzeni roku (zmiana
	--pomiędzy 2018 a 2019).

SELECT b2019.gid, b2019.polygon_id, b2019.name, b2019.type, b2019.height, ST_AsText(b2019.geom) 
FROM t2019_kar_buildings b2019
LEFT JOIN t2018_kar_buildings b2018 ON b2018.geom = b2019.geom
WHERE b2018.gid IS NULL;



--2. Zaimportuj dane dotyczące POIs (Points of Interest) z obu lat:T2018_KAR_POI_TABLE, T2019_KAR_POI_TABLE
	--Znajdź ile nowych POI pojawiło się w promieniu 500 m od wyremontowanych lub
	--wybudowanych budynków, które znalezione zostały w zadaniu 1. Policz je wg ich kategorii.

CREATE VIEW buildings_from_zad1 AS
SELECT b2019.gid, b2019.polygon_id, b2019.name, b2019.type, b2019.height, b2019.geom 
FROM t2019_kar_buildings b2019
LEFT JOIN t2018_kar_buildings b2018 ON b2018.geom = b2019.geom
WHERE b2018.gid IS NULL;

CREATE VIEW new_poi AS 
SELECT poi2019.gid, poi2019.poi_id, poi2019.link_id, poi2019.type, poi2019.poi_name, poi2019.st_name, poi2019.lat,
       poi2019.lon,poi2019.geom
FROM t2019_kar_poi_table poi2019
LEFT JOIN t2018_kar_poi_table poi2018 ON poi2018.geom = poi2019.geom
WHERE poi2018.gid IS NULL; 

CREATE VIEW results AS
SELECT DISTINCT poi.type, poi.gid FROM new_poi poi
OIN buildings_from_zad1 b ON ST_Intersects(poi.geom, ST_Buffer(b.geom,0.005));

SELECT type, COUNT(*) FROM results GROUP BY type



--3. Utwórz nową tabelę o nazwie ‘streets_reprojected’, która zawierać będzie dane z tabeli
	--T2019_KAR_STREETS przetransformowane do układu współrzędnych DHDN.Berlin/Cassini.

CREATE TABLE streets_reprojected (
	gid serial4 NOT NULL,
	link_id float8 NULL,
	st_name varchar(254) NULL,
	ref_in_id float8 NULL,
	nref_in_id float8 NULL,
	func_class varchar(1) NULL,
	speed_cat varchar(1) NULL,
	fr_speed_l float8 NULL,
	to_speed_l float8 NULL,
	dir_travel varchar(1) NULL,
	geom geometry NULL
)

INSERT INTO streets_reprojected 
SELECT gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, to_speed_l,
		dir_travel, ST_Transform(ST_SetSRID(geom,4326), 3068)
FROM t2019_kar_streets



--4. Stwórz tabelę o nazwie ‘input_points’ i dodaj do niej dwa rekordy o geometrii punktowej.
	--Użyj następujących współrzędnych:
	--X Y
	--8.36093 49.03174
	--8.39876 49.00644

CREATE TABLE inputs_points (id int, name varchar, geom geometry)

INSERT INTO inputs_points values
    (1, 'point1', 'POINT(8.36093 49.03174)'),
    (2, 'point2', 'POINT(8.39876 49.00644)')
   
    
    
--5. Zaktualizuj dane w tabeli ‘input_points’ tak, aby punkty te były w układzie współrzędnych
	--DHDN.Berlin/Cassini.
UPDATE inputs_points
SET geom = ST_Transform(ST_SetSRID(geom,4326), 3068)



--6. Znajdź wszystkie skrzyżowania, które znajdują się w odległości 200 m od linii zbudowanej
	--z punktów w tabeli ‘input_points’. Wykorzystaj tabelę T2019_STREET_NODE. Dokonaj
	--reprojekcji geometrii, aby była zgodna z resztą tabel.

UPDATE t2019_kar_street_node
SET geom = ST_Transform(ST_SetSRID(geom,4326), 3068)
   
CREATE VIEW lines AS
SELECT ST_Makeline(geom) as line FROM inputs_points

SELECT *
FROM t2019_kar_street_node
CROSS JOIN lines
WHERE ST_Contains(ST_Buffer(lines.line, 0.002),t2019_kar_street_node.geom)



--7. Policz jak wiele sklepów sportowych (‘Sporting Goods Store’ - tabela POIs) znajduje się
	--w odległości 300 m od parków (LAND_USE_A).

CREATE VIEW parks AS
SELECT ST_Buffer(land.geom, 0.003) FROM t2019_kar_land_use_a land
WHERE land.type = 'Park (City/County)'

SELECT COUNT(*) FROM t2019_kar_poi_table poi
CROSS JOIN parks
WHERE poi.type ='Sporting Goods Store'
AND ST_Contains(parks.st_buffer, poi.geom)
  


--8. Znajdź punkty przecięcia torów kolejowych (RAILWAYS) z ciekami (WATER_LINES). Zapisz
	--znalezioną geometrię do osobnej tabeli o nazwie ‘T2019_KAR_BRIDGES’.

SELECT ST_Intersection(railways.geom, waterlines.geom) as geom
INTO T2019_KAR_BRIDGES
FROM t2019_kar_railways railways
JOIN t2019_kar_water_lines waterlines
ON ST_Intersects(railways.geom, waterlines.geom)

SELECT * FROM T2019_KAR_BRIDGES


