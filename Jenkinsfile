pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                git credentialsId: '796d7a10-33e2-4f00-80b9-479828042c45', url: 'https://github.com/SalmaHKamal/ChatApp.git', branch: 'develop/setup-jenkins'
	        echo "change id => ${env.BUILD_ID}"
                echo "branch name => ${BRANCH_NAME}"
		echo "job name =>  ${env.JOB_NAME}"
		echo "ENV => ${env.getEnvironment()}"
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

