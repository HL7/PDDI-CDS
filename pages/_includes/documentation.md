## PDDI CDS - Documentation
{:.no_toc}
This section contains documentation for implementers from both the clinical and technical perspectives. The process documentation describes the assumptions and decisions made, as well as a functional description of the recommendations. The integration documentation describes the overall approach and documents the artifacts contained in the IG, while the implementation documentation provides developer-level documentation on how to use the artifacts.

### Warfarin + NSAIDs 

#### Minimal Information Model 

> **Drugs Involved:** Warfarin and non-steroidal anti-inflamatory drugs (NSAIDs).
> *Comment:*  The drugs involved in a PDDI MUST be explicitly stated. To support a computable representation of the PDDI, the drugs involved SHOULD be listed as sets of terms from a terminology such as RxNorm or the Anatomical Therapeutic Chemical Classification System (ATC). Such so called value sets MAY be referenced by a URI to a public repository such as the Value Set Authority Center that is maintained by the United States National Library of Medicine.

> **Clinical Consequences:** Increased risk of bleeding including gastrointestinal bleeding, intracranial hemorrhage, and cerebral hemorrhage.
> *Comment:* The clinical consequences associated with a PDDI MUST be reported if known. Clinical consequences SHOULD refer health outcomes as specifically as possible. To support a computable representation of the PDDI, clinical consequences SHOULD be represented as one or more sets of terms from a terminology such as ICD-10 or SNOMED-CT. Such so called value sets MAY be referenced by a URI to a public repository such as the Value Set Authority Center that is maintained by the United States National Library of Medicine.

> **Seriousness:** Bleeding is a serious potential clinical consequence because it can result in death, life-threatening hospitalization, and disability.
> *Comment:* A PDDI clinical consequence MUST be noted as serious if it can result in death, life-threatening hospitalization, congenital anomaly, disability, or if it requires intervention to prevent permanent impairment or damage.

> **Severity:** While bleeding is a serious potential clinical consequence, severity can vary from easily tolerated to incapacitating.
> *Comment:* The severity of a PDDI clinical consequence MUST be reported if known. The severity of a PDDI clinical consequence MUST be noted using non-ambiguous terms or phrases. Any of the existing terminologies for adverse event severity, such as Common Terminology Criteria for Adverse Event (CTCAE) [ctcae-wiki], MAY be used for describing a PDDI clinical consequence.

> **Mechanism of Interaction:**  Non-steroidal anti-inflammatory drugs (NSAIDs) have antiplatelet effects which increase the bleeding risk when combined with oral anticoagulants such as warfarin. The antiplatelet effect of NSAIDs lasts only as long as the NSAID is present in the circulation, unlike aspirin’s antiplatelet effect, which lasts for up to 2 weeks after aspirin is discontinued. NSAIDs also can cause peptic ulcers and most of the evidence for increased bleeding risk with NSAIDs plus warfarin is due to upper gastrointestinal bleeding (UGIB).
> *Comment:* The mechanism of a PDDI MUST be reported if known. The description SHOULD be written for a clinician audience and include details that help the clinician decide what course of management action to take. To reduce ambiguity, the description MAY refer to specific drugs or health conditions using codes from terminologies.

> **Recommended Action:** If the NSAID is being used as an analgesic or antipyretic, it would be prudent to use an alternative such as acetaminophen. In some people, acetaminophen can increase the anticoagulant effect of warfarin, so monitor the INR if acetaminophen is used in doses over 2 g/day for a few days. For more severe pain consider short-term opioids in place of the NSAID.
> *Comment:* Any recommended actions that apply to all patient exposures SHOULD be stated using clear and concise language. The recommended action statement SHOULD also provide citations to evidence for a suspected drug-drug interaction (not provided in this example). Recommendations that depend on contextual information/modifying factors SHOULD be mentioned separately to support context-specific presentation of such information.

> **Contextual Information/Modifying Factors:** 
> 1. The NSAID is topical diclofenac
> * **Recommended Action:** No special precautions
> * **Evidence for a Suspected Drug-Drug Interaction:**  Topical diclofenac has relatively low systemic absorption; in one study a topical gel (16 g/day) produced about 6% of the absorption seen with systemic administration of 150 mg/day. A higher than recommended dose of topical gel (48 g/day) produced 20% of a systemic dose of diclofenac.
> 2. The NSAID is NOT topical diclofenac but the patient is concomitantly taking a proton pump inhibitor or misoprostol
> * **Recommended Action:** Assess risk and take action if necessary
> * **Evidence for a Suspected Drug-Drug Interaction:**  Proton pump inhibitors and misoprostol may reduce the risk of UGIB in patients receiving NSAIDs and warfarin.
> 3. The NSAID is NOT topical diclofenac, the patient is NOT concomitantly taking a proton pump inhibitor or misoprostol, and the patient has one or more of the following risk factors:
> * History of upper gastrointestinal bleeding (UGIB) or peptic ulcer or age > 65 years old
>   * **Recommended Action:** Use only if benefit outweighs risk
>   * **Evidence for a Suspected Drug-Drug Interaction:** Patients with a history of UGIB or peptic ulcer may have an increased risk of UGIB from this interaction. The extent to which older age is an independent risk factor for UGIB due to these interactions is not firmly established, but UGIB in general is known to increase with age.
> * Concomitantly taking systemic corticosteroids, aldosterone antagonists, or high dose or multiple NSAIDs
>   * **Recommended Action:** Use only if benefit outweighs risk
>   * **Evidence for a Suspected Drug-Drug Interaction:** Both corticosteroids and aldosterone antagonists have been shown to substantially increase the risk of UGIB in patients on NSAIDs, with relative risks of 12.8 and 11 respectively compared to a risk of 4.3 with NSAIDs alone [masclee-2014].
> *Comment:*  Contextual information/modifying factors are necessary for alerts that are both sensitive and specific. Like clinical consequences, each known factor SHOULD be stated as specifically as possible. The factors SHOULD be amenable to implementation as executable logic using value sets from clinical terminologies such as RxNorm, the Anatomical Therapeutic Chemical Classification System (ATC), ICD-10, and SNOMED-CT. As is used in this example, each factor SHOULD be related to a specific recommended action that is supported by the evidence for a suspected drug-drug interaction.

> **Frequency of Exposure to the PDDI:** Unknown.
> *Comment:* Frequency of exposure and frequency of harm information is rarely available but can help a clinician assess the risk/benefit trade-off of exposure to PDDI. Such information SHOULD be provided if available.

> **Frequency of Harm for persons who have been exposed to the PDDI:** Unknown.
> *Comment:* Frequency of exposure and frequency of harm information is rarely available but can help a clinician assess the risk/benefit trade-off of exposure to PDDI. Such information SHOULD be provided if available.

#### Decision Points

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Warfarin + NSAID Decision Logic </strong></figcaption>
  <img src="assets/images/Warfarin_NSAID_logic.png" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_logic.png" />
</figure>

#### Content
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

### Digoxin + Cyclosporin

#### Decision Points