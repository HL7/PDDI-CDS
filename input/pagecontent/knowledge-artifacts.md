
### Clinical Reasoning
{:.no_toc}

This section describes the components and processes of the Clinical Reasoning module used for the PDDI CDS artifacts. The Clinical Reasoning module provides resources and operations to enable sharing and evaluation of clinical knowledge artifacts. For the PDDI CDS artifacts this encompasses the `PlanDefinition`, `CarePlan`, `RequestGroup`, and CQL libraries. 

> *Note:* While resources and CQL libraries are specified for this implementation guide, these are not required for PDDI CDS functionality. The `PlanDefinition`, however, is RECOMMENDED to create sharable PDDI knowledge artifacts.

#### PlanDefinition
{:.no_toc}

In the FHIR resource [workflow](https://www.hl7.org/fhir/workflow.html), the PlanDefinition resource is categorized as a definition. Resources in this category define an action that can occur with a patient. There are four main elements of the `PlanDefinition` that are used for the PDDI CDS instances. These elements include `TriggerDefinition,` `Condition,` `DynamicValue,` and `Action.` 

**TriggerDefinition**
{:.no_toc}

The `TriggerDefinition` uses the Name Event, which allows triggering of an event opposed to a scheduled or fixed event. The `TriggerDefinition` for a `PlanDefinition` written for PDDI CDS MUST be based on one of the CDS Hooks requests `order-sign` and `order-select.`

~~~
"triggerDefinition": {
              "type": "named-event",
              "eventName": "order-sign"
~~~
~~~
"triggerDefinition": {
              "type": "named-event",
              "eventName": "order-select"
~~~              

**Condition**
{:.no_toc}

The `condition` element is used to determine whether or not the CDS logic is to be applied and the language that the logic is written in. If the `condition` is satisfied (i.e., true or false), an action(s) is initiated.

~~~
"condition": [
              {
                "kind": "applicability",
                "language": "text/cql",
                "expression": "Inclusion Criteria"
~~~                

**Action**
{:.no_toc}

The `Action` element provides the specific action(s) and associated information. Only one action can be taken for each group, which is reflected by the Card actions where the user can only select one action per suggestion. 

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

**DynamicValue**
{:.no_toc}

The `DynamicValue` enables customization of the statically defined resources. Since each decision block for PDDIs have one or more individualized information components, integrating patient-specific and product-specific data into Card elements is facilitated by the `DynamicValue` element.

~~~
"action": [
                  {
                    "label": "Assess risk and take action if necessary.",
                    "dynamicValue": [
                      {
                        "path": "action.label",
                        "expression": "Get Card 2 Label"
~~~


#### CarePlan and RequestGroup 
{:.no_toc}


The FHIR resource [workflow](https://www.hl7.org/fhir/workflow.html) categorizes the `CarePlan` and `RequestGroup` resources as requests, thereby expressing the intention for something to occur. The CDS service creates a `CarePlan` that references a `RequestGroup` for each CDS Hook response Card. As an example, in this implementation guide, the Warfarin + NSAID artifact creates four response cards, each containing minimum information model elements and associated actions. The `CarePlan` references four `RequestGroup` resources under the the `activity` element. The `RequestGroup` `action` element provides the suggestions and actions in the response card. The `CarePlan` and `RequestGroup` resources are subsequently transformed into a CDS Hooks Card response and sent to the EHR. 


### CQL Library
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

It is RECOMMENDED that a CDS rule execution engine for PDDI CDS be able to execute CDS rules written in [CQL](https://ecqi.healthit.gov/cql-clinical-quality-language). CQL was developed by HL7 for clinical experts to express knowledge in an author-friendly and human-readable but computable language.

All artifact logic using CQL are wrapped in a container called a library. There is a set of declarations documented in the [CQL Specification](http://cql.hl7.org) that need to be defined to provide information about the library. Those declarations are Library, Data Models, Libraries, Terminology, Parameters, Context and Statements.

#### Declarations
{:.no_toc}

**Library**
{:.no_toc}

The library declaration defines the library name used as an identifier for other CQL libraries to reference. The version is an optional declaration.

~~~
   library Warfarin_NSAIDs_CDS version '1.0'
~~~

**Data Models**
{:.no_toc}

Data models define the structures that can be used within retrieve expressions in the library.

~~~
   using FHIR version '3.0.0'
~~~

For the PDDI CDS artifacts, FHIR model, version 3.0.0 is used as the primary data model within the library. The data model supports all [FHIR R4](https://www.hl7.org/fhir/index.html) resources including MedicationRequest, MedicationStatement, MedicationAdministration, MedicationDispense, Observation, and Condition.

**Libraries**
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

**Terminology**
{:.no_toc}

A value set declaration specifies a local identifier that represents a value set and can be used anywhere within the library.

~~~
  valueset "Warfarins": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-warfarin'
~~~

This definition establishes the local identifier `Warfarins` as a reference to the external identifier for the value set, an uniform resource identifier (URI) in this case is `http://hl7.org/fhir/uv/pddi/ValueSet/valueset-warfarin`. The external identifier should be an ID or a uniform resource identifier (URI).

This valueset definition can then be used within the library wherever a valueset can be used:

~~~
  define "Warfarin Rx":
    [MedicationRequest: "Warfarins"] MR
      where MR.authoredOn.value in Interval[Today() - 100 days, null]
~~~

The above statement collects all MedicationRequest resources with a code in the `Warfarins` value set and the authored date within 100-day look-back period.

For the PDDI CDS value sets, refer to [Terminology](terminology.html) page for the list of value sets used by this implementation.

**Parameters**
{:.no_toc}

The parameters defined in a library MAY be referenced by name in any expression within the library. 

~~~
parameter ContextPrescriptions List<MedicationRequest>
~~~

The `context` element of CDS Hook request contains the MedicationRequest resources specified in `medications` element as described in the example below. The data is parsed and assigned to the `ContextPrescriptions` parameter defined in the library.

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

**Context**
{:.no_toc}

The context declaration defines the overall context for statements within the library.

~~~
context Patient
~~~

The `context Patient` declaration to restrict the information that will be returned from a retrieve of a single patient.

**Statements**
{:.no_toc}

`Define` statements describing named expressions that can be referenced either from other expressions within the same library or by containing decision support artifacts.

~~~
define "GI Bleeds Condition":
  Last(
    [Condition: "History of GI Bleeds"] C
      sort by assertedDate.value
  )
~~~

This example defines the `GI Bleeds Condition` statement, which retrieves the most recent condition with a code in the `History of GI Bleeds` value set.

#### Connection of CQL to PlanDefinition
{:.no_toc}

**Library**
{:.no_toc}

The Library resource contains the CQL library in base64 format. As an example below, the CQL library is encoded to base64 format and stored by using the Library FHIR resource.

In Library resource, the `relatedArtifact` element defines the dependent relationship between libraries. For example, `warfarin-nsaids-cds` library references the `PDDICDS_Common` library and that relationship is described in the `relatedArtifact` element.

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

When the Clinical Reasoning module processes the data, the library resource is loaded from local FHIR server and then the logic content in base64 format is decoded. If the content is in CQL format, it is translated into ELM XML format which is a machine-readable canonical representation.

For the best performance, the CQL logic should be translated into ELM XML format before being stored in the Library resource. This will enable the Clinical Reasoning module to execute the CQL logic without performing the translation.

**PlanDefinition**
{:.no_toc}

In PlanDefinition resource, the `library` element defines the reference to the logic used by the PlanDefinition. An example for `warfarin-nsaids-cds` PlanDefinition resource is the reference to `Library/warfarin-nsaids-cds` Library resource. 

~~~
"library": [
  {
    "reference": "Library/warfarin-nsaids-cds"
  }
],
~~~

This library contains the logic used by the PlanDefinition to establish the condition, and to dynamically construct the guidance so that it reflects the data for the current patient.

As described in the `condition` element of the PlanDefinition section, the Clinical Reasoning module will load the statement in the `condition` element defined in the CQL library. Then the statement will be evaluated by the CQL engine. For example, the `Inclusion Criteria` statement in the library below will be loaded and evaluated to determine whether or not the condition is satisfied.

~~~
define "Inclusion Criteria":
  if "Is context medication topical diclofenac"
    then "Is warfarin in prefetch"
  else (
    "Is context medication systemic NSAID"
      and "Is warfarin in prefetch"
  )

define "Is context medication topical diclofenac":
  exists ("Topical Diclofenac Prescription")

define "Topical Diclofenac Prescription":
  ContextPrescriptions P
    where Common.ToCode(P.medication.coding[0]) in "Topical Diclofenac"

define "Is warfarin in prefetch":
  exists ("Warfarin Rx")

define "Warfarin Rx":
  [MedicationRequest: "Warfarins"] MR
    where MR.authoredOn.value in Interval[Today() - 100 days, null]

define "Is context medication systemic NSAID":
  exists ("NSAID Prescription")

define "NSAID Prescription":
  ContextPrescriptions P
    where Common.ToCode(P.medication.coding[0]) in "NSAIDs"
~~~

Similar to `condition` element, `dynamicValue` element within the `action` element allows to customize the card content depending on the logic defined in the library. As an example, the `Get Base Summary` statement below specified in `dynamicValue` element will be evaluated, and the dynamic content containing medication names will be returned.

~~~
define "Get Base Summary":
  'Potential Drug-Drug Interaction between warfarin (' 
    + Common.GetMedicationNames("Warfarin Rx") 
    + ') and NSAID (' 
    + Common.GetMedicationNames("NSAID Prescription")
    + ').'

define "Get Base Detail":
  'Increased risk of bleeding.'

define "Get Base Indicator":
  if "Is context medication topical diclofenac"
    then 'info'
  else 'warning'
~~~

### Knowledge Artifacts 
{:.no_toc}

The following artifacts represent the behavior for implementing PDDI CDS:

| Resource | Type | Description |
| --- | --- | --- |
| [FHIRHelpers v3.0.0 Library](artifacts/FhirHelpers_v3.0.0-library.json) | [Library](https://www.hl7.org/fhir/library.html) |  |
| [FHIRHelpers v3.0.0 Library ELM](artifacts/FhirHelpers_v3.0.0_elm.xml) | [Library](https://www.hl7.org/fhir/library.html) |  |
| [FHIRHelpers v3.0.0 CQL](artifacts/FhirHelpers_v3.0.0.cql) | CQL Source |  |
| [Common PDDI-CDS Library](artifacts/pddi-cds-common-library.json) | [Library](https://www.hl7.org/fhir/library.html) | CQL Library that provides common logic for the recommendations |
| [Common PDDI-CDS CQL](artifacts/pddi-cds-common-logic.cql) | CQL Source | For reference, the complete CQL source for the common logic. |
| [Warfarin NSAIDs Select PlanDefinition](artifacts/warfarin-nsaids/warfarin-nsaids-cds-plandefinition.json)  |	[PlanDefinition](https://www.hl7.org/fhir/plandefinition.html)  | Event-Condition-Action rule that implements behavior for Warfarin NSAIDs Recommendation |
| [Warfarin NSAIDs Sign PlanDefinition](artifacts/warfarin-nsaids/warfarin-nsaids-cds-plandefinition-sign.json)  |	[PlanDefinition](https://www.hl7.org/fhir/plandefinition.html)  | Event-Condition-Action rule that implements behavior for Warfarin NSAIDs Recommendation |
| [Warfarin NSAIDs Select Library](artifacts/warfarin-nsaids/warfarin-nsaids-cds-library.json) | [Library](https://www.hl7.org/fhir/library.html) | Defines the data requirements to support evaluation of Warfarin NSAIDs recommendation |
| [Warfarin NSAIDs Sign Library](artifacts/warfarin-nsaids/warfarin-nsaids-cds-library-sign.json) | [Library](https://www.hl7.org/fhir/library.html) | Defines the data requirements to support evaluation of Warfarin NSAIDs recommendation |
| [Warfarin NSAIDs CQL](artifacts/warfarin-nsaids/warfarin-nsaids-cds-logic.cql) | CQL Source | For reference, the complete CQL source for Warfarin NSAIDs recommendation |
| [Warfarin NSAIDs ActivityDefinition](artifacts/warfarin-nsaids/activitydefinition-bundle.json) | Example Activity Definition Bundle |  |
| [Digoxin Cyclosporine Select PlanDefinition](artifacts/digoxin-cyclosporine/digoxin-cyclosporine-cds-plandefinition.json)  |	[PlanDefinition](https://www.hl7.org/fhir/plandefinition.html)  | Event-Condition-Action rule that implements behavior for Digoxin Cyclosporine Recommendation |
| [Digoxin Cyclosporine Sign PlanDefinition](artifacts/digoxin-cyclosporine/digoxin-cyclosporine-cds-plandefinition-sign.json)  |	[PlanDefinition](https://www.hl7.org/fhir/plandefinition.html)  | Event-Condition-Action rule that implements behavior for Digoxin Cyclosporine Recommendation |
| [Digoxin Cyclosporine Select Library](artifacts/digoxin-cyclosporine/digoxin-cyclosporine-cds-library.json) | [Library](https://www.hl7.org/fhir/library.html) | Defines the data requirements to support evaluation of Digoxin Cyclosporine recommendation |
| [Digoxin Cyclosporine Sign Library](artifacts/digoxin-cyclosporine/digoxin-cyclosporine-cds-library-sign.json) | [Library](https://www.hl7.org/fhir/library.html) | Defines the data requirements to support evaluation of Digoxin Cyclosporine recommendation |
| [Digoxin Cyclosporine CQL](artifacts/digoxin-cyclosporine/digoxin-cyclosporine-cds-logic.cql) | CQL Source | For reference, the complete CQL source for Digoxin Cyclosporine recommendation |
| [Digoxin Cyclosporine ActivityDefinition](artifacts/digoxin-cyclosporine/activitydefinition-bundle.json) | Example Activity Definition Bundle |  |
