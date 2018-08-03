For the two PDDI examples - specifically how was done:

1. Knowledge representation for the PDDI CDS (e.g, decision tree) - mapping out the decision paths, pre-fetch requirements.....  

2. Translating the KR to CQL  -- after investigation on our part, refering to possibility of using the publicly available CDS Authoring tool -- this will be simple --- libraries to import, specifying the FHIR terminology profile, utility functions, logic 

3. Implementing CDS Hooks and PlanDefinition to receive CDS requests medication-request or medication-prescribe and return the cards with actions
 
4. Implementing the CDS Service - including how to load the Library, PlanDefinition, and where value sets reside....

5. Fine tuning the CDS service for performance -- pre-loading data to reduce calls to the EHR e.g., for all patients who will be seen on a day. Other kinds of caching.....


# <span style="color:silver"> 8.0.0 </span> Examples defined for the PDDI CDS Implementation Guide


The following are examples for the PDDI CDS implementation guide:

### Examples

#### Encounter

{% include list-simple-encounters.xhtml %} 

#### MedicationAdministration

{% include list-simple-medicationadministrations.xhtml %} 

#### MedicationDispense

{% include list-simple-medicationdispenses.xhtml %} 

#### MedicationRequest

{% include list-simple-medicationrequests.xhtml %} 

#### MedicationStatement

{% include list-simple-medicationstatements.xhtml %} 

#### Patient

{% include list-simple-patients.xhtml %} 

<p/><p/>
