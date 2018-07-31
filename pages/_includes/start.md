[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

* **TODO** add numbers to sections?
* **TODO** check `data` backticks to make sure they make sense with the sentence
* **TODO** add example of CDS Hook response and possibly a mockup of the cards Cards
* **TODO** Phi to work on CQL Library section
* **TODO** work on tables for specification 
* **TODO** add quick link table on right side

# Getting Started with PDDI CDS
{:.no_toc}


<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

---

### What You Will Need

* CQL Evaluation Engine to enable the translation and execution of CQL libraries
* FHIR Server 
    * [Public](http://wiki.hl7.org/index.php?title=Publicly_Available_FHIR_Servers_for_testing) 
    * Local (preferred)
        * [HAPI RESTful Server](http://hapifhir.io/doc_rest_server.html)
        * [HAPI JPA Server](http://hapifhir.io/doc_jpa.html)
        * [HAPI JAX-RS Server](http://hapifhir.io/doc_rest_server_jaxrs.html)
        * [.NET Server](https://github.com/ewoutkramer/fhir-net-api)
* CDS Hooks API
* JSON Parser

### What Is Recommended 

* [Clinical Decision Support Authoring Tool](https://cds.ahrq.gov/cdsconnect/authoring)

The Clinical Decision Support Authoring Tool is a componenet of the CDS Connect project funded by the [Agency for Healthcare Research and Quality](https://www.ahrq.gov/). The Documentation section has the decision points described at a semi-structured level. The authoring tool can then be used to translated this knowledge into a structured formate using CQL.

# Basic


# Advanced
# Status
There are two PDDI CDS artifacts available in this Implementation Guide:

* Warfarin + NSAIDs

* Digoxin + Cyclosporin

These specific PDDIs were chosen based on complexity, decision points, and contextual factors. These examples serve as reference for the methodology and procedures that may be adopted when developing and implementing PDDI CDS using HL7 FHIR and CDS Hooks standards.

Different contextual factors are available and needed at different times during the medication order process. To align clinicians' information needs with PDDI information, this implementation guide explores the use of two separate points in the medication therapy workflow:

* Signing a medication order (`medication-prescribe`)

* Selecting a drug product to include in medication order (`medication-select`)

We have chosen to delineate a separate CDS Service for each CDS Hook (i.e., Medication Select Service and Medication Prescribe Service) for clarity, standards' precision, logic flexibility, and to avoid CDS service state requirement. However, both CDS Services are under the PDDI CDS auspices and apply to each artifact for a given medication order event. 

> *Note:* `medication-prescribe` exists in the CDS Hooks standard, but modifying the `context` element requires a new Hook Verson. Additionally, `medication-select` Hook is under development. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: CPOE Workflow Example </strong></figcaption>
  <img src="assets/images/CPOE_workflow.png" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow.png" />
</figure>



# Process 
This section provides an overview of the processes and components that were used to develop the PDDI CDS. Specific details regarding the individual artifacts can be found in the [Documentation](documentation.html) section.  

### CDS Function

To invoke the PDDI CDS service, the EHR needs to send a CDS Hook request at a pre-specified step the workflow process. The CDS Service then parses and processes the request to determine if the prescribed medication conflicts with a medication that the patient is presumably taking. If the condition is satisfied, the CDS Service provides individualized information based on the PDDI knowledge base. 

### Assumptions
#### Clinical
{:.no_toc}
Potential drug-drug interactions, to an extent, are theoretical due to knowledge gaps in the literature. Thus, the specificity of alerts and individualized information provided is limited by the available knowledge.  The goal of contextualizing or individualizing these alerts is not only to reduce the number of alerts, by increasing specificity, but to improve the clinical relevance of the information that is presented. In this regard, PDDI CDS functions as an educational tool to raise awareness of known factors that may mitigate or increase risk associated with PDDIs. Gaps in the literature relating to contextual factors is a known issue of the domain and is a key limitation to this and other drug-drug interaction CDS systems. Moreover, with this limitation, unknown medication adherence, and data quality/availability, it is ultimately up to the clinician's discretion to proceed with interacting orders. 

#### Technical 
{:.no_toc}
The goal of CDS is to bring clinically relevant information to the clinician at the right time; therefore, CDS performance is required to meet the responsiveness expectation of the clinician. Delays in presenting information may lead to unsuccessful adoption of the CDS system and clinician frustration. While the EHR vendor remains in control of fulfilling prefetch queries, this is a key component that dictates the CDS performance. Depending on the patient and Hook, prefetch data may encompass a variety resources captured during various time periods, so it is crucial that implementors and clinicians refine prefetch template parameters to obtain only data that is clinically relevant. EHR vendors may combine several methods to satisfy prefetch templates. For example, the EHR may compute a set of prefetch templates with data in memory and others with FHIR server network calls. 


The initial implementation focus is on Epic and Cerner EHR platforms. Each implementation, however, may need to employ a slightly different approach to ensure successful integration of the CDS system. There are several general aspects that may need to assessed:

* Technical framework for the EHR to interact with CDS Hooks

    * EHR CDS Hooks request for `medication-prescribe` and `medication-select`

    * EHR caputure and presentation of CDS Hooks response

* Terminology mapping (e.g., RxNorm, LOINC)

* FHIR resources include but may not be limited to those listed under [Profiles](profiles.html)

* SMART authentication and FHIR server requests

### Summary of Operations
The primary differences between the Medication Select and the Medication Prescribe Services are the triggering hooks, context resources, and prefetch templates. Whether the Medication Prescribe Service is called depends on aspects of the `DetectedIssue` resource. The `DetectedIssue` resource is created by the Medication Select Service and populated by clinician actions in response to `medication-select` response cards. Figures 2-3 depict the process of an EHR sending CDS Hooks request, a CDS service generating and transforming resources, and an EHR receiving the CDS Hooks Card response to display alerts for clinician to initiate actions.


#### Medication Select Service 
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Medication Select Service Summary </strong></figcaption>
  <img src="assets/images/Medication_Select_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Medication_Select_Service.png" />
</figure>

#### Medication Prescribe Service
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Medication Prescribe Service Summary </strong></figcaption>
  <img src="assets/images/Medication_Prescribe_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Medication_Prescribe_Service.png" />
</figure>

### CDS Hooks

The PDDI CDS artifacts use the HL7 [CDS Hooks specification](http://cds-hooks.org/specification/1.0/). 
The CDS Hooks standard defines the data structure to facilitate communication between the electronic health record and the CDS service through a RESTful API request and response. This allows patient data to be sent and received by the EHR at intervals that better align with clinical workflows – further leveraging FHIR and SMART applications at the point of care. The `context` and `prefetch` are two key elements of the CDS Hook request. The `context` element contains data that is task and Hook-specific. For this use case where two separate Hooks can be used for a specific medication order task, the `context` contains the current `MedicationRequest` resource for the `medication-select` request and the `DetectedIssue` resource for the `medication-prescribe` request. The `prefetch` element contains patient specific information that is relevant to the `context` data and the invoked CDS Service. If the EHR vendor decides not to provide `prefetch` data, the CDS Service MUST request needed data via post-hoc FHIR server request at pre-processing. The goal is to improve the performance of the CDS system by supplying data that is needed for most CDS services associated with a specific Hook in the request `prefetch` element. Examples and clarifications for CDS Hooks relevant to this use case are below.

> *Note:* The CDS Service is not necessarily CDS Hooks dependent. For this use case, CDS Hooks provides simplicity and specific orientation to standardized CPOE workflow

#### CDS Hooks Specification
{:.no_toc}
This implementation guide specifies the use of up to two CDS Hooks (i.e., `medication-select` and `medication-prescribe`) during a single medication order task. Currently, `medication-prescribe` is the only CDS Hook specified for this task.  In addition to creating a new hook, coordinating the two hooks requires modifying the context field of the `mediction-prescribe` hook. 

##### **`medication-select` 1.0**
{:.no_toc}
Field | Optionality | Prefetch Token | Type | Description
----- | -------- | ---- | ---- | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource

##### **`medication-prescribe` 1.1**
 {:.no_toc}
 The version for the `medication-prescribe` hook is 1.0. The PDDI CDS implementation requires an additional context field for `DetectedIssue.`This modification is considered Minor but will change the version to 1.1.


| Field       | Optionality        |  Prefetch Token     |Type  | Description |
| :------------- |:-------------:|:-------: |:-----:| :-----------------|
| patientId     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context |
| encounterId     | OPTIONAL    | Yes |   string | The FHIR Encounter.id of the current encounter in context |
| detectedissueId | REQUIRED     | Yes |    object | STU3 - FHIR `DetectedIssue` resource |
| medication | REQUIRED     | No |    object | STU3 - FHIR `MedicationRequest` resource |
| implicated | OPTIONAL     | No |    object | STU3 - FHIR `DetectedIssue` resource |
| category | OPTIONAL     | No |    object | STU3 - FHIR `DetectedIssue` resource |


### Discovery

The CDS Service Discovery is invoked to identify CDS Services and obtain associated `prefetch` templates. A `prefetch` template is a dictionary of read and search requests. The PDDI CDS Service provides a `prefetch` template for each service and the EHR SHOULD populate `prefetch` templates with relevant patient data for an anticipated CDS Hook request. CDS Service Discovery and fulfilling `prefetch` queries are performed at the discretion EHR vendor.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: CDS Service Discovery </strong></figcaption>
  <img src="assets/images/Discover_CDS_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Discover_CDS_Service.png" />
</figure>

##### Example 1: EHR Request for CDS Discovery
{:.no_toc}
````
GET http://FHIR.org/PDDI-CDS
````

##### Example 2: CDS Service Discovery Response
{:.no_toc}
```{
  "services": [
    {
      "hook": "medication-select",
      "title": "PDDI CDS Service",
      "description": "CDS Service for drug-drug interactions",
      "id": "PDDI-CDS-medication-select",
      "prefetch": {
        "medications_stated": "MedicationStatement?patient/{{context.patientId}}..."
        "medications_dispensed" : "MedicationDispense?patient/{{context.patientId}}..."
        "medications_administered" : "MedicationAdminister?patient/{{context.patientId}}..."
        "medications_prescribed" : "MedicationRequest?patient/{{context.patientId}}..."
      }
    },
    {
      "hook": "medication-prescribe",
      "title": "PDDI CDS Service",
      "description": "CDS Service for drug-drug interactions",
      "id": "PDDI-CDS-medication-prescribe",
      "prefetch": {
        "drug_drug_interaction": "DetectedIssue/{{context.detectedissueId}}",
        "observaions": "Observation?detectedissue={{context.detectedissueId}}..."
        "conditions": "Condition?detectedissue={{context.detectedissueId}}..."
      }
    }
  ]
}
```



#### CDS Hooks Request 

The EHR calls the PDDI CDS service by `POST` ing a `JSON` file to the service endpoint (e.g.,`http://FHIR.org/PDDI-CDS/{Warfarin_NSAID}`). The JSON file (CDS Hook) contains elements for the hook that was triggered, FHIR server, user, context, and prefetch.

###### Context
{:.no_toc}
The `context` element of a CDS Hook request contains hook-specific data and is contextual for the current task. For example, the Medication Select Service only needs the medication product (i.e., `medication` element of the `MedicationRequest` resource ) of the order that is in process. For the Medication Prescribe Service, however, the implicated medications in the DDI and the prescribed medication are needed. 


###### Prefetch
{:.no_toc}
The `prefetch` element contains patient data that has been previously queried prior to the hook trigger. The prefetch data for the `medication-select` hook include the patient's current medications. The Medication Select Service then performs a pair-wise comparision of the `context` medication to the patient's current medications in the `prefetch` element. The prefetch data for the `medication-prescribe` hook is contextual for the specific DDI that was identifed by the Medication Select Service. For example, a patient's history of upper gastrointestinal bleed is specific for a warfarin + NSAID DDI and, thus, SHOULD be provided in the `prefetch` element of the `medication-prescribe` hook.

> *Note:* Based on the standard prescription days-supply, a 100-day time period is recommended as a starting point for the `medication-select` prefetch for all medication resources (i.e., `MedicationRequest, MedicationDispense, MedicationStatement, MedicationAdministration).`


###### Bundle 
{:.no_toc}
A `Bundle` is a FHIR resource that is used to group resources into a single instance, which is ideal for messaging with CDS Hooks, storing the collection of resources obtained on CDS discovery, and providing flexibility in using the collections as a persistent instance. For this use case, the `bundle` resource is used for the key CDS Hook components (i.e., `context` and `prefetch`).  

##### Example 3: CDS Hooks Request
{:.no_toc}

#### FHIR Server Request
{:.no_toc}
In the event the EHR does NOT provide prefetch data, the PDDI CDS Services MUST request the data from the FHIR server via network call. To accomplish a FHIR server request, the server URL and the OAuth authorization token (i.e. `fhirServer,` `fhirAuthorization`) MUST be provided in the CDS Hook request. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Parse and Pre-process medication-select request </strong></figcaption>
  <img src="assets/images/Parse_pre-process_select.png" class="figure-img img-responsive img-rounded center-block" alt="Parse_pre-process_select.png" />
</figure>

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: Parse and Pre-process medication-prescribe request </strong></figcaption>
  <img src="assets/images/Parse_pre-process_prescribe.png" class="figure-img img-responsive img-rounded center-block" alt="Parse_pre-process_prescribe.png" />
</figure>

## Clinical Reasoning
This section describes the components and processes of the Clinical Reasoning module used for the PDDI CDS artifacts. The Clinical Reasoning Module provides resources and operations to enable sharing and evaluation of clinical knowledge artifacts. The Clinical Reasoning Module for the PDDI CDS artifacts encompasses the `PlanDefinition, RequestGroup, DetectedIssue,` and CQL libraries. 

### PlanDefinition
In the FHIR resource workflow, the `PlanDefinition` is categorized as a definition. Resources in this category define an action that can occur with a patient. There are three main elements of the PlanDefinition that are used for the PDDI CDS instances. These include `TriggerDefinition`, `Condition`, and `Action.` 
##### TriggerDefinition
{:.no_toc}
The `TriggerDefinition` uses the Name Event, which allows triggering of an event opposed to a scheduled or fixed event. The TriggerDefinition for the PDDI CDS is based on the CDS Hooks requests `medication-prescribe` and `medication-select.`
```
"triggerDefinition": {
              "type": "named-event",
              "eventName": "medication-prescribe"
```
```
"triggerDefinition": {
              "type": "named-event",
              "eventName": "medication-select"
```              
##### Condition 
{:.no_toc}
The Condition element is used to determine whether or not the CDS logic is to be applied. If the Condition is satisfied (i.e., true or false), an action(s) is intiated. 
````
"condition": [
              {
                "kind": "applicability",
                "language": "text/cql",
                "expression": "Inclusion Criteria"
````                

##### Action
{:.no_toc}
The `Action` element provides the action(s) and information associated with the action(s). Only one action can be take for each group, which is reflected by the Card actions where the user can only select one. 
````
"condition": [
              {
                "kind": "applicability",
                "language": "text/cql",
                "expression": "Inclusion Criteria"
              }
            ],
            "action": [
              {
                "title": "Increased risk of bleeding",
                "description": "Potential Drug-Drug Interaction between warfarin (product) and NSAID (product)",
                "dynamicValue": [
                  {
                    "path": "action.title",
                    "expression": "Get Base Summary"
                  },
                  {
                    "path": "action.description",
                    "expression": "Get Base Detail"
                  },
                  {
                    "path": "activity.extension",
                    "expression": "Get Base Indicator"
                  }
                ],
                "action": [
                snipped for brevity
````                
##### DynamicValue
{:.no_toc}
The DynamicValue enables customization of the statically defined resources. Since each decision block for PDDIs have one or more individualized information components, integrating patient-specific and product-specific data into specific Card elements is facilitated by the `DynamicValue` element.
````
"action": [
                  {
                    "label": "Assess risk and take action if necessary.",
                    "dynamicValue": [
                      {
                        "path": "action.label",
                        "expression": "Get Card 2 Label"
````
### RequestGroup 
FHIR resource workflow categorizes the `RequestGroup` as a Request, which expresses the intention for something to occur. For the PDDI CDS instance this could involve initiating another medication, substituting a medication order, or discontinuing the current order. The `RequestGroup` resource is created by the CDS service and subsequently transformed into a CDS Hooks response. 

### DetectedIssue 
The `DetectedIssue` resource is created by the Medication Select Service and is subsequently passed to the EHR with the CDS Hooks response as an extension. Mitigating actions corresponding to CDS Card suggestions are documented by the EHR in the `DetectedIssue` resource. The `DetectedIssue` `status` element, instantiated by the Medication Select Service, specifies to the EHR if the prefetch template for the Medication Prescribe Service needs to be fulfilled. The `DetectedIssue` resource is passed to the Medication Prescribe Service with the the `medication-prescribe` Hook request for further processing. For example, a `DetecedIssue`  "final" status may indicate to the EHR that prefetch data for the `medication-prescribe` hook is not needed.

````
  {
  "resourceType" : "DetectedIssue",
  "status" : "preliminary"
  "implicated" : [{ Reference(Any) }], // Interacting drugs
  "mitigation" : [{ // Step taken to address
    "action" : { CodeableConcept }, // Discontinued interacting drug
    snipped for brevity
  }]
}
````

### PDDI CDS CQL Library



This library contains the logic used by the PlanDefinition to establish the condition, as well as to dynamically construct the guidance so that it reflects the data for the current patient.


## CDS Hook Response and Card Display Examples





