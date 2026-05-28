#!/usr/bin/env bash
# ------------------------------------------------------------
# acestream-launcher.sh
#   • Receives an URL of the form  acestream://<STREAM_ID>
#   • Transforms it into the HTTP URL that the AceStream daemon
#     (running on localhost:6878) understands
#   • Starts VLC (or any other player you prefer) with that URL
# ------------------------------------------------------------

# Abort on any error, and print the command we are about to run
set -euo pipefail

# -----------------------------------------------------------------
# 1️⃣ Extract the stream id from the passed argument.
#    The argument can be either:
#       - "acestream://<id>"
#       - just "<id>"
# -----------------------------------------------------------------
raw_uri="${1:-}"
if [[ -z "$raw_uri" ]]; then
    echo "Error: No stream identifier supplied."
    exit 1
fi

# Strip the leading scheme if present
stream_id="${raw_uri#acestream://}"

# -----------------------------------------------------------------
# 2️⃣ Build the HTTP URL that the AceStream daemon expects.
# -----------------------------------------------------------------
http_url="http://127.0.0.1:6878/ace/getstream?id=${stream_id}"

# -----------------------------------------------------------------
# 3️⃣ Launch VLC (you can replace this with any player you like).
#    We use `vlc --quiet` so the terminal stays clean.
# -----------------------------------------------------------------
exec vlc --quiet "$http_url"
