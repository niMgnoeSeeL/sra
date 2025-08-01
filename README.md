A README main file describing what the artifact does and where it can be obtained (with hidden links and access password if necessary). Also, there should be a clear description of how to repeat/replicate/reproduce the results presented in the paper. Artifacts that focus on data should, in principle, cover aspects relevant to understand the context, data provenance, ethical and legal statements (as long as relevant), and storage requirements. Artifacts that focus on software should, in principle, cover aspects relevant to how to install and use it (and be accompanied by a small example).



# Artifact for the project "Statistical Reachability Analysis"

This repository contains the artifact of the paper "Statistical Reachability Analysis" submitted to the FSE/ESEC 2023 conference.

# Artifact structure

The artifact is structured as follows:
```
├── README.md (this file)
├── rq1 (folder containing the data for the results of RQ1)
│   ├── laplace (folder containing the data for the Laplace estimator)
|   |   └── RQ1-Laplace.ipynb (Jupyter notebook to generate the RQ1 results for the Laplace estimator)
│   ├── preach (folder containing the data for the PReach)
│   └── pse (folder containing the data for the PSE)
├── rq2 (folder containing the data for the results of RQ2)
│   ├── fuzz-data (folder containing the fuzzing data)
│   ├── figures (folder containing the figures)
|   ├── esti-result (folder containing the estimation results of statistical reachability estimators)
|   ├── scripts (folder containing the scripts to generate the estimation results)
|   ├── sra (folder containing the source code of the SRA tool)
|   RQ2-estimate.ipynb (Jupyter notebook to generate the RQ2 estimation results)
└── RQ2-timespent.ipynb (Jupyter notebook to generate the RQ2 time spent results)
```