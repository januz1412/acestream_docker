# acestream_docker
a simple docker to run locally the [AceStream Engine](https://www.acestream.org) on newer version of ubuntu (default at `http://127.0.0.1:6878`)

## Requirements:
VLC media player

docker

## Installation:
(replace `/home/user/` with your desired installation path)

create a working directory

`$ mkdir /home/user/acestreamDocker`

and copy Dockerfile in it

`$ cd /home/user/acestreamDocker`
`$ cp downloadDir/Dockerfile .`

compile the image

`$ docker build -t localhost/acestream:3.2.11 .`

create the runtime directory

`$ mkdir /home/user/.acestream`

add the following alias in your `.bash_aliases`

`alias acestream-start='docker rm -f acestream; /usr/bin/docker run -d --name acestream -p 6878:6878 -v /home/user/.acestream:/home/acestream/.acestream localhost/acestream:3.2.11'`

## run acestream
open a terminal and run 

`$ acestream-start`

run vlc and open an `acestream:` hyperlink

If this fails have a look to https://github.com/ilgonmic/vlc-acestream


