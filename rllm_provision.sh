#!/bin/bash

# Move to workspace for persistent storage
cd /workspace/
set -eo pipefail  # Exit on error

# Activate the default virtual environment (used by Vast images)
. /venv/main/bin/activate

# Install curl, git, wget, and conda if not present
apt update && apt install -y curl git wget

# Clone your repository into /root/rllm
git clone --recurse-submodules https://github.com/August-murr/rllm.git /root/rllm

# Install uv (via the provided script)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Set up Miniconda (if not already installed)
if ! command -v conda &> /dev/null; then
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
  bash miniconda.sh -b -p /opt/conda
  export PATH="/opt/conda/bin:$PATH"
fi

# Create Conda environment 'rllm'
conda create -n rllm python=3.10 -y

# Activate conda env
source /opt/conda/etc/profile.d/conda.sh
conda activate rllm

# Install editable packages
pip install -e /root/rllm/verl
pip install -e /root/rllm

echo "Provisioning complete."
