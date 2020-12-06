#!/bin/bash

OPENSCAD=/usr/bin/openscad

render()
{
    echo "Processing "${1}"..."
    file_name=stl/${1}.stl
    rm -f ${file_name}
    ${OPENSCAD} -o ${file_name} -D 'which_model="'${1}'"' \
    model.scad
}

render "network_rack" & \
render "power_rack" & \
render "nanopi_rack" & \
render "topfan_rack" & \
render "door" & \
render "body"