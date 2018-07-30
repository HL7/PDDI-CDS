[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

## Introduction

**TODO: write this last sort of like an abstract**


## Scope

This implementation guide:
* Describes knowledge and decision points for two PDDI CDS artifacts: 
    * [Warfarin + NSAIDs](documentation.html)
    * [and Digoxin + Cyclosporine](documentation.html)
* Provides structured code for CDS artifacts using released technology specifications:
    * Health Level 7 (HL7), Fast Health Interoperability Resources ([FHIR](http://www.fhir.org/))
    * [CDS Hooks](http://cds-hooks.org/)
    * Clinical Quality Language [(CQL)](https://ecqi.healthit.gov/cql-clinical-quality-language)
* Proposes methodology to improve the acceptance of PDDI alerts and provides technology modification guidance to accommodate this methodology   


## A Project Rationale

Clinical decision support has the potential to reduce adverse outcomes associated with pharmacotherapy. Specifically, computerized drug-drug interaction checking is an efficient mechanism to bring conflicting therapies to clinicians' attention. While Meaningful Use incentives have supported the widespread dissemination of PDDI checking, the acceptance rate of the alerts is abysmal. Researchers have found that nearly all PDDI alerts in computerized provider order entry (CPOE) systems are ignored. The reason for overriding these alerts appears to be multi-factorial. For example, simple pair-wise drug comparisons can lead to overly sensitive alerts, and patient-specific factors are not expressed in CDS logic. Moreover, medication alerts are typically   


* Motivate the need for PDDI decision support at the various places in med therapy workflow -- esp at drug selection and signing.

* Motivate the need for this CDS to be available as a service

    * maintainance of PDDI CDS is difficult (cite https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5064943/), there is broad disagreement across sources (https://www.ncbi.nlm.nih.gov/pubmed/28339701), more opportunities for innovation, perhaps a better evidence base 
	
	* Knowledge vendors provide a better service using broadly adopted HIT standards 

* Motivate the need for contextual PDDIs 

    * address the overalerting issue - use EHR data to make alerts more specific w/out losing sensitivity
	
	* mention the minimum info model as a vehicle for contextualization and supporting clinical cognition

* Motivate the need for sharable CDS written in CQL 

    * CQL, in principal, enable domain experts to assist with developing the CDS -- CDS authoring for CQL https://grants.nih.gov/grants/guide/pa-files/PA-18-792.html 


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
   
    

### Collaborators

This implementation guide was developed for potential drug-drug interaction (PDDI) clinical decision support (CDS). It was developed by the Clinical Decision Support Work Group in collaboration with University of Pittsburgh Medical Center, RWTH Aachen University, and Wolters Kluwer Health. The project focused on developing standardized and shareable artifacts to contextualize PDDIs.

