pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "sunilsahu0123/hello-world-spring-boot:latest"
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sahooosunil/hello-world-spring-boot.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        def app = docker.build(DOCKER_IMAGE)
                        app.push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-credential-id', variable: 'KUBECONFIG')]) {
                    sh 'kubectl apply -f k8s/deployment.yaml'
                    sh 'kubectl apply -f k8s/service.yaml'
                }
            }
        }
    }

}