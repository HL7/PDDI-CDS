# PDDI-CDS
Documents and code related to the CDS and Pharmacy WG sponsored implementation guide for potential drug-drug interaction clinical decision support. 

## CI Build
Commits to this repository will automatically trigger a build which is pushed to the following location:

http://build.fhir.org/ig/HL7/PDDI-CDS/index.html

## Balloted version Fall 2020

http://hl7.org/fhir/uv/pddi/2020SEP/index.html

### Project Wiki Page ###

https://confluence.hl7.org/display/CDS/PDDI+CDS

### Who do I talk to? ###

* Project Facilitators

Richard Boyce boycerd@upmc.edu

Guilherme Del Fiol guilherme.delfiol@utah.edu

## Local Build
Download jar from https://github.com/HL7/fhir-ig-publisher/releases

    java -jar "org.hl7.fhir.publisher.jar" -ig ig.ini
       
## ig publisher GUI

Please read more about the implementation guide publishing process here: http://wiki.hl7.org/index.php?title=IG_Publisher_Documentation 

Running the publisher"
```
    java -jar org.hl7.fhir.publisher.jar
```     

Then, execute ig.json from the GUI. This will render webpages with html files in output folder (e.g., index.html).
