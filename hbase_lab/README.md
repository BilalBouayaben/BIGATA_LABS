# Laboratoire 4 — Apache HBase

**Réalisé par : Bouayaben Bilal** - Année Universitaire 2025-2026

## 📄 Objectifs du TP

Ce laboratoire couvre les aspects fondamentaux d'Apache HBase, une base de données NoSQL distribuée construite sur Hadoop HDFS.

### 🎯 Compétences visées :
- ✅ Installation et configuration d'Apache HBase
- ✅ Première utilisation du shell HBase
- ✅ Utilisation de l'API HBase en Java
- ✅ Chargement et manipulation de fichiers
- ✅ Traitement de données avec Apache Spark

---

## 🏗️ Architecture

**Apache HBase** est une base de données orientée colonnes open-source, distribuée et versionnée. Elle fournit des fonctionnalités de type BigTable de Google sur la base de Hadoop HDFS.

**HBase** offre également une API en Java permettant de pouvoir interagir avec les données de la base.

---

## 📋 Prérequis

### Infrastructure Docker
Assurez-vous que les conteneurs Hadoop sont lancés :

```powershell
# Depuis le dossier docker_setup
cd ..\docker_setup
docker-compose up -d

# Vérifier que les conteneurs sont actifs
docker ps
```

Vous devez avoir :
- `hadoop-master` (conteneur principal)
- `hadoop-slave1` et `hadoop-slave2` (workers)

---

## 🚀 Installation HBase

### Étape 1 : Télécharger HBase

