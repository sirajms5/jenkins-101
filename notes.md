```
docker build -t myjenkins-blueocean:latest .
```

Breaking it Down:
    docker build → This command tells Docker to build a new image.
    -t myjenkins-blueocean:2.414.2 → The -t flag assigns a tag (name) to the image:
    myjenkins-blueocean → The name of the Docker image.
    2.414.2 → The version/tag of the image (could be based on the Jenkins Blue Ocean plugin version).
    . → The dot (.) specifies the build context, meaning Docker will look for a Dockerfile in the current directory to build the image.


```
docker network create jenkins
```
    This command creates a Docker network named jenkins. Useful for container communication when running Jenkins with other services
    Creates an isolated network for Jenkins and other containers.
    Allows Jenkins to communicate with agents, databases, or Docker-in-Docker.
    Essential for containerized CI/CD workflows.

```
docker network ls
```
    to list current networks


```
docker run --name jenkins-blueocean --restart=on-failure --detach `
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 `
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 `
  --volume jenkins-data:/var/jenkins_home `
  --volume jenkins-docker-certs:/certs/client:ro `
  --publish 8080:8080 --publish 50000:50000 myjenkins-blueocean:2.414.2
```

| Command                                    | Explanation |
|--------------------------------------------|-------------|
| `docker run`                               | Runs a new container. |
| `--name jenkins-blueocean`                 | Names the container `jenkins-blueocean` for easier reference. |
| `--restart=on-failure`                     | Ensures the container **restarts only if it fails** (not on normal shutdown). |
| `--detach`                                 | Runs the container in the **background (detached mode)**. Without this option, the container would run in the terminal, blocking further commands |
| `--network jenkins`                        | Connects the container to the **jenkins** network, allowing it to communicate with other containers. |
| `--env DOCKER_HOST=tcp://docker:2376`      | Configures **Docker-in-Docker (DinD)** by setting the Docker daemon’s address. |
| `--env DOCKER_CERT_PATH=/certs/client`     | Specifies the path where **Docker TLS certificates** are stored for secure communication. |
| `--env DOCKER_TLS_VERIFY=1`                | Enables **TLS verification** to securely connect to the Docker daemon. |
| `--volume jenkins-data:/var/jenkins_home`  | Creates a **persistent volume (`jenkins-data`)** to store Jenkins home directory data (jobs, configurations, plugins). Without this, all data would be lost when the container is restarted or deleted. |
| `--volume jenkins-docker-certs:/certs/client:ro` | Mounts **Docker certificates** in read-only mode (`ro`) to secure Docker communication. |
| `--publish 8080:8080`                      | Exposes Jenkins web UI on **port 8080 (host)**. |
| `--publish 50000:50000`                    | Exposes the port for **Jenkins agents to connect**. |
| `myjenkins-blueocean:2.414.2`              | Runs the **custom Jenkins Blue Ocean image** built earlier (`myjenkins-blueocean:2.414.2`). |

```
docker ps
```
Shows currently running containers

Then go to localhost:8080 it will ask for a password
password found at /var/jenkins_home/secrets/initialAdminPassword when we installed jenkins
or command 
```
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```
move through the steps to end up on jenkins GUI


Jenkins container bash shell (linux)
```
docker exec -it jenkins-blueocean bash
```

go to the job we created
```
cd /var/jenkins_home/workspace
cd mu_first_job
ls -ltra
```

