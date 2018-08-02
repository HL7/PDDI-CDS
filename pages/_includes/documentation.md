* **TODO** add Digoxin + Cyclosporin
* **TODO: Add language in the form of recommendations e.g.,  MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, AND OPTIONAL (Key words for use in RFCs to Indicate Requirement Levels. S. Bradner. IETF. March 1997. Best Current Practice. URL: https://tools.ietf.org/html/rfc2119)**
* **TODO** split into Basic and Advanced
* **TODO** display card example in documentation vs start?


-1. Knowledge representation for the PDDI CDS (e.g, decision tree) - mapping out the decision paths, pre-fetch requirements.....  
 
-2. Translating the KR to CQL  -- after investigation on our part, refering to possibility of using the publicly available CDS Authoring tool -- this will be simple --- libraries to import, specifying the FHIR terminology profile, utility functions, logic 

-3. Implementing CDS Hooks and PlanDefinition to receive CDS requests medication-request or medication-prescribe and return the cards with actions (since general to both artifacts consider moving to start.md?)

-4. Implementing the CDS Service - including how to load the Library, PlanDefinition, and where value sets reside....
+## Warfarin + NSAIDs 
 
-5. Fine tuning the CDS service for performance -- pre-loading data to reduce calls to the EHR e.g., for all patients who will be seen on a day. Other kinds of caching.....
+### Decision Points


# PDDI CDS - Documentation
{:.no_toc}

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}


This section contains documentation, on the specific CDS artifacts, for implementers from both the clinical and technical perspectives.

# PDDI CDS - prefetch and performance

This section documents for technical implementers the intended role of prefetch resources in improving the performance of the CDS service. 

## What is the role of prefetch?

The role of prefetch is to minimize calls by the CDS Service to external resources such as an external FHIR server containing clinical data. When a client program subscribes to PDDI CDS service, a prefetch specicification is returned in the response. This specification identifies important resources that the PDDI CDS service SHOULD recieve when the client makes a request for CDS. As is described below, the prefetch requirements are different depending on if CDS is for `medication-select` or `medication-prescribe`. In both cases, there are some parts of the prefetch that are mandatory because they are necessary for CDS to run, and others that are desired because they will improve CDS performance. 

## Prefetch and `medication-select` in the *basic* or *advanced* CDS scenario
{:.no_toc}

The following diagram shows the ideal scenario for prefetch for `medication-select` requests. The scenario is true for both the *basic* or *advanced* CDS scenarios because the prefetch requirements are distinct from the requirements related to the use of `DetectedIssue` resources.

**TODO: develop a figure for this case and finish the section**

## Prefetch and `medication-request` in the *basic* or *advanced* CDS scenario
{:.no_toc}

The following diagram shows the ideal scenario for prefetch for `medication-select` requests. The scenario is true for both the *simple* or *advanced* CDS scenarios because the prefetch requirements are distinct from the requirements related to the use of `DetectedIssue` resources.

**TODO: develop a figure for this case and finish the section**

> *Note:* For simplicity, this implementation guide uses the term "prefetch" regardless of whether the EHR supplies the data prior to a hook request or if it is queried by the CDS service as a post-hoc FHIR server query. All data required by the CDS artifacts is delineated in the prefetch templates. 


# Warfarin + NSAIDs 

# Basic

### Decision Points
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Basic Warfarin + NSAID logic </strong></figcaption>
  <a href = "assets/images/Basic_Warfarin_NSAID.svg" target ="_blank" > <img src= "assets/images/Basic_Warfarin_NSAID.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Warfarin_NSAID.svg" /></a>
</figure>

## Context
{:.no_toc}

## Prefetch 
{:.no_toc}

## Example Display Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Basic Warfarin + NSAID Cards </strong></figcaption>
  <a href = "assets/images/Basic_W_N_Cards.png" target ="_blank" > <img src="assets/images/Basic_W_N_Cards.png" class="figure-img img-responsive img-rounded center-block" alt="Basic_W_N_Cards.png" /></a>
</figure>

# Advanced


### Decision Points
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Warfarin + NSAID medication-select logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_select.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_select.svg" /></a>
</figure>




<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 2: Advanced Warfarin + NSAID medication-prescribe logic </strong></figcaption>
  <a href = "assets/images/Warfarin_NSAID_prescribe.svg" target ="_blank" > <img src="assets/images/Warfarin_NSAID_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Warfarin_NSAID_prescribe.svg" /></a>
</figure>

## Context
{:.no_toc}

## Prefetch 
{:.no_toc}

## Example Display Cards
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Warfarin + NSAID Cards </strong></figcaption>
  <a href = "assets/images/Advanced_W_N_Cards.svg" target ="_blank" > <img src="assets/images/Advanced_W_N_Cards.svg" class="figure-img img-responsive img-rounded center-block" alt="Advanced_W_N_Cards.svg" /></a>
</figure>

# Digoxin + Cyclosporin

### Definitions 
{:.no_toc}
* **Incident Order** – `context` medication is *not* in `prefetch` medications and, thus, is presumably the first occurrence. 
* **Prevelant Order** – `context` medication is in in `prefetch` medications and, thus, is presumably a medication order that is continued or repeated.
* **Normal** – observation that is within a specified time period, and the measure is within a therapeutic window or below/above a certain threshold.
* **Abnormal** – observation that is *not* within a specified time period, *or* the measure is *not* within a therapeutic window or below/above a certain threshold.

# Basic

### Decision Points
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: Basic Digoxin + Cyclosporine logic </strong></figcaption>
  <a href = "assets/images/Basic_Digoxin_Cyclosporine.svg" target ="_blank" > <img src="assets/images/Basic_Digoxin_Cyclosporine.svg" class="figure-img img-responsive img-rounded center-block" alt="Basic_Digoxin_Cyclosporine.svg" /></a>
</figure>

## Context
{:.no_toc}

## Prefetch
{:.no_toc}

# Advanced

### Decision Points
{:.no_toc}

## Context
{:.no_toc}

## Prefetch
{:.no_toc}


### Decision Points
{:.no_toc}

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 3: Digoxin + Cyclosporine medication-select logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_select.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_select.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_select.svg" /></a>
</figure>

<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 4: Digoxin + Cyclosporine medication-prescribe logic </strong></figcaption>
  <a href = "assets/images/Digoxin_Cyclosporine_prescribe.svg" target ="_blank" > <img src="assets/images/Digoxin_Cyclosporine_prescribe.svg" class="figure-img img-responsive img-rounded center-block" alt="Digoxin_Cyclosporine_prescribe.svg" /></a>
</figure>

#### Content
{:.no_toc}
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
