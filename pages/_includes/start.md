[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

<!-- backticks refer to elements and hooks only -->

<!-- camel case for resources only, capitalize service name (Medication Prescribe Service?) -->


# <span style="color:silver"> 2.0.0 </span> Getting Started with PDDI CDS
The words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, AND OPTIONAL are used as defined [*"Key words for use in RFCs to Indicate Requirement Levels".* S. Bradner. IETF. March 1997. Best Current Practice.](https://tools.ietf.org/html/rfc2119)

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

---

## <span style="color:silver"> 2.1.0 </span> What You Will Need

* PDDI CDS knowledge artifacts. It is RECOMMENDED that the knowledge artifacts adhere to the [Minimum Representation of Potential Drug-Drug Interaction Knowledge and Evidence](https://dbmi-icode-01.dbmi.pitt.edu/dikb-evidence/hcls-drug-drug-interaction/index.html) proposed by the [W3C Semantic Web in Health Care and Life Sciences Community Group](https://www.w3.org/community/hclscg/)

* A CDS rule execution engine. Its RECOMMENDED that it be able to execute CDS rules written in [Clinical Quality Language (CQL)](http://www.hl7.org/implement/standards/product_brief.cfm?product_id=400) and represented as a [FHIR `Library`](http://hl7.org/fhir/stu3/library.html) resource, either directly or compiled to HL7 [Expression Logical Model](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md).

* FHIR server(s) for terminology and patient data

	* [Public](http://wiki.hl7.org/index.php?title=Publicly_Available_FHIR_Servers_for_testing) 
    
	* Local (preferred)

	    * [HAPI RESTful Server](http://hapifhir.io/doc_rest_server.html)

		* [HAPI JPA Server](http://hapifhir.io/doc_jpa.html)

		* [HAPI JAX-RS Server](http://hapifhir.io/doc_rest_server_jaxrs.html)

		* [.NET Server](https://github.com/ewoutkramer/fhir-net-api)
			
* The service MUST be able to process CDS Hooks requests and return CDS Hooks Card responses.


## <span style="color:silver"> 2.2.0 </span> Related Projects 

The [Clinical Decision Support Authoring Tool](https://cds.ahrq.gov/cdsconnect/authoring) is a component of the CDS Connect project funded by the [Agency for Healthcare Research and Quality](https://www.ahrq.gov/). The Documentation section of this implementation guide describes CDS artifact decision points at a semi-structured level. Although currently not tested, it should be possible to use the authoring tool to develop CQL from semi-structured descriptions.


## <span style="color:silver"> 2.3.0 </span> CDS Function

To invoke the PDDI CDS service, the EHR needs to send a CDS Hooks request at a pre-specified step the workflow process. The CDS Service then parses and processes the request to determine if the prescribed medication conflicts with a medication the patient is presumably taking. If the condition is satisfied, the CDS Service provides individualized information based on the PDDI knowledge base. 

## <span style="color:silver"> 2.4.0 </span> Assumptions
### <span style="color:silver"> 2.4.1 </span>Clinical
{:.no_toc}

PDDIs are, to an extent, theoretical due to knowledge gaps in the literature. Thus, alert specificity and individualized information is limited by available knowledge. The goal of contextualizing or individualizing these alerts is not only to reduce the number of alerts, by increasing specificity, but to improve the clinical relevance of the information that is presented. In this regard, PDDI CDS functions as an educational tool to raise awareness of known factors that may mitigate or increase risk associated with PDDIs. Gaps in the literature relating to contextual factors is a known issue of the domain and is a key limitation to this and other PDDI CDS systems. Moreover, with this limitation, unknown medication adherence, and data quality/availability – it is ultimately the clinician's discretion whether to proceed with interacting orders. 

### <span style="color:silver"> 2.4.2 </span> Technical 
{:.no_toc}

The goal of CDS is to bring clinically relevant information to the clinician at the right time. Therefore, CDS performance is required to meet clinician expectations. Delays in presenting information may lead to unsuccessful CDS adoption and clinician frustration. While the implementor remains in control of fulfilling prefetch queries, this is a key component of the CDS Hooks standard that dictates performance of the CDS system. Depending on the patient and service, prefetch data may encompass a variety resources captured during various time periods, so it is crucial that implementors and clinicians refine prefetch template parameters to obtain only data that is clinically relevant. The EHR may combine several methods to satisfy prefetch templates. For more information see the Documentation section, [CDS Hooks prefetch element](documentation.html).

Each implementation MAY employ a slightly different approach to ensure successful integration of the CDS system. Here are several general aspects to assess:

* Technical framework for the EHR to interact with CDS Hooks

    * EHR CDS Hooks requests

    * EHR capture and presentation of CDS Hooks response
    
    * EHR capture, process, modify, and store a DetectedIssue resource

* Terminology mapping (e.g., RxNorm, LOINC)

* Building FHIR resources

* SMART authentication and FHIR server requests

## <span style="color:silver"> 2.5.0 </span> Status
Two exemplar PDDI CDS knowledge artifacts are used in this implementation guide:

* Warfarin + NSAIDs

* Digoxin + Cyclosporine

> *Note:* The PDDIs were chosen for level of complexity, decision points, and contextual factors. These examples serve as reference for the methodology and procedures that may be adopted when developing and implementing PDDI CDS using HL7 FHIR and CDS Hooks standards.

## <span style="color:silver"> 2.6.0 </span> Level 1 versus Level 2 Implementations

The primary difference between Level 1 and Level 2 Implementations is the addition of a second hook during the order entry task. From a clinical and technical perspective, this sets these PDDI CDS artifact implementations apart from most other PDDI CDS systems. PDDI information is split and moved up further in the order entry workflow. This provides clinicians with actionable information in the middle of their decision making process – before completing the order. By splitting contextual factors into `medication-select` (medication resources) and `medication-prescribe` (other resources specific to PDDI), this MAY limit the amount of information that needs to be shown to cover the minimum information model elements, and it MAY limit the amount of information the EHR has to provide for an order entry task. For example, if a clinician started an NSAID order for a patient that was taking warfarin and decided to discontinue the order based on the presented cards, the clinician would only need to read and process medication factors, and the EHR would not display additional patient resources such as age and history of upper gastrointestinal bleed. Additionally, by creating a DetectedIssue resource that contains clinician responses, this gives control to the clinician on what if any more patient-specific information is presented, and this stores crucial information on clinician action for monitoring PDDIs and improving actionable suggestions. For example, if the clinician decided to continue with the NSAID prescription but added a proton pump inhibitor (risk mitigating action), the Medication Prescribe Service would be adjusted the indicator from "hard-stop" to "warning;" whereby, further increasing alert specificity.    
 


#### Table 1: Specification and Feature Comparision between Level 1 and Level Implementations
{:.no_toc}

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Base Specifications | Level-1 | Level-2 
----- | :--------: | :----: | :----: 
**Specifications** | |  |   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`medication-prescribe 1.0` | **X** | **X** |  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`medication-prescribe 1.1`|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`medication-select 1.0`|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DetectedIssue resource | **X** | **X** | **X** 
**Features** |  |  | 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DetectedIssue potentiation element |  | **X** | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Card response extension for DetectedIssue|  | **X** | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clinician action documentation|  | **X** | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sequential clinician action documentation|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clinician response alert filtering|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Minimized alert presentation|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Minimized data query |  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Scalable framework for contextual factors |  |  | **X** 




# <span style="color:silver"> 3.0.0 </span> Process 
This section provides an overview of the processes and components of the PDDI CDS. It is delineated by Level 1 and Level 2 Implementation sections. The Level 1 Implementation describes the technology specifications, and what structured code is available in this implementation guide. The Level 2 Implementation is a target for future iterations to optimize the CDS artifacts. Details regarding the knowledge artifacts and decision points for the individual artifacts can be found in the [Documentation](documentation.html) section.

## <span style="color:silver"> 3.1.0 </span> CDS Discovery
{:.no_toc}

Prior to a hook trigger and subsequent processes, the EHR MUST initiate a CDS Discovery (Figure 1). CDS Discovery is to identify CDS Services and obtain associated prefetch templates. A prefetch template is a dictionary of read and search requests for needed resources of a particular service. The PDDI CDS Service MAY provide a prefetch template for each service, and the EHR SHOULD populate prefetch templates with relevant patient data for the anticipated CDS Hook request.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: CDS Service Discovery </strong></figcaption>
  <img src="assets/images/Discover_CDS_Service.png" class="figure-img img-responsive img-rounded center-block" alt="Discover_CDS_Service.png" />
</figure>

**Example 1: EHR request for CDS Discovery**

~~~
GET http://FHIR.org/PDDI-CDS
~~~

**Example 2: CDS Discovery response**

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

# <span style="color:silver"> 4.0.0 </span> Level 1 Implementation

The Level 1 Implementation uses the `medication-prescribe 1.0` specification but does not declare the triggering event. Since EHR platforms may have different discrete steps in the order entry process, the implementor decides what action (e.g., selecting a medication product, accepting order completion) triggers the CDS Hooks request.  

Specific CDS Hooks and FHIR standards modifications:
1. CDS Hooks Card extension for DetectedIssue resource
2. DetectedIssue resource extension for `potentiation` element 

## <span style="color:silver"> 4.2.0 </span> Summary of Operations
{:.no_toc}

The process for a unique instance of PDDI CDS begins with the user triggering a CDS Hooks request (i.e., `medication-prescribe`) and ends with the user's action in response to the Card response suggestion(s) (Figure 1). The parse and pre-process subprocess is to determine if a FHIR server query needed. The Clinical Reasoning module evaluates the complete request and creates information to send back the the EHR. The event subprocesses may occur in response to a specific instance (i.e., SMART authorization and FHIR access) or asynchronous of the specific instance (i.e., CDS Discovery). 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Level 1 – Medication Prescribe Service Summary </strong></figcaption>
  <img src="assets/images/Basic_Medication_prescribe_service.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_Medication_prescribe_service.png" />
</figure>



## <span style="color:silver"> 4.3.0 </span> CDS Hooks
{:.no_toc}

The PDDI CDS artifacts use the HL7 [CDS Hooks specification](http://cds-hooks.org/specification/1.0/).  The CDS Hooks standard defines the data structure to facilitate communication between the electronic health record and the CDS service through a RESTful API request and response. This allows patient data to be sent and received by the EHR at intervals that better align with clinical workflows – further leveraging FHIR and SMART applications at the point of care. CDS Hooks instances include CDS Discovery, EHR requests and CDS service response. The `context` and `prefetch` are two key elements of the CDS Hook request. The `context` element contains data that is task and Hook-specific. The `prefetch` element contains patient specific information that is relevant to the `context` data and the invoked CDS service. The CDS Hooks response is a set of Cards. The Cards contain general information, suggested actions, and display indicators in a structured format for the EHR to process and display. The CDS Discovery of the CDS Hooks specification delineates information that the CDS service is to provide to the EHR.

> *Note:* The CDS Service is not necessarily CDS Hooks dependent. For this use case, CDS Hooks standard provides simplicity and specific orientation for integration into the CPOE workflow.



### <span style="color:silver"> 4.3.1 </span> CDS Hooks Request 
{:.no_toc}

The EHR MUST call the PDDI CDS service by sending an HTTP `POST` containing `JSON` to the service endpoint (e.g.,`http://FHIR.org/PDDI-CDS/warfarin-nsaids-cds`). The JSON (CDS Hooks request) MUST contain specified information for the hook that was triggered, FHIR server, user, context, and prefetch.

##### Context
{:.no_toc}

The `context` element of a CDS Hooks request contains contextual data for the current task and is specified below. For example, the `medication-prescribe 1.0` specifies the `context` MUST include the medication product (i.e., `medication` element of the MedicationRequest resource) of the order in process. 

**`medication-prescribe` 1.0.**


Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | ---- | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource

##### Prefetch
{:.no_toc}

The `prefetch` element contains patient data that is provided by the EHR prior to the hook trigger by using the prefetch template. The prefetch query SHOULD build on the context `patientID` to obtain data that is for the current patient. The CDS service SHOULD then perform a pair-wise comparision of the `context` medication to the patient's current medications in the `prefetch` element. If available the `prefetch` element MUST also contain patient data, other than medications, to individualized the CDS logic and response. 

> *Note:* For simplicity, this implementation guide uses the term "prefetch" regardless of whether the EHR supplies the data prior to a hook request or if it is queried by the CDS service as a post-hoc FHIR server query. All data required by the CDS artifacts is delineated in the prefetch templates. 

##### Bundle 
{:.no_toc}

A Bundle is a FHIR resource that groups resources into a single instance, which is ideal for messaging with CDS Hooks, storing the collection of resources obtained on CDS discovery, and providing flexibility in using the collections as a persistent instance. Implementaters of PDDI CDS MUST use the bundle resource for certain `context` elements and all `prefetch` resources. For each prefetch template query, a Bundle MUST be created to group the resources. A prefetch element MAY contain several Bundle resources with several other resources grouped within.

## <span style="color:silver"> 4.4.0 </span> Clinical Reasoning
{:.no_toc}

This section describes the components and processes of the Clinical Reasoning module used for the PDDI CDS artifacts. The Clinical Reasoning module provides resources and operations to enable sharing and evaluation of clinical knowledge artifacts. For the PDDI CDS artifacts this encompasses the `PlanDefinition, CarePlan, RequestGroup,` and CQL libraries. 

> *Note:* While resources and CQL are specified for this implementation guide, these are not required for PDDI CDS functionality. The PlanDefinition, however, is RECOMMENDED at minimum to create sharable PDDI knowledge artifacts.

### <span style="color:silver"> 4.4.1 </span> PlanDefinition
{:.no_toc}

In the [FHIR resource workflow](https://www.hl7.org/fhir/workflow.html), the PlanDefinition resource is categorized as a definition. Resources in this category define an action that can occur with a patient. There are three main elements of the PlanDefinition that are used for the PDDI CDS instances. These elements include `TriggerDefinition,` `Condition,` `DynamicValue,` and `Action.` 

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

The `condition` element is used to determine whether or not the CDS logic is to be applied and the language that the logic is written in. If the `condition` is satisfied (i.e., true or false), an action(s) is initiated.

~~~
"condition": [
              {
                "kind": "applicability",
                "language": "text/cql",
                "expression": "Inclusion Criteria"
~~~                

##### Action
{:.no_toc}

The `Action` element provides the specific action(s) and associated information. Only one action can be taken for each group, which is reflected by the Card actions where the user can only select one. 
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


The [FHIR resource workflow](https://www.hl7.org/fhir/workflow.html) categorizes the CarePlan and RequestGroup resources as requests, thereby expressing the intention for something to occur. The CDS Service creates a CarePlan that references a RequestGroup for each CDS Hook response Card. As an example, in this implementation guide, the Warfarin + NSAID artifact creates four response cards, each containing minimum information model elements and associated actions. The CarePlan references four RequestGroup resources under the the `activity` element. The RequestGroup `action` element provides the suggestions and actions in the response card. The CarePlan and RequestGroup resources are subsequently transformed into a CDS Hooks Card response. 

### <span style="color:silver"> 4.4.3 </span> DetectedIssue 

The DetectedIssue resource is needed to document clinician actions associated with identified PDDIs and increasing the specificity of alerts; thus, it is created by the Medication Prescribe Service in the Level 1 Implementation and the Medication Select Service in the Level 2 Implementation. Level 1 and Level 2 Implementations MUST have EHR functionality to receive, process, modify, and store a DetectedIssue resource created by a PDDI CDS service. Use of the DetectedIssue resource with PDDI CDS requires an extension for the `potentiating` element. The `potentiating` element is analogous but antagonistic to the `mitigating` element that exists. These elements refer to relevant actions that have occurred (e.g.,  initiating another medication, substituting a medication order, or discontinuing the current order). For example, substituting naproxen for acetaminophen when a Warfarin-NSAID interaction is detected would be documented as a mitigating action. Conversely, if the same patient was currently taking prednisone, it would be documented as a potentiating action.  

**Example 3: DetectedIssue Elements**

~~~
  {
  "resourceType" : "DetectedIssue",
  "status" : "preliminary"
  "implicated" : [{ Reference(Any) }], e.g., Interacting drugs
  "mitigation" : [{  e.g., Step taken to address and patient risk mitigating factors
    "action" : { CodeableConcept }, e.g., Discontinued interacting drug
    }]
  "potentiating" : [{  e.g., overriden suggested actions and patient risk potentiating factors
    "action" : { CodeableConcept}, e.g., Overrode discontinuing interacting drug
snipped for brevity
~~~


## <span style="color:silver"> 4.5.0 </span> CQL Library
{:.no_toc}

<!-- 
* for someone new to CQL would need to know  - point them elsewhere
* brief overview of the logic

* for the audience familiar with CQL - explain what is specific to the PDDI use case
* use of FHIR profiles
* importance of the value sets
* how to create the specific library resource for PDD CDS
* connection of CQL to PlanDefinition
* libraries entail and how to use them, utility functions and other libaries
* highlight specific instances that are unique to this implementation 
-->

Clinical Quality Language [(CQL)](https://ecqi.healthit.gov/cql-clinical-quality-language) is developed by HL7 for clinical expertises to express clinical knowledge in an author-friendly and human-readable language.

All artifact logics that clinical domain experts can express using CQL are wrapped in a container called a library. There is a set of declarations documented in [CQL Specification](http://cql.hl7.org) that need to be defined to provide information about the library. Those declarations are Library, Data Models, Libraries, Terminology, Parameters, Context and Statements.

### <span style="color:silver"> 4.5.1 </span> Declarations
{:.no_toc}

#### Library
{:.no_toc}

The library declaration defines the library name used as an identifier for other CQL libraries to reference. The version is an optional declaration.
~~~
library Warfarin_NSAIDs_CDS version '1.0'
~~~

#### Data Models
{:.no_toc}

Data models define the structures that can be used within retrieve expressions in the library.
~~~
using FHIR version '3.0.0'
~~~

For the PDDI CDS artifacts, `FHIR` model, version `3.0.0` is used as the primary data model within the library. The data model supports all [FHIR STU3](https://www.hl7.org/fhir/index.html) resources including Medication Request, Medication Statement, Medication Administration, Medication Dispense, Observation, and Condition.

#### Libraries
{:.no_toc}

Statements defined in specific libraries can be reused in other libraries as a reference by a locally assigned name.
~~~
include PDDICDS_Common version '1.0' called Common
~~~

As an example below, statements defined in the PDDICDS_Common library, version 1.0, can now be referenced using the assigned name of Common.
~~~
define "NSAID Prescription":
  ContextPrescriptions P
    where Common.ToCode(P.medication.coding[0]) in "NSAIDs"
~~~

#### Terminology
{:.no_toc}

A valueset declaration specifies a local identifier that represents a valueset and can be used anywhere within the library that a valueset is expected.
~~~
valueset "Warfarins": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-warfarin'
~~~

This definition establishes the local identifier `Warfarins` as a reference to the external identifier for the valueset, an uniform resource identifier (URI) in this case is `http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-warfarin`. The external identifier should be an ID or an uniform resource identifier (URI).

This valueset definition can then be used within the library wherever a valueset can be used:
~~~
define "Warfarin Rx":
  [MedicationRequest: "Warfarins"] MR
    where MR.authoredOn.value in Interval[Today() - 100 days, null]
~~~
The above statement collects all medication requests having code in `Warfarins` value set and the date when the clinician authored on within 100-day look back period.

For the PDDI-CDS value sets, refer to [Terminology](terminology.html) page for the list of value set used in this implementation guide.

#### Parameters
{:.no_toc}

The parameters defined in a library may be referenced by name in any expression within the library. 
~~~
parameter ContextPrescriptions List<MedicationRequest>
~~~

For PDDI-CDS, the `context` element of CDS Hook request contains the list of Medication Request specified in `medications` element as described in the example below. Those data will be parsed and assigned to the `ContextPrescriptions` parameter defined in the library.
~~~
"context": {
  ...
  "medications": {
    "resourceType": "Bundle",
      "entry": [
        {
          "resource": {
            ... // FHIR MedicationRequest
          }
        }
      ]
    }
  }
}
~~~

This parameter definition can now be referenced anywhere within the CQL library:
~~~
define "NSAID Prescription":
  ContextPrescriptions P
    where Common.ToCode(P.medication.coding[0]) in "NSAIDs"
~~~

#### Context
{:.no_toc}

The context declaration defines the overall context for statements within the library.
~~~
context Patient
~~~

PDDI-CDS uses the `context Patient` declaration to restrict the information that will be returned from a retrieve to a single patient.

#### Statements
{:.no_toc}

`Define` statements describing named expressions that can be referenced either from other expressions within the same library or by containing decision support artifacts.
~~~
define "GI Bleeds Condition":
  Last(
    [Condition: "History of GI Bleeds"] C
      sort by assertedDate.value
  )
~~~
This example defines the `GI Bleeds Condition` statement which get the most recent condition whose code is in the `History of GI Bleeds` valueset.

### <span style="color:silver"> 4.5.2 </span> Connection of CQL to PlanDefinition
{:.no_toc}

#### Library
{:.no_toc}

In PDDI CDS, the Library resource contains the CQL library under base64 format. As an example below, the CQL library is encoded to base64 format and stored by using the Library FHIR resource.

In Library resource, the `relatedArtifact` element defines the dependent relationship between libraries. For example, `warfarin-nsaids-cds` library references to the `PDDICDS_Common` library and that relationship is well described in `relatedArtifact` element.
~~~
{
  "resource": {
    "resourceType": "Library",
    "id": "warfarin-nsaids-cds",
    ...
    "relatedArtifact": [
      {
        "type": "depends-on",
        "resource": {
          "reference": "Library/PDDICDSCommon"
        }
      }
    ],
    "content": [
      {
        "contentType": "application/elm+xml",
        "data": "..." // CQL base64 logic content
      }
    ]
  }
}
~~~

When the Clinical Reasoning module processes the data, the library resource is loaded from local FHIR server and then the logic content in base64 format is decoded. If the content is in `CQL` format, it is tranlated into [ELM XML]() format which is a machine-readable canonical representation.

For the best performance, the CQL logic in CQL format should be translated into ELM XML format before stored in the Library resource and then the Clinical Reasoning module can execute the CQL logic without performing the translation.

#### Plan Definition
{:.no_toc}

In Plan Definition resource, the `library` element defines the reference to the logic used by the Plan Definition. An example for `warfarin-nsaids-cds` Plan Definition resource is the reference to `Library/warfarin-nsaids-cds` Library resource. 
~~~
"library": [
  {
    "reference": "Library/warfarin-nsaids-cds"
  }
],
~~~

This library contains the logic used by the `PlanDefinition` to establish the condition, as well as to dynamically construct the guidance so that it reflects the data for the current patient.

As described in the `condition` element of the section 4.4.1 Plan Definition, the Clinical Reasoning module will load the statement in `condition` element defined in the CQL library, and then that statement will be evaluated by the CQL engine. For example, the `Inclusion Criteria` statement in the library below will be loaded and evaluated to determine whether or not the condition is satisfied.
~~~
define "Inclusion Criteria":
  "Has Warfarin"
    and "Has NSAID in Context Prescription"

define "Has Warfarin":
  exists ("Warfarin Rx")

define "Warfarin Rx":
  [MedicationRequest: "Warfarins"] MR
    where MR.authoredOn.value in Interval[Today() - 100 days, null]

define "Has NSAID in Context Prescription":
  exists ("NSAID Prescription")

define "NSAID Prescription":
  ContextPrescriptions P
    where Common.ToCode(P.medication.coding[0]) in "NSAIDs"
~~~

Similar to `condition` element, `dynamicValue` element within the `action` element allows to customize the card content depending on the logic defined in the library. As an example, the `Get Base Detail` statement below specified in `dynamicValue` element will be evaluated, and the dynamic content containing medication names will be returned.
~~~
define "Get Base Summary":
  'Increased risk of bleeding.'

define "Get Base Detail":
  'Potential Drug-Drug Interaction between warfarin (' 
    + Common.GetMedicationNames("Warfarin Rx") 
    + ') and NSAID (' 
    + Common.GetMedicationNames("NSAID Prescription")
    + ').'

define "Get Base Indicator":
  'warning'
~~~

## <span style="color:silver"> 4.6.0 </span> FHIR Server Request
{:.no_toc}

A FHIR server request by the CDS service after receiving a CDS Hooks request (e.g., `medication-prescribe`) is necessary in the event the `prefetch` element is empty. While the `prefetch` element is OPTIONAL, it MUST NOT be partially fulfilled. In the event the EHR does not provide prefetch data, the PDDI CDS service MUST request the data from the FHIR server via network call. The post-hoc FHIR server query is performed at the parse and pre-process phase shown in Figure 3. To accomplish a FHIR server request, the server URL and the OAuth authorization token (i.e. `fhirServer,` `fhirAuthorization`) MUST be provided in the CDS Hooks request. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Basic – Parse and Pre-process CDS Hooks request </strong></figcaption>
  <img src="assets/images/Basic_Parse_pre-process.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_Parse_pre-process.png" />
</figure>



## <span style="color:silver"> 4.7.0 </span> CDS Hooks Response and Card Display
{:.no_toc}

The CDS service response is a Card array. Each Card has specified attributes that map to the core elements of the minimum information model (`summary` = Drugs Involved). Each Card has a `suggestions` array and each suggestion has an `action` array. The Card `indicator` element dictates how the EHR presents the alert (e.g., `indicator` = "hard-stop" could be a modal alert).

**Example 4: CDS Hooks Response**

~~~
{
  "cards": [
    {
      "summary": "Potential drug-drug interaction between naproxen 500mg tablet and warfarin 5mg tablet",
      "indicator": "hard-stop",
      "detail": "Non-steroidal anti-inflammatory drugs (NSAIDs) have antiplatelet effects which increase the bleeding risk when combined with oral anticoagulants such as warfarin.",
      "source": {
        "label": "Potential Drug-Drug Interaction CDS",
        "suggestions": [
          {
            "label": "Assess risk and take action if necessary",
            "actions": [
              {
                "type": "create",
                "description": "If the NSAID is being used as an analgesic or antipyretic, it would be prudent to use an alternative such as acetaminophen.",
                "resource": {
                  "APAP-order": "MedicationRequest"
                }
              }
            ]
          }
        ]
      }
    },
    {
      "summary": "Patient is taking omeprazole 20mg daily",
      "indicator": "info",
      "detail": "Proton pump inhibitors and misoprostol may reduce the risk of UGIB in patients receiving NSAIDs and warfarin.",
      "source": {
        "label": "Potential Drug-Drug Interaction CDS"
      }
    }
  ]
}

~~~
**Card Display Example**
* [Level 1 – Warfarin + NSAID Cards](documentation.html)

* [Level 1 – Digoxin + Cyclosporine Cards](documentation.html)


# <span style="color:silver"> 5.0.0 </span> Level 2 Implementation


The Level 2 Implementation is a proposed target to optimize PDDI CDS artifacts. It builds on the Level 1 Implementation; however, implementors MUST select either Level 1 or 2 Implementation and NOT both. This section does not provide a comprehensive overview but highlights key deviations from the Level 1 Implementation above. 


Summary of differences between the Level 1 and Level 2 Implementations include:
1. Defining two CDS Hooks triggers in CPOE workflow (i.e., `medication-select` and `medication-prescribe`)
2. Creating a `medication-select` specification 
3. Modify `medication-prescribe` specification
4. Creating Medication Select and Medication Prescribe Services

> *Note:* The Level 1 Medication Prescribe Service MUST NOT be used for the Level 2 Implementation. The Level 2 Implementation requires two separate, *but coordinated,* services for standards' precision, logic flexibility, and to avoid the need  for CDS service state.


## <span style="color:silver"> 5.1.0 </span> Level 2 – CPOE Workflow
{:.no_toc}
Different contextual factors are available and needed at different times during the medication order process (Figure 4). To align clinicians' information needs with PDDI information, the Level 2 Implementation defines two separate hook trigger events in the medication order workflow:

1. Selecting a drug product to include in medication order (`medication-select`)

2. Accepting or signing a single medication order (`medication-prescribe`)


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: CPOE Workflow Example </strong></figcaption>
  <img src="assets/images/CPOE_workflow.png" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow.png" />
</figure>

## <span style="color:silver"> 5.2.0 </span> Level 2 – Summary of Operations
{:.no_toc}
Coordinating the Medication Select Service with the Medication Prescribe Service is a crucial aspect of the Level 2 Implementation. Whether the Medication Prescribe Service is called depends on aspects of the DetectedIssue resource (i.e., `status` element). The DetectedIssue resource is created by the Medication Select Service and populated by clinician actions in response the displayed Cards. Figure 5 depicts the summary of operations that coordinates the Medication Select and Medication Prescribe Services.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: Advanced – PDDI CDS Service Summary </strong></figcaption>
  <img src="assets/images/Advanced_Summary.png" class="figure-img img-responsive img-rounded center-block" alt="Advanced_Summary.png" />
</figure>

## <span style="color:silver"> 5.3.0 </span> CDS Hooks
{:.no_toc}



### <span style="color:silver"> 5.3.1 </span> Level 2 – CDS Service Discovery response example
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

### <span style="color:silver"> 5.3.2 </span> Level 2 – CDS Hooks Request
{:.no_toc}

The Level 2 Implementation specifies the use of both the `medication-select` and `medication-prescribe` CDS Hooks during a single medication order task. In addition to creating a `medication-select` request (currently not a part of the CDS Hooks standard), the `mediction-prescribe` `context` is modified to include elements of the DetectedIssue resource. 


#### Context
{:.no_toc}

The `context` element of the `medication-select` CDS Hooks request is identical to the current `medication-prescribe` specification used in the Level 1 Implementation. The `context` element in the Level 2 Implementation `medication-prescribe` element has a minor modification to include the DetectedIssue resource. The DetectedIssue.id indicates the PDDI that was identified by the Medication Select Service (e.g., `id : "warfarin-NSAID1234"`). For details on the specifications are below.


#### **`medication-select` 1.0** (new CDS Hook)
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | :----: | ----
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient 
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter
`medication`| REQUIRED | No | *object* | STU3 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task

#### **`medication-prescribe` 1.1** (modification of a current CDS Hook)
 {:.no_toc}
 The version for the `medication-prescribe` hook is 1.0. The Advanced PDDI CDS implementation requires an additional context field. This modification is considered Minor but will change the version to 1.1.


 Field       | Optionality        |  Prefetch Token     |Type  | Description 
 :------------- |:-------------:|:-------: |:-----:| :-----------------
 `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context 
 `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context 
 `detectedissue` | REQUIRED     | Yes |    *object* | STU3 - FHIR Bundle of DetectedIssue resource for current order entry task
 `medication` | REQUIRED     | No |    *object* | STU3 - FHIR Bundle of draft MedicationRequest resource for the current order entry task


#### Prefetch
{:.no_toc}
Since the order entry task is split into two separate CDS Hooks events (i.e., services), the prefetch template for the Medication Select Service includes only medication resources. The prefetch template for the Medication Prescribe Service includes any additional resources needed for a specific PDDI after accounting for clinician action(s). 

##### Example CDS Hooks Requests
{:.no_toc}

* [Request test data](testdata.html)


## <span style="color:silver"> 5.4.0 </span> DetectedIssue 
{:.no_toc}

As previously discussed, a DetectedIssue resource is created in both implementations. The Level 2 Implementation, however, uses the DetectedIssue to carry clinician-action state through order entry process. The the `context` element of the `medication-prescribe` request contains the DetectedIssue resource. During the parse and pre-process phase, the service determines if the ordered medication is the same as the DetectedIssue medication, and if prefetch is needed for additional processing. The ordered medication is compared to the DetectedIssue medication either by the `DetectedIssue.id,` which is a Persistent Uniform Resource Locator (PURL) or through the `DetectedIssue.implicated` reference to conflicting medications. This is to ensure the clinician action did not eliminate the PDDI (e.g., change naproxen to acetaminophen). The DetectedIssue `status` element is instantiated by the Medication Select Service and indicates to the EHR if prefetch data are available or needed. If the status value is "final", the EHR and the CDS service MUST NOT retrieve prefetch data. If the `status` is "preliminary", the EHR MAY fulfill the prefetch queries or the CDS service MUST retrieve prefetch.


## <span style="color:silver"> 5.5.0 </span> Level 2 – FHIR Server Request
{:.no_toc}
The parse and pre-process event for `medication-select` requests in the Level 2 Implementation is identical to what occurs with `medication-prescribe` for the Level 1 Implementation. Processing of `medication-prescribe` by the Level 2 Implementation service is slightly different (Figure 6). During the parse and pre-process phase the CDS service checks the medication that was finally ordered against the `detectedissueID` field. This is to confirm that the prescriber continued with the conflicting order after having the option to change the medication in response to the previously sent CDS Hook `card` suggestions. In addition, the `DetectedIssue` `status` field indicates to the CDS service if additional prefetch data is needed for the specific PDDI.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 6: Level 2 – Parse and Pre-process for Medication Prescribe Service </strong></figcaption>
  <img src="assets/images/Parse_pre-process_prescribe.png" class="figure-img img-responsive img-rounded center-block" alt="Parse_pre-process_prescribe.png" />
</figure>



## <span style="color:silver"> 5.6.0 </span> Level 2 – Hooks Response and Card Display
{:.no_toc}

**Example: Level 2 – CDS Hooks Response**
~~~
{
  "cards": [
    {
      "summary": "Potential drug-drug interaction between naproxen 500mg tablet and warfarin 5mg tablet",
      "indicator": "hard-stop",
      "detail": "Non-steroidal anti-inflammatory drugs (NSAIDs) have antiplatelet effects which increase the bleeding risk when combined with oral anticoagulants such as warfarin.",
      "detectedIssue" : {
        "resourceType": "DetectedIssue",
        "id": "Warfarin-NSAID-1234",
        "status": "preliminary",
        "category": {
          "coding": [
            {
              "system": "http://hl7.org/fhir/v3/ActCode",
              "code": "DRG",
              "display": "Drug Interaction Alert"
            }
          ]
        },
snipped for brevity        
~~~

**Card Display Example**
* [Level 2 – Warfarin + NSAID Cards](documentation.html)

* [Level 2 – Digoxin + Cyclosporin Cards](documentation.html)



