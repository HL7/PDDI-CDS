[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-


# <span style="color:silver"> 1.0.0 </span> Implementation Guide for PDDI CDS (DRAFT)

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

## <span style="color:silver"> 1.1.0 </span> Introduction

This implementation guide is targeted at stakeholders who seek to increase the specificity and clinical relevance of potential drug-drug interaction (PDDI) alerts presented through the electronic health record. The approach is service-oriented and uses Web standards, a PDDI minimum information model, and emerging Health Information Technology (HIT) standards including [CDS Hooks](http://cds-hooks.org/), Fast Health Interoperability Resources [(FHIR)](http://www.fhir.org/), and Clinical Quality Language [(CQL)](https://ecqi.healthit.gov/cql-clinical-quality-language).

## <span style="color:silver"> 1.2.0 </span> Collaborators and Funding

This implementation guide was developed by the Health Level 7 [(HL7)](http://wiki.hl7.org) Clinical Decision Support Work Group [CDS WG](http://wiki.hl7.org/index.php?title=Clinical_Decision_Support_Workgroup) in collaboration with the University of Pittsburgh Medical Center (UPMC), RWTH Aachen University, the Open Source Electronic Health Alliance (OSEHRA), the University of Arizona, and Wolters Kluwer Health. It was funded by AHRQ grants: R01 LM011838, R21 HS023826 and R01 HS025984, and NLM grant T15 LM007124.


## <span style="color:silver"> 1.3.0 </span> Scope

This implementation guide:

1. Describes two exemplar potential PDDI CDS artifacts: [Warfarin + NSAIDs](documentation.html) and [Digoxin + Cyclosporine.](documentation.html)

2. Provides structured code for artifacts using the following HIT specifications:

	* [FHIR](http://www.fhir.org/)
	* [CDS Hooks](http://cds-hooks.org/)
	* [CQL](https://ecqi.healthit.gov/cql-clinical-quality-language)

3. Proposes and provides guidance to implement efficient PDDI CDS artifacts.

> *Note:* This implementation guide describes two levels of PDDI CDS implementation. Level 1 Implementation enables stakeholders to start using PDDI CDS with benefits over conventional PDDI alerting systems. Level 2 Implementation extends and optimizes the PDDI CDS. The [Getting Started](start.html) tab specifies differences between the two levels of implementation.

## <span style="color:silver"> 1.4.0 </span> Project Rationale

Clinical decision support has the potential to reduce adverse outcomes associated with pharmacotherapy. Specifically, computerized PDDI checking at medication order entry is an efficient mechanism to bring conflicting therapies to clinicians' attention. In the United States, Meaningful Use incentives have supported the widespread dissemination of PDDI checking;<sup>1</sup> however, researchers have found that nearly all PDDI alerts in computerized provider order entry (CPOE) systems are ignored.<sup>2,3</sup> The reason for overriding PDDI alerts appears to be multi-factorial. Simple pair-wise drug comparisons can lead to overly sensitive alerts and desensitized clinicians. Moreover, medication alerts are typically presented the end of the order entry task – after the decision has been made to prescribe a medication. A primary motivation for this implementation guide is to expand PDDI CDS to provide *actionable* information to clinicians earlier in the order entry process.

The burden of PDDI CDS governance falls to specific institutions, which may contribute to the broad discord of PDDI alerts among institutions.<sup>4,5</sup> While the majority of health systems use third-party commercial knowledge bases that are integrated into the EHR alerting framework, each institution has the ability to customize the alert types and thresholds in relation to the knowledge base. A sharable service that coordinates drug knowledge and CDS alerts may reduce the variability and set a standard of care for PDDI CDS across institutions. Supporting this approach, both EHR vendors and drug knowledge vendors are beginning to adopt service-oriented data standards such as FHIR and CDS Hooks. In addition to standardizing care, a sharable service-based approach to PDDI CDS can help disperse the burden of optimizing alerts and maintaining drug knowledge.<sup>6</sup>    

Personalized alerting is an overarching goal of PDDI CDS that has not been broadly achieved. The current state of high-sensitivity and low-specificity alerts is a known problem without a simple solution. The barriers are both theoretical and technological. Individual patients have unique risk factor combinations that increase the complexity of decisions, and alerts are often designed without due consideration for the clinician's decision making process. Conventional PDDI CDS approaches alert on simple pair-wise drug combinations without considering other data that could be used to tailor CDS for the specific patient. In other words, the knowledge base and technical framework need further development to account for patient factors to reduce the number of alerts and improve alert specificity. This implementation guide advances toward improving alert specificity by building on the Word Wide Web Consortium (W3C) community group project to make PDDI knowledge more comprehensive, standardized, and computable through a minimum information model.<sup>7</sup> The W3C project and resulting minimum information model support defining and presenting actionable PDDI information at the point of care. This implementation guide not only leverages knowledge and technologies to support presenting actionable PDDI recommendations, but also provides an efficient system to document these actions in conjunction with relevant patient-specific information. In this regard, implementors can track clinician responses for analyses that may lead to further refined PDDI CDS alerts. 

Finally, clinical expertise is crucial to developing clinically relevant CDS. However, a barrier exists between expressing clinical knowledge and writing the actual code used by CDS systems. CQL is an HL7 standard that was developed as an authoring language that is both structured and human readable.<sup>8</sup> Moreover, CQL is a foundational component of national efforts, such as [CDS Connect](https://cds.ahrq.gov/cdsconnect) in the United States, to make CDS artifacts computable and interoperable. This implementation guide applies CQL to PDDI CDS, which may lower the barrier for other implementors to use the codebase for their institution's needs.

### <span style="color:silver"> 1.4.1 </span> W3C Effort

This implementation guide builds on the the W3C Community Group Note, *"A Minimum Representation of Potential Drug-Drug Interaction Knowledge and Evidence - Technical and User-centered Foundation."* This Note provides a technical and user-centered foundation for a PDDI minimum information model. The overarching goal of this project was to support effective PDDI CDS. The principal contributions of the Note include:

1. definitions for the model's core information items, examples of using these definitions to represent two PDDIs, and a set of additional PDDIs selected as case studies for future work using the information model;

2. clarification of model users, use cases, and specific information needs;

3. statement on the appropriate scope of knowledge representation for the information model;

4. potential applications of the minimum information model that could lead to improved patient safety.

This Community Group Note provides motivation and a detailed domain analysis for structuring PDDI knowledge with the minimum information model. The model elements include: 

   * **Clinical consequences**
   * **Contextual information/modifying factors**
   * **Drugs involved** 
   * **Evidence**
   * **Frequency of exposure to the interacting drug pair**
   * **Frequency of harm for persons who have been exposed to the interacting drug pair**
   * **Mechanism of the interaction**
   * **Recommended actions**
   * **Seriousness rating**

#### References
{:.no_toc}
   
1. Centers for Medicare and Medicated Services. Eligible Professional Meaningful Use Core Measures Measure 2 of 14. 2013 April (cited 2018 August). Available from: https://www.cms.gov/Regulations-and-Guidance/Legislation/EHRIncentivePrograms/Downloads/2013DefinitionEP_2_Drug_Interaction_Checks.pdf. 
2. Bryant AD, Fletcher GS, Payne TH. Drug Interaction Alert Override Rates in the Meaningful Use Era: No Evidence of Progress. Applied Clinical Informatics. 2014;5(3):802-813. doi:10.4338/ACI-2013-12-RA-0103.
3. Van der Sijs H, Aarts J, Vulto A, Berg M. Overriding of Drug Safety Alerts in Computerized Physician Order Entry. Journal of the American Medical Informatics Association : JAMIA. 2006;13(2):138-147. doi:10.1197/jamia.M1809.
4. McEvoy DS, Sittig DF, Hickman T-T, et al. Variation in high-priority drug-drug interaction alerts across institutions and electronic health records. Journal of the American Medical Informatics Association : JAMIA. 2017;24(2):331-338. doi:10.1093/jamia/ocw114.and 5.
5. Fung KW, Kapusnik-Uner J, Cunningham J, Higby-Baker S, Bodenreider O. Comparison of three commercial knowledge bases for detection of drug-drug interactions in clinical decision support. Journal of the American Medical Informatics Association : JAMIA. 2017;24(4):806-812. doi:10.1093/jamia/ocx010.
6. Tilson H, Hines LE, McEvoy G, et al. Recommendations for Selecting Drug-Drug Interactions for Clinical Decision Support. American journal of health-system pharmacy : AJHP : official journal of the American Society of Health-System Pharmacists. 2016;73(8):576-585. doi:10.2146/ajhp150565.
7. World Wide Web Consortium (W3C). Community Group Note, A Minimum Representation of Potential Drug-Drug Interaction Knowledge and Evidence - Technical and User-centered Foundation.
8. Health Level Seven International. HL7 Cross-Paradigm Specification: Clinical Quality Language, Release 1. 2017 May (cited 2018 August). Available from: http://www.hl7.org/implement/standards/product_brief.cfm?product_id=400.
    
