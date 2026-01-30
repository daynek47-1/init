#!/bin/bash

SETUP_SCRIPT="./setup.sh"

echo "Running tests for $SETUP_SCRIPT"

# Check for Gemini CLI installation logic
if grep -q "npm install -g @google/gemini-cli" "$SETUP_SCRIPT"; then
  echo "PASS: Gemini CLI installation command found in $SETUP_SCRIPT."
else
  echo "FAIL: Gemini CLI installation command NOT found in $SETUP_SCRIPT."
  exit 1
fi

echo "All setup.sh tests passed."