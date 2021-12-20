// This a declarative pipeline for Jenkins
// The syntax is based on Groovy, and is documented here:
//    https://www.jenkins.io/doc/book/pipeline/syntax
pipeline {    // Every declarative pipeline starts with this line
  agent any   // This is a standard way to tell Jenkins to use all available agents


  environment {    // Here we set environment variables for all stages  
    /*
        The CI and COVERALLS_REPO_TOKEN variables configure how to
         upload test coverage data to the cloud service "coveralls".
       The 'credentials' command pulls encrypted credentials from Jenkins
         (which are defined using the Jenkins browser interface)
    */
    COVERALLS_REPO_TOKEN = credentials('coveralls-repo-token')
    CI = "true"
  }  // End the environment block

  stages {       // These stages each run consequtively  
    stage('Build') { // The build stage builds and loads the dockerized test stack
      steps {
        // dir("docker_test_env") {        // All commands in this block are executed in the directory 'docker_test_env'

        // //   /*
        // //      The git command in Jenkins clones an external git repo.
        // //      Credentials for github are stored in Jenkins  and managed through the browser interface.
        // //      This clones the repository for the dockerized development environment.
        // //   */
        // //   //git changelog: false, credentialsId: 'github_user', poll: false,  branch: 'tests', url: "https://github.com/UCSCLibrary/digital_collections_dev_docker.git"
          
        // //   /*
        // //      The 'sh' Jenkins command runs a command in a bash shell.
        // //      Here we build and load the dockerized test environment. It will load from a cache
        // //      if most of the build steps are identical to before, so this usually does not take too long.
        // //      Jenkins sets the GIT_BRANCH environment variable to something like origin/master,
        // //        and we define BRANCH to be the same without the "origin/" par. BRANCH is
        // //        expected in our docker-compose file.
        // //   */
        //   sh 'PATH="/var/lib/jenkins/workspace/DAMS_pipeline_staging/docker_test_env/:$PATH"; BRANCH=${GIT_BRANCH/origin\\//} docker-compose build; BRANCH=${GIT_BRANCH/origin\\//} docker-compose up -d'
        // }
        
        sh 'rm -rf tmp/pids; mkdir -p tmp/pids; chmod -R 777 tmp/pids; cd stack_car; BRANCH=${GIT_BRANCH/origin\\//} docker-compose build; BRANCH=${GIT_BRANCH/origin\\//} docker-compose up -d'
        
        
      }
    }

    stage('Test') { // The Test stage runs the main testing suite in the dockerized testing environment. 
      steps {
        //dir("docker_test_env") {   // All commands in this block are executed in the directory 'docker_test_env'
          /*
          The 'sh' Jenkins command runs a command in a bash shell.
          'docker exec' runs a command inside a running Docker container
          The docker container for our webapp is named 'hycruz'.
          The script 'run-tests-when-ready.sh' waits until the test environment is online
            and then runs the rspec test suite
          */
          sh 'mkdir -p coverage; chmod -R 777 coverage; cd stack_car; chmod +x run-tests-when-ready.sh; chmod +x wait-for-services.sh; BRANCH=${GIT_BRANCH/origin\\//} docker exec -e COVERALLS_REPO_TOKEN=$COVERALLS_REPO_TOKEN hycruz stack_car/run-tests-when-ready.sh'
        //}
        
      }
    }
    
    stage('Deploy') { // The deploy stage loads the new code on our application server using Capistrano
      steps {
        /*
          The 'sh' Jenkins command runs a command in a bash shell.
          The 'cap' command deploys application code to our web servers
          We first include the capistrano binary path in our execution path
          And set the ruby environment for cap based on the git branch
            (replacing 'master' with 'production').
        */
        sh 'PATH="/var/lib/jenkins/.rvm/rubies/default/bin/:$PATH"; BRANCH_NAME=${GIT_BRANCH/origin\\/}; cap ${BRANCH_NAME/master/production} deploy'
      }
    }
    
    stage('SmokeTest') { // The smoke test stage runs simple tests on the live deployed server
      steps {
        // This is almost exactly like the test stage,
        // except the script tells rspec only to run the smoke tests
        sh 'chmod +x run-smoke-tests-when-ready.sh; BRANCH=${GIT_BRANCH/origin\\//} docker exec hycruz stack_car/run-smoke-tests-when-ready.sh'
      }
    }
    
  }    // End the stages block
  
  post {                             // This block contains code to run after the pipeline finishes.
    always {                         // Code in this block runs whether it succeeds or fails.
      dir("docker_test_env") {       // All commands in this block are executed in the directory 'docker_test_env'.
        sh 'docker-compose down'     // close down the test environment,
      }
    //   cleanWs()
    //   dir("${env.WORKSPACE}@tmp") {
    //   deleteDir()
    // }
    }
  }
  
}
