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


// pipeline {
//   agent any

//   stages {
//     stage('Clone') {
//       steps {
//         git 'https://github.com/your/repo.git'
//       }
//     }

//     stage('Build and Test') {
//       steps {
//         sh 'docker-compose build'
//         sh 'docker-compose run --rm web npm test'
//       }
//     }

//     stage('Build and Push to Docker Hub') {
//       steps {
//         sh 'docker build -t yourusername/myapp .'
//         sh 'docker push yourusername/myapp'
//       }
//     }

//     stage('Deploy to EC2') {
//       steps {
//         sshagent(credentials: ['your-ssh-key']) {
//           sh 'ssh ec2-user@your-ec2-instance "cd /path/to/app && docker-compose down && docker-compose pull && docker-compose up -d"'
//         }
//       }
//     }

//     stage('Check') {
//       steps {
//         sh 'curl http://your-app-url/health'
//       }
//     }

//     stage('Notifications') {
//       steps {
//         // Add Slack or email notification here if health check fails
//       }
//     }
//   }
// }
