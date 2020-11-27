/*[Dimensions]*/
$fn = 50;
inner_x = 125;
inner_y = 125;
wall_thickness = 4.0;
level_thickness = 1.6;
level_heights = [0, 30, 35, 60, 25];
level_retainer_protrusion = 1.6;
level_retainer_thickness = 1.6;
level_retainer_overflow = 1.6;
tolerence = 0.25;
outer_fillet = 1.6;
level_fillet= 1.6;
door_inner_thickness = 1;
door_dovetail_angle = 45;

/*[Calculated Dimensions]*/
intra_retainer_offset = 2 * level_retainer_thickness + level_thickness + 2 * tolerence;
inter_retainer_offset = level_retainer_thickness + level_thickness + 2 * tolerence;
inner_z = sum(level_heights) + (len(level_heights) - 1) * intra_retainer_offset - level_retainer_thickness;
outer_x = inner_x + 2 * (level_retainer_overflow + level_retainer_protrusion + tolerence + wall_thickness);
outer_y = inner_y + 2 * (level_retainer_overflow + level_retainer_protrusion + tolerence + wall_thickness);
outer_z = inner_z + 2 * wall_thickness;

function sum(v, num=-1, i=0, r=0) = (i<min(num, len(v))  || (i<len(v) && num==-1)) ? sum(v, num, i+1, r+v[i]) : r;

module level()
{
    linear_extrude(level_thickness)
    difference()
    {
        minkowski()
        {
            square([inner_x + 2 * (level_retainer_overflow + level_retainer_protrusion - level_fillet), 
                    inner_y + 2 * (level_retainer_overflow + level_retainer_protrusion - level_fillet)], true);
            circle(level_fillet);
        }
        square([inner_x, inner_y], true);
    }
}

module walls()
{
    translate([0, 0, outer_z / 2])
    difference()
    {
        minkowski()
        {
            cube([outer_x - 2 * outer_fillet, outer_y - 2 * outer_fillet, outer_z - 2 * outer_fillet], true);
            sphere(outer_fillet);
        }
        cube([outer_x - 2 * wall_thickness, outer_y - 2 * wall_thickness, inner_z], true);
    }
}

module level_retainers()
{
    translate([0, 0, wall_thickness])
    for(i = [1:len(level_heights) - 1])
    for(j = [0:1])
    if(level_heights[i - 1] != 0 || j != 0)
    translate([0, 0, sum(level_heights, i) + (i - 1) * intra_retainer_offset + j * inter_retainer_offset - level_retainer_thickness])
    linear_extrude(level_retainer_thickness)
    difference()
    {
        square([outer_x - 2 * wall_thickness, outer_y - 2 * wall_thickness], true);
        square([inner_x, inner_y], true);
        translate([0, - (inner_y + outer_y) / 2])
        square([outer_x, outer_y], true);
    }
}

module door(offset=0)
{
    translate([0, wall_thickness / 2 - door_inner_thickness - outer_x / 2 + wall_thickness / 2, outer_z / 2 + (wall_thickness + tolerence) / 2])
    hull()
    {
        translate([0, door_inner_thickness / 2 + offset / 2, 0])
        cube([outer_x - wall_thickness + 2 * offset / sin(door_dovetail_angle), door_inner_thickness + offset, outer_z - wall_thickness - tolerence + 2 * offset], true);
        translate([0, - (wall_thickness - door_inner_thickness) / 2 - offset, 0])
        cube([outer_x - wall_thickness - 2 * (wall_thickness - door_inner_thickness + offset) / tan(door_dovetail_angle) + 2 * offset / sin(door_dovetail_angle), 
              wall_thickness - door_inner_thickness, outer_z - wall_thickness - tolerence + 2 * offset], true);
    }
}

module case()
{
    union()
    {
        difference()
        {
            walls();
            door(tolerence);
        }
        intersection()
        {
            door();
            walls();
        }
        level_retainers();
        for(i = [1:len(level_heights) - 1])
        translate([0, 0, wall_thickness + tolerence + sum(level_heights, i) + (i - 1) * intra_retainer_offset])
        level();
    }
}

case();