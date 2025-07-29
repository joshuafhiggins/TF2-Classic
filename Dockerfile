# 1. Use a modern OS base with the correct GLIBC
FROM ubuntu:24.04

ENV DOCKER_DEFAULT_NETWORK=host

LABEL maintainer="contact@mclab.tf"

# 2. Set all necessary environment variables
ENV SRCDS_TOKEN="changeme" 
ENV SRCDS_RCONPW="changeme" 
ENV SRCDS_PW="changeme" 
ENV SRCDS_PORT=27015
ENV SRCDS_TV_PORT=27020
ENV SRCDS_IP="0"
ENV SRCDS_FPSMAX=300
ENV SRCDS_TICKRATE=66
ENV SRCDS_MAXPLAYERS=14
ENV SRCDS_REGION=3
ENV SRCDS_STARTMAP="ctf_2fort"
ENV SRCDS_HOSTNAME="New TF Server"
ENV SRCDS_WORKSHOP_AUTHKEY=""

# Script Var
ENV USER="steam"
ENV HOMEDIR="/home/steam"
ENV STEAMCMDDIR="/home/steam/steamcmd"
ENV STEAMAPPID="244310"
ENV STEAMAPP="tf2classic"
ENV STEAMAPPDIR="/home/steam/tf2classic-dedicated"

# 3. Set up the system and install all dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       wget \
       ca-certificates \
       curl \
       p7zip-full \
       aria2 \
       lib32gcc-s1 \
       lib32stdc++6 \
       zlib1g:i386 \
       libncurses6:i386 \
       libtinfo6:i386 \
       libbz2-1.0:i386 \
       libsdl2-2.0-0:i386 \
       libcurl4:i386 \
    && rm -rf /var/lib/apt/lists/*

# 4. Create the user and directories
RUN useradd -m --shell /bin/bash ${USER} \
    && mkdir -p ${STEAMCMDDIR} ${STEAMAPPDIR} \
    && chown -R ${USER}:${USER} ${HOMEDIR}

# 5. Switch to non-root user
USER ${USER}
WORKDIR ${HOMEDIR}

# 6. Download and install SteamCMD
RUN curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C ${STEAMCMDDIR}

# 7. Create the update script for the game
RUN { \
    echo '@ShutdownOnFailedCommand 1'; \
    echo '@NoPromptForPassword 1'; \
    echo 'force_install_dir '"${STEAMAPPDIR}"''; \
    echo 'login anonymous'; \
    echo 'app_update '"${STEAMAPPID}"'' -beta previous2021; \
    echo 'quit'; \
    } > "${HOMEDIR}/${STEAMAPP}_update.txt"

# 8. Copy the entry script and make it executable
COPY --chown=steam:steam entry.sh .
RUN chmod +x entry.sh

# 9. Expose the server ports
EXPOSE ${SRCDS_PORT}/tcp
EXPOSE ${SRCDS_PORT}/udp
EXPOSE ${SRCDS_TV_PORT}/udp

# 10. Set the container startup command
CMD ["./entry.sh"]