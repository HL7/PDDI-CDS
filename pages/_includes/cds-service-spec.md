
# <span style="color:silver"> 3.0.0 </span> CDS Service Specification 

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}


### <span style="color:silver"> 3.0.1 </span>Summary of Normative Recommendations
{:.no_toc}

**PDDI CDS knowledge artifacts.**valueset-warfarin.xml

* It is RECOMMENDED that knowledge artifacts for PDDI CDS are written so that clinician-focused response information adheres to the 8 detailed best practice recommendations discussed in the Community Group Note titled [Minimum Representation of Potential Drug-Drug Interaction Knowledge and Evidence](https://w3id.org/hclscg/pddi).

**A CDS rule execution engine (service).** 

* The CDS rule execution engine MUST be able to process CDS Hooks requests and return CDS Hooks Card responses. In processing a CDS request, it MUST also be able to process FHIR data including clinical and terminology resources.

* If the CDS rule execution engine does not receive prefetch data in the request it MUST query the FHIR server via network call.

* It is RECOMMENDED that the rule engine be able to execute CDS rules written in [CQL](http://www.hl7.org/implement/standards/product_brief.cfm?product_id=400) and represented as a [FHIR Library](http://build.fhir.org/library.html) resource, either directly or compiled to HL7 [Expression Logical Model](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md).

* If the engine implements the advanced functionality described in this implementation guide (i.e., coordination between order-select and order-sign to prevent alert duplication) then, it MUST support processing of the configuration options described in [Extension subsection](#extension). If EHR clients do not send the configuration options, the default behavior of the service should be to NOT suppress card responses at order-sign that might duplicate card responses sent at order-select. This is because the EHR client should have an active role in the decision of whether to filter out alert responses. 

**An electronic health record (EHR) CDS client.**


* Prior to a hook trigger and subsequent processes, the EHR MUST initiate a [CDS Discovery](#-319--cds-discovery) request

* The EHR MUST call the PDDI CDS service by sending an HTTP POST containing a CDS Hooks request (JSON formatted) to the service endpoint (e.g.,http://FHIR.org/PDDI-CDS/warfarin-nsaids-cds). The JSON ([CDS Hooks request](#-323--cds-hooks-request)) MUST contain specified information for the hook that was triggered including FHIR server, user, and context. Provision of prefetch data as specified by the CDS service is RECOMMENDED.

* If the EHR client is requesting a CDS from an engine implements the advanced functionality described in this implementation guide (i.e., coordination between order-select and order-sign to prevent alert duplication) then, the client SHOULD use the configuration options described in [Extension subsection](#extension). The purpose of this is so that the EHR client has an active role in the decision to filter out alert responses. 

# <span style="color:silver"> 3.1.0 </span> Preliminaries 

This section contains documentation on how to implement PDDI CDS artifacts from a clinical and technical perspective. Later sections describe implementation details using a specific knowledge artifact example. Structured artifacts that implement the logic and behavior described below are available under [Artifacts](artifacts.html).


### <span style="color:silver"> 3.1.1 </span> Getting Started with PDDI CDS
{:.no_toc}

The words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, AND OPTIONAL are used as defined [*"Key words for use in RFCs to Indicate Requirement Levels".*](https://tools.ietf.org/html/rfc2119) S. Bradner. IETF. March 1997. Best Current Practice.


### <span style="color:silver"> 3.1.2 </span> What You Will Need
{:.no_toc}

* A web service that processes CDS requests using a CDS rule execution engine. The service MUST be able to process CDS Hooks requests and return CDS Hooks Card responses.

* A web service that processes CDS requests MUST be able to process FHIR data including clinical and terminology resources. 

* The EHR system that sends requests to the service MAY provide access to the service to relevant patient data in the EHR via a FHIR server. EHR systems that do not provide access to addition patient data will potentially receive more limited CDS because the service will only work with data in the `context` and `prefetch` fields of CDS Hooks requests.

* Here is a list of FHIR tools that might be of interest to implementers:

	* [Public](http://wiki.hl7.org/index.php?title=Publicly_Available_FHIR_Servers_for_testing) 
    
	* Local (preferred)

           <b> The HAPI links DO NOT work </b>
	    * [HAPI RESTful Server](http://hapifhir.io/doc_rest_server.html)

		* [HAPI JPA Server](http://hapifhir.io/doc_jpa.html)

		* [HAPI JAX-RS Server](http://hapifhir.io/doc_rest_server_jaxrs.html)

		* [.NET Server](https://github.com/ewoutkramer/fhir-net-api)
			


### <span style="color:silver"> 3.1.3 </span> CDS Function
{:.no_toc}

To invoke the PDDI CDS service, the EHR needs to send a CDS Hooks request at a pre-specified step the workflow process. The CDS service then parses and processes the request to determine if the prescribed medication conflicts with a medication the patient is presumably taking. If this condition is satisfied, the CDS service provides individualized information based on the PDDI knowledge base. While each implementation may employ a slightly different approach to ensure successful integration of the CDS system. Here are several general aspects to assess:

* A technical framework for the EHR to interact with the CDS service by

    * creating and sending CDS Hooks requests

    * capturing and presenting CDS Hooks card responses

* Use of FHIR terminologies (e.g., RxNorm, LOINC) and other FHIR resources

* SMART authentication during FHIR server requests


### <span style="color:silver"> 3.1.4 </span> CPOE Workflow Hooks 
{:.no_toc}

Figure 1 depicts hook triggers for a medication prescribing example. The implementation follows the [CDS Hooks `order-select`](https://cds-hooks.org/hooks/order-select/) and [CDS Hooks `order-sign`](https://cds-hooks.org/hooks/order-sign/) specifications that define trigger events when a clinician enters a medication and is ready to sign one or more medication orders for a patient. The `order-select` hook defines the initial trigger at the start of the CPOE workflow. The `order-sign` hook is among the last workflow events before an order is promoted out of a draft status. From a clinical and technical perspective, triggering the CDS service at two events in the workflow sets PDDI CDS apart from most conventional CDS systems that trigger CDS at the time of order signing. By moving CDS triggers earlier in the order entry workflow (i.e., `order-select`), clinicians will have actionable information in the middle of their decision making process. We think that providing information at this stage presents less of a cognitive burden on the clinician and will lead to more effective CDS.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Workflow and CDS Hooks for medication prescription </strong></figcaption>
  <a href = "assets/images/CPOE_workflow_2.svg" target ="_blank" > <img src= "assets/images/CPOE_workflow_2.svg" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow_2.svg" /></a>
</figure>

### <span style="color:silver"> 3.1.5 </span> Prefetch Role 
{:.no_toc}

For technical implementers, the intended role of prefetch is to improve the CDS service performance. This is achieved by minimizing CDS service network calls to external resources such as a FHIR server. When a client program subscribes to the PDDI CDS service, the service MUST return a prefetch specification in the response. This specification identifies resources that the PDDI CDS service SHOULD receive upon request. As described below, the prefetch requirements are different for `order-select` and `order-sign` services. The ideal scenario for both implementations and services is to send prefetch data with the CDS Hooks request. The implementor has flexibility on when and how to fulfill the prefetch templates (e.g., data in EHR memory or server call), which will likely result in a solution that reduces the burden of the server and improves the CDS service efficiency. If the CDS service does not receive prefetch data in the request it MUST query the server via network call. 


### <span style="color:silver"> 3.1.6 </span> Configuration Options and the CDS Service
{:.no_toc}

The primary motivation for configuration options is to support the advanced functionality of coordinating between order-select and order-sign to prevent alert duplication. Although it might seem reasonable to have the service default to this kind of coordination with no input from the EHR client, we think that there might be potential scenarios where this form of duplication might be desirable. For example, a teaching hospital might have resident physicians go through the order selection process and then have an attending physician sign off on the order. In this situation, having the same CDS Hooks cards returned at order-select and order-sign would not be perceived as a duplication to the attending. There might be other scenarios where repeating cards across the hooks makes sense. Thus, it seems best to have the EHR client some active role in the decision of whether to filter out alert responses. Using configuration options sent from the EHR client to the service provides a way for the client to have a say in how apparent duplication is handled.

Another role for configuration options would be to enable greater specificity of PDDI CDS to a given clinical environment. This is because clinicians and/or groups of clinicians often have specialized knowledge that might lead them to prioritize information about certain PDDIs over others. One of the advantages of PDDI CDS as a service over the conventional approach of triggering alerts using of a general drug interaction knowledge base is an EHR can be more specific about the interactions provided within a specific clinical environment.  For example, clinicians working at a psychiatric hospital might be well versed in psychiatric PDDIs and so only interested in PDDI CDS for drugs they know less about. However, there is another level of specificity that might be beneficial beyond the selection of specific drug combinations. For example, a particular clinician or clinical group might desire to only view PDDIs that are regarded as serious. Also, there might be a preference for the amount of detail in the response narrative. These could be handled using configuration options passed from the EHR client to the CDS service. This would likely be a preferred approach to allow for PDDI CDS to be more customized across many different clinical environments using EHR.

This implementation guide discusses a mechanism for providing the CDS service configuration from CDS Hooks requests. The use of this mechanism is required for the advanced functionality of coordinating between order-select and order-sign. There is no requirement to use additional configuration options at this time. Other possibly useful configuration options, such as to filter out non-serious alerts, might be the focus of a future project.

### <span style="color:silver"> 3.1.6 </span> The CDS Hooks Feedback Endpoint and the CDS Service
{:.no_toc}

The feedback service...TODO: discuss https://github.com/cds-hooks/docs/wiki/Feedback-endpoint-for-CDS-Hooks-1.1 



### <span style="color:silver"> 3.1.7 </span> Filtering CDS Hooks response cards at `order-sign`: CDS Service versus EHR Client
{:.no_toc}

The preferred implementation is to configure the CDS service to filter duplicative response cards previously shown to the prescriber at `order-select` as demonstrated in the [advanced implementation](#-330--advanced-implementation).  In order for PDDI CDS to be both sensitive and specific, different contextual factors are sent to the CDS service depending upon the order entry workflow step the clinician is engaged in.  At the time of medication selection, a `order-select` CDS Hook sends medication resources to the CDS service. Later, at the time of order signing, a `order-sign` CDS Hook sends other contextual resources specific to a PDDI identified from processing `order-select`. This might include retrospective patient conditions, lab measurements, and other information. One potential advantage of this approach is a reduction the amount of information needed to provide actionable PDDI information to the clinician. The approach might also limit the amount of information the EHR has to provide for an order entry task. For example, if a clinician starts an NSAID order for a patient that was taking warfarin and decides to discontinue the order based on the presented cards, the clinician only needs to read and process medication factors, and the EHR would not display additional patient resources such as age and history of upper gastrointestinal bleed.
 
### <span style="color:silver"> 3.1.8 </span> Process 
{:.no_toc}

This section provides an overview of the processes and components of the PDDI CDS. It is delineated by [Basic](#-320--basic-implementation) and [Advanced](#-330--advanced-implementation) Implementation sections. The Basic Implementation describes the technology specifications, and what structured code is available in this implementation guide. The Advanced Implementation is a target for future iterations to optimize the CDS artifacts. Details regarding the knowledge artifacts and decision points for the individual artifacts can be found in the TODO section.

### <span style="color:silver"> 3.1.9 </span> CDS Discovery
{:.no_toc}

Prior to a hook trigger and subsequent processes, the EHR MUST initiate a CDS Discovery (Figure 2). CDS Discovery is to identify CDS services and obtain associated prefetch templates. A prefetch template is a dictionary of read and search requests for needed resources of a particular service. The PDDI CDS service MAY provide a prefetch template for each service, and the EHR SHOULD populate prefetch templates with relevant patient data for the anticipated CDS Hook request.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: CDS Service Discovery </strong></figcaption>
  <img src="assets/images/cds-service-discovery.png" class="figure-img img-responsive img-rounded center-block" alt="Discover_CDS_Service.svg" />
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
      "hook": "order-select",
      "name": "PlanDefinition - Warfarin NSAIDs Recommendation Workflow",
      "title": "Warfarin NSAIDs Recommendation",
      "extension": {
        "pddi-configuration-items": [
          {
            "code": <an identifier for the configuration option>,
            "type": <data type of the configuration option, e.g. boolean>,
            "name": <human readable name of the configuration option>,
            "description": <human readable description of the configuration option>
          },

          ... other configuration options ...
        ]
      },
      "id": "warfarin-nsaids-cds-select",
      "prefetch": {
        "item1": "Patient?_id={{context.patientId}}",
        "item2": "MedicationRequest?patient={{context.patientId}}&authoredon=ge2019-12-11",
        "item3": "MedicationAdministration?patient={{context.patientId}}&effective-time=ge2019-12-11",
        "item4": "MedicationDispense?patient={{context.patientId}}&whenhandedover=ge2019-12-11",
        "item5": "MedicationStatement?patient={{context.patientId}}&effective=ge2019-12-11",
        "item6": "Condition?patient={{context.patientId}}"
      }
    },
    {
      "hook": "order-sign",
      "name": "PlanDefinition - Warfarin NSAIDs Recommendation Workflow",
      "title": "Warfarin NSAIDs Recommendation",
      "extension": {
        "pddi-configuration-items": [
          {
            "code": <an identifier for the configuration option>,
            "type": <data type of the configuration option, e.g. boolean>,
            "name": <human readable name of the configuration option>,
            "description": <human readable description of the configuration option>
          },

          ... other configuration options ...
        ]
      },
      "id": "warfarin-nsaids-cds-sign",
      "prefetch": {
        "item1": "Patient?_id={{context.patientId}}",
        "item2": "MedicationRequest?patient={{context.patientId}}&authoredon=ge2019-12-11",
        "item3": "MedicationAdministration?patient={{context.patientId}}&effective-time=ge2019-12-11",
        "item4": "MedicationDispense?patient={{context.patientId}}&whenhandedover=ge2019-12-11",
        "item5": "MedicationStatement?patient={{context.patientId}}&effective=ge2019-12-11",
        "item6": "Condition?patient={{context.patientId}}"
      }
    }
  ]
}

~~~


# <span style="color:silver"> 3.2.0 </span> Basic Implementation

The Basic Implementation uses the `order-sign 1.0` and is a more simplistic approach compared to the [Advanced Implementation](#-330--advanced-implementation). The CDS Hooks specification states that `order-sign 1.0` fires when a clinician is ready to sign one or more orders for a patient, (including orders for medications, procedures, labs and other orders). This hook is among the last workflow events before an order is promoted out of a draft status. The context contains all order details, such as dose, quantity, route, etc, although the order has not yet been signed and therefore still exists in a draft status. Use this hook when your service requires all order details, and the clinician will accept recommended changes. Since EHR platforms may have different discrete steps in the order entry process, the implementor decides what action (e.g., selecting a medication product, accepting order completion) triggers the CDS Hooks request.  

## <span style="color:silver"> 3.2.1 </span> Summary of Operations
{:.no_toc}

The process for a unique instance of PDDI CDS begins with the user triggering a CDS Hooks request (i.e., `order-sign`) and ends with the user's action in response to the Card response suggestion(s) (Figure 3). The parse and pre-process subprocess is to determine if a FHIR server query needed. The Clinical Reasoning module evaluates the complete request and creates information to send back the the EHR. The event subprocesses may occur in response to a specific instance (i.e., SMART authorization and FHIR access) or asynchronous of the specific instance (i.e., CDS Discovery). 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Basic Implementation – Order Sign Service Summary </strong></figcaption>
  <img src="assets/images/basic-order-sign-service.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_Order_Sign_service.svg" />
</figure>



## <span style="color:silver"> 3.2.2 </span> CDS Hooks
{:.no_toc}

The PDDI CDS artifacts use the HL7 CDS Hooks specification [1.0](http://cds-hooks.org/specification/1.0/).  The CDS Hooks standard defines the data structure to facilitate communication between the EHR and the CDS service through a RESTful API request and response. This allows patient data to be sent and received by the EHR at intervals that better align with clinical workflows – further leveraging FHIR and SMART applications at the point of care. CDS Hooks instances include CDS Discovery, EHR requests and CDS service response. The `context` and `prefetch` are two key elements of the CDS Hook request that contain patient information. The `context` element contains data that is task and hook-specific. The `prefetch` element contains patient-specific information that is relevant to the `context` data and the invoked CDS service. The CDS Hooks response is a set of Cards. The Cards contain general information, suggested actions, and display indicators in a structured format for the EHR to process and display. The CDS Discovery of the CDS Hooks specification delineates information that the CDS service is to provide to the EHR.

> *Note:* The [HL7 specification for decision support](http://www.hl7.org/implement/standards/product_brief.cfm?product_id=334) does not require that the CDS service process CDS Hooks. This implementation guide requires their use because CDS Hooks should provide simplicity and specific orientation for CPOE workflow integration.



### <span style="color:silver"> 3.2.3 </span> CDS Hooks Request 
{:.no_toc}

The EHR MUST call the PDDI CDS service by sending an HTTP `POST` containing `JSON` to the service endpoint (e.g.,`http://FHIR.org/PDDI-CDS/warfarin-nsaids-cds`). The JSON (CDS Hooks request) MUST contain specified information for the hook that was triggered, FHIR server, user, context, and prefetch.

##### Context
{:.no_toc}

The `context` element of a CDS Hooks request contains contextual data for the current task and is specified below. For example, the `order-sign` hook specifies the `context` MUST include the medication product (i.e., `medication` element of the MedicationRequest resource) of the order in process. 

##### order-sign 1.0.
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | ---- | ----
`userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient in context
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter in context
`draftOrders`| REQUIRED | No | *object* | R4 - FHIR `MedicationRequest` resource

##### Extension
{:.no_toc}

###### PDDI Configuration Items
{:.no_toc}
The CDS Service MAY process configuration options sent as within an extension resource with the CDS Hooks request in the field `pddi-configuration-items`. At the present time, there are no standard configuration options for the basic implementation of PDDI CDS. Balloting such options as a standard is for future work. While not a recommendation, some examples can be shown. One example would be a configuration such as `alert-non-serious` that accepts accepts a Boolean value indicating to the CDS service if it should provide alerts for PDDIs that have an indicator other than 'serious'. Another example would be a configuration such as `show-evidence-support`  indicating to the CDS service that it should provide more detailed evidence support for its alerts. 
			    			    			    

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


### <span style="color:silver"> 3.2.4 </span> FHIR Server Request
{:.no_toc}

A FHIR server request by the CDS service is necessary in the event the request `prefetch` element is empty. While the `prefetch` element is OPTIONAL, it MUST NOT be partially fulfilled. The post-hoc FHIR server query is performed at the parse and pre-process phase shown in Figure 4. To accomplish a FHIR server request, the server URL and the OAuth authorization token (i.e. `fhirServer,` `fhirAuthorization`) MUST be provided in the CDS Hooks request. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: Basic – Parse and Pre-process CDS Hooks request </strong></figcaption>
  <img src="assets/images/basic-parse-pre-process.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_Parse_pre-process.svg" />
</figure>



### <span style="color:silver"> 3.2.5 </span> CDS Hooks Response and Card Display
{:.no_toc}

The CDS service response is a Card array. Each Card has specified attributes that map to the core elements of the minimum information model (e.g., `summary` = Drugs Involved). Each Card has a `suggestions` array and each suggestion has an `action` array. The Card `indicator` element dictates how the EHR presents the alert (e.g., `indicator` = "critical" could be a modal alert).

**Example 3: CDS Hooks Response**

~~~
{
  "cards": [
    {
      "summary": "Potential drug-drug interaction between naproxen 500mg tablet and warfarin 5mg tablet",
      "indicator": "critical",
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
    } ...
 snipped for brevity
~~~

**Card Display Example**

* Basic – Warfarin + NSAIDs Cards (Without `filter-out-repeated-alerts`)
~~~
{
  "cards": [
    {
      "summary": "Potential Drug-Drug Interaction between warfarin (Warfarin Sodium 0.5 MG Oral Tablet) and NSAID (Ketorolac Tromethamine 10 MG Oral Tablet).",
      "indicator": "warning",
      "detail": "Increased risk of bleeding. \nBleeding is a serious potential clinical consequence because it can result in death, life-threatening hospitalization, and disability. \nNon-steroidal anti-inflammatory drugs (NSAIDs) have antiplatelet effects which increase the bleeding risk when combined with oral anticoagulants such as warfarin. The antiplatelet effect of NSAIDs lasts only as long as the NSAID is present in the circulation, unlike aspirin’s antiplatelet effect, which lasts for up to 2 weeks after aspirin is discontinued. NSAIDs also can cause peptic ulcers and most of the evidence for increased bleeding risk with NSAIDs plus warfarin is due to upper gastrointestinal bleeding (UGIB). \nunknown. \n unknown.",
      "source": {
        "label": "Warfarin-NSAIDs clinical decision support algorithm",
        "url": "https://ddi-cds.org/warfarin-nsaids/"
      },
      "suggestions": [
        {
          "label": "Assess risk and take action if necessary.",
          "actions": [
            {
              "type": "delete",
              "description": "If the NSAID is being used as an analgesic or antipyretic, it would be prudent to use an alternative such as acetaminophen. In some people, acetaminophen can increase the anticoagulant effect of warfarin, so monitor the INR if acetaminophen is used in doses over 2 g/day for a few days. For more severe pain consider short-term opioids in place of the NSAID."
            }
          ]
        },
        {
          "label": "Substitute NSAID (Ketorolac Tromethamine 10 MG Oral Tablet) with APAP (Acetaminophen 325 MG Oral Tablet).",
          "actions": [
            {
              "type": "create",
              "description": "Order for APAP <2g per day (APAP 500 mg every 4-6 hours prn).",
              "resource": {
                "resourceType": "MedicationRequest",
                "id": "3f6b9b43-9354-4512-9883-a915417e2936",
                "intent": "order",
                "medicationCodeableConcept": {
                  "coding": [
                    {
                      "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                      "code": "313782",
                      "display": "Acetaminophen 325 MG Oral Tablet"
                    }
                  ],
                  "text": "Acetaminophen 325 MG Oral Tablet"
                },
                "subject": {
                  "reference": "f101"
                }
              }
            }
          ]
        },
        {
          "label": "Substitute NSAID (Ketorolac Tromethamine 10 MG Oral Tablet) with APAP (Acetaminophen 500 MG Oral Tablet).",
          "actions": [
            {
              "type": "create",
              "description": "Order for APAP <2g per day (APAP 500 mg every 4-6 hours prn).",
              "resource": {
                "resourceType": "MedicationRequest",
                "id": "d54e75a7-90ce-4ee7-90b6-63333c052648",
                "intent": "order",
                "medicationCodeableConcept": {
                  "coding": [
                    {
                      "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                      "code": "198440",
                      "display": "Acetaminophen 500 MG Oral Tablet"
                    }
                  ],
                  "text": "Acetaminophen 500 MG Oral Tablet"
                },
                "subject": {
                  "reference": "f101"
                }
              }
            }
          ]
        }
      ]
    },
    {
      "summary": "Patient is not taking a proton pump inhibitor or misoprostol.",
      "indicator": "critical",
      "detail": "Proton pump inhibitors and misoprostol may reduce the risk of UGIB in patients receiving NSAIDs and warfarin.",
      "source": {
        "label": "Warfarin-NSAIDs clinical decision support algorithm",
        "url": "https://ddi-cds.org/warfarin-nsaids/"
      },
      "suggestions": [
        {
          "label": "Use only if benefit outweighs risk."
        }
      ]
    },
    {
      "summary": "Patient is 65 y/o or does have a history of upper gastrointestinal bleed (\"Acute duodenal ulcer with hemorrhage\" and 2020-03-01).",
      "indicator": "warning",
      "detail": "Patients with a history of UGIB or peptic ulcer may have an increased risk of UGIB from this interaction. The extent to which older age is an independent risk factor for UGIB due to these interactions is not firmly established, but UGIB in general is known to increase with age.",
      "source": {
        "label": "Warfarin-NSAIDs clinical decision support algorithm",
        "url": "https://ddi-cds.org/warfarin-nsaids/"
      },
      "suggestions": [
        {
          "label": "Use only if benefit outweighs risk."
        }
      ]
    },
    {
      "summary": "Patient is not concomitantly taking systemic corticosteroids, aldosterone antagonist, or high dose or multiple NSAIDs.",
      "indicator": "info",
      "detail": "Both corticosteroids and aldosterone antagonists have been shown to subsetantially increase the risk of UGIB in patients on NSAIDs, with relative risks of 12.8 and 11 respectively compared to a risk of 4.3 with NSAIDs alone (Masclee et al. Gastroenterology 2014; 147:784-92.)",
      "source": {
        "label": "Warfarin-NSAIDs clinical decision support algorithm",
        "url": "https://ddi-cds.org/warfarin-nsaids/"
      },
      "suggestions": [
        {
          "label": "Assess risk and take action if necessary."
        }
      ]
    }
  ]
}
~~~

* Basic - Digoxin + Cyclosporine Cards (Without `filter-out-repeated-alerts`)
~~~
{
  "cards": [
    {
      "summary": "Potential Drug-Drug Interaction between digoxin (Digoxin 0.2 MG Oral Capsule) and cyclosporine (Cyclosporine 100 MG)",
      "indicator": "warning",
      "detail": "Increased risk of digoxin toxicity. Assess risk and take action if necessary. \nDigoxin toxicity is potentially serious. The clinical consequences may include anorexia, nausea, vomiting, visual changes, and cardiac arrhythmias. \nThe mechanism of this interaction appears to be mediated through P-glycoprotein inhibition by cyclosporine. P-glycoprotein is a major transporter for digoxin efflux. \nunknown. \nunknown.",
      "source": {
        "label": "Potential Drug-Drug Interaction Clinical Decision Support",
        "url": "http://hl7.org/fhir/ig/PDDI-CDS"
      },
      "suggestions": [
        {
          "label": "Consultation",
          "actions": [
            {
              "type": "create",
              "description": "Request communication with digoxin prescriber",
              "resource": {
                "resourceType": "ProcedureRequest",
                "id": "70ef559c-a02d-463d-8505-9beb9c2629c3",
                "status": "draft",
                "intent": "order",
                "code": {
                  "coding": [
                    {
                      "system": "http://snomed.info/sct",
                      "code": "11429006",
                      "display": "Consultation"
                    }
                  ],
                  "text": "Consultation"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        },
        {
          "label": "Cancel digoxin",
          "actions": [
            {
              "type": "delete",
              "description": "Discontinue digoxin order"
            }
          ]
        }
      ]
    },
    {
      "summary": "Patient does not have digoxin level on record within the last 30 days. ",
      "indicator": "warning",
      "detail": "Initiating cyclosporine is expected to increase digoxin levels. For patients without a reliable plasma digoxin concentration in normal range, use only if benefits outweight risks. Extreme caution and close monitoring is necessary.",
      "source": {
        "label": "Potential Drug-Drug Interaction Clinical Decision Support",
        "url": "http://hl7.org/fhir/ig/PDDI-CDS"
      },
      "suggestions": [
        {
          "label": "Digoxin Level",
          "actions": [
            {
              "type": "create",
              "description": "Order digoxin trough within 24 hours from the initiation of cyclosporine",
              "resource": {
                "resourceType": "ProcedureRequest",
                "id": "79d64211-25f6-4e8c-babe-856816127d1b",
                "status": "draft",
                "intent": "order",
                "code": {
                  "coding": [
                    {
                      "system": "http://snomed.info/sct",
                      "code": "269872007",
                      "display": "Serum digoxin measurement"
                    }
                  ],
                  "text": "Serum digoxin measurement"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        },
        {
          "label": "New Digoxin",
          "actions": [
            {
              "type": "create",
              "description": "Preemptively reduce digoxin dose with new order ",
              "resource": {
                "resourceType": "MedicationRequest",
                "id": "3c428362-5646-4131-9f96-937a7df5dbf4",
                "intent": "order",
                "medicationCodeableConcept": {
                  "coding": [
                    {
                      "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                      "code": "315819",
                      "display": "Digoxin 0.125 MG"
                    }
                  ],
                  "text": "Digoxin 0.125 MG"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        }
      ],
      "links": [
        {
          "label": "digoxin-cyclosporine PDDI knowledge artifact",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/derived-from#digoxin-cyclosporine-knowledge-artifact"
        },
        {
          "label": "(Dorian et al. Clin Invest Med 1988; 11(2):108-112) ",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/citation#dorian1988"
        },
        {
          "label": "(Dorian et al. Transplant Proc. 1987; 19(1):1825-1827)",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/citation#dorian#1987"
        }
      ]
    },
    {
      "summary": "Within 100 days, the patient has had electrolyte and serum creatinine levels checked, and they are not on a potassium sparing or loop diuretic.",
      "indicator": "info",
      "detail": "(Potassium: 3.6mEq/L and 2020-04-28)\n (Magnesium: 0.8mmol/L and 2020-04-28)\n (Calcium: 8.6mg/dL and 2020-04-28)\n",
      "source": {
        "label": "Potential Drug-Drug Interaction Clinical Decision Support",
        "url": "http://hl7.org/fhir/ig/PDDI-CDS"
      },
      "suggestions": [
        {
          "label": "Serum Creatinine",
          "actions": [
            {
              "type": "create",
              "description": "Order for serum creatinine",
              "resource": {
                "resourceType": "ProcedureRequest",
                "id": "85d53af2-22ec-4441-8ecf-f71879779f2a",
                "status": "draft",
                "intent": "order",
                "code": {
                  "coding": [
                    {
                      "system": "http://snomed.info/sct",
                      "code": " 313822004",
                      "display": "Corrected serum creatinine"
                    }
                  ],
                  "text": "Serum Creatinine"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        },
        {
          "label": "Electrolyte Panel",
          "actions": [
            {
              "type": "create",
              "description": "Order for electrolyte panel",
              "resource": {
                "resourceType": "ProcedureRequest",
                "id": "8c6514e3-1d47-47b6-87b3-fc53ce8f6eb2",
                "status": "draft",
                "intent": "order",
                "code": {
                  "coding": [
                    {
                      "system": "http://snomed.info/sct",
                      "code": "271236005",
                      "display": "Serum potassium level"
                    },
                    {
                      "system": "http://snomed.info/sct",
                      "code": "312475002",
                      "display": "Plasma magnesium level"
                    },
                    {
                      "system": "http://snomed.info/sct",
                      "code": "390963002",
                      "display": "Plasma calcium level"
                    }
                  ],
                  "text": "Electrolyte Panel"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        }
      ],
      "links": [
        {
          "label": "digoxin-cyclosporine PDDI knowledge artifact",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/derived-from#digoxin-cyclosporine-knowledge-artifact"
        },
        {
          "label": "(Lip et al. Postgrad Med J. 1993; 69(811):337)",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/citation#lip1993"
        },
        {
          "label": "(Digoxin-FDA [prescribing information] NDA 20405/S-004)",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/citation#nda20405"
        }
      ]
    }
  ]
}
~~~

# <span style="color:silver"> 3.3.0 </span> Advanced Implementation


The Advanced Implementation is a proposed target to optimize PDDI CDS artifacts. It builds on the [Basic Implementation](#-320--basic-implementation); however, implementors MUST select either Basic or Advanced Implementation and *not* both. This section does not provide a comprehensive overview of the implementation but highlights deviations from the Basic Implementation above. 


Differences between the Basic and Advanced Implementations include:

1. Defining two CDS Hooks triggers in CPOE workflow (i.e., `order-select` and `order-sign`)

2. Creating a `order-select` specification 

3. Modify `order-sign` specification

4. Creating separate but coordinated Order Select and Order Sign Services

> *Note:* The Advanced Implementation requires two separate, but *coordinated,* services for standards' precision, logic flexibility, and to avoid the need for CDS service state.


### <span style="color:silver"> 3.3.1 </span> Advanced – CPOE Workflow
{:.no_toc}

Different contextual factors are available and needed at different times during the medication order process (Figure 5). To align clinicians' information needs with PDDI information, the Advanced Implementation *defines* two separate hook trigger events in the medication order workflow:

1. Selecting a drug product to include in medication order (`order-select`)

2. Accepting or signing a single medication order (`order-sign`)


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: CPOE Workflow Example </strong></figcaption>
  <img src="assets/images/CPOE_workflow.svg" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow.svg" />
</figure>

### <span style="color:silver"> 3.3.2 </span> Advanced – Summary of Operations
{:.no_toc}

Coordinating the Order Select Service with the Order Sign Service is a key aspect of the Advanced Implementation. Figure 6 depicts the summary of operations that coordinates the Order Select and Order Sign Services.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 6: Advanced – PDDI CDS Service Summary </strong></figcaption>
  <img src="assets/images/advanced-pddi-cds-service.png" class="figure-img img-responsive img-rounded center-block" alt="Advanced_Summary.svg" />
</figure>

### <span style="color:silver"> 3.3.3 </span> CDS Hooks
{:.no_toc}


### <span style="color:silver"> 3.3.4 </span> Advanced – order-select CDS Service Discovery response example
{:.no_toc}

~~~
 {
  "services": [
    {
      "hook": "order-select",
      "name": "PlanDefinition - Warfarin NSAIDs Recommendation Workflow",
      "title": "Warfarin NSAIDs Recommendation",
      "extension": {
        "pddi-configuration-items": [
          {
            "code": <an identifier for the configuration option>,
            "type": <data type of the configuration option, e.g. boolean>,
            "name": <human readable name of the configuration option>,
            "description": <human readable description of the configuration option>
          },

          ... other optional configuration options ...
        ]
      },
      "id": "warfarin-nsaids-cds-select",
      "prefetch": {
        "item1": "Patient?_id={{context.patientId}}",
        "item2": "MedicationRequest?patient={{context.patientId}}&authoredon=ge2019-12-11",
        "item3": "MedicationAdministration?patient={{context.patientId}}&effective-time=ge2019-12-11",
        "item4": "MedicationDispense?patient={{context.patientId}}&whenhandedover=ge2019-12-11",
        "item5": "MedicationStatement?patient={{context.patientId}}&effective=ge2019-12-11",
        "item6": "Condition?patient={{context.patientId}}"
      }
    },
    {
      "hook": "order-sign",
      "name": "PlanDefinition - Warfarin NSAIDs Recommendation Workflow",
      "title": "Warfarin NSAIDs Recommendation",
      "extension": {
        "pddi-configuration-items": [
          {
            "code": <an identifier for the configuration option>,
            "type": <data type of the configuration option, e.g. boolean>,
            "name": <human readable name of the configuration option>,
            "description": <human readable description of the configuration option>
          },

          ... other configuration options ...
        ]
      },
      "id": "warfarin-nsaids-cds-sign",
      "prefetch": {
        "item1": "Patient?_id={{context.patientId}}",
        "item2": "MedicationRequest?patient={{context.patientId}}&authoredon=ge2019-12-11",
        "item3": "MedicationAdministration?patient={{context.patientId}}&effective-time=ge2019-12-11",
        "item4": "MedicationDispense?patient={{context.patientId}}&whenhandedover=ge2019-12-11",
        "item5": "MedicationStatement?patient={{context.patientId}}&effective=ge2019-12-11",
        "item6": "Condition?patient={{context.patientId}}"
      }
    }
  ]
}

~~~

### <span style="color:silver"> 3.3.5 </span> Advanced – CDS Hooks Request
{:.no_toc}

The Advanced Implementation specifies the use of both the `order-select` and `order-sign` CDS Hooks during a single medication order task.


#### Context
{:.no_toc}

The `context` element of the `order-select` CDS Hooks request is identical to the `order-sign` specification used in the Basic Implementation. For details on the specifications are below.


#### order-select 1.0
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | :----: | ----
`userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient 
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter
`selections`  | REQUIRED | No | *array* | The FHIR id of the newly selected order(s). The `selections` field references FHIR resources in the `draftOrders` Bundle. For example, `MedicationRequest/103`.
`draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


#### order-sign 1.1 (modification of a current CDS Hook)
 {:.no_toc}
 The base version for the `order-sign` hook is 1.0. The Advanced Implementation requires an additional context field. This modification is considered Minor but will change the version to 1.1.


 Field       | Optionality        |  Prefetch Token     |Type  | Description 
 :------------- |:-------------:|:-------: |:-----:| :-----------------
 `userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
 `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context 
 `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context 
 `draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task

##### Extension
{:.no_toc}

###### PDDI Configuration Items
{:.no_toc}
The CDS Service MUST process configuration options sent as within an extension resource with the CDS Hooks request in the field `pddi-configuration-items`. There are two standard configuration options:  `cache-for-order-sign-filtering` (only used in `order-select`), `filter-out-repeated-alerts` (only used in `order-sign`). All of these configuration options accept Boolean values and are required for the advanced implementation. The `cache-for-order-sign-filtering` option is used to cache the medication resource during `order-select` and is used as a reference during `order-sign` if `filter-out-repeated-alerts` is set to TRUE. The `filter-out-repeated-alerts` option is used to hide card results if they were shown in the `order-select` results. At the present time, there are no other standard configuration options for the basic implementation of PDDI CDS. Balloting such options as a standard is for future work. While not a recommendation, some examples can be shown. One example would be a configuration such as `alert-non-serious` that accepts accepts a Boolean value indicating to the CDS service if it should provide alerts for PDDIs that have an indicator other than 'serious'. Another example would be a configuration such as `show-evidence-support`  indicating to the CDS service that it should provide more detailed evidence support for its alerts. 


#### Prefetch
{:.no_toc}

Since the order entry task is split into two separate CDS Hooks events (i.e., services), the prefetch template for the Order Select Service includes only medication resources. The prefetch template for the Order Sign Service includes any additional resources needed for a specific PDDI *after* accounting for clinician action(s). 

##### CDS Hooks Request Example
{:.no_toc}

* [Request test data](testdata.html)


### <span style="color:silver"> 3.3.6 </span> Advanced – FHIR Server Request
{:.no_toc}

The parse and pre-process event for a `order-select` request in the Advanced Implementation is identical to what occurs with `order-sign` for the Basic Implementation. Processing of `order-sign` for the Advanced Implementation service is slightly different. During the parse and pre-process phase the CDS service checks the medication that was finally ordered against the medication that was cached during `order-select` if `cache-for-order-sign-filtering` was set to TRUE. If `filter-out-repeated-alerts` is also set to TRUE during `order-sign` then repeated alert cards will not be returned. 


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 7: Advanced – Parse and Pre-process for Order Select/Order Sign Service </strong></figcaption>
  <img src="assets/images/advanced-parse-pre-process.png" class="figure-img img-responsive img-rounded center-block" alt="Parse_pre-process_prescribe.svg" />
</figure>



### <span style="color:silver"> 3.3.7 </span> Advanced – CDS Hooks Response and Card Display
{:.no_toc}

**Example: Advanced – CDS Hooks Response**

~~~
{
  "cards": [
    {
      "summary": "Potential drug-drug interaction between naproxen 500mg tablet and warfarin 5mg tablet",
      "indicator": "critical",
      "detail": "Non-steroidal anti-inflammatory drugs (NSAIDs) have antiplatelet effects which increase the bleeding risk when combined with oral anticoagulants such as warfarin.",
      
snipped for brevity        
~~~

**Card Display Example**

* Advanced – Warfarin + NSAIDs Cards (Without `filter-out-repeated-alerts`)

~~~
{
  "cards": [
    {
      "summary": "Potential Drug-Drug Interaction between warfarin (Warfarin Sodium 0.5 MG Oral Tablet) and NSAID (Ketorolac Tromethamine 10 MG Oral Tablet).",
      "indicator": "warning",
      "detail": "Increased risk of bleeding. \nBleeding is a serious potential clinical consequence because it can result in death, life-threatening hospitalization, and disability. \nNon-steroidal anti-inflammatory drugs (NSAIDs) have antiplatelet effects which increase the bleeding risk when combined with oral anticoagulants such as warfarin. The antiplatelet effect of NSAIDs lasts only as long as the NSAID is present in the circulation, unlike aspirin’s antiplatelet effect, which lasts for up to 2 weeks after aspirin is discontinued. NSAIDs also can cause peptic ulcers and most of the evidence for increased bleeding risk with NSAIDs plus warfarin is due to upper gastrointestinal bleeding (UGIB). \nunknown. \n unknown.",
      "source": {
        "label": "Warfarin-NSAIDs clinical decision support algorithm",
        "url": "https://ddi-cds.org/warfarin-nsaids/"
      },
      "suggestions": [
        {
          "label": "Assess risk and take action if necessary.",
          "actions": [
            {
              "type": "delete",
              "description": "If the NSAID is being used as an analgesic or antipyretic, it would be prudent to use an alternative such as acetaminophen. In some people, acetaminophen can increase the anticoagulant effect of warfarin, so monitor the INR if acetaminophen is used in doses over 2 g/day for a few days. For more severe pain consider short-term opioids in place of the NSAID."
            }
          ]
        },
        {
          "label": "Substitute NSAID (Ketorolac Tromethamine 10 MG Oral Tablet) with APAP (Acetaminophen 325 MG Oral Tablet).",
          "actions": [
            {
              "type": "create",
              "description": "Order for APAP <2g per day (APAP 500 mg every 4-6 hours prn).",
              "resource": {
                "resourceType": "MedicationRequest",
                "id": "3f6b9b43-9354-4512-9883-a915417e2936",
                "intent": "order",
                "medicationCodeableConcept": {
                  "coding": [
                    {
                      "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                      "code": "313782",
                      "display": "Acetaminophen 325 MG Oral Tablet"
                    }
                  ],
                  "text": "Acetaminophen 325 MG Oral Tablet"
                },
                "subject": {
                  "reference": "f101"
                }
              }
            }
          ]
        },
        {
          "label": "Substitute NSAID (Ketorolac Tromethamine 10 MG Oral Tablet) with APAP (Acetaminophen 500 MG Oral Tablet).",
          "actions": [
            {
              "type": "create",
              "description": "Order for APAP <2g per day (APAP 500 mg every 4-6 hours prn).",
              "resource": {
                "resourceType": "MedicationRequest",
                "id": "d54e75a7-90ce-4ee7-90b6-63333c052648",
                "intent": "order",
                "medicationCodeableConcept": {
                  "coding": [
                    {
                      "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                      "code": "198440",
                      "display": "Acetaminophen 500 MG Oral Tablet"
                    }
                  ],
                  "text": "Acetaminophen 500 MG Oral Tablet"
                },
                "subject": {
                  "reference": "f101"
                }
              }
            }
          ]
        }
      ]
    },
    {
      "summary": "Patient is not taking a proton pump inhibitor or misoprostol.",
      "indicator": "critical",
      "detail": "Proton pump inhibitors and misoprostol may reduce the risk of UGIB in patients receiving NSAIDs and warfarin.",
      "source": {
        "label": "Warfarin-NSAIDs clinical decision support algorithm",
        "url": "https://ddi-cds.org/warfarin-nsaids/"
      },
      "suggestions": [
        {
          "label": "Use only if benefit outweighs risk."
        }
      ]
    },
    {
      "summary": "Patient is 65 y/o or does have a history of upper gastrointestinal bleed (\"Acute duodenal ulcer with hemorrhage\" and 2020-03-01).",
      "indicator": "warning",
      "detail": "Patients with a history of UGIB or peptic ulcer may have an increased risk of UGIB from this interaction. The extent to which older age is an independent risk factor for UGIB due to these interactions is not firmly established, but UGIB in general is known to increase with age.",
      "source": {
        "label": "Warfarin-NSAIDs clinical decision support algorithm",
        "url": "https://ddi-cds.org/warfarin-nsaids/"
      },
      "suggestions": [
        {
          "label": "Use only if benefit outweighs risk."
        }
      ]
    },
    {
      "summary": "Patient is not concomitantly taking systemic corticosteroids, aldosterone antagonist, or high dose or multiple NSAIDs.",
      "indicator": "info",
      "detail": "Both corticosteroids and aldosterone antagonists have been shown to subsetantially increase the risk of UGIB in patients on NSAIDs, with relative risks of 12.8 and 11 respectively compared to a risk of 4.3 with NSAIDs alone (Masclee et al. Gastroenterology 2014; 147:784-92.)",
      "source": {
        "label": "Warfarin-NSAIDs clinical decision support algorithm",
        "url": "https://ddi-cds.org/warfarin-nsaids/"
      },
      "suggestions": [
        {
          "label": "Assess risk and take action if necessary."
        }
      ]
    }
  ]
}
~~~

* Advanced – Warfarin + NSAIDs Cards (With `filter-out-repeated-alerts`)

~~~
{
  "cards": [
    {
      "summary": "An alert was filtered because this request is configured to filter alerts if they were presented previously in response to a prior CDS Hook request.",
      "indicator": "info",
      "detail": "Since filter-out-repeated-alerts was set to true in this CDS Hook request, the service is filtering out cards that were triggered by the same knowledge artifact when the physician reference display, encounter id, and patient id match between the order-select and order-sign requests.",
      "source": {}
    }
  ]
}
~~~

* Advanced - Digoxin + Cyclosporine Cards (Without `filter-out-repeated-alerts`)

~~~
{
  "cards": [
    {
      "summary": "Potential Drug-Drug Interaction between digoxin (Digoxin 0.2 MG Oral Capsule) and cyclosporine (Cyclosporine 100 MG)",
      "indicator": "warning",
      "detail": "Increased risk of digoxin toxicity. Assess risk and take action if necessary. \nDigoxin toxicity is potentially serious. The clinical consequences may include anorexia, nausea, vomiting, visual changes, and cardiac arrhythmias. \nThe mechanism of this interaction appears to be mediated through P-glycoprotein inhibition by cyclosporine. P-glycoprotein is a major transporter for digoxin efflux. \nunknown. \nunknown.",
      "source": {
        "label": "Potential Drug-Drug Interaction Clinical Decision Support",
        "url": "http://hl7.org/fhir/ig/PDDI-CDS"
      },
      "suggestions": [
        {
          "label": "Consultation",
          "actions": [
            {
              "type": "create",
              "description": "Request communication with digoxin prescriber",
              "resource": {
                "resourceType": "ProcedureRequest",
                "id": "70ef559c-a02d-463d-8505-9beb9c2629c3",
                "status": "draft",
                "intent": "order",
                "code": {
                  "coding": [
                    {
                      "system": "http://snomed.info/sct",
                      "code": "11429006",
                      "display": "Consultation"
                    }
                  ],
                  "text": "Consultation"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        },
        {
          "label": "Cancel digoxin",
          "actions": [
            {
              "type": "delete",
              "description": "Discontinue digoxin order"
            }
          ]
        }
      ]
    },
    {
      "summary": "Patient does not have digoxin level on record within the last 30 days. ",
      "indicator": "warning",
      "detail": "Initiating cyclosporine is expected to increase digoxin levels. For patients without a reliable plasma digoxin concentration in normal range, use only if benefits outweight risks. Extreme caution and close monitoring is necessary.",
      "source": {
        "label": "Potential Drug-Drug Interaction Clinical Decision Support",
        "url": "http://hl7.org/fhir/ig/PDDI-CDS"
      },
      "suggestions": [
        {
          "label": "Digoxin Level",
          "actions": [
            {
              "type": "create",
              "description": "Order digoxin trough within 24 hours from the initiation of cyclosporine",
              "resource": {
                "resourceType": "ProcedureRequest",
                "id": "79d64211-25f6-4e8c-babe-856816127d1b",
                "status": "draft",
                "intent": "order",
                "code": {
                  "coding": [
                    {
                      "system": "http://snomed.info/sct",
                      "code": "269872007",
                      "display": "Serum digoxin measurement"
                    }
                  ],
                  "text": "Serum digoxin measurement"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        },
        {
          "label": "New Digoxin",
          "actions": [
            {
              "type": "create",
              "description": "Preemptively reduce digoxin dose with new order ",
              "resource": {
                "resourceType": "MedicationRequest",
                "id": "3c428362-5646-4131-9f96-937a7df5dbf4",
                "intent": "order",
                "medicationCodeableConcept": {
                  "coding": [
                    {
                      "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                      "code": "315819",
                      "display": "Digoxin 0.125 MG"
                    }
                  ],
                  "text": "Digoxin 0.125 MG"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        }
      ],
      "links": [
        {
          "label": "digoxin-cyclosporine PDDI knowledge artifact",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/derived-from#digoxin-cyclosporine-knowledge-artifact"
        },
        {
          "label": "(Dorian et al. Clin Invest Med 1988; 11(2):108-112) ",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/citation#dorian1988"
        },
        {
          "label": "(Dorian et al. Transplant Proc. 1987; 19(1):1825-1827)",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/citation#dorian#1987"
        }
      ]
    },
    {
      "summary": "Within 100 days, the patient has had electrolyte and serum creatinine levels checked, and they are not on a potassium sparing or loop diuretic.",
      "indicator": "info",
      "detail": "(Potassium: 3.6mEq/L and 2020-04-28)\n (Magnesium: 0.8mmol/L and 2020-04-28)\n (Calcium: 8.6mg/dL and 2020-04-28)\n",
      "source": {
        "label": "Potential Drug-Drug Interaction Clinical Decision Support",
        "url": "http://hl7.org/fhir/ig/PDDI-CDS"
      },
      "suggestions": [
        {
          "label": "Serum Creatinine",
          "actions": [
            {
              "type": "create",
              "description": "Order for serum creatinine",
              "resource": {
                "resourceType": "ProcedureRequest",
                "id": "85d53af2-22ec-4441-8ecf-f71879779f2a",
                "status": "draft",
                "intent": "order",
                "code": {
                  "coding": [
                    {
                      "system": "http://snomed.info/sct",
                      "code": " 313822004",
                      "display": "Corrected serum creatinine"
                    }
                  ],
                  "text": "Serum Creatinine"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        },
        {
          "label": "Electrolyte Panel",
          "actions": [
            {
              "type": "create",
              "description": "Order for electrolyte panel",
              "resource": {
                "resourceType": "ProcedureRequest",
                "id": "8c6514e3-1d47-47b6-87b3-fc53ce8f6eb2",
                "status": "draft",
                "intent": "order",
                "code": {
                  "coding": [
                    {
                      "system": "http://snomed.info/sct",
                      "code": "271236005",
                      "display": "Serum potassium level"
                    },
                    {
                      "system": "http://snomed.info/sct",
                      "code": "312475002",
                      "display": "Plasma magnesium level"
                    },
                    {
                      "system": "http://snomed.info/sct",
                      "code": "390963002",
                      "display": "Plasma calcium level"
                    }
                  ],
                  "text": "Electrolyte Panel"
                },
                "subject": {
                  "reference": "f001"
                }
              }
            }
          ]
        }
      ],
      "links": [
        {
          "label": "digoxin-cyclosporine PDDI knowledge artifact",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/derived-from#digoxin-cyclosporine-knowledge-artifact"
        },
        {
          "label": "(Lip et al. Postgrad Med J. 1993; 69(811):337)",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/citation#lip1993"
        },
        {
          "label": "(Digoxin-FDA [prescribing information] NDA 20405/S-004)",
          "url": "http://hl7.org/fhir/ig/PDDI-CDS/citation#nda20405"
        }
      ]
    }
  ]
}
~~~

* Advanced – Digoxin + Cyclosporine Cards (With `filter-out-repeated-alerts`)

~~~
{
  "cards": [
    {
      "summary": "An alert was filtered because this request is configured to filter alerts if they were presented previously in response to a prior CDS Hook request.",
      "indicator": "info",
      "detail": "Since filter-out-repeated-alerts was set to true in this CDS Hook request, the service is filtering out cards that were triggered by the same knowledge artifact when the physician reference display, encounter id, and patient id match between the order-select and order-sign requests.",
      "source": {}
    }
  ]
}
~~~


# <span style="color:silver"> 3.4.0 </span> Basic Implementation for the Warfarin + NSAIDs Knowledge Artifact

Figure 8 depicts how a PDDI CDS implementer would translate a minimum information model narrative to a semi-structured knowledge artifact. The Basic Implementation uses a single CDS service call and response with the `order-sign` hook. The decision tree results in three warning indicators (i.e., green, orange, red) and contextual factors that MAY be passed to the clinician.  After processing the CDS Hooks `order-sign` request, the CDS service MUST return CDS Hooks Cards that MAY include actions with associated FHIR resources. Figure 9 builds on Figure 8 by depicting a Card display example within the order entry workflow. The decision points, `order-sign` request, and Card(s) response are discussed further in the sections below.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 8: Basic – Warfarin + NSAIDs Semi-Structured Knowledge </strong></figcaption>
  <a href = "assets/images/Basic_Warfarin_NSAID.svg" target ="_blank" > <img src= "assets/images/Basic_Warfarin_NSAID.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Warfarin_NSAID.svg" /></a>
</figure>

### <span style="color:silver"> 3.4.1 </span> Decision Points Summary
{:.no_toc}

Many PDDI CDS scenarios have similar drug and patient related decision points. Implementers SHOULD develop CQL artifacts that work in conjunction with the `order-sign` context and prefetch to support the base decision points. The Warfarin + NSAIDs PDDI exemplar as three main decision blocks that include:

1. whether the prescribed NSAID is topical diclofenac,

2. whether the patient is taking a proton pump inhibitor, and 

3. the presence or absence of risk factors involving age, exacerbating medications, and history of upper gastrointestinal bleed


### <span style="color:silver"> 3.4.2 </span> CDS Hooks Request
{:.no_toc}

The `order-sign` request includes `context` and `prefetch` elements with FHIR resource attributes or entire resources. The contents of these elements for the Warfarin + NSAIDs CDS artifact are shown below.

##### Context
{:.no_toc}

* [`order-sign 1.0`](https://cds-hooks.org/hooks/order-sign/) 

##### Prefetch
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
    

### <span style="color:silver"> 3.4.3 </span> CDS Hooks Cards
{:.no_toc}


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 9: Basic – Warfarin + NSAIDs Response Card Example </strong></figcaption>
  <a href = "assets/images/Basic_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Basic_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_W_N_Cards.svg" /></a>
</figure>


### <span style="color:silver"> 3.4.4 </span> Card Actions
{:.no_toc}

The CDS Hooks service response supports providing actionable information to clinicians at the time of medication order entry. A response Card has an `action` element within the suggestion attribute. The `action` element is defined by three types including `create, update, and delete.` Depending on the type of action, resources may be provided that facilitate the suggestion. For example, if a suggestion recommends substituting naproxen for acetaminophen, a `create` action may be used to apply a MedicationRequest for acetaminophen to the current order entry task. The actions, types and associated resources are listed below.  

* `create` 
    * Substituting NSAID for acetaminophen – MedicationRequest for acetaminophen 
    * Adding proton pump inhibitor – MedicationRequest for proton pump inhibitor
* `update` 
* `delete`
    * Remove current NSAID order 

> *Note:* These actions are options that SHOULD be customized to an institutions needs and capabilities. 

# <span style="color:silver"> 3.5.0 </span> Advanced Implementation - Warfarin + NSAIDs Knowledge Artifact

The Advanced Implementation for the Warfarin + NSAIDs artifact is split into two separate hooks and services. Figures 10 and 11 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both Hooks (i.e., `order-select` and `order-sign`). Figure 10 provides a Card display example for each CDS Hooks instance within the order entry workflow. In the provided Card display example, the clinician decided to order the NSAID medication but adds a proton pump inhibitor, in response to the card suggestion. This action results in a downgrade of the `medication-prescribe` response card (i.e., "critical" – red to "warning" – orange). 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 10: Warfarin + NSAIDs order-select logic </strong></figcaption>
  <a href = "assets/images/warfarin-nsaid-select.png" target ="_blank" > <img src="assets/images/warfarin-nsaid-select.png" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_select.svg" /></a>
</figure>




<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 11: Warfarin + NSAIDs order-sign logic </strong></figcaption>
  <a href = "assets/images/warfarin-nsaid-sign.png" target ="_blank" > <img src="assets/images/warfarin-nsaid-sign.png" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_prescribe.svg" /></a>
</figure>


### <span style="color:silver"> 3.5.1 </span> CDS Hooks request
{:.no_toc}


##### Context
{:.no_toc}

##### order-sign 1.0.
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | :----: | ----
`userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient 
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter
`selections`  | REQUIRED | No | *array* | The FHIR id of the newly selected order(s). The `selections` field references FHIR resources in the `draftOrders` Bundle. For example, `MedicationRequest/103`.
`draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


##### order-sign 1.1 (modification of a current CDS Hook)
 {:.no_toc}
 The base version for the `order-sign` hook is 1.0. The Advanced Implementation requires an additional context field. This modification is considered Minor but will change the version to 1.1.


 Field       | Optionality        |  Prefetch Token     |Type  | Description 
 :------------- |:-------------:|:-------: |:-----:| :-----------------
 `userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
 `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context 
 `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context 
 `draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


##### order-select prefetch
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

##### order-sign prefetch
{:.no_toc}

* Age of patient on current date.
    * [Patient](https://www.hl7.org/fhir/patient.html)
    
* Rolling 5-year look-back period for history of upper gastrointestinal bleed.
    * [Condition](https://www.hl7.org/fhir/condition.html)
    

### <span style="color:silver"> 3.5.2 </span> CDS Hooks Cards
{:.no_toc}


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 12: Warfarin + NSAIDs Cards </strong></figcaption>
  <a href = "assets/images/Advanced_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Advanced_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Advanced_W_N_Cards.svg" /></a>
</figure>

# <span style="color:silver"> 3.6.0 </span> Basic Implementation for the Digoxin + Cyclosporine Knowledge Artifact

Figure 13 depicts how a PDDI CDS implementer would translate a minimum information model narrative to a semi-structured knowledge artifact. The Basic Implementation uses a single CDS service call and response with the `order-sign` hook. The decision tree results in three warning indicators (i.e., green, orange, red) and contextual factors that MAY be passed to the clinician.  After processing the CDS Hooks `order-sign` request, the CDS service MUST return CDS Hooks Cards that MAY include actions with associated FHIR resources. Figure 14 builds on Figure 13 by depicting a Card display example within the order entry workflow. The decision points, `order-sign` request, and Card(s) response are discussed further in the sections below.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 13: Basic – Digoxin + Cyclosporine Semi-Structured Knowledge </strong></figcaption>
  <a href = "assets/images/Basic_Digoxin_Cyclosporine.svg" target ="_blank" > <img src= "assets/images/Basic_Digoxin_Cyclosporine.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Digoxin_Cyclosporine.svg" /></a>
</figure>

### <span style="color:silver"> 3.6.1 </span> Decision Points Summary
{:.no_toc}

The Digoxin + Cyclosporine exemplar artifact has two main decision blocks:

1. whether the patient is taking digoxin and/or cyclosporine at the time of the current order for digoxin or cyclosporine, and

2. whether the patient has risk factors that may potentiate the risk of digitalis toxicity. 


### <span style="color:silver"> 3.6.2 </span> CDS Hooks Request
{:.no_toc}

The `order-sign` request includes `context` and `prefetch` elements with FHIR resource attributes or entire resources. The contents of these elements for the Digoxing + Cyclosporine CDS artifact are shown below.

##### Context
{:.no_toc}

* [`order-sign 1.0`](https://cds-hooks.org/hooks/order-sign/) 

##### Prefetch
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
        

### <span style="color:silver"> 3.6.3 </span> CDS Hooks Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 14: Basic – Digoxin + Cyclosporine Response Card Example </strong></figcaption>
  <a href = "assets/images/Level_1_D_C_Cards.svg" target ="_blank" > <img src="assets/images/Level_1_D_C_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Level_1_D_C_Cards.svg" /></a>
</figure>

### <span style="color:silver"> 3.6.4 </span> Card Actions
{:.no_toc}

The CDS Hooks service response supports providing actionable information to clinicians at the time of medication order entry. A response Card has an `action` element within the suggestion attribute. The `action` element is defined by three types including `create, update, and delete.` Depending on the type of action, resources may be provided that facilitate the suggestion. For example, if a suggestion recommends substituting naproxen for acetaminophen, a `create` action may be used to apply a MedicationRequest for acetaminophen to the current order entry task. The actions, types and associated resources are listed below.  

* `create` 
    * Adding order for digoxin level measure – ProcedureRequest for serum digoxin trough within 24 hours 
    * Add consultation for either prescriber of digoxin or cyclosporine depending on which the patient is currently taking – ProcedureRequest consultation
    * Add order for electrolyte panel(s) (i.e., calcium, magnesium, potassium) and renal function (e.g., eGRF and serum creatinine) – ProcedureRequest for labs to be drawn
* `update` 
    * Reduce digoxin order currenlty on the patient's profile – MedicationRequest for low-dose digoxin
* `delete`
    * Remove current order for digoxin or cyclosporine 

> *Note:* These actions are options that SHOULD be customized to an institutions needs and capabilities. 

# <span style="color:silver"> 3.7.0 </span> Advanced Implementation - Digoxin + Cyclosporine Knowledge Artifact

The Advanced Implementation for the Digoxin + Cyclosporine artifact is split into two separate hooks and services. Figures 15 and 16 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both Hooks (i.e., `order-select` and `order-sign`). Figure 10 provides a Card display example for each CDS Hooks instance within the order entry workflow. In the provided Card display example, the clinician decided to order the NSAID medication but adds a proton pump inhibitor, in response to the card suggestion. This action results in a downgrade of the `medication-prescribe` response card (i.e., "critical" – red to "warning" – orange). 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 15: Digoxin + Cyclosporine order-select logic </strong></figcaption>
</figure>




<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 16: Digoxin + Cyclosporine order-sign logic </strong></figcaption>
  <a href = "assets/images/digoxin-cylcosporine-sign.png" target ="_blank" > <img src="assets/images/digoxin-cylcosporine-sign.png" class="figure-img img-responsive img-rounded center-block" alt="digoxin-cylcosporine-sign.png" /></a>
</figure>


### <span style="color:silver"> 3.7.1 </span> CDS Hooks request
{:.no_toc}


##### Context
{:.no_toc}

##### order-sign 1.0.
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | :----: | ----
`userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
`patientId` | REQUIRED | Yes | *string* | The FHIR Patient.id of the current patient 
`encounterId` | OPTIONAL | Yes | *string* | The FHIR Encounter.id of the current encounter
`selections`  | REQUIRED | No | *array* | The FHIR id of the newly selected order(s). The `selections` field references FHIR resources in the `draftOrders` Bundle. For example, `MedicationRequest/103`.
`draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


##### order-sign 1.1 (modification of a current CDS Hook)
 {:.no_toc}
 The base version for the `order-sign` hook is 1.0. The Advanced Implementation requires an additional context field. This modification is considered Minor but will change the version to 1.1.


 Field       | Optionality        |  Prefetch Token     |Type  | Description 
 :------------- |:-------------:|:-------: |:-----:| :-----------------
 `userId` | REQUIRED | Yes | *string* | The id of the current user. For this hook, the user is expected to be of type Practitioner. For example, `Practitioner/123Describe`
 `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context 
 `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context 
 `draftOrders` | REQUIRED     | No |    *object* | R4 - FHIR Bundle of *draft* MedicationRequest resource for the current order entry task


##### order-select prefetch
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

##### order-sign prefetch
{:.no_toc}

* Rolling 100-day look-back period for digoxin concentration
    * [Observation](https://www.hl7.org/fhir/observation.html)

* Rolling 100-day look-back period for serum creatinine
    * [Observation](https://www.hl7.org/fhir/observation.html)
    
* Rolling 100-day look-back period for electrolytes including: potassium, magnesium, and calcium
    * [Observation](https://www.hl7.org/fhir/observation.html)


### <span style="color:silver"> 3.7.2 </span> CDS Hooks Cards
{:.no_toc}


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 17: Digoxin + Cyclosporine Cards </strong></figcaption>
  <a href = "assets/images/Level_2_D_C_Cards.svg" target ="_blank" > <img src="assets/images/Level_2_D_C_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Level_2_D_C_Cards.svg" /></a>
</figure>

# <span style="color:silver"> 3.8.0 </span> CDS Message Filtering

The following tables have been created to better conceptualize the various scenarios where message filtering may occur 
for the clinician during `order-sign`. The assumptions used when creating these tables are that `cache-for-order-sign-filtering` 
and `filter-out-repeated-alerts` for both `order-select` and `order-sign` are set to TRUE. During `order-select` the 
following items are cached in order to properly handle message filtering.

* Ordering Clinician
* Patient
* Encounter
* Knowledge Artifact URL
* Base 64 encoded medication resource specified in `selections`
* An ID created by concatenating the system and code from the “medicationCodeableConcept” of the medication resource (used for retrieving a medication resource during `order-sign`)
* Base 64 encoded summary, detail, and indicator from the CDS cards returned

### <span style="color:silver"> 3.8.1 </span> Scenario - Order-select with 1 medication that triggers a branch
{:.no_toc}

Clinician A calls order-select with 1 medication in `draftOrders` that triggers a branch of the rules then calls order-sign.
> *Note:* CDS hooks do not couple `indicators` with `suggestions`.

| Indicator for the branch triggered | Service suggested action | Clinician accepts suggested action | Will alert be filtered | Description                                                                                        |
| ---------------------------------- | ------------------------ | ---------------------------------- | ---------------------- | -------------------------------------------------------------------------------------------------- |
| Info                               | Create/Update/Delete     | FALSE                              | TRUE                   | Only message received is non-serious, no action is taken and alert will be filtered on order-sign  |
| Info                               | Create                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |
| Info                               | Update                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |
| Info                               | Delete                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |
| Warning                            | Create/Update/Delete     | FALSE                              | TRUE                   | Warning message received, no additional action taken, alert will be filtered on order-sign         |
| Warning                            | Create                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |
| Warning                            | Update                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |
| Warning                            | Delete                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |
| Critical                          | Create/Update/Delete     | FALSE                              | TRUE                   | Critical message received, no additional action taken, alert will be filtered on order-sign       |
| Critical                          | Create                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |
| Critical                          | Update                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |
| Critical                          | Delete                   | TRUE                               | FALSE                  | If action taken does not trigger a new order-select call, alert will not be filtered on order-sign |


### <span style="color:silver"> 3.8.2 </span> Scenario - Order-select with more than 1 medication that triggers a branch
{:.no_toc}

Each medication request specified in `selections` will be cached for message filtering on `order-sign`, this scenario will operate just as above.


### <span style="color:silver"> 3.8.3 </span> Scenario - Order-select is called by 2 different clinicians before order-sign
{:.no_toc}

Clinician A goes through an `order-select` process, for some reason is not able to start the `order-sign` process immediately. Clinician B then goes through the `order-select` and `order-sign` process for the same patient.

| Branch triggered for clinician A | Branch triggered for clinician B | Will alert be filtered | Description                                                                           |
| -------------------------------- | -------------------------------- | ---------------------- | ------------------------------------------------------------------------------------- |
| Info                             | Info                             | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |
| Warning                          | Warning                          | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |
| Critical                        | Critical                        | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |
| Info                             | Warning                          | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |
| Info                             | Critical                        | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |
| Warning                          | Info                             | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |
| Warning                          | Critical                        | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |
| Critical                        | Info                             | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |
| Critical                        | Warning                          | FALSE                  | Because the clinician IDs are different the alerts will not be filtered on order-sign |

### <span style="color:silver"> 3.8.4 </span> Scenario - Order-select is called more than once before order-sign by same the same clinician
{:.no_toc}

Clinician A starts the `order-select` process, gets interrupted and prevented from beginning the `order-sign` processes (potential network issues or other problems arise). Clinician A then goes through the `order-select` process again before completing `order-sign`.

| Branch triggered for both order-selects | Will alert be filtered | Description                                                                                                                                            |
| --------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Info                                    | TRUE                   | Message filtering is never performed on the messages returned from an order-select call. All messages will be filtered normally on the order-sign call |
| Warning                                 | TRUE                   | Message filtering is never performed on the messages returned from an order-select call. All messages will be filtered normally on the order-sign call |
| Critical                               | TRUE                   | Message filtering is never performed on the messages returned from an order-select call. All messages will be filtered normally on the order-sign call |


### <span style="color:silver"> 3.8.5 </span> Scenario - Order-select is called multiple times with updates to the draft orders
{:.no_toc}
Clinician A starts the `order-select` process with 1 medication in the draft orders that triggers a rule set. Clinician A
 then add a second medication to draft orders which triggers a different rule set. Clinician A then begins the `order-sign` 
 process with both medications in the draft orders. 

| Indicator for the branch triggered (medication 1) | Indicator for the branch triggered (medication 2) | Will alerts be filtered | Description                                                                                                                                                                                                                                                                |
|---------------------------------------------------|---------------------------------------------------|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Info                                              | Info                                              | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |
| Info                                              | Warning                                           | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |
| Info                                              | Critical                                          | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |
| Warning                                           | Info                                              | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |
| Warning                                           | Warning                                           | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |
| Warning                                           | Critical                                          | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |
| Critical                                          | Info                                              | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |
| Critical                                          | Warning                                           | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |
| Critical                                          | Critical                                          | TRUE                    | Message filtering will be performed. No change in the ordering clinician, patient, encounter, and knowledge artifact URL. The CDS card is cached as well to ensure repeated messages are not shown even if the rule set that is triggered by each medication is different. |

### <span style="color:silver"> 3.8.6 </span> Scenario - Order-select is called with a long gap of time before order-sign
{:.no_toc}

Clinician A completes the `order-select` process, something prevents them from starting `order-sign` for a long period of time.

> *Note:* There is currently no time-out period or expiration for cached medications to reset `order-sign` message filtering

| Branch triggered | Time-out set | Will alert be filtered | Description                                                                                                                   |
| ---------------- | ------------ | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Info             | FALSE        | TRUE                   | Message filtering will be performed as normal                                                                                 |
| Info             | TRUE         | FALSE                  | If a time-out is set and the time between order-select and order-sign exceeds that period, there will be no message filtering |
| Warning          | FALSE        | TRUE                   | Message filtering will be performed as normal                                                                                 |
| Warning          | TRUE         | FALSE                  | If a time-out is set and the time between order-select and order-sign exceeds that period, there will be no message filtering |
| Critical        | FALSE        | TRUE                   | Message filtering will be performed as normal                                                                                 |
| Critical        | TRUE         | FALSE                  | If a time-out is set and the time between order-select and order-sign exceeds that period, there will be no message filtering |


### <span style="color:silver"> 3.8.7 </span> Scenario - Order-select is called for patient A but order-sign is completed after the same clinician sees another patient
{:.no_toc}

Since the patient ID is used to create a unique cached medication statement, if a clinician completes the `order-select` with patient 
A but does an `order-select`/`order-sign` with patient B before completing `order-sign` for patient A, the message filtering
 will not be affected. This may be another situation where a time-out could be beneficial for the clinician so that messages will not be filtered.
Another solution would be to track if a clinician completes `order-select` for a new patient before completing `order-sign` for their initial patient.

### <span style="color:silver"> 3.8.8 </span> Scenario - Order-select and order-sign are completed by 2 different clinicians
{:.no_toc}

Clinician A completes the `order-select` process and clinician B completes `order-sign`.

| Branch triggered for both order-select and order-sign | Will alert be filtered | Description                                                                     |
| ----------------------------------------------------- | ---------------------- | ------------------------------------------------------------------------------- |
| Info                                                  | FALSE                  | Since the clinicians are different there will be no message filtering performed |
| Warning                                               | FALSE                  | Since the clinicians are different there will be no message filtering performed |
| Critical                                             | FALSE                  | Since the clinicians are different there will be no message filtering performed |


### <span style="color:silver"> 3.8.9 </span> Scenario - Order-select with no medications that trigger rule
{:.no_toc}

No cards to be filtered are returned.

