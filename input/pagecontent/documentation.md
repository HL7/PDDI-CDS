
# <span style="color:silver"> 6.0.0 </span> Documentation

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

## <span style="color:silver"> 6.1.0 </span> Preliminaries
{:.no_toc}

This section contains documentation on how to implement PDDI CDS artifacts from a clinical and technical perspective. Implementation details are described using two specific knowledge artifacts as examples.
## <span style="color:silver"> 6.2.0 </span> CPOE Workflow Hooks
{:.no_toc}

Figure 1 depicts hook triggers for Level 1 and 2 Implementations. The primary difference in the Level 2 Implementation is the additional `order-select` hook defining the initial trigger at the start of the CPOE workflow. The Level 1 Implementation follows the [CDS Hooks `order-sign`](https://cds-hooks.org/hooks/order-sign/) specification that defines the triggering event as when a clinician is ready to sign one or more medication orders for a patient. This hook is among the last workflow events before an order is promoted out of a draft status..

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Level 1 versus Level 2 Implementation Hooks </strong></figcaption>
  <a href = "assets/images/CPOE_workflow_2.svg" target ="_blank" > <img src= "assets/images/CPOE_workflow_2.svg" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow_2.svg" /></a>
</figure>

## <span style="color:silver"> 6.3.0 </span> Prefetch Role
{:.no_toc}

For technical implementers, the intended role of prefetch is to improve the CDS service performance. This is achieved by minimizing CDS service network calls to external resources such as a FHIR server. When a client program subscribes to the PDDI CDS service, the service MUST return a prefetch specification in the response. This specification identifies resources that the PDDI CDS service SHOULD receive upon request. As described below, the prefetch requirements are different for `order-select` and `order-sign` services. The ideal scenario for both implementations and services is to send prefetch data with the CDS Hooks request. The implementor has flexibility on when and how to fulfill the prefetch templates (e.g., data in EHR memory or server call), which will likely result in a solution that reduces the burden of the server and improves the CDS service efficiency. If the CDS service does not receive prefetch data in the request it MUST query the server via network call.

# <span style="color:silver"> 7.0.0 </span> Warfarin + NSAIDs

## <span style="color:silver"> 7.1.0 </span> The Warfarin + NSAIDs Knowledge Artifact
{:.no_toc}

The  Warfarin + NSAIDs knowledge artifact represents a relatively complex contextualized PDDI CDS algorithm. The knowledge artifact contains logic that uses both drug and patient contextual factors. The original rule was developed by clinical experts as part of the W3C Community Group effort to develop a PDDI minimal information model. Table 1 is the Warfarin + NSAIDs knowledge artifact at the narrative level using the minimal information model.

#### Table 1. Warfarin + NSAIDs Minimal Information Model
{:.no_toc}

<div>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Drugs involved</strong>: Warfarin and non-steroidal anti-inflammatory drugs (NSAIDs)</td>
      </tr>
      <tr>
	<td>
	  <strong>Comment:</strong> The drugs involved in a PDDI MUST be explicitly stated. To support a computable representation of the PDDI, the drugs involved SHOULD be listed as sets of terms from a terminology such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a> or the <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Clinical Consequences</strong>: Increased risk of bleeding including gastrointestinal bleeding,  intracranial hemorrhage,  and cerebral hemorrhage</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The clinical consequences associated with a PDDI MUST be reported if known. Clinical consequences SHOULD refer health outcomes as specifically as possible. To support a computable representation of the PDDI, clinical consequences SHOULD be represented as one or more sets of terms from a terminology such as <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a> or <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Seriousness</strong>: Bleeding is a serious potential clinical consequence because it can result in death, life-threatening hospitalization, and disability. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> A PDDI clinical consequence MUST be noted as <i>serious</i> if it can result in death, life-threatening hospitalization, congenital anomaly, disability, or if it requires intervention to prevent permanent impairment or damage.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Severity</strong>: While bleeding is a serious potential clinical consequence, severity can vary from easily tolerated to incapacitating </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The severity of a PDDI clinical consequence MUST be reported if known. The severity of a PDDI clinical consequence MUST be noted using non-ambiguous terms or phrases. Any of the existing terminologies for adverse event severity, such as <a href="https://wiki.nci.nih.gov/display/VKC/Common+Terminology+Criteria+for+Adverse+Events+FAQ">Common Terminology Criteria for Adverse Event (CTCAE)</a>, MAY be used for describing a PDDI clinical consequence.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Mechanism of Interaction</strong>: Non-steroidal anti-inflammatory drugs (NSAIDs) have
          antiplatelet effects which increase the bleeding risk when combined with oral anticoagulants such as
          warfarin. The antiplatelet effect of NSAIDs lasts only as long as the NSAID is present in the circulation,
          unlike aspirin’s antiplatelet effect, which lasts for up to 2 weeks after aspirin is discontinued. NSAIDs also
          can cause peptic ulcers and most of the evidence for increased bleeding risk with NSAIDs plus warfarin is due to
          upper gastrointestinal bleeding (UGIB).</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The mechanism of a PDDI MUST be reported if known. The description SHOULD be written for a clinician audience and include details that help the clinician decide what course of management action to take. To reduce ambiguity, the description MAY refer to specific drugs or health conditions using codes from terminologies. </td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Recommended Action</strong>: If the NSAID is being used as an analgesic or antipyretic,
          it would be prudent to use an alternative such as acetaminophen. In some people, acetaminophen can
          increase the anticoagulant effect of warfarin, so monitor the INR if acetaminophen is used in doses
          over 2 g/day for a few days. For more severe pain consider short-term opioids in place of the NSAID.</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Any recommended actions that apply to all patient exposures SHOULD be stated using clear and concise language. The recommended action statement SHOULD also provide citations to <a href="http://purl.obolibrary.org/obo/MPIO_0000004" target="new">evidence for a suspected drug-drug interaction</a> (not provided in this example). Recommendations that depend on <a href="http://purl.obolibrary.org/obo/MPIO_0000000" target="new">contextual information/modifying factors</a> SHOULD be mentioned separately to support context-specific presentation of such information.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Contextual information/modifying factors</strong>:
          <ol>
            <li>The NSAIDs is topical diclofenac</li>
            <ul>
              <li><strong>Recommended Action:</strong> No special precautions</li>
              <li><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> Topical diclofenac has relatively
		low systemic absorption; in one study a topical gel (16 g/day) produced about 6% of
		the absorption seen with systemic administration of 150 mg/day. A higher than recommended
		dose of topical gel (48 g/day) produced 20% of a systemic dose of diclofenac.</li>
            </ul>
            <li>The NSAID is NOT topical diclofenac but the patient is concomitantly taking a
              proton pump inhibitor or misoprostol</li>
            <ul>
              <li><strong>Recommended Action:</strong> Assess risk and take action if necessary</li>
              <li><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> Proton pump inhibitors and misoprostol may reduce the risk of UGIB in patients receiving NSAIDs and warfarin. </li>
            </ul>
            <li>The NSAID is NOT topical diclofenac, the patient is NOT concomitantly taking a proton pump inhibitor or misoprostol, and the patient has one or more of the following risk factors:</li>
            <ul>
              <li>History of upper gastrointestinal bleeding (UGIB) or peptic ulcer or age > 65 years old</li>
              <ul>
		<li><strong>Recommended Action:</strong> Use only if benefit outweighs risk</li>
		<li><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> Patients with a
                  history of UGIB or peptic ulcer may have an increased risk of UGIB from this interaction.
                  The extent to which older age is an independent risk factor for UGIB due to these interactions
                  is not firmly established, but UGIB in general is known to increase with age.</li>
              </ul>
              <li>Concomitantly taking systemic corticosteroids, aldosterone antagonists, or high dose or multiple NSAIDs</li>
              <ul>
		<li><strong>Recommended Action:</strong> Use only if benefit outweighs risk</li>
		<li><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> Both corticosteroids
                  and aldosterone antagonists have been shown to substantially increase the risk of UGIB in
                  patients on NSAIDs, with relative risks of 12.8 and 11 respectively compared
                  to a risk of 4.3 with NSAIDs alone (<a href='https://www.ncbi.nlm.nih.gov/pubmed/24937265'>Masclee *et al.* 2014</a>)</li>
              </ul>
            </ul>
          </ol>
	</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> <a href='http://purl.obolibrary.org/obo/MPIO_0000000' target="new">Contextual information/modifying factors</a> are necessary for alerts that
          are both sensitive and specific. Like clinical consequences, each known factor SHOULD be
          stated as specifically as possible. The factors SHOULD be amenable to implementation as executable
          logic using value sets from clinical terminologies such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a>, the
	  <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>, <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a>, and <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. As is used in this
          example, each factor SHOULD be related to a specific <a href='http://purl.obolibrary.org/obo/MPIO_0000008' target="new">recommended action</a> that is supported by the <a href='http://purl.obolibrary.org/obo/MPIO_0000004' target="new">evidence for a suspected drug-drug interaction</a></td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Frequency of Exposure to the PDDI:</strong> Unknown</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Frequency of exposure and frequency of harm information is
          rarely available but can help a clinician assess the risk/benefit trade-off of exposure to PDDI. Such information SHOULD be provided if available. </td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Frequency of Harm for persons who have been exposed to the PDDI:</strong> Unknown</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Frequency of exposure and frequency of harm information is
          rarely available but can help a clinician assess the risk/benefit trade-off of exposure to PDDI. Such information SHOULD be provided if available. </td>
      </tr>
    </table>
</div>

## <span style="color:silver"> 7.2.0 </span> Level 1 Implementation - Warfarin + NSAIDs Knowledge Artifact (semi-structured)

Figure 2 depicts how a PDDI CDS implementer would translate a minimal information model narrative to a semi-structured knowledge artifact. The Level 1 Implementation uses a single CDS service call and response with the `order-sign` hook. The decision tree results in three warning indicators (i.e., green, orange, red) and contextual factors that MAY be passed to the clinician.  After processing the CDS Hooks `order-sign` request, the CDS service MUST return CDS Hooks Cards that MAY include actions with associated FHIR resources. Figure 3 builds on Figure 2 by depicting a Card display example within the order entry workflow. The decision points, `order-sign` request, and Card(s) response are discussed further in the sections below.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Level 1 – Warfarin + NSAID Semi-Structured Knowledge </strong></figcaption>
  <a href = "assets/images/Basic_Warfarin_NSAID.svg" target ="_blank" > <img src= "assets/images/Basic_Warfarin_NSAID.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Warfarin_NSAID.svg" /></a>
</figure>

### <span style="color:silver"> 7.2.1 </span> Decision Points Summary
{:.no_toc}

Many PDDI CDS scenarios have similar drug and patient related decision points. Implementers SHOULD develop CQL artifacts that work in conjunction with the `order-sign` context and prefetch to support the base decision points. The Warfarin + NSAIDs PDDI exemplar as three main decision blocks that include:

1. whether the prescribed NSAID is topical diclofenac,

2. whether the patient is taking a proton pump inhibitor, and

3. the presence or absence of risk factors involving age, exacerbating medications, and history of upper gastrointestinal bleed


### <span style="color:silver"> 7.2.2 </span> CDS Hooks Request
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


### <span style="color:silver"> 7.3.0 </span> CDS Hooks Cards
{:.no_toc}


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Level 1 – Warfarin + NSAID Response Card Example </strong></figcaption>
  <a href = "assets/images/Basic_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Basic_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_W_N_Cards.svg" /></a>
</figure>


### <span style="color:silver"> 7.3.1 </span> Card Actions
{:.no_toc}

The CDS Hooks service response supports providing actionable information to clinicians at the time of medication order entry. A response Card has an `action` element within the suggestion attribute. The `action` element is defined by three types including `create, update, and delete.` Depending on the type of action, resources may be provided that facilitate the suggestion. For example, if a suggestion recommends substituting naproxen for acetaminophen, a `create` action may be used to apply a MedicationRequest for acetaminophen to the current order entry task. The actions, types and associated resources are listed below.

* `create`
    * Substituting NSAID for acetaminophen – MedicationRequest for acetaminophen
    * Adding proton pump inhibitor – MedicationRequest for proton pump inhibitor
* `update`
* `delete`
    * Remove current NSAID order

> *Note:* These actions are options that SHOULD be customized to an institutions needs and capabilities.

## <span style="color:silver"> 7.4.0 </span> Level 2 Implementation - Warfarin + NSAIDs Knowledge Artifact (semi-structured)

The Level 2 Implementation for the Warfarin + NSAID artifact is split into two separate hooks and services. Figures 4 and 5 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both Hooks (i.e., `order-select` and `order-sign`). Figure 6 provides a Card display example for each CDS Hooks instance within the order entry workflow. In the provided Card display example, the clinician decided to order the NSAID medication but adds a proton pump inhibitor, in response to the card suggestion. This action results in a downgrade of the `medication-prescribe` response card (i.e., "critical" – red to "warning" – orange). The blue task boxes highlight the DetectedIssue `status` indicator, which informs the EHR  of additional needed resources (whether or not to fulfill the `order-sign` service prefetch template), and `order-sign` service if it needs to perform a FHIR server request in the event prefetch data are not provided in the request.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: Warfarin + NSAID order-select logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_select.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_select.svg" /></a>
</figure>




<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: Warfarin + NSAID order-sign logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_prescribe.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_prescribe.svg" /></a>
</figure>


### <span style="color:silver"> 7.4.1 </span> CDS Hooks request
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


### <span style="color:silver"> 7.4.4 </span> CDS Hooks Cards
{:.no_toc}


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 6: Warfarin + NSAID Cards </strong></figcaption>
  <a href = "assets/images/Advanced_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Advanced_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Advanced_W_N_Cards.svg" /></a>
</figure>


# <span style="color:silver"> 8.0.0 </span> Digoxin + Cyclosporine

## <span style="color:silver"> 8.1.0 </span> The Digoxin + Cyclosporine Knowledge Artifact
{:.no_toc}

#### Table 2. Digoxin + Cyclosporine Minimal Information Model
{:.no_toc}

<div>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Drugs involved</strong>: Digoxin and Cyclosporine</td>
      </tr>
      <tr>
	<td>
	  <strong>Comment:</strong> The drugs involved in a PDDI MUST be explicitly stated. To support a computable representation of the PDDI, the drugs involved SHOULD be listed as sets of terms from a terminology such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a> or the <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Clinical Consequences</strong>: Increased risk of digitalis toxicity that may lead to cardiac arrhythmias</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The clinical consequences associated with a PDDI MUST be reported if known. Clinical consequences SHOULD refer health outcomes as specifically as possible. To support a computable representation of the PDDI, clinical consequences SHOULD be represented as one or more sets of terms from a terminology such as <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a> or <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Seriousness</strong>: Digitalis toxicity is a serious potential clinical consequence because it can result in death, life-threatening hospitalization, and disability. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> A PDDI clinical consequence MUST be noted as <i>serious</i> if it can result in death, life-threatening hospitalization, congenital anomaly, disability, or if it requires intervention to prevent permanent impairment or damage.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Severity</strong>: While digitalis toxicity is a serious potential clinical consequence, it can produce a range of cardiac arrhythmias and rhythm disturbances that vary in severity, from manageable bradycardia to life-threatening ventricular fibrillation. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The severity of a PDDI clinical consequence MUST be reported if known. The severity of a PDDI clinical consequence MUST be noted using non-ambiguous terms or phrases. Any of the existing terminologies for adverse event severity, such as <a href='https://wiki.nci.nih.gov/display/VKC/Common+Terminology+Criteria+for+Adverse+Events+FAQ'>Common Terminology Criteria for Adverse Event (CTCAE)</a>, MAY be used for describing a PDDI clinical consequence.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Mechanism of Interaction</strong>: The mechanism of this interaction appears to be mediated through P-glycoprotein inhibition by cyclosporine. P-glycoprotein is a major transporter for digoxin efflux.</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The mechanism of a PDDI MUST be reported if known. The description SHOULD be written for a clinician audience and include details that help the clinician decide what course of management action to take. To reduce ambiguity, the description MAY refer to specific drugs or health conditions using codes from terminologies.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Recommended Action</strong>: For patients with a reliable plasma digoxin concentration in normal range, it is reasonable to anticipate an increase in plasma concentrations after the initiation of cyclosporine. Following initiation, close monitoring and adjusting the digoxin dose as needed is recommended.</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Any recommended actions that apply to all patient exposures SHOULD be stated using clear and concise language. The recommended action statement SHOULD also provide citations to <a href='http://purl.obolibrary.org/obo/MPIO_0000004' target="new">evidence for a suspected drug-drug interaction</a> (not provided in this example). Recommendations that depend on <a href='http://purl.obolibrary.org/obo/MPIO_0000000' target="new">contextual information/modifying factors</a> SHOULD be mentioned separately to support context-specific presentation of such information.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Contextual information/modifying factors</strong>:
          <ol>
            <li>Relevant digoxin concentration in normal range
              <ul><strong>Recommended Action:</strong> Assess risk and take action if necessary</ul>
              <ul><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> For patients with a reliable plasma digoxin concentration in normal range, it is reasonable to anticipate an increase in plasma concentrations after the initiation of cyclosporine. Following initiation, close monitoring and adjusting the digoxin dose as needed is recommended. (Dorian et al. Clin Invest Med 1988; 11(2):108-112) (Dorian et al. Transplant Proc. 1987; 19(1):1825-1827). Taken 4-6 hours after the most recent dose, the approximate therapeutic range is 0.8 to 2.0 ng/mL (1 to 2.6 nmol/L); however, toxicity has been observed with concentrations in this range.</ul>
            </li>
            <li>Risk factors that may increase digoxin concentration or toxicity independent of cyclosporine include: reduced renal function and electrolyte abnormalities
              <ul><strong>Recommended Action:</strong> Assess risk and take action if necessary</ul>
              <ul><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> </ul>
               <ul>50-70% of digoxin is excreted unchanged in the urine. Changing renal function may increase serum concentrations and risk of toxicity, (Digoxin-FDA [prescribing information] NDA 20405/S-004) </ul>
               <ul>Hypokalemia, hypomagnesemia, and hypercalcemia may potentiate digoxin toxicity. (Lip et al. Postgrad Med J. 1993; 69(811):337)</ul>
            </li>
           </ol>
	</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> <a href='http://purl.obolibrary.org/obo/MPIO_0000000' target="new">Contextual information/modifying factors</a> are necessary for alerts that
          are both sensitive and specific. Like clinical consequences, each known factor SHOULD be
          stated as specifically as possible. The factors SHOULD be amenable to implementation as executable
          logic using value sets from clinical terminologies such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a>, the
	  <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>, <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a>, and <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. As is used in this
          example, each factor SHOULD be related to a specific <a href='http://purl.obolibrary.org/obo/MPIO_0000008' target="new">recommended action</a> that is supported by the <a href='http://purl.obolibrary.org/obo/MPIO_0000004' target="new">evidence for a suspected drug-drug interaction</a></td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Frequency of Exposure to the PDDI:</strong> Unknown</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Frequency of exposure and frequency of harm information is
          rarely available but can help a clinician assess the risk/benefit trade-off of exposure to PDDI. Such information SHOULD be provided if available. </td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Frequency of Harm for persons who have been exposed to the PDDI:</strong> Unknown</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Frequency of exposure and frequency of harm information is
          rarely available but can help a clinician assess the risk/benefit trade-off of exposure to PDDI. Such information SHOULD be provided if available. </td>
      </tr>
    </table>
</div>


## <span style="color:silver"> 8.2.0 </span> Definitions
{:.no_toc}

The Digoxin + Cyclosporine artifact logic depends on whether the patient is stable on digoxin or cyclosporine before the current medication order event. This section defines terms used in the subsequent flow diagrams. Certain terms are defined by assumptions that may be taken based on the presence of resources in `context` versus `prefetch` elements of the request.


* **Incident Order** – `context` medication is *not* in `prefetch` medications and, thus, is presumably the first occurrence.

* **Prevalent Order** – `context` medication is in `prefetch` medications and, thus, is presumably a medication order that is continued or repeated.

* **Normal** – observation that is within a specified time period, and the measure is within a therapeutic window or below/above a certain acceptable threshold.

* **Abnormal** – observation that is *not* within a specified time period, *or* the measure is *not* within a therapeutic window or below/above a certain threshold.

> *Note:* Parameters for "normal" and "abnormal" observations SHOULD be modified by the implementor. The provided artifacts use a simplistic approach of querying for the most recent measure in a specific time frame. This approach SHOULD be modified to capture and present the most clinically relevant information. For example, clinicians may want a look-back period that captures several measures for serum creatinine to determine the status *and* prognosis for renal insufficiency.

## <span style="color:silver"> 8.3.0 </span> Level 1 Implementation - Digoxin + Cyclosporine Knowledge Artifact (semi-structured)


Figure 7 shows how a PDDI CDS implementer would implement the Digoxin + Cyclosporine PDDI knowledge artifact using the CDS Hooks `order-sign` hook. The figure shows the CDS Service processes the PDDI CDS logic after receiving a `order-sign` request. Figure 7 progresses through the decision tree and includes warning indicators (i.e., green, orange, red) and contextual factors that may be presented to the clinician. Figure 8 builds on this artifact and provides a display of Cards example.

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 7: Level 1 Digoxin + Cyclosporine logic </strong></figcaption>
  <a href = "assets/images/Basic_Digoxin_Cyclosporine.svg" target ="_blank" > <img src="assets/images/Basic_Digoxin_Cyclosporine.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Digoxin_Cyclosporine.svg" /></a>
</figure>


### <span style="color:silver"> 8.3.1 </span> Decision Points Summary
{:.no_toc}

The Digoxin + Cyclosporine exemplar artifact has two main decision blocks:

1. whether the patient is taking digoxin and/or cyclosporine at the time of the current order for digoxin or cyclosporine, and

2. whether the patient has risk factors that may potentiate the risk of digitalis toxicity.

### <span style="color:silver"> 8.3.2 </span> CDS Hooks Request
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


### <span style="color:silver"> 8.3.3 </span> CDS Hooks Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 8: Level 1 Digoxin + Cyclosporine Cards </strong></figcaption>
  <a href = "assets/images/Level_1_D_C_Cards.svg" target ="_blank" > <img src="assets/images/Level_1_D_C_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Level_1_D_C_Cards.svg" /></a>
</figure>

### <span style="color:silver"> 8.3.4 </span> Card Actions
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

## <span style="color:silver"> 8.4.0 </span> Level 2 Implementation - Digoxin + Cyclosporine Knowledge Artifact (semi-structured)

As described under the Getting Started tab, the Level 2 Implementation proposal requires several changes to the current standard specifications. Changes to the CDS Hooks context are specified below. The Level 2 Implementation proposal for the Digoxin + Cyclosporine artifact is split into two separate services. Figures 9 and 10 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both services (i.e., Order Select and Order Sign). The blue task boxes highlight the DetectedIssue status indicator, which informs the EHR  of additional needed resources (whether or not to fulfill the Order Sign Service prefetch template), and Order Sign Service if it needs to perform a FHIR server request in the event prefetch data are not provided in the request. Figure 11 depicts a Card display example. In this scenario, the `order-sign` Cards are filtered since the clinician's action indicated that the patient was no longer taking digoxin.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 9: Digoxin + Cyclosporine order-select logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_select.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_select.svg" /></a>
</figure>

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 10: Digoxin + Cyclosporine order-sign logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_prescribe.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_prescribe.svg" /></a>
</figure>


### <span style="color:silver"> 8.4.1 </span> CDS Hooks Request
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


### <span style="color:silver"> 8.3.3 </span> CDS Hooks Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 11: Level 2 Digoxin + Cyclosporine Cards </strong></figcaption>
  <a href = "assets/images/Level_2_D_C_Cards.svg" target ="_blank" > <img src="assets/images/Level_2_D_C_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Level_2_D_C_Cards.svg" /></a>
</figure>



# <span style="color:silver"> 9.0.0 </span> Warfarin + NSAIDs and Digoxin + Cyclosporine CDS Artifacts (structured)

The structured artifacts following the aforementioned logic and behavior are available for the Level 1 Implementation under [Artifacts](artifacts.html).

