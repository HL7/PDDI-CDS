library Digoxin_Cyclosporine_CDS version '1.0'

using FHIR version '3.0.0'

// include PDDICDSCommon version '1.0' called Common

valueset "Digoxin": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-digoxin'
valueset "Cyclosporine": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-cyclosporine'
valueset "Aldosterone Antagonists": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-AAS'
valueset "Loop Diuretics": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-LOOPDIURETIC'
valueset "Digoxin LOINC": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-digoxin-LOINC'
valueset "Potassium LOINC": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-potassium-LOINC'
valueset "Magnesium LOINC": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-magnesium-LOINC'
valueset "Calcium LOINC": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-calcium-LOINC'
valueset "Renal LOINC": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-renal-LOINC'

parameter ContextPrescriptions List<MedicationRequest>

context Patient

// NOTE: These functions have been moved here from the Commmon library to boost performance
define function GetConditionName(condition Condition):
  if condition is not null
    then condition.code.coding[0].display.value
  else 'NA'

define function GetAssertedDate(condition Condition):
  if condition is not null
    then ToString(condition.assertedDate.value)
  else 'NA'

define function GetLevelAndDate(observation Observation):
  if observation is not null
    then ToString(ToQuantity(observation.value as Quantity))
      + ' and ' 
      + ToString(observation.effective.value)
  else 'NA'

define function GetMedicationNames(medications List<MedicationRequest>):
  medications M
    return ToCode(M.medication.coding[0]).display

define function GetDrugNames(codings List<FHIR.Coding>):
  Combine(
    flatten (
      codings coding
          return ToCode(coding).display
    ), ', ')

define function ToCode(coding FHIR.Coding):
  System.Code {
    code: coding.code.value,
    system: coding.system.value,
    version: coding.version.value,
    display: coding.display.value
  }

define function ToQuantity(quantity FHIR.Quantity):
  System.Quantity { value: quantity.value.value, unit: quantity.unit.value }

define function ToString(value FHIR.Coding): value.display.value
define function ToString(value Code): value.display

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
    where ToCode(P.medication.coding[0]) in "Cyclosporine"
    return P.medication.coding[0]

define "Is digoxin in prefetch":
  exists ("Digoxin Rx")

define "Digoxin Rx":
  flatten (
    (
      [MedicationRequest: "Digoxin"] MR
        where MR.authoredOn.value in Interval[Today() - 100 days, null]
        return MR.medication.coding[0]
    )
    union (
      [MedicationAdministration: "Digoxin"] MA
        where MA.effective.value in Interval[Today() - 100 days, null]
        return MA.medication.coding[0]
    )
    union (
      [MedicationDispense: "Digoxin"] MD
        where MD.whenHandedOver.value in Interval[Today() - 100 days, null]
        return MD.medication.coding[0]
    )
    union (
      [MedicationStatement: "Digoxin"] MS
        where MS.effective.value in Interval[Today() - 100 days, null]
        return MS.medication.coding[0]
    )
  )


define "Is Context medication digoxin":
  exists ("Digoxin Prescription")

define "Digoxin Prescription":
  ContextPrescriptions P
    where ToCode(P.medication.coding[0]) in "Digoxin"
    return P.medication.coding[0]


define "Is cyclosporine in prefetch":
  exists ("Cyclosporine Rx")

define "Cyclosporine Rx":
	flatten (
    (
      [MedicationRequest: "Cyclosporine"] MR
        where MR.authoredOn.value in Interval[Today() - 100 days, null]
        return MR.medication.coding[0]
    )
    union (
      [MedicationAdministration: "Cyclosporine"] MA
        where MA.effective.value in Interval[Today() - 100 days, null]
        return MA.medication.coding[0]
    )
    union (
      [MedicationDispense: "Cyclosporine"] MD
        where MD.whenHandedOver.value in Interval[Today() - 100 days, null]
        return MD.medication.coding[0]
    )
    union (
      [MedicationStatement: "Cyclosporine"] MS
        where MS.effective.value in Interval[Today() - 100 days, null]
        return MS.medication.coding[0]
    )
  )

