This repository is an example of how to dockerize simple application and Nginx server.

To view the results of the dockerized application, follow these steps:
- download all the files from this repository
- run: 'sudo docker-compose up' (in the directory where all the files were downloaded)
- in a browser type:
  * localhost/greet (to see the results of the activated Go application)
  * localhost/health (to see the text: "I am healthy" (with an HTTP status code of 200))
  * localhost:9001 (to be redirected to subpage with the text about health
  
The repository includes the following files:
- 'main.go' + 'go.mod': code for a simple Go app that serves multiple HTTP endpoints (not mine)
- 'nginx.conf': configuration of Nginx
- 'app.Dockerfile': dockerfile to build the image for the app (from scratch)
- 'docker-compose.yml': file to build the images and run the containers in Docker (using docker-compose)


