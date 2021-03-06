---
created_at: "2017-06-28"
---

# providing test data for databases

A few days ago, I did some experiments with PostgreSQL JSONB columns. 
A used a simple person model for my tests, containing address data for a person.

For my tests, I needed some test data. 
I could have generated some random strings, but I wanted to fill the database with more realistic data. 
I have often thought of a test data generator for commonly used data models.
If you want to generate randomized addresses for a person, you need a big list of street names and city names.
When it comes to geographical data like this, [open street maps][osm] comes into the game.

<!--more-->

Because I live in North rhine westphalia, I use [local data][nrwPbf] from the German [open street map][osm] provider [geofabrik][geofabrik].
At the time of writing the pbf data is about 647 MB in size.
This file contains all cities, highways, residential data, rail ways and so on. 
I only need a fraction of this. 
The osm community has build a tool called [osmosis][osmosis] for this.
With osmosis you can filter the data and save the result in a XML file.

# Cities

    $ osmosis --read-pbf nordrhein-westfalen-latest.osm.pbf \
    > --tf accept-nodes place=city,town,village,hamlet,suburb \
    > --tf reject-relations \
    > --tf reject-ways \
    > --write-xml nrw-cities.osm
    Jun 28, 2017 07:44:09 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Osmosis Version 0.40.1
    Jun 28, 2017 07:44:09 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Preparing pipeline.
    Jun 28, 2017 07:44:09 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Launching pipeline execution.
    Jun 28, 2017 07:44:09 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Pipeline executing, waiting for completion.
    Jun 28, 2017 07:44:53 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Pipeline complete.
    Jun 28, 2017 07:44:53 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Total execution time: 44140 milliseconds.

As a result, you get a 3MB xml file.
The file contains all nodes with a [place tag][osmPlaceTag], containing either `city`, `town`, `village`, `hamlet` or `suburb`.
These tags has usually have a [name tag][osmNameTag].

The city Dortmund looks like

    <node id="25293125" version="33" timestamp="2017-05-08T12:12:08Z" uid="5706452" user="Bienson" changeset="48500235" lat="51.5142273" lon="7.4652789">
      <tag k="ele" v="86"/>
      <tag k="is_in" v="Regierungsbezirk Arnsberg,Nordrhein-Westfalen,Bundesrepublik Deutschland,Europe"/>
      <tag k="is_in:country_code" v="DE"/>
      <tag k="is_in:iso_3166_2" v="DE-NW"/>
      <tag k="name" v="Dortmund"/>
      <tag k="name:de" v="Dortmund"/>
      <tag k="name:hu" v="Dortmund"/>
      ...
      <tag k="openGeoDB:community_identification_number" v="05913"/>
      <tag k="openGeoDB:is_in_loc_id" v="179"/>
      <tag k="openGeoDB:layer" v="5"/>
      <tag k="openGeoDB:license_plate_code" v="DO"/>
      <tag k="openGeoDB:loc_id" v="404"/>
      <tag k="place" v="city"/>
      <tag k="place:importance" v="2"/>
      <tag k="population" v="600933"/>
      <tag k="ref:LOCODE" v="DEDTM"/>
      <tag k="website" v="http://www.dortmund.de"/>
      <tag k="wikidata" v="Q1295"/>
      <tag k="wikipedia" v="de:Dortmund"/>
    </node>

At this point you can decide either to use a xml library for extracting the name tag, or to use the Linux system tools.
I start over with the system tools. 
Let's look how far we can get.

A first `grep` gets every line with a name tag.

    $ grep 'k="name"' nrw-cities.osm | head
        <tag k="name" v="Dingden"/>
        <tag k="name" v="Bocholt"/>
        <tag k="name" v="K??ln"/>
        <tag k="name" v="Herne"/>
        <tag k="name" v="L??nen"/>
        <tag k="name" v="Alstedde"/>
        <tag k="name" v="Heggen"/>
        <tag k="name" v="Herzebrock-Clarholz"/>
        <tag k="name" v="Dortmund"/>
        <tag k="name" v="Schlangen"/>

Looks promising. 
With a `cut` I can extract the values of the tag.

    $ grep 'k="name"' nrw-cities.osm | cut -d\" -f4 | head
    Dingden
    Bocholt
    K??ln
    Herne
    L??nen
    Alstedde
    Heggen
    Herzebrock-Clarholz
    Dortmund
    Schlangen

At this point, you can get a unique sorted list with

    $ grep 'k="name"' nrw-cities.osm | cut -d\" -f4 | sort | uniq | head
    Aachen
    Aan de Popelaar
    Aandeschool
    Aarm??hle
    Aaseestadt
    Abbenroth
    Abenden
    Absto??
    Abtsk??che
    Achterberg

As a result we have 

    $ grep 'k="name"' nrw-cities.osm | cut -d\" -f4 | sort | uniq | wc -l
    7725

unique elements.

# Streets

    $ osmosis --read-pbf nordrhein-westfalen-latest.osm.pbf \
    > --wkv keyValueList=highway.residential \
    > --tf reject-nodes \
    > --tf reject-relations \
    > --write-xml nrw-streets.osm
    Jun 28, 2017 08:34:04 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Osmosis Version 0.40.1
    Jun 28, 2017 08:34:04 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Preparing pipeline.
    Jun 28, 2017 08:34:04 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Launching pipeline execution.
    Jun 28, 2017 08:34:04 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Pipeline executing, waiting for completion.
    Jun 28, 2017 08:35:11 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Pipeline complete.
    Jun 28, 2017 08:35:11 PM org.openstreetmap.osmosis.core.Osmosis run
    INFORMATION: Total execution time: 66564 milliseconds.

