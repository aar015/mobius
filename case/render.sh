#!/bin/bash

OPENSCAD=/usr/bin/openscad

render()
{
    echo "Processing "${1}"..."
    file_name=parts/${1}.stl
    rm -f ${file_name}
    ${OPENSCAD} -o ${file_name} -D 'which_model="'${1}'"' \
    model.scad
}

render "body" & \
render "door" & \
render "network_rack" & \
render "power_rack" & \
render "nanopi_rack" & \
render "nanopi_mount" & \
render "topfan_rack"