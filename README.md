# docker_images

Docker image(s) for softwareQ tools

## Installation

First install [Docker](https://www.docker.com/get-started), then clone this
repository and
`cd` into it by executing

```shell
git clone https://github.com/softwareqinc/docker_images && cd docker_images
```

Next build the image by executing

```shell
docker build -t softwareq-tools .
```

--- 

Run the Jupyter server in a container by executing

```shell
docker run -p8890:8890 -it --workdir=/home/sq/notebooks softwareq-tools sh -c "jupyter notebook --port=8890 --no-browser --ip=0.0.0.0"
```

The output of the `docker run` command should be similar to

> To access the server, open this file in a browser:
>
>    file:///home/sq/.local/share/jupyter/runtime/jpserver-7-open.html
> Or copy and paste one of these URLs:
>
>    http://c19114f6e736:8890/tree?token=2412fa2d0a9a4b1ad79528715ed41db3c251f393de7d213d
>
>    http://127.0.0.1:8890/tree?token=2412fa2d0a9a4b1ad79528715ed41db3c251f393de7d213d

To connect to the Jupyter environment, launch a browser at one of the hyperlinks
produced by `docker run`, which should be similar to the ones above (the token
value will of course be different in your case).

See
the [notebooks](https://github.com/softwareQinc/docker_images/tree/main/notebooks)
directory for Jupyter Notebook examples.

---

In case you want to use the Docker container as a development environment, mount
your directory (in this case the current directory) in a Docker container with

```shell
docker run --rm -it --workdir=/home/sq/hostdir -v ${PWD}:/home/sq/hostdir softwareq-tools /bin/bash 
```
