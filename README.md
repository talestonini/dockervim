# Dockerized NeoVim

Ubuntu base image containing my dev text editor settings, with basic tooling for Java and Scala.

### Building the image
    docker build -t dockervim .

### Running the container
    docker run -ti -v ~/dev:/root/dev dockervim

### Restarting container
    docker ps -a
    docker start -i <container name from command above>
