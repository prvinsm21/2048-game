pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = "privnsm21"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKERIMAGE_NAME = "prvinsm21/2048-game:${BUILD_NUMBER}"
    }

    stages {
        stage ('Git Checkout') {
            steps {
                sh 'echo PASSED'
            }
        }

        stage ('Unit testing') {
            steps {
                sh 'mvn test'
            }
        }

        stage ('Integration Testing') {
            steps {
                sh 'mvn clean verify -DskipUnitTests=true'
            }
        }

        stage ('Build Stage') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage ('Static Code analysis') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                    sh 'mvn clean package sonar:sonar'}
                }
            }
        }

        stage ('Quality Gate check') {
            steps {
                script {
                waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                }
            }
        }
    }
}