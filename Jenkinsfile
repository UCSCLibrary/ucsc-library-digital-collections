pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        dir("docker_test_env") {
          git changelog: false, credentialsId: 'github_user', poll: false,  branch: 'unit-test', url: "https://github.com/UCSCLibrary/digital_collections_dev_docker.git"
          sh 'echo ${GIT_BRANCH/origin\\//}'
          sh 'BRANCH=${GIT_BRANCH/origin\\//} docker-compose build; docker-compose up -d'
        }
      }
    }
    stage('Test') {
      steps {
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
/*
    stage('AcceptanceTest') {
      when {
          branch 'docker-test'
      }
      environment {
        ADMIN_USERNAME = credentials('app-admin-username')
        ADMIN_PASSWORD = credentials('app-admin-password')
      }
      steps {
        sh 'PATH="/var/lib/jenkins/.rvm/rubies/default/bin/:$PATH" bundle install; PATH="/var/lib/jenkins/.rvm/rubies/default/bin/:$PATH" bundle exec rspec spec/acceptance'
      }
      post {
        unsuccessful {
          sh 'PATH="/var/lib/jenkins/.rvm/rubies/default/bin/:$PATH"; BRANCH_NAME=${GIT_BRANCH/origin\\/}; cap ${BRANCH_NAME/master/production} deploy:rollback'
        }
      }
    }
    
    */
  }
  post {
    always {
      dir("docker_test_env") {
        sh 'docker-compose down'
      }
    }
  }
}
