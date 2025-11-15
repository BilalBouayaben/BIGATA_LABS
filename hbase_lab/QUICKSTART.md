# Guide de Démarrage Rapide - HBase Lab

## 🚀 Démarrage Rapide

### Méthode 1 : Utiliser HBase dans le conteneur Hadoop existant

```powershell
# 1. Se connecter au conteneur hadoop-master
docker exec -it hadoop-master bash

# 2. Vérifier si HBase est disponible
which hbase

# 3. Démarrer HBase (si nécessaire)
start-hbase.sh

# 4. Vérifier que HBase fonctionne
jps
# Vous devriez voir : HMaster, HRegionServer, HQuorumPeer

# 5. Lancer le shell HBase
hbase shell
```

### Méthode 2 : Utiliser un conteneur HBase dédié

```powershell
# Depuis le dossier hbase_lab
cd c:\Users\lenovo\hadoop_project\BIGDATA_ENGINEERING_LABS\hbase_lab

# Lancer HBase avec docker-compose
docker-compose -f docker-compose-hbase.yml up -d

# Vérifier que le conteneur est lancé
docker ps | grep hbase

# Se connecter au conteneur
docker exec -it hbase-standalone bash

# Lancer le shell HBase
hbase shell
```

## 📝 Commandes Essentielles

### Dans le shell HBase

```ruby
# Lister les tables
list

# Créer la table de l'exercice
create 'customers', 'customer', 'sales'

# Insérer des données (exemple)
put 'customers', '101', 'customer:name', 'John White'
put 'customers', '101', 'customer:city', 'Los Angeles, CA'
put 'customers', '101', 'sales:product', 'Lamps'
put 'customers', '101', 'sales:amount', '$200.00'

# Lire les données
scan 'customers'
get 'customers', '101'

# Quitter
exit
```

## 🧪 Exécuter le Script d'Exercice

```bash
# Copier le script dans le conteneur (depuis l'hôte PowerShell)
docker cp hbase_exercise.sh hadoop-master:/tmp/

# Ou si vous utilisez le volume partagé, depuis le conteneur :
cd /shared_volume/hbase_lab
chmod +x hbase_exercise.sh
./hbase_exercise.sh
```

## 🌐 Accès Web UI

### HBase Master Web UI
- URL : http://localhost:16010
- Affiche l'état du cluster HBase, les tables, les régions

### HBase RegionServer Web UI  
- URL : http://localhost:16030
- Affiche les statistiques du RegionServer

## 🔧 Dépannage

### HBase ne démarre pas
```bash
# Vérifier les logs
cat /usr/local/hbase/logs/hbase-*-master-*.log

# Vérifier HDFS
hdfs dfsadmin -report

# Vérifier ZooKeeper
zkCli.sh -server localhost:2181
```

### Erreur de connexion
```bash
# Vérifier que ZooKeeper fonctionne
jps | grep QuorumPeer

# Redémarrer HBase
stop-hbase.sh
start-hbase.sh
```

## 📚 Prochaines Étapes

1. ✅ Créer la table `customers`
2. ✅ Insérer les 4 enregistrements de l'exercice
3. ✅ Effectuer des lectures (scan et get)
4. ✅ Mettre à jour des données
5. ✅ Supprimer des données
6. 📝 Développer un programme Java pour interagir avec HBase
7. 📊 Charger des données depuis un fichier CSV

---
**Bouayaben Bilal - 2025**
