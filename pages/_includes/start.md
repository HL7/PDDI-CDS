[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

* **TODO** split into Basic and Advanced
* **TODO** add numbers to sections?
* **TODO** check `data` backticks to make sure they make sense with the sentence
* **TODO** add example of CDS Hook response and possibly a mockup of the cards Cards
* **TODO** Phi to work on CQL Library section
* **TODO** work on tables for specification 
* **TODO** add motivation for Advanced implementation 

# Getting Started with PDDI CDS
{:.no_toc}


<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

---

# What You Will Need

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

## What Is Recommended 

The Clinical Decision Support Authoring Tool is a componenet of the CDS Connect project funded by the [Agency for Healthcare Research and Quality](https://www.ahrq.gov/). The Documentation section has the decision points described at a semi-structured level. The authoring tool can then be used to translated this knowledge into a structured formate using CQL.


* [Clinical Decision Support Authoring Tool](https://cds.ahrq.gov/cdsconnect/authoring)


# CDS Function

To invoke the PDDI CDS service, the EHR needs to send a CDS Hook request at a pre-specified step the workflow process. The CDS Service then parses and processes the request to determine if the prescribed medication conflicts with a medication that the patient is presumably taking. If the condition is satisfied, the CDS Service provides individualized information based on the PDDI knowledge base. 

# Assumptions
### Clinical
{:.no_toc}
Potential drug-drug interactions, to an extent, are theoretical due to knowledge gaps in the literature. Thus, the specificity of alerts and individualized information provided is limited by the available knowledge.  The goal of contextualizing or individualizing these alerts is not only to reduce the number of alerts, by increasing specificity, but to improve the clinical relevance of the information that is presented. In this regard, PDDI CDS functions as an educational tool to raise awareness of known factors that may mitigate or increase risk associated with PDDIs. Gaps in the literature relating to contextual factors is a known issue of the domain and is a key limitation to this and other drug-drug interaction CDS systems. Moreover, with this limitation, unknown medication adherence, and data quality/availability, it is ultimately up to the clinician's discretion to proceed with interacting orders. 

### Technical 
{:.no_toc}
The goal of CDS is to bring clinically relevant information to the clinician at the right time; therefore, CDS performance is required to meet the responsiveness expectation of the clinician. Delays in presenting information may lead to unsuccessful adoption of the CDS system and clinician frustration. While the EHR vendor remains in control of fulfilling prefetch queries, this is a key component that dictates the CDS performance. Depending on the patient and Hook, prefetch data may encompass a variety resources captured during various time periods, so it is crucial that implementors and clinicians refine prefetch template parameters to obtain only data that is clinically relevant. EHR vendors may combine several methods to satisfy prefetch templates. For example, the EHR may compute a set of prefetch templates with data in memory and others with FHIR server network calls. 


The initial implementation focus is on Epic and Cerner EHR platforms. Each implementation, however, may need to employ a slightly different approach to ensure successful integration of the CDS system. There are several general aspects that may need to assessed:

* Technical framework for the EHR to interact with CDS Hooks

    * EHR CDS Hooks request for `medication-prescribe` and `medication-select`

    * EHR caputure and presentation of CDS Hooks response

* Terminology mapping (e.g., RxNorm, LOINC)

* FHIR resources include but may not be limited to those listed under [Profiles](profiles.html)

* SMART authentication and FHIR server requests

# Status
There are two PDDI CDS artifacts available in this Implementation Guide:

* Warfarin + NSAIDs

* Digoxin + Cyclosporin

These specific PDDIs were chosen based on complexity, decision points, and contextual factors. These examples serve as reference for the methodology and procedures that may be adopted when developing and implementing PDDI CDS using HL7 FHIR and CDS Hooks standards.



# Process 
This section provides an overview of the processes and components that were used to develop the PDDI CDS. It is delineated by Basic and Advanced sections. The Basic section describes the current technology specifications, and what structured knowledge is available in this Implementation Guide. The Advanced section is a target for the authors of this Implementation Guide to reach in future iterations to optimize the CDS artifacts. Details regarding the individual artifacts can be found in the [Documentation](documentation.html) section.  


# Basic

### Summary of Operations
The CDS Discovery is the initial process that occurs...
#### Medication Prescribe Service
{:.no_toc}
<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Basic – Medication Prescribe Service Summary </strong></figcaption>
  <img src="assets/images/Basic_Medication_prescribe_service.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_Medication_prescribe_service.png" />
</figure>

## CDS Discovery

The CDS Service Discovery is invoked to identify CDS Services and obtain associated `prefetch` templates. A `prefetch` template is a dictionary of read and search requests for the needed resources for a particular service. The PDDI CDS Service provides a `prefetch` template for each service, and the EHR SHOULD populate `prefetch` templates with relevant patient data for the anticipated CDS Hook request. CDS Service Discovery and fulfilling `prefetch` queries are performed at the discretion EHR vendor.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: CDS Service Discovery </strong></figcaption>
  <img src="assets/images/Discover_CDS_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Discover_CDS_Service.png" />
</figure>

##### Example 1: EHR Request for CDS Discovery
{:.no_toc}
````
GET http://FHIR.org/PDDI-CDS
````

##### Example 2: Basic – CDS Service Discovery Response
{:.no_toc}
````
{
  "services": [
    {
      "hook": "medication-prescribe",
      "title": "PDDI CDS Service",
      "description": "CDS Service for drug-drug interactions",
      "id": "PDDI-CDS",
      "prefetch": {
        "medications_stated": "MedicationStatement?patient/{{context.patientId}}..."
        "medications_dispensed" : "MedicationDispense?patient/{{context.patientId}}..."
        "medications_administered" : "MedicationAdminister?patient/{{context.patientId}}..."
        "medications_prescribed" : "MedicationRequest?patient/{{context.patientId}}..."
        "age" : "Request?patient/{{context.patientId}}..."
        "UGIB" : "Condition?patient/{{context.patientId}}..."
      }

````

## CDS Hooks

The PDDI CDS artifacts use the HL7 [CDS Hooks specification](http://cds-hooks.org/specification/1.0/). 
The CDS Hooks standard defines the data structure to facilitate communication between the electronic health record and the CDS service through a RESTful API request and response. This allows patient data to be sent and received by the EHR at intervals that better align with clinical workflows – further leveraging FHIR and SMART applications at the point of care. The `context` and `prefetch` are two key elements of the CDS Hook request. The `context` element contains data that is task and Hook-specific. For this use case where two separate Hooks can be used for a specific medication order task, the `context` contains the current `MedicationRequest` resource for the `medication-select` request and the `DetectedIssue` resource for the `medication-prescribe` request. The `prefetch` element contains patient specific information that is relevant to the `context` data and the invoked CDS Service. If the EHR vendor decides not to provide `prefetch` data, the CDS Service MUST request needed data via post-hoc FHIR server request at pre-processing. The goal is to improve the performance of the CDS system by supplying data that is needed for most CDS services associated with a specific Hook in the request `prefetch` element. Examples and clarifications for CDS Hooks relevant to this use case are below.

> *Note:* The CDS Service is not necessarily CDS Hooks dependent. For this use case, CDS Hooks provides simplicity and specific orientation to standardized CPOE workflow


 
#### Specification 
{:.no_toc}
The available CDS Hook context specification for the order entry task is **`medication-prescribe` 1.0.**



Field | Optionality | Prefetch Token | Type | Description
----- | -------- | ---- | ---- | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource


### CDS Hooks Request 
{:.no_toc}
The EHR calls the PDDI CDS service by `POST` ing a `JSON` file to the service endpoint (e.g.,`http://FHIR.org/PDDI-CDS/warfarin-nsaids-cds`). The JSON file (CDS Hook) contains elements for the hook that was triggered, FHIR server, user, context, and prefetch.

##### Context
{:.no_toc}
The `context` element of a CDS Hook request contains hook-specific data and is contextual for the current task. For the order entry task, the `context` needs the medication product (i.e., `medication` element of the `MedicationRequest` resource ) of the order that is in process. 


##### Prefetch
{:.no_toc}
The `prefetch` element contains patient data that was provided by the EHR prior to the hook trigger by using the prefetch template. Typically, the prefetch query will build on the context `patientID` to obtain data that is for the current patient. The CDS Service then performs a pair-wise comparision of the `context` medication to the patient's current medications in the `prefetch` element. The `prefetch` element also contains patient data, other than medications, to individualized the CDS logic and Hook response. 

> *Note:* Based on the standard prescription days-supply, a 100-day time period is recommended as a starting point for all medication resources (i.e., `MedicationRequest, MedicationDispense, MedicationStatement, MedicationAdministration).`

##### Bundle 
{:.no_toc}
A `Bundle` is a FHIR resource that is used to group resources into a single instance, which is ideal for messaging with CDS Hooks, storing the collection of resources obtained on CDS discovery, and providing flexibility in using the collections as a persistent instance. This implementation uses the `bundle` resource for the key CDS Hook components (i.e., `context` and `prefetch`).  

## Clinical Reasoning
This section describes the components and processes of the Clinical Reasoning module used for the PDDI CDS artifacts. The Clinical Reasoning Module provides resources and operations to enable sharing and evaluation of clinical knowledge artifacts. The Clinical Reasoning Module for the PDDI CDS artifacts encompasses the `PlanDefinition, RequestGroup, DetectedIssue,` and CQL libraries. 

### PlanDefinition
{:.no_toc}
In the FHIR resource workflow, the `PlanDefinition` is categorized as a definition. Resources in this category define an action that can occur with a patient. There are three main elements of the PlanDefinition that are used for the PDDI CDS instances. These elements include `TriggerDefinition`, `Condition`, and `Action.` 
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
### CarePlan and RequestGroup 
{:.no_toc}
The FHIR resource workflow(link) categorizes the `CarePlan` and `RequestGroup` as a Requests, which expresses the intention for something to occur. The CDS Service creates a `CarePlan` that references a `RequestGroup` for each CDS Hook response Card. For example, the warfarin-nsaids-cds service creates four response cards with different information, so the CarePlan would reference four RequestGroup resources under the the `activity` element. The RequestGroup `action` element provides information for suggestions and actions in the response card such as initiating another medication, substituting a medication order, or discontinuing the current order. The CarePlan and RequestGroup resources are subsequently transformed into a CDS Hooks responses. 

#### FHIR Server Request

A post-hoc FHIR server request by the CDS Service may be necessary depending on the availablity of prefetch data. While the prefetch element is optional, it MUST not be partially fulfilled. The prefetch element is either empty or has all data specified by the prefetch template. In the event the EHR does NOT provide prefetch data, the PDDI CDS service MUST request the data from the FHIR server via network call. This event is performed at the parse and pre-process phase. To accomplish a FHIR server request, the server URL and the OAuth authorization token (i.e. `fhirServer,` `fhirAuthorization`) MUST be provided in the CDS Hook request. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Basic – Parse and Pre-process CDS Hooks request </strong></figcaption>
  <img src="assets/images/Basic_Parse_pre-process.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_Parse_pre-process.png" />
</figure>

### PDDI CDS CQL Library

This library contains the logic used by the PlanDefinition to establish the condition, as well as to dynamically construct the guidance so that it reflects the data for the current patient.


## CDS Hook Response and 

## Basic Card Display Examples

[Documentation](documentation.html)


# Advanced


As previously discussed, the Advanced section is a target for future implementations. This section does not provide a comprehensive overview but highlights key deviations from the Basic implementation section above.  


The primary differences between the Basic and Advanced sections include:
* Specifying a `medication-select` CDS Hook
* Referencing a DetectedIssue resource in the CarePlan
* Creating a CDS Hooks response extension for DetectedIssue
* Adding detectedIssueId element to the `context` of `medication-prescribe` CDS Hook request
 
From a technical and clinical perspective, the Advanced Implementation has several features that make it preferable. First, PDDI information is split and moved up further in the order entry workflow. This provides clinicians with actionable information in the middle of their decision making process – before completing the order. Second, by splitting contextual factors into `medication-select` (medication resources) and `medication-prescribe` (other resources specific to PDDI), this may limit the amount of information that needs to be shown to fulfill the Minimum Information Model, and the amount of information the EHR has to provide. For example, if a clinician started an NSAID order and decided to discontinue the order based on the presented cards, the clinician would only need to read and process medication factors, and the EHR would not query for additional patient resources such as age and history of upper gastrointestinal bleed. Finally, by creating a DetectedIssue resource, this stores information on clinician action and enables the Medication Prescribe to present refined information based on these actions. For example, if the clinician decided to continue with the NSAID prescription but added a proton pump inhibitor, the `medication-prescribe` alert would be adjusted from "hard-stop" to "warning."    
 
> *Note:* Examples and explainations for the differences are provided in the sections below

# Advanced – CPOE Workflow
Different contextual factors are available and needed at different times during the medication order process. To align clinicians' information needs with PDDI information, the Advanced sections explore the use of two separate points in the medication therapy workflow:

* Signing a medication order (`medication-prescribe`)

* Selecting a drug product to include in medication order (`medication-select`)

We have chosen to delineate a separate CDS Service for each CDS Hook (i.e., Medication Select Service and Medication Prescribe Service) for clarity, standards' precision, logic flexibility, and to avoid CDS service state requirement. However, both CDS Services are under the PDDI CDS auspices and apply to each artifact for a given medication order event. 

> *Note:* `medication-prescribe` exists in the CDS Hooks standard, but modifying the `context` element requires a new Hook Verson. Additionally, `medication-select` Hook is under development. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: CPOE Workflow Example </strong></figcaption>
  <img src="assets/images/CPOE_workflow.png" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow.png" />
</figure>

### Summary of Operations
Coordinating the `medication-select` with the `medication-prescribe` CDS Hooks request is a crucial aspect of the Advanced implementation. Whether the Medication Prescribe Service is called depends on aspects of the `DetectedIssue` resource. The `DetectedIssue` resource is created by the Medication Select Service and populated by clinician actions in response to `medication-select` response cards. Figure X depicts the summary of operations that coordinates the medication-select and medication-prescribe services.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Advanced PDDI CDS Service Summary </strong></figcaption>
  <img src="assets/images/Advanced_Summary.png" class="figure-img img-responsive img-rounded center-block" alt="Advanced_Summary.png" />
</figure>

### CDS Hooks

#### Advanced CDS Hooks Specification
{:.no_toc}
This implementation guide specifies the use of up to two CDS Hooks (i.e., `medication-select` and `medication-prescribe`) during a single medication order task. In addition to creating a new hook, coordinating the two hooks requires modifying the current specification context of the `mediction-prescribe` hook. 

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
| encounterId     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context |
| detectedissueId | REQUIRED     | Yes |    *string* | STU3 - FHIR `DetectedIssue` resource |
| detectedissueStatus | REQUIRED     | No |    *code* | STU3 - FHIR `DetectedIssue` resource |
| medication | REQUIRED     | No |    *object* | STU3 - FHIR `MedicationRequest` resource |



#### Example x: Advanced CDS Service Discovery Response
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

### Context
{:.no_toc}
The `context` element of the `medication-select` CDS Hook request is identical to the current `medication-prescribe` specification for used in the Basic section. The `context` element in the Advanced `medication-prescribe` element has a minor modification to include the detectedissueID. The detectedissueID indicates the PDDI that was identified by the Medication Select Service (e.g., `id : "warfarin-NSAID"`). For details on the specification refer to the Advanced CDS Hooks Specification section above.

### Prefetch
{:.no_toc}
Since the order entry task is split into two separate CDS Hooks events, the prefetch template for the `medication-select` hook includes only medication resources. The prefetch template for `medication-prescribe` includes any additional resources needed by the CDS service for a specific PDDI.  

##### Example : CDS Hooks Request
{:.no_toc}

### DetectedIssue 
(in the CarePlan.activity.reference) The `DetectedIssue` resource is created by the Medication Select Service and is subsequently passed to the EHR with the CDS Hooks response as an extension. Mitigating actions corresponding to CDS Card suggestions are documented by the EHR in the `DetectedIssue` resource. The `DetectedIssue` `status` element, instantiated by the Medication Select Service, specifies to the EHR if the prefetch template for the Medication Prescribe Service needs to be fulfilled. The `DetectedIssue` resource is passed to the Medication Prescribe Service with the the `medication-prescribe` Hook request for further processing. For example, a `DetecedIssue`  "final" status may indicate to the EHR that prefetch data for the `medication-prescribe` hook is not needed.

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

### FHIR Server Request
{:.no_toc}
The parse and pre-process event for the `medication-select` CDS Hook request is identical to the Basic `medication-prescribe` parse and pre-process event under section X. The Advanced `medication-prescribe` parse and pre-process event, however, is slightly different. During this phase the CDS service checks the medication that was finally ordered against the detectedissueID. This is to confirm that the prescriber continued with the conflicting order after having the option to change the medication in response the Card suggestions. 


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure : Advanced Parse and Pre-process medication-prescribe request </strong></figcaption>
  <img src="assets/images/Parse_pre-process_prescribe.png" class="figure-img img-responsive img-rounded center-block" alt="Parse_pre-process_prescribe.png" />
</figure>


## CDS Hook Request for `medication-select`

## CDS Hook Request for `medication-prescribe`


## Advanced Card Display Examples

[Documentation](documentation.html)




