
# <span style="color:silver"> 14.0.0 </span> Terminology defined for the PDDI CDS Implementation Guide

## <span style="color:silver"> 14.1.0 </span> Value Sets


The framework for the PDDI CDS value sets has three components:  

1. **Composite ValueSet**
2. **Element ValueSet**
3. **Element ValueSet-exclude**
 
Delineation in the components of value sets is based on characteristics or hierarchy of the terminology and the CDS service. The CDS service typically calls individual identifiers in the Element ValueSet through the Composite ValueSet. The CDS Service MUST call an Element ValueSet in the event a Composite ValueSet is unnecessary or unavailable. This approach allows value sets to be agnostic, reusable, and amenable to automated updating.

### <span style="color:silver"> 14.1.1 </span> Scope and Definitions

 While the processes for creating value sets for this implementation guide are amenable to international applications, several of the value sets for the provided CDS artifacts are limited to the United States. The scope of the value set is signified in the version (e.g., US 1.0) and jurisdiction (US) elements. Service agnostic value sets (i.e., Element ValueSet) have a broad description that refrains from limiting the value set to a certain terminology. Service-specific value sets specify a terminology and query details in the description element. Depending on the type of value set, up to two definitions are available, which include:
  
 
* *Extensional Definition* – Explicitly enumerating each of the value set concepts.
* *Intensional Definition* – Defining an algorithm that, when executed by a machine (or interpreted by a human), yields a set of such elements.
 

### <span style="color:silver"> 14.1.2 </span> Composite ValueSet
The Composite ValueSet is a superset that references Element ValueSets and Element ValueSets-exclude as needed for the defined CDS Service. It is signified by an upper-case name (e.g., valueset-NSAIDS). For example, non-steroidal anti-inflammatory drugs (NSAIDs) is a class of medications with several members (e.g., ibuprofen, naproxen, diclofenac). The Composite ValueSet references Element ValueSets including valueset-ibuprofen, valueset-naproxen, valueset-diclofenac etc. Composite ValueSets have an Extensional Definition for including and excluding Element ValueSets. The Composite ValueSet references Element ValueSet-exclude to refine included identifiers. 

### <span style="color:silver"> 14.1.3 </span> Element ValueSet
The Element ValueSets are signified by lower-case names (e.g., valueset-naproxen). Element ValueSets are unique in that the identifiers are available in the Extensional and Intensional Definitions. Element ValueSets MUST have a persistent URL for the Composite ValueSet to reference. The Extensional Definition of enumerated identifiers and names are available through `ValueSet.compose.include.concept.` The Intensional Definition identifiers and names are available through `ValueSet.expansion.contains.` The Intensional Definition is a general query to a public Terminology server, typically through an API with a RESTful query. The intent of an Element ValueSet is to contain a broad capture of identifiers at the concept or product level (e.g., naproxen and naproxen 500mg tablet). Refining these value sets occurs at the Composite ValueSet level with Element ValueSet-exclude.  

#### RESTful API
Public terminology servers are now available for several of the most recognized terminologies including: RxNorm, LOINC, and SNOMED-CT. These APIs are convenient, stable, and provide a simplistic mechanism for reproducible queries. 

### <span style="color:silver"> 14.1.4 </span> Element ValueSet-exclude
The Element ValueSet-excludes are signified with an identical name to the Element ValueSets but with an "-exclude" (e.g., valueset-naproxen-exclude) These value sets have an enumerated Extensional Definition only, and are a subset of the Element ValueSet. The subset criteria is defined in the `description` element. For example, an Element ValueSet may capture all naproxen products; however, the CDS knowledge only calls for systemic naproxen. By including an Element ValueSet-exclude that has an enumerated set of identifiers that are topical, the Composite ValueSet can provide a more precise set of identifiers that closely matched the CDS knowledge. The Composite ValueSet and Element ValueSet-exclude are CDS Service specific. In the situation where Element ValueSet-excludes are not maintained, it will only increase the sensitivity of the CDS system (i.e., error on safety).


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: ValueSet Framework </strong></figcaption>
  <a href = "assets/images/Value_Sets.svg" target ="_blank" > <img src="assets/images/Value_Sets.svg" class="figure-img img-responsive img-rounded center-block" alt="Value-Sets.svg" /></a>
</figure>

## <span style="color:silver"> 14.2.0 </span> ValueSet

{% include list-simple-valuesets.xhtml %} 

<p/><p/>


## Code Systems



{% include list-simple-codesystems.xhtml %} 

<p/><p/>



