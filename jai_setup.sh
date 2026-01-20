#!/bin/bash

set -e

# This script is used to update the JAI compiler from a download URL containing a zip file.
# The script will download the zip file, extract it to a versioned directory, and symlink to it.
# All versions are stored in jai_compilers directory for easy rollback.

# Check if URL argument is provided
if [ -z "$1" ]; then
    echo "Error: Download URL is required."
    echo "Usage: $0 <download_url>"
    exit 1
fi

# Check if JAI_ROOT is defined, otherwise, set it with default value
SHOW_BASHRC_SETUP_MESSAGE=false
if [ -z "$JAI_ROOT" ]; then
    JAI_ROOT="$HOME/jai"
    echo "JAI_ROOT not set, using default: $JAI_ROOT"
    SHOW_BASHRC_SETUP_MESSAGE=true
fi

if [ -z "$JAI_PATH" ]; then
    JAI_PATH="$JAI_ROOT/jai"
    echo "JAI_PATH not set, using default: $JAI_PATH"
    SHOW_BASHRC_SETUP_MESSAGE=true
fi

# Extract version from URL before downloading
DOWNLOAD_URL="$1"
# Extract filename from URL, removing query parameters
ZIP_FILENAME=$(basename "$DOWNLOAD_URL" | cut -d'?' -f1)

# Extract version from filename (e.g., jai-beta-2-025.zip -> beta-2-025)
VERSION=$(echo "$ZIP_FILENAME" | sed 's/^jai-//' | sed 's/\.zip$//')
if [ -z "$VERSION" ]; then
    echo "Error: Could not extract version from filename: $ZIP_FILENAME"
    exit 1
fi

echo "Detected version: $VERSION"

# Set up the jai_compilers directory
JAI_COMPILERS_DIR="$JAI_ROOT/jai_compilers"
VERSION_DIR="$JAI_COMPILERS_DIR/$VERSION"

# Create jai_compilers directory if it doesn't exist
if [ ! -d "$JAI_COMPILERS_DIR" ]; then
    echo "Creating jai_compilers directory: $JAI_COMPILERS_DIR"
    mkdir -p "$JAI_COMPILERS_DIR"
fi

# Check if this version already exists
if [ -d "$VERSION_DIR" ]; then
    echo "Warning: Version $VERSION already exists at $VERSION_DIR"
    read -p "Do you want to remove and reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 1
    fi
    echo "Removing existing version to reinstall..."
    rm -rf "$VERSION_DIR"
fi

# Download the zip file
echo "Downloading JAI compiler from: $DOWNLOAD_URL"
wget -O "$ZIP_FILENAME" "$DOWNLOAD_URL"

# Extract the zip file
echo "Extracting $ZIP_FILENAME..."
unzip -q "$ZIP_FILENAME"

# Move extracted directory to versioned location
if [ ! -d "jai" ]; then
    echo "Error: Expected 'jai' directory not found after extraction"
    rm -f "$ZIP_FILENAME"
    exit 1
fi

echo "Installing to $VERSION_DIR"
mv jai "$VERSION_DIR"

# Remove the zip file
rm -f "$ZIP_FILENAME"

# Update symlink to point to the new version
if [ -L "$JAI_PATH" ] || [ -e "$JAI_PATH" ]; then
    echo "Removing old JAI_PATH link/directory: $JAI_PATH"
    rm -rf "$JAI_PATH"
fi

echo "Creating symlink: $JAI_PATH -> $VERSION_DIR"
ln -s "$VERSION_DIR" "$JAI_PATH"

echo ""
echo "JAI compiler version $VERSION installed successfully."
echo "Installation directory: $VERSION_DIR"
echo "Symlink: $JAI_PATH -> $VERSION_DIR"
echo ""
echo "Available versions in $JAI_COMPILERS_DIR:"
ls -1 "$JAI_COMPILERS_DIR"

if [ "$SHOW_BASHRC_SETUP_MESSAGE" = true ]; then
    echo ""
    echo "=========================================="
    echo "Setup Instructions:"
    echo "=========================================="
    echo "Add the following to your ~/.bashrc or ~/.bash_profile:"
    echo ""
    echo "  export JAI_ROOT=\"$JAI_ROOT\""
    echo "  export JAI_PATH=\"$JAI_PATH\""
    echo "  export PATH=\"\$JAI_PATH/bin:\$PATH\""
    echo ""
    echo "Then run: source ~/.bashrc"
    echo "=========================================="
fi

