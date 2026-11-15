FROM python:3.6-alpine

WORKDIR /opt

# Copier l'intégralité du projet
COPY . /opt/

# Installer explicitement Flask et les dépendances nécessaires
RUN pip install --no-cache-dir flask

EXPOSE 8080

# Lancer l'application Flask
CMD ["python", "app.py"]