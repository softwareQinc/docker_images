# docker_images

Docker images for our tools

# Installation

```bash
git clone https://github.com/softwareqinc/docker_images
cd docker_images
docker build -t softwareq .
docker run -p8888:8888 softwareq
```

The output should be similar to 

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

Finally, launch a browser at the hyperlink marked in **bold** above (the token sequence will 
be different in your case) to connect to the Jupyter environment.


## [Example](https://github.com/softwareQinc/docker_images/blob/main/example.ipnyb)


