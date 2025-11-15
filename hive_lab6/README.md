# Laboratoire 6 — Apache Hive & Data Warehousing

## 📄 Documentation complète disponible dans le fichier "CR_Bouayaben_Bilal_TP6_Hive.pdf"

---

## 🔧 Prérequis Techniques

### Configuration de l'Environnement
- **Répertoire de données (hôte) :** `C:\Users\lenovo\hadoop_project\hive_data`
  
  **Fichiers requis :**
  - `clients.txt`
  - `hotels.txt`
  - `reservations.txt`

- **Conteneur Hive :** Instance `hiveserver2-standalone` avec montage du volume hôte sur `/shared_volume`

### Vérifications Préalables
1. Assurez-vous que tous les fichiers de données sont présents dans le répertoire hôte
2. Vérifiez le montage correct du volume dans le conteneur
3. Confirmez la disponibilité de HiveServer2 sur le port 10000

---

## 🚀 Exécution des Scripts HiveQL

### Séquence d'Exécution (Ordre Obligatoire)

#### 1️⃣ Création des Schémas et Tables
```bash
docker exec -it hiveserver2-standalone bash -c \
  "beeline -u 'jdbc:hive2://localhost:10000' -n scott -p tiger \
   -f /shared_volume/lab6_hive/Creation.hql"
```

**Fonctionnalités :**
- Définition des tables externes et managées
- Configuration du partitionnement
- Mise en place du bucketing pour optimisation

#### 2️⃣ Chargement des Données
```bash
docker exec -it hiveserver2-standalone bash -c \
  "beeline -u 'jdbc:hive2://localhost:10000' -n scott -p tiger \
   -f /shared_volume/lab6_hive/Loading.hql"
```

**Important :** Avant d'exécuter cette étape, copiez tous les fichiers `.txt` dans le répertoire configuré sur l'hôte.

**Actions effectuées :**
- Ingestion des données depuis les fichiers sources
- Population des tables partitionnées
- Chargement dans les buckets configurés

#### 3️⃣ Requêtes Analytiques
```bash
docker exec -it hiveserver2-standalone bash -c \
  "beeline -u 'jdbc:hive2://localhost:10000' -n scott -p tiger \
   -f /shared_volume/lab6_hive/Queries.hql"
```

**Analyses réalisées :**
- Agrégations complexes (GROUP BY, HAVING)
- Jointures entre tables multiples
- Fonctions de fenêtrage (window functions)
- Requêtes analytiques avancées

---

## 📊 Résultats & Validation

Le document PDF annexé contient :
- Captures d'écran des résultats de chaque requête
- Métriques de performance (temps d'exécution)
- Analyse des plans d'exécution (EXPLAIN)
- Validation des optimisations appliquées

---

## 💡 Notes Techniques

### Optimisations Implémentées

**Partitionnement :**
- Découpage logique des tables par colonnes clés
- Amélioration des performances pour les requêtes filtrées
- Réduction du volume de données scannées

**Bucketing (Clustering) :**
- Distribution uniforme des données dans des fichiers
- Optimisation des jointures (map-side joins)
- Amélioration du sampling et de l'échantillonnage

### Bonnes Pratiques

**Préparation des Données :**
- ⚠️ **Supprimer les en-têtes CSV** avant le chargement
- Alternative : Utiliser `TBLPROPERTIES ("skip.header.line.count"="1")`
- Vérifier l'encodage des fichiers (UTF-8 recommandé)
- Valider les délimiteurs de champs

**Gestion des Métadonnées :**
- Les tables externes préservent les données sources après suppression
- Les tables managées (internes) suppriment les données avec DROP TABLE
- Utiliser MSCK REPAIR TABLE pour synchroniser les partitions

**Performance :**
- Activer la vectorisation : `SET hive.vectorized.execution.enabled = true;`
- Optimiser les jointures : `SET hive.auto.convert.join = true;`
- Utiliser le format ORC ou Parquet pour les grandes volumétries

---

**Développé par : Bouayaben Bilal**
