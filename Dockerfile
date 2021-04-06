FROM phusion/passenger-full:latest
RUN apt update
RUN apt install rsync
RUN npm install --global yarn

# TODO Reorder the file so that the commands that change least often remain on top!

# Enable SSH for testing capistrano deploys
RUN rm -f /etc/service/sshd/down
RUN /usr/sbin/enable_insecure_key
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# RUN ls /pd_build/*
# RUN /pd_build/ruby-2.7.2.sh
# RUN /pd_build/nodejs.sh
RUN bash -lc 'rvm --default use ruby-2.7.2'

RUN mkdir -p /deploy/webapp
COPY --chown=app:app . /deploy/webapp

# RUN mkdir -p /home/app/.ssh
RUN chmod 700 /home/app/.ssh
RUN ls /home/app/.ssh
COPY insecure_key.pub /home/app/.ssh/authorized_keys
RUN chmod 644 /home/app/.ssh/authorized_keys
# Permit SSH login to app user
RUN usermod -p '*' app

RUN chown -R app:app /home/app/.ssh

RUN echo "AllowUsers root app" >> /etc/ssh/sshd_config

USER app
RUN (cd /deploy/webapp && bundle install)

USER root

RUN bash -c 'echo -e "Host localhost\n\tUser app\n\tIdentityFile /deploy/webapp/insecure_key" >> /root/.ssh/config'
RUN chmod 664 /root/.ssh/config

RUN /bd_build/cleanup.sh
