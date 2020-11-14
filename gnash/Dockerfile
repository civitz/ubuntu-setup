FROM ubuntu:18.04

RUN apt-get update && apt-get install -y sudo
RUN apt-get update && apt-get install -y gnash

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

# docker run -ti --rm -e DISPLAY=$DISPLAY --net=host -v /tmp/.X11-unix:/tmp/.X11-unix gnash
# docker run -it -e DISPLAY=$DISPLAY  /dev/snd --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/home/developer gnash --screenshot 1 --screenshot-file filename.png libro_U17.swf 
WORKDIR /home/developer
ENTRYPOINT ["/usr/bin/gnash"]