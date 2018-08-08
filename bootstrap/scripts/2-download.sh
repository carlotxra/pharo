#!/usr/bin/env bash
#
# Download resources required for bootstrap process
#
set -x
set -e

. ${BOOTSTRAP_REPOSITORY:-.}/bootstrap/scripts/envvars.sh

mkdir -p "${CACHE}" #required to generate hermes files

${BOOTSTRAP_REPOSITORY}/bootstrap/scripts/getPharoVM.sh 61
wget https://github.com/guillep/PharoBootstrap/releases/download/v1.4.1/bootstrapImage.zip
unzip bootstrapImage.zip

cd "${CACHE}"
#We need the old sources file next to the image because of sources condensation step
wget http://files.pharo.org/sources/PharoV60.sources
echo "Prepare icons"
mkdir icon-packs
cd icon-packs
# update the commit hash as soon as you need a new version of the icons to be loaded
wget http://github.com/pharo-project/pharo-icon-packs/archive/57fba57a02ef3b96c453fb9feba7b71c6a3e618e.zip -O idea11.zip
cd ..
cd ..


# Downloads a SPUR vm for the configured architecture
mkdir ${CACHE}/vmtarget
cd ${CACHE}/vmtarget
${BOOTSTRAP_REPOSITORY}/bootstrap/scripts/getPharoVM.sh 70 vm $BOOTSTRAP_ARCH
cd -

