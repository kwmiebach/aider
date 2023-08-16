#!/bin/bash

SOURCE_DIR=/src

echo "Checking if Aider is installed and in which mode ..."
echo ""

# Check if a script named 'aider' is in the PATH
if which aider >/dev/null 2>&1; then
    echo "The 'aider' command is already available."
    # Further checks for editable or regular mode see below
else
    echo "The 'aider' command is not installed. Installing for development in $SOURCE_DIR ..."
    cd $SOURCE_DIR
    pip install -e .
    echo "... done."
    echo "The aider package was installed in editable mode. Any changes made to"
    echo "the source will be directly reflected without needing a reinstall."
    exit 0
fi

# Get the location of the aider package in site-packages
pkg_location=$(python -c "import os, aider; print(os.path.dirname(aider.__file__))" 2>/dev/null)
echo "Package location: ${pkg_location}"

# Check if ${pkg_location} starts with /opt/venv/bin
if [[ ${pkg_location} == /opt/venv/bin* ]]; then
    echo "Error: the 'aider' package is already installed in regular mode."
    echo "exit code: 1"
    exit 1
else
    echo "The 'aider' package is already installed in development mode."
    echo "exit code: 0"
    exit 0
fi
