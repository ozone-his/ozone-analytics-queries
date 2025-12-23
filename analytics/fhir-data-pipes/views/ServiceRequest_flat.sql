CREATE OR REPLACE VIEW ServiceRequest_flat_view AS
SELECT SR.id AS id,
  SR.subject.patientId AS patient_id,
  SR.encounter.encounterId AS encounter_id,
  SR.status,
  SR.intent,
  SR.priority,
  SRC.code AS code_code,
  SRC.`system` AS code_sys,
  SRCC.code AS category_code,
  SRCC.`system` AS category_sys,
  SR.authoredOn AS authored_on,
  SR.requester.practitionerId AS requester_practitioner_id,
  SR.requester.organizationId AS requester_org_id,
  SR.performer.practitionerId AS performer_practitioner_id,
  SR.performer.organizationId AS performer_org_id
FROM ServiceRequest AS SR
  LATERAL VIEW OUTER explode(SR.code.coding) AS SRC
  LATERAL VIEW OUTER explode(SR.category) AS SRCA
  LATERAL VIEW OUTER explode(SRCA.coding) AS SRCC
;




