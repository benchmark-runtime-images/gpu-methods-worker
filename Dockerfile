ARG BASE_IMAGE=ghcr.io/benchmark-runtime-images/vllm-ssh-worker@sha256:856891fd5e66237a5107ddc06fd6a3f212ed4a93b735263986aa25fbced02900
FROM ${BASE_IMAGE}

# Dependency installation happens only while building this immutable image.
# Billed worker startup inherits the package-free managed SSH entrypoint.
COPY requirements.lock /tmp/requirements.lock
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.lock \
    && rm -f /tmp/requirements.lock \
    && install -d -m 0755 /usr/local/share/benchmark \
    && python3 - <<'PY'
import importlib.metadata as metadata
import importlib
import json
import platform

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
    "nvidia-nccl-cu13": "2.30.7",
    "torch": "2.13.0+cu130",
    "transformers": "5.17.0",
    "vllm": "0.31.0",
}
actual = {name: metadata.version(name) for name in expected}
if actual != expected:
    raise SystemExit(f"runtime matrix drift: {actual}")
for module in (
    "peft",
    "trl",
    "bitsandbytes",
    "datasets",
    "sentence_transformers",
    "xgboost",
    "sklearn",
    "torch_geometric",
    "networkx",
    "pandas",
    "pyarrow",
    "cairosvg",
    "PIL",
):
    importlib.import_module(module)
with open("/usr/local/share/benchmark/runtime-matrix.json", "w", encoding="utf-8") as handle:
    json.dump(
        {"python": platform.python_version(), "packages": actual},
        handle,
        indent=2,
        sort_keys=True,
    )
    handle.write("\n")
PY

LABEL org.opencontainers.image.title="Neutral GPU methods worker" \
      org.opencontainers.image.description="Digest-locked training, retrieval and risk benchmark runtime" \
      benchmark.runtime.profile="gpu-methods-cu130-v1" \
      benchmark.runtime.startup-package-installation="false"
