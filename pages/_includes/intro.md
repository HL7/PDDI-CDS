[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

* **TODO** position this from the position this from the EHR is doing something but more can be done with the standard, etectedIssue is monitoring what is happen 

* **TODO** Citations and linking 


# <span style="color:silver"> 1.0.0 </span> Implementation Guide for PDDI CDS (DRAFT)

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

## <span style="color:silver"> 1.1.0 </span> Introduction

This implementation guide (IG) is targeted at stakeholders who seek to increase the specificity and clinical relevance of drug-drug interaction alerts presented through the electronic health record. The approach is service-oriented and uses Web standards, a minimum information model for potential drug interactions, and emerging Health Information Technology standards including [CDS Hooks](http://cds-hooks.org/), Fast Health Interoperability Resources ([FHIR](http://www.fhir.org/)), and Clinical Quality Language [(CQL)](https://ecqi.healthit.gov/cql-clinical-quality-language).

## <span style="color:silver"> 1.2.0 </span> Collaborators

This implementation guide was developed by the [Clinical Decision Support Work Group](http://wiki.hl7.org/index.php?title=Clinical_Decision_Support_Workgroup) of [Health Level 7 (HL7)](http://wiki.hl7.org)  in collaboration with University of Pittsburgh Medical Center, RWTH Aachen University, and Wolters Kluwer Health.


## <span style="color:silver"> 1.3.0 </span> Scope

This implementation guide:

1. Describes knowledge and decision points for two exemplar potential drug-drug interaction (PDDI) clinical decision support (CDS) artifacts: [Warfarin + NSAIDs](documentation.html) and [Digoxin + Cyclosporine](documentation.html)

2. Provides structured code for CDS artifacts using the following Health Information Technology (HIT) specifications:

	* HL7 – Fast Health Interoperability Resources ([FHIR](http://www.fhir.org/))

	* [CDS Hooks](http://cds-hooks.org/)

	* Clinical Quality Language [(CQL)](https://ecqi.healthit.gov/cql-clinical-quality-language)

3. Proposes and provides guidance to implement efficient PDDI CDS artifacts

> *Note:* This IG describes two levels of PDDI CDS implementation. Level 1 implementation enables stakeholders to start using PDDI CDS with marked benefits over current PDDI alerting systmes. Level 2 implementation extends and optimizes the PDDI CDS. For specific differences in Level 1 and 2 implementations, see section X under the Getting Started tab.

## <span style="color:silver"> 1.4.0 </span> A Project Rationale

Clinical decision support has the potential to reduce adverse outcomes associated with pharmacotherapy. Specifically, computerized PDDI checking at the time of ordering is an efficient mechanism to bring conflicting therapies to clinicians' attention. In the United States, Meaningful Use incentives have supported the widespread dissemination of PDDI checking,(cite https://www.cms.gov/Regulations-and-Guidance/Legislation/EHRIncentivePrograms/Downloads/2013DefinitionEP_2_Drug_Interaction_Checks.pdf) the acceptance rate of alerts is abysmal. Researchers have found that nearly all PDDI alerts in computerized provider order entry (CPOE) systems are ignored.(cite https://www.ncbi.nlm.nih.gov/pubmed/25298818 and refer to Van Der Sijis to show the stubborness of this statistic) The reason for overriding PDDI alerts appears to be multi-factorial. For example, simple pair-wise drug comparisons can lead to overly sensitive alerts and desensitized clinicians. Moreover, medication alerts are typically presented the end of the order entry task – after the decision has been made to prescribe the medication. Among the motivations for this implementation guide is to expand PDDI CDS to provide useful information to clinicians earlier in the order entry process.

The burden of PDDI CDS governance falls to specific institutions contributing to the broad discord that currently exists in PDDI alerts when examined across health care institutions (cite McEvoy 27570216 and Fung  28339701). While the majority of health systems use commercial knowledge bases that are integrated into the EHR framework, each implementation customizes the knowledge base to site-specific requirements. One solution to setting a standard of care for PDDI CDS while reducing the variability of alerts across sites is to develop PDDI CDS as a sharable service. Supporting this approach, both EHR vendors and drug knowledge vendors are beginning to adopt service-oriented data standards such as FHIR and CDS Hooks. In addition to standardizing care, a sharable service-based approach to PDDI CDS can help disperse the burden of optimizing alerts and maintaining drug knowledge(cite https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5064943/).      

Personalization of CDS alerts is an overarching goal of PDDI CDS that has not yet been broadly acheived. The current state of high-sensitivity and low-specificity alerts is a known problem without a simple solution. The barriers are both theoretical and technological. Individual patients have unique combinations of risk factors. Alerts are often designed without due consideration of a clinician's decision making process. For example, traditional PDDI CDS approaches alert on simple pair-wise drug combinations without considering data in the EHR that could be used to tailor CDS for the specific patient case. In other words, the knowledge base and technical framework need further development to account for patient factors in order to reduce the number of alerts and improve alert specificity. This IG  advances toward this goal by building on Word Wide Web Consortium (W3C) community group project to make PDDI knowledge more comprehensive, standardized, and computable through a minimum information model.(cite W3C) 

Finally, clinical expertise is crucial to developing clinically relevant CDS. However, a barrier exists between expressing clinical knowledge and writing the actual code used by CDS systems. Clinical Quality Language [(CQL)](https://ecqi.healthit.gov/cql-clinical-quality-language) is an HL7 standard (cite http://www.hl7.org/implement/standards/product_brief.cfm?product_id=400) that was developed as an authoring language standard that is both structured for electronic queries and human readable. Moreover, CQL is a foundational component of national efforts, such [CDS Connect](https://cds.ahrq.gov/cdsconnect) in the United States, to make CDS artifacts computable, interoperable. This Implementation Guide applies CQL to PDDI CDS, which may lower the barrier for other implementors to use the codebase for their institution's needs.

### <span style="color:silver"> 1.4.1 </span> W3C Effort

This IG builds on the the W3C Community Group Note *"A Minimum Representation of Potential Drug-Drug Interaction Knowledge and Evidence - Technical and User-centered Foundation"* is to provide a technical and user-centered foundation for a minimum information model for PDDI information. The principal contributions include:

* definitions for the model's core information items, examples of using these definitions to represent two PDDIs, and a set of additional PDDIs selected as case studies for future work on the information model;

* clarification on the intended users of the information model along with use stories and specific information needs; and

* a statement on the appropriate scope of knowledge representation for the information model.
The focus of this document is definition of the model, not representation.

This Community Group Note provides motivation and a detailed domain analysis for a minimum information model for PDDI information which includes the following elements: 

   * Clinical consequences
   * Contextual information/modifying factors
   * Drugs involved 
   * Evidence
   * Frequency of exposure to the interacting drug pair
   * Frequency of harm for persons who have been exposed to the interacting drug pair
   * Mechanism of the interaction
   * Recommended actions
   * Seriousness rating

The Note also suggests potential applications of the minimum information model that could lead to improvements in patient safety with respect to PDDIs. The overarching goal of these contributions is to provide a technical foundation for effective PDDI clinical decision support. 

   
    
