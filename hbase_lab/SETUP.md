# 📊 Résumé - Lab HBase Configuration

## ✅ Ce qui a été créé

### 1. **README.md** 
   - Documentation complète du lab HBase
   - Installation et configuration
   - Commandes shell HBase
   - API Java
   - Exercices pratiques

### 2. **QUICKSTART.md**
   - Guide de démarrage rapide
   - Deux méthodes de déploiement
   - Commandes essentielles
   - Dépannage

### 3. **docker-compose-hbase.yml**
   - Configuration Docker pour HBase standalone
   - Connecté au réseau Hadoop existant
   - Ports exposés pour Web UI

### 4. **hbase_exercise.sh**
   - Script automatisé pour l'exercice
   - Création de la table `customers`
   - Insertion des 4 enregistrements
   - Opérations CRUD

### 5. **customers_data.csv**
   - Données de test pour bulk load
   - 10 enregistrements clients

## 🚀 Pour Commencer

### Étape 1 : Vérifier les conteneurs Hadoop
```powershell
cd c:\Users\lenovo\hadoop_project\BIGDATA_ENGINEERING_LABS\docker_setup
docker-compose ps
```

### Étape 2 : Choisir votre méthode HBase

#### Option A : HBase dans hadoop-master (recommandé si disponible)
```powershell
docker exec -it hadoop-master bash
hbase version
# Si HBase n'est pas installé, passez à l'Option B
```

#### Option B : HBase standalone
```powershell
cd ..\hbase_lab
docker-compose -f docker-compose-hbase.yml up -d
docker exec -it hbase-standalone bash
```

### Étape 3 : Démarrer HBase Shell
```bash
hbase shell
```

### Étape 4 : Exécuter l'exercice
```ruby
# Dans le shell HBase, créer la table
create 'customers', 'customer', 'sales'

# Insérer les données (voir README.md pour les commandes complètes)
put 'customers', '101', 'customer:name', 'John White'
# ... etc

# Afficher les données
scan 'customers'
```

## 📁 Structure du Lab

```
hbase_lab/
├── README.md                      # Documentation complète
├── QUICKSTART.md                  # Guide rapide
├── SETUP.md                       # Ce fichier
├── docker-compose-hbase.yml       # Config Docker HBase
├── hbase_exercise.sh              # Script automatisé
└── customers_data.csv             # Données de test
```

## 🌐 Interfaces Web

- **HBase Master UI** : http://localhost:16010
- **HBase RegionServer UI** : http://localhost:16030
- **Hadoop NameNode UI** : http://localhost:9870
- **Hadoop ResourceManager UI** : http://localhost:8088

## 📝 Prochaines Étapes

1. ✅ Infrastructure Docker opérationnelle
2. 🔄 Choisir et démarrer HBase (Option A ou B)
3. 📖 Suivre le README.md pour les exercices
4. 💻 Développer des programmes Java (optionnel)
5. 📊 Expérimenter avec Spark + HBase (avancé)

## 🆘 Besoin d'Aide ?

Consultez la section **Dépannage** dans QUICKSTART.md

---
**Bouayaben Bilal - Lab HBase 2025**
