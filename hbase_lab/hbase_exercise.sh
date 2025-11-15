#!/bin/bash
# Script HBase - Exercice Lab 4
# Auteur : Bouayaben Bilal

echo "==========================================="
echo "  Exercice HBase - Création et Manipulation"
echo "==========================================="

# Créer la table customers avec deux familles de colonnes
echo "1. Création de la table 'customers'..."
hbase shell <<EOF
create 'customers', 'customer', 'sales'
list
describe 'customers'
EOF

# Insérer des données
echo ""
echo "2. Insertion des données..."
hbase shell <<EOF
# Client 101 - John White
put 'customers', '101', 'customer:name', 'John White'
put 'customers', '101', 'customer:city', 'Los Angeles, CA'
put 'customers', '101', 'sales:product', 'Lamps'
put 'customers', '101', 'sales:amount', '\$200.00'

# Client 102 - Jane Brown
put 'customers', '102', 'customer:name', 'Jane Brown'
put 'customers', '102', 'customer:city', 'Atlanta, GA'
put 'customers', '102', 'sales:product', 'Lamps'
put 'customers', '102', 'sales:amount', '\$200.00'

# Client 103 - Bill Green
put 'customers', '103', 'customer:name', 'Bill Green'
put 'customers', '103', 'customer:city', 'Pittsburgh, PA'
put 'customers', '103', 'sales:product', 'Desk'
put 'customers', '103', 'sales:amount', '\$500.00'

# Client 104 - Jack Black
put 'customers', '104', 'customer:name', 'Jack Black'
put 'customers', '104', 'customer:city', 'St. Louis, MO'
put 'customers', '104', 'sales:product', 'Bed'
put 'customers', '104', 'sales:amount', '\$1,600.00'
EOF

# Afficher toutes les données
echo ""
echo "3. Affichage de toutes les données..."
hbase shell <<EOF
scan 'customers'
EOF

# Lire un enregistrement spécifique
echo ""
echo "4. Lecture du client 101..."
hbase shell <<EOF
get 'customers', '101'
EOF

# Mettre à jour un enregistrement
echo ""
echo "5. Mise à jour du montant pour le client 101..."
hbase shell <<EOF
put 'customers', '101', 'sales:amount', '\$250.00'
get 'customers', '101'
EOF

echo ""
echo "==========================================="
echo "  Script terminé avec succès !"
echo "==========================================="
