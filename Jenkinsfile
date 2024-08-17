pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "sunilsahu0123/hello-world-spring-boot:${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                // Clone the repository
                git branch: 'main', url: 'https://github.com/sahooosunil/hello-world-spring-boot.git'
            }
        }
        stage('Build') {
            steps {
                // Compile and package the application
                sh 'mvn clean package'
            }
        }
        stage('Docker Build') {
            steps {
                // Check Docker version
                sh 'docker version'

                // Build Docker image
                sh "docker build -t ${DOCKER_IMAGE} ."

                // List Docker images
                sh 'docker image list'
            }
        }
        stage('Docker Login and Push') {
            steps {
                withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'PASSWORD')]) {
                    // Login to Docker Hub
                    sh 'docker login -u sunilsahu0123@gmail.com -p $PASSWORD'
                    
                    // Push Docker image to repository
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Deploy to K8s Cluster') {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'K8S master'
                    remote.host = '192.168.64.13'
                    remote.user = 'ubuntu'
                    remote.allowAnyHosts = true
                    remote.identityFile = '/var/lib/jenkins/.ssh/id_rsa'

                    // Upload deployment.yaml to the remote server
                    sshPut remote: remote, from: 'k8s/deployment.yaml', into: '.'
                    
                    // Update the Docker image tag in deployment.yaml
                    sshCommand remote: remote, command: "sed -i 's|sunilsahu0123/hello-world-spring-boot:.*|${DOCKER_IMAGE}|g' deployment.yaml"
                    
                    // Apply deployment configuration to the Kubernetes cluster
                    sshCommand remote: remote, command: "kubectl apply -f deployment.yaml"
                    
                    // Upload and apply service.yaml
                    sshPut remote: remote, from: 'k8s/service.yaml', into: '.'
                    sshCommand remote: remote, command: "kubectl apply -f service.yaml"
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
        always {
            cleanWs() // Clean workspace after build
        }
    }
}