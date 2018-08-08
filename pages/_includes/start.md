[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

* **TODO** check `data` backticks to make sure they make sense with the sentence

* **TODO** Phi to work on CQL Library section 

* **TODO** I think that the discovery process should be mentioned in Summary of Operations (even if only to show it in figure 1 and point to that sub-section) to emphasize the critical role of prefetch templates for both Basic and Advanced

* **TODO** Check throughout the document that prefetch is spelled consistently

* **TODO** Check throughout the document that section numbering is consistent and that a consitent style of capitalization or no capitalization is used for code resources 

* **TODO** either make the naming of "Medication Select" and "Medication Prescribe" Services more obvious in the document or do away with them and simply refer to Basic and Advanced. As it is, the terms are first mentioned in a note and are easily missed by a reader skimming through the document 

# <span style="color:silver"> 2.0.0 </span> Getting Started with PDDI CDS



<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

---

## <span style="color:silver"> 2.1.0 </span> What You Will Need

* PDDI CDS knowledge artifacts. It is RECOMMENDED that the knowledge artifacts adhere to the [Minimum Representation of Potential Drug-Drug Interaction Knowledge and Evidence](https://dbmi-icode-01.dbmi.pitt.edu/dikb-evidence/hcls-drug-drug-interaction/index.html) proposed by the [W3C Semantic Web in Health Care and Life Sciences Community Group](https://www.w3.org/community/hclscg/)

* A CDS rule execution engine. Its RECOMMENDED that it be able to execute CDS rules written in [Clinical Quality Language (CQL)](http://www.hl7.org/implement/standards/product_brief.cfm?product_id=400) and represented as a [FHIR `Library`](http://hl7.org/fhir/stu3/library.html) resource, either directly or compiled to HL7 [Expression Logical Model](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md).  ~~evaluation engine to enable the translation and execution of CQL libraries~~

* FHIR server(s) for terminology and patient data

	* [Public](http://wiki.hl7.org/index.php?title=Publicly_Available_FHIR_Servers_for_testing) 
    
	* Local (preferred)

			* [HAPI RESTful Server](http://hapifhir.io/doc_rest_server.html)

			* [HAPI JPA Server](http://hapifhir.io/doc_jpa.html)

			* [HAPI JAX-RS Server](http://hapifhir.io/doc_rest_server_jaxrs.html)

			* [.NET Server](https://github.com/ewoutkramer/fhir-net-api)
			
* The ability to ~~initiate~~ process CDS Hooks requests and ~~receive~~ return CDS Hooks `card` responses. The program receiving CDS Hooks requests MUST be able to process the `medication-prescribe` hook. 

~~~JSON Parser~~

## <span style="color:silver"> 2.2.0 </span> ~~What Is Recommended~~ Related Projects 

The Clinical Decision Support Authoring Tool is a component of the CDS Connect project funded by the [Agency for Healthcare Research and Quality](https://www.ahrq.gov/). The Documentation section describes CDS artifact decision points at both a semi-structured and structured level (CQL). Although currently not tested, it should be possible to use the authoring tool to develop CQL from semi-structured descriptions.

* [Clinical Decision Support Authoring Tool](https://cds.ahrq.gov/cdsconnect/authoring)


## <span style="color:silver"> 2.3.0 </span> CDS Function

To invoke the PDDI CDS service, the EHR needs to send a CDS Hook request at a pre-specified step the workflow process. The CDS Service then parses and processes the request to determine if the prescribed medication conflicts with a medication the patient is presumably taking. If the condition is satisfied, the CDS Service provides individualized information based on the PDDI knowledge base. 

## <span style="color:silver"> 2.4.0 </span> Assumptions
### <span style="color:silver"> 2.4.1 </span>Clinical
{:.no_toc}

PDDIs are, to an extent, theoretical due to knowledge gaps in the literature. Thus, alert specificity and individualized information is limited by available knowledge. The goal of contextualizing or individualizing these alerts is not only to reduce the number of alerts, by increasing specificity, but to improve the clinical relevance of the information that is presented. In this regard, PDDI CDS functions as an educational tool to raise awareness of known factors that may mitigate or increase risk associated with PDDIs. Gaps in the literature relating to contextual factors is a known issue of the domain and is a key limitation to this and other PDDI CDS systems. Moreover, with this limitation, unknown medication adherence, and data quality/availability – it is ultimately the clinician's discretion whether to proceed with interacting orders. 

### <span style="color:silver"> 2.4.2 </span> Technical 
{:.no_toc}

The goal of CDS is to bring clinically relevant information to the clinician at the right time. Therefore, CDS performance is required to meet the responsiveness expectation of the clinician. Delays in presenting information may lead to unsuccessful CDS adoption and clinician frustration. While EHR remains in control of fulfilling prefetch queries, this is a key component of the CDS Hooks standard that dictates performance. Depending on the patient and service, prefetch data may encompass a variety resources captured during various time periods, so it is crucial that implementors and clinicians refine prefetch template parameters to obtain only data that is clinically relevant. The EHR may combine several methods to satisfy prefetch templates. For more information see section [The Importance of the CDS Hooks `prefetch` Resource ](documentation.html) in the Documentation tab.


~~The initial implementation focus is on Epic and Cerner EHR platforms.~~ Each implementation ~~, however,~~ may need to employ a slightly different approach to ensure successful integration of the CDS system. Here are several general aspects that may need to assessed:

* Technical framework for the EHR to interact with CDS Hooks

    * EHR CDS Hooks request for `medication-prescribe` and `medication-select`

    * EHR caputure and presentation of CDS Hooks response

* Terminology mapping (e.g., RxNorm, LOINC)

* Building FHIR resources

* SMART authentication and FHIR server requests

## <span style="color:silver"> 2.5.0 </span> Status
There are two ~~Basic~~ PDDI CDS knowlege artifacts that are used in this Implementation Guide:

* Warfarin + NSAIDs

* Digoxin + Cyclosporine

The PDDIs were chosen for level of complexity, decision points, and contextual factors. These examples serve as reference for the methodology and procedures that may be adopted when developing and implementing PDDI CDS using HL7 FHIR and CDS Hooks standards.

# <span style="color:silver"> 3.0.0 </span> Process 
This section provides an overview of the processes and components that were used to develop the PDDI CDS. It is delineated by Basic and Advanced sections. The Basic section describes the current technology specifications, and what structured code is available in this implementation guide. The Advanced section is a target for the authors of this Implementation Guide to reach in future iterations to optimize the CDS artifacts. Details regarding the individual artifacts can be found in the [Documentation](documentation.html) section.


# <span style="color:silver"> 4.0.0 </span> Basic

## <span style="color:silver"> 4.1.0 </span> Summary of Operations
{:.no_toc}

The process for an individual instance of PDDI CDS begins with the user triggering a CDS Hooks request (i.e., `medication-prescribe`) and ends with the user's action in response to the Card response suggestion(s) (Figure 1). The parse and pre-process subprocess is to determine if a FHIR server query needed. The Clinical Reasoning module evaluates the complete request and creates information to send back the the EHR. The event subprocesses may occur in response to a specific instance (i.e., SMART authorization and FHIR access) or asynchronous of the specific instance (i.e., CDS Discovery). 


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Basic – Medication Prescribe Service Summary </strong></figcaption>
  <img src="assets/images/Basic_Medication_prescribe_service.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_Medication_prescribe_service.png" />
</figure>

## <span style="color:silver"> 4.2.0 </span> CDS Hooks
{:.no_toc}

The PDDI CDS artifacts use the HL7 [CDS Hooks specification](http://cds-hooks.org/specification/1.0/).  The CDS Hooks standard defines the data structure to facilitate communication between the electronic health record and the CDS service through a RESTful API request and response. This allows patient data to be sent and received by the EHR at intervals that better align with clinical workflows – further leveraging FHIR and SMART applications at the point of care. The key instances for using the CDS Hooks data standard are for triggered requests, CDS service responses, and CDS Discovery. The `context` and `prefetch` are two key elements of the CDS Hook request. The `context` element contains data that is task and Hook-specific. The `prefetch` element contains patient specific information that is relevant to the `context` data and the invoked CDS Service. The key element of the CDS service response are CDS Hooks Cards. The Cards contain general information, suggested actions, and display indicators in a structured format for the EHR to display. The CDS Discovery of the CDS Hooks specification delineates information that the CDS service is to provide to the EHR.

> *Note:* The CDS Service is not necessarily CDS Hooks dependent. For this use case, CDS Hooks provides simplicity and specific orientation to standardized CPOE workflow


### <span style="color:silver"> 4.2.1 </span> CDS Discovery
{:.no_toc}

A client system MAY invoke the CDS Service Discovery to identify CDS Services and obtain associated `prefetch` templates. A `prefetch` template is a dictionary of read and search requests for needed resources of a particular service. The PDDI CDS Service MAY provide a `prefetch` template for each service, and the EHR SHOULD populate `prefetch` templates with relevant patient data for the anticipated CDS Hook request.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: CDS Service Discovery </strong></figcaption>
  <img src="assets/images/Discover_CDS_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Discover_CDS_Service.png" />
</figure>

**Example: EHR request for CDS Discovery example**

~~~
GET http://FHIR.org/PDDI-CDS
~~~

**Example: CDS Discovery response example**

~~~
{
  "services": [
    {
      "hook": "medication-prescribe",
      "title": "PDDI CDS Service",
      "description": "CDS Service for drug-drug interactions",
      "id": "PDDI-CDS",
      "prefetch": {
        "medications_stated": "MedicationStatement?patient/{{context.patientId}}/query parameters"
        "medications_dispensed" : "MedicationDispense?patient/{{context.patientId}}/query parameters"
        "medications_administered" : "MedicationAdminister?patient/{{context.patientId}}/query parameters"
        "medications_prescribed" : "MedicationRequest?patient/{{context.patientId}}/query parameters"
        "age" : "Request?patient/{{context.patientId}}/query parameters"
        "UGIB" : "Condition?patient/{{context.patientId}}/query parameters"
      }

~~~

### <span style="color:silver"> 4.3.2 </span> CDS Hooks Request 
{:.no_toc}

The EHR MUST call the PDDI CDS service by sending an HTTP `POST` containing `JSON` to the service endpoint (e.g.,`http://FHIR.org/PDDI-CDS/warfarin-nsaids-cds`). The JSON (CDS Hook) MUST contain elements for the hook that was triggered, FHIR server, user, context, and prefetch.

##### Context
{:.no_toc}

The `context` element of a CDS Hook request contains hook-specific data and is contextual for the current task. For the order entry task, the `context` MUST include the medication product (i.e., `medication` element of the `MedicationRequest` resource ) of the order in process. 

The CDS Hooks context specification for **`medication-prescribe` 1.0.**


Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | ---- | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource

##### Prefetch
{:.no_toc}

The `prefetch` element contains patient data that was provided by the EHR prior to the hook trigger by using the prefetch template. The prefetch query SHOULD build on the context `patientID` to obtain data that is for the current patient. The CDS Service SHOULD then perform a pair-wise comparision of the `context` medication to the patient's current medications in the `prefetch` element. The `prefetch` element SHOULD also contain patient data, other than medications, to individualized the CDS logic and Hook response. 

> *Note:* For simplicity, this implementation guide uses the term "prefetch" regardless of whether the EHR supplies the data prior to a hook request or if it is queried by the CDS service as a post-hoc FHIR server query. All data required by the CDS artifacts is delineated in the prefetch templates. 

##### Bundle 
{:.no_toc}

A `Bundle` is a FHIR resource that is used to group resources into a single instance, which is ideal for messaging with CDS Hooks, storing the collection of resources obtained on CDS discovery, and providing flexibility in using the collections as a persistent instance. Implementaters of PDDI CDS MUST use the `bundle` resource for the key CDS Hooks request components (i.e., `context` and `prefetch`). For each prefetch template query, a Bundle MUST be created to group the resources. A prefetch element MAY contain several Bundle resources with several other resources grouped within.

## <span style="color:silver"> 4.4.0 </span> Clinical Reasoning
{:.no_toc}

This section describes the components and processes of the Clinical Reasoning module used for the PDDI CDS artifacts. The Clinical Reasoning module provides resources and operations to enable sharing and evaluation of clinical knowledge artifacts. For the PDDI CDS artifacts this encompasses the `PlanDefinition, CarePlan, RequestGroup,` and CQL libraries. 

### <span style="color:silver"> 4.4.1 </span> PlanDefinition
{:.no_toc}

In the FHIR resource workflow, the `PlanDefinition` is categorized as a definition. Resources in this category define an action that can occur with a patient. There are three main elements of the PlanDefinition that are used for the PDDI CDS instances. These elements include `TriggerDefinition,` `Condition,` `DynamicValue,` and `Action.` 

##### TriggerDefinition
{:.no_toc}

The `TriggerDefinition` uses the Name Event, which allows triggering of an event opposed to a scheduled or fixed event. The `TriggerDefinition` for a `PlanDefinition` written for PDDI CDS MUST be based on one of the CDS Hooks requests `medication-prescribe` and `medication-select.`

~~~
"triggerDefinition": {
              "type": "named-event",
              "eventName": "medication-prescribe"
~~~
~~~
"triggerDefinition": {
              "type": "named-event",
              "eventName": "medication-select"
~~~              

##### Condition 
{:.no_toc}

The `condition` element is used to determine whether or not the CDS logic is to be applied and the language that the logic is written in. If the `condition` is satisfied (i.e., true or false), an action(s) is intiated. A `condition` element written for PDDI CDS MAY refer to  

~~~
"condition": [
              {
                "kind": "applicability",
                "language": "text/cql",
                "expression": "Inclusion Criteria"
~~~                

##### Action
{:.no_toc}

The `Action` element provides the action(s) and information associated with the action(s). Only one action can be take for each group, which is reflected by the Card actions where the user can only select one. 
~~~
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
~~~                
##### DynamicValue
{:.no_toc}

The DynamicValue enables customization of the statically defined resources. Since each decision block for PDDIs have one or more individualized information components, integrating patient-specific and product-specific data into specific Card elements is facilitated by the `DynamicValue` element.
~~~
"action": [
                  {
                    "label": "Assess risk and take action if necessary.",
                    "dynamicValue": [
                      {
                        "path": "action.label",
                        "expression": "Get Card 2 Label"
~~~

### <span style="color:silver"> 4.4.2 </span> CarePlan and RequestGroup 
{:.no_toc}

The [FHIR resource workflow](https://www.hl7.org/fhir/workflow.html) categorizes the `CarePlan` and `RequestGroup` as requests, thereby expressing the intention for something to occur. The CDS Service creates a `CarePlan` that references a `RequestGroup` for each CDS Hook response Card. As an example, in this implementation guide, the warfarin-nsaids-cds artifact creates four response cards, each containing different information, The `CarePlan` would reference four `RequestGroup` resources under the the `activity` element. The `RequestGroup` `action` element provides information for suggestions and actions in the response card such as initiating another medication, substituting a medication order, or discontinuing the current order. The `CarePlan` and `RequestGroup` resources are subsequently transformed into a CDS Hooks `card` response. 

## <span style="color:silver"> 4.4.3 </span> PDDI CDS CQL Library
{:.no_toc}

This library contains the logic used by the `PlanDefinition` to establish the condition, as well as to dynamically construct the guidance so that it reflects the data for the current patient.


## <span style="color:silver"> 4.5.0 </span> FHIR Server Request
{:.no_toc}

A FHIR server request by the CDS service after receiving a CDS Hooks request (e.g., `medication-prescribe`) might be necessary depending on the availability of prefetch data in the request. While the prefetch element is OPTIONAL, it MUST NOT be partially fulfilled. The prefetch element MUST be either empty or have all data specified by the prefetch template. In the event the EHR does not provide prefetch data, the PDDI CDS service MUST request the data from the FHIR server via network call. This event is performed at the parse and pre-process phase shown in Figure 3. To accomplish a FHIR server request, the server URL and the OAuth authorization token (i.e. `fhirServer,` `fhirAuthorization`) MUST be provided in the CDS Hooks request. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Basic – Parse and Pre-process CDS Hooks request </strong></figcaption>
  <img src="assets/images/Basic_Parse_pre-process.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_Parse_pre-process.png" />
</figure>



## <span style="color:silver"> 4.6.0 </span> CDS Hooks Response and Card Display
{:.no_toc}

[Basic Warfarin + NSAID Cards](documentation.html)


# <span style="color:silver"> 5.0.0 </span> Advanced


As previously discussed, the Advanced section is a target for future implementations. This section does not provide a comprehensive overview but highlights key deviations from the Basic implementation section above.  


The primary differences between the Basic and Advanced sections include:
* Creating a `medication-select` and `medication-prescribe` service for each CDS artifact
* Specifying the `medication-select` context for the CDS Hooks request
* Referencing DetectedIssue resource in the CarePlan
* Creating a CDS Hooks response extension for DetectedIssue resource
* Adding detectedIssueId element to the `context` of `medication-prescribe` CDS Hooks request
* Adding a `potentiation` element extension to DetectedIssue resource
 
From a technical and clinical perspective, the Advanced implementation has several features that make it preferable. First, PDDI information is split and moved up further in the order entry workflow. This provides clinicians with actionable information in the middle of their decision making process – before completing the order. Second, by splitting contextual factors into `medication-select` (medication resources) and `medication-prescribe` (other resources specific to PDDI), this may limit the amount of information that needs to be shown to fulfill the MIM, and limit the amount of information the EHR has to provide. For example, if a clinician started an NSAID order for a patient that was taking warfarin and decided to discontinue the order based on the presented cards, the clinician would only need to read and process medication factors, and the EHR would not query for additional patient resources such as age and history of upper gastrointestinal bleed. Finally, by creating a DetectedIssue resource, this stores clinician action information and enables the Medication Prescribe Service to present refined information based on these actions. For example, if the clinician decided to continue with the NSAID prescription but added a proton pump inhibitor (risk mitigating action), the Medication Prescribe Service would be adjusted the indicator from "hard-stop" to "warning;" whereby, further increasing alert specificity.    
 
> *Note:* We have chosen to delineate a separate CDS Service for each CDS Hook (i.e., Medication Select Service and Medication Prescribe Service) for clarity, standards' precision, logic flexibility, and to avoid CDS service state requirement. However, both CDS Services are under the PDDI CDS auspices and apply to each artifact for a given medication order event. 


## <span style="color:silver"> 5.1.0 </span> Advanced – CPOE Workflow
{:.no_toc}
Different contextual factors are available and needed at different times during the medication order process (Figure 4). To align clinicians' information needs with PDDI information, the Advanced proposal explores two separate points in the medication order workflow:

* Selecting a drug product to include in medication order (`medication-select`)

* Signing a medication order (`medication-prescribe`)


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: CPOE Workflow Example </strong></figcaption>
  <img src="assets/images/CPOE_workflow.png" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow.png" />
</figure>

## <span style="color:silver"> 5.2.0 </span> Advanced – Summary of Operations
{:.no_toc}
Coordinating the Medication Select Service with the Medication Prescribe Service is a crucial aspect of the Advanced implementation. Whether the Medication Prescribe Service is called depends on aspects of the `DetectedIssue` resource (i.e., `status` element). The DetectedIssue resource is created by the Medication Select Service and populated by clinician actions in response the displayed Cards. Figure 5 depicts the summary of operations that coordinates the Medication Select and Medication Prescribe Services.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: Advanced – PDDI CDS Service Summary </strong></figcaption>
  <img src="assets/images/Advanced_Summary.png" class="figure-img img-responsive img-rounded center-block" alt="Advanced_Summary.png" />
</figure>

## <span style="color:silver"> 5.3.0 </span> CDS Hooks
{:.no_toc}



### <span style="color:silver"> 5.3.1 </span> Advanced – CDS Service Discovery response example
{:.no_toc}

~~~
{
"services": [
  {
    "hook": "medication-select",
    "title": "PDDI CDS Service",
    "description": "CDS Service for drug-drug interactions",
    "id": "PDDI-CDS-medication-select",
    "prefetch": {
      "medications_stated": "MedicationStatement?patient/{{context.patientId}}/query parameters"
      "medications_dispensed" : "MedicationDispense?patient/{{context.patientId}}/query parameters"
      "medications_administered" : "MedicationAdminister?patient/{{context.patientId}}/query parameters"
      "medications_prescribed" : "MedicationRequest?patient/{{context.patientId}}/query parameters"
    }
  },
  {
    "hook": "medication-prescribe",
    "title": "PDDI CDS Service",
    "description": "CDS Service for drug-drug interactions",
    "id": "PDDI-CDS-medication-prescribe",
    "prefetch": {
      "drug_drug_interaction": "DetectedIssue/{{context.detectedissueId}}/query parameters"
      "observations": "Observation?detectedissue/{{context.detectedissueId}}/query parameters"
      "conditions": "Condition?detectedissue/{{context.detectedissueId}}/query parameters"
    }
  }
 ]
}
~~~

### <span style="color:silver"> 5.3.2 </span> Advanced – CDS Hooks Request
{:.no_toc}

The advanced PDDI CDS case, which is currently OPTIONAL, specifies the use of both the `medication-select` and `medication-prescribe` CDS Hooks during a single medication order task. In addition to creating a `medication-select` request (currently not a part of the CDS Hooks standard), the `mediction-prescribe` `context` is modified to include elements of the DetectedIssue resource. 


#### Context
{:.no_toc}

The `context` element of the `medication-select` CDS Hooks request is identical to the current `medication-prescribe` specification used in the Basic implementation. The `context` element in the Advanced `medication-prescribe` element has a minor modification to include the detectedissueID. The detectedissueID indicates the PDDI that was identified by the Medication Select Service (e.g., `id : "warfarin-NSAID"`). For details on the specification refer to the Advanced CDS Hooks Specification section below.


#### **`medication-select` 1.0** (new CDS Hook)

{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | :----: | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource

##### **`medication-prescribe` 1.1** (modification of a current CDS Hook)
 {:.no_toc}
 The version for the `medication-prescribe` hook is 1.0. The Advanced PDDI CDS implementation requires an additional context field. This modification is considered Minor but will change the version to 1.1.


| Field       | Optionality        |  Prefetch Token     |Type  | Description |
| :------------- |:-------------:|:-------: |:-----:| :-----------------|
| `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context |
| `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context |
| `detectedissueId` | REQUIRED     | Yes |    *string* | STU3 - FHIR `DetectedIssue` resource |
| `detectedissueStatus` | REQUIRED     | No |    *code* | STU3 - FHIR `DetectedIssue` resource |
| `medication` | REQUIRED     | No |    *object* | STU3 - FHIR `MedicationRequest` resource |


#### Prefetch
{:.no_toc}
Since the order entry task is split into two separate CDS Hooks events (i.e., services), the prefetch template for the Medication Select Service includes only medication resources. The prefetch template for the Medication Prescribe Service includes any additional resources needed for a specific PDDI after accounting for clinician action(s). 

##### Example : CDS Hooks Request
{:.no_toc}

## <span style="color:silver"> 5.6.0 </span> DetectedIssue 
{:.no_toc}

If the CDS service provides Advanced CDS using `medication-select` then, it MUST return a `DetectedIssue` resource in the CDS Hooks `card` response upon processing a `medication-select` request. The purpose of this is to enable the client EHR to document mitigating actions corresponding to CDS Card suggestions using the `DetectedIssue` resource. The CDS service also MUST provide a `status` element in the returned `DetectedIssue` that specifies if the prefetch template to be sent in the subsequent `medication-prescribe` request needs to be fulfilled. The client EHR MUST include a copy of the `DetectedIssue` that it receives in response to a `medication-select` request in the subsequent `medication-prescribe` request. The CDS service MUST read the `DetectedIssue` `status` value. If the status value is "final", the CDS Service MUST NOT retrieve prefetch data from the EHR for the `medication-prescribe`. If the `status` is "preliminary", the CDS Service MUST retrieve data specified in the prefetch template.

##### Example: DetectedIssue Elements
{:.no_toc}
~~~
  {
  "resourceType" : "DetectedIssue",
  "status" : "preliminary"
  "implicated" : [{ Reference(Any) }], // Interacting drugs
  "mitigation" : [{ // Step taken to address
    "action" : { CodeableConcept }, // Discontinued interacting drug
    snipped for brevity
  }]
}
~~~

## <span style="color:silver"> 5.7.0 </span> FHIR Server Request
{:.no_toc}
The parse and pre-process event for `medication-select` requests by the Advanced PDDI CDS service ~~Medication Select Service~~ is identical to what occurs with `medication-prescribe` for the Basic service. Processing of `medication-prescribe` by the Advanced service is slightly different (Figure 6). During the parse and pre-process phase the CDS service checks the medication that was finally ordered against the `detectedissueID` field. This is to confirm that the prescriber continued with the conflicting order after having the option to change the medication in response to the previously sent CDS Hook `card` suggestions. In addition, the `DetectedIssue` `status` field indicates to the CDS service if additional prefetch data is needed for the specific PDDI.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 6: Advanced – Parse and Pre-process for Medication Prescribe Service </strong></figcaption>
  <img src="assets/images/Parse_pre-process_prescribe.png" class="figure-img img-responsive img-rounded center-block" alt="Parse_pre-process_prescribe.png" />
</figure>



## <span style="color:silver"> 5.9.0 </span> Advanced – Hooks Response and Card Display
{:.no_toc}

[Advanced Warfarin + NSAID Cards](documentation.html)




