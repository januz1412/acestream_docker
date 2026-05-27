# acestream_docker
a simple docker to run locally the [AceStream Engine](https://www.acestream.org) on newer version of ubuntu (default at `http://127.0.0.1:6878`)

## Requirements:
- VLC media player
- docker

## Installation:
(replace `YOUR_DOWNLOAD_DIRECTORY` with the path where you have downloaded the repository files

create a working directory
```
$ mkdir ~/acestreamDocker
```

and copy Dockerfile in it
```
$ cd ~/acestreamDocker`
$ cp YOUR_DOWNLOAD_DIRECTORY/Dockerfile .
```

compile the image
```
$ docker build -t localhost/acestream:3.2.11 .
```

create the runtime directory
```
$ mkdir /home/user/.acestream
```

add the following alias in your `.bash_aliases`
```
alias acestream-start='docker rm -f acestream; /usr/bin/docker run -d --name acestream -p 6878:6878 -v /home/user/.acestream:/home/acestream/.acestream localhost/acestream:3.2.11'
```

###Set Up the Protocol Handler
the handler is acestream-launcher.sh that uses vls as media player.

copy acestram-launcher.sh in a directory included in the path (e.g. `~/bin/`):
```
$ cp YOUR_DOWNLOAD_DIRECTORY/acestream-launcher.sh ~/bin
$ chmod 775 ~/bin/acestream-launcher.sh*
```

create the handler
```
$ nano ~/.local/share/applications/acestream-launcher.desktop
```

Paste the following configuration into the file:
```
[Desktop Entry]
Name=AceStream Launcher
Comment=Play AceStream links with VLC
Exec=acestream-launcher "%u"
Terminal=false
Type=Application
MimeType=x-scheme-handler/acestream;
Categories=Network;Video;Player;
```

Update your desktop database to register the new protocol association with:
```
$ update-desktop-database ~/.local/share/applications
```

Set it as the Default Handler

```
$ xdg-mime default acestream-launcher.desktop x-scheme-handler/acestream
```


## run acestream
open a terminal and run 

```
$ acestream-start
```

open the browser and and open an `acestream:` hyperlink

If this fails have a look to https://github.com/ilgonmic/vlc-acestream