// Card 1: Base
define "Get Base Summary":
  'Potential Drug-Drug Interaction between digoxin (' 
    + (
      if "Is Context medication digoxin"
        then GetDrugNames("Digoxin Prescription") 
      else GetDrugNames("Digoxin Rx") 
    )
    + ') and cyclosporine (' 
    + (
      if "Is Context medication cyclosporine"
        then GetDrugNames("Cyclosporine Prescription") 
      else GetDrugNames("Cyclosporine Rx")
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
    else 'hard-stop'
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
    + GetLevelAndDate("Normal Digoxin Observation")
    + '). \nFor patients with a reliable plasma digoxin concentration in normal range, it is reasonable to anticipate an increase in plasma concentrations after the initiation of cyclosporine. Following initiation, close monitoring and adjusting the digoxin dose as needed is recommended'
  else 'Initiating cyclosporine is expected to increase digoxin levels. For patients without a reliable plasma digoxin concentration in normal range, use only if benefits outweight risks. Extreme caution and close monitoring is necessary.'


define "Need to reduce Digoxin dose":
  "Is Context medication cyclosporine"
    or not "Is there a normal digoxin level in prefetch"

define "Is there a normal digoxin level in prefetch":
  exists ("Normal Digoxin Observation")

define "Normal Digoxin Observation":
	Last (
    [Observation: "Digoxin LOINC"] O
      where O.effective.value in Interval[Today() - 30 days, null] 
        and ToQuantity(O.value) < 0.9 'ng/mL' 
      sort by effective.value
  )


define "Are diuretics in prefetch":
  exists ("Aldosterone Antagonists Rx")
    or exists("Loop Diuretics Rx")

define "Aldosterone Antagonists Rx":
	flatten (
    (
      [MedicationRequest: "Aldosterone Antagonists"] MR
        where MR.authoredOn.value in Interval[Today() - 100 days, null]
        return MR.medication.coding[0]
    )
    union (
      [MedicationAdministration: "Aldosterone Antagonists"] MA
        where MA.effective.value in Interval[Today() - 100 days, null]
        return MA.medication.coding[0]
    )
    union (
      [MedicationDispense: "Aldosterone Antagonists"] MD
        where MD.whenHandedOver.value in Interval[Today() - 100 days, null]
        return MD.medication.coding[0]
    )
    union (
      [MedicationStatement: "Aldosterone Antagonists"] MS
        where MS.effective.value in Interval[Today() - 100 days, null]
        return MS.medication.coding[0]
    )
  )

define "Loop Diuretics Rx":
	flatten (
    (
      [MedicationRequest: "Loop Diuretics"] MR
        where MR.authoredOn.value in Interval[Today() - 100 days, null]
        return MR.medication.coding[0]
    )
    union (
      [MedicationAdministration: "Loop Diuretics"] MA
        where MA.effective.value in Interval[Today() - 100 days, null]
        return MA.medication.coding[0]
    )
    union (
      [MedicationDispense: "Loop Diuretics"] MD
        where MD.whenHandedOver.value in Interval[Today() - 100 days, null]
        return MD.medication.coding[0]
    )
    union (
      [MedicationStatement: "Loop Diuretics"] MS
        where MS.effective.value in Interval[Today() - 100 days, null]
        return MS.medication.coding[0]
    )
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
    + GetLevelAndDate("Normal Potassium Observation")
    + ')\n (Magnesium: ' 
    + GetLevelAndDate("Normal Magnesium Observation")
    + ')\n (Calcium: ' 
    + GetLevelAndDate("Normal Calcium Observation")
    + ')\n'
  else ''
  + '(Serum creatinine: ' 
  + GetLevelAndDate("Normal Renal Observation")
  + ')\n Hypokalemia, hypomagnesemia, and hypercalcemia may potentiate digoxin toxicity. 50-70% of digoxin is excreted unchanged in the urine. Changing renal function may increase serum concentrations and risk of toxicity.'

define "Are diuretics or abnormal electrolyte or abnormal renal observations in prefetch":
  "Are diuretics in prefetch"
    or not "Is there a normal electrolyte and renal observation in prefetch"

define "Is there a normal electrolyte and renal observation in prefetch":
  "Is there a normal electrolyte observation in prefetch"
    and "Is there a normal renal observation in prefetch"

define "Is there a normal electrolyte observation in prefetch":
  exists ("Normal Potassium Observation")
  and exists ("Normal Magnesium Observation")
  and exists ("Normal Calcium Observation")

define "Normal Potassium Observation":
  Last (
    [Observation: "Potassium LOINC"] O
      where O.effective.value in Interval[Today() - 365 days, null] 
        and ToQuantity(O.value) > 3.5 'mEq/L'
        and ToQuantity(O.value) < 5.0 'mEq/L'
      sort by effective.value
  )

define "Normal Magnesium Observation":
  Last (
    [Observation: "Magnesium LOINC"] O
      where O.effective.value in Interval[Today() - 365 days, null] 
        and ToQuantity(O.value) > 0.7 'mmol/L' 
        and ToQuantity(O.value) < 1.1 'mmol/L' 
      sort by effective.value
  )

define "Normal Calcium Observation":
  Last (
    [Observation: "Calcium LOINC"] O
      where O.effective.value in Interval[Today() - 365 days, null] 
        and ToQuantity(O.value) > 8.5 'mg/dL' 
        and ToQuantity(O.value) < 10.2 'mg/dL' 
      sort by effective.value
  )

define "Is there a normal renal observation in prefetch":
  exists ("Normal Renal Observation")

define "Normal Renal Observation":
  Last (
    [Observation: "Renal LOINC"] O
      where O.effective.value in Interval[Today() - 365 days, null] 
        and ToQuantity(O.value) > 0.6 'mg/dL' 
        and ToQuantity(O.value) < 1.2 'mg/dL' 
      sort by effective.value
  )
