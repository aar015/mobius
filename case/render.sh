#!/bin/bash

OPENSCAD=/usr/bin/openscad

render()
{
    echo "Processing "${1}"..."
    file_name=stl/${2}.stl
    log_name=logs/${2}-log.txt
    rm -f ${file_name}
    rm -f ${log_name}
    ${OPENSCAD} -o ${file_name} -D 'model="'${1}'"' -D 'resolution="render"' &> ${log_name} model.scad
    echo "Finished "${1}"..."
}

render "bottom" "bottom_x1" & \
render "level-two" "level_one_x1" & \
render "level-four" "level_two_three_x2" & \
render "top" "top_x1" & \
render "front-wall" "wall_x3" & \
render "back-wall" "back_x1" & \
render "pi-mount" "mount_x4"
wait