[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

# Getting Started with PDDI CDS

## Status
There are two PDDI CDS artifacts available in this Implementation Guide:

* Warfarin + NSAIDs

* Digoxin + Cyclosporin

These specific PDDIs were chosen based on complexity, decision points, and priority. These examples serve as reference for the methodology and procedures that may be adopted when developing and implementing PDDI CDS using HL7 FHIR and CDS Hooks standards.

Different contextual factors are available and needed at different times during the medication order process. To align clinicians' information needs with PDDI information, this implementation guide explores the use of two separate points in the medication therapy workflow:

* Signing a medication order (`medication-prescribe`)

* Selecting a drug product to include in medication order (`medication-select`)

For clarity and standards' precision, we have chosen to delineate a separate CDS Service for each CDS Hook (i.e., Medication Select Service and Medication Prescribe Service); however, both CDS Services are under the PDDI CDS auspices and apply to each artifact.

The motivation for separating and coordinating these two instances in the order entry process stems from the poor performance of current PDDI alerts, where nearly all are ignored due, in part, to prompts that occur after a decision has been made to place a medication order.  

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: CPOE Workflow Example </strong></figcaption>
  <img src="assets/images/CPOE_workflow.png" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow.png" />
</figure>


> *Note:* A the time of this writing, `medication-prescribe` exists in the CDS Hooks standard but `medication-select` is under development. 

# Process 
This section provides an overview of the processes and components that were used to develop the PDDI CDS. Specific details regarding the individual artifacts can be found in the [Documentation](documentation.html) section.  

### CDS Function

To invoke the PDDI CDS service, the EHR needs to send a CDS Hook request at a pre-specified step the workflow process. The CDS Service then parses and processes the request to determine if the prescribed medication conflicts with a medication that the patient is presumably taking. If the condition is satisfied, the CDS Service provides individualized information based on the PDDI. 

### Assumptions
#### Clinical
Potential drug-drug interactions, to an extent, are theoretical due to knowledge gaps in the literature. Thus, the specificity of alerts and individualized information provided is limited by the available knowledge.  The goal of contextualizing or individualizing these alerts is not only to reduce the number of alerts, by increasing the specificity, but to improve the clinical relevance of the information that is presented. In this regard, PDDI CDS functions as an educational tool to raise awareness of known factors that may mitigate or increase risk associated with PDDIs. Gaps in the literature relating to contextual factors is a known issue in the domain and is a key limitation to this and other drug-drug interaction CDS systems. Moreover, with this limitation, unknown medication adherence, and data quality/availability, it is ultimately up to the clinician's discretion when proceeding with interacting orders. 




#### Technical 

The goal of CDS is to bring clinically relevant information to the clinician at the right time; therefore, CDS performance is required to meet the responsiveness expectations of the clinician. Delays in presenting information may lead to unsuccessful adoption of the CDS system and clinician frustration. While the EHR vendor remains in control of fulfilling `prefetch` queries, this is a key component that dictates the CDS performance. Depending on the patient and Hook, `prefetch` data may encompass a variety resources captured during various time periods. 


The initial implementation focus is on Epic and Cerner EHR platforms. Each implementation, however, may need to employ a slightly different approach to ensure successful integration of the CDS system. There are several general aspects that may need to assessed:

* Technical framework for the EHR to interact with CDS Hooks

    * EHR CDS Hooks request for `medication-prescribe` and `medication-select`

    * EHR caputure and presentation of CDS Hooks response

* Terminology mapping (e.g., RxNorm, LOINC)

* FHIR resources include but may not be limited to those listed under [Profiles](profiles.html)

* SMART authentication and FHIR server requests

### Summary of Operations
The primary differences between the Medication Select Service and the Medication Prescribe Service are the triggering Hook, `context` resources, and `prefetch` queries. Whether the Medication Prescribe Service is called depends on aspects of the `DetectedIssue` resource that is created by the Medication Select Service and populated by clinician actions.

#### DetectedIssue 
The `DetectedIssue` resource is created by the Medication Select Service and is subsequently passed to the EHR with the CDS Hooks response. Mitigating actions corresponding to CDS Card suggestions are documented by the EHR in the `DetectedIssue` resource. The `status` element of the `DetectedIssue` determines if the resource is passed to the Medication Prescribe Service with the `medication-prescribe` Hook request. For example, a "preliminary" `status` may indicate that this resource will send with the `medication-prescribe` request.

````
  {
  "resourceType" : "DetectedIssue",
  "status" : "preliminary"
  "implicated" : [{ Reference(Any) }], // Interacting drugs
  "mitigation" : [{ // Step taken to address
    "action" : { CodeableConcept }, // Discontinued interacting drug
  }]
}
````
The detected issue accomplishes several things:
* flexibility in Discover and fulfilling prefetch data
* captures mitigating responses (card.suggestions.actions) for refined processing by the CDS logic 
* indicates to the user if there is more informaiton to come
* indicates to the EHR when to fulfill prefetch and for what specifically (implicated element)



#### Medication Select Service 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Medication Select Service Summary </strong></figcaption>
  <img src="assets/images/Medication_Select_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Medication_Select_Service.png" />
</figure>

#### Medication Prescribe Service

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Medication Prescribe Service Summary </strong></figcaption>
  <img src="assets/images/Medication_Prescribe_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Medication_Prescribe_Service.png" />
</figure>

### CDS Hooks
The PDDI CDS artifacts use the HL7 [CDS Hooks specification](http://cds-hooks.org/specification/1.0/). 
The CDS Hooks standard defines the data structure to facilitate communication between the electronic health record and the CDS service through a RESTful API request and response. This allows patient data to be sent and received by the EHR at intervals that better align with clinical workflows – further leveraging FHIR and SMART applications at the point of care. Relevant to PDDI CDS, the `context` and `prefetch` are two key elements of the CDS Hook request. The `context` element contains data that is task and Hook-specific. For this use case where two separate Hooks can be used for a specific medication order task, the `context` contains the current `MedicationRequest` resource for the `medication-select` request and the `DetectedIssue` resource for the `medication-prescribe` request. The `prefetch` element contains patient specific information that is relevant to the `context` data and the invoked CDS Service. If the EHR vendor decides not to provide `prefetch` data, the CDS Service MUST request the needed data via post-hoc FHIR server at request pre-processing. The goal is to improve the performance of the CDS system by supplying data that is needed for most CDS services associated with a specific Hook in the request `prefetch` element. Examples and clarifications for CDS Hooks relevant to this use case in this are below.

> *Note:* The CDS Service is not necessarily CDS Hooks dependent. For this use case, CDS Hooks provides simplicity and specific orientation to standardized CPOE workflow



#### Discovery

The CDS Service Discovery is invoked to identify CDS Services and obtain associated `prefetch` templates. A `prefetch` template is a dictionary of read and search requests. The PDDI CDS Service provides a `prefetch` template for each service and the EHR SHOULD populate `prefetch` tokens with relevant patient data for an anticipated CDS Hook request. CDS Service Discovery and fulfilling `prefetch` queries are performed at the discretion EHR vendor. For example, an EHR vendor may fulfill certain `prefetch` queries at the beginning of the day for all scheduled patients, or it may be desirable to query when a specific patient profile is opened.  


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: CDS Service Discovery </strong></figcaption>
  <img src="assets/images/Discover_CDS_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Discover_CDS_Service.png" />
</figure>


##### Example: CDS Service Discovery Response
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



##### Request 

**TODO: remove the curl. Mention the header of the request (raw application/json)

The EHR calls the PDDI CDS service by `POST` ing a `JSON` file (CDS Hook) to the service endpoint `{baseUrl}/cds-services/{PDDI-CDS}`. Two components of a request are processed to determine if a request is relevant for a specific PDDI: `context` and `prefetch`.

###### Context
The `context` of a CDS Hook request contains Hook-specific data that is processed to determine if the CDS rule is satisfied for one or more PDDI. `MedicationRequest` is the `context` resource used for both the `medication-prescribe` and `medication-select` Hooks; hover . While the `MedicationRequest` resource may be present in the `context` or `prefetch`, it represents the medication that is currently being prescribed in the `context`. 


###### Prefetch
The `prefetch` element contains patient data that has been previously queried during the CDS discovery phase. For this implementation, `prefetch` elements include medication resources: `MedicationRequest,` `MedicationDispense,` `MedicationStatement,` and `MedicationAdministration.`  A typical scenario is when the patient has an ongoing medication presented in the `prefetch` element and the current or new medication (conflicting) in the context. 

> *Prefetch Parameters* 
While fulfilling the `prefetch` element of the CDS Hook is not required, it is highly recommended for performance of the CDS system. Since the majority of PDDI alerts rely on medication order characteristics (e.g., dose, timing), this implementation guide recommends only medication associated resources should be implemented as `prefetch.` Based on the regularity of dispensed prescription days-supply, the time-frame parameter for `prefetch` is 100 days for all medication resources (i.e., `MedicationRequest, MedicationDispense, MedicationStatement, MedicationAdministration).`


###### Bundle 
A `Bundle` is a FHIR resource that is used to group a collection of resources into a single instance. For this use case, using the `bundle` resource for each of the CDS Hook components (i.e., `context` and `prefetch`) is ideal for messaging with CDS Hooks, storing the collection of resources obtained on CDS discovery, and providing flexibility in using the collections as a persistent instance. 

TODO example of request together

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Parse and Pre-process Request </strong></figcaption>
  <img src="assets/images/Parse_and_pre-process_Request.png" class="figure-img img-responsive img-rounded center-block" alt="Parse_and_pre-process_Request.png" />
</figure>

## Clinical Reasoning
This section describes the components and processes of the Clinical Reasoning module used for the PDDI CDS artifacts. The Clinical Reasoning Module provides resources and operations to enable sharing and evaluation of clinical knowledge artifacts.

### PlanDefinition
`PlanDefinition` falls into the FHIR resource workflow as a definition. Resources in this category define an action that can occur with a patient. There are three main elements of the PlanDefinition that are used for the PDDI CDS instances. These include `TriggerDefinition`, `Condition`, and `Action.` 
#### TriggerDefinition
The TriggerDefinition uses the Name Event, which allows triggering of an event opposed to a scheduled or fixed event. The TriggerDefinition for the PDDI CDS is based on the CDS Hooks requests `medication-prescribe` and `medication-select.`
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
#### Condition 
The Condition element is used to determine whether or not the CDS logic is to be applied. If the Condition is satisfied (i.e., true or false), an action(s) is intiated. 
````
"condition": [
              {
                "kind": "applicability",
                "language": "text/cql",
                "expression": "Inclusion Criteria"
````                

#### Action
The Action element provides the actions and information associated with the actions that are to be taken. For this implementation, each action with a Condition signifies a CDS Hook response card. 

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
#### DynamicValue
The DynamicValue enables customization of the statically defined resources. Since each decision block for PDDIs have one or more individualized information componenets that are potentially useful to the clinician, integrating patient-specific data into each response card is necessary.
````
"action": [
                  {
                    "label": "Assess risk and take action if necessary.",
                    "dynamicValue": [
                      {
                        "path": "action.label",
                        "expression": "Get Card 2 Label"
````
### DetectedIssue, RequestGroup and CarePlan
The RequestGroup and Careplan fall into FHIR resource workflow as Requests, which expressed the intention for something to occur. For the PDDI CDS instance this could involve initiating another medication, substituting a medication order, or discontinuing the current order. 

````
{
  "resourceType": "CarePlan",
  "status": "active",
  "intent": "order",
  "title": "High risk for opioid overdose - taper now",
  "description": "Total morphine milligram equivalent (MME) is 20200.700mg/d. Taper to less than 50.",
  "activity": [
    {
      "detail": {
        "status": "in-progress",
        "statusReason": "warning"
      }
    }
  ],
  "note": [
    {
      "id": "CDC guideline for prescribing opioids for chronic pain",
      "text": "https://guidelines.gov/summaries/summary/50153/cdc-guideline-for-prescribing-opioids-for-chronic-pain---united-states-2016#420"
    },
    {
      "id": "MME Conversion Tables",
      "text": "https://www.cdc.gov/drugoverdose/pdf/calculating_total_daily_dose-a.pdf"
    }
  ]
}
````
### CDS Hook Response

TODO add example of response and discuss the Cards

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: Flow Diagram for CDS Hooks Request and Response </strong></figcaption>
  <img src="assets/images/CDS_Hooks_Request_Response.png" class="figure-img img-responsive img-rounded center-block" alt="CDS_Hooks_Request_Response.png" />
</figure>

### PDDI CDS CQL Library

TODO Phi update this description

This library contains the logic used by the PlanDefinition to establish the condition, as well as to dynamically construct the guidance so that it reflects the data for the current patient.

## Implementation

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




