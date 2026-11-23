# Docker POC

A simple proof of concept: a "Hello, World!" Node.js web server packaged in a **Dockerfile**, built into a **Docker image**, and run as a **container**.

## 1. What is Docker?

Docker is an open-source platform that packages an application together with everything it needs to run (runtime, libraries, system tools, configuration) into a standard unit called a **container**. A container runs the same way on a laptop, a test server or the cloud, which removes the classic "it works on my machine" problem.

Key concepts:

| Concept | Meaning |
|---|---|
| **Dockerfile** | A text file with the step-by-step recipe to build an image. |
| **Image** | A read-only template built from a Dockerfile. It contains the app and its dependencies. |
| **Container** | A running instance of an image. |
| **Registry** | A place to store and share images (Docker Hub, GitHub Container Registry, AWS ECR). |

## 2. How does it work?

Containers are not virtual machines. A virtual machine emulates a full computer, with its own operating system kernel. Containers share the kernel of the host and only isolate the process, using two Linux kernel features:

- **Namespaces**: give each container its own isolated view of processes, network, filesystem and users.
- **cgroups (control groups)**: limit how much CPU, memory and I/O a container can use.

An image is built from **layers**. Each instruction in the Dockerfile creates a layer, and layers are cached and shared between images, so builds and downloads are fast.

```
Dockerfile --(docker build)--> Image --(docker run)--> Container
                                  |
                                  +--(docker push)--> Registry
```

The **Docker Engine** is made of the `dockerd` daemon (does the work), a REST API, and the `docker` CLI (the client you type commands in). On Windows and macOS, Docker Desktop runs the engine inside a lightweight Linux VM.

## 3. Where can we use it?

- **Consistent development environments**: the whole team runs the same stack with one command.
- **Microservices**: each service in its own container, easy to scale and update.
- **CI/CD pipelines**: build and test in clean, reproducible containers (GitHub Actions, GitLab CI, Jenkins).
- **Cloud deployment**: AWS ECS/EC2, Google Cloud Run, Azure Container Apps and Kubernetes all run containers.
- **Testing and demos**: start a database or a service in seconds and throw it away afterwards.

## 4. Who created it and who uses it?

- **Creator**: Solomon Hykes, founder of the company **dotCloud** (later renamed Docker, Inc.). It was first presented in March 2013 at PyCon and released as open source. It is written in Go and builds on Linux Containers (LXC) and later its own library, `libcontainer`/`runc`.
- **Standardization**: in 2015 Docker donated the container format to the Open Container Initiative (OCI), under the Linux Foundation, so images work across different tools.
- **Who uses it**: it is used across the industry, including companies such as Spotify, PayPal, Netflix, Uber, Google and Amazon, and it is the base of container platforms like Kubernetes and AWS ECS.

## 5. The POC

The app is the most basic Node.js HTTP server (`src/server.js`, no dependencies). It answers "Hello, World!" to every request, and it runs inside a container.

### Project structure

```
docker-poc/
├── Dockerfile        # recipe to build the image
├── .dockerignore     # files excluded from the build
├── package.json
└── src/
    └── server.js     # the web server
```

### What is a Dockerfile?

A Dockerfile is a text file with step-by-step instructions to package our app or service.

- It is not code that runs directly. It is a set of steps that Docker follows when you run `docker build`.
- It is named `Dockerfile` (no extension).
- Each line is an instruction that creates a layer in the final artifact (the image).
- A Dockerfile does not change at runtime. It is a static file that can be versioned in Git.

### What is a Docker image?

A Docker image is the result of `docker build`.

- It is immutable and read-only. Once created, it does not change.
- Images are made of layers. Each instruction in the Dockerfile creates a layer.
- Layers are reusable and shared. If two images have a layer in common, they share that layer on disk.

### The Dockerfile explained

```dockerfile
FROM node:22-alpine        # base image: Node.js on a small Linux
WORKDIR /app               # working directory inside the container
COPY package.json ./       # copy files into the image
COPY src ./src
EXPOSE 80                  # the app listens on port 80
USER node                  # do not run as root
CMD ["node", "src/server.js"]   # command run when the container starts
```

### Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.

### Run it

1. Build the **image**:

   ```bash
   docker build -t docker-poc .
   ```

2. Run a **container** from the image (maps port 80 of the container to port 8080 of your machine):

   ```bash
   docker run -d --name docker-poc -p 8080:80 docker-poc
   ```

3. Open <http://localhost:8080>. You should see *"Hello, World! (from inside a Docker container)"*.

4. Useful commands:

   ```bash
   docker images            # list images
   docker ps                # list running containers
   docker logs docker-poc   # see the app output
   docker stop docker-poc   # stop the container
   docker rm docker-poc     # remove the container
   ```

### Use the published image (Docker Hub)

The image is published at <https://hub.docker.com/r/jeyby99/docker-poc>. You do not need the source code, only Docker:

```bash
docker run --rm -p 8080:80 jeyby99/docker-poc:1.0
```

Then open <http://localhost:8080>. (`--rm` deletes the container when it stops.)

To publish your own copy:

```bash
docker login
docker tag docker-poc <user>/docker-poc:1.0
docker push <user>/docker-poc:1.0
```

## References

- Docker documentation: <https://docs.docker.com/>
- Open Container Initiative: <https://opencontainers.org/>
