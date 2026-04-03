CREATE OR REPLACE VIEW Task_flat_view AS
SELECT T.id AS id,
  T.status,
  T.intent,
  T.priority,
  T.for.patientId AS patient_id,
  T.focus.serviceRequestId AS focus_servicerequest_id,
  T.owner.organizationId AS owner_org_id,
  T.requester.practitionerId AS requester_practitioner_id,
  T.requester.organizationId AS requester_org_id,
  T.authoredOn AS authored_on,
  T.lastModified AS last_modified,
  element_at(filter(T.identifier, x -> x.system = 'http://openelis-global.org/facility_id'), 1).value AS facility_id,
  element_at(filter(T.identifier, x -> x.system = 'http://openelis-global.org/facility_id'), 1).assigner.display AS facility_name
FROM Task AS T
;




