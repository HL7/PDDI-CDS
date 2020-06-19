[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-


# <span style="color:silver"> 1 </span> Implementation Guide for PDDI CDS (DRAFT)

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

## <span style="color:silver"> 1.1 </span> Introduction


## <span style="color:silver"> 1.2 </span> Intended Audiences

The primary intended audience includes individuals seeking guidance on how to implement drug-drug interaction clinical decision support using modern health information technology standards. This implementation guide is written with the intention of showing how potential drug-drug interaction (PDDI) alerts more specifically tailored to patient context could be presented through the electronic health record using modern standards. It is also written for a more general audience of individuals creating medication safety knowledge artifacts that they intend to  disseminate to healthcare organizations. 

## <span style="color:silver"> 1.3 </span> Collaborators and Funding

This implementation guide was developed by the Health Level 7 [(HL7)](http://wiki.hl7.org) [Clinical Decision Support Work Group (CDS WG)](http://wiki.hl7.org/index.php?title=Clinical_Decision_Support_Workgroup) in collaboration with the University of Pittsburgh, University of Utah, RWTH Aachen University, Clemson University, the Open Source Electronic Health Alliance (OSEHRA), the University of Arizona, and Wolters Kluwer Health. It was funded in part by by AHRQ grants: U18 HS027099, R01 LM011838, R21 HS023826 and R01 HS025984, and NLM grant T15 LM007124, R15 LM012941.

## <span style="color:silver"> 1.4 </span> Context

## <span style="color:silver"> 1.4.1 </span> Rationale

Clinical decision support has the potential to reduce adverse events associated with pharmacotherapy. Specifically, computerized PDDI checking at medication order entry is an efficient mechanism to bring conflicting therapies to clinicians' attention. In the United States, Meaningful Use incentives have supported the widespread dissemination of PDDI checking;<sup>[1](#references)</sup> however, researchers have found that a hight percentage (~90%) of PDDI alerts in computerized provider order entry (CPOE) systems are ignored.<sup>[2,3](#references)</sup> The reason for overriding PDDI alerts appears to be multi-factorial. The current widely-used approach of alerting based on simple pair-wise drug comparisons with no further consideration of patient context can lead to alerts with hight recall but low precision. This implementation guide provides guidance on how to use information in the electronic health record to make alerts more specifically relevant to a given patient. Moreover, medication alerts are typically presented at the end of the order entry task – after the decision has been made to prescribe a medication. A primary motivation for this implementation guide is to expand PDDI CDS to provide *actionable* information to clinicians earlier in the order entry process.

The burden of PDDI CDS governance falls to specific institutions, which may contribute to the broad discord of PDDI alerts among institutions.<sup>[4,5](#references)</sup> While the majority of health systems use third-party commercial knowledge bases that are integrated into the EHR alerting framework, each institution has the ability to customize the alert types and thresholds in relation to the knowledge base. A sharable service that coordinates drug knowledge and CDS alerts may reduce the variability and set a standard-of-care for PDDI CDS across institutions. Supporting this approach, both EHR vendors and drug knowledge vendors are beginning to adopt service-oriented data standards such as FHIR and CDS Hooks. In addition to standardizing care, a sharable service-based approach to PDDI CDS might help disperse the burden of optimizing alerts and maintaining drug knowledge.<sup>[6](#references)</sup>    

Patient-specific alerting is an overarching goal for PDDI CDS that has not been broadly achieved. The current state of high-sensitivity and low-specificity alerts is a known problem without a simple solution. The barriers are both theoretical and technological. The unique combinations of risk factors possessed by each individual patient increases the complexity of decisions. Moreover, alerts are often designed without due consideration for the clinician's decision making process. Conventional PDDI CDS approaches alert on simple pair-wise drug combinations without considering other data that could be used to tailor CDS for the specific patient. The knowledge base and technical framework need further development to account for patient factors to reduce the number of alerts and improve alert specificity. This implementation guide advances PDDI CDS by building on the Word Wide Web Consortium (W3C) Semantic Web in Health Care and Life Sciences Community Group project to make PDDI knowledge more comprehensive, standardized, and computable through a minimum information model.<sup>[7](#references)</sup> The W3C project provides non-ambiguous definitions for 10 core information items. It also provides 8 detailed best practice recommendations related to the 10 core information items. This implementation guide implements the W3C project's recommendations using a service-based approach and the emerging health information technology standards FHIR, CDS Hooks, and CQL. PDDI CDS that follows the recommendations in this guide should be more specific, actionable, and sharable than current PDDI alerts. Also, the approach allows for an efficient system to document physician actions in conjunction with relevant patient-specific information. In this regard, CDS implementers can track clinician responses for analyses that may lead to further refined PDDI CDS alerts. 

Finally, clinical expertise is crucial to developing clinically relevant CDS. However, a barrier exists between expressing clinical knowledge and writing the actual code used by CDS systems. CQL is an HL7 standard that was developed as an authoring language that is both structured and human readable.<sup>[8](#references)</sup> Moreover, CQL is a foundational component of national efforts to make CDS artifacts computable and interoperable such as [CDS Connect](https://cds.ahrq.gov/cdsconnect). This implementation guide usees CQL to represent executable PDDI CDS logic with the intention lowering the barrier for other implementers to use the codebase for their institution's needs.

## <span style="color:silver"> 1.4.2 </span> Assumptions

### <span style="color:silver"> 1.4.2.1 </span> Clinical
{:.no_toc}

PDDIs are, to an extent, theoretical due to knowledge gaps in the literature. Thus, alert specificity and individualized information is limited by available knowledge. The goal of contextualizing or individualizing these alerts is not only to reduce the number of alerts by increasing specificity, but also to improve the clinical relevance of the information that is presented. In this respect, PDDI CDS may function as an educational tool to raise awareness of known factors that may mitigate or potentiate the risk associated with PDDIs. Gaps in the literature relating to contextual factors is a known issue of the domain and is a key limitation to this and other PDDI CDS systems. Moreover, with this limitation, unknown medication adherence, and data quality/availability – it is ultimately the clinician's decision whether to proceed with potentially interacting drug orders. 

### <span style="color:silver"> 1.4.2.2 </span> Technical 
{:.no_toc}

An important requirement of CDS is that it provide clinically relevant information to the clinician at the right time. This implementation guide assumes that CDS is provided as a real-time remote service which the EHR (client) subscribes to at various points in the workflow of clinicians. The service requests clinical decision support based on the current patient context. The EHR client sends relevant contextual information as part of the request and receives clinically relevant suggestions describing potential actions to be taken. The CDS service must run efficiently to meet clinician expectations and not interrupt from the clinical workflow. Delays in presenting CDS information may lead to unsuccessful CDS adoption and clinician frustration. 

*TODO - need to reword this paragraph to remove DetectedIssue
To address workflow considerations, this implementation guide describes two complementary PDDI CDS scenarios: 1) CDS at the time that an ordering clinician selects a drug to add to an order ("order-select"), and 2) CDS at the time an ordering clinician signs a drug order ("order-sign"). It is possible for a stakeholder to implement both scenarios. In such case, the CDS service might trigger highly similar alerts at both order-select and order-sign. For example, if a clinican decides to ignore/over-ride a CDS suggestion presented at order-select, the CDS service might detect the same PDDI issue upon order-sign. This implementation guide defines a stateless approach where DetectedIssue resources returned from the order-select service refer to a unique identifier for the triggering PDDI knowledge artifact, thereby allowing client EHRs to choose how to handle apparently repeat CDS suggestions. 

In this guide, we assume that the service implementation complies with the [CDS Hooks Specification](http://cds-hooks.org/). CDS-Hooks is a standard that has gained considerable interest among EHR vendors. It is a “hook” based pattern designed to provide a simple way to initiate requests for CDS, from any point in a clinical workflow. It specifies the basic actions of registering for CDS services, calling those services, and then receiving the CDS service response in form of simple structured messages called "cards" that provide appropriate information and suggested actions within the context of the EHR. In CDS Hooks, "Prefetch" queries are a key component that supports the CDS system performance. These queries assemble relevant data from the EHR prior to submitting a request to the CDS service. Depending on the patient and service, prefetch data may encompass a variety resources captured during various time periods, so it is crucial that implementors and clinicians refine prefetch template parameters to obtain only data that is clinically relevant. See this implementation guide's discussion of the [CDS Service specification applied to PDDI CDS](./cds-service-spec.html) for more information.


## <span style="color:silver"> 1.4.3 </span> Related Projects 

The [Use Case](./use-cases.html) section of this implementation guide describes a representative clinical PDDI example that is used for illustration throughout this implementation guide. PDDI CDS artifacts were created from the use case at a narrative, semi-structured, and fully executable level. The artifacts comply with the a minimum information model for potential drug-drug interaction knowledge and evidence described in a W3C Community Interest Group Note.<sup>[7](#references)</sup>

The example CDS services shown in this implementation guide were written without the use of a specific authoring tool. The [Clinical Decision Support Authoring Tool](https://cds.ahrq.gov/cdsconnect/authoring) is a component of the CDS Connect project funded by the Agency for Healthcare Research and Quality [(AHRQ)](https://www.ahrq.gov/). It is possible to use the authoring tool to develop PDDI CDS logic using CQL. Interested persons can access [a test version of the tool with these features on GitHub](https://github.com/dbmi-pitt/AHRQ-CDS-Connect-Authoring-Tool). However, the authoring tool was not used to assist with PDDI CDS that usese CDS Hooks as specified in this implementation guide. 

## <span style="color:silver"> 1.3 </span> Scope

This implementation guide:

1. Describes a potential PDDI CDS use case (Warfarin + NSAIDs):

	* CDS at the time that an ordering clinician selects a drug to add to an order ("order-select"), and 
	* CDS at the time an ordering clinician signs a drug order ("order-sign")

2. Provides implementation guidance for actionable PDDI alerts using sharable CDS artifacts that adhere to a [minimum information model for representing clinically actionable knowedge about PDDIs](https://w3id.org/hclscg/pddi)

3. Provides knowledge artifacts and related resources using the following HIT specifications:

	* [CDS Hooks](http://cds-hooks.org/)
	* [FHIR](http://www.fhir.org/)
	* [CQL](https://ecqi.healthit.gov/cql-clinical-quality-language)


<a name="references"></a>

#### References
{:.no_toc}
   
1. Centers for Medicare and Medicated Services. Eligible Professional Meaningful Use Core Measures Measure 2 of 14. 2013 April (cited 2018 August). Available from: https://www.cms.gov/Regulations-and-Guidance/Legislation/EHRIncentivePrograms/Downloads/2013DefinitionEP_2_Drug_Interaction_Checks.pdf. 
2. Bryant AD, Fletcher GS, Payne TH. Drug Interaction Alert Override Rates in the Meaningful Use Era: No Evidence of Progress. Applied Clinical Informatics. 2014;5(3):802-813. doi:10.4338/ACI-2013-12-RA-0103.
3. Van der Sijs H, Aarts J, Vulto A, Berg M. Overriding of Drug Safety Alerts in Computerized Physician Order Entry. Journal of the American Medical Informatics Association : JAMIA. 2006;13(2):138-147. doi:10.1197/jamia.M1809.
4. McEvoy DS, Sittig DF, Hickman T-T, et al. Variation in high-priority drug-drug interaction alerts across institutions and electronic health records. Journal of the American Medical Informatics Association : JAMIA. 2017;24(2):331-338. doi:10.1093/jamia/ocw114.and 5.
5. Fung KW, Kapusnik-Uner J, Cunningham J, Higby-Baker S, Bodenreider O. Comparison of three commercial knowledge bases for detection of drug-drug interactions in clinical decision support. Journal of the American Medical Informatics Association : JAMIA. 2017;24(4):806-812. doi:10.1093/jamia/ocx010.
6. Tilson H, Hines LE, McEvoy G, et al. Recommendations for Selecting Drug-Drug Interactions for Clinical Decision Support. American journal of health-system pharmacy : AJHP : official journal of the American Society of Health-System Pharmacists. 2016;73(8):576-585. doi:10.2146/ajhp150565.
7. World Wide Web Consortium (W3C) Semantic Web in Health Care and Life Sciences Community Group. A Minimum Representation of Potential Drug-Drug Interaction Knowledge and Evidence - Technical and User-centered Foundation. May 8, 2019. https://w3id.org/hclscg/pddi. 
8. Health Level Seven International. HL7 Cross-Paradigm Specification: Clinical Quality Language, Release 1. 2017 May (cited 2018 August). Available from: http://www.hl7.org/implement/standards/product_brief.cfm?product_id=400.
    
