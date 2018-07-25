# Getting Started with PDDI CDS

## Status
There are two PDDI CDS artifacts available in this Implemenation Guide. These specific PDDIs were chosen based on complexity, decision points, and priority. These examples serve as reference for the methodology and procedures that may be adopted when developing and implementing PDDI CDS using FHIR and CDS Hooks standards.  
* Warfarin + NSAIDs
* Digoxin + Cyclosporin

# Process 
This section provides an overview of the processes and components that were used to develop the PDDI CDS artifacts. Specific details regarding the individual artifacts can be found in the [Documentation](documentation.html) section.  

#### CDS Function
To invoke the PDDI CDS service, the patient in question needs to be prescribed a medication (i.e., in the `context` element of CDS Hook) that conflicts with a medication that the patient is presumably taking (i.e., `prefetch` element or FHIR server request). The CDS Service provides contextual information based on the coinciding  patient factors and the "Mimimum Information Model" knowledge base.  

#### Assumptions
Potential drug-drug interactions, to an extent, are theoretical due to knowledge gaps in the literature. Thus, the specificity of alerts and individualized information is limited by the available knowledge.  The goal of contextualizing or individualizing these alerts is to not only reduce the number of alerts by increasing the specificity of alerts, but to improve the clinical relevance of the information that is presented. In this regard, PDDI CDS functions as an educational tool to raise awareness of known factors that may mitigate or increase risk associated with PDDIs. Gaps in the literature regarding contextual factors is a known issue in the domain and a key limitation to this implementation and other drug-drug interaction CDS. Compounded with medication adherence issues and data quality/availability, it is ultimately up to the clinician's discretion to proceed with interacting orders. 

The initial implementation focus is on Epic and Cerner EHR platforms. Each cite, however, will need to determine the best approach to ensure a successful integration. There are several general aspects that need to assessed:
* Technical frame work for the EHR to interact with CDS Hooks
    * EHR CDS Hooks request for medication-prescribe and medication-select
    * EHR caputure and presentation of CDS Hooks response
* Terminology mapping (e.g., RxNorm, LOINC)
* FHIR resources include but may not be limited to those listed under [Profiles](profiles.html)
* SMART authentication and FHIR server requests



<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Summary of Operations </strong></figcaption>
  <img src="assets/images/Summary_of_operations.png" class="figure-img img-responsive img-rounded center-block" alt="Summary_of_operations.png" />
</figure>


#### CDS Hooks
The PDDI CDS artifacts use the HL7 [CDS Hooks specification](http://cds-hooks.org/specification/1.0/). 
The CDS Hooks define the data structure to facilitate communication between the electronic health record and the PDDI CDS service through a RESTful API request and response. This allows patient data to be sent and received by the EHR at intervals that can better align with clinical workflows – further leveraging FHIR and SMART applications at the point of care. Relevant examples and clarifications for CDS Hooks in this implementation guide are below   

##### Discovery
The CDS service discovery is invoked for querying data that is needed for an anticipated CDS Hook request. This is a process that is performed at the EHR vendors discretion to improve the performance by supplying data that is needed for most CDS services associated with a specific Hook. 


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: CDS Service Discovery </strong></figcaption>
  <img src="assets/images/Discover_CDS_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Discover_CDS_Service.png" />
</figure>






```{
  "services": [
    {
      "hook": "medication-prescribe",
      "title": "PDDI CDS Service",
      "description": "CDS Service for drug-drug interactions",
      "id": "PDDI-CDS",
      "prefetch": {
        "patientToGreet": "Patient/{{context.patientId}}"
      }
    },
    {
      "hook": "medication-prescribe",
      "title": "Medication Echo CDS Service",
      "description": "An example of a CDS Service that simply echos the medication being prescribed",
      "id": "medication-echo",
      "prefetch": {
        "patient": "Patient/{{context.patientId}}",
        "medications": "MedicationOrder?patient={{context.patientId}}"
      }
    }
  ]
}
```




##### Request 
The EHR calls the PDDI CDS service by `POST` ing a `JSON` file (CDS Hook) to the service endpoint `{baseUrl}/cds-services/{PDDI-CDS}`. Two components of a request are processed to determine if a request is relevant for a specific PDDI: `context` and `prefetch`.

`curl -0 -v -X POST http://localhost:XXXX/cds-services/pddi-cds  -H 'Content-type: application/json' -d\`

###### Context
The `context` of a CDS Hook request contains Hook-specific data that is processed to determine if the CDS rule is satisfied for one or more PDDI. The `context` resource used for both the `medication-prescribe` and `medication-select` hooks is `MedicationRequest`. While the `MedicationRequest` resource may be present in the `context` or `prefetch`, it represents the medication that is currently being prescribed in the `context`. 



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
### RequestGroup and Careplan
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