HBase peut être téléchargé depuis le cluster Hadoop (généralement pré-installé dans l'image `hadoop-spark-jupyter`) ou vous pouvez utiliser un conteneur dédié HBase.

**Option 1 : Utiliser l'image avec HBase intégré**
```bash
# Se connecter au conteneur master
docker exec -it hadoop-master bash

# Vérifier si HBase est installé
which hbase
```

**Option 2 : Utiliser un conteneur HBase standalone**
```bash
# Lancer un conteneur HBase standalone
docker run -itd \
  --name hbaseserver-standalone \
  --hostname hbaseserver-standalone \
  --network docker_setup_hadoop-network \
  -p 16010:16010 \
  -p 16030:16030 \
  -v C:/Users/lenovo/hadoop_project/BIGDATA_ENGINEERING_LABS:/shared_volume \
  harisekhon/hbase:1.4
```

### Étape 2 : Démarrer HBase

```bash
# Si HBase est dans le conteneur hadoop-master
docker exec -it hadoop-master bash

# Lancer HBase (si non automatique)
cd /usr/local/hbase
./bin/start-hbase.sh

# Vérifier que HBase est lancé
jps
# Vous devez voir : HMaster
```

---

## 💻 Première Utilisation - HBase Shell

### Lancer le shell HBase

```bash
# Depuis le conteneur
hbase shell
```

### Commandes de base

#### Créer une table
```ruby
# Syntaxe : create 'nom_table', 'famille_colonnes'
create 'customers', 'customer', 'sales'
```

#### Lister les tables
```ruby
list
```

#### Décrire une table
```ruby
describe 'customers'
```

#### Insérer des données
```ruby
# put 'table', 'row_key', 'column_family:column', 'value'
put 'customers', '101', 'customer:name', 'John White'
put 'customers', '101', 'customer:city', 'Los Angeles, CA'
put 'customers', '101', 'sales:product', 'Lamps'
put 'customers', '101', 'sales:amount', '$200.00'

put 'customers', '102', 'customer:name', 'Jane Brown'
put 'customers', '102', 'customer:city', 'Atlanta, GA'
put 'customers', '102', 'sales:product', 'Lamps'
put 'customers', '102', 'sales:amount', '$200.00'

put 'customers', '103', 'customer:name', 'Bill Green'
put 'customers', '103', 'customer:city', 'Pittsburgh, PA'
put 'customers', '103', 'sales:product', 'Desk'
put 'customers', '103', 'sales:amount', '$500.00'

put 'customers', '104', 'customer:name', 'Jack Black'
put 'customers', '104', 'customer:city', 'St. Louis, MO'
put 'customers', '104', 'sales:product', 'Bed'
put 'customers', '104', 'sales:amount', '$1,600.00'
```

#### Lire des données
```ruby
# Lire toute la table
scan 'customers'

# Lire une ligne spécifique
get 'customers', '101'

# Lire une colonne spécifique
get 'customers', '101', 'customer:name'
```

#### Mettre à jour des données
```ruby
# Mettre à jour une valeur (même syntaxe que put)
put 'customers', '101', 'sales:amount', '$250.00'
```

#### Supprimer des données
```ruby
# Supprimer une colonne
delete 'customers', '101', 'sales:amount'

# Supprimer une ligne complète
deleteall 'customers', '101'
```

#### Supprimer une table
```ruby
# Désactiver la table avant de la supprimer
disable 'customers'
drop 'customers'
```

---

## 🔧 Utilisation de l'API HBase (Java)

### Configuration Maven

Ajouter les dépendances HBase dans `pom.xml` :

```xml
<dependencies>
    <dependency>
        <groupId>org.apache.hbase</groupId>
        <artifactId>hbase-client</artifactId>
        <version>2.4.9</version>
    </dependency>
    <dependency>
        <groupId>org.apache.hbase</groupId>
        <artifactId>hbase-common</artifactId>
        <version>2.4.9</version>
    </dependency>
</dependencies>
```

### Exemple : Créer une table avec Java

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;

public class HBaseExample {
    public static void main(String[] args) throws Exception {
        Configuration config = HBaseConfiguration.create();
        config.set("hbase.zookeeper.quorum", "localhost");
        config.set("hbase.zookeeper.property.clientPort", "2181");
        
        Connection connection = ConnectionFactory.createConnection(config);
        Admin admin = connection.getAdmin();
        
        // Créer une table
        TableName tableName = TableName.valueOf("test_table");
        TableDescriptorBuilder builder = TableDescriptorBuilder.newBuilder(tableName);
        builder.setColumnFamily(ColumnFamilyDescriptorBuilder.of("cf1"));
        
        admin.createTable(builder.build());
        
        System.out.println("Table créée avec succès !");
        
        admin.close();
        connection.close();
    }
}
```

---

## 📊 Chargement de Fichiers

### Bulk Load avec ImportTsv

```bash
# Préparer un fichier CSV
# Format : row_key,column_family:column,value

# Charger dans HBase
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv \
  -Dimporttsv.separator=',' \
  -Dimporttsv.columns=HBASE_ROW_KEY,customer:name,customer:city,sales:product,sales:amount \
  customers \
  hdfs://hadoop-master:9000/user/data/customers.csv
```

---

## 🧪 Exercices Pratiques

### Exercice 1 : Manipulation de base
1. Créer une table `products` avec deux familles de colonnes : `info` et `stock`
2. Insérer 5 produits avec leurs informations
3. Afficher tous les produits
4. Mettre à jour le stock d'un produit
5. Supprimer un produit

### Exercice 2 : API Java
1. Créer un programme Java qui se connecte à HBase
2. Créer une table programmatiquement
3. Insérer des données
4. Lire et afficher les données

### Exercice 3 : Traitement avec Spark
1. Charger des données depuis HBase dans Spark
2. Effectuer des agrégations
3. Sauvegarder les résultats dans une nouvelle table HBase

---

## 📝 Notes Techniques

### Architecture HBase
- **HMaster** : Coordonne le cluster HBase
- **RegionServer** : Gère les régions (partitions de tables)
- **ZooKeeper** : Coordination et configuration
- **HDFS** : Stockage sous-jacent

### Familles de Colonnes
- Regroupement logique de colonnes
- Définies à la création de la table
- Optimisation du stockage et des performances

### Row Key Design
- **Critique** pour les performances
- Éviter les hotspots (concentration sur un seul RegionServer)
- Utiliser des préfixes distribués si nécessaire

### Bonnes Pratiques
- Limiter le nombre de familles de colonnes (généralement 1-3)
- Utiliser des Row Keys bien distribuées
- Activer la compression pour réduire l'espace disque
- Utiliser le bloom filter pour améliorer les lectures

---

## 🔗 Ressources Utiles

- [Documentation officielle HBase](https://hbase.apache.org/)
- [HBase Shell Reference](https://hbase.apache.org/book.html#shell)
- [HBase Java API](https://hbase.apache.org/apidocs/)

---

**Développé par : Bouayaben Bilal**
