Spatialsuite-zonestatus
=======================


# Licens

Dette modul er finansieret af Ishøj Kommune og er kan anvendes kvit og frit af alle uden betingelser


#Beskrivelse:

Modulet til SpatialSuite beregner manglende zonetatus for landzone


#Afhængigheder:

Kræver ogr2ogr version 1.9.1 bygget med spatialite

#INSTALLATION :

1:   Installér modulet

1.a: Hent seneste version af modulet her:


https://github.com/Septima/spatialsuite-zonestatus/archive/master.zip

Kopiér indholder til en folder med navnet "zonestatus"

Note: Seneste version af modulet kan altid hentes med ovenstående link


1.b: Kopier modulet "zonestatus" til sitets Septima moduler, dvs. til "[cbinfo.config.dir]/modules/septima/zonestatus"

1.c: Skriv følgende entry i [cbinfo.modules]:
```xml
<module name="zonestatus" dir="septima/zonestatus"/>
```
2: Tilføj tema

2.a: I profilen indsættes:
```xml
    <theme module="zonestatus" name="theme-zonekort-landzone">
        <themeselector>
            <initialstate>available</initialstate>
            <group>basemap</group>
            <displayname>Zonekort (beregnet landzone)</displayname>
            <selectable>true</selectable>
        </themeselector>
    </theme>
```

3: Tilføj targetset

3.a: I profilens targetset fil tilføjes følgende include:
```xml
    <include src="[module:zonestatus.dir]/queries/targetset.xml" nodes="/spatialqueries/targetset/*" mustexist="false"/>
```

Eksempel:

```xml
     <targetset name="std_soegning" maxresult="500" >
        <include src="[module:zonestatus.dir]/queries/targetset.xml" nodes="/spatialqueries/targetset/*" mustexist="false"/>
        <target displayname="Skoler"
            presentation="[module:kbh.dir]/presentations/pres-buf-skoler"
            maxresult="50" srs="25832">
            <datasource name="ds_skoler" />
        </target>
    </targetset>
```


4: Hent data

4.a: I modulets "data folder" tilrettes createdata.bat  med følgende variable:

```python
komnr=183
dataprod='April' # dato for oprettelse af landzonepolygon
kommunenavn='Ishøj'
zonestatus='Beregnet landzone' # Teksten i feltet zonestatus
```

