#!/usr/bin/env bash

PROJECT_DIR=$1
PROJECT=$2

mkdir -p ${PROJECT_DIR}/{${PROJECT},docs,tests}
touch ${PROJECT_DIR}/{README.md,LICENSE.md,setup.py,requirements.txt,${PROJECT}/__init__.py}

