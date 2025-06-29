FROM ubuntu:latest
ENV TZ="America/Toronto"
RUN apt-get update && \
    apt-get -y update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Toronto /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y build-essential python3.10 python3-pip python3-dev \
    python3-venv libeigen3-dev cmake sudo git vim libgmp-dev

# Enable a normal user with sudo access
RUN useradd -m -c "softwareQ" sq
RUN echo '%sq ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create a Python 3 virtual environment
USER sq
WORKDIR /home/sq
RUN python3 -m venv venv

# Install Jupyter and other dependencies, followed by pyqpp and pystaq
COPY requirements.txt ./
RUN . venv/bin/activate && pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir git+https://github.com/softwareqinc/qpp && \
    pip install --no-cache-dir git+https://github.com/softwareqinc/staq

# Clone and install Quantum++ and qpp_qasm
RUN git clone --depth 1 --branch main https://github.com/softwareqinc/qpp
WORKDIR /home/sq/qpp
RUN cmake -B build && \
    cmake --build build --target qpp_qasm && \
    sudo cmake --build build --target install && \
    sudo cp build/qpp_qasm /usr/local/bin

# Clone and install staq
WORKDIR /home/sq
RUN git clone --depth 1 --branch main https://github.com/softwareqinc/staq
WORKDIR /home/sq/staq
RUN cmake -B build -DINSTALL_SOURCES=ON && \
    cmake --build build --target all --parallel 4 && \
    sudo cmake --build build --target install
WORKDIR /home/sq

# Create a notebook directory for Jupyter
RUN mkdir notebooks
COPY notebooks/* notebooks
