
## Terminology defined for the PDDI CDS Implementation Guide

The following terminology artifacts have been defined for the PDDI CDS implementation guide: ValueSets, CodeSystems, and ConceptMaps 

The ValueSets created for the PDDI-CDS IG have two categories which include: 

1. **Member ValueSet** – concept level identifiers (lower-case identifier)
2. **Grouper ValueSet** – superset that references Member ValueSet (upper-case identifier)

Delineation of the two types of value sets is based on characteristics or hierarchy of the terminology. 
The Grouper ValueSet references the Member ValueSets as needed for the defined service. For example, 
non-steroidal anti-inflammatory drugs (NSAIDs) is a class of medications with several members 
(e.g., ibuprofen, naproxen, diclofenac). The Grouper ValueSet (valueset-NSAIDS) 
references valueset-ibuprofen, valueset-naproxen, valueset-diclofenac etc. 
While the Grouper value sets are service specific, the Member value sets are service agnostic, reusable, and amenable to automated updating. 
Refinement of included concepts occurs in the exclude tag of the Grouper ValueSet, with additional ValueSets. 
In the situation where a Member ValueSet does not have a Grouper ValueSet, and does not require refinement of included concepts, it may be referenced directly. 
The Grouper and Member value sets have an Extensional Definition, which is an enumeration of the value set concepts; however, 
the Member value sets have both and Extensional and Intensional (machine executable) Definition. The Intensional Definition is enumerated in the expansion element.

#### Value Sets

{% include list-simple-valuesets.xhtml %} 

<p/><p/>



#### Code Systems



{% include list-simple-codesystems.xhtml %} 

<p/><p/>



