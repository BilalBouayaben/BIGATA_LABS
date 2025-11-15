-- Charger les données des employés
employees = LOAD '/input/employees.txt' USING PigStorage(',') AS (
    id:int,
    nom:chararray,
    prenom:chararray,
    departement:chararray,
    salaire:int,
    region:chararray
);

-- Question 1: Quel est le salaire moyen des employés dans chaque département ?
salaire_moyen_dept = GROUP employees BY departement;
avg_salaire = FOREACH salaire_moyen_dept GENERATE 
    group AS departement, 
    AVG(employees.salaire) AS salaire_moyen;
STORE avg_salaire INTO '/shared_volume/pig_out/Q1_salaire_moyen';
