
# <span style="color:silver"> 2.0.0 </span> Use Case - a potential interaction between warfarin and non-steroidal anti-inflammatory drugs (NSAIDs)

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

The  Warfarin + NSAIDs knowledge artifact represents a relatively complex contextualized PDDI CDS algorithm. The knowledge artifact contains logic that uses both drug and patient contextual factors. The original rule was developed by clinical experts as part of the W3C Community Group effort to develop a [minimum information model for representing clinically actionable knowedge about PDDIs](https://w3id.org/hclscg/pddi). Table 1 is the Warfarin + NSAIDs knowledge artifact at the narrative level using the minimum information model. 

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
	<a href = "assets/images/Warfarin-NSAID-TREE-opthalmic-addition.png" target ="_blank" > <img src="assets/images/Warfarin-NSAID-TREE-opthalmic-addition.png" class="figure-img img-responsive img-rounded center-block" alt="Warfarin + NSAID PDDI" /></a>
</figure>

<p style="text-align: left"><strong>Footnotes:</strong>
<ol type="1">
  <li style="text-align: left">Topical diclofenac has relatively low systemic absorption; in one study a topical gel (16 g/day) produced about 6% of the absorption seen with systemic administration of 150 mg/day. A higher than recommended dose of topical gel (48 g/day) produced 20% of a systemic dose of diclofenac. The UK Summary of Product Characteristics for Voltarol Ophtha Multidose Eye Drops states, "No measurable levels of diclofenac could be found in humans after ocular application of diclofenac sodium eye drops". The FDA-approved SPL for Diclofenac Sodium Ophthalmic Solution 0.1% states, "Results from a bioavailability study established that plasma levels of diclofenac following ocular instillation of two drops of Diclofenac sodium ophthalmic solution, 0.1% to each eye were below the limit of quantification (10 ng/mL) over a 4-hour period. This study suggests that limited, if any, systemic absorption occurs with Diclofenac sodium ophthalmic solution". </li>
  <li style="text-align: left">If the NSAID is being used as an analgesic or antipyretic, it would be prudent to use an alternative such as acetaminophen. In some people, acetaminophen can increase the anticoagulant effect of warfarin, so monitor the INR if acetaminophen is used in doses over 2 g/day for a few days. For more severe pain consider short-term opioids in place of the NSAID.</li>
  <li style="text-align: left">Proton pump inhibitors and misoprostol may reduce the risk of UGIB in patients receiving NSAIDs and warfarin.</li>
  <li style="text-align: left">Patients with a history of UGIB or peptic ulcer may have an increased risk of UGIB from this interaction. The extent to which older age is an independent risk factor for UGIB due to these interactions is not firmly established, but UGIB in general is known to increase with age.</li>
  <li style="text-align: left">Both corticosteroids and aldosterone antagonists have been shown to substantially increase the risk of UGIB in patients on NSAIDs, with relative risks of 12.8 and 11 respectively compared to a risk of 4.3 with NSAIDs alone [[masclee-2014]]</li>
</ol>
</p>


#### Warfarin-NSAIDS PDDI PDDI Minimum Information Model Elements
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

# <span style="color:silver"> 2.1.0 </span> Digoxin + Cyclosporine


#### Digoxin + Cyclosporine Logic Table 
{:.no_toc}

<figure class="figure">
	<figcaption class="figure-caption">
		Legend: <span style="color: #30d529">&#9678;</span> = No special precautions.
		<span style="color: #f9bd3b">&#9632;</span> = Assess risk and take action if necessary.
		<span style="color: #fb0082">&#9670;</span> = Use only if benefit outweighs risk. 
		<br>
		Note that this rule was originally developed through &quot;Individualized Drug Interactions&quot; (AHRQ Project R21-HS023826-01) by Thomase Reese, Daniel Malone, John Horn, and Philp Hansten.
	</figcaption>
	<a href = "assets/images/Digoxin_Cyclosporine_tree.png" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_tree.png" class="figure-img img-responsive img-rounded center-block" alt="Digoxin + Cyclosporine PDDI" /></a>
</figure>

<p style="text-align: left"><strong>Footnotes:</strong>
<ol type="1">
	<li style="text-align: left"> For patients with a reliable plasma digoxin concentration in normal range, it is reasonable to anticipate an increase in plasma concentrations after the initiation of cyclosporine. Following initiation, close monitoring and adjusting the digoxin dose as needed is recommended. (Dorian et al. Clin Invest Med 1988; 11(2):108-112) (Dorian et al. Transplant Proc. 1987; 19(1):1825-1827) </li>
	<li style="text-align: left"> 50-70% of digoxin is excreted unchanged in the urine. Changing renal function may increase serum concentrations and risk of toxicity, (Digoxin-FDA [prescribing information] NDA 20405/S-004) </li>
	<li style="text-align: left"> Hypokalemia, hypomagnesemia, and hypercalcemia may potentiate digoxin toxicity. (Lip et al. Postgrad Med J. 1993; 69(811):337)  </li>
</ol>
</p>


#### Digoxin + Cyclosporine PDDI Minimum Information Model Elements
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