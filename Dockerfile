# docker build --build-arg WANDB_KEY=hash -t aluno_bryan-archer .
# docker run -it --rm -v /home/bryan/Documents/ceia/cemig/experiments/ArCHer/dataset:/app/dataset -v /home/bryan/Documents/ceia/cemig/experiments/ArCHer/outputs:/app/outputs --name aluno_bryan-archer_1 aluno_bryan-archer archer_offline_20q
# docker run -it --rm --gpus '"device=0"' -v /raid/bryan/rlhf/ArCHer/dataset:/app/dataset -v /raid/bryan/rlhf/ArCHer/outputs:/app/outputs --name aluno_bryan-archer_1 aluno_bryan-archer

FROM nvidia/cuda:12.1.1-runtime-ubuntu20.04

RUN apt update && \
    apt install -y software-properties-common

RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y wget build-essential python3.10 python3.10-dev python3.10-distutils
    
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.10 get-pip.py

RUN rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install the dependencies
RUN python3.10 -m pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

ARG WANDB_KEY
ENV WANDB_API_KEY=$WANDB_KEY

# Set the entrypoint command
ENTRYPOINT ["python3.10", "-m", "scripts.run", "--config-name"]

# Set the default command line argument
CMD ["offline_archer_20q"]
