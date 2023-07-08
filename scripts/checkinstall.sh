#!/bin/bash

echo "Checking if Aider is installed and in which mode ..."
echo ""
echo "Instructions for normal install:"
echo "pip install aider-chat"
echo ""
echo "Instructions for editable install:"
echo "cd /src && pip install -e ."
echo "Instructions for non editable install:"
echo "cd /src && pip install ."

# Check if a script named 'aider' is in the PATH
if which aider >/dev/null 2>&1; then
    echo "The 'aider' command is available."
    # Further checks for editable or regular mode could be done here
else
    echo "The 'aider' command is not installed."
    echo exit code: 1
    exit 1
fi

# Try to get the location of the package in site-packages
pkg_location=$(python -c "import os, aider; print(os.path.dirname(aider.__file__))" 2>/dev/null)

# Check if ${pkg_location} starts with /opt/venv/bin
if [[ ${pkg_location} == /opt/venv/bin* ]]; then
    echo "The 'aider' package is installed in regular mode."
    echo "exit code: 0"
    exit 0
else
    echo "The 'aider' package is installed in editable mode."
    echo "exit code: 2"
    exit 2
fi
