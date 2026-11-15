FROM python:3.6-alpine

WORKDIR /opt

# Copier le fichier releases.txt dans l'image pour pouvoir le lire
COPY releases.txt /opt/releases.txt

# Extraire dynamiquement les valeurs du fichier releases.txt grâce à awk
RUN export ODOO_URL=$(awk '$1=="ODOO_URL"{print $2}' releases.txt) && \
    export PGADMIN_URL=$(awk '$1=="PGADMIN_URL"{print $2}' releases.txt) && \
    export VERSION=$(awk '$1=="VERSION"{print $2}' releases.txt) && \
    echo "Configuration pour Odoo: $ODOO_URL" && \
    echo "Configuration pour pgAdmin: $PGADMIN_URL" && \
    echo "Version de l'application: $VERSION"

# Installer les dépendances Flask
RUN pip install flask

# Copier le reste du code source de l'application
COPY . /opt/

EXPOSE 8080

# Définir les variables d'environnement basées sur le fichier (ou les rendre disponibles à l'exécution)
ENV ODOO_URL="https://www.odoo.com/"
ENV PGADMIN_URL="https://www.pgadmin.org/"

ENTRYPOINT ["python", "app.py"]