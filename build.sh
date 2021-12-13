rm -rf tmp/pids
mkdir -p tmp/pids
chmod -R 777 tmp/pids
cd stack_car
BRANCH=${GIT_BRANCH/origin\\//} docker-compose build
BRANCH=${GIT_BRANCH/origin\\//} docker-compose up
