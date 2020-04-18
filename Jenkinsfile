pipeline {
  agent any
  stages {
    stage('Build') {        
      steps {
        dir("docker_test_env") {
          git changelog: false, credentialsId: 'github_user', poll: false,  branch: 'unit-test', url: "https://github.com/UCSCLibrary/digital_collections_dev_docker.git"
          sh 'BRANCH=${GIT_BRANCH/origin\\/} docker-compose build; docker-compose up -d'
        }
      }
    }
    stage('Test') {
      steps {
        dir("docker_test_env") {
          sh 'docker exec hycruz /srv/run-unit-tests-when-ready.sh'
        }
      }
    }
    stage('Deploy') {
      steps {
        git branch: "${GIT_BRANCH/origin\\/}", url: "https://github.com/UCSCLibrary/digital-collections-ucsc-library-digital-collections"
        sh 'BRANCH_NAME=${GIT_BRANCH/origin\\/}; cap ${BRANCH_NAME/master/production} deploy'
      }
    }
    stage('AcceptanceTest') {
      steps {
        sh 'bundle install; bundle exec rspec spec/acceptance'
      }
      post {
        unsuccessful {
          sh 'BRANCH_NAME=${GIT_BRANCH/origin\\/}; cap ${BRANCH_NAME/master/production} deploy:rollback'
        }
      }
    }
  }
}