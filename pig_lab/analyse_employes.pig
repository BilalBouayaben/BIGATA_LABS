-- Chargement des données
-- Format: ID,Nom,Gender,Salaire,depno,Region,departements
employees = LOAD '/input/employees.txt' USING PigStorage(',') 
    AS (ID:int, Nom:chararray, Gender:chararray, Salaire:int, depno:int, Region:chararray, departements:chararray);

-- 1. Salaire moyen par département
dept_group = GROUP employees BY depno;
avg_salary_dept = FOREACH dept_group GENERATE group AS departement, AVG(employees.Salaire) AS salaire_moyen;
STORE avg_salary_dept INTO '/shared_volume/pigout/avg_salary_dept';

-- 2. Nombre d'employés par département
count_by_dept = FOREACH dept_group GENERATE group AS departement, COUNT(employees) AS nb_employes;
STORE count_by_dept INTO '/shared_volume/pigout/count_by_dept';

-- 3. Liste employés avec départements
emp_with_dept = FOREACH employees GENERATE Nom, depno AS departement;
STORE emp_with_dept INTO '/shared_volume/pigout/emp_with_dept';

-- 4. Employés avec salaire > 60000
high_salary = FILTER employees BY Salaire > 60000;
STORE high_salary INTO '/shared_volume/pigout/high_salary';

-- 5. Département avec salaire le plus élevé
salary_by_dept = FOREACH dept_group GENERATE group AS departement, MAX(employees.Salaire) AS max_salaire;
STORE salary_by_dept INTO '/shared_volume/pigout/salary_by_dept';

-- 6. Départements sans employés (non applicable avec ces données)

-- 7. Nombre total d'employés dans l'entreprise
all_employees = GROUP employees ALL;
total_count = FOREACH all_employees GENERATE COUNT(employees) AS total_employes;
STORE total_count INTO '/shared_volume/pigout/total_count';

-- 8. Employés de Paris
paris_employees = FILTER employees BY Region == 'Paris';
STORE paris_employees INTO '/shared_volume/pigout/paris_employees';

-- 9. Salaire total par ville
city_group = GROUP employees BY Region;
total_salary_city = FOREACH city_group GENERATE group AS ville, SUM(employees.Salaire) AS salaire_total;
STORE total_salary_city INTO '/shared_volume/pigout/total_salary_city';

-- 10. Départements avec femmes employées
femmes_dept = FILTER employees BY Gender == 'Female';
femmes_group = GROUP femmes_dept BY depno;
dept_with_femmes = FOREACH femmes_group GENERATE group AS departement, COUNT(femmes_dept) AS nb_femmes;
STORE dept_with_femmes INTO '/shared_volume/pigout/dept_with_femmes';
