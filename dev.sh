#!/bin/bash
# make sure we are not in the production environment

echo "Starting Aider development version ..."
pip install -e .
aider
