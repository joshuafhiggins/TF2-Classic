[![Docker Build Status](https://img.shields.io/docker/cloud/build/litltoast/tf2-classic.svg)](https://hub.docker.com/r/litltoast/tf2-classic/) [![Docker Stars](https://img.shields.io/docker/stars/litltoast/tf2-classic.svg)](https://hub.docker.com/r/litltoast/tf2-classic/) [![Docker Pulls](https://img.shields.io/docker/pulls/litltoast/tf2-classic.svg)](https://hub.docker.com/r/litltoast/tf2-classic/) [![](https://img.shields.io/docker/image-size/litltoast/tf2-classic)](https://microbadger.com/images/litltoast/tf2-classic)
# Supported tags and respective `Dockerfile` links
-	[`base`, `latest` (*Dockerfile*)](https://github.com/higgy999/TF2-Classic/blob/master/Dockerfile)

# How to use this image
## Hosting a simple game server

Running on the *host* interface (recommended):<br/>
```console
$ docker run -d -it --net=host --name=tf2classic-dedicated -e SRCDS_TOKEN={YOURTOKEN} litltoast/tf2-classic
```

Running using a bind mount for data persistence on container recreation:
```console
$ mkdir -p $(pwd)/tf2-data
$ chmod 777 $(pwd)/tf2-data # Makes sure the directory is writeable by the unprivileged container user
$ docker run -d -it --net=host -v $(pwd)/tf2-data:/home/steam/tf2classic-dedicated/ --name=tf2classic-dedicated -e SRCDS_TOKEN={YOURTOKEN} litltoast/tf2-classic
```

Running multiple instances (increment SRCDS_PORT and SRCDS_TV_PORT):
```console
$ docker run -d -it --net=host --name=tf2classic-dedicated2 -e SRCDS_PORT=27016 -e SRCDS_TV_PORT=27021 -e SRCDS_TOKEN={YOURTOKEN} litltoast/tf2-classic
```

`SRCDS_TOKEN` **is required to be listed & reachable. Generate one here using AppID `440`:**  
[https://steamcommunity.com/dev/managegameservers](https://steamcommunity.com/dev/managegameservers)<br/><br/>
`SRCDS_WORKSHOP_AUTHKEY` **is required to use workshop features:**  
[https://steamcommunity.com/dev/apikey](https://steamcommunity.com/dev/apikey)<br/>

**It's also recommended to use "--cpuset-cpus=" to limit the game server to a specific core & thread.**<br/>
**The container will automatically update the game on startup, so if there is a game update just restart the container.**

# Configuration
## Environment Variables
Feel free to overwrite these environment variables, using -e (--env): 
```dockerfile
SRCDS_TOKEN="changeme" (value is is required to be listed & reachable, retrieve token here (AppID 440): https://steamcommunity.com/dev/managegameservers)
SRCDS_RCONPW="changeme" (value can be overwritten by tf/cfg/server.cfg) 
SRCDS_PW="changeme" (value can be overwritten by tf/cfg/server.cfg) 
SRCDS_PORT=27015
SRCDS_TV_PORT=27020
SRCDS_IP="0" (local ip to bind)
SRCDS_FPSMAX=300
SRCDS_TICKRATE=66
SRCDS_MAXPLAYERS=14
SRCDS_REGION=3
SRCDS_STARTMAP="ctf_2fort"
SRCDS_HOSTNAME="New TF Server" (first launch only)
SRCDS_WORKSHOP_AUTHKEY="" (required to load workshop maps)
```
## Config
TF2 Configs not guarenteed to work in TF2 Classic
The image contains static copies of the competitive config files from [UGC League](https://www.ugcleague.com/files_tf26.cfm#) and [RGL.gg](https://rgl.gg/Public/About/Configs.aspx?r=24). 

You can edit the config using this command:
```console
$ docker exec -it tf2classic-dedicated nano /home/steam/tf2classic-dedicated/tf2classic/cfg/server.cfg
```

If you want to learn more about configuring a TF2 server check this [documentation](https://wiki.teamfortress.com/wiki/Dedicated_server_configuration).

# Image Variants:

## `tf2classic:latest`
This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is a bare-minimum TF2 dedicated server containing no 3rd party plugins.<br/>

# Contributors
[![Contributors Display](https://badges.pufler.dev/contributors/higgy999/TF2-Classic?size=50&padding=5&bots=false)](https://github.com/higgy999/TF2-Classic/graphs/contributors)
