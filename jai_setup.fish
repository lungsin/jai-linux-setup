#!/usr/bin/env fish

# This script is used to update the JAI compiler from a download URL containing a zip file.
# The script will download the zip file, extract it, and then remove the zip file.

# Check if the env variable JAI_HOME is defined
if not set -q JAI_HOME
    echo "Error: JAI_HOME environment variable is not defined. Define it to the desired location of the JAI compiler."
    exit 1
end

# Check if the JAI_HOME directory exists
if not test -d "$JAI_HOME"
    echo "Creating directory for JAI compiler: $JAI_HOME"
    mkdir -p "$JAI_HOME"
end

# Ensure a URL argument is provided
if test (count $argv) -lt 1
    echo "Usage: update_jai.fish <download_url>"
    exit 1
end

set url $argv[1]

wget -O jai.zip $url
unzip jai.zip

if test -d "$JAI_HOME"
    echo "Backing up existing JAI compiler: $JAI_HOME"
    rm -rf "$JAI_HOME/../jai-bk"
    mv "$JAI_HOME" "$JAI_HOME/../jai-bk"
end

mv jai "$JAI_HOME"
rm jai.zip
echo "JAI compiler updated successfully."
