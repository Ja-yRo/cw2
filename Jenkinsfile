pipeline {
    agent any
    environment {
        DOCKERHUB_CREDS = credentials('docker') 
    }
    stages {
        stage('Docker Image Build') {
            steps {
                echo 'Building Docker Image...'
                sh 'docker build --tag jayr1/cw2-server:0.1 .'
                echo 'Docker Image built successfully'
            }
        }

        stage('Test Docker Image') {
            steps {
                echo 'Testing Docker Image...'
                sh '''
                    docker image inspect jayr1/cw2-server:0.1
                    docker run --name test-container -p 8080:8080 -d jayr1/cw2-server:0.1
                    docker ps
                    docker stop test-container
                    docker rm test-container
                '''
                echo 'Docker Image test completed successfully.'
            }
        }

        stage('DockerHub Login') {
            steps {
                echo 'Logging into DockerHub...'
                sh '''
                    echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin
                '''
                echo 'DockerHub login successful.'
            }
        }

        stage('DockerHub Image Push') {
            steps {
                echo 'Pushing Docker Image to DockerHub...'
                sh 'docker push jayr1/cw2-server:0.1'
                echo 'Docker Image pushed successfully.'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to Production Server...'
                sshagent(['jenkins-k8s-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.18.90 '
                        docker pull jayr1/cw2-server:0.1
                        docker stop production-container || true
                        docker rm production-container || true
                        docker run -d --name production-container -p 8080:8080 jayr1/cw2-server:0.1
                        '
                    '''
                }
                echo 'Deployment completed successfully.'
            }
        }
    }
}
