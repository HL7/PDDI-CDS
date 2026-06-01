library DigoxinCyclosporineCDSLogic version '1.0.0'

using FHIR version '4.0.1'

include hl7.fhir.uv.cql.FHIRHelpers version '4.0.1'
include hl7.fhir.uv.cql.FHIRCommon version '2.0.0'

include PDDICDSCommon version '1.0.0' called Common

valueset "Digoxin": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-digoxin'
valueset "Cyclosporine": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-cyclosporine'
valueset "Aldosterone Antagonists": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-AAS'
valueset "Loop Diuretics": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-LOOPDIURETIC'
valueset "Digoxin LOINC": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-digoxin-LOINC'
valueset "Potassium LOINC": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-potassium-LOINC'
valueset "Magnesium LOINC": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-magnesium-LOINC'
valueset "Calcium LOINC": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-calcium-LOINC'
valueset "Renal LOINC": 'http://hl7.org/fhir/uv/pddi/ValueSet/valueset-renal-LOINC'

parameter ContextPrescriptions List<MedicationRequest>

context Patient

/*
**
** Digoxin Cyclosporine CDS Recommendation
**
*/

define "Inclusion Criteria":
  (
    "Is Context medication cyclosporine"
      and "Is digoxin in prefetch"
  )
  or (
    "Is Context medication digoxin"
      and "Is cyclosporine in prefetch"
  )

define "Is Context medication cyclosporine":
  exists ("Cyclosporine Prescription")

define "Cyclosporine Prescription":
  ContextPrescriptions P
    where P.medication in "Cyclosporine"
    return P.medication as CodeableConcept

define "Is digoxin in prefetch":
  exists ("Digoxin Rx")

define "Digoxin Rx":
    (
      [MedicationRequest: "Digoxin"] MR
        where MR.authoredOn.toInterval() during Interval[Today() - 100 days, null]
        return MR.medication as CodeableConcept
    )
    union (
      [MedicationAdministration: "Digoxin"] MA
        where MA.effective.toInterval() overlaps Interval[Today() - 100 days, null]
        return MA.medication as CodeableConcept
    )
    union (
      [MedicationDispense: "Digoxin"] MD
        where MD.whenHandedOver.toInterval() during Interval[Today() - 100 days, null]
        return MD.medication as CodeableConcept
    )
    union (
      [MedicationStatement: "Digoxin"] MS
        where MS.effective.toInterval() overlaps Interval[Today() - 100 days, null]
        return MS.medication as CodeableConcept
    )

define "Is Context medication digoxin":
  exists ("Digoxin Prescription")

define "Digoxin Prescription":
  ContextPrescriptions P
    where P.medication in "Digoxin"
    return P.medication as CodeableConcept


define "Is cyclosporine in prefetch":
  exists ("Cyclosporine Rx")

define "Cyclosporine Rx":
    (
      [MedicationRequest: "Cyclosporine"] MR
        where MR.authoredOn.toInterval() during Interval[Today() - 100 days, null]
        return MR.medication as CodeableConcept
    )
    union (
      [MedicationAdministration: "Cyclosporine"] MA
        where MA.effective.toInterval() overlaps Interval[Today() - 100 days, null]
        return MA.medication as CodeableConcept
    )
    union (
      [MedicationDispense: "Cyclosporine"] MD
        where MD.whenHandedOver.toInterval() during Interval[Today() - 100 days, null]
        return MD.medication as CodeableConcept
    )
    union (
      [MedicationStatement: "Cyclosporine"] MS
        where MS.effective.toInterval() overlaps Interval[Today() - 100 days, null]
        return MS.medication as CodeableConcept
    )

// Card 1: Base
define "Get Base Summary":
  'Potential Drug-Drug Interaction between digoxin ('
    + (
      if "Is Context medication digoxin"
        then Common.GetDrugNames("Digoxin Prescription")
      else Common.GetDrugNames("Digoxin Rx")
    )
    + ') and cyclosporine ('
    + (
      if "Is Context medication cyclosporine"
        then Common.GetDrugNames("Cyclosporine Prescription")
      else Common.GetDrugNames("Cyclosporine Rx")
    )
    + ')'

