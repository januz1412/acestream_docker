#!/usr/bin/env bash
# ------------------------------------------------------------
# acestream-launcher.sh
#   • Receives an URL of the form  acestream://<STREAM_ID>
#     or simply the 40 digits <STREAM_ID>
#   • Transforms it into the HTTP URL that the AceStream daemon
#     (running on localhost:6878) understands
#   • Starts VLC (or any other player you prefer) with that URL
# ------------------------------------------------------------

parse_acestream() {
    local input="$1"
    local stream_id=""

    if [[ "$input" =~ ^acestream://([a-fA-F0-9]{40})$ ]]; then
        stream_id="${BASH_REMATCH[1]}"
    elif [[ "$input" =~ ^([a-fA-F0-9]{40})$ ]]; then
        stream_id="$1"
    else
        echo "Error: invalid input '$input'" >&2
        return 1
    fi

    echo "$stream_id"
}

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
# check if the url


# Strip the leading scheme if present
stream_id=$(parse_acestream "$1") || exit 1

# -----------------------------------------------------------------
# 2️⃣ Build the HTTP URL that the AceStream daemon expects.
# -----------------------------------------------------------------
http_url="http://127.0.0.1:6878/ace/getstream?id=${stream_id}"

# -----------------------------------------------------------------
# 3️⃣ Launch VLC (you can replace this with any player you like).
#    We use `vlc --quiet` so the terminal stays clean.
# -----------------------------------------------------------------
exec vlc --quiet "$http_url"
