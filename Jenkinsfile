pipeline {
    agent any

    environment {
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
                script {
                    // Extraction robuste de la version, compatible avec tous les formats de releases.txt
                    env.VERSION = sh(
                        script: "grep -i 'VERSION' releases.txt | awk -F'[:= ]+' '{print \$NF}' | tr -d '\\r' | tr -d ' \"'",
                        returnStdout: true
                    ).trim()

                    echo "Version détectée : '${env.VERSION}'"

                    if (env.VERSION == "") {
                        error("Erreur critique : La version lue dans releases.txt est vide !")
                    }

                    echo "Construction de l'image Docker ${IMAGE_NAME}:${env.VERSION}..."
                    sh "docker build -t ${IMAGE_NAME}:${env.VERSION} -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Test Application') {
            steps {
                echo "Lancement d'un conteneur de test sur le port 8082..."
                sh "docker run -d --name test-ic-webapp -p 8082:8080 ${IMAGE_NAME}:${env.VERSION}"
                
                // Attente de démarrage du serveur Flask
                sh "sleep 3"
                
                // Test de connexion ultra-robuste sur une ligne stricte sans indentation
                sh """
                    python3 -c "import urllib.request; print(urllib.request.urlopen('http://localhost:8082').getcode())" || (
                        echo "--- ERREUR : ECHEC DU TEST DE CONNEXION ---"
                        docker logs test-ic-webapp
                        docker rm -f test-ic-webapp
                        exit 1
                    )
                """
                
                // Nettoyage en cas de succès
                sh "docker rm -f test-ic-webapp"
            }
        }

        stage('Deploy with Ansible') {
            steps {
                echo "Déploiement des applications Odoo et pgAdmin via les rôles Ansible..."
                // Exécution du playbook Ansible principal
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