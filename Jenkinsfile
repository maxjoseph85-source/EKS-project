pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        ACCOUNT_ID = '792126555869'
        ECR_REPO = 'eks-node-app'
        IMAGE_TAG = 'latest'
        IMAGE_URI = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
        CLUSTER_NAME = 'enterprise-cluster'
        DEPLOYMENT_NAME = 'eks-node-app'
        CONTAINER_NAME = 'eks-node-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/maxjoseph85-source/EKS-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh 'docker build -t eks-node-app .'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh '''
                    /usr/local/bin/aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    '''
                }
            }
        }

        stage('Tag Image') {
            steps {
                sh 'docker tag eks-node-app:latest $IMAGE_URI'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_URI'
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh '''
                    /usr/local/bin/aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                    sed -i 's|command: aws|command: /usr/local/bin/aws|g' ~/.kube/config || true
                    sed -i 's|client.authentication.k8s.io/v1alpha1|client.authentication.k8s.io/v1beta1|g' ~/.kube/config || true
                    kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=$IMAGE_URI
                    kubectl rollout status deployment/$DEPLOYMENT_NAME
                    '''
                }
            }
        }
    }
}