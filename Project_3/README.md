This repository is an example of how to configure an Nginx server as a load balancer using containers in Docker.

In the example, five containers are created:
- server_(1-4): four web servers hosting static page with number
- nginx-lg: a server acting as a load balancer that distributes traffic between server_(1-4)

To view the results of the dockerized application, follow these steps:
- download all the files from this repository
- run: 'sudo docker-compose up' (in the directory where all the files were downloaded)
- in a browser type: 'localhost/load'
- click the "refresh" button in the browser few times

The repository includes the following files:
- 'indexes': directory with index.html pages for server_(1-4)
- 'nginx.conf': configuration of Nginx
- 'docker-compose.yml': file to build the images and run the containers in Docker (using docker-compose)


