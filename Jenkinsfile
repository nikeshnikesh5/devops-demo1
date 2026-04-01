pipeline {
    agent any

    environment {
        // These are your global variables
        DOCKER_IMAGE = "techhunt/devops-demo:latest"
        K8S_VM_USER  = "root"
        K8S_VM_IP    = "192.168.122.158"
        // Ensure this ID matches the one you created in Jenkins Credentials
        DOCKER_HUB_CREDS = "docker-cred" 
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // This builds the image locally on the Jenkins agent
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // This pulls the GLOBAL credentials by their ID
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDS}") {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // This pulls the GLOBAL SSH key by its ID
                sshagent(['k8s-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${K8S_VM_USER}@${K8S_VM_IP} \
                        "kubectl apply -f /path/to/your/k8s/configs"
                    """
                }
            }
        }
    }
}