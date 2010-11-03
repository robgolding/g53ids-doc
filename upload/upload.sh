#!/bin/bash

DIR=`dirname $0`

java -jar $DIR/google-docs-upload-1.3.2.jar $1 \
    --username rob@robgolding.com \
    --remote-folder University/Dissertation \
    --replace-all --password
