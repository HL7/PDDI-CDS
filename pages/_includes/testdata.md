
# <span style="color:silver"> 15.0.0 </span> Test data defined as part of the PDDI CDS Implementation Guide

To facilitate testing and verification, this guide includes test requests for a number of sample scenarios.

## <span style="color:silver"> 15.1.0 </span> Warfarin + NSAID

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


## <span style="color:silver"> 15.2.0 </span> Digoxin + Cyclosporine

##### Scenario 1: `context:` cyclosporine – MedicationRequest; `prefetch:` digoxin – MedicationDispense, digoxin level – Observation, furosemide – MedicationDispense
* [Request Digoxin + Cyclosporine scenario 01](requests/request-digoxin-cyclosporine-scenario-01.json)

##### Scenario 2: `context:` cyclosporine – MedicationRequest; `prefetch:` digoxin – MedicationDispense, cyclosporine - MedicationRequest, potassium – Observation, 
* [Request Digoxin + Cyclosporine scenario 02](requests/request-digoxin-cyclosporine-scenario-02.json)

##### Scenario 3: `context:` digoxin – MedicationRequest; `prefetch:` cyclosporine – MedicationRequest, renal – Observation
* [Request Digoxin + Cyclosporine scenario 03](requests/request-digoxin-cyclosporine-scenario-03.json)

##### Scenario 4: `context:` digoxin – MedicationRequest; `prefetch:` cyclosporine – MedicationRequest, digoxin – MedicationDispense, digoxin level – Observation
* [Request Digoxin + Cyclosporine scenario 04](requests/request-digoxin-cyclosporine-scenario-04.json)