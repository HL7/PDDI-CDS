[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

# <span style="color:silver"> 1.0.0 </span> Implementation Guide for PDDI CDS

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

## <span style="color:silver"> 1.1.0 </span> Introduction

**TODO: write this last sort of like an abstract**


## <span style="color:silver"> 1.2.0 </span> Scope

This implementation guide:
* Describes knowledge and decision points for two PDDI CDS artifacts: 
    * [Warfarin + NSAIDs](documentation.html)
    * [Digoxin + Cyclosporine](documentation.html)
* Provides structured code for CDS artifacts using released technology specifications:
    * Health Level 7 (HL7), Fast Health Interoperability Resources ([FHIR](http://www.fhir.org/))
    * [CDS Hooks](http://cds-hooks.org/)
    * Clinical Quality Language [(CQL)](https://ecqi.healthit.gov/cql-clinical-quality-language)
* Proposes methodology to improve the acceptance of PDDI alerts and provides technology modification guidance to accommodate this methodology

> *Note:* This Implementation Guide provides a Basic and Advanced version. The Basic version relates to current technology specifications and artifacts that are provided. The Advanced version is a goal for the creators of this Implementation Guide to obtain in future iterations.

## <span style="color:silver"> 1.3.0 </span> A Project Rationale

Clinical decision support has the potential to reduce adverse outcomes associated with pharmacotherapy. Specifically, computerized drug-drug interaction checking is an efficient mechanism to bring conflicting therapies to clinicians' attention. While Meaningful Use incentives have supported the widespread dissemination of PDDI checking,(cite) the acceptance rate of the alerts is abysmal. Researchers have found that nearly all PDDI alerts in computerized provider order entry (CPOE) systems are ignored.(cite Van Der Sijis or other) The reason for overriding PDDI alerts appears to be multi-factorial. For example, simple pair-wise drug comparisons can lead to overly sensitive alerts and desensitized clinicians. Moreover, medication alerts are typically presented the end of the order entry task – after the decision has been made to prescribe the medication. The motivation of this Implementation Guide is, in part, to explore a process of providing information earlier in the order entry process.      

There is broad discord in PDDI alerts among health care institutions. While the majority of PDDI CDS systems are integrated into the EHR framework, each EHR implementation is customized to the institution's requirements. The burden of PDDI CDS governance falls on the specific institutions. Moreover, larger vendors frequenlty contract the drug knowledge base to a third-party, which increases the complexity and furthers variability of PDDI CDS.(cite Fung  28339701) One solution to reducing the variability of alerts and setting a standard of care is to develop PDDI CDS as a sharable service. Supporting this approach, EHR vendors are beginning to adopt data standards such as FHIR and CDS Hooks, and drug knowledge vendors, intent on improving service, view this approach as a mechanism to improve patient care. In addition to standardizing care, a sharable service-based approach to PDDI CDS can help disperse the burden of optimizing alerts and maintaining drug knowledge(cite https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5064943/).      

Individualizing medication alerts is an overarching goal of PDDI CDS. The current state of high-sensitivity and low-specificity alerts is a known problem without a simple solution. The barriers are both theoretical and technological. Patients are unique with factor combinations that frequently relegate them outside the clinical trial cohort category. Moreover, a clinician's decision making process and conclusions are dictated by factors that may not be fully substantiated in the literature. Traditional PDDI CDS approaches avoid this complexity by alerting on simple pair-wise comparisons; therefore, the knowledge base and technical framework have not been developed to account for patient factors. Accounting for patient factors can reduce the number of alerts and improve the specificity. This implementation guide builds on efforts to improve drug knowledge (cite W3C) by exploring technology methods that enable clincally relevant expression of the drug knowledge.        

Clinical expertise is crucial to developing clinically relevant CDS; however, a barrier exists between expressing clinical knowledge and CDS codebase. In an effort to support the contextual nature of medicine, Clinical Quality Language [(CQL)](https://ecqi.healthit.gov/cql-clinical-quality-language) was developed as an authoring language standard that is structured for electronic queries but is human readable. This Implementation Guide applies CQL to PDDI CDS, which will lower the barrier for other implementors to use the codebase for their institution's needs. 

### <span style="color:silver"> 1.3.1 </span> W3C Effort
New information regarding PDDIs is published every day in primary sources such as drug product labeling
     and the scientific literature. A PubMed search for publications indexed with the Medical Subject Headings keyword “Drug interactions” shows
     an average of 3,970 publications per year from 2000 through 2016. This suggests that the body of evidence about PDDIs is overwhelming and
     dynamic. Food and drug regulatory agencies in the United States, European Union, and Japan have issued guidance to industry recommending
     the use of drug product labeling to communicate potential involvements in drug interactions (Rekić et al. 2017) **TODO: PLACE REFERENCE**. As it is impossible for
     clinicians to keep up with the PDDI evidence base, drug experts generate summaries of PDDI evidence from primary sources. These summaries
     bring PDDI knowledge to clinicians in the form of published drug information compendia, clinical decision support rules, and interaction
     checking applications. **TODO: check that this makes sense relative to the publishing of the W3C note**  <b> However, there are currently no broadly accepted standards to guide these experts in the knowledge representation
     and services implementation of PDDI information that would be most effective for clinical decision support.</b> Without international coordination
     for the extensions and profiles used to express PDDI CDS, needless variation is certain to occur in implementations. This project will provide
     the opportunity for the international community to collaborate and come to consensus on patterns used in implementations.

   This need for a standard representation of PDDI information was one of the topics addressed at two multi-stakeholder conference meetings/series
   **TODO: REFERENCE AND ELSEWHERE IN THIS PAGE** (Hines et al. 2011; Scheife et al. 2015; Payne et al. 2015; Tilson et al. 2016). Attendees at both conferences included international stakeholders
    from drug information content providers, regulatory agencies, and academic organizations. **TODO: probably reference the W3C note rather than this citation**  Among the key recommendations was the following suggested
    set of core information that should be included for every PDDI mentioned in a clinically-oriented drug information resource (Payne et al. 2015):
    
   * Drugs involved 
   * Clinical consequences
   * Frequency of exposure to the interacting drug pair
   * Frequency of harm for persons who have been exposed to the interacting drug pair
   * Contextual information/modifying factors
   * Evidence
   * Mechanism of the interaction
   * Recommended actions
   * Seriousness rating
   
    

## <span style="color:silver"> 1.4.0 </span> Collaborators

This implementation guide was developed for potential drug-drug interaction (PDDI) clinical decision support (CDS). It was developed by the Clinical Decision Support Work Group in collaboration with University of Pittsburgh Medical Center, RWTH Aachen University, and Wolters Kluwer Health. The project focused on developing standardized and shareable artifacts to contextualize PDDIs.

