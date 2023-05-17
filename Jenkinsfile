// Documentation: https://www.jenkins.io/doc/book/pipeline/syntax
pipeline {
  agent any

  environment {
    /*
    The CI and COVERALLS_REPO_TOKEN variables configure how to
    upload test coverage data to the cloud service "coveralls".

    The 'credentials' command pulls encrypted credentials from Jenkins
    (which are defined using the Jenkins browser interface)
    */
    COVERALLS_REPO_TOKEN = credentials('coveralls-repo-token')
    CI = "true"
  }

  stages {
    // The build stage builds and loads the dockerized test stack
    stage('Build') {
      steps {
        /*
        The 'sh' Jenkins command runs a command in a bash shell.
        Jenkins owns the app folder, we need looser perms for the app to run properly
        */
        sh '''
          rm -rf tmp/pids
          mkdir -p tmp/pids
          chmod -R 777 tmp/pids
          mkdir -p coverage
          chmod 777 coverage
          chmod 666 Gemfile.lock
          chmod 777 log
          chmod 666 log/test.log
          chmod 666 log/capistrano.log
          chmod 777 db/schema.rb
          mkdir -p tmp/sockets
          chmod 777 tmp/sockets
          '''
        dir('stack_car') {
          sh 'docker-compose build;docker-compose up -d'
        }
      }
    }

    // The Test stage runs the main testing suite in the dockerized testing environment. 
    stage('Test') {
      steps {
          /*
          'docker exec' runs a command inside a running Docker container
          The docker container for our webapp is named 'hycruz'.
          The script 'run-tests-when-ready.sh' waits until the test environment is online
          and then runs the rspec test suite
          */
          sh 'docker exec -e COVERALLS_REPO_TOKEN=$COVERALLS_REPO_TOKEN hycruz stack_car/run-tests-when-ready.sh'
      }
    }
    
    // The deploy stage loads the new code on our application server using Capistrano
    stage('Deploy') {
      steps {
        /*
          The 'cap' command deploys application code to our web servers
          We first include the capistrano binary path in our execution path
          And set the ruby environment for cap based on the git branch
          (replacing 'master' with 'production').
          Jenkins sets the GIT_BRANCH environment variable to something like origin/master,
          and we define BRANCH to be the same without the "origin/" part.
        */
        sh '''
          PATH="/var/lib/jenkins/.rvm/rubies/default/bin/:$PATH"
          BRANCH_NAME=${GIT_BRANCH/origin\\/}
          cap ${BRANCH_NAME/master/production} deploy
          '''
      }
    }
    
    // The smoke test stage runs simple tests on the live deployed server
    stage('SmokeTest') {
      steps {
        // This is almost exactly like the test stage,
        // except the script tells rspec only to run the smoke tests
        sh 'docker exec hycruz stack_car/run-smoke-tests-when-ready.sh'
      }
    }
    
  } // End the stages block
  
  // This block contains code to run after the pipeline finishes.
  post {
    always {
        sh 'cd stack_car; docker-compose down'
    }
  }

}
