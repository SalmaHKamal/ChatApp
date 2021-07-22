pipeline {
    agent any
    
    stages {
        stage('SCM') {
            git branch: 'Enhance/chatHistory', credentialsId: '796d7a10-33e2-4f00-80b9-479828042c45', url: 'https://github.com/SalmaHKamal/ChatApp.git'
        }
        stage('Build') {
            steps {
                echo 'Building'
                load 'handle.groovy'
                sh 'xcodebuild -workspace chatApp.xcworkspace'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing'
            }
        }
        stage('Release') {
            steps {
                echo 'Releasing'
            }
        }
    }
}
