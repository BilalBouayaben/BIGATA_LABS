-- 1. Analyse des employés
-- Charger les données des employés
employees = LOAD 'hdfs dfs -mkdir input' USING PigStorage(',') AS (
    id:int,
    nom:chararray,
    prenom:chararray,
    departement:chararray,
    salaire:int,
    region:chararray
);

-- Question 1: Salaire moyen par département
salaire_moyen = GROUP employees BY departement;
avg_salaire_dept = FOREACH salaire_moyen GENERATE 
    group AS departement, 
    AVG(employees.salaire) AS salaire_moyen;
DUMP avg_salaire_dept;

-- Question 2: Nombre d'employés par département
count_employes = FOREACH salaire_moyen GENERATE 
    group AS departement, 
    COUNT(employees) AS nb_employes;
DUMP count_employes;

-- Question 3: Lister tous les employés avec leurs départements
employes_dept = FOREACH employees GENERATE 
    nom, prenom, departement;
DUMP employes_dept;

-- Question 4: Employés avec salaire > 60000
employes_riches = FILTER employees BY salaire > 60000;
DUMP employes_riches;

-- Question 5: Département avec le salaire le plus élevé
dept_salaire_max = GROUP employees BY departement;
max_salaire_dept = FOREACH dept_salaire_max GENERATE 
    group AS departement, 
    MAX(employees.salaire) AS salaire_max;
DUMP max_salaire_dept;

-- Question 6: Départements sans employés (données fictives pour démonstration)
-- Cette requête nécessiterait une table de référence des départements

-- Question 7: Nombre total d'employés dans l'entreprise
all_employees = GROUP employees ALL;
total_employes = FOREACH all_employees GENERATE COUNT(employees) AS total;
DUMP total_employes;

-- Question 8: Employés de la ville de Paris
employes_paris = FILTER employees BY region == 'Paris';
DUMP employes_paris;

-- Question 9: Salaire total des employés par ville
salaire_par_ville = GROUP employees BY region;
total_salaire_ville = FOREACH salaire_par_ville GENERATE 
    group AS ville, 
    SUM(employees.salaire) AS salaire_total;
DUMP total_salaire_ville;

-- Question 10: Départements avec des femmes employées
-- Enregistrer le dernier résultat dans pigout/employes_femmes
STORE employes_paris INTO 'pigout/employes_femmes' USING PigStorage(',');
