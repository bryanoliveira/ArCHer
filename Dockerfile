# docker build --build-arg WANDB_KEY=hash -t aluno_bryan-archer .
# docker run -it --rm -v /home/bryan/Documents/ceia/cemig/experiments/ArCHer/dataset:/app/dataset -v /home/bryan/Documents/ceia/cemig/experiments/ArCHer/outputs:/app/outputs --name aluno_bryan-archer_1 aluno_bryan-archer archer_offline_20q
# docker run -it --rm --gpus '"device=0"' -v /raid/bryan/rlhf/ArCHer/dataset:/app/dataset -v /raid/bryan/rlhf/ArCHer/outputs:/app/outputs --name aluno_bryan-archer_1 aluno_bryan-archer

FROM nvidia/cuda:12.1.1-runtime-ubuntu20.04

# Install Python
RUN apt-get update && \
    apt-get install -y python3.10-dev && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

ARG WANDB_KEY
ENV WANDB_API_KEY=$WANDB_KEY

# Set the entrypoint command
ENTRYPOINT ["python", "-m", "scripts.run", "--config-name"]

# Set the default command line argument
CMD ["archer_20q"]
