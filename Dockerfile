FROM python:3.6-alpine

WORKDIR /opt

# Copier le fichier releases.txt dans l'image
COPY releases.txt /opt/releases.txt

# Installer les dépendances Flask
RUN pip install flask

# Copier le reste du code source
COPY . /opt/

EXPOSE 8080

# Définir l'application Flask pour écouter sur toutes les interfaces réseau
ENV HOST=0.0.0.0
ENV PORT=8080

ENTRYPOINT ["python", "app.py"]