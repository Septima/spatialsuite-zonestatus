komnr=183
area_filter=10

## Data variable, der indsættes i landzone
dataprod='April'
kommunenavn='Ishøj'
zonestatus='Beregnet landzone'

echo "Deleting data.sqlite"
rm data.sqlite

echo "Fetching kommuepolygon and zonestatuspolygons"
ogr2ogr -overwrite -f "sqlite" data.sqlite wfs:"http://geoservice.plansystem.dk/wfs" pdk:theme_pdk_zonekort_v -where "komnr=$komnr" -nln zonekort -lco SPATIALITE=yes -lco FORMAT=SPATIALITE
ogr2ogr -overwrite -f "sqlite" data.sqlite wfs:"http://geoservice.plansystem.dk/wfs" pdk:kommune  -where "nr=$komnr" -nln kommune -lco SPATIALITE=yes -lco FORMAT=SPATIALITE

echo "Creating new table  zonekort_exploded"

ogr2ogr  -update -append -f "sqlite" data.sqlite \
-sql "SELECT planid ,GEOMETRY, komnr, dataprod, kommunenavn as komnavn, zonestatus  \
          FROM zonekort \
          UNION
          SELECT -1, difference(k.GEOMETRY,z.GEOMETRY), '$komnr', '$dataprod', '$kommunenavn', '$zonestatus'
          FROM kommune k, (SELECT gunion(GEOMETRY) as GEOMETRY  FROM zonekort) z" \
          data.sqlite -explodecollections -nln zonekort_exploded -lco SPATIALITE=yes -lco SPATIALITE=yes -lco FORMAT=SPATIALITE

echo "Creating shapefile zoner_septima.shp"
ogr2ogr -overwrite  -f "ESRI Shapefile" zoner_septima.shp data.sqlite -sql "select * FROM zonekort_exploded WHERE st_Area(GEOMETRY) > $area_filter"
