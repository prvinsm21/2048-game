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

        stage ('Upload jar files to nexus') {
            steps {
                script {
                    def readPomVersion = readMavenPom file: 'pom.xml'
                 //   def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "cicd-proj2-snapshot" : "cicd-proj2-release"
                    nexusArtifactUploader artifacts: [
                        [
                            artifactId: '2048-game', classifier: '', file: 'target/2048-game-site.jar', type: 'jar'
                        ]
                        ], 
                        credentialsId: 'nexus-auth', 
                        groupId: 'com.macko', 
                        nexusUrl: '192.168.29.38:8081/', 
                        nexusVersion: 'nexus3', 
                        protocol: 'http', 
                        repository: '2048-game', 
                        version: "${readPomVersion.version}"
                }
            }
        }

        stage ('Build Docker image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKERIMAGE_NAME} .'
                }
            }
        }

        stage ('Trivy Image Scanning') {
            steps {
                sh 'trivy image ${DOCKERIMAGE_NAME} > $WORKSPACE/trivy-image-scan-$BUILD_NUMBER.txt'
            }
        }
    }
}