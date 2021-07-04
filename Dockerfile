FROM jobber
LABEL maintainer="John Stucklen <stuckj@gmail.com>"

USER root

RUN apk update \
    && apk add py3-pip openssh \
    && rm -rf /var/cache/apk/*

USER jobberuser

RUN mkdir /mnt/backup

VOLUME /mnt/backup

RUN pip3 install snapdump

ENV PATH="${PATH}:/home/jobberuser/.local/bin"

COPY --chown=jobberuser:jobberuser jobber.yml /home/jobberuser/.jobber

COPY --chown=jobberuser:jobberuser backup.sh /home/jobberuser/backup.sh

RUN chmod 0600 /home/jobberuser/.jobber
