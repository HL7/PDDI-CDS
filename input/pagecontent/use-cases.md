### Introduction

Note that assumption of the use case examples presented on this page is that the drugs involved in the potential drug-drug interaction (PDDI) CDS service logic include only sets of terminology codes for specific semantic clinical/branded drugs that have a formulation indicative of the route of administration. This is very typical for electronic health record systems. It is left to developers of CDS rules to consider how to handle situations where an EHR system triggers the CDS service using a selected ingredient rather than a semantic clinical drug.

### Warfarin + NSAIDs (Informational Example)


The  Warfarin + non-steroidal anti-inflamatory drugs (NSAIDs) knowledge artifact represents a relatively complex contextualized PDDI CDS algorithm. The knowledge artifact contains logic that uses both drug and patient contextual factors. The original rule was developed by clinical experts as part of the W3C Community Group effort to develop a [minimal information model for representing clinically actionable knowledge about PDDIs](https://w3id.org/hclscg/pddi). Table 1 is the Warfarin + NSAIDs knowledge artifact at the narrative level using the minimal information model. The IG use case shows that the potential interactions often need to consider route and formulation. The minimal information model specifies  contextual  information/modifying factors which these would fall under.

#### Warfarin + NSAIDs Logic Table
{:.no_toc}

<figure class="figure">
	<figcaption class="figure-caption">
		Legend: <span style="color: #30d529">&#9678;</span> = No special precautions.
		<span style="color: #f9bd3b">&#9632;</span> = Assess risk and take action if necessary.
		<span style="color: #fb0082">&#9670;</span> = Use only if benefit outweighs risk.
		<br>
		Note that this rule was originally developed through &quot;Individualized Drug Interactions&quot; (AHRQ Project R21-HS023826-01) by Daniel Malone, John Horn, and Philp Hansten.
	</figcaption>
	<a href = "Warfarin-NSAID-TREE-opthalmic-addition.png" target ="_blank" > <img src="Warfarin-NSAID-TREE-opthalmic-addition.png" class="figure-img img-responsive img-rounded center-block" alt="Warfarin + NSAID PDDI" /></a>
</figure>

<p style="text-align: left"><strong>Footnotes:</strong>
<ol type="1">
  <li style="text-align: left">Topical diclofenac has relatively low systemic absorption; in one study a topical gel (16 g/day) produced about 6% of the absorption seen with systemic administration of 150 mg/day. A higher than recommended dose of topical gel (48 g/day) produced 20% of a systemic dose of diclofenac. The UK Summary of Product Characteristics for Voltarol Ophtha Multidose Eye Drops states, "No measurable levels of diclofenac could be found in humans after ocular application of diclofenac sodium eye drops". The FDA-approved SPL for Diclofenac Sodium Ophthalmic Solution 0.1% states, "Results from a bioavailability study established that plasma levels of diclofenac following ocular instillation of two drops of Diclofenac sodium ophthalmic solution, 0.1% to each eye were below the limit of quantification (10 ng/mL) over a 4-hour period. This study suggests that limited, if any, systemic absorption occurs with Diclofenac sodium ophthalmic solution". </li>
  <li style="text-align: left">If the NSAID is being used as an analgesic or antipyretic, it would be prudent to use an alternative such as acetaminophen. In some people, acetaminophen can increase the anticoagulant effect of warfarin, so monitor the INR if acetaminophen is used in doses over 2 g/day for a few days. For more severe pain consider short-term opioids in place of the NSAID.</li>
  <li style="text-align: left">Proton pump inhibitors and misoprostol may reduce the risk of upper gastrointestinal bleeding (UGIB) in patients receiving NSAIDs and warfarin.</li>
  <li style="text-align: left">Patients with a history of UGIB or peptic ulcer may have an increased risk of UGIB from this interaction. The extent to which older age is an independent risk factor for UGIB due to these interactions is not firmly established, but UGIB in general is known to increase with age.</li>
  <li style="text-align: left">Both corticosteroids and aldosterone antagonists have been shown to substantially increase the risk of UGIB in patients on NSAIDs, with relative risks of 12.8 and 11 respectively compared to a risk of 4.3 with NSAIDs alone [[masclee-2014]]</li>
</ol>
</p>


#### Warfarin-NSAIDS PDDI PDDI Minimal Information Model Elements
{:.no_toc}

<div>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Drugs involved</strong>: Warfarin and non-steroidal anti-inflammatory drugs (NSAIDs)</td>
      </tr>
      <tr>
	<td>
	  <strong>Comment:</strong> The drugs involved in a PDDI SHOULD be explicitly stated. To support a computable representation of the PDDI, the drugs involved SHOULD be listed as sets of terms from a terminology such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a> or the <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Clinical Consequences</strong>: Increased risk of bleeding including gastrointestinal bleeding,  intracranial hemorrhage,  and cerebral hemorrhage</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The clinical consequences associated with a PDDI SHOULD be reported if known. Clinical consequences SHOULD refer health outcomes as specifically as possible. To support a computable representation of the PDDI, clinical consequences SHOULD be represented as one or more sets of terms from a terminology such as <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a> or <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Seriousness</strong>: Bleeding is a serious potential clinical consequence because it can result in death, life-threatening hospitalization, and disability. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> A PDDI clinical consequence SHOULD be noted as <i>serious</i> if it can result in death, life-threatening hospitalization, congenital anomaly, disability, or if it requires intervention to prevent permanent impairment or damage.</td>
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
	<td><strong>Comment:</strong> The mechanism of a PDDI SHOULD be reported if known. The description SHOULD be written for a clinician audience and include details that help the clinician decide what course of management action to take. To reduce ambiguity, the description MAY refer to specific drugs or health conditions using codes from terminologies. </td>
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

### Digoxin + Cyclosporine


This is another IG use case that  shows that the potential interactions often need to consider route and formulation. The minimal information model specifies  contextual  information/modifying factors which these would fall under.

#### Digoxin + Cyclosporine Logic Table (Informational Example)
{:.no_toc}

<figure class="figure">
	<figcaption class="figure-caption">
		Legend: <span style="color: #30d529">&#9678;</span> = No special precautions.
		<span style="color: #f9bd3b">&#9632;</span> = Assess risk and take action if necessary.
		<span style="color: #fb0082">&#9670;</span> = Use only if benefit outweighs risk.
		<br>
		Note that this rule was originally developed through &quot;Individualized Drug Interactions&quot; (AHRQ Project R21-HS023826-01) by Thomase Reese, Daniel Malone, John Horn, and Philp Hansten.
	</figcaption>
	<a href = "Digoxin_Cyclosporine_tree.png" target ="_blank" > <img src="Digoxin_Cyclosporine_tree.png" class="figure-img img-responsive img-rounded center-block" alt="Digoxin + Cyclosporine PDDI" /></a>
</figure>

<p style="text-align: left"><strong>Footnotes:</strong>
<ol type="1">
	<li style="text-align: left"> For patients with a reliable plasma digoxin concentration in normal range, it is reasonable to anticipate an increase in plasma concentrations after the initiation of cyclosporine. Following initiation, close monitoring and adjusting the digoxin dose as needed is recommended. (Dorian et al. Clin Invest Med 1988; 11(2):108-112) (Dorian et al. Transplant Proc. 1987; 19(1):1825-1827) </li>
	<li style="text-align: left"> 50-70% of digoxin is excreted unchanged in the urine. Changing renal function may increase serum concentrations and risk of toxicity, (Digoxin-FDA [prescribing information] NDA 20405/S-004) </li>
	<li style="text-align: left"> Hypokalemia, hypomagnesemia, and hypercalcemia may potentiate digoxin toxicity. (Lip et al. Postgrad Med J. 1993; 69(811):337)  </li>
</ol>
</p>


#### Digoxin + Cyclosporine PDDI Minimal Information Model Elements
{:.no_toc}

<div>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Drugs involved</strong>: Digoxin and Cyclosporine</td>
      </tr>
      <tr>
	<td>
	  <strong>Comment:</strong> The drugs involved in a PDDI SHOULD be explicitly stated. To support a computable representation of the PDDI, the drugs involved SHOULD be listed as sets of terms from a terminology such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a> or the <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Clinical Consequences</strong>: Increased risk of digitalis toxicity that may lead to cardiac arrhythmias</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The clinical consequences associated with a PDDI SHOULD be reported if known. Clinical consequences SHOULD refer health outcomes as specifically as possible. To support a computable representation of the PDDI, clinical consequences SHOULD be represented as one or more sets of terms from a terminology such as <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a> or <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Seriousness</strong>: Digitalis toxicity is a serious potential clinical consequence because it can result in death, life-threatening hospitalization, and disability. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> A PDDI clinical consequence SHOULD be noted as <i>serious</i> if it can result in death, life-threatening hospitalization, congenital anomaly, disability, or if it requires intervention to prevent permanent impairment or damage.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Mechanism of Interaction</strong>: The mechanism of this interaction appears to be mediated through P-glycoprotein inhibition by cyclosporine. P-glycoprotein is a major transporter for digoxin efflux.</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The mechanism of a PDDI SHOULD be reported if known. The description SHOULD be written for a clinician audience and include details that help the clinician decide what course of management action to take. To reduce ambiguity, the description MAY refer to specific drugs or health conditions using codes from terminologies.</td>
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

### Cannabis Natural Product Interactions


This is another IG use case that shows a few examples with natural products interactions involving cannabis. Although these are not standard drug - drug interactions, these examples still follow the minimal information model.

#### Cannabis + DOAC Minimal Information Model (Informational Example)

##### Cannabis + DOAC Logic Table
{:.no_toc}

<figure class="figure">
	<figcaption class="figure-caption">
		Legend: <span style="color: #30d529">&#9678;</span> = No special precautions.
		<span style="color: #f9bd3b">&#9632;</span> = Usually Avoid Combination or Minimize Risk.
		<span style="color: #fb0082">&#9670;</span> = Avoid combination.
		<br>
		Note that this rule was originally developed by Dr. Kojo Abanyie with input from Dr. Daniel Malone, Dr. Lorenzo Villa-Zapata, and Dr. Xiaotong Li.
	</figcaption>
	<a href = "CBD-DOAC.png" target ="_blank" > <img src="CBD-DOAC.png" class="figure-img img-responsive img-rounded center-block" alt="CBD + DOAC NPDI" /></a>
</figure>

##### Cannabis + DOAC PDDI Minimal Information Model Elements
{:.no_toc}

<div>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Drugs involved</strong>: Cannabis and DOAC</td>
      </tr>
      <tr>
	<td>
	  <strong>Comment:</strong> The drugs involved in a NPDI SHOULD be explicitly stated. To support a computable representation of the NPDI, the drugs involved SHOULD be listed as sets of terms from a terminology such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a> or the <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>. Due the novelty of natural products in terminology sets, use of <a href="https://mor.nlm.nih.gov/RxMix/" target="new">RxMix</a>may be helpful in finding a set of terms relating to the natural product in consideration.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Clinical Consequences</strong>: Increased risk of bleeding due to increased exposure from DOAC </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The clinical consequences associated with a NPDI SHOULD be reported if known. Clinical consequences SHOULD refer health outcomes as specifically as possible. To support a computable representation of the NPDI, clinical consequences SHOULD be represented as one or more sets of terms from a terminology such as <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a> or <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Seriousness</strong>: Bleeding is a serious potential clinical consequence because it can result in death, life-threatening hospitalization, and disability.</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> A NPDI clinical consequence SHOULD be noted as <i>serious</i> if it can result in death, life-threatening hospitalization, congenital anomaly, disability, or if it requires intervention to prevent permanent impairment or damage.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Mechanism of Interaction</strong>: The mechanism of this interaction appears to be mediated through P-glycoprotein inhibition by cannabis products. DOACS are substrates of P-glycoprotein.</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The mechanism of a NPDI SHOULD be reported if known. The description SHOULD be written for a clinician audience and include details that help the clinician decide what course of management action to take. To reduce ambiguity, the description MAY refer to specific drugs or health conditions using codes from terminologies.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Recommended Action</strong>: For patients on DOACs, patients should be monitored for potential increased bleeding incidence as well as miminize any additional bleeding risks. Patients with poor renal function should be monitored more closely due to increased exposure to DOAC, particualrly for patients on dabigatran. In these cases, cannabis should be discontinued to avoid bleeding events. Of note, patients on apixaban potentially have a lower risk of adverse events when taken in conjunction with cannabis. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Any recommended actions that apply to all patient exposures SHOULD be stated using clear and concise language. The recommended action statement SHOULD also provide citations to <a href='http://purl.obolibrary.org/obo/MPIO_0000004' target="new">evidence for a suspected drug-drug interaction</a> (not provided in this example). Recommendations that depend on <a href='http://purl.obolibrary.org/obo/MPIO_0000000' target="new">contextual information/modifying factors</a> SHOULD be mentioned separately to support context-specific presentation of such information.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Contextual information/modifying factors</strong>:
          <ol>
            <li>The DOAC is Apixaban
              <ul><strong>Recommended Action:</strong> No Special Precautions</ul>
              <ul><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> Strong evidence does not exist with apixaban as a prominent substrate of P-gp. In addition, product labeling suggest the risk is associated with strong CYP3A4 and P-gp inhibitors.(Eliquis (apixaban) [prescribing information]) Research also does not strongly support cannabis as a strong dual inhibitor of CYP3A4 and P-gp.</ul>
            </li>
            <li>The DOAC is rivaroxaban, edoxaban, dabigatran
              <ul><strong>Recommended Action:</strong> Minimize Risk</ul>
              <ul><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> </ul>
               <ul>Evidence supports rivaroxaban and edoxaban as prominent substrats of P-gp. This is further substantiated by the product labels for rivaroxaban, edoxaban and dabigatran(Xarelto (rivaroxaban) [prescribing information], Sayvaysa (edoxaban) [prescribing information], and Pradaxa (dabigatran etexilate) [prescribing information]) The potency of cannabis as a P-gp inhibitor is unclear given the available evidence.[Zhu et al. J Pharmacol Exp Ther. 2006;317(2):850-857.]  </ul>
            </li>
            <li>The DOAC is dabigatran and the patient has a CrCl less than 50 or AKI/CKD.
              <ul><strong>Recommended Action:</strong> Avoid Combination</ul>
              <ul><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> </ul>
               <ul>The product labeling for dabigatran has warnings regarding severe renal impairment. It also mentiones that the concomitant use of P-gp inhibitors can cause an increased exposure of dabigatran.(Pradaxa (dabigatran etexilate) [prescribing information])</ul>
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
	<td style="background-color: #f4fff2"><strong>Frequency of Exposure to the NPDI:</strong> Unknown</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Frequency of exposure and frequency of harm information is
          rarely available but can help a clinician assess the risk/benefit trade-off of exposure to NPDI. Such information SHOULD be provided if available. </td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Frequency of Harm for persons who have been exposed to the NPDI:</strong> Unknown</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Frequency of exposure and frequency of harm information is
          rarely available but can help a clinician assess the risk/benefit trade-off of exposure to NPDI. Such information SHOULD be provided if available. </td>
      </tr>
    </table>
</div>

#### Cannabis + Clopidogrel Minimal Information Model (Informational Example)

##### Cannabis + Clopidogrel Logic Table
{:.no_toc}

<figure class="figure">
	<figcaption class="figure-caption">
		Legend: <span style="color: #30d529">&#9678;</span> = No special precautions.
		<span style="color: #f9bd3b">&#9632;</span> = Usually Avoid Combination or Minimize Risk.
		<span style="color: #fb0082">&#9670;</span> = Avoid combination.
		<br>
		Note that this rule was originally developed by Dr. Kojo Abanyie with input from Dr. Daniel Malone, Dr. Lorenzo Villa-Zapata, and Dr. Xiaotong Li.
	</figcaption>
	<a href = "CBD-Clopidogrel.png" target ="_blank" > <img src="CBD-Clopidogrel.png" class="figure-img img-responsive img-rounded center-block" alt="CBD + Clopidogrel NPDI" /></a>
</figure>

##### Cannabis + Clopidogrel PDDI Minimal Information Model Elements
{:.no_toc}

<div>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Drugs involved</strong>: Cannabis and Clopidogrel</td>
      </tr>
      <tr>
	<td>
	  <strong>Comment:</strong> The drugs involved in a NPDI SHOULD be explicitly stated. To support a computable representation of the NPDI, the drugs involved SHOULD be listed as sets of terms from a terminology such as <a href="https://www.nlm.nih.gov/research/umls/rxnorm/" target="new">RxNorm</a> or the <a href="https://www.whocc.no/atc/structure_and_principles/" target="new">Anatomical Therapeutic Chemical Classification System (ATC)</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>. Due the novelty of natural products in terminology sets, use of <a href="https://mor.nlm.nih.gov/RxMix/" target="new">RxMix</a>may be helpful in finding a set of terms relating to the natural product in consideration.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Clinical Consequences</strong>: Increased risk of ischemic events due decreased availability of clopidogrel's active metabolite. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The clinical consequences associated with a NPDI SHOULD be reported if known. Clinical consequences SHOULD refer health outcomes as specifically as possible. To support a computable representation of the NPDI, clinical consequences SHOULD be represented as one or more sets of terms from a terminology such as <a href="http://www.who.int/classifications/icd/en/" target="new">ICD-10</a> or <a href="https://www.snomed.org/snomed-ct" target="new">SNOMED-CT</a>. Such so called <i>value sets</i> MAY be referenced by a URI to a public repository such as the <a href="https://vsac.nlm.nih.gov/" target="new">Value Set Authority Center</a> that is maintained by the <a href="https://www.nlm.nih.gov/" target="new">United States National Library of Medicine</a>.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Seriousness</strong>: Ischemic events are serious can cause serious potential clinical consquences as it can result in death, life-threatening hospitalization, and disability.</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> A NPDI clinical consequence SHOULD be noted as <i>serious</i> if it can result in death, life-threatening hospitalization, congenital anomaly, disability, or if it requires intervention to prevent permanent impairment or damage.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Mechanism of Interaction</strong>: The mechanism of this interaction appears to be mediated through CYP2C19 inhibition by cannabis products. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> The mechanism of a NPDI SHOULD be reported if known. The description SHOULD be written for a clinician audience and include details that help the clinician decide what course of management action to take. To reduce ambiguity, the description MAY refer to specific drugs or health conditions using codes from terminologies.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Recommended Action</strong>: Monitor the patient for ischemic events and consider discontinuation of the cannabis product or use of another antiplatelet agent such as aspirin or another P2Y12 inhibitor. </td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Any recommended actions that apply to all patient exposures SHOULD be stated using clear and concise language. The recommended action statement SHOULD also provide citations to <a href='http://purl.obolibrary.org/obo/MPIO_0000004' target="new">evidence for a suspected drug-drug interaction</a> (not provided in this example). Recommendations that depend on <a href='http://purl.obolibrary.org/obo/MPIO_0000000' target="new">contextual information/modifying factors</a> SHOULD be mentioned separately to support context-specific presentation of such information.</td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Contextual information/modifying factors</strong>:
          <ol>
            <li>The patient is only on clopidogrel and a cannabinoid or the patient is on clopidogrel, a cannabinoid, and another non-CYP2C19 inhibitor
              <ul><strong>Recommended Action:</strong> No Special Precautions</ul>
              <ul><strong>Evidence for a Suspected Drug-Drug Interaction:</strong> Clopidogrel needs to be metabolized into it's active metabolite for it to be effective against ischemic events. (Plavix (clopidogrel) [prescribing information]) As such, cannabis inhibtion of CYP2C19 can cause an increase ischemic events.</ul>
            </li>
            <li>The patient is on clopidogrel, a cannabinoid, and an additional CYP2C19 inhibitor.
              <ul><strong>Recommended Action:</strong> Avoid Combination</ul>
              <ul><strong>Evidence for a Suspected Drug-Drug Interaction:</strong>  </ul>
               <ul>Since clopidogrel needs to be metabolized by CYP2C19, inhibtion of cannabis and other CYP2C19 inhibitors can potentially cause a significant increase in ischemic events.</ul>
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
	<td style="background-color: #f4fff2"><strong>Frequency of Exposure to the NPDI:</strong> Unknown</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Frequency of exposure and frequency of harm information is
          rarely available but can help a clinician assess the risk/benefit trade-off of exposure to NPDI. Such information SHOULD be provided if available. </td>
      </tr>
    </table>
    <table>
      <tr>
	<td style="background-color: #f4fff2"><strong>Frequency of Harm for persons who have been exposed to the NPDI:</strong> Unknown</td>
      </tr>
      <tr>
	<td><strong>Comment:</strong> Frequency of exposure and frequency of harm information is
          rarely available but can help a clinician assess the risk/benefit trade-off of exposure to NPDI. Such information SHOULD be provided if available. </td>
      </tr>
    </table>
</div>
