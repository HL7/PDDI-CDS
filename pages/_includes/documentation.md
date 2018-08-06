* **TODO: Add language in the form of recommendations e.g.,  MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, AND OPTIONAL (Key words for use in RFCs to Indicate Requirement Levels. S. Bradner. IETF. March 1997. Best Current Practice. URL: https://tools.ietf.org/html/rfc2119)**
* **TODO** Consider placing tylenol substitution as a response Card example
* **TODO** Consider adding Card display example to Dig + Cyclo


-1. ~~Knowledge representation for the PDDI CDS (e.g, decision tree) - mapping out the decision paths, pre-fetch requirements~~
 
-2. Translating the KR to CQL  -- after investigation on our part, refering to possibility of using the publicly available CDS Authoring tool -- this will be simple --- libraries to import, specifying the FHIR terminology profile, utility functions, logic 

-3. Implementing CDS Hooks and PlanDefinition to receive CDS requests medication-request or medication-prescribe and return the cards with actions (since general to both artifacts consider moving to start.md?)

-4. Implementing the CDS Service - including how to load the Library, PlanDefinition, and where value sets reside....
+## Warfarin + NSAIDs 
 
-5. Fine tuning the CDS service for performance -- pre-loading data to reduce calls to the EHR e.g., for all patients who will be seen on a day. Other kinds of caching.....
+### Decision Points


# <span style="color:silver"> 6.0.0 </span> PDDI CDS - Documentation


<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}


This section contains documentation, on specific CDS artifacts, for implementers from both the clinical and technical perspectives.

## <span style="color:silver"> 6.1.0 </span> Prefetch and Performance

This section documents for technical implementers the intended role of prefetch resources in improving the performance of the CDS service. 

### <span style="color:silver"> 6.1.0 </span> What is the role of prefetch?
{:.no_toc}
The role of prefetch is to minimize calls by the CDS Service to external resources such as an external FHIR server containing clinical data. When a client program subscribes to PDDI CDS service, a prefetch specicification is returned in the response. This specification identifies important resources that the PDDI CDS service SHOULD recieve when the client makes a request for CDS. As is described below, the prefetch requirements are different depending on if CDS is for `medication-select` or `medication-prescribe`. In both cases, there are some parts of the prefetch that are mandatory because they are necessary for CDS to run, and others that are desired because they will improve CDS performance. 

### <span style="color:silver"> 6.1.1 </span> Prefetch and `medication-select` in the *basic* or *advanced* CDS scenario
{:.no_toc}

The following diagram shows the ideal scenario for prefetch for `medication-select` requests. The scenario is true for both the *basic* or *advanced* CDS scenarios because the prefetch requirements are distinct from the requirements related to the use of `DetectedIssue` resources.

**TODO: develop a figure for this case and finish the section**

### <span style="color:silver"> 6.1.2 </span> Prefetch and `medication-request` in the *basic* or *advanced* CDS scenario
{:.no_toc}

The following diagram shows the ideal scenario for prefetch for `medication-select` requests. The scenario is true for both the *simple* or *advanced* CDS scenarios because the prefetch requirements are distinct from the requirements related to the use of `DetectedIssue` resources.

**TODO: develop a figure for this case and finish the section**



# <span style="color:silver"> 7.0.0 </span> Warfarin + NSAIDs 

## <span style="color:silver"> 7.1.0 </span> Basic

Figure 1 progresses through the decision tree and includes warning indicators (i.e., green, orange, red) and contextual factors that may be passed to the clinician. Figure 2 builds on Figure 1 by depicting a Card display example within the order entry workflow.

### <span style="color:silver"> 7.1.1 </span> Decision Points
{:.no_toc}

The Warfarin + NSAIDs artifact has three main decision blocks that incude:
* prescribed NSAID is topical diclofenac
* patient is taking a proton pump inhibitor 
* risk factors such as age, exacerbating medications, and history of upper gastrointestinal bleed


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Basic Warfarin + NSAID logic </strong></figcaption>
  <a href = "assets/images/Basic_Warfarin_NSAID.svg" target ="_blank" > <img src= "assets/images/Basic_Warfarin_NSAID.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Warfarin_NSAID.svg" /></a>
</figure>

### <span style="color:silver"> 7.1.2 </span> CDS Hooks request
{:.no_toc}
#### Context
{:.no_toc}
* [`medication-prescribe 1.0`](https://cds-hooks.org/hooks/medication-prescribe/) 

#### Prefetch 
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

* Age of patient on current date.
    * [Patient](https://www.hl7.org/fhir/patient.html)
    
* Rolling 5-year look-back period for history of upper gastrointestinal bleed.
    * [Condition](https://www.hl7.org/fhir/condition.html)
    

### <span style="color:silver"> 7.1.3 </span> Example Display Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Basic Warfarin + NSAID Cards </strong></figcaption>
  <a href = "assets/images/Basic_W_N_Cards.png" target ="_blank" > <img src="assets/images/Basic_W_N_Cards.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_W_N_Cards.png" /></a>
</figure>

## <span style="color:silver"> 7.2.0 </span> Advanced

The Advanced implementation proposal for the Warfarin + NSAID artifact is split into two separate services. Figures 3 and 4 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both services (i.e., Medication Select and Medication Prescribe). Figure 5 provides a Card display example for each CDS Hooks instances within the order entry workflow. In the Card display example (Figure 5), the clinician decides to order the NSAID medication but adds a proton pump inhibitor, in response to the Card suggestion. This action results in a downgrade of the `medication-presecribe` response Card (i.e., "hard-stop" – red to "warning" – orange). The blue task boxes highlight the DetectedIssue status indicator, which informs the EHR  of additional needed resources (whether or not to fulfill the Medication Prescribe Service prefetch template), and Medication Prescribe Service if it needs to perform a FHIR server request in the event prefetch data are not provided in the request.  

### <span style="color:silver"> 7.2.1 </span> Decision Points
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Warfarin + NSAID medication-select logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_select.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_select.svg" /></a>
</figure>




<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: Advanced Warfarin + NSAID medication-prescribe logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_prescribe.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_prescribe.svg" /></a>
</figure>

### <span style="color:silver"> 7.2.3 </span> CDS Hooks request
{:.no_toc}
#### Context
{:.no_toc}

##### `medication-select 1.0`
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | ---- | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource

##### `medication-prescribe 1.1`
{:.no_toc}

| Field       | Optionality        |  Prefetch Token     |Type  | Description |
| :------------- |:-------------:|:-------: |:-----:| :-----------------|
| `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context |
| `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context |
| `detectedissueId` | REQUIRED     | Yes |    *string* | STU3 - FHIR `DetectedIssue` resource |
| `detectedissueStatus` | REQUIRED     | No |    *code* | STU3 - FHIR `DetectedIssue` resource |
| `medication` | REQUIRED     | No |    *object* | STU3 - FHIR `MedicationRequest` resource |

#### Prefetch 
{:.no_toc}

##### `medication-select`
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

##### `medication-prescribe`
{:.no_toc}

* Age of patient on current date.
    * [Patient](https://www.hl7.org/fhir/patient.html)
    
* Rolling 5-year look-back period for history of upper gastrointestinal bleed.
    * [Condition](https://www.hl7.org/fhir/condition.html)
    

### <span style="color:silver"> 7.2.4 </span> Example Display Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: Warfarin + NSAID Cards </strong></figcaption>
  <a href = "assets/images/Advanced_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Advanced_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Advanced_W_N_Cards.svg" /></a>
</figure>

# <span style="color:silver"> 8.0.0 </span> Digoxin + Cyclosporine

The Digoxin + Cyclosporine artifact logic depends on the concept that the patient was currently stable on digoxin before the current medication order. To make this clear, the Definitions section (8.1.0) defines terms used in the subsequent flow diagrams. Figure 6 progresses through the decision tree and includes warning indicators (i.e., green, orange, red) and contextual factors that may be passed to the clinician.


## <span style="color:silver"> 8.1.0 </span> Definitions 
{:.no_toc}
* **Incident Order** – `context` medication is *not* in `prefetch` medications and, thus, is presumably the first occurrence. 
* **Prevelant Order** – `context` medication is in in `prefetch` medications and, thus, is presumably a medication order that is continued or repeated.
* **Normal** – observation that is within a specified time period, and the measure is within a therapeutic window or below/above a certain threshold.
* **Abnormal** – observation that is *not* within a specified time period, *or* the measure is *not* within a therapeutic window or below/above a certain threshold.

## <span style="color:silver"> 8.2.0 </span> Basic

### <span style="color:silver"> 8.2.1 </span> Decision Points
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 6: Basic Digoxin + Cyclosporine logic </strong></figcaption>
  <a href = "assets/images/Basic_Digoxin_Cyclosporine.svg" target ="_blank" > <img src="assets/images/Basic_Digoxin_Cyclosporine.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Digoxin_Cyclosporine.svg" /></a>
</figure>

#### Context
{:.no_toc}

* [`medication-prescribe 1.0`](https://cds-hooks.org/hooks/medication-prescribe/) 

#### Prefetch
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)
    
* Rolling 365-day look-back period for digoxin concentration
    * [Observation](https://www.hl7.org/fhir/observation.html)

* Rolling 365-day look-back period for serum creatinine
    * [Observation](https://www.hl7.org/fhir/observation.html)
    
* Rolling 365-day look-back period for electrolytes including: potassium, magnesium, and calcium
    * [Observation](https://www.hl7.org/fhir/observation.html)
        

## <span style="color:silver"> 8.3.0 </span> Advanced

As described under the Getting Started tab, the Advanced proposal requires several changes to the current standard specifications. Changes to the CDS Hooks context are specified below. The Advanced implementation proposal for the Digoxin + Cyclosporine artifact is split into two separate services. Figures 7 and 8 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both services (i.e., Medication Select and Medication Prescribe). The blue task boxes highlight the DetectedIssue status indicator, which informs the EHR  of additional needed resources (whether or not to fulfill the Medication Prescribe Service prefetch template), and Medication Prescribe Service if it needs to perform a FHIR server request in the event prefetch data are not provided in the request.

### <span style="color:silver"> 8.3.1 </span> Decision Points
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 7: Digoxin + Cyclosporine medication-select logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_select.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_select.svg" /></a>
</figure>

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 8: Digoxin + Cyclosporine medication-prescribe logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_prescribe.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_prescribe.svg" /></a>
</figure>


#### Context
{:.no_toc}

##### `medication-select 1.0`
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | ---- | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource

###### `medication-prescribe 1.1`
{:.no_toc}

| Field       | Optionality        |  Prefetch Token     |Type  | Description |
| :------------- |:-------------:|:-------: |:-----:| :-----------------|
| `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context |
| `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context |
| `detectedissueId` | REQUIRED     | Yes |    *string* | STU3 - FHIR `DetectedIssue` resource |
| `detectedissueStatus` | REQUIRED     | No |    *code* | STU3 - FHIR `DetectedIssue` resource |
| `medication` | REQUIRED     | No |    *object* | STU3 - FHIR `MedicationRequest` resource |


#### Prefetch
{:.no_toc}

##### `medication-select`
{:.no_toc}
* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

##### `medication-prescribe`
{:.no_toc}

* Rolling 365-day look-back period for digoxin concentration
    * [Observation](https://www.hl7.org/fhir/observation.html)

* Rolling 365-day look-back period for serum creatinine
    * [Observation](https://www.hl7.org/fhir/observation.html)
    
* Rolling 365-day look-back period for electrolytes including: potassium, magnesium, and calcium
    * [Observation](https://www.hl7.org/fhir/observation.html)


#### Content
{:.no_toc}
The following artifacts formalize the description of the logic and behavior defined by this recommendation.

| Resource | Type | Description |
| --- | --- | --- |
| [Common PDDI CDS Logic](documentation.html) | [Library](https://www.hl7.org/fhir/library.html) | CQL Library that provides common logic for the recommendations |
| [Common PDDI CDS Logic](documentation.html) | CQL Source | For reference, the complete CQL source for the common logic. |
| [PDDI CDS Data](documentation.html) | [Library](https://www.hl7.org/fhir/library.html) | CQL Library that provides data for the recommendations |
| [PDDI CDS Data](documentation.html) | CQL Source | For reference, the complete CQL source for the data. |
| [Warfarin NSAIDs Recommendation Workflow](documentation.html)  |	[PlanDefinition](https://www.hl7.org/fhir/plandefinition.html)  | Event-Condition-Action rule that implements behavior for Warfarin NSAIDs Recommendation |
| [Warfarin NSAIDs Recommendation](documentation.html) | [Library](https://www.hl7.org/fhir/library.html) | Defines the data requirements to support evaluation of Warfarin NSAIDs recommendation |
| [Warfarin NSAIDs Recommendation](documentation.html) | CQL Source | For reference, the complete CQL source for Warfarin NSAIDs recommendation |
