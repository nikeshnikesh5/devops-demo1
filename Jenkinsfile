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
        sshagent(['k8s-ssh-key-id']) {
            sh """
                # 1. Create a directory on the remote VM just in case
                ssh -o StrictHostKeyChecking=no ${K8S_VM_USER}@${K8S_VM_IP} "mkdir -p /root/k8s-deploy"

                # 2. Copy the YAML files from Jenkins workspace to the VM
                # (Assuming your YAMLs are in a folder named 'k8s' in your repo)
                scp -o StrictHostKeyChecking=no k8s/*.yaml ${K8S_VM_USER}@${K8S_VM_IP}:/root/k8s-deploy/

                # 3. Apply the configuration
                ssh -o StrictHostKeyChecking=no ${K8S_VM_USER}@${K8S_VM_IP} "kubectl apply -f /root/k8s-deploy/"
            """
        }
    }
}
    }
}
