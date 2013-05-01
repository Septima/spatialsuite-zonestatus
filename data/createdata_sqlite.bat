set gdalpath=E:\spatialsuite\app\mapserver\release-1600-gdal-1-9-mapserver-6-2\bin\
set komnr=183
set komnr1=187
set area_filter=10
set date = %date%
rem  Data variable, der indsættes i landzone
set dataprod=%date%
set kommunenavn='Ishøj'
set zonestatus='Beregnet landzone'

echo "Deleting data.sqlite"
del data.sqlite
echo "Creating data for Ishøj......" 

echo "Fetching kommuepolygon and zonestatuspolygons and write data to data.sqlite"
%gdalpath%ogr2ogr -overwrite -f "sqlite" data.sqlite wfs:"http://geoservice.plansystem.dk/wfs" pdk:theme_pdk_zonekort_v -where "komnr=%komnr%" -nln zonekort -lco SPATIALITE=yes -lco FORMAT=SPATIALITE
%gdalpath%ogr2ogr -overwrite -f "sqlite" data.sqlite wfs:"http://geoservice.plansystem.dk/wfs" pdk:kommune  -where "nr=%komnr%" -nln kommune -lco SPATIALITE=yes -lco FORMAT=SPATIALITE
echo "Creating new temp shapefile zoner_temp.shp "
%gdalpath%ogr2ogr  -overwrite -f "ESRI Shapefile" zoner_temp.shp -sql "SELECT planid ,GEOMETRY, komnr, dataprod, kommunenavn as komnavn, zonestatus  FROM zonekort UNION SELECT -1, difference(k.GEOMETRY,z.GEOMETRY), %komnr%, '%dataprod%', %kommunenavn%, 'Beregnet landzone' FROM kommune k, (SELECT gunion(GEOMETRY) as GEOMETRY  FROM zonekort) z" data.sqlite -explodecollections
echo "Creating shapefile zoner_septima.shp and removing polygons with area less than %area_filter%"
%gdalpath%ogr2ogr  -overwrite  -f "ESRI Shapefile" zoner_septima.shp zoner_temp.shp -sql "select * FROM zoner_temp WHERE OGR_GEOM_AREA > %area_filter%"
echo "write to postgres database"
set PGCLIENTENCODING=utf8
%gdalpath%ogr2ogr  -overwrite -f "PostgreSQL" pg:"host=localhost dbname=k183test user=user password=password port=5432" -sql "select * FROM zoner_temp WHERE OGR_GEOM_AREA > %area_filter%" zoner_temp.shp -nln cbkort.zoner_septima



rem echo "Creating data for Vallensbak......" 
rem set komnr=187
rem set kommunenavn='Vallensbaek'
rem set zonestatus='Beregnet landzone'

rem echo "Deleting data.sqlite"
rem del data.sqlite
rem echo "Fetching kommuepolygon and zonestatuspolygons and write data to data.sqlite"
rem %gdalpath%ogr2ogr -overwrite -f "sqlite" data.sqlite wfs:"http://geoservice.plansystem.dk/wfs" pdk:theme_pdk_zonekort_v -where "komnr=%komnr%" -nln zonekort -lco SPATIALITE=yes -lco FORMAT=SPATIALITE
rem %gdalpath%ogr2ogr -overwrite -f "sqlite" data.sqlite wfs:"http://geoservice.plansystem.dk/wfs" pdk:kommune  -where "nr=%komnr%" -nln kommune -lco SPATIALITE=yes -lco FORMAT=SPATIALITE
rem echo "Creating new temp shapefile zoner_temp.shp "
rem %gdalpath%ogr2ogr  -overwrite  -f "ESRI Shapefile" zoner_temp.shp -sql "SELECT planid ,GEOMETRY, komnr, dataprod, kommunenavn as komnavn, zonestatus  FROM zonekort UNION SELECT -1, difference(k.GEOMETRY,z.GEOMETRY), %komnr%, '%dataprod%', %kommunenavn%, 'Beregnet landzone' FROM kommune k, (SELECT gunion(GEOMETRY) as GEOMETRY  FROM zonekort) z" data.sqlite -explodecollections
rem %gdalpath%ogr2ogr  -overwrite  -f "ESRI Shapefile" zoner_septima.shp zoner_temp.shp -sql "select * FROM zoner_temp WHERE OGR_GEOM_AREA > %area_filter%"

rem E:\spatialsuite\app\mapserver\release-1600-gdal-1-9-mapserver-6-2\bin\ogr2ogr  -overwrite  -f "PostgreSQL" pg:"host=localhost dbname=k183test user=k183 password=k183 port=5432" -sql "select * FROM zoner_temp WHERE OGR_GEOM_AREA > 10" -nln cbkort.zoner_temp



