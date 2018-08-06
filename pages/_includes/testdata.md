
# <span style="color:silver"> 14.0.0 </span> Test data defined as part of the PDDI CDS Implementation Guide

* **TODO** add test requests for each scenario where prefetch is included
* **TODO** add test requests for each scenario where prefetch is not included

To facilitate testing and verification, this guide includes test bundles for a number of sample patients.

## <span style="color:silver"> 14.1.0 </span> Warfarin + NSAID

All scenarios invoke the CDS service – so `prefetch` warfarin resources overlap a new NSAID order in each scenario below. 

##### Scenario 1: `context:` topical diclofenac – MedicationRequest; `prefetch:` warfarin – MedicationRequest 
* [Request NSAID + Warfarin scenario 01](requests/request-warfarin-nsaid-scenario-01.json)

##### Scenario 2: `context:` systemic NSAID – MedicationRequest; `prefetch:` warfarin – MedicationRequest, proton pump inhibitor – MedicationRequest,
* [Request NSAID + Warfarin scenario 02](requests/request-warfarin-nsaid-scenario-02.json) 

##### Scenario 3: `context:` systemic NSAID – MedicationRequest; `prefetch:` wafarin – MedicationDispense, >65 years old – Patient, systemic corticosteroid – MedicationRequest
* [Request NSAID + Warfarin scenario 03](requests/request-warfarin-nsaid-scenario-03.json) 

##### Scenario 4: `context` systemic NSAID – MedicationRequest; `prefetch:` wafarin – MedicationAdministration, <65 years old – Patient, history of upper gastrointestinal bleed – Condition, NSAID – MedicationRequest
* [Request NSAID + Warfarin scenario 04](requests/request-warfarin-nsaid-scenario-04.json) 

##### Scenario 5: `context:` systemic NSAID – MedicationRequest; `prefetch:` wafarin – MedicationStatement, <65 years old – Patient, aldosterone antagonist – MedicationRequest
* [Request NSAID + Warfarin scenario 05](requests/request-warfarin-nsaid-scenario-05.json) 