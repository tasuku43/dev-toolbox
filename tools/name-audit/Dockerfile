FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  bash \
  ca-certificates \
  coreutils \
  curl \
  git \
  file \
  nodejs \
  npm \
  python3 \
  python3-pip \
  python3-venv \
  && rm -rf /var/lib/apt/lists/*

# Non-root runtime to avoid host-like npm/pip permission issues.
RUN useradd -m -u 10001 -s /bin/bash auditor

ENV HOME=/home/auditor \
    NPM_CONFIG_CACHE=/home/auditor/.npm \
    PIP_CACHE_DIR=/home/auditor/.cache/pip \
    HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew \
    HOMEBREW_NO_AUTO_UPDATE=1 \
    TIMEOUT_SECS=25 \
    PYPI_RETRY_TIMEOUT_SECS=90

# Install Homebrew on Linux so "brew search" checks are available in container runs.
RUN mkdir -p /home/linuxbrew/.linuxbrew && \
    git clone --depth=1 https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew && \
    mkdir -p /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin && \
    ln -sf ../Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew && \
    chown -R auditor:auditor /home/linuxbrew

ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}

WORKDIR /work

COPY --chown=auditor:auditor name-audit /usr/local/bin/name-audit
RUN chmod +x /usr/local/bin/name-audit

USER auditor

# Prime core formula metadata during build so runtime checks are fast and consistent.
RUN brew update --force --quiet || true

ENTRYPOINT ["name-audit"]
