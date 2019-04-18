pipeline {
    agent any
    environment {
        APP_NAME = "javatest"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh './mvnw -B -DskipTests clean package'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                sh './mvnw test'
            }

            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Deploy') {
            environment {
                DOCKER_HUB_ACCOUNT = credentials('ngocchien-docker-hub')
            }
            steps {
                echo "Deploying..."
                sh "docker build -t=${APP_NAME}:${BRANCH_NAME} ."
                sh "docker login -u ${DOCKER_HUB_ACCOUNT_USR} -p ${DOCKER_HUB_ACCOUNT_PSW}"
                sh "docker tag ${APP_NAME}:${BRANCH_NAME} ${DOCKER_HUB_ACCOUNT_USR}/${APP_NAME}:${BRANCH_NAME}"
                sh "docker push ${DOCKER_HUB_ACCOUNT_USR}/${APP_NAME}:${BRANCH_NAME}"
            }
        }
    }
}