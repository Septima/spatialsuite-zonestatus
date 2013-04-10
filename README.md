Spatialsuite-zonestatus
=======================


# Licens

Dette modul er finansieret af Ishøj Kommune og er kan anvendes kvit og frit af alle uden betingelser


#Beskrivelse:


Plansystem udstiller ikke data om landzoner medmindre en plan specifikt er udlagt til landzone. Derfor antages det at alle arealer, der ikke er registreret med en zoneplan i Plansystem, kan betragtes som landzone.

Dette modul til SpatialSuite beregner manglende zonetatus for landzone ved først at hente kommunegrænsen. Samtidig hentes alle eksisterende zoner i kommunen og alle polygonerne lægges sammen(union).

Endelig fratrækkes de sammelagte zonerarealer fra kommunens amlede areal.

Note: Der er registreret præcisionsforskelle mellem zonearealer og kommunegrænsen, hvilket medfører en randzoneproblematik ved "klipningen". Polygonen for den beregnede landszone er defor beregnet ved at påføre en negativ buffer på 0,0,5 meter på kommunepolygonen. Derfor har den beregnede landszone en marginal usikkerhed i kanterne på 0,05 meter

Modulet konstruerer således en ESRI Shapefile med alle zonearealer inklusive beregnede landzonearealer. Andre formater kan meget enkelt understøttes herunder spatialle databaser


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
4.b: Åben en kommandolinjeprompt i modulets datafolder og kør scriptet.
