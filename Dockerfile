##########################
#
# Docker file to  extend elastest/docker-siblings:latest with
#     - Xvfb
#     - Chrome
#     - Firefox
#
########################

FROM elastest/ci-docker-siblings:latest
USER root

# Xvfb
RUN apt-get update && apt-get install -y xvfb supervisor
ENV DISPLAY :99.0
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME /var/log/supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Chrome
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

# Cleanup
RUN apt-get autoremove --purge

# Jenkins user
USER jenkins
WORKDIR ${WORKSPACE}
ENTRYPOINT ["/bin/bash"]

