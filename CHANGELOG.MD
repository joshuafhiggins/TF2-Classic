# Changelog - Dockerfile

## Major Changes

### Complete Base Image Change

- **Removed:**  
    `FROM cm2network/steamcmd:root AS build_stage`
- **Added:**  
    `FROM ubuntu:24.04`

### Added New Environment Variable

- **Added:**  
    `ENV DOCKER_DEFAULT_NETWORK=host`

### Restructured Environment Variables

- **Removed:**  
    Simple environment variable definitions
- **Added:**  
    More comprehensive environment variable setup with detailed comments and additional variables, such as:
    - `USER="steam"`
    - `HOMEDIR="/home/${USER}"`
    - `STEAMCMDDIR="${HOMEDIR}/steamcmd"`
    - Performance and configuration variables (`SRCDS_FPSMAX`, `SRCDS_TICKRATE`, etc.)
    - Server configuration variables (`SRCDS_HOSTNAME`, `SRCDS_STARTMAP`, `SRCDS_RCONPW`, etc.)

### Complete Rebuild Approach

- **Removed:**  
    Multi-stage build using pre-built SteamCMD image
- **Added:**  
    - Single-stage build installing all dependencies manually
    - Manual SteamCMD installation process
    - Proper user creation and permission management
    - Manual dependency installation for 32-bit libraries
