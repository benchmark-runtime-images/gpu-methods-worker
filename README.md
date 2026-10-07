# Neutral GPU methods worker

This public repository builds a generic GPU worker for reproducible training,
retrieval and synthetic risk-analysis benchmarks. It extends the immutable
neutral SSH/vLLM runtime and installs all dependencies at image-build time.
Worker startup performs no package installation.

The build verifies imports for the complete training, retrieval, classical-ML
and vision stack and preserves the base runtime's PyTorch 2.13.0+cu130,
Transformers 5.17.0, vLLM 0.31.0 and NCCL 2.30.7 versions.

The source and image contain no credentials, SSH private keys, model weights,
benchmark fixtures, hidden references, graders, private mappings, client data,
private source code, or organization-specific metadata. Model and synthetic
candidate inputs are supplied only at runtime under the controller's privacy
policy.
