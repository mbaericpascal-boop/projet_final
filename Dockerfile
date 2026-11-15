FROM python:3.6-alpine

WORKDIR /opt

# Copier l'intégralité du projet
COPY . /opt/

# Installer Flask
RUN pip install --no-cache-dir flask

EXPOSE 8080

# Lancer l'application Flask au démarrage du conteneur
CMD ["python", "app.py"]