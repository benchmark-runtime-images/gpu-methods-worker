ARG BASE_IMAGE=ghcr.io/benchmark-runtime-images/vllm-ssh-worker@sha256:856891fd5e66237a5107ddc06fd6a3f212ed4a93b735263986aa25fbced02900
FROM ${BASE_IMAGE}

# Dependency installation happens only while building this immutable image.
# Billed worker startup inherits the package-free managed SSH entrypoint.
COPY requirements.lock /tmp/requirements.lock
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.lock \
    && rm -f /tmp/requirements.lock \
    && python3 - <<'PY'
import importlib.metadata as metadata

expected = {
    "peft": "0.21.2",
    "trl": "1.14.2",
    "bitsandbytes": "0.50.2",
    "datasets": "5.1.0",
    "sentence-transformers": "6.1.0",
    "xgboost": "3.4.1",
    "scikit-learn": "1.9.1",
    "torch-geometric": "2.8.0.post1",
    "networkx": "3.7",
    "pandas": "3.0.6",
    "pyarrow": "25.0.1",
    "CairoSVG": "2.9.1",
    "Pillow": "12.3.0",
}
actual = {name: metadata.version(name) for name in expected}
if actual != expected:
    raise SystemExit(f"runtime matrix drift: {actual}")
PY

LABEL org.opencontainers.image.title="Neutral GPU methods worker" \
      org.opencontainers.image.description="Digest-locked training, retrieval and risk benchmark runtime" \
      benchmark.runtime.profile="gpu-methods-cu130-v1" \
      benchmark.runtime.startup-package-installation="false"
