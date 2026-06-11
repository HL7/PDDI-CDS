This section provides a summary of the role of terminology value sets in PDDI CDS. It is intended to be informative so the example values sets are examples only. For terminology design and maintenance, implementers should also consult the [FHIR Terminology Module](https://hl7.org/fhir/terminology-module.html) and the [FHIR IG Guidance on terminology](https://build.fhir.org/ig/FHIR/ig-guidance/terminology.html). In this IG, some drug-identification value sets point to terminology content maintained in VSAC. For selected drug classes, the IG now includes both pedagogical composite examples and Value Set RulesText-based artifacts. The composite examples illustrate structure and have been used in testing, while the Value Set RulesText artifacts document the preferred reproducible process for deriving the current RxNorm expansion needed for implementation. Another thing to consider is that, for some drug-drug interaction, one or more value sets based on drug classes might be the correct way to represent the interacting medications. However, this is generally not the case for pharmacokinetic drug interactions.

### Value Sets


The framework for the PDDI CDS value sets has three components:

1. **Composite ValueSet**
2. **Element ValueSet**
3. **Element ValueSet-exclude**

Delineation in the components of value sets is based on characteristics or hierarchy of the terminology and the CDS service. The CDS service typically calls individual identifiers in the Element ValueSet through the Composite ValueSet. The CDS Service SHOULD call an Element ValueSet in the event a Composite ValueSet is unnecessary or unavailable. This approach allows value sets to be agnostic, reusable, and amenable to automated updating.

#### Scope and Definitions

 While the processes for creating value sets for this implementation guide are amenable to international applications, several of the value sets for the provided CDS artifacts are limited to the United States. The scope of the value set is signified in the version (e.g., US 1.0) and jurisdiction (US) elements. Service agnostic value sets (i.e., Element ValueSet) have a broad description that refrains from limiting the value set to a certain terminology. Service-specific value sets specify a terminology and query details in the description element. Depending on the type of value set, up to two definitions are available, which include:


* *Extensional Definition* – Explicitly enumerating each of the value set concepts.
* *Intensional Definition* – Defining an algorithm that, when executed by a machine (or interpreted by a human), yields a set of such elements.


#### Composite ValueSet
The Composite ValueSet is a superset that references Element ValueSets and Element ValueSets-exclude as needed for the defined CDS Service. It is signified by an upper-case name (e.g., valueset-NSAIDS). For example, non-steroidal anti-inflammatory drugs (NSAIDs) is a class of medications with several members (e.g., ibuprofen, naproxen, diclofenac). In this IG, composite value sets are retained as informative structural examples, and implementers may use similar composition to assemble working value sets from element value sets and element value set-excludes when maintaining operational terminology. Complementary Value Set RulesText artifacts document a reproducible process that a maintainer can follow to derive the current RxNorm expansion and, where appropriate, compose the operational value set needed for implementation.

#### Element ValueSet
The Element ValueSets are signified by lower-case names (e.g., valueset-naproxen). Element ValueSets are unique in that the identifiers are available in the Extensional and Intensional Definitions. Element ValueSets SHOULD have a persistent URL for the Composite ValueSet to reference. The Extensional Definition of enumerated identifiers and names are available through `ValueSet.compose.include.concept.` The Intensional Definition identifiers and names are available through `ValueSet.expansion.contains.` The Intensional Definition is a general query to a public Terminology server, typically through an API with a RESTful query. The intent of an Element ValueSet is to contain a broad capture of identifiers at the concept or product level (e.g., naproxen and naproxen 500mg tablet). Refining these value sets occurs at the Composite ValueSet level with Element ValueSet-exclude.

**RESTful API**
Public terminology servers are now available for several of the most recognized terminologies including: RxNorm, LOINC, and SNOMED-CT. These APIs are convenient, stable, and provide a simplistic mechanism for reproducible queries.

#### Element ValueSet-exclude
The Element ValueSet-excludes are signified with an identical name to the Element ValueSets but with an "-exclude" (e.g., valueset-naproxen-exclude) These value sets have an enumerated Extensional Definition only, and are a subset of the Element ValueSet. The subset criteria is defined in the `description` element. For example, an Element ValueSet may capture all naproxen products; however, the CDS knowledge only calls for systemic naproxen. By including an Element ValueSet-exclude that has an enumerated set of identifiers that are topical, the Composite ValueSet can provide a more precise set of identifiers that closely matched the CDS knowledge. The Composite ValueSet and Element ValueSet-exclude are CDS Service specific. In the situation where Element ValueSet-excludes are not maintained, it will only increase the sensitivity of the CDS system (i.e., error on safety).


<figure class="figure">
<figcaption class="figure-caption"><strong>Figure 1: ValueSet Framework </strong></figcaption>
  <a href = "Value_sets.svg" target ="_blank" > <img src="Value_sets.svg" class="figure-img img-responsive img-rounded center-block" alt="Value_sets.svg" /></a>
</figure>

### ValueSet

{% include list-simple-valuesets.xhtml %}

<p/><p/>

