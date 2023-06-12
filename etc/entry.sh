#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true  

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" \
				+quit

# Is the tf2classic directory present? if not then assume the game hasn't been downloaded and download it
if [ ! -d "${STEAMAPPDIR}/${STEAMAPP}/" ]; then
        wget https://wiki.tf2classic.com/kachemak/tf2classic-latest.zip
        7z e "${HOMEDIR}/tf2classic-latest.zip" -o "${STEAMAPPDIR}/${STEAMAPP}/"
fi

# Is the config missing?
if [ ! -f "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" ]; then
        # Download & extract the config
        wget -qO- "${DLURL}/master/etc/cfg.tar.gz" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

        # Change hostname on first launch (you can comment this out if it has done its purpose)
        sed -i -e 's/{{SERVER_HOSTNAME}}/'"${SRCDS_HOSTNAME}"'/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"
fi

# Believe it or not, if you don't do this srcds_run shits itself
cd "${STEAMAPPDIR}"

bash "${STEAMAPPDIR}/srcds_run" -game "${STEAMAPP}" -console -autoupdate \
                        -steam_dir "${STEAMCMDDIR}" \
                        -steamcmd_script "${HOMEDIR}/${STEAMAPP}_update.txt" \
                        -usercon \
                        +fps_max "${SRCDS_FPSMAX}" \
                        -tickrate "${SRCDS_TICKRATE}" \
                        -port "${SRCDS_PORT}" \
                        +tv_port "${SRCDS_TV_PORT}" \
                        +clientport "${SRCDS_CLIENT_PORT}" \
                        +maxplayers "${SRCDS_MAXPLAYERS}" \
                        +map "${SRCDS_STARTMAP}" \
                        +sv_setsteamaccount "${SRCDS_TOKEN}" \
                        +rcon_password "${SRCDS_RCONPW}" \
                        +sv_password "${SRCDS_PW}" \
                        +sv_region "${SRCDS_REGION}" \
                        -ip "${SRCDS_IP}" \
                        -authkey "${SRCDS_WORKSHOP_AUTHKEY}"
