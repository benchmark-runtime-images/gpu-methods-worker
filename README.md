# Neutral GPU methods worker

This public repository builds a generic GPU worker for reproducible training,
retrieval and synthetic risk-analysis benchmarks. It extends the immutable
neutral SSH/vLLM runtime and installs all dependencies at image-build time.
Worker startup performs no package installation.

The source and image contain no credentials, SSH private keys, model weights,
benchmark fixtures, hidden references, graders, private mappings, client data,
private source code, or organization-specific metadata. Model and synthetic
candidate inputs are supplied only at runtime under the controller's privacy
policy.
