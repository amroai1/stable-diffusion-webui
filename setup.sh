#!/bin/bash
set -e

# Install system dependencies
apt-get update
apt-get install -y wget git python3 python3-venv python3-pip libgl1 libglib2.0-0

# Create virtual environment
python3 -m venv /venv
source /venv/bin/activate

# Upgrade pip first
pip install --upgrade pip setuptools wheel

# Install torch first with specific versions
pip install torch==2.0.1 torchvision==0.15.2 --index-url https://download.pytorch.org/whl/cpu

# Install requirements with pre-built wheels
pip install -r requirements.txt --prefer-binary

# Test installation
python -c "import torch; print(f'PyTorch version: {torch.__version__}')"
python -c "import gradio; print(f'Gradio version: {gradio.__version__}')"
