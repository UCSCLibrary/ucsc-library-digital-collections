pipeline {
  agent any
  
  environment {
    COVERALLS_REPO_TOKEN = credentials('coverall')
    CI = "true"
  }
  stages {
    stage('Build') {
      steps {
        dir("docker_test_env") {
          git changelog: false, credentialsId: 'github_user', poll: false,  branch: 'unit-test', url: "https://github.com/UCSCLibrary/digital_collections_dev_docker.git"
          sh 'BRANCH=${GIT_BRANCH/origin\\//} docker-compose build; BRANCH=${GIT_BRANCH/origin\\//} docker-compose up -d'
        }
      }
    }
    stage('Test') {
      steps {
        echo "CI is ${CI}"
        echo "coveralls repo token is ${COVERALLS_REPO_TOKEN}"
        dir("docker_test_env") {
          sh 'BRANCH=${GIT_BRANCH/origin\\//} docker exec hycruz /srv/run-unit-tests-when-ready.sh'
        }
      }
    }
    stage('Deploy') {
      steps {
        sh 'PATH="/var/lib/jenkins/.rvm/rubies/default/bin/:$PATH"; BRANCH_NAME=${GIT_BRANCH/origin\\/}; cap ${BRANCH_NAME/master/production} deploy'
      }
    }
  }
  post {
    always {
      dir("docker_test_env") {
        sh 'docker-compose down'
      }
    }
  }
}
