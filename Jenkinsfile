pipeline {
    agent any

    environment {
        // Lecture dynamique de la version depuis releases.txt pour taguer l'image
        VERSION = sh(script: "awk '\$1==\"VERSION\"{print \$2}' releases.txt", returnStdout: true).trim()
        IMAGE_NAME = "ic-webapp"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Récupération du code source depuis le dépôt Git..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Construction de l'image Docker ${IMAGE_NAME}:${VERSION}..."
                // Le Dockerfile lit automatiquement les URL dans releases.txt grâce à awk
                sh "docker build -t ${IMAGE_NAME}:${VERSION} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Test Application') {
            steps {
                echo "Lancement d'un conteneur de test pour valider l'application..."
                // Lancement d'un test rapide pour vérifier que Flask répond
                sh "docker run -d --name test-ic-webapp -p 8080:8080 ${IMAGE_NAME}:${VERSION}"
                // Attente de démarrage puis test HTTP simple
                sh "sleep 3 && curl -I http://localhost:8080 || exit 1"
                // Nettoyage du conteneur de test
                sh "docker rm -f test-ic-webapp"
            }
        }

        stage('Deploy with Ansible') {
            steps {
                echo "Déploiement des applications Odoo et pgAdmin via les rôles Ansible..."
                // Exécution du playbook Ansible principal qui appelle odoo_role et pgadmin_role
                sh "ansible-playbook -i localhost, -c local playbook.yaml"
            }
        }
    }

    post {
        success {
            echo "Pipeline exécuté avec succès ! L'application est déployée."
        }
        failure {
            echo "Échec du pipeline. Veuillez vérifier les logs ci-dessus."
        }
    }
}