This profile sets minimum expectations for searching for and fetching information associated with an electronic endpoint. It identifies which core elements, extensions, vocabularies and value sets **SHALL** be present in the endpoint resource when using this profile.

**Background & Scope**

An endpoint describes the technical details of a location that can be connected to for the delivery/retrieval of information.

This profile removes `endpoint.connectionType` and replaces it with two new attributes to provide additional specificity about an endpoint: `endpoint.protocol` and `endpoint.profile`. This profile also constrains `endpoint.managingOrganization` and `endpoint.period` (both are now required), as well as `endpoint.contact` (only one contact point for an endpoint is permitted).

**Examples:**

The following are example uses for the vhdir-endpoint profile:

-  TBD


**Mandatory Data Elements**

The following data-elements are mandatory (i.e data MUST be present). These are presented below in a simple human-readable explanation. The [**Formal Profile Definition**](#profile) below provides the  formal summary, definitions, and  terminology requirements.  

Each endpoint must have:

1.  A status in `endpoint.status`
1.  An organization responsible for managing the endpoint in `endpoint.managingOrganization`
1.  A period for which the endpoint is available in `endpoint.period`
1.  At least one indication of the type of content the endpoint supports in `endpoint.payloadType`
1.  One technical address for connecting to the endpoint in `endpoint.address`
1.  One indicaton of the technical protocol for transmitting data used by the endpoint in `endpoint.protocol`
1.  For each use case defined for the endpoint, one indication of the type of services provided in `endpoint.useCase.type`


**Profile specific implementation guidance:**

- TBD


**Extensions:**

1.  Restriction (0..*) - indicates restrictions on the use/release of information associated with the endpoint
1.  Protocol (1..1) - indicates the specification of the technical protocol used to transmit data
1.  Profile (0..*) - a more detailed desctiption of the standards, implementation guide, etc. that the endpoint supports
1.  UseCase (0..*) - an enumeration of the specific use cases (service descriptions) supported by the endpoint, consisting of:
    1.  Type (1.1) - the types of services supported by the endpoint
    1.  Standard (0..1) - URI of a published standard (e.g. an HL7 implementation guide)
1.  Rank (0..1) - an indication of the preferred order for connecting to an endpoint when multiple endpoints capable of transferring the same content are listed
1.  DigitalCertificate (0..*) - a digital certificate associated with the endpoint


**Terminology**

TBD

