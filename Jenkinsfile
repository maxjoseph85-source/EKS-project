pipeline {
    agent any

    environment {
        AWS_REGION      = 'us-east-2'
        ACCOUNT_ID      = '792126555869'
        ECR_REPO        = 'eks-node-app'
        IMAGE_NAME      = 'eks-node-app'
        IMAGE_TAG       = 'latest'
        IMAGE_URI       = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
        CLUSTER_NAME    = 'enterprise-cluster'
        DEPLOYMENT_NAME = 'eks-node-app'
        CONTAINER_NAME  = 'eks-node-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/maxjoseph85-source/EKS-project.git'
            }
        }

        stage('Verify Files') {
            steps {
                sh '''
                    echo "Current directory:"
                    pwd
                    echo "Root contents:"
                    ls -la
                    echo "App folder contents:"
                    ls -la app
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh '''
                        echo "Building Docker image..."
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }

        stage('Tag Image') {
            steps {
                sh '''
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_URI}
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    docker push ${IMAGE_URI}
                '''
            }
        }
    }

    post {
        always {
            sh 'docker images || true'
        }
        success {
            echo ' Pipeline completed successfully'
        }
        failure {
            echo ' Pipeline failed - check logs'
        }
    }
}