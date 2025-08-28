FROM satijalab/seurat:latest

LABEL maintainer="luca.alessandri@example.org"

# =================== PYTHON + JUPYTER ===================
RUN apt-get update && apt-get install -y \
    python3-pip python3-dev curl libzmq3-dev \
    && pip3 install --no-cache-dir jupyterlab notebook \
    && Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org'); IRkernel::installspec(user = FALSE)"

# Set password for Jupyter (biohack123)
RUN mkdir -p /root/.jupyter && \
    python3 -c "from jupyter_server.auth import passwd; print(\"c.ServerApp.password = u'\" + passwd('biohack123') + \"'\")" \
    > /root/.jupyter/jupyter_lab_config.py

# =================== WORKDIR ===================
WORKDIR /home/project

# =================== PYTHON PACKAGES ===================
RUN pip install scanpy
RUN pip uninstall -y numba llvmlite && \
    pip install numba==0.56.4 llvmlite==0.39.1 && \
    pip install igraph leidenalg louvain

# =================== R PACKAGES ===================
RUN apt-get update && apt-get install -y \
    libfontconfig1-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# Bioconductor core
RUN R -e "if (!requireNamespace('BiocManager', quietly=TRUE)) install.packages('BiocManager', repos='https://cloud.r-project.org')"

# SingleR + celldex
RUN R -e "BiocManager::install(c('SingleR','celldex'), ask=FALSE, update=FALSE)"
RUN R -e 'remotes::install_github("YuLab-SMU/ggtree", force = TRUE)'

# Functional analysis stack (senza enrichplot)
RUN R -e "BiocManager::install(c('clusterProfiler','org.Hs.eg.db','msigdbr'), ask=FALSE, update=FALSE)"

# Verifica installazione clusterProfiler

# =================== JUPYTER ===================
EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.root_dir=/"]
