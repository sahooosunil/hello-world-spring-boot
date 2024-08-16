pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "sunilsahu0123/hello-world-spring-boot:latest"
        DOCKER_CREDENTIALS = credentials('docker-credential-id')
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
        stage("Docker build"){
            sh 'docker version'
            sh 'docker build -t sunilsahu0123/hello-world-spring-boot:latest .'
            sh 'docker image list'
        }
        stage("Docker Login"){
                withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'PASSWORD')]) {
                    sh 'docker login -u sunilsahu0123@gmail.com -p $PASSWORD'
                }
        }
        stage("Push Image to Docker Hub"){
            sh 'docker push  sunilsahu0123/hello-world-spring-boot:latest'
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