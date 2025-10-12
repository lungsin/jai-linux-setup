#!/bin/bash

set -e

# This script is used to update the JAI compiler from a download URL containing a zip file.
# The script will download the zip file, extract it, and then remove the zip file.

# Check if the env variable JAI_HOME is defined
if [ -z "$JAI_HOME" ]; then
    echo "Error: JAI_HOME environment variable is not defined. Define it to the desired location of the JAI compiler."
    exit 1
fi

# Check if the JAI_HOME directory exists
if [ ! -d "$JAI_HOME" ]; then
    echo "Creatng directory for JAI compiler: $JAI_HOME"
    mkdir -p $JAI_HOME
fi

wget -O jai.zip $1
unzip jai.zip 

if [ -d "$JAI_HOME" ]; then
    echo "Backing up existing JAI compiler: $JAI_HOME"
    rm -rf $JAI_HOME/../jai-bk
    mv $JAI_HOME $JAI_HOME/../jai-bk
fi
mv jai $JAI_HOME
rm jai.zip

echo "JAI compiler updated successfully."

