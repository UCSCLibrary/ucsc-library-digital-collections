pipeline {
  agent {
    node {
      label: 'master'
      customWorkspace: 'ucsc_docker'
    }
  }
  environment {       
//    EXAMPLE_ENVIRONMENT_VARIABLE = credentials('example-var-name-defined-in-jenkins-credentials-system')
  }

  stages {
    stage('Build') {        
      agent {
        node {
          label: 'master'
          reuseNode: true
        }
      }
      steps {
        git branch: 'unit-testing', url: "https://github.com/UCSCLibrary/digital-collections-dev-docker.git"
        sh 'docker-compose build; docker-compose up -d'
      }
    }
    stage('Test') {
      agent {
        node {
          label: 'master'
          reuseNode: true
        }
      }
      steps {
          sh 'docker exec hycruz bundle exec rspec spec/unit; docker exec hycruz bundle exec rspec spec/integration'
      }
    }
    stage('Deploy') {
      agent any
      steps {
        git branch: "${BRANCH_NAME}", url: "https://github.com/UCSCLibrary/digital-collections-ucsc-library-digital-collections"
        sh 'cap ${BRANCH_NAME/master/production} deploy'
      }
    }
    stage('AcceptanceTest') {
      agent any
      steps {
        sh 'bundle install; bundle exec rspec spec/acceptance'
      }
      post {
        unsuccessful {
          sh 'cap ${BRANCH_NAME/master/production} deploy:rollback'
        }
      }
    }
  }
  /*
  post {
    success {
      mail to: ethenry@ucsc.edu, subject: 'Jenkins pipeline success!'
    }
    failure {
      mail to: ethenry@ucsc.edu, subject: 'Jenkins pipeline failure'
    }
  }
  */
}
