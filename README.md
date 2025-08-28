# Single-Cell RNA-seq: Seurat + Scanpy (Dockerized)

This repository provides a **complete single-cell RNA-seq workflow** inside a Docker container, combining **R/Seurat** and **Python/Scanpy**.  
It is designed for reproducibility and ease of use: you mount your working directory into the container, run the provided scripts or notebooks, and find all results neatly organized under `Results/`.

---

## 1) Prerequisites

- **Docker** installed
  - macOS: Docker Desktop
  - Windows: Docker Desktop (WSL2 backend recommended)
  - Linux: Docker Engine
- ~8–16 GB RAM recommended for typical 10x datasets (more is better)
- Disk space for matrices and caches

**Expected repository structure:**

```
Data/
 ├─ matrix.mtx.gz
 ├─ features.tsv.gz
 ├─ barcodes.tsv.gz
 └─ metadata.tsv          # optional
Script/
 ├─ 1_PreprocessingData.ipynb
 ├─ 2_Seurat.ipynb
 ├─ 3_Scanpy.ipynb
 ├─ 4_normalization&VariableFeature.ipynb
 └─ 5_FeatureSelection.ipynb
Results/                 # created automatically, one subfolder per script
Dockerfile
README.md
```

---

## 2) What’s inside the Docker image

Base image: [`satijalab/seurat:latest`](https://hub.docker.com/r/satijalab/seurat) with extras:

- **R packages**:  
  `Seurat`, `SingleR`, `celldex`, `clusterProfiler`, `org.Hs.eg.db`, `msigdbr`, `ggplot2`, `patchwork`
- **Python packages**:  
  `scanpy`, `numpy`, `pandas`, `igraph`, `leidenalg`, `louvain`
- **JupyterLab** with IRkernel (R support)

**Authentication defaults**  
- Jupyter password: `biohack123`  
- You can override with `-e JUPYTER_TOKEN=yourpassword` at runtime.

---

## 3) Build the image (optional)

To build locally from the `Dockerfile`:

```bash
docker build -t repbioinfo/bioinfo-r-python .
```

Or pull the image from DockerHub if already published.

---

## 4) Running the container

From the repository root (`/home/jovyan/work` inside the container will map to your `PWD`):

### Linux / macOS
```bash
bash 1_runMe.sh
```

### Windows (PowerShell or CMD)
```powershell
1_script.cmd
```

Both launch:

```bash
docker run -p 8888:8888   -v "$PWD":/home/jovyan/work   -e JUPYTER_TOKEN=yourpassword   repbioinfo/bioinfo-r-python
```

---

## 5) Access JupyterLab

Open your browser at: [http://localhost:8888](http://localhost:8888)  
Login with your chosen token/password (`biohack123` by default).

---

## 6) Workflow overview

All scripts/notebooks live in `Script/`. Results go into `Results/scriptX` folders.

### **Script 1 — PCA & clustering (R base)**
- Loads the raw 10x matrix (`Data/`)
- Subsamples cells
- Selects top variable genes
- Runs PCA
- Performs **k-means** and **hierarchical clustering**
- Saves PCA plots, clustering plots, dendrogram, and results in `Results/script1`

### **Script 2 — Seurat workflow**
- Creates a Seurat object from raw matrix
- Runs standard Seurat preprocessing (`NormalizeData`, `FindVariableFeatures`, `ScaleData`, `RunPCA`)
- Graph-based clustering (`FindNeighbors`, `FindClusters`)
- UMAP embedding and visualization
- Exports cluster assignments + UMAP coordinates as CSV and PNG plots in `Results/script2`

### **Script 3 — Scanpy workflow**
- Loads raw 10x matrix using Scanpy/AnnData
- Normalization, log-transform, HVG selection
- Scaling, PCA, neighbors, Louvain clustering, UMAP
- Saves AnnData (`.h5ad`), cluster assignments with UMAP, and UMAP plots in `Results/script3`

### **Script 4 — Normalization & QC**
- Demonstrates normalization approaches (raw counts, log-normalization, CPM)
- Generates histograms of **raw counts**, **log-normalized counts**, and **CPM**
- Identifies highly variable genes (HVGs) and plots top HVGs
- Saves plots and Seurat objects in `Results/script4`

### **Script 5 — Integrated Seurat + SingleR + GSEA**
- Loads and processes raw matrix with Seurat
- Converts ENSEMBL IDs → SYMBOLs
- Runs clustering + UMAP
- Annotates cells with **SingleR** (best-matching reference from `celldex`)
- Runs **GSEA (Hallmark gene sets)** per cluster
- Saves annotated Seurat object, UMAPs, and GSEA results in `Results/script5`

---

## 7) Outputs

Each script writes into its own folder under `Results/`:

- **Results/script1/**: PCA, clustering plots, dendrogram, CSVs
- **Results/script2/**: Seurat UMAPs, cluster CSV, metadata with UMAP, RDS object
- **Results/script3/**: AnnData `.h5ad`, Scanpy UMAPs, cluster CSV
- **Results/script4/**: QC histograms (raw, normalized, CPM), top HVG plots, RDS objects
- **Results/script5/**: Seurat object with SingleR labels, UMAP plots, GSEA CSVs

---

## 8) Troubleshooting

- If `celldex` fails (`ExperimentHub` issues), SingleR annotations may be skipped. GSEA and Seurat plots are still generated.  
- Use sufficient memory; PCA/UMAP on >50k cells may require >16 GB.  
- Ensure your `Data/` directory contains **gzipped** `matrix.mtx`, `features.tsv`, `barcodes.tsv`.

---

## 9) Citation

If you use this workflow, please cite:  
- Seurat: Satija Lab  
- Scanpy: Wolf et al., Genome Biology 2018  
- SingleR: Aran et al., Nature Immunology 2019  
- clusterProfiler: Wu et al., *The Innovation* 2021  

---

**Maintainer:** Luca Alessandri (<l.alessandri@unito.it>)
**Contact:** please open issues or reach out for questions.
