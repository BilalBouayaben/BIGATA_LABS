# Laboratoires d'Ingénierie Big Data

## 📄 Documentation complète disponible dans le fichier "tp1bigdata_HDFS_MapReduce_Bouayaben_Bilal_CR.pdf"


Ce module regroupe les travaux pratiques 1 et 2 axés sur l'écosystème Apache Hadoop, incluant le système de fichiers distribué HDFS et le framework de traitement parallèle MapReduce.

## 📁 Organisation du Repository

- **`hadoop_lab/`** - Projet Maven pour les implémentations Hadoop
  - `src/main/java/edu/ensias/hadoop/hdfslab/` - Utilitaires pour les manipulations HDFS
  - `src/main/java/edu/ensias/hadoop/mapreducelab/` - Implémentations MapReduce
- **`mapper.py`** - Script Python pour la phase de mapping (compatibilité Hadoop Streaming)
- **`reducer.py`** - Script Python pour la phase de réduction (compatibilité Hadoop Streaming)
- **`alice.txt`** - Dataset de test pour l'algorithme WordCount

## 🔬 Travaux Pratiques Réalisés

### TP 1 : Opérations sur HDFS (Hadoop Distributed File System)
Développement d'utilitaires Java pour interagir avec le système de fichiers distribué :
- **`HadoopFileStatus`** : Inspection des métadonnées et statistiques des fichiers HDFS
- **`ReadHDFS`** : Lecture distribuée et récupération du contenu depuis HDFS
- **`WriteHDFS`** : Création et écriture de nouveaux fichiers avec réplication automatique

### TP 2 : Traitement Parallèle avec MapReduce (Java)
- **`WordCount`** : Implémentation complète du paradigme MapReduce en Java pour le comptage de fréquences de mots
  - Phase Map : Tokenisation et émission de paires (mot, 1)
  - Phase Reduce : Agrégation des compteurs par clé

### TP 3 : MapReduce avec Python (Hadoop Streaming)
Approche polyglotte utilisant l'API Hadoop Streaming :
- **`mapper.py`** : Transformation des données en flux de paires clé-valeur
- **`reducer.py`** : Agrégation finale des résultats

## 🛠️ Stack Technologique

- **Apache Hadoop** 3.2.0
- **Java Development Kit** 8
- **Python** 3.x
- **Apache Maven** - Gestion des dépendances et build
- **Docker** - Environnement Hadoop conteneurisé

## 🚀 Guide d'Utilisation

### Compilation du Projet Maven
```bash
mvn clean package
```

### Exécution des Jobs Hadoop

#### WordCount en Java
```bash
hadoop jar WordCount.jar /user/root/input/file.txt /user/root/output/wordcount
```

#### WordCount en Python (via Hadoop Streaming)
```bash
hadoop jar hadoop-streaming-3.2.0.jar \
    -files mapper.py,reducer.py \
    -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" \
    -input /user/root/input/file.txt \
    -output /user/root/output/wordcount_python
```

---
**Développé par : Bouayaben Bilal**
