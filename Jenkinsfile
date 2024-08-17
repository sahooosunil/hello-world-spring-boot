pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "sunilsahu0123/hello-world-spring-boot:${env.BUILD_NUMBER}"
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
                sh "docker build -t ${DOCKER_IMAGE} ."
                sh 'docker image list'
            }
        }
        stage("Docker Login and push"){
            steps {
                withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'PASSWORD')]) {
                    sh 'docker login -u sunilsahu0123@gmail.com -p $PASSWORD'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('SSH into Kmaster n Deploy to K8s cluster') {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'K8S master'
                    remote.host = '192.168.64.13'
                    remote.user = 'ubuntu'
                    remote.allowAnyHosts = true
                    remote.identityFile = '/var/lib/jenkins/.ssh/id_rsa' 
                    // Upload the deployment.yaml file
                    sshPut remote: remote, from: 'k8s/deployment.yaml', into: '.'
                    // Replace placeholder with actual Docker image tag
                    sshCommand remote: remote, command: "sed -i 's|sunilsahu0123/hello-world-spring-boot:.*|${DOCKER_IMAGE}|g' deployment.yaml"
                    sshCommand remote: remote, command: "kubectl apply -f deployment.yaml"
                    sshPut remote: remote, from: 'k8s/service.yaml', into: '.'
                    sshCommand remote: remote, command: "kubectl apply -f service.yaml"
                    
                }
            }
        }
    }

}