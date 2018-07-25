-*- --from markdown_strict+footnotes+backtick_code_blocks -*-

## Introduction

This implementation guide was developed for potential drug-drug interaction (PDDI) clinical decision support (CDS). It was developed by the Clinical Decision Support Work Group in collaboration with University of Pittsburgh Medical Center, RWTH Aachen University, and Wolters Kluwer Health. The project focused on developing standardized and shareable artifacts to contextualize PDDIs.


## Scope

This implementation guide is for PDDI CDS. The guide specifies both a knowledge representation format for PDDI logic and CDS services. Specifically, the implementation guide includes specifications for:

* How to represent PDDI logic in CQL and evidence in computational format using the FHIR Clinical Reasoning module.
* How to use CDS Hooks as a mechanism for EHRs to request PDDI CDS from CDS services.
 


## A Project Rationale

New information regarding potential drug-drug interactions (PDDIs) is published every day in primary sources such as drug product labeling
     and the scientific literature. A PubMed search for publications indexed with the Medical Subject Headings keyword “Drug interactions” shows
     an average of 3,970 publications per year from 2000 through 2016. This suggests that the body of evidence about PDDIs is overwhelming and
     dynamic. Food and drug regulatory agencies in the United States, European Union, and Japan have issued guidance to industry recommending
     the use of drug product labeling to communicate potential involvements in drug interactions (Rekić et al. 2017). As it is impossible for
     clinicians to keep up with the PDDI evidence base, drug experts generate summaries of PDDI evidence from primary sources. These summaries
     bring PDDI knowledge to clinicians in the form of published drug information compendia, clinical decision support rules, and interaction
     checking applications. <b> However, there are currently no broadly accepted standards to guide these experts in the knowledge representation
     and services implementation of PDDI information that would be most effective for clinical decision support.</b> Without international coordination
     for the extensions and profiles used to express PDDI CDS, needless variation is certain to occur in implementations. This project will provide
     the opportunity for the international community to collaborate and come to consensus on patterns used in implementations.

   This need for a standard representation of PDDI information was one of the topics addressed at two multi-stakeholder conference meetings/series
    (Hines et al. 2011; Scheife et al. 2015; Payne et al. 2015; Tilson et al. 2016). Attendees at both conferences included international stakeholders
    from drug information content providers, regulatory agencies, and academic organizations. Among the key recommendations was the following suggested
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
   
 These core information elements are consistent with the results of a separate international Delphi study on how to
     improve the delivery of medication alerts within computerized physician order entry systems (Riedmann et al. 2011).
     This suggested list of core information elements includes some that are present in one or more of the 15 PDDI conceptual models
     analyzed in a recent comprehensive review by Herrero-Zazo, Segura-Bedmar, and Martínez (Herrero-Zazo et al. 2016). However, there
     is little commonality across the conceptual models on those elements that are included and no single conceptual model covers all 9
     of the information elements. Moreover, the creation and maintenance of PDDI decision support generally requires considerable time
     and energy from highly trained domain experts. An additional need is to standardize the EHR context that is sent to CDS services.
     This includes context parameters that are currently not available but that, if present, would be useful for increasing the specificity
     of the CDS alerts. This is important to ensure that PDDI decision support can be implemented across a variety of systems.
    

### Collaborators

W3C Healthcare and Lifesciences Working Group. A volunteer-based task force <a href="https://www.w3.org/wiki/HCLSIG/DDI">https://www.w3.org/wiki/HCLSIG/DDI</a>
    was formed in January 2016 within the Health Care and Life Sciences Interest Group that operates publicly through
    the World Wide Web Consortium (W3C). The goal of the task force was to develop a minimal information model for drug
    interaction evidence and knowledge as part of an HIT standard like HL7. The workgroup’s results will serve as requirements
    and business knowledge for the current project. The task force is in the process of finalizing a draft Interest Group Note
    that provides use cases, user stories, definitions, and exemplar potential drug-drug interaction descriptions for a minimal
    information model for drug interaction evidence and knowledge.
