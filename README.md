# acestream_docker
a simple docker to run locally the [AceStream Engine](https://www.acestream.org) on newer version of ubuntu (default at `http://127.0.0.1:6878`)

## Requirements:
- VLC media player
- docker (follow the instructions at https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04 )

## Installation:
in the commands below, replace:
- `YOUR_DOWNLOAD_DIRECTORY` with the path where you have downloaded the repository files
- `YOUR_BIN_DIRECTORY` with the path of a directory included in `$PATH` (e.g. `~/bin`)
- `ANY_WORKING_ACESTREAM_ID` with a working acestream id

### Set up the docker container
create a working directory
```
mkdir ~/acestreamDocker
```

and copy Dockerfile in it
```
cd ~/acestreamDocker`
cp YOUR_DOWNLOAD_DIRECTORY/Dockerfile .
```

compile the image
```
docker build -t localhost/acestream:3.2.11 .
```

create the runtime directory
```
mkdir /home/user/.acestream
```

add the following alias in your `.bash_aliases`
```
alias acestream-start='docker rm -f acestream; /usr/bin/docker run -d --name acestream -p 6878:6878 -v /home/user/.acestream:/home/acestream/.acestream localhost/acestream:3.2.11'
```

### Create the launcher
the launcher is acestream-launcher.sh that uses vlc as media player.

copy acestram-launcher.sh in `YOUR_BIN_DIRECTORY`, a directory included in `$PATH` (e.g. `~/bin`):
```
cp YOUR_DOWNLOAD_DIRECTORY/acestream-launcher.sh YOUR_BIN_DIRECTORY
chmod 775 YOUR_BIN_DIRECTORY/acestream-launcher.sh*
```

to test if everithing is ok type the commands:
```
acestream-start='docker rm -f acestream; /usr/bin/docker run -d --name acestream -p 6878:6878 -v /home/user/.acestream:/home/acestream/.acestream localhost/acestream:3.2.11
acestream-launcher.sh acestream://ANY_WORKING_ACESTREAM_ID
```
the vlc window should pop up and show the desired channel

### Set Up the Protocol Handler
copy the handler
```
$ cp YOUR_DOWNLOAD_DIRECTORY/acestream-launcher.desktop ~/.local/share/applications/
```
edit it and replace `YOUR_BIN_DIRECTORY` with the proper path



Update your desktop database to register the new protocol association with:
```
$ update-desktop-database ~/.local/share/applications
```

Set it as the default handler

```
$ xdg-mime default acestream-launcher.desktop x-scheme-handler/acestream
```


## Nominal usage to watch an acestream
open a terminal and run 

```
$ acestream-start
```

open the browser and and open an `acestream://` hyperlink

If this fails have a look to https://github.com/ilgonmic/vlc-acestream


