# BIGDATA_ENGINEERING_LABS

Bienvenue dans ce dépôt dédié aux laboratoires pratiques de Big Data Engineering pour l'année académique 2025-2026.

---
# INGÉNIERIE DES DONNÉES MASSIVES  
**Année académique : 2025-2026**  
**Réalisé par : Bouayaben Bilal**

---

## Architecture du Projet

Ce repository regroupe l'ensemble des travaux pratiques effectués dans le cadre du cours d'ingénierie Big Data. Voici l'organisation des différents modules :

- **`docker_setup/`** : Configuration initiale de l'environnement Docker
  Infrastructure distribuée comprenant un nœud master et plusieurs workers, orchestrés via `docker-compose.yml` pour faciliter le déploiement et la gestion des volumes partagés.

- **`hadoop_labs/`** : Ateliers 1 & 2 — Hadoop Distributed File System & MapReduce
  Module complet intégrant des implémentations Java pour les opérations HDFS ainsi que des jobs MapReduce. Inclut également des scripts d'exécution optimisés pour l'écosystème Hadoop.

- **`kafka_lab3/`** : Atelier 3 — Apache Kafka & Streaming
  Exploration approfondie de Kafka avec le sous-module `kafka_lab` contenant des producteurs et consommateurs en Java, une application Kafka Streams pour le traitement en temps réel (WordCount), des configurations Kafka Connect, et un environnement Kafka-UI via Docker Compose.

- **`hive_lab6/`** : Atelier 6 — Data Warehousing avec Apache Hive
  Scripts HiveQL structurés pour la création de schémas, l'ingestion de données et l'exécution de requêtes analytiques avancées. Déployé dans un conteneur `hiveserver2-standalone` avec partage de volume `/shared_volume`.

## Réalisations Techniques

### 1. Infrastructure Conteneurisée (docker_setup)
  - Orchestration Docker Compose pour un cluster Hadoop multi-nœuds
  - Configuration du nœud master avec volume partagé pour la distribution des artefacts (JARs, fichiers de configuration)
  - Mise en place de l'écosystème distribué pour les traitements Big Data

### 2. Traitement Distribué avec Hadoop (hadoop_labs)
  - Implémentations Java robustes pour les opérations HDFS :
    * `HadoopFileStatus` : Inspection des métadonnées des fichiers distribués
    * `ReadHDFS` : Lecture optimisée depuis HDFS
    * `WriteHDFS` : Écriture et réplication de fichiers dans HDFS
  - Job MapReduce WordCount en Java avec optimisation des performances
  - Alternative Python utilisant Hadoop Streaming (mapper.py / reducer.py)

Consulter la documentation détaillée dans les fichiers PDF et README du répertoire correspondant.

### 3. Streaming & Messagerie avec Kafka (kafka_lab3)
  - Producteurs et consommateurs Java personnalisés (`EventProducer`, `EventConsumer`)
  - Applications interactives pour le traitement en temps réel (`WordProducer`, `WordCountConsumer`)
  - Application Kafka Streams stateful : `WordCountApp` avec state store local
  - Intégration Kafka Connect pour l'ingestion/export de données (file source ↔ topic ↔ file sink)
  - Interface de monitoring Kafka-UI pour la supervision du cluster

Documentation complète disponible dans les PDF et README du lab3.

### 4. Entrepôt de Données avec Hive (hive_lab6)
  - Déploiement et configuration d'Apache Hive (HiveServer2 + client Beeline)
  - Scripts HiveQL modulaires :
    * `Creation.hql` : Définition des schémas et tables partitionnées
    * `Loading.hql` : Stratégies d'ingestion de données
    * `Queries.hql` : Requêtes analytiques et agrégations complexes

Voir la documentation détaillée dans les PDF et README du lab6.

---
**Développé par : Bouayaben Bilal**
---
