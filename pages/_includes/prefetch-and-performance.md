[//]: # -*- --from markdown_strict+footnotes+backtick_code_blocks -*-

# PDDI CDS - prefetch and performance

This section documents for technical implementers the intended role of prefetch resources in improving the performance of the CDS service. 

## What is the role of prefetch?

The role of prefetch is to minimize calls by the CDS Service to external resources such as an external FHIR server containing clinical data. When a client program subscribes to PDDI CDS service, a prefetch specicification is returned in the response. This specification identifies important resources that the PDDI CDS service SHOULD recieve when the client makes a request for CDS. As is described below, the prefetch requirements are different depending on if CDS is for `medication-select` or `medication-prescribe`. In both cases, there are some parts of the prefetch that are mandatory because they are necessary for CDS to run, and others that are desired because they will improve CDS performance. 

## Prefetch and `medication-select` in the *basic* or *advanced* CDS scenario

The following diagram shows the ideal scenario for prefetch for `medication-select` requests. The scenario is true for both the *basic* or *advanced* CDS scenarios because the prefetch requirements are distinct from the requirements related to the use of `DetectedIssue` resources.

**TODO: develop a figure for this case and finish the section**

## Prefetch and `medication-request` in the *basic* or *advanced* CDS scenario

The following diagram shows the ideal scenario for prefetch for `medication-select` requests. The scenario is true for both the *simple* or *advanced* CDS scenarios because the prefetch requirements are distinct from the requirements related to the use of `DetectedIssue` resources.

**TODO: develop a figure for this case and finish the section**
