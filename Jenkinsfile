pipeline {
    agent any
    stages{
        stage('Clone'){
            steps{
                git url: 'https://github.com/yonig15/TODO-APP.git', branch: 'master' 
            }
        }
        stage('Build and Test') {
            steps {
                sh 'docker-compose build'
                sh 'docker-compose run --rm web npm test'
            }
        }
        // stage('Run Security Scans') {
        //     steps {
        //         script {
        //             docker.withRegistry('https://registry.hub.docker.com/', 'docker-hub-credentials') {
        //                 withCredentials([usernamePassword(credentialsId: '<YOUR_AQUA_CREDENTIAL_ID>', usernameVariable: 'AQUA_USER', passwordVariable: 'AQUA_PASS')]) {
        //                     sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e AQUA_USER=${AQUA_USER} -e AQUA_PASS=${AQUA_PASS} aquasec/cli:6.2 scan --local --registry registry.hub.docker.com --repo ${DOCKER_IMAGE}"
        //                 }
        //             }
        //         }
        //     }
        // }
        stage('Build and Push to Docker Hub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerCredntials', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        	    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                sh 'docker build -t yonig15/yoniapp .'
                sh 'docker push yonig15/yoniapp'
                }
            }
        }
        stage('Deploy to EC2') {
        steps {
            sshagent(credentials: ['finel_exzem']) {
            sh 'ssh ec2-16-16-144-83.eu-north-1.compute.amazonaws.com "cd /path/to/app && docker-compose down && docker-compose pull && docker-compose up -d"'
            }
        }
        }
        stage('Check') {
            steps {
            sh 'curl http://localhost:8000/health'
            }
        }
    }
    post {
        success {
            slackSend(color: 'good', message: "Build succeeded!\n\n*Commit:* ${env.GIT_COMMIT}\n*Branch:* ${env.BRANCH_NAME}\n*Build URL:* ${env.BUILD_URL}")
        }
        failure {
            slackSend(color: 'danger', message: "Build failed!\n\n*Commit:* ${env.GIT_COMMIT}\n*Branch:* ${env.BRANCH_NAME}\n*Build URL:* ${env.BUILD_URL}")
        }
    }
}