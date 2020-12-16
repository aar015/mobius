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

render "body" & \
render "door" & \
render "rack_zero" & \
render "rack_one_ssd" & \
render "rack_one_drive" & \
render "rack_two" & \
render "rack_three_six" & \
render "rack_four" & \
render "rack_five" & \
render "fan_mount" & \
render "pi_mount"