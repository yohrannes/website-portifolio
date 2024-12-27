
Build website docker image

docker build -f ./build-app/Dockerfile --network host -t yohrannes/website-portifolio .

Get latest docker pipeline logs

docker logs -f $(docker ps -lq)

Obs: To use this comand you will need a gl-runner running in docker mode...
