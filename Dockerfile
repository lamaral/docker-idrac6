FROM jlesage/baseimage-gui:ubuntu-18.04

ENV APP_NAME="iDRAC 6" \
    IDRAC_PORT=443 \
    HOME=/app

COPY keycode-hack.c /keycode-hack.c
RUN apt-get update && \
    apt-get install -y wget openjdk-8-jdk gcc && \
    gcc -o /keycode-hack.so /keycode-hack.c -shared -s -ldl -fPIC && \
    apt-get remove -y gcc && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm /keycode-hack.c

COPY java.security /etc/java-8-openjdk/security/java.security
RUN mkdir /app && \
    mkdir -p /app/.java/.userPrefs && \
    chown ${USER_ID}:${GROUP_ID} -R /app

COPY startapp.sh /startapp.sh

WORKDIR /app
