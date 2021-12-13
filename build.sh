rm -rf tmp/pids
mkdir -p tmp/pids
chmod -R 777 tmp/pids
cd stack_car
docker-compose build
docker-compose up
