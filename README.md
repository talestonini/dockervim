# Dockerized Neovim

Ubuntu base image containing my dev text editor settings, with basic tooling for Java and Scala.

### Building the image
    docker build -t dockervim .

### Running the container
    docker run -ti -v [directory in host]:/root/[directory in container] dockervim

where `directory in host` and `directory in container` allows for mapping projects in host machine into the
container, e.g.:

    docker run -ti -v ~/dev:/root/dev dockervim

### Restarting container
    docker ps -a
    docker start -i [container name from command above]
