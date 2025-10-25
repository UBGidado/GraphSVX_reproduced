# ===== Base image =====
FROM python:3.9-slim-bookworm

WORKDIR /app

# ===== Install build tools =====
RUN apt-get update && \
    apt-get install -y git wget curl build-essential && \
    rm -rf /var/lib/apt/lists/*

# ===== Upgrade pip =====
RUN pip install --upgrade pip

# ===== Install PyTorch (CPU only) =====
RUN pip install torch==1.12.1+cpu torchvision==0.13.1+cpu torchaudio==0.12.1 \
    -f https://download.pytorch.org/whl/cpu/torch_stable.html

# ===== Scientific and graph dependencies =====
RUN pip install numpy pandas scikit-learn networkx matplotlib tqdm seaborn

# ===== PyTorch Geometric (CPU wheels for torch==1.12.1) =====
RUN pip install torch-scatter==2.0.9 torch-sparse==0.6.15 torch-cluster==1.6.0 \
    -f https://data.pyg.org/whl/torch-1.12.1+cpu.html
RUN pip install torch-geometric==2.2.0

# ===== Optional: your project dependencies =====
COPY requirements.txt .
RUN pip install -r requirements.txt || true

# ===== Copy your source code =====
COPY . .

CMD ["/bin/bash"]
