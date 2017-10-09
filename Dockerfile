##########################
#
# Docker file to  extend elastest/docker-siblings:latest with
#     - Chrome
#     - Firefox
#     - Xvfb
#
########################

FROM elastest/ci-docker-siblings:latest

# user for setting the environment
USER root

# Xvfb
RUN apt-get install -y xvfb

RUN echo '#!/bin/bash\n\
\n\
XVFB=/usr/bin/Xvfb\n\
XVFBARGS="$DISPLAY -ac -screen 0 1024x768x16"\n\
PIDFILE=${HOME}/xvfb_${DISPLAY:1}.pid\n\
case "$1" in\n\
  start)\n\
    echo -n "Starting virtual X frame buffer: Xvfb"\n\
    /sbin/start-stop-daemon --start --quiet --pidfile $PIDFILE --make-pidfile --background --exec $XVFB -- $XVFBARGS\n\
    echo "."\n\
    ;;\n\
  stop)\n\
    echo -n "Stopping virtual X frame buffer: Xvfb"\n\
    /sbin/start-stop-daemon --stop --quiet --pidfile $PIDFILE\n\
    echo "."\n\
    ;;\n\
  restart)\n\
    $0 stop\n\
    $0 start\n\
    ;;\n\
  *)\n\
  echo "Usage: /etc/init.d/xvfb {start|stop|restart}"\n\
  exit 1\n\
esac\n\
exit 0\n'\
>> /etc/init.d/xvfb

RUN chmod +x /etc/init.d/xvfb
RUN /etc/init.d/xvfb start
ENV DISPLAY :99.0

# Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list

# Firefox
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AF316E81A155146718A6FBD7A6DCF7707EBC211F  \
  && echo "deb http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu trusty main" >> /etc/apt/sources.list.d/firefox.list \
  && apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    firefox \
  && rm -rf /etc/apt/sources.list.d/firefox.list

USER jenkins

WORKDIR ${WORKSPACE}

# launch container
#ENTRYPOINT ["/bin/bash"]
