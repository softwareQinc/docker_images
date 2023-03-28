FROM ubuntu:latest
ENV TZ="America/Toronto"
RUN apt-get update && \
    apt-get -y update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Toronto /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install dependecies
RUN apt-get install -y \ 
    build-essential \
    python3.6 \
    python3-pip \
    python3-dev \
    libeigen3-dev \
    cmake \
    vim \
    git

RUN pip3 -q install pip --upgrade

# Create the main working directory
RUN mkdir /softwareq
WORKDIR /softwareq
COPY . .

# Clone staq and Quantum++ C++ repositories (shallow clone)
RUN mkdir repos
WORKDIR /softwareq/repos
RUN git clone --depth=1 https://github.com/softwareqinc/qpp
RUN git clone --depth=1 https://github.com/softwareqinc/staq

# Install the Quantum++ and staq Ppython wrappers
RUN pip3 install git+https://github.com/softwareqinc/qpp
RUN pip3 install git+https://github.com/softwareqinc/staq

# Install the Jupyter server on port 8888
WORKDIR /softwareq/notebooks
RUN pip3 install jupyter matplotlib numpy
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"] 
