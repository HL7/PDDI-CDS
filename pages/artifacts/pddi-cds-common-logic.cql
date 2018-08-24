library PDDICDSCommon version '1.0'

using FHIR version '3.0.0'

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
