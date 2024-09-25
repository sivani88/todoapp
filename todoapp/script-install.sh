#!/bin/bash

echo "Starting Django project diagnostic..."

# Activer l'environnement virtuel
echo "Activating virtual environment..."
source ../venv/bin/activate

# Vérifier la version de Python
echo "Python version:"
python3 --version

# Vérifier la version de pip
echo "Pip version:"
python3 -m pip --version

# Mettre à jour pip
echo "Updating pip..."
python3 -m pip install --upgrade pip

# Installer ou mettre à jour Django
echo "Installing/Updating Django..."
python3 -m pip install --upgrade django

# Afficher les bibliothèques installées
echo "Installed libraries:"
python3 -m pip list

# Vérifier la présence de manage.py
if [ -f manage.py ]; then
    echo "manage.py found."
else
    echo "Error: manage.py not found in the current directory."
    pwd
    ls -la
    exit 1
fi

# Vérifier les fichiers du projet
echo "Project files:"
ls -la

# Tenter de lancer une commande Django
echo "Attempting to run Django check command..."
python3 manage.py check

# Tenter de lancer le serveur Django
echo "Attempting to run Django server..."
python3 manage.py runserver

echo "Script completed."