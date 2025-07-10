# Single-Cell Tutorial Playground

Welcome to this compact tutorial repository designed to illustrate different approaches to analyzing single-cell RNA-seq data.

This repository includes:
- A subset of real 10X Genomics data from a peer-reviewed publication
- Three different workflows: a naive example (what not to do), and proper pipelines using Seurat (R) and Scanpy (Python)
- Fully reproducible environments using Docker and Singularity

## Repository Structure

```
.
├── Data/                    # Raw 10X data subset
├── Script/                 # Tutorial notebooks and generated figures
│   ├── 1_PreprocessingData.ipynb       <- Manual R pipeline (naive)
│   ├── 2_Seurat.ipynb                  <- Seurat workflow
│   ├── 3_Scanpy.ipynb                  <- Scanpy workflow
│   └── figures/
│       └── umap_louvain.png            <- UMAP plot from Scanpy
├── Dockerfile                        # Docker image definition
├── script.sh                         # Start Docker container (Linux/Mac)
├── script.cmd                        # Start Docker container (Windows)
├── script_singularity.sh             # Start container using Singularity
├── scanpy_clusters_umap.csv          # Scanpy UMAP and clustering output
├── seurat_clusters_umap.csv          # Seurat UMAP and clustering output
├── metadata.tsv                      # Sample metadata (if available)
└── commandsToCommit.txt              # Versioning notes
```

## Data

This project uses a subset of the data from:

**Publication**: [Single-cell transcriptomics of the human immune system](https://pubmed.ncbi.nlm.nih.gov/38307867/)  
The dataset includes 10X-formatted files: `matrix.mtx.gz`, `barcodes.tsv.gz`, `features.tsv.gz`.

## Notebooks Overview

### 1. `1_PreprocessingData.ipynb` — Naive R Example
A manual approach using base R:
- Direct loading of sparse matrices
- Subsampling 500 cells
- PCA, k-means and hierarchical clustering
- Basic plots (including dendrogram)

This script is included for educational purposes, showing how *not* to analyze single-cell data.

### 2. `2_Seurat.ipynb` — Seurat Workflow (R)
Standard single-cell analysis using Seurat:
- Creation of Seurat object from raw matrix
- Normalization, feature selection, scaling
- PCA, graph-based clustering (Louvain)
- UMAP for visualization
- Export of UMAP + cluster coordinates to CSV

### 3. `3_Scanpy.ipynb` — Scanpy Workflow (Python)
Scanpy implementation with equivalent steps:
- Manual loading of raw matrix market format
- Normalization and log transformation
- Highly variable gene selection
- PCA, neighborhood graph, Louvain clustering
- UMAP for visualization
- Export of results as CSV and PNG

## How to Run

### Option 1: Docker

#### Linux / macOS
```bash
./script.sh
```

#### Windows (CMD)
```cmd
script.cmd
```

This will start a Docker container and launch Jupyter Lab at [http://localhost:8888](http://localhost:8888). The `sharedFolder` inside the container maps to the repository folder.

### Option 2: Singularity

```bash
./script_singularity.sh
```

This will pull the Docker image from DockerHub, convert it to a Singularity `.sif` image if needed, and launch Jupyter Lab with the repository mounted.

## Citation

Please cite the original dataset source if you use this material for publication or presentations:

> Arigoni et al. [PMID: 38307867](https://pubmed.ncbi.nlm.nih.gov/38307867/)

## License

This repository is provided for educational purposes only. Use at your own discretion.
