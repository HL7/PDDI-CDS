
# <span style="color:silver"> 3.0.0 </span> CDS Service Specification 

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}


### <span style="color:silver"> 3.0.1 </span>Summary of Normative Recommendations
{:.no_toc}

* PDDI CDS knowledge artifacts. It is RECOMMENDED that the knowledge artifacts adhere to the 8 detailed best practice recommendations related to the 10 core information items discussed in the Community Group Note titled [Minimum Representation of Potential Drug-Drug Interaction Knowledge and Evidence](https://dbmi-icode-01.dbmi.pitt.edu/dikb-evidence/hcls-drug-drug-interaction/index.html).

* A CDS rule execution engine. It is RECOMMENDED that it be able to execute CDS rules written in [CQL](http://www.hl7.org/implement/standards/product_brief.cfm?product_id=400) and represented as a [FHIR Library](http://build.fhir.org/library.html) resource, either directly or compiled to HL7 [Expression Logical Model](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md).


## <span style="color:silver"> 3.1.0 </span> Preliminaries 

This section contains documentation on how to implement PDDI CDS artifacts from a clinical and technical perspective. Later sections describe implementation details using two specific knowledge artifacts as examples. Structured artifacts that implement the logic and behavior described below are available under [Artifacts](artifacts.html).


# <span style="color:silver"> 3.1.1 </span> Getting Started with PDDI CDS
The words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, AND OPTIONAL are used as defined [*"Key words for use in RFCs to Indicate Requirement Levels".*](https://tools.ietf.org/html/rfc2119) S. Bradner. IETF. March 1997. Best Current Practice.


## <span style="color:silver"> 3.1.2 </span> What You Will Need

* A web service that processes CDS requests using a CDS rule execution engine. The service MUST be able to process CDS Hooks requests and return CDS Hooks Card responses.

* A web service that processes CDS requests MUST be able to process FHIR data including clinical and terminology resources. 

* The EHR system that sends requests to the service MAY provide access to the service to relevant patient data in the EHR via a FHIR server. EHR systems that do not provide access to addition patient data will potentially receive more limited CDS because the service will only work with data in the `context` and `prefetch` fields of CDS Hooks requests.

* Here is a list of FHIR tools that might be of interest to implementers:

	* [Public](http://wiki.hl7.org/index.php?title=Publicly_Available_FHIR_Servers_for_testing) 
    
	* Local (preferred)

	    * [HAPI RESTful Server](http://hapifhir.io/doc_rest_server.html)

		* [HAPI JPA Server](http://hapifhir.io/doc_jpa.html)

		* [HAPI JAX-RS Server](http://hapifhir.io/doc_rest_server_jaxrs.html)

		* [.NET Server](https://github.com/ewoutkramer/fhir-net-api)
			


## <span style="color:silver"> 3.1.3 </span> CDS Function

To invoke the PDDI CDS service, the EHR needs to send a CDS Hooks request at a pre-specified step the workflow process. The CDS service then parses and processes the request to determine if the prescribed medication conflicts with a medication the patient is presumably taking. If this condition is satisfied, the CDS service provides individualized information based on the PDDI knowledge base. 

The EHR MAY combine several methods to satisfy prefetch templates. For more information see the Documentation section, [Prefetch Role](documentation.html).

Each implementation may employ a slightly different approach to ensure successful integration of the CDS system. Here are several general aspects to assess:

* A technical framework for the EHR to interact with the CDS service by

    * creating and sending CDS Hooks requests

    * capturing and presenting CDS Hooks responses
    
    * capturing, processing, modifying, and storing a `DetectedIssue` resource

* Terminology mapping (e.g., RxNorm, LOINC)

* Building FHIR resources

* SMART authentication and FHIR server requests


## <span style="color:silver"> 3.1.4 </span> CPOE Workflow Hooks 
{:.no_toc}

Figure 1 depicts hook triggers for Level 1 and 2 Implementations. The Level 1 Implementation follows the [CDS Hooks `order-sign`](https://cds-hooks.org/hooks/order-sign/) specification that defines the triggering event as when a clinician is ready to sign one or more medication orders for a patient. This hook is among the last workflow events before an order is promoted out of a draft status. The primary difference in the Level 2 Implementation is the additional `order-select` hook defining the initial trigger at the start of the CPOE workflow. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Level 1 versus Level 2 Implementation Hooks </strong></figcaption>
  <a href = "assets/images/CPOE_workflow_2.svg" target ="_blank" > <img src= "assets/images/CPOE_workflow_2.svg" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow_2.svg" /></a>
</figure>

## <span style="color:silver"> 3.1.5 </span> Prefetch Role 
{:.no_toc}

For technical implementers, the intended role of prefetch is to improve the CDS service performance. This is achieved by minimizing CDS service network calls to external resources such as a FHIR server. When a client program subscribes to the PDDI CDS service, the service MUST return a prefetch specification in the response. This specification identifies resources that the PDDI CDS service SHOULD receive upon request. As described below, the prefetch requirements are different for `order-select` and `order-sign` services. The ideal scenario for both implementations and services is to send prefetch data with the CDS Hooks request. The implementor has flexibility on when and how to fulfill the prefetch templates (e.g., data in EHR memory or server call), which will likely result in a solution that reduces the burden of the server and improves the CDS service efficiency. If the CDS service does not receive prefetch data in the request it MUST query the server via network call. 


## <span style="color:silver"> 3.1.6 </span> Level 1 versus Level 2 Implementations

The primary difference between Level 1 and Level 2 Implementations is the addition of a second hook during the order entry task. From a clinical and technical perspective, this sets the Level 2 Implementation apart from most conventional CDS systems that trigger PDDI CDS at the time of order signing. In Level 2, PDDI CDS is moved up to earlier in the order entry workflow, providing clinicians with actionable information in the middle of their decision making process. We think that providing information at this stage presents less of a cognitive burden on the clinician and will lead to more effective PDDI CDS. 

In order for PDDI CDS to be both sensitive and specific, different contextual factors are sent to the CDS service depending order entry workflow step the clinician is engaged in.  At the time of medication selection, a `order-select` CDS Hook sends medication resources to the CDS service. Later, at the time of order signing, a `order-sign` CDS Hook sends other contextual resources specific to a PDDI identified from processing `order-select`. This might include retrospective patient conditions, lab measurements, and other information. One potential advantage of this approach is a reduction the amount of information needed to provide actionable PDDI information to the clinician. The approach might also limit the amount of information the EHR has to provide for an order entry task. For example, if a clinician starts an NSAID order for a patient that was taking warfarin and decides to discontinue the order based on the presented cards, the clinician only needs to read and process medication factors, and the EHR would not display additional patient resources such as age and history of upper gastrointestinal bleed. In Level 2, the `DetectedIssue` resource stores crucial information on clinician action that facilitates monitoring PDDIs and improving actionable suggestions. Moreover, creating a `DetectedIssue` resource that contains clinician responses gives control to the clinician on what, if any, additional patient-specific information is presented. For example, if a clinician decides to continue with the NSAID prescription but adds a proton pump inhibitor (risk mitigating action), the CDS Service for `order-sign` would adjust the indicator from "hard-stop" (interruptive) to "warning" (passive). Table 1 provides a summary of the specification and feature differences between the levels of implementation.
 


#### Table 1: Specification and Feature Comparision between Level 1 and 2 Implementations
{:.no_toc}

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Base Specifications | Level-1 | Level-2 
----- | :--------: | :----: | :----: 
**Specifications** | |  |   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`order-sign 1.0` | **X** | **X** |  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`order-select 1.0`|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DetectedIssue` resource | **X** | **X** | **X** 
**Features** |  |  | 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DetectedIssue` potentiation element |  | **X** | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Card response extension for `DetectedIssue`|  | **X** | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clinician action documentation|  | **X** | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sequential clinician action documentation|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Clinician response alert filtering|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Minimized alert presentation|  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Minimized data query |  |  | **X** 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Scalable framework for contextual factors |  |  | **X** 

# <span style="color:silver"> 3.1.7 </span> Process 
This section provides an overview of the processes and components of the PDDI CDS. It is delineated by Level 1 and Level 2 Implementation sections. The Level 1 Implementation describes the technology specifications, and what structured code is available in this implementation guide. The Level 2 Implementation is a target for future iterations to optimize the CDS artifacts. Details regarding the knowledge artifacts and decision points for the individual artifacts can be found in the [Documentation](documentation.html) section.

## <span style="color:silver"> 3.1.8 </span> CDS Discovery
{:.no_toc}

Prior to a hook trigger and subsequent processes, the EHR MUST initiate a CDS Discovery (Figure 1). CDS Discovery is to identify CDS services and obtain associated prefetch templates. A prefetch template is a dictionary of read and search requests for needed resources of a particular service. The PDDI CDS service MAY provide a prefetch template for each service, and the EHR SHOULD populate prefetch templates with relevant patient data for the anticipated CDS Hook request.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: CDS Service Discovery </strong></figcaption>
  <img src="assets/images/Discover_CDS_Service.svg" class="figure-img img-responsive img-rounded center-block" alt="Discover_CDS_Service.svg" />
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
      "hook": "order-sign",
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



# <span style="color:silver"> 3.1.10 </span> Level 1 Implementation

The Level 1 Implementation uses the `order-sign 1.0`. The CDS Hooks specification states that `order-sign 1.0` fires when a clinician is ready to sign one or more orders for a patient, (including orders for medications, procedures, labs and other orders). This hook is among the last workflow events before an order is promoted out of a draft status. The context contains all order details, such as dose, quantity, route, etc, although the order has not yet been signed and therefore still exists in a draft status. Use this hook when your service requires all order details, and the clinician will accept recommended changes. Since EHR platforms may have different discrete steps in the order entry process, the implementor decides what action (e.g., selecting a medication product, accepting order completion) triggers the CDS Hooks request.  

Specific CDS Hooks and FHIR standards modifications REQUIRED for Level 1 Implementation:

1. A CDS Hooks Card extension so that a `DetectedIssue` resource can be included in a Card response

2. A `DetectedIssue` resource extension to add the `potentiation` element 

## <span style="color:silver"> 3.1.11 </span> Summary of Operations
{:.no_toc}

The process for a unique instance of PDDI CDS begins with the user triggering a CDS Hooks request (i.e., `order-sign`) and ends with the user's action in response to the Card response suggestion(s) (Figure 2). The parse and pre-process subprocess is to determine if a FHIR server query needed. The Clinical Reasoning module evaluates the complete request and creates information to send back the the EHR. The event subprocesses may occur in response to a specific instance (i.e., SMART authorization and FHIR access) or asynchronous of the specific instance (i.e., CDS Discovery). 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Level 1 – Order Sign Service Summary </strong></figcaption>
  <img src="assets/images/Basic_Order_Sign_service.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Order_Sign_service.svg" />
</figure>



## <span style="color:silver"> 3.1.12 </span> CDS Hooks
{:.no_toc}

The PDDI CDS artifacts use the HL7 CDS Hooks specification [1.0](http://cds-hooks.org/specification/1.0/).  The CDS Hooks standard defines the data structure to facilitate communication between the EHR and the CDS service through a RESTful API request and response. This allows patient data to be sent and received by the EHR at intervals that better align with clinical workflows – further leveraging FHIR and SMART applications at the point of care. CDS Hooks instances include CDS Discovery, EHR requests and CDS service response. The `context` and `prefetch` are two key elements of the CDS Hook request that contain patient information. The `context` element contains data that is task and hook-specific. The `prefetch` element contains patient-specific information that is relevant to the `context` data and the invoked CDS service. The CDS Hooks response is a set of Cards. The Cards contain general information, suggested actions, and display indicators in a structured format for the EHR to process and display. The CDS Discovery of the CDS Hooks specification delineates information that the CDS service is to provide to the EHR.

> *Note:* The [HL7 specification for decision support](http://www.hl7.org/implement/standards/product_brief.cfm?product_id=334) does not require that the CDS service process CDS Hooks. This implementation guide requires their use because CDS Hooks should provide simplicity and specific orientation for CPOE workflow integration.



### <span style="color:silver"> 3.1.13 </span> CDS Hooks Request 
{:.no_toc}

The EHR MUST call the PDDI CDS service by sending an HTTP `POST` containing `JSON` to the service endpoint (e.g.,`http://FHIR.org/PDDI-CDS/warfarin-nsaids-cds`). The JSON (CDS Hooks request) MUST contain specified information for the hook that was triggered, FHIR server, user, context, and prefetch.

##### Context
{:.no_toc}

The `context` element of a CDS Hooks request contains contextual data for the current task and is specified below. For example, the `order-sign` hook specifies the `context` MUST include the medication product (i.e., `medication` element of the MedicationRequest resource) of the order in process. 

**`order-sign` 1.0.**


Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | ---- | ----
`userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient in context
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter in context
`draftOrders`| REQUIRED | No | *object* | R4 - FHIR `MedicationRequest` resource

##### Prefetch
{:.no_toc}

The `prefetch` element contains patient data that is provided by the EHR upon submission of the CDS Hook to the CDS service. The CDS service MUST provide the EHR with a prefetch template at the time of service discovery. The `prefetch` element MAY specify patient data other than medications for the purpose of individualizing the CDS logic and response. The prefetch query MUST be designed to obtain data for the patient indicated by the context `patientID`. The CDS service SHOULD then compare the `context` medication to the patient's current medications in the `prefetch` element. 

> *Note:* For simplicity, this implementation guide uses the term "prefetch" regardless of whether the EHR supplies the data prior to a hook request or if it is queried by the CDS service as a post-hoc FHIR server request.

##### CDS Hooks Request Example
{:.no_toc}

* [Request test data](testdata.html)

##### Bundle 
{:.no_toc}

A `Bundle` is a FHIR resource that groups resources into a single instance, which is ideal for messaging with CDS Hooks, storing a collection of resources obtained on CDS Discovery, and providing flexibility in using the collections as a persistent instance. PDDI CDS implementors MUST use the bundle resource for certain `context` elements and all `prefetch` resources. For each prefetch template query, a `Bundle` MUST be created to group the resources. A prefetch element MAY contain several `Bundle` resources with several other resources grouped within.


## <span style="color:silver"> 3.1.14 </span> FHIR Server Request
{:.no_toc}

A FHIR server request by the CDS service is necessary in the event the request `prefetch` element is empty. While the `prefetch` element is OPTIONAL, it MUST NOT be partially fulfilled. The post-hoc FHIR server query is performed at the parse and pre-process phase shown in Figure 3. To accomplish a FHIR server request, the server URL and the OAuth authorization token (i.e. `fhirServer,` `fhirAuthorization`) MUST be provided in the CDS Hooks request. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Basic – Parse and Pre-process CDS Hooks request </strong></figcaption>
  <img src="assets/images/Basic_Parse_pre-process.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Parse_pre-process.svg" />
</figure>



## <span style="color:silver"> 3.1.15 </span> CDS Hooks Response and Card Display
{:.no_toc}

The CDS service response is a Card array. Each Card has specified attributes that map to the core elements of the minimum information model (e.g.,`summary` = Drugs Involved). Each Card has a `suggestions` array and each suggestion has an `action` array. The Card `indicator` element dictates how the EHR presents the alert (e.g., `indicator` = "hard-stop" could be a modal alert).

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
 snipped for brevity
~~~

**Card Display Example**

* [Level 1 – Warfarin + NSAID Cards](documentation.html)

* [Level 1 – Digoxin + Cyclosporine Cards](documentation.html)


# <span style="color:silver"> 3.1.16 </span> Level 2 Implementation


The Level 2 Implementation is a proposed target to optimize PDDI CDS artifacts. It builds on the Level 1 Implementation; however, implementors MUST select either Level 1 or 2 Implementation and *not* both. This section does not provide a comprehensive overview of the implementation but highlights deviations from the Level 1 Implementation above. 


Differences between the Level 1 and Level 2 Implementations include:

1. Defining two CDS Hooks triggers in CPOE workflow (i.e., `order-select` and `order-sign`)

2. Creating a `order-select` specification 

3. Modify `order-sign` specification

4. Creating separate but coordinated Order Select and Order Sign Services

> *Note:* The Level 2 Implementation requires two separate, but *coordinated,* services for standards' precision, logic flexibility, and to avoid the need for CDS service state.


## <span style="color:silver"> 3.1.17 </span> Level 2 – CPOE Workflow
{:.no_toc}

Different contextual factors are available and needed at different times during the medication order process (Figure 4). To align clinicians' information needs with PDDI information, the Level 2 Implementation *defines* two separate hook trigger events in the medication order workflow:

1. Selecting a drug product to include in medication order (`order-select`)

2. Accepting or signing a single medication order (`order-sign`)


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: CPOE Workflow Example </strong></figcaption>
  <img src="assets/images/CPOE_workflow.svg" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow.svg" />
</figure>

## <span style="color:silver"> 3.1.18 </span> Level 2 – Summary of Operations
{:.no_toc}

Coordinating the Order Select Service with the Order Sign Service is a key aspect of the Level 2 Implementation. Whether the Order Sign Service is called depends on aspects of the DetectedIssue resource (i.e., `status` element). The DetectedIssue resource is created by the Order Select Service and populated by clinician actions in response to the displayed Cards. Figure 5 depicts the summary of operations that coordinates the Order Select and Order Sign Services.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: Advanced – PDDI CDS Service Summary </strong></figcaption>
  <img src="assets/images/Advanced_Summary.svg" class="figure-img img-responsive img-rounded center-block" alt="Advanced_Summary.svg" />
</figure>

## <span style="color:silver"> 3.1.19 </span> CDS Hooks
{:.no_toc}



### <span style="color:silver"> 3.1.20 </span> Level 2 – CDS Service Discovery response example
{:.no_toc}

~~~
{
"services": [
  {
    "hook": "order-select",
    "title": "PDDI CDS Service",
    "description": "CDS Service for drug-drug interactions",
    "id": "PDDI-CDS-order-select",
    "prefetch": {
      "medications_stated": "MedicationStatement?patient/{{context.patientId}}/query parameters"
      "medications_dispensed" : "MedicationDispense?patient/{{context.patientId}}/query parameters"
      "medications_administered" : "MedicationAdminister?patient/{{context.patientId}}/query parameters"
      "medications_prescribed" : "MedicationRequest?patient/{{context.patientId}}/query parameters"
    }
  },
  {
    "hook": "order-sign",
    "title": "PDDI CDS Service",
    "description": "CDS Service for drug-drug interactions",
    "id": "PDDI-CDS-order-sign",
    "prefetch": {
      "drug_drug_interaction": "DetectedIssue/{{context.detectedissueId}}/query parameters"
      "observations": "Observation?detectedissue/{{context.detectedissueId}}/query parameters"
      "conditions": "Condition?detectedissue/{{context.detectedissueId}}/query parameters"
    }
  }
 ]
}
~~~

### <span style="color:silver"> 3.1.22 </span> Level 2 – CDS Hooks Request
{:.no_toc}

The Level 2 Implementation specifies the use of both the `order-select` and `order-sign` CDS Hooks during a single medication order task. In addition to creating a `order-select` hook, the `mediction-prescribe` `context` is modified to include the DetectedIssue resource. 


#### Context
{:.no_toc}

The `context` element of the `order-select` CDS Hooks request is identical to the `order-sign` specification used in the Level 1 Implementation. The `context` element in the Level 2 Implementation `order-sign` element has a minor modification to include the DetectedIssue resource. The DetectedIssue.id indicates the PDDI that was identified by the Order Select Service (e.g., `id : "warfarin-NSAID1234"`). For details on the specifications are below.


#### **`order-select` 1.0** 
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | :----: | ----
`userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient 
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter
`selections`  | REQUIRED | No | *array* | The FHIR id of the newly selected order(s). The `selections` field references FHIR resources in the `draftOrders` Bundle. For example, `MedicationRequest/103`.
`draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


#### **`order-sign` 1.1** (modification of a current CDS Hook)
 {:.no_toc}
 The base version for the `order-sign` hook is 1.0. The Level 2 Implementation requires an additional context field. This modification is considered Minor but will change the version to 1.1.


 Field       | Optionality        |  Prefetch Token     |Type  | Description 
 :------------- |:-------------:|:-------: |:-----:| :-----------------
 `userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
 `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context 
 `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context 
 `detectedissue` | REQUIRED     | Yes |    *object* | R4 - FHIR Bundle of DetectedIssue resource for current order entry task
 `draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


#### Prefetch
{:.no_toc}

Since the order entry task is split into two separate CDS Hooks events (i.e., services), the prefetch template for the Order Select Service includes only medication resources. The prefetch template for the Order Sign Service includes any additional resources needed for a specific PDDI *after* accounting for clinician action(s). 

##### CDS Hooks Request Example
{:.no_toc}

* [Request test data](testdata.html)


## <span style="color:silver"> 3.1.23 </span> Level 2 – DetectedIssue 
{:.no_toc}

As previously discussed, a DetectedIssue resource is created in both implementations. The Level 2 Implementation, however, uses the DetectedIssue to carry clinician-action state through order entry process. The the `context` element of the `order-sign` request contains the DetectedIssue resource. During the parse and pre-process phase, the service determines if the ordered medication is the same as the DetectedIssue medication, and if prefetch data is needed for additional processing. The ordered medication is compared to the DetectedIssue medication either by the `DetectedIssue.id,` which is a Persistent Uniform Resource Locator (PURL) or through the `DetectedIssue.implicated` reference to conflicting medications. This is to ensure the clinician action did not eliminate the PDDI (e.g., change naproxen to acetaminophen). The DetectedIssue `status` element is instantiated by the Order Select Service and indicates to the EHR if prefetch data are available or needed. If the `status` value is "final", the EHR and the CDS service MUST NOT retrieve prefetch data. If the `status` is "preliminary", the EHR MAY fulfill the prefetch queries or the CDS service MUST retrieve prefetch data from the FHIR server.


## <span style="color:silver"> 3.1.24 </span> Level 2 – FHIR Server Request
{:.no_toc}

The parse and pre-process event for a `order-select` request in the Level 2 Implementation is identical to what occurs with `order-sign` for the Level 1 Implementation. Processing of `order-sign` for the Level 2 Implementation service is slightly different. During the parse and pre-process phase the CDS service checks the medication that was finally ordered against the DetectedIssue resource (Figure 6). This is to confirm that the prescriber continued with the conflicting order after having the option to change the medication in response to the CDS Hooks Cards. In addition, the DetectedIssue `status` field indicates to the CDS service if additional prefetch data is needed for the specific PDDI.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 6: Level 2 – Parse and Pre-process for Order Sign Service </strong></figcaption>
  <img src="assets/images/Parse_pre-process_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Parse_pre-process_prescribe.svg" />
</figure>



## <span style="color:silver"> 3.1.25 </span> Level 2 – CDS Hooks Response and Card Display
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



## <span style="color:silver"> 3.2.0 </span> Level 1 Implementation for the Warfarin + NSAIDs Knowledge Artifact

Figure 2 depicts how a PDDI CDS implementer would translate a minimum information model narrative to a semi-structured knowledge artifact. The Level 1 Implementation uses a single CDS service call and response with the `order-sign` hook. The decision tree results in three warning indicators (i.e., green, orange, red) and contextual factors that MAY be passed to the clinician.  After processing the CDS Hooks `order-sign` request, the CDS service MUST return CDS Hooks Cards that MAY include actions with associated FHIR resources. Figure 3 builds on Figure 2 by depicting a Card display example within the order entry workflow. The decision points, `order-sign` request, and Card(s) response are discussed further in the sections below.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Level 1 – Warfarin + NSAID Semi-Structured Knowledge </strong></figcaption>
  <a href = "assets/images/Basic_Warfarin_NSAID.svg" target ="_blank" > <img src= "assets/images/Basic_Warfarin_NSAID.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Warfarin_NSAID.svg" /></a>
</figure>

### <span style="color:silver"> 3.2.1 </span> Decision Points Summary
{:.no_toc}

Many PDDI CDS scenarios have similar drug and patient related decision points. Implementers SHOULD develop CQL artifacts that work in conjunction with the `order-sign` context and prefetch to support the base decision points. The Warfarin + NSAIDs PDDI exemplar as three main decision blocks that include:

1. whether the prescribed NSAID is topical diclofenac,

2. whether the patient is taking a proton pump inhibitor, and 

3. the presence or absence of risk factors involving age, exacerbating medications, and history of upper gastrointestinal bleed


### <span style="color:silver"> 3.2.2 </span> CDS Hooks Request
{:.no_toc}

The `order-sign` request includes `context` and `prefetch` elements with FHIR resource attributes or entire resources. The contents of these elements for the Warfarin + NSAIDs CDS artifact are shown below.

#### `context`
{:.no_toc}

* [`order-sign 1.0`](https://cds-hooks.org/hooks/order-sign/) 

#### `prefetch` 
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
	* [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
	* [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
	* [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
	* [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

> *Note:* The use of multiple medication resources is to ensure a comprehensive capture of medications the patient may be taking. In some cases the implementing institution may only have access to MedicationRequest (prescription order), and in other cases they may have access to several resources for a specific medication intervention (e.g., prescription order from medical office, prescription product picked up from pharmacy). The 100-day look-back period is a general starting point. Implementors SHOULD refine this based on the available data. For example, MedicationAdministration is typically documented in the inpatient setting when a nurse administers a medication. This data source may be a more reliable proxy for blood concentrations and could be used to refine CDS logic. 

* Age of patient on current date.
    * [Patient](https://www.hl7.org/fhir/patient.html)
    
* Rolling 5-year look-back period for history of upper gastrointestinal bleed.
    * [Condition](https://www.hl7.org/fhir/condition.html)
    

### <span style="color:silver"> 3.2.3 </span> CDS Hooks Cards
{:.no_toc}


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Level 1 – Warfarin + NSAID Response Card Example </strong></figcaption>
  <a href = "assets/images/Basic_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Basic_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_W_N_Cards.svg" /></a>
</figure>


### <span style="color:silver"> 3.2.4 </span> Card Actions
{:.no_toc}

The CDS Hooks service response supports providing actionable information to clinicians at the time of medication order entry. A response Card has an `action` element within the suggestion attribute. The `action` element is defined by three types including `create, update, and delete.` Depending on the type of action, resources may be provided that facilitate the suggestion. For example, if a suggestion recommends substituting naproxen for acetaminophen, a `create` action may be used to apply a MedicationRequest for acetaminophen to the current order entry task. The actions, types and associated resources are listed below.  

* `create` 
    * Substituting NSAID for acetaminophen – MedicationRequest for acetaminophen 
    * Adding proton pump inhibitor – MedicationRequest for proton pump inhibitor
* `update` 
* `delete`
    * Remove current NSAID order 

> *Note:* These actions are options that SHOULD be customized to an institutions needs and capabilities. 

## <span style="color:silver"> 3.3.0 </span> Level 2 Implementation - Warfarin + NSAIDs Knowledge Artifact

The Level 2 Implementation for the Warfarin + NSAID artifact is split into two separate hooks and services. Figures 4 and 5 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both Hooks (i.e., `order-select` and `order-sign`). Figure 6 provides a Card display example for each CDS Hooks instance within the order entry workflow. In the provided Card display example, the clinician decided to order the NSAID medication but adds a proton pump inhibitor, in response to the card suggestion. This action results in a downgrade of the `medication-presecribe` response card (i.e., "hard-stop" – red to "warning" – orange). The blue task boxes highlight the DetectedIssue `status` indicator, which informs the EHR  of additional needed resources (whether or not to fulfill the `order-sign` service prefetch template), and `order-sign` service if it needs to perform a FHIR server request in the event prefetch data are not provided in the request.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: Warfarin + NSAID order-select logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_select.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_select.svg" /></a>
</figure>




<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: Warfarin + NSAID order-sign logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_prescribe.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_prescribe.svg" /></a>
</figure>


### <span style="color:silver"> 3.3.1 </span> CDS Hooks request
{:.no_toc}


#### `context`
{:.no_toc}

#### **`order-select` 1.0** 
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | :----: | ----
`userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient 
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter
`selections`  | REQUIRED | No | *array* | The FHIR id of the newly selected order(s). The `selections` field references FHIR resources in the `draftOrders` Bundle. For example, `MedicationRequest/103`.
`draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


#### **`order-sign` 1.1** (modification of a current CDS Hook)
 {:.no_toc}
 The base version for the `order-sign` hook is 1.0. The Level 2 Implementation requires an additional context field. This modification is considered Minor but will change the version to 1.1.


 Field       | Optionality        |  Prefetch Token     |Type  | Description 
 :------------- |:-------------:|:-------: |:-----:| :-----------------
 `userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
 `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context 
 `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context 
 `detectedissue` | REQUIRED     | Yes |    *object* | R4 - FHIR Bundle of DetectedIssue resource for current order entry task
 `draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


##### `order-select` `prefetch`
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

##### `order-sign` `prefetch`
{:.no_toc}

* Age of patient on current date.
    * [Patient](https://www.hl7.org/fhir/patient.html)
    
* Rolling 5-year look-back period for history of upper gastrointestinal bleed.
    * [Condition](https://www.hl7.org/fhir/condition.html)
    

### <span style="color:silver"> 3.3.2 </span> CDS Hooks Cards
{:.no_toc}


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 6: Warfarin + NSAID Cards </strong></figcaption>
  <a href = "assets/images/Advanced_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Advanced_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Advanced_W_N_Cards.svg" /></a>
</figure>


## <span style="color:silver"> 3.4.0 </span> Level 1 Implementation - Digoxin + Cyclosporine Knowledge Artifact


The Digoxin + Cyclosporine artifact logic depends on whether the patient is stable on digoxin or cyclosporine before the current medication order event. This section defines terms used in the subsequent flow diagrams. Certain terms are defined by assumptions that may be taken based on the presence of resources in `context` versus `prefetch` elements of the request. 


* **Incident Order** – `context` medication is *not* in `prefetch` medications and, thus, is presumably the first occurrence. 

* **Prevalent Order** – `context` medication is in `prefetch` medications and, thus, is presumably a medication order that is continued or repeated.

* **Normal** – observation that is within a specified time period, and the measure is within a therapeutic window or below/above a certain acceptable threshold.

* **Abnormal** – observation that is *not* within a specified time period, *or* the measure is *not* within a therapeutic window or below/above a certain threshold.

> *Note:* Parameters for "normal" and "abnormal" observations SHOULD be modified by the implementor. The provided artifacts use a simplistic approach of querying for the most recent measure in a specific time frame. This approach SHOULD be modified to capture and present the most clinically relevant information. For example, clinicians may want a look-back period that captures several measures for serum creatinine to determine the status *and* prognosis for renal insufficiency. 


Figure 7 shows how a PDDI CDS implementer would implement the Digoxin + Cyclosporine PDDI knowledge artifact using the CDS Hooks `order-sign` hook. The figure shows the CDS Service processes the PDDI CDS logic after receiving a `order-sign` request. Figure 7 progresses through the decision tree and includes warning indicators (i.e., green, orange, red) and contextual factors that may be presented to the clinician. Figure 8 builds on this artifact and provides a display of Cards example. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 7: Level 1 Digoxin + Cyclosporine logic </strong></figcaption>
  <a href = "assets/images/Basic_Digoxin_Cyclosporine.svg" target ="_blank" > <img src="assets/images/Basic_Digoxin_Cyclosporine.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Digoxin_Cyclosporine.svg" /></a>
</figure>


### <span style="color:silver"> 3.4.1 </span> Decision Points Summary
{:.no_toc}

The Digoxin + Cyclosporine exemplar artifact has two main decision blocks:

1. whether the patient is taking digoxin and/or cyclosporine at the time of the current order for digoxin or cyclosporine, and

2. whether the patient has risk factors that may potentiate the risk of digitalis toxicity. 

### <span style="color:silver"> 3.4.2 </span> CDS Hooks Request
{:.no_toc}


#### `context`
{:.no_toc}

* [`order-sign 1.0`](https://cds-hooks.org/hooks/order-sign/) 

#### `prefetch`
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)
    
* Rolling 100-day look-back period for digoxin concentration
    * [Observation](https://www.hl7.org/fhir/observation.html)

* Rolling 100-day look-back period for serum creatinine
    * [Observation](https://www.hl7.org/fhir/observation.html)
    
* Rolling 100-day look-back period for electrolytes including: potassium, magnesium, and calcium
    * [Observation](https://www.hl7.org/fhir/observation.html)
        

### <span style="color:silver"> 3.4.3 </span> CDS Hooks Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 8: Level 1 Digoxin + Cyclosporine Cards </strong></figcaption>
  <a href = "assets/images/Level_1_D_C_Cards.svg" target ="_blank" > <img src="assets/images/Level_1_D_C_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Level_1_D_C_Cards.svg" /></a>
</figure>

### <span style="color:silver"> 3.4.4 </span> Card Actions
{:.no_toc}

The actions, types and associated resources for the Digoxin + Cyclosporine Level 1 Implementation are listed below:  

* `create` 
    * Adding order for digoxin level measure – ProcedureRequest for serum digoxin trough within 24 hours 
    * Add consultation for either prescriber of digoxin or cyclosporine depending on which the patient is currently taking – ProcedureRequest consultation
    * Add order for electrolyte panel(s) (i.e., calcium, magnesium, potassium) and renal function (e.g., eGRF and serum creatinine) – ProcedureRequest for labs to be drawn
* `update` 
    * Reduce digoxin order currenlty on the patient's profile – MedicationRequest for low-dose digoxin
* `delete`
    * Remove current order for digoxin or cyclosporine 
    
> *Note:* These actions are options that SHOULD be customized to an institutions needs and capabilities.     
    
## <span style="color:silver"> 3.5.0 </span> Level 2 Implementation - Digoxin + Cyclosporine Knowledge Artifact

As described under the Getting Started tab, the Level 2 Implementation proposal requires several changes to the current standard specifications. Changes to the CDS Hooks context are specified below. The Level 2 Implementation proposal for the Digoxin + Cyclosporine artifact is split into two separate services. Figures 9 and 10 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both services (i.e., Order Select and Order Sign). The blue task boxes highlight the DetectedIssue status indicator, which informs the EHR  of additional needed resources (whether or not to fulfill the Order Sign Service prefetch template), and Order Sign Service if it needs to perform a FHIR server request in the event prefetch data are not provided in the request. Figure 11 depicts a Card display example. In this scenario, the `order-sign` Cards are filtered since the clinician's action indicated that the patient was no longer taking digoxin. 


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 9: Digoxin + Cyclosporine order-select logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_select.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_select.svg" /></a>
</figure>

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 10: Digoxin + Cyclosporine order-sign logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_prescribe.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_prescribe.svg" /></a>
</figure>


### <span style="color:silver"> 3.5.1 </span> CDS Hooks Request
{:.no_toc}




##### `order-select 1.0`
{:.no_toc}


Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | :----: | ----
`userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient 
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter
`selections`  | REQUIRED | No | *array* | The FHIR id of the newly selected order(s). The `selections` field references FHIR resources in the `draftOrders` Bundle. For example, `MedicationRequest/103`.
`draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


#### **`order-sign` 1.1** (modification of a current CDS Hook)
 {:.no_toc}
 The base version for the `order-sign` hook is 1.0. The Level 2 Implementation requires an additional context field. This modification is considered Minor but will change the version to 1.1.


 Field       | Optionality        |  Prefetch Token     |Type  | Description 
 :------------- |:-------------:|:-------: |:-----:| :-----------------
 `userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
 `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context 
 `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context 
 `detectedissue` | REQUIRED     | Yes |    *object* | R4 - FHIR Bundle of DetectedIssue resource for current order entry task
 `draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


#### `order-select` `prefetch`
{:.no_toc}
* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

#### `order-sign` `prefetch`
{:.no_toc}

* Rolling 100-day look-back period for digoxin concentration
    * [Observation](https://www.hl7.org/fhir/observation.html)

* Rolling 100-day look-back period for serum creatinine
    * [Observation](https://www.hl7.org/fhir/observation.html)
    
* Rolling 100-day look-back period for electrolytes including: potassium, magnesium, and calcium
    * [Observation](https://www.hl7.org/fhir/observation.html)


### <span style="color:silver"> 3.5.2 </span> CDS Hooks Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 11: Level 2 Digoxin + Cyclosporine Cards </strong></figcaption>
  <a href = "assets/images/Level_2_D_C_Cards.svg" target ="_blank" > <img src="assets/images/Level_2_D_C_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Level_2_D_C_Cards.svg" /></a>
</figure>



