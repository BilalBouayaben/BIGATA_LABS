# Laboratoire 3 — Apache Kafka & Streaming en Temps Réel

**Réalisé par : Bouayaben Bilal** - 3A BI&A

## 📄 Documentation complète disponible dans le fichier "CR_Bouayaben_Bilal_TP3_Kafka.pdf"

---

Ce laboratoire explore l'écosystème Apache Kafka pour le traitement de flux de données en temps réel et la construction de pipelines de données événementielles.

## 📦 Contenu du Module

### Architecture des Sources Java
Répertoire : `kafka_lab/src/main/java/edu/ensias/kafka/`

**Composants de Base :**
  - **`EventProducer`** & **`EventConsumer`** : Implémentations fondamentales producteur/consommateur
  
**Applications Interactives :**
  - **`WordProducer`** : Interface en ligne de commande - capture clavier et publication sur topic Kafka
  - **`WordCountConsumer`** : Consommateur avec agrégation en mémoire - affichage des statistiques par mot

**Traitement de Flux (Streams) :**
  - **`WordCountApp`** : Application Kafka Streams stateful avec state store local pour comptage distribué

### Configuration & Build
- **`pom.xml`** : Configuration Maven avec génération d'un fat-jar (`*-jar-with-dependencies.jar` dans `target/`)
- **`docker-compose.yml`** : Orchestration Docker pour Kafka-UI (interface de monitoring)

## 🚀 Guide de Déploiement

### Étape 1 : Compilation du Projet
Exécuter sur la machine hôte :

```powershell
cd lab3_kafka/kafka_lab
mvn clean package
```

### Étape 2 : Distribution de l'Artefact
Copier le JAR assemblé vers le volume partagé du cluster :

```powershell
Copy-Item -Path .\target\*jar-with-dependencies*.jar -Destination "C:\Users\lenovo\hadoop_project\kafka" -Force
```
> **Note :** Adapter le chemin de destination selon votre configuration

### Étape 3 : Configuration des Topics Kafka
Depuis le conteneur `hadoop-master` :

```bash
# Création du topic d'entrée
/usr/local/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 \
  --create --topic input-topic --partitions 1 --replication-factor 1

# Création du topic de sortie
/usr/local/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 \
  --create --topic output-topic --partitions 1 --replication-factor 1
```

### Étape 4 : Lancement des Applications

#### Producteur Interactif (saisie clavier) :
```bash
java -cp /shared_volume/kafka/*jar-with-dependencies*.jar \
  edu.ensias.kafka.WordProducer input-topic localhost:9092
```

#### Consommateur avec Comptage :
```bash
java -cp /shared_volume/kafka/*jar-with-dependencies*.jar \
  edu.ensias.kafka.WordCountConsumer output-topic localhost:9092
```

### Étape 5 : Tests via Console Kafka

#### Publication manuelle sur input-topic :
```bash
/usr/local/kafka/bin/kafka-console-producer.sh \
  --broker-list localhost:9092 --topic input-topic
```

#### Consommation depuis output-topic (avec affichage des clés) :
```bash
/usr/local/kafka/bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 --topic output-topic \
  --from-beginning --property print.key=true
```

## 🏗️ Configuration Avancée - Cluster Multi-Brokers

### Architecture Distribuée
Le conteneur `hadoop-master` héberge une installation Kafka (typiquement dans `/usr/local/kafka`).

### Mise en Place d'un Cluster
Pour déployer un cluster Kafka haute disponibilité :
1. Créer des fichiers de configuration supplémentaires :
   - `server-one.properties` (port 9093)
   - `server-two.properties` (port 9094)
2. Lancer plusieurs instances de brokers
3. Créer des topics avec réplication :
   ```bash
   --replication-factor 2
   ```

## 🖥️ Interface de Monitoring : Kafka-UI

Le fichier `docker-compose.yml` inclut un service **Kafka-UI** accessible sur le port **8081** de l'hôte.

**Lancement :**
```powershell
docker-compose up -d
```

**Accès Web :** [http://localhost:8081](http://localhost:8081)

**Fonctionnalités :**
- Inspection des topics, partitions et offsets
- Visualisation des messages en temps réel
- Monitoring des groupes de consommateurs
- Gestion du cluster Kafka

## ⚠️ Notes Techniques Importantes

### Persistance des Données
- Le consommateur `WordCountConsumer` maintient les compteurs **uniquement en mémoire**
- Les données sont perdues au redémarrage de l'application
- Pour une persistance, envisager Kafka Streams avec state store ou une base externe

### Optimisation du Build
Pour générer des JARs dédiés avec points d'entrée spécifiques :
- Configurer le plugin `maven-shade-plugin` dans `pom.xml`
- Définir l'attribut `Main-Class` pour chaque exécutable
- Générer des artefacts séparés (producer.jar, consumer.jar, etc.)

### Bonnes Pratiques
- Utiliser des groupes de consommateurs pour le load balancing
- Configurer des stratégies de sérialisation appropriées (Avro, JSON, Protobuf)
- Monitorer les métriques de latence et de throughput
- Implémenter une gestion d'erreurs robuste (retry, dead-letter queues)

---

**Développé par : Bouayaben Bilal**
