# PDDI-CDS
Documents and code related to the CDS and Pharmacy WG sponsored implementation guide for potential drug-drug interaction clinical decision support. 

### Project Wiki Page ###

http://wiki.hl7.org/index.php?title=PDDI_CDS

### Who do I talk to? ###

* Project Facilitators

Richard Boyce boycerd@upmc.edu

Guilherme Del Fiol guilherme.delfiol@utah.edu

## Local Build
    java -jar "org.hl7.fhir.igpublisher.jar" -ig ig.json
   
    
## ig publisher GUI

Please read more about the implementation guide publishing process here: http://wiki.hl7.org/index.php?title=IG_Publisher_Documentation 

Running the publisher"
```
    java -jar org.hl7.fhir.igpublisher.jar
```     

Then, execute ig.json from the GUI. This will render webpages with html files in output folder (e.g., index.html).
