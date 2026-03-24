# --------------------------------------------------------------
# 1️⃣  Base image – Ubuntu 22.04 (Jammy)
# --------------------------------------------------------------
FROM ubuntu:22.04 AS builder

# --------------------------------------------------------------
# 2️⃣  Prevent interactive tzdata prompts & set env vars
# --------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive \
    ACESTREAM_TAR_URL="https://download.acestream.media/linux/acestream_3.2.11_ubuntu_22.04_x86_64_py3.10.tar.gz" \
    ACESTREAM_VERSION="3.2.11"

# --------------------------------------------------------------
# 3️⃣  Install core utilities (wget, gnupg, dirmngr) – needed for any
#     later apt‑key operations (we’ll only use them for the focal repo)
# --------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        gnupg \
        dirmngr \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------
# 4️⃣  Add the *focal* archive **only** to fetch libssl1.1
# --------------------------------------------------------------
RUN echo "deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse" \
        > /etc/apt/sources.list.d/focal.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse" \
        >> /etc/apt/sources.list.d/focal.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends libssl1.1 && \
    # Remove the temporary focal list – we don’t want the rest of the packages
    rm /etc/apt/sources.list.d/focal.list && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------
# 5️⃣  Install **all** runtime dependencies required by the tarball
# --------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.10 \
        python3.10-venv \
        python3.10-dev \
        libglib2.0-0 \
        libqt5core5a \
        libqt5gui5 \
        libqt5network5 \
        libqt5widgets5 \
        libavcodec58 \
        libavformat58 \
        libavutil56 \
        libswscale5 \
        ffmpeg \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------
# 6️⃣  Upgrade pip for the 3.10 interpreter (makes the later install smoother)
# --------------------------------------------------------------
RUN wget -qO /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3.10 /tmp/get-pip.py && \
    rm -f /tmp/get-pip.py /usr/local/bin/pip3 && \
    ln -s /usr/local/bin/pip /usr/local/bin/pip3

# --------------------------------------------------------------
# 7️⃣  Download and unpack the AceStream tarball
# --------------------------------------------------------------
WORKDIR /usr/local/bin
RUN wget -O /tmp/acestream.tar.gz "$ACESTREAM_TAR_URL" && \
    tar -xzf /tmp/acestream.tar.gz && \
    rm -f /tmp/acestream.tar.gz

# --------------------------------------------------------------
# 8️⃣  Install AceStream (the tarball ships a setup.py‑style installer)
# --------------------------------------------------------------
RUN python3.10 -m pip install --upgrade pip setuptools wheel
RUN python3.10 -m pip install -r requirements.txt

# --------------------------------------------------------------
# 9️⃣  Create a non‑root user that will run the daemon
# --------------------------------------------------------------
RUN groupadd -r acestream && \
    useradd -r -g acestream -s /bin/bash -m -d /home/acestream acestream
RUN chmod 777 /usr/local/bin

# --------------------------------------------------------------
# 🔟  Switch to that user
# --------------------------------------------------------------
USER acestream
WORKDIR /home/acestream

# --------------------------------------------------------------
# 1️⃣1️⃣ Expose the default AceStream daemon port
# --------------------------------------------------------------
EXPOSE 6878/tcp

# --------------------------------------------------------------
# 1️⃣2️⃣ Default command – start the daemon in console mode
# --------------------------------------------------------------
ENTRYPOINT ["/usr/local/bin/acestreamengine"]
CMD ["--client-console"]