This result contains only [way xml nodes][osmWay] containing a [highway tag][osmHighwayTag] with the value `residential`.

    <way id="455771" version="15" timestamp="2017-03-09T07:41:37Z" uid="67862" user="HolgerJeromin" changeset="46719636">
      <nd ref="290215666"/>
      <nd ref="2704621"/>
      <nd ref="1256434820"/>
      <nd ref="1834309845"/>
      <nd ref="2896578753"/>
      <nd ref="2704622"/>
      <nd ref="2704623"/>
      <tag k="highway" v="living_street"/>
      <tag k="lit" v="yes"/>
      <tag k="name" v="Ernst-Meurin-Stra??e"/>
      <tag k="surface" v="paving_stones"/>
    </way>    

Ways with a name tag are usually urban ways.
All other ways will be filtered.

The names can be extracted on the same way, like it is done with the cities. 

    $ grep 'k="name"' nrw-streets.osm | cut -d\" -f4 | sort | uniq | head
    55er Stra??e
    (A7)
    Aabach Aue
    Aabauerschaft
    Aachener Ende
    Aachener Glacis
    Aachener Gracht
    Aachener Platz
    Aachener Stra??e
    Aachener Weg

The North rhine westphalia file contains

    $ grep 'k="name"' nrw-streets.osm | cut -d\" -f4 | sort | uniq | wc -l
    71787

unique streets.    

If you want to know, how often a street name is used in North rhine westphalia, you can extend the query like 

    $ grep 'k="name"' nrw-streets.osm | cut -d\" -f4 | sort | uniq -c | sort -rn | head -n 20
        749 Bahnhofstra??e
        651 Schulstra??e
        640 Gartenstra??e
        618 Bergstra??e
        574 Kirchstra??e
        493 Bachstra??e
        478 Ringstra??e
        473 M??hlenstra??e
        457 Schillerstra??e
        434 Dorfstra??e
        428 Breslauer Stra??e
        408 Goethestra??e
        402 Jahnstra??e
        400 Lindenstra??e
        397 Feldstra??e
        394 Hauptstra??e
        374 Wiesenstra??e
        372 M??hlenweg
        368 Sch??tzenstra??e
        359 Waldstra??e

This can be useful, if you like to use the top `n` street names of the whole list.

    $ grep 'k="name"' nrw-streets.osm | cut -d\" -f4 | sort | uniq -c | sort -rn | \
    > head -n 20 | sed -e 's/^[[:space:]]*//' | cut -d' ' -f2-
    Bahnhofstra??e
    Schulstra??e
    Gartenstra??e
    Bergstra??e
    Kirchstra??e
    Bachstra??e
    Ringstra??e
    M??hlenstra??e
    Schillerstra??e
    Dorfstra??e
    Breslauer Stra??e
    Goethestra??e
    Jahnstra??e
    Lindenstra??e
    Feldstra??e
    Hauptstra??e
    Wiesenstra??e
    M??hlenweg
    Sch??tzenstra??e
    Waldstra??e

This is similar to the previous query.
First remove leading spaces with `sed`, then show all content after the first space occurrence with `cut`.
This will reduce the occurrence of false positive matches.
With a increasing number of occurrences, the possibility, that the match is a real street name increases.


If you like to use only those street names, which occurs more than ten times you can query like 

    $ grep 'k="name"' nrw-streets.osm | cut -d\" -f4 | sort | \
    > uniq -c | sort -rn | sed -e 's/^[[:space:]]*//' | \
    > awk '$1 > 10 { print $0}' | cut -d' ' -f2- | wc -l
    3352

If you need more streets, matching the above requirements, you can take a bigger pbf file.
For non German names, just choose an other country.

The query above for Belgium looks like

    $ grep 'k="name"' belgium-streets.osm | cut -d\" -f4 | sort | uniq -c | sort -rn | \ 
    > sed -e 's/^[[:space:]]*//' | awk '$1 > 10 { print $0}' | cut -d' ' -f2- | wc -l
    1778

The top 20 streets for Belgium are

    $ grep 'k="name"' belgium-streets.osm | cut -d\" -f4 | sort | uniq -c | sort -rn | \
    > sed -e 's/^[[:space:]]*//' | awk '$1 > 10 { print $0}' | cut -d' ' -f2- | head -n 20
    Kerkstraat
    Molenstraat
    Nieuwstraat
    Schoolstraat
    Stationsstraat
    Kapelstraat
    Veldstraat
    Groenstraat
    Kasteelstraat
    Kloosterstraat
    Broekstraat
    Bosstraat
    Rue du Moulin
    Dorpsstraat
    Rue de l&apos;??glise
    Berkenlaan
    Beukenlaan
    Bergstraat
    Lindestraat
    Hoogstraat

Looks slightly different, right?     
   
With these flat files you can generate a combination of streets, cities and postal codes.
For the postal codes, a random number generator should fit my needs.
This will also work for street numbers. 
With different pbf country files, I can generate localized address test data.

[nrwPbf]: http://download.geofabrik.de/europe/germany/nordrhein-westfalen.html
[osm]: https://www.openstreetmap.org
[geofabrik]: http://www.geofabrik.de/
[osmosis]: http://wiki.openstreetmap.org/wiki/Osmosis
[osmPlaceTag]: http://wiki.openstreetmap.org/wiki/Key:place
[osmNameTag]: http://wiki.openstreetmap.org/wiki/Key:name
[osmWay]: http://wiki.openstreetmap.org/wiki/Way
[osmHighwayTag]: http://wiki.openstreetmap.org/wiki/Key:highway
