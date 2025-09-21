FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    git \
    python3 \
    python3-venv \
    python3-pip \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Upgrade pip and install dependencies
RUN pip install --upgrade pip setuptools wheel
RUN pip install torch==2.0.1 torchvision==0.15.2 --index-url https://download.pytorch.org/whl/cpu
RUN pip install -r requirements.txt --prefer-binary

# Create necessary directories for Stable Diffusion
RUN mkdir -p \
    models/Stable-diffusion \
    models/VAE \
    models/Codeformer \
    models/ESRGAN \
    models/RealESRGAN \
    embeddings \
    outputs

# Expose port
EXPOSE 7860

# Start the application
CMD ["python3", "launch.py", "--listen", "--port", "7860", "--skip-torch-cuda-test", "--no-half", "--enable-insecure-extension-access"]
