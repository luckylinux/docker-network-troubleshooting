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

# Run in the Background
opts+=("-d")

# Podman 5.x with Pasta doesn't handle Networking Correctly
# Force to use slirp4netns
#opts+=("--network=slirp4netns")

# Debug Pasta
# opts+=("--network=pasta:--pcap,/tmp/your.pcap")
#opts+=("--network=pasta:--ipv6-only,-t,2XXX:XXXX:XXXX:XXXX::2/80,-t,2XXX:XXXX:XXXX:XXXX::2/443,-t,2XXX:XXXX:XXXX:XXXX::2/5001,-u,2XXX:XXXX:XXXX:XXXX::2/5001")
#opts+=("--network=pasta:--ipv6-only,--outbound,2XXX:XXXX:XXXX:XXXX::2")
#opts+=("--network=pasta:--ipv6-only,-a,2XXX:XXXX:XXXX:XXXX::2")
opts+=("--network=pasta:--ipv6-only,-a,2XXX:XXXX:XXXX:XXXX::2")

# Publish ports
opts+=("-p")
opts+=("[2XXX:XXXX:XXXX:XXXX::2]:80:80/tcp")
opts+=("-p")
opts+=("[2XXX:XXXX:XXXX:XXXX::2]:443:443/tcp")
opts+=("-p")
opts+=("[2XXX:XXXX:XXXX:XXXX::2]:5201:5201/tcp")
opts+=("-p")
opts+=("[2XXX:XXXX:XXXX:XXXX::2]:5201:5201/udp")

# Add Capacilities
opts+=("--cap-add")
opts+=("CAP_NET_RAW")

# Enable Infinite Loop
opts+=("-e")
opts+=("ENABLE_INFINITE_LOOP=true")

# Disable Automatic Test
opts+=("-e")
opts+=("ENABLE_AUTOMATIC_TEST=false")

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
echo "Executing: ${engine} run --name=${containername} ${opts[*]} localhost:5000/local/${containerimage}"
${engine} run --name=${containername} ${opts[*]} localhost:5000/local/"${containerimage}"

# Open Interactive Shell with Container
${engine} exec -it ${containername} /bin/bash
