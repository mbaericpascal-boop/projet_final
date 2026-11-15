FROM python:3.6-alpine

WORKDIR /opt

# Copier l'intégralité du projet (y compris templates et releases.txt)
COPY . /opt/

# Installer les dépendances Flask
RUN pip install flask

EXPOSE 8080

ENTRYPOINT ["python", "app.py"]