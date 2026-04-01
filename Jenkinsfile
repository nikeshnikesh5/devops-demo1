pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "techhunt/devops-demo:latest"
        K8S_VM_USER  = "root"
        K8S_VM_IP    = "192.168.122.158"
    }

    stages { // <--- Added this mandatory block
        stage('Checkout') {
            steps {
                git 'https://github.com/nikeshnikesh5/devops-demo1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image(DOCKER_IMAGE).push()
                    } // Closed registry block
                } // Closed script block
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sshagent(['k8s-ssh-key-id']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${K8S_VM_USER}@${K8S_VM_IP} \
                        "kubectl apply -f /path/to/your/k8s/configs"
                    """
                }
            }
        }
    } // Closed stages block
} // Closed pipeline block