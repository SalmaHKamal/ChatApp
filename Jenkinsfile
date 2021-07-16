pipeline {
    agent any
    
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
                def externalMethod = load("handle.groovy")
            }
        }
        stage('Test') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Release') {
            steps {
                echo 'Hello World'
            }
        }
    }
}