define "Get Base Detail":
  'Increased risk of digoxin toxicity. Assess risk and take action if necessary. \nDigoxin toxicity is potentially serious. The clinical consequences may include anorexia, nausea, vomiting, visual changes, and cardiac arrhythmias. \nThe mechanism of this interaction appears to be mediated through P-glycoprotein inhibition by cyclosporine. P-glycoprotein is a major transporter for digoxin efflux. \nunknown. \nunknown.'

define "Get Base Indicator":
  if "Is continuation order for digoxin"
    or "Is continuation order for cyclosporine"
    then if "Is there a normal digoxin level in prefetch"
        then if "Are diuretics or abnormal electrolyte or abnormal renal observations in prefetch"
            then 'warning'
          else 'info'
      else 'warning'
  else 'warning'


define "Is new order for digoxin":
  "Is Context medication digoxin"
      and not "Is digoxin in prefetch"

define "Is continuation order for digoxin":
  "Is Context medication digoxin"
      and "Is digoxin in prefetch"

define "Is new order for cyclosporine":
  "Is Context medication cyclosporine"
      and not "Is cyclosporine in prefetch"

define "Is continuation order for cyclosporine":
  "Is Context medication cyclosporine"
      and "Is cyclosporine in prefetch"



// Card 2
define "Get Card 2 Indicator":
  if "Is new order for cyclosporine"
    then if "Is there a normal digoxin level in prefetch"
      then 'warning'
    else 'critical'
  else if "Is there a normal digoxin level in prefetch"
      then 'info'
    else 'warning'


define "Get Card 2 Summary":
  if "Is there a normal digoxin level in prefetch"
    then 'Patient has digoxin level within 30 days that is below 0.9 ng/mL (SI: 1.2 nmol/L)'
  else 'Patient does not have digoxin level on record within the last 30 days. '

define "Get Card 2 Detail":
  if "Is there a normal digoxin level in prefetch"
    then '(Digoxin: '
    + Common.GetLevelAndDate("Normal Digoxin Observation")
    + '). \nFor patients with a reliable plasma digoxin concentration in normal range, it is reasonable to anticipate an increase in plasma concentrations after the initiation of cyclosporine. Following initiation, close monitoring and adjusting the digoxin dose as needed is recommended'
  else 'Initiating cyclosporine is expected to increase digoxin levels. For patients without a reliable plasma digoxin concentration in normal range, use only if benefits outweight risks. Extreme caution and close monitoring is necessary.'


define "Need to reduce Digoxin dose":
  "Is Context medication cyclosporine"
    or not "Is there a normal digoxin level in prefetch"

define "Is there a normal digoxin level in prefetch":
  "Normal Digoxin Observation" is not null

define "Normal Digoxin Observation":
	Last (
    [Observation: "Digoxin LOINC"] O
      where O.effective.toInterval() during Interval[Today() - 30 days, null]
        and O.value < 0.9 'ng/mL'
      sort by start of effective.toInterval()
  )


define "Are diuretics in prefetch":
  exists ("Aldosterone Antagonists Rx")
    or exists("Loop Diuretics Rx")

define "Aldosterone Antagonists Rx":
    (
      [MedicationRequest: "Aldosterone Antagonists"] MR
        where MR.authoredOn.toInterval() during Interval[Today() - 100 days, null]
        return MR.medication as CodeableConcept
    )
    union (
      [MedicationAdministration: "Aldosterone Antagonists"] MA
        where MA.effective.toInterval() overlaps Interval[Today() - 100 days, null]
        return MA.medication as CodeableConcept
    )
    union (
      [MedicationDispense: "Aldosterone Antagonists"] MD
        where MD.whenHandedOver.toInterval() during Interval[Today() - 100 days, null]
        return MD.medication as CodeableConcept
    )
    union (
      [MedicationStatement: "Aldosterone Antagonists"] MS
        where MS.effective.toInterval() overlaps Interval[Today() - 100 days, null]
        return MS.medication as CodeableConcept
    )

