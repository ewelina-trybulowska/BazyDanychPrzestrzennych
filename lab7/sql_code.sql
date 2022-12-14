
CREATE DATABASE cwiczenia7;

CREATE EXTENSION postgis;

CREATE EXTENSION postgis_raster;



----------------------------------- ZADANIE 3
--2. utworzenie indeksu przestrzennego:
CREATE INDEX idx_intersects_rast_gist ON public.uk_250k 
USING gist (ST_ConvexHull(rast));

--3. dodanie raster constraints:
SELECT AddRasterConstraints('public'::name, 'uk_250k'::name,'rast'::name);



--2. utworzenie indeksu przestrzennego:
CREATE INDEX idx_intersects_rast_gist ON public.uk_250k_w2 
USING gist (ST_ConvexHull(rast));

--3. dodanie raster constraints:
SELECT AddRasterConstraints('public'::name, 'uk_250k_w2'::name,'rast'::name);



CREATE TABLE tmp_out2 AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE',
'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM public.uk_250k_w2;

SELECT lo_export(loid, 'C:\cw6_bd\raster_zad3.tiff')
FROM tmp_out2;

SELECT lo_unlink(loid)
  FROM tmp_out2;
  
 

 --------------------------------------- ZADANIE 6 i 7
SELECT UpdateGeometrySRID('national_parks','geom',4277);

CREATE TABLE uk_lake_district AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM uk_250k AS a, national_parks AS b
where b.gid = 1 and ST_Intersects(b.geom,a.rast);

select * from uk_lake_district;
 
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE',
'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM uk_lake_district;


SELECT lo_export(loid, 'C:\cw6_bd\raster_zad7.tiff') 
FROM tmp_out;


SELECT lo_unlink(loid)
FROM tmp_out; 

------------------------------------- ZADANIE 9
SELECT * FROM public.sentinel;
 
 ------------------------------------- ZADANIE 10

CREATE INDEX idx_rast_sentinel_gist ON public.sentinel 
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('public'::name,'sentinel'::name,'rast'::name);


CREATE OR REPLACE FUNCTION NDVI(
value double precision [] [] [], 
pos integer [][],
VARIADIC userargs text []
)
RETURNS double precision AS
$$
BEGIN

RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value 
[1][1][1]); --> NDVI calculation!
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;





CREATE TABLE NDVI_2 AS
WITH r AS (
SELECT * FROM public.sentinel
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, ARRAY[1,4],
'NDVI(double precision[],
integer[],text[])'::regprocedure, 
'32BF'::text
) AS rast
FROM r;

SELECT * FROM NDVI_2; 


CREATE TABLE intersect_sentinel AS
SELECT a.rid, ST_Clip(a.rast,b.geom,true) AS rast
FROM NDVI_2 AS a, national_parks AS b
WHERE b.gid=1 AND ST_Intersects(b.geom,a.rast);

SELECT * FROM intersect_sentinel;


 -------------------------------------- ZDANIE 11

CREATE TABLE tmp_out3 AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE',
'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM intersect_sentinel;


SELECT lo_export(loid, 'C:\cw6_bd\raster_zad7.tiff') 
FROM tmp_out3;

SELECT lo_unlink(loid)
FROM tmp_out3; 