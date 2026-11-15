from flask import Flask, render_template
import socket
import os

app = Flask(__name__)

@app.route("/")
def main():
    odoo_url = os.environ.get('ODOO_URL', 'https://www.odoo.com/')
    pgadmin_url = os.environ.get('PGADMIN_URL', 'https://www.pgadmin.org/')
    return render_template('index.html', name=socket.gethostname(), odoo_url=odoo_url, pgadmin_url=pgadmin_url)

if __name__ == "__main__":
    print("Démarrage de l'application Flask sur le port 8080...")
    app.run(host="0.0.0.0", port=8080)