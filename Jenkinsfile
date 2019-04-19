pipeline {
  agent {
    label "logstash"
  }
  environment {
    ORG = 'liatrio'
    APP_NAME = 'logstash-bitbucket'
    DOCKER_REGISTRY = 'docker.artifactory.liatr.io'
    SLACK_CHANNEL="flywheel"
  }
  stages {
    stage('Build image') {
      steps {
        container('logstash') {
          sh "docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:${GIT_COMMIT[0..10]} -t ${DOCKER_REGISTRY}/${APP_NAME}:latest ."
        }
      }
    }
    stage('Publish image') {
      when {
        branch 'master'
      }
      steps {
        container('logstash') {
          script {
          docker.withRegistry("https://${DOCKER_REGISTRY}", 'artifactory-takumin') {
            sh """
              docker push ${DOCKER_REGISTRY}/${APP_NAME}:${GIT_COMMIT[0..10]}
              docker push ${DOCKER_REGISTRY}/${APP_NAME}:latest
              """
          }
          }
        }
      }
    }
  }
  post {
    failure {
      slackSend channel: "#${env.SLACK_CHANNEL}",  color: "danger", message: "Build failed: ${env.JOB_NAME} on build #${env.BUILD_NUMBER} (<${env.BUILD_URL}|go there>)"
    }
    fixed {
      slackSend channel: "#${env.SLACK_CHANNEL}", color: "good",  message: "Build recovered: ${env.JOB_NAME} on #${env.BUILD_NUMBER}"
    }
    success {
      slackSend channel: "#${env.SLACK_CHANNEL}", color: "good",  message: "Build was successfully deployed: ${env.JOB_NAME} on #${env.BUILD_NUMBER} (<${env.BUILD_URL}|go there>)"
    }
  }
}
