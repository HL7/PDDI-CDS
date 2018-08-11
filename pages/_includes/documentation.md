
* **TODO** need to specify clearly if is there information unique to warfarin-NSAIDs or Dig-Cyclo in terms of implementation

* **TODO** Consider adding recommendations to implementors based on the examples shown for Context, Prefetch, and Cards in the basic and advance CDS scenarios. Think of the two PDDI knowledge artifacts as pedagogical examples to explaining to implementors the implementation requirements

* **TODO** make PDDI mention format consistent e.g., choose either drug1 - drug2 or drug1 + drug2


# <span style="color:silver"> 6.0.0 </span> Documentation 

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

## <span style="color:silver"> 6.1.0 </span> Preliminaries 
{:.no_toc}

This section contains documentation on how to implement PDDI CDS artifacts from a clinical and technical perspective. Implementation details are described using two specific knowledge artifacts as examples. The words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, AND OPTIONAL are used as defined [*"Key words for use in RFCs to Indicate Requirement Levels".* S. Bradner. IETF. March 1997. Best Current Practice.](https://tools.ietf.org/html/rfc2119)

## <span style="color:silver"> 6.2.0 </span> CPOE Workflow Hooks 
{:.no_toc}

Figure 1 depicts hook triggers for Level 1 and 2 Implementations. The primary difference in the Level 2 Implementation is the additional hook and defining the initial trigger at the top of the CPOE workflow. The Level 1 Implementation follows the [CDS Hooks `medication-prescribe`](https://cds-hooks.org/hooks/medication-prescribe/) specification, which does not necessarily define the triggering event. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Level 1 versus Level 2 Implementation Hooks </strong></figcaption>
  <a href = "assets/images/CPOE_workflow_2.png" target ="_blank" > <img src= "assets/images/CPOE_workflow_2.png" class="figure-img img-responsive img-rounded center-block" alt="CPOE_workflow_2.png" /></a>
</figure>

## <span style="color:silver"> 6.3.0 </span> Prefetch Role 
{:.no_toc}

For technical implementers, the intended role of prefetch is to improve the CDS service performance. This is achieved by minimizing network calls by the CDS service to external resources such as a FHIR server. When a client program subscribes to PDDI CDS service, the service MUST return a prefetch specification in the response. This specification identifies resources that the PDDI CDS service SHOULD receive upon request. As is described below, the prefetch requirements are different for `medication-select` and `medication-prescribe` services. The ideal scenario for both implementations and services is to send prefetch data with the CDS Hooks request. The implementor has flexibility on when and how to fulfill the prefetch templates (e.g., data in EHR memory or server call), which will likely result in a solution that reduces the burden of the server and improves the CDS service efficiency. If the CDS service does not receive prefetch data in the request it MUST query the server via network call. 

## <span style="color:silver"> 6.4.0 </span> Relationships between CQL and PlanDefinition
{:.no_toc}

**TODO: make some mention of these three key technologies and their relationship to eachother**

# <span style="color:silver"> 7.0.0 </span> Warfarin + NSAIDs

## <span style="color:silver"> 7.1.0 </span> The Warfarin + NSAIDs Knowledge Artifact
{:.no_toc}

The  Warfarin + NSAIDs knowledge artifact represents a relatively complex contextualized PDDI CDS algorithm. The knowledge artifact contains logic that uses both drug and patient contextual factors. The original rule was developed by clinical experts as part of the W3C Community Group effort to develop a PDDI minimum information model. Table 1 is the Warfarin + NSAIDs knowledge artifact at the narrative level using the minimum information model. 

#### Table 1. Warfarin + NSAIDs Minimum Information Model
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
	<td><strong>Comment:</strong> The severity of a PDDI clinical consequence MUST be reported if known. The severity of a PDDI clinical consequence MUST be noted using non-ambiguous terms or phrases. Any of the existing terminologies for adverse event severity, such as <a href='https://wiki.nci.nih.gov/display/VKC/Common+Terminology+Criteria+for+Adverse+Events+FAQ'>Common Terminology Criteria for Adverse Event (CTCAE)</a>, MAY be used for describing a PDDI clinical consequence.</td>
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
	<td><strong>Comment:</strong> Any recommended actions that apply to all patient exposures SHOULD be stated using clear and concise language. The recommended action statement SHOULD also provide citations to <a>evidence for a suspected drug-drug interaction</a> (not provided in this example). Recommendations that depend on <a>contextual information/modifying factors</a> SHOULD be mentioned separately to support context-specific presentation of such information.</td>
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
	<td><strong>Comment:</strong> <a>Contextual information/modifying factors</a> are necessary for alerts that
          are both sensitive and specific. Like clinical consequences, each known factor SHOULD be
          stated as specifically as possible. The factors SHOULD be amenable to implementation as executable
          logic using value sets from clinical terminologies such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a>, the
	  <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>, <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a>, and <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. As is used in this
          example, each factor SHOULD be related to a specific <a>recommended action</a> that is supported by the <a>evidence for a suspected drug-drug interaction</a></td>
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

Figure 2 depicts how a PDDI CDS implementer would translate a minimum information model narrative to a semi-structured knowledge artifact. The Level 1 Implementation uses a single CDS service call and response using the `medication-prescribe` Hook. The decision tree results in three warning indicators (i.e., green, orange, red) and contextual factors that MAY be passed to the clinician.  After processing the CDS Hooks `medication-prescribe`, the CDS service MUST return CDS Hooks Cards that MAY include actions with associated FHIR resources. Figure 3 builds on Figure 2 by depicting a Card display example within the order entry workflow. The decision points, `medication-prescribe` request, and Card(s) response are discussed further in the sections below.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Level 1 – Warfarin + NSAID Semi-Structured Knowledge </strong></figcaption>
  <a href = "assets/images/Basic_Warfarin_NSAID.svg" target ="_blank" > <img src= "assets/images/Basic_Warfarin_NSAID.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Warfarin_NSAID.svg" /></a>
</figure>




### <span style="color:silver"> 7.2.1 </span> Decision Points Summary
{:.no_toc}

Many PDDI CDS scenarios have similar drug and patient related decision points. Implementers SHOULD develop CQL artifacts that work in conjunction with the `medication-prescribe` context and prefetch to support the base decision points. The Warfarin + NSAIDs PDDI exemplar as three main decision blocks that include:

* whether the prescribed NSAID is topical diclofenac

* whether the patient is taking a proton pump inhibitor 

* the presence or absence of risk factors involving age, exacerbating medications, and history of upper gastrointestinal bleed


### <span style="color:silver"> 7.2.2 </span> CDS Hooks Request
{:.no_toc}

The `medication-prescribe` request includes `context` and `prefetch` elements with FHIR resource attributes or entire resources. The contents of these elements for the Warfarin + NSAIDs CDS artifact are shown below.

#### `context`
{:.no_toc}

* [`medication-prescribe 1.0`](https://cds-hooks.org/hooks/medication-prescribe/) 

#### `prefetch` 
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:

	* [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)

	* [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)

	* [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)

	* [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

* Age of patient on current date.
    * [Patient](https://www.hl7.org/fhir/patient.html)
    
* Rolling 5-year look-back period for history of upper gastrointestinal bleed.
    * [Condition](https://www.hl7.org/fhir/condition.html)
    

#### <span style="color:silver"> 7.2.3 </span> CDS Hooks Cards
{:.no_toc}

**TODO: refer to the resources and explain to implementors the requirements **

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Level 1 – Warfarin + NSAID Response Card Example </strong></figcaption>
  <a href = "assets/images/Basic_W_N_Cards.png" target ="_blank" > <img src="assets/images/Basic_W_N_Cards.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_W_N_Cards.png" /></a>
</figure>


## <span style="color:silver"> 7.3.0 </span> Level 2 Implementation - Warfarin + NSAIDs Knowledge Artifact (semi-structured)

The Level 2 Implementation for the Warfarin + NSAID artifact is split into two separate Hooks and services. Figures 4 and 5 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both Hooks (i.e., `medication-select` and `medication-prescribe`). Figure 5 provides a Card display example for each CDS Hooks instance within the order entry workflow. In the provided Card display example, the clinician decided to order the NSAID medication but adds a proton pump inhibitor, in response to the card suggestion. This action results in a downgrade of the `medication-presecribe` response card (i.e., "hard-stop" – red to "warning" – orange). The blue task boxes highlight the DetectedIssue `status` indicator, which informs the EHR  of additional needed resources (whether or not to fulfill the `medication-prescribe` service prefetch template), and `medication-prescribe` service if it needs to perform a FHIR server request in the event prefetch data are not provided in the request.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: Warfarin + NSAID medication-select logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_select.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_select.svg" /></a>
</figure>




<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: Advanced Warfarin + NSAID medication-prescribe logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_prescribe.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_prescribe.svg" /></a>
</figure>


### <span style="color:silver"> 7.3.1 </span> CDS Hooks request
{:.no_toc}


#### `context`
{:.no_toc}

##### `medication-select 1.0`
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | ---- | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource

##### `medication-prescribe 1.1`
{:.no_toc}

| Field       | Optionality        |  Prefetch Token     |Type  | Description |
| :------------- |:-------------:|:-------: |:-----:| :-----------------|
| `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context |
| `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context |
| `detectedissueId` | REQUIRED     | Yes |    *string* | STU3 - FHIR `DetectedIssue` resource |
| `detectedissueStatus` | REQUIRED     | No |    *code* | STU3 - FHIR `DetectedIssue` resource |
| `medication` | REQUIRED     | No |    *object* | STU3 - FHIR `MedicationRequest` resource |


#### `medication-select` `prefetch`
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

##### `medication-prescribe` `prefetch`
{:.no_toc}

* Age of patient on current date.
    * [Patient](https://www.hl7.org/fhir/patient.html)
    
* Rolling 5-year look-back period for history of upper gastrointestinal bleed.
    * [Condition](https://www.hl7.org/fhir/condition.html)
    

### <span style="color:silver"> 7.3.4 </span> CDS Hooks Cards
{:.no_toc}

*TODO: refer to the resources and explain to implementors the requirements **

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 5: Warfarin + NSAID Cards </strong></figcaption>
  <a href = "assets/images/Advanced_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Advanced_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Advanced_W_N_Cards.svg" /></a>
</figure>


# <span style="color:silver"> 8.0.0 </span> Digoxin + Cyclosporine

## <span style="color:silver"> 8.1.0 </span> The Digoxin + Cyclosporine Knowledge Artifact
{:.no_toc}

#### Table 2. Digoxin + Cyclosporine Minimum Information Model
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
	<td><strong>Comment:</strong> Any recommended actions that apply to all patient exposures SHOULD be stated using clear and concise language. The recommended action statement SHOULD also provide citations to <a>evidence for a suspected drug-drug interaction</a> (not provided in this example). Recommendations that depend on <a>contextual information/modifying factors</a> SHOULD be mentioned separately to support context-specific presentation of such information.</td>
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
	<td><strong>Comment:</strong> <a>Contextual information/modifying factors</a> are necessary for alerts that
          are both sensitive and specific. Like clinical consequences, each known factor SHOULD be
          stated as specifically as possible. The factors SHOULD be amenable to implementation as executable
          logic using value sets from clinical terminologies such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a>, the
	  <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>, <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a>, and <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. As is used in this
          example, each factor SHOULD be related to a specific <a>recommended action</a> that is supported by the <a>evidence for a suspected drug-drug interaction</a></td>
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

The Digoxin + Cyclosporine artifact logic depends on the concept that the patient was currently stable on digoxin before the current medication order. To make this clear, the Definitions section (8.1.0) defines terms used in the subsequent flow diagrams. Figure 6 progresses through the decision tree and includes warning indicators (i.e., green, orange, red) and contextual factors that may be passed to the clinician.


* **Incident Order** – `context` medication is *not* in `prefetch` medications and, thus, is presumably the first occurrence. 

* **Prevalent Order** – `context` medication is in `prefetch` medications and, thus, is presumably a medication order that is continued or repeated.

* **Normal** – observation that is within a specified time period, and the measure is within a therapeutic window or below/above a certain threshold.

* **Abnormal** – observation that is *not* within a specified time period, *or* the measure is *not* within a therapeutic window or below/above a certain threshold.



## <span style="color:silver"> 8.3.0 </span> Level 1 Implementation - Digoxin + Cyclosporine Knowledge Artifact (semi-structured) 


Figure 6 shows how a PDDI CDS implementer would implement the Digoxin + Cyclosporine PDDI knowlege artifact using the CDS Hooks `medication-prescribe` hook. The figure shows that the CDS Service would process the PDDI CDS logic after receiving a `medication-prescribe` request. Note that, like the Warfarin-NSAIDs PDDI, the CDS implementor MUST create *pre-fetch* templates the client programs will use to assemble data for `medication-prescribe` requests.  Data in the request MUST include both the prescribing context required as part of the `medication-prescribe` hook and pre-fetch resources specified by the CDS service. The decision tree shown in the figure indicates warning indicators (i.e., green, orange, red) and contextual factors that MAY be passed to the clinician.  After processing the CDS Hooks `medication-prescribe`, the CDS service MUST return CDS Hooks *cards* that MAY include *actions* with associated FHIR resources. 

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 6: Level 1 Digoxin + Cyclosporine logic </strong></figcaption>
  <a href = "assets/images/Basic_Digoxin_Cyclosporine.svg" target ="_blank" > <img src="assets/images/Basic_Digoxin_Cyclosporine.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Digoxin_Cyclosporine.svg" /></a>
</figure>


### <span style="color:silver"> 8.3.1 </span> Decision Points Summary
{:.no_toc}


### <span style="color:silver"> 8.3.2 </span> CDS Hooks Request
{:.no_toc}


#### `context`
{:.no_toc}

* [`medication-prescribe 1.0`](https://cds-hooks.org/hooks/medication-prescribe/) 

#### `prefetch`
{:.no_toc}

* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)
    
* Rolling 365-day look-back period for digoxin concentration
    * [Observation](https://www.hl7.org/fhir/observation.html)

* Rolling 365-day look-back period for serum creatinine
    * [Observation](https://www.hl7.org/fhir/observation.html)
    
* Rolling 365-day look-back period for electrolytes including: potassium, magnesium, and calcium
    * [Observation](https://www.hl7.org/fhir/observation.html)
        

### <span style="color:silver"> 8.3.3 </span> CDS Hooks Cards Example
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 7: Level 1 Digoxin + Cyclosporine Cards </strong></figcaption>
  <a href = "assets/images/Level_1_D_C_Cards.svg" target ="_blank" > <img src="assets/images/Level_1_D_C_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Level_1_D_C_Cards.svg" /></a>
</figure>


## <span style="color:silver"> 8.4.0 </span> Level 2 Implementation - Digoxin + Cyclosporine Knowledge Artifact (semi-structured)

As described under the Getting Started tab, the Advanced proposal requires several changes to the current standard specifications. Changes to the CDS Hooks context are specified below. The Advanced implementation proposal for the Digoxin + Cyclosporine artifact is split into two separate services. Figures 7 and 8 depict the decision tree for warning indicators (i.e., green, orange, red) and contextual factors for both services (i.e., Medication Select and Medication Prescribe). The blue task boxes highlight the DetectedIssue status indicator, which informs the EHR  of additional needed resources (whether or not to fulfill the Medication Prescribe Service prefetch template), and Medication Prescribe Service if it needs to perform a FHIR server request in the event prefetch data are not provided in the request.


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 7: Digoxin + Cyclosporine medication-select logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_select.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_select.svg" /></a>
</figure>

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 8: Digoxin + Cyclosporine medication-prescribe logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_prescribe.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_prescribe.svg" /></a>
</figure>


### <span style="color:silver"> 8.4.1 </span> CDS Hooks Request
{:.no_toc}


#### `medication-select 1.0` `context`
{:.no_toc}

Field | Optionality | Prefetch Token | Type | Description
----- | -------- | :----: | ---- | ----
`patientId` | REQUIRED | Yes | *string* | Describe the context value
`encounterId` | OPTIONAL | Yes | *string* | Describe the context value
`medication`| REQUIRED | No | *object* | STU3 - FHIR `MedicationRequest` resource

#### `medication-prescribe 1.1` `context`
{:.no_toc}

| Field       | Optionality        |  Prefetch Token     |Type  | Description |
| :------------- |:-------------:|:-------: |:-----:| :-----------------|
| `patientId`     | REQUIRED | Yes|string | The FHIR Patient.id of the current patient in context |
| `encounterId`     | OPTIONAL    | Yes |   *string* | The FHIR Encounter.id of the current encounter in context |
| `detectedissueId` | REQUIRED     | Yes |    *string* | STU3 - FHIR `DetectedIssue` resource |
| `detectedissueStatus` | REQUIRED     | No |    *code* | STU3 - FHIR `DetectedIssue` resource |
| `medication` | REQUIRED     | No |    *object* | STU3 - FHIR `MedicationRequest` resource |



#### `medication-select` `prefetch`
{:.no_toc}
* Rolling 100-day look-back period for medication resources including:
    * [MedicationRequest](https://www.hl7.org/fhir/medicationrequest.html)
    * [MedicationDispense](https://www.hl7.org/fhir/medicationdispense.html)
    * [MedicationStatement](https://www.hl7.org/fhir/medicationstatement.html)
    * [MedicationAdministration](https://www.hl7.org/fhir/medicationadministration.html)

#### `medication-prescribe` `prefetch`
{:.no_toc}

* Rolling 365-day look-back period for digoxin concentration
    * [Observation](https://www.hl7.org/fhir/observation.html)

* Rolling 365-day look-back period for serum creatinine
    * [Observation](https://www.hl7.org/fhir/observation.html)
    
* Rolling 365-day look-back period for electrolytes including: potassium, magnesium, and calcium
    * [Observation](https://www.hl7.org/fhir/observation.html)


### <span style="color:silver"> 8.3.3 </span> CDS Hooks Cards Example
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 9: Level 2 Digoxin + Cyclosporine Cards </strong></figcaption>
  <a href = "assets/images/Level_2_D_C_Cards.svg" target ="_blank" > <img src="assets/images/Level_2_D_C_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Level_2_D_C_Cards.svg" /></a>
</figure>

# <span style="color:silver"> 9.0.0 </span> Warfarin + NSAIDs and Digoxin + Cyclosporine CDS Artifacts (structured)

The following artifacts formalize the description of the logic and behavior defined by this recommendation.

| Resource | Type | Description |
| --- | --- | --- |
| [Common PDDI CDS Logic](documentation.html) | [Library](https://www.hl7.org/fhir/library.html) | CQL Library that provides common logic for the recommendations |
| [Common PDDI CDS Logic](documentation.html) | CQL Source | For reference, the complete CQL source for the common logic. |
| [PDDI CDS Data](documentation.html) | [Library](https://www.hl7.org/fhir/library.html) | CQL Library that provides data for the recommendations |
| [PDDI CDS Data](documentation.html) | CQL Source | For reference, the complete CQL source for the data. |
| [Warfarin NSAIDs Recommendation Workflow](documentation.html)  |	[PlanDefinition](https://www.hl7.org/fhir/plandefinition.html)  | Event-Condition-Action rule that implements behavior for Warfarin NSAIDs Recommendation |
| [Warfarin NSAIDs Recommendation](documentation.html) | [Library](https://www.hl7.org/fhir/library.html) | Defines the data requirements to support evaluation of Warfarin NSAIDs recommendation |
| [Warfarin NSAIDs Recommendation](documentation.html) | CQL Source | For reference, the complete CQL source for Warfarin NSAIDs recommendation |
