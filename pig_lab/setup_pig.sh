#!/bin/bash
# Configuration des variables d'environnement pour PIG
echo 'export PIG_HOME=/usr/local/pig' >> ~/.bashrc
echo 'export PATH=$PATH:$PIG_HOME/bin' >> ~/.bashrc
source ~/.bashrc
