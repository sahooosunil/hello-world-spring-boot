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
            steps {
                sh 'docker version'
                sh 'docker build -t sunilsahu0123/hello-world-spring-boot:latest .'
                sh 'docker image list'
            }
        }
        stage("Docker Login and push"){
            steps {
                withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'PASSWORD')]) {
                    sh 'docker login -u sunilsahu0123@gmail.com -p $PASSWORD'
                    sh 'docker push  sunilsahu0123/hello-world-spring-boot:latest'
                }
            }
        }

        stage("SSH Into k8s Server") {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'K8S master'
                    remote.host = '192.168.64.9'
                    remote.user = 'ubuntu'
                    remote.password = 'welcome1'
                    remote.allowAnyHosts = true

                    sshPut remote: remote, from: 'k8s/deployment.yaml', into: '.'
                    sshCommand remote: remote, command: "kubectl apply -f deployment.yaml"
                    sshPut remote: remote, from: 'k8s/service.yaml', into: '.'
                    sshCommand remote: remote, command: "kubectl apply -f service.yaml"
                }
            }
        }
    }

}