pipeline {
    agent { label 'jenkins-agent' }

    environment {
        DOCKER_REGISTRY = "amradel2002"    
        BUILD_TAG       = "${BUILD_NUMBER}"
        KUBECONFIG      = '/home/jenkins/.kube/config'
        NAMESPACE       = 'dev'
        APP_HEALTH_URL  = "http://proxy.${NAMESPACE}.svc.cluster.local/health"
    }

    stages {

        stage('Source') {
            steps {
                echo "Pulling code from GitHub..."
                git 'https://github.com/abdelrahmanonline4/deploy-tier-application-backend-Database-proxy-'
            }
        }

        stage('Build All') {
            container('docker') {
                steps {
                    sh """
                    docker build -t $DOCKER_REGISTRY/backend:$BUILD_TAG ./backend
                    docker build -t $DOCKER_REGISTRY/proxy:$BUILD_TAG ./proxy
                    docker build -t $DOCKER_REGISTRY/database:$BUILD_TAG ./database
                    """
                }
            }
        }

        stage('Push All') {
            container('docker') {
                steps {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                     usernameVariable: 'DOCKER_HUB_USER',
                                                     passwordVariable: 'DOCKER_HUB_PASS')]) {
                        sh """
                        echo $DOCKER_HUB_PASS | docker login -u $DOCKER_HUB_USER --password-stdin
                        docker push $DOCKER_REGISTRY/backend:$BUILD_TAG
                        docker push $DOCKER_REGISTRY/proxy:$BUILD_TAG
                        docker push $DOCKER_REGISTRY/database:$BUILD_TAG
                        """
                    }
                }
            }
        }

        stage('Deploy') {
            container('helm') {
                steps {
                    sh """
                    helm upgrade --install k8s-app ./chart \
                        --namespace $NAMESPACE \
                        --set backend.image.repository=$DOCKER_REGISTRY/backend \
                        --set backend.image.tag=$BUILD_TAG \
                        --set proxy.image.repository=$DOCKER_REGISTRY/proxy \
                        --set proxy.image.tag=$BUILD_TAG \
                        --set database.image.repository=$DOCKER_REGISTRY/database \
                        --set database.image.tag=$BUILD_TAG \
                        --wait --timeout=5m
                    """
                }
            }
        }

        stage('Smoke Test') {
            container('helm') {
                steps {
                    sh """
                    STATUS=\$(curl -s -o /dev/null -w "%{http_code}" $APP_HEALTH_URL)
                    if [ "\$STATUS" -ne 200 ]; then
                        echo "Smoke Test Failed"
                        exit 1
                    fi
                    echo "Smoke Test Passed"
                    """
                }
            }
        }

        stage('Notification') {
            steps {
                mail to: 'amr.adel512001@gmail.com',
                     subject: "SUCCESS: Build #$BUILD_TAG (${env.JOB_NAME})",
                     body: "Build successful.\nProject: ${env.JOB_NAME}\nBuild URL: ${env.BUILD_URL}"
            }
        }

    }

    post {
        failure {
            mail to: 'amr.adel512001@gmail.com',
                 subject: "FAILED: Build #$BUILD_TAG (${env.JOB_NAME})",
                 body: "Build FAILED.\nProject: ${env.JOB_NAME}\nBuild URL: ${env.BUILD_URL}\nCheck logs for details."
        }
    }
}
