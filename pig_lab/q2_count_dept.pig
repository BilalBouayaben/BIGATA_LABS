-- Charger les données
employees = LOAD '/input/employees.txt' USING PigStorage(',') AS (
    id:int, nom:chararray, prenom:chararray, 
    departement:chararray, salaire:int, region:chararray
);

-- Question 2: Combien d'employés travaillent dans chaque département ?
count_dept = GROUP employees BY departement;
nb_employes = FOREACH count_dept GENERATE 
    group AS departement, 
    COUNT(employees) AS nb_employes;
STORE nb_employes INTO '/shared_volume/pig_out/Q2_count_dept';
