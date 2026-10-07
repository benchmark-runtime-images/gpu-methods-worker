# Neutral GPU methods worker

This public repository builds a generic GPU worker for reproducible training,
retrieval and synthetic risk-analysis benchmarks. It extends the immutable
neutral SSH/vLLM runtime and installs all dependencies at image-build time.
Worker startup performs no package installation.

The v1 OCI package is published under the neutral registry path
`ghcr.io/benchmark-runtime-images/gpu-methods-worker-v1`.

The build verifies imports for the complete training, retrieval, classical-ML
and vision stack and preserves the base runtime's PyTorch 2.13.0+cu130,
Transformers 5.17.0, vLLM 0.31.0 and NCCL 2.30.7 versions.
PyTorch's wheel metadata names NCCL 2.29.7, so the already-frozen NCCL 2.30.7
Blackwell override is isolated in `runtime-overrides.lock`, applied without
dependency resolution after the main stack, and then checked by the exact
final runtime-matrix verifier.

The source and image contain no credentials, SSH private keys, model weights,
benchmark fixtures, hidden references, graders, private mappings, client data,
private source code, or organization-specific metadata. Model and synthetic
candidate inputs are supplied only at runtime under the controller's privacy
policy.
