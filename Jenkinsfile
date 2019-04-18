pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'mvn -B -DskipTests clean package'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'mvn test'
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
                echo 'Deploying...'
                sh 'docker build -t=javatest:v2 .'
                sh "docker login -u ${DOCKER_HUB_ACCOUNT_USR} -p ${DOCKER_HUB_ACCOUNT_PSW}"
                sh 'docker tag javatest:v2 ngocchien/javatest:v2'
                sh 'docker push ngocchien/javatest:v2'
            }
        }
    }
}