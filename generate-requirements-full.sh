#!/bin/bash
python3 -m pip install --quiet --upgrade pip
python3 -m pip install --quiet pip-tools 
pip-compile --quiet \
            --generate-hashes \
            --pip-args='--prefer-binary' \
            --output-file=requirements-full.txt \
            requirements-core.txt
