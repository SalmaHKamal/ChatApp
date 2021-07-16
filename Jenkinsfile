pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                echo 'Building'
                load 'handle.groovy'
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