define "Loop Diuretics Rx":
    (
      [MedicationRequest: "Loop Diuretics"] MR
        where MR.authoredOn.toInterval() during Interval[Today() - 100 days, null]
        return MR.medication as CodeableConcept
    )
    union (
      [MedicationAdministration: "Loop Diuretics"] MA
        where MA.effective.toInterval() overlaps Interval[Today() - 100 days, null]
        return MA.medication as CodeableConcept
    )
    union (
      [MedicationDispense: "Loop Diuretics"] MD
        where MD.whenHandedOver.toInterval() during Interval[Today() - 100 days, null]
        return MD.medication as CodeableConcept
    )
    union (
      [MedicationStatement: "Loop Diuretics"] MS
        where MS.effective.toInterval() overlaps Interval[Today() - 100 days, null]
        return MS.medication as CodeableConcept
    )


// Card 3
define "Get Card 3 Indicator":
  if "Is there a normal electrolyte and renal observation in prefetch"
    then 'info'
  else 'warning'

define "Get Card 3 Summary":
  if "Is there a normal electrolyte and renal observation in prefetch"
    then 'Within 100 days, the patient has had electrolyte and serum creatinine levels checked, and they are not on a potassium sparing or loop diuretic.'
  else 'Within 100 days, the patient has not had an electrolyte panel. The patient does have serum creatinine level and is not on a potassium sparing or loop diuretic.'

define "Get Card 3 Detail":
  if "Is there a normal electrolyte and renal observation in prefetch"
    then '(Potassium: '
    + Common.GetLevelAndDate("Normal Potassium Observation")
    + ')\n (Magnesium: '
    + Common.GetLevelAndDate("Normal Magnesium Observation")
    + ')\n (Calcium: '
    + Common.GetLevelAndDate("Normal Calcium Observation")
    + ')\n'
  else ''
  + '(Serum creatinine: '
  + Common.GetLevelAndDate("Normal Renal Observation")
  + ')\n Hypokalemia, hypomagnesemia, and hypercalcemia may potentiate digoxin toxicity. 50-70% of digoxin is excreted unchanged in the urine. Changing renal function may increase serum concentrations and risk of toxicity.'

define "Are diuretics or abnormal electrolyte or abnormal renal observations in prefetch":
  "Are diuretics in prefetch"
    or not "Is there a normal electrolyte and renal observation in prefetch"

define "Is there a normal electrolyte and renal observation in prefetch":
  "Is there a normal electrolyte observation in prefetch"
    and "Is there a normal renal observation in prefetch"

define "Is there a normal electrolyte observation in prefetch":
  "Normal Potassium Observation" is not null
  and "Normal Magnesium Observation" is not null
  and "Normal Calcium Observation" is not null

define "Normal Potassium Observation":
  Last (
    [Observation: "Potassium LOINC"] O
      where O.effective.toInterval() during Interval[Today() - 365 days, null]
        and O.value > 3.5 'meq/L'
        and O.value < 5.0 'meq/L'
      sort by start of effective.toInterval()
  )

define "Normal Magnesium Observation":
  Last (
    [Observation: "Magnesium LOINC"] O
      where O.effective.toInterval() during Interval[Today() - 365 days, null]
        and O.value > 0.7 'mmol/L'
        and O.value < 1.1 'mmol/L'
      sort by start of effective.toInterval()
  )

define "Normal Calcium Observation":
  Last (
    [Observation: "Calcium LOINC"] O
      where O.effective.toInterval() during Interval[Today() - 365 days, null]
        and O.value > 8.5 'mg/dL'
        and O.value < 10.2 'mg/dL'
      sort by start of effective.toInterval()
  )

define "Is there a normal renal observation in prefetch":
  "Normal Renal Observation" is not null

define "Normal Renal Observation":
  Last (
    [Observation: "Renal LOINC"] O
      where O.effective.toInterval() during Interval[Today() - 365 days, null]
        and O.value > 0.6 'mg/dL'
        and O.value < 1.2 'mg/dL'
      sort by start of effective.toInterval()
  )
