Spatialsuite-zonestatus
=======================


# Licens

Dette modul er udgives under MIT licensen

Første version er finansierret af Ishøj Kommune

The MIT License (MIT)

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#Beskrivelse:


Plansystem udstiller ikke data om landzoner medmindre en zone specifikt er udlagt til landzone. Det antages i modulet at alle arealer, der ikke er registreret med en zoneplan i Plansystem er landzoner.

Dette modul til SpatialSuite beregner det ikke-zonelagte areal og angiver det som landszone zone.

Først hentes kommunegrænsen fra plansystem. Samtidig hentes alle eksisterende zoner i kommunen og alle zone-polygonerne lægges sammen(union).

Endelig fratrækkes(difference) de sammelagte zonerarealer fra kommunensgrænsen (polygon).

Note: Der er registreret præcisionsforskelle mellem geometrierne fra zonearealer og kommunegrænsen, hvilket medfører en randzoneproblematik ved "klipningen" og der opstår derfor et antal meget små polygoner som efterfølgende fjernes. Størrelsen på de arealer, der skal fjernes styres med variablen areal_filter. Default er 10 m2

Modulet konstruerer således en ESRI Shapefile med alle zonearealer inklusive beregnede landzonearealer. Andre formater kan meget enkelt understøttes herunder spatialle databaser


#Afhængigheder:

Kræver ogr2ogr version 1.9.1 bygget med spatialite

#Installation :

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
            presentation="[module:skoler.dir]/presentations/pres-skoler"
            maxresult="50" srs="25832">
            <datasource name="ds_skoler" />
        </target>
    </targetset>
```


4: Hent data

4.a: I modulets "data folder" tilrettes createdata.bat  med følgende variable:

```python
komnr=183
areal_filter=10 # alle arealer mindre end 10m2 fjernes fra datasættet
dataprod='April' # dato for oprettelse af landzonepolygon
kommunenavn='Ishøj'
zonestatus='Beregnet landzone' # Teksten i feltet zonestatus
```
4.b: Åben en kommandolinjeprompt i modulets datafolder og kør scriptet. Modulet har herefter en ESRI SHapefil med alle zonearealer inklusive beregnede landzonearealer.
