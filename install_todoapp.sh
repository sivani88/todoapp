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

# Vérifier la présence du Dockerfile et déplacer les fichiers si nécessaire
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

# Construire l'image Docker
echo "Construction de l'image Docker..."
docker build -t sivani88/todoapp:$VERSION .

# Connexion à Docker Hub et push de l'image
echo "Connexion à Docker Hub..."
docker login

# Push de l'image sur Docker Hub
echo "Push de l'image sur Docker Hub..."
docker push sivani88/todoapp:$VERSION

echo "Installation et déploiement terminés !"
echo "Pour démarrer l'application localement, utilisez : docker run -p 8000:8000 sivani88/todoapp:$VERSION"
