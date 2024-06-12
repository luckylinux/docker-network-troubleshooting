#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v toolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); toolpath=$(realpath --canonicalize-missing ${scriptpath}/${relativepath}); fi

# Load Configuration
libpath=$(readlink --canonicalize-missing "${toolpath}/includes")
source ${libpath}/functions.sh


# Optional argument
engine=${1-"podman"}

# Container Name
containername="docker-network-troubleshooting"

# Container Image
containerimage="docker-network-troubleshooting:debian-latest"

# Containers Configuration Folder to Map
containersconfigfolder="./containers"

# Options
opts=()

# Podman 5.x with Pasta doesn't handle Networking Correctly
# Force to use slirp4netns
opts+=("--network=slirp4netns")

# Add Capacilities
opts+=("--cap-add")
opts+=("CAP_NET_RAW")

# Load the Environment Variables into THIS Script
if [[ -f "./.env" ]]
then
   eval "$(shdotenv --env .env || echo \"exit $?\")"
fi

# Terminate and Remove Existing Containers if Any
${engine} stop --ignore ${containername}
${engine} rm --ignore ${containername}

# Run Image with Infinite Loop to prevent it from automatically terminating
#${engine} run --name=${containername} --env-file "./.env" localhost:5000/local/"${containerimage}"
${engine} run --name=${containername} ${opts[*]} localhost:5000/local/"${containerimage}"

# Open Interactive Shell with Container
${engine} exec -it ${containername} /bin/bash
