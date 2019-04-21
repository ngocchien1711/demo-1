pipeline {
    agent any
    environment {
        APP_NAME = "javatest"
        BRANCH_NAME = "v4"
    }
    stages {
        stage('Develement Environment') {
            stages {
                stage('Prepare') {
                    steps {
                        echo "Populating config file"
                        sh "ansible-playbook -i /opt/demo1-playbooks/hosts/dev=prepare /opt/demo1-playbooks/populate-config.yml"
                    }
                }

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
                    steps {
                        echo "Development Deploy"
                        sh "ansible-playbook -i /opt/demo1-playbooks/hosts/dev /opt/demo1-playbooks/deploy-dev.yml"
                    }
                }
            }
        }

        stage('Staging Environment') {
            stages {
                stage('Prepare') {
                    steps {
                        echo "Populating config file"
                        sh "ansible-playbook -i /opt/demo1-playbooks/hosts/staging-prepare /opt/demo1-playbooks/populate-config.yml"
                    }
                }

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
                stage('Delivery') {
                    environment {
                        DOCKER_HUB_ACCOUNT = credentials('ngocchien-docker-hub')
                    }
                    steps {
                        echo "Promoting..."
                        sh "docker build -t=${APP_NAME}:${BRANCH_NAME} ."
                        sh "docker login -u ${DOCKER_HUB_ACCOUNT_USR} -p ${DOCKER_HUB_ACCOUNT_PSW}"
                        sh "docker tag ${APP_NAME}:${BRANCH_NAME} ${DOCKER_HUB_ACCOUNT_USR}/${APP_NAME}:${BRANCH_NAME}"
                        sh "docker push ${DOCKER_HUB_ACCOUNT_USR}/${APP_NAME}:${BRANCH_NAME}"
                    }
                }

                stage('Deploy') {
                    steps {
                        echo "Development Deploy"
                        sh "ansible-playbook -i /opt/demo1-playbooks/hosts/staging /opt/demo1-playbooks/deploy-staging.yml"
                    }
                }
            }
        }

    }
}