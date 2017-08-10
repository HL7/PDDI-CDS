
## Terminology defined for the Validated Healthcare Directory Implementation Guide

This page lists all the ValueSets, CodeSystems, and ConceptMaps defined as part of the Validated Healthcare Directory implementation Guide. For more information on using codes in resources, see the [guidance section](guidance.html#using-codes-in-us-core-profiles) as well as in the [FHIR specification](http://hl7.org/fhir/STU3/terminologies.html).

#### Value Sets

These value sets have been defined for this implementation guide.

{% include list-simple-valuesets.xhtml %}

#### Code Systems

See the [FHIR terminology section](http://hl7.org/fhir/STU3/terminologies-systems.html) for a complete discussion on code systems and a list of codes system names used in FHIR. The following additional names (URIs) have been identified for this implementation guide,   If a URI is listed here, it **SHALL** be used in the US Core profiles in preference to any other code system name.

**Code systems published in this IG** - Includes US Core defined code systems and externally defined code systems

<!-- {sdf% include list-simple-codesystems.xhtml %} -->

<p>
</p>

**Externally Published code systems**

|URI|Source|Comment|OID (for non-FHIR systems)
|---|---|---|---|
|`http://hl7.org/fhir/sid/icd-10-cm`|[CMS](http://www.cms.gov/Medicare/Coding/ICD10/)|*International Classification of Diseases, 10th Revision, Clinical Modification (ICD-10-CM)* -  See [Using ICD-[X] with FHIR](http://hl7.org/fhir/STU3/icd.html#4.2.11).|2.16.840.1.113883.6.90
|`http://www.icd10data.com/icd10pcs`|[CMS](http://www.cms.gov/Medicare/Coding/ICD10/)|*International Classification of Diseases, 10th Revision, Procedure Coding System (ICD-10-PCS)* -  See [ICD-10 PCS Codes](http://www.icd10data.com/icd10pcs) for online access to codes for general information purposes. |2.16.840.1.113883.6.4
|`http://hl7.org/fhir/us/sid/cdt`|[ADA](http://www.ada.org/en/publications/cdt)|*Code on Dental Procedures and Nomenclature*|2.16.840.1.113883.6.13

<!--
|[urn:oid:2.16.840.1.113883.6.238](CodeSystem-cdcrec.html)|[CDC](https://www.cdc.gov/phin/resources/vocabulary/index.html)|*Race & Ethnicity - CDC* - See [CDC Race and Ethnicity Code Set Version 1.0](https://www.cdc.gov/phin/resources/vocabulary/documents/cdc-race--ethnicity-background-and-purpose.pdf).|2.16.840.1.113883.6.238
-->

<p>
</p>

#### ConceptMaps

The following concept mappings have been defined as part of the this guide.

  <!-- {sdf% include list-simple-conceptmaps.xhtml %} -->
<p>
</p>
