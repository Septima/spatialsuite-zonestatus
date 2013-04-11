komnr=183
area_filter=10

## Data variable, der indsættes i landzone
dataprod='April'
kommunenavn='Ishøj'
zonestatus='Beregnet landzone'

ogr2ogr -overwrite  -f "ESRI Shapefile" zoner_temp.shp -dialect sqlite \
-sql "SELECT planid ,geometri, planid, komnr, dataprod, kommunenavn as komnavn, zonestatus  \
    FROM \"pdk:theme_pdk_zonekort_v\" \
    WHERE komnr=$komnr \

    UNION SELECT -1, difference(k.geometri,z.GEOMETRY), null, $komnr, '$dataprod', '$kommunenavn', '$zonestatus' \

    FROM \"pdk:kommune\" k, (SELECT gunion(geometri) as GEOMETRY \
    FROM \"pdk:theme_pdk_zonekort_v\" \
    WHERE komnr=$komnr) z WHERE k.nr=$komnr" \
wfs:"http://geoservice.plansystem.dk/wfs" -explodecollections


ogr2ogr -overwrite -f "ESRI Shapefile" zoner_septima.shp zoner_temp.shp -sql "SELECT * FROM zoner_temp WHERE OGR_GEOM_AREA > $area_filter"

