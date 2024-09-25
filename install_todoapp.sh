#!/bin/bash

VERSION="1.0.6"

# Mise à jour du système
echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installation des dépendances nécessaires
echo "Installation des dépendances..."
sudo apt install -y git python3 python3-pip python3-venv docker.io

# Activation de Docker
echo "Configuration de Docker..."
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Clonage du dépôt
echo "Clonage du dépôt GitHub..."
git clone https://github.com/sivani88/todoapp.git
cd todoapp

# Gestion du problème potentiel de répertoire
if [ ! -f Dockerfile ]; then
    echo "Dockerfile non trouvé dans le répertoire principal. Recherche dans les sous-répertoires..."
    DOCKERFILE_PATH=$(find . -name Dockerfile)
    if [ -n "$DOCKERFILE_PATH" ]; then
        echo "Dockerfile trouvé à $DOCKERFILE_PATH. Déplacement des fichiers..."
        mv $(dirname $DOCKERFILE_PATH)/* .
        rm -rf $(dirname $DOCKERFILE_PATH)
    else
        echo "Dockerfile non trouvé. Veuillez vérifier votre dépôt."
        exit 1
    fi
fi

# Création et activation de l'environnement virtuel
echo "Configuration de l'environnement Python..."
python3 -m venv venv
source venv/bin/activate

# Installation des dépendances Python
echo "Installation des dépendances Python..."
pip install -r requirements.txt

# Construction de l'image Docker
echo "Construction de l'image Docker..."
docker build -t sivani88/todoapp:1.0.4 .

# Connexion à Docker Hub
echo "Connexion à Docker Hub..."
echo "Veuillez entrer vos identifiants Docker Hub :"
docker login

# Construction de l'image Docker
echo "Construction de l'image Docker..."
docker build -t sivani88/todoapp:$VERSION .

# Push de l'image sur Docker Hub
echo "Push de l'image sur Docker Hub..."
docker push sivani88/todoapp:$VERSION


echo "Installation et déploiement terminés !"
echo "Pour activer l'environnement virtuel, utilisez : source venv/bin/activate"
echo "Pour démarrer l'application localement, utilisez : docker run -p 8000:8000 sivani88/todoapp:$VERSION"