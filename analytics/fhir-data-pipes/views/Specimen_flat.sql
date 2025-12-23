CREATE OR REPLACE VIEW Specimen_flat_view AS
SELECT S.id AS id,
  S.subject.patientId AS patient_id,
  S.status,
  STC.code AS type_code,
  STC.`system` AS type_sys,
  S.collection.collectedDateTime AS collected_datetime,
  S.receivedTime AS received_time
FROM Specimen AS S
  LATERAL VIEW OUTER explode(S.type.coding) AS STC
;




