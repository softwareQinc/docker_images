# docker_images

Docker image for softwareQ tools

## Installation

Install [Docker](https://www.docker.com/get-started), then build the image by
executing

```shell
git clone https://github.com/softwareqinc/docker_images && cd docker_images
docker build -t softwareq-tools .
```

--- 

Run the Jupyter server in a container by executing

```shell
docker run -p8888:8888 -it --workdir=/home/sq/notebooks softwareq-tools sh -c "jupyter notebook --port=8888 --no-browser --ip=0.0.0.0"
```

The output of the `docker run` command should be similar to

> To access the notebook, open this file in a browser:
>
> file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
>
> Or copy and paste one of these URLs:
>
> http://a16168cc7fdd:8888/?token=d9651cb8726cdc87b6093e43d7411d9a234cd43377a93019
>
> or
>
> **http://127.0.0.1:8888/?token=d9651cb8726cdc87b6093e43d7411d9a234cd43377a93019**

To connect to the Jupyter environment, launch a browser at the hyperlink
produced by `docker run`,
which should be similar to the one marked in **bold** above
(the token value will of course be different in your case).

See
the [notebooks](https://github.com/softwareQinc/docker_images/tree/main/notebooks)
directory for Jupyter Notebook examples.

---

In case you want to use the Docker container as a development environment, mount
your directory (in this case the current directory) in a Docker container with

```shell
docker run --rm -it --workdir=/home/sq/hostdir -v ${PWD}:/home/sq/hostdir softwareq-tools /bin/bash 
```
