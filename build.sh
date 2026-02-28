#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v toolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); toolpath=$(realpath --canonicalize-missing ${scriptpath}/${relativepath}); fi

# Load Functions
# libpath=$(readlink --canonicalize-missing "${toolpath}/includes")
# source "${libpath}/functions.sh"

# Optional argument
engine=${1-"podman"}

# Check if Engine Exists
# engine_exists "${engine}"
# if [[ $? -ne 0 ]]
# then
#     # Error
#     echo "[CRITICAL] Neither Podman nor Docker could be found and/or the specified Engine <${engine}> was not valid."
#     echo "ABORTING !"
#     exit 9
# fi

# Load the Environment Variables into THIS Script
# eval "$(shdotenv --env ${toolpath}/.env || echo \"exit $?\")"

if [[ -f ./.env ]]
then
   source ./.env
fi

# Run a Local Registry WITHOUT Persistent Data Storage
# run_local_registry "${engine}"

# Image Name
name="docker-network-troubleshooting"

# Options
opts=()

# Use --no-cache when e.g. updating docker-entrypoint.sh and images don't get updated as they should
# opts+=("--no-cache")

# Specify local Docker Mirror
opts+=("--build-arg")
opts+=("DOCKER_MIRROR=${DOCKER_MIRROR}")

# Base Image
# "Alpine" or "Debian"
bases=()
bases+=("Alpine")
bases+=("Debian")

# Mandatory Tag
#tag=$(cat ./tag.txt | head -n1)
tag=$(date +%Y%m%d)


# Select Platform
# Not used for now
#platform="linux/amd64"
#platform="linux/arm64/v8"


# Iterate over Image Base
for base in "${bases[@]}"
do
    # Select Dockerfile
    buildfile="Dockerfile-$base"

    # Check if they are set
    if [[ ! -v name ]] || [[ ! -v tag ]]
    then
       echo "Both Container Name and Tag Must be Set" !
    fi

    # Define Tags to attach to this image
    imagetags=()
    imagetags+=("${name}:${base,,}-${tag}")
    imagetags+=("${name}:${base,,}-latest")

    # Copy requirements into the build context
    # cp <myfolder> . -r docker build . -t  project:latest

    # For each image tag
    tagargs=()
    for imagetag in "${imagetags[@]}"
    do
       # Echo
       echo "Processing Image Tag <${imagetag}> for Container Image <${name}>"

       # Check if Image with the same Name already exists
       # remove_image_already_present "${imagetag}" "${engine}"

       # Add Argument to tag this Image too when running Container Build Command
       tagargs+=("-t")
       tagargs+=("${imagetag}")
    done

    # Build Container Image
    ${engine} build ${opts[*]} ${tagargs[*]} -f ${buildfile} .

    # For each Image Tag
    # for imagetag in "${imagetags[@]}"
    # do
    #     # Tag & Upload to local Registry
    #     upload_to_local_registry "${imagetag}" "${engine}"
    # done
done
