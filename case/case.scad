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
tolerence = 0.3;
case_fillet = 5;
level_fillet= 5;

/*[Calculated Dimensions]*/
inner_z = sum(level_heights) + (len(level_heights) - 1) * (2 * level_retainer_thickness + level_thickness + 2 * tolerence) - level_retainer_thickness;
outer_x = inner_x + 2 * (level_retainer_overflow + level_retainer_protrusion + tolerence + wall_thickness);
outer_y = inner_y + 2 * (level_retainer_overflow + level_retainer_protrusion + tolerence + wall_thickness);
outer_z = inner_z + 2 * wall_thickness;

function sum(v, num=-1, i=0, r=0) = (i<min(num, len(v))  || (i<len(v) && num==-1)) ? sum(v, num, i+1, r+v[i]) : r;

module base()
{
    linear_extrude(wall_thickness)
    square([outer_x, outer_y], true);
}

module level()
{
    linear_extrude(level_thickness)
    difference()
    {
        minkowski()
        {
            square([inner_x, inner_y], true);
            circle(level_retainer_overflow + level_retainer_protrusion);
        }
        square([inner_x, inner_y], true);
    }
}

module side_wall()
{
    rotate(180, [0, 0, 1])
    translate([0, - outer_y / 2, 0])
    rotate(-90, [0, 1, 0])
    union()
    {
        linear_extrude(wall_thickness)
        square([inner_z, outer_y]);
        linear_extrude(wall_thickness + level_retainer_protrusion)
        for(i = [1:len(level_heights) - 1])
        for(j = [0:1])
        if(level_heights[i - 1] !=0 || j !=0)
        translate([sum(level_heights, i) - level_retainer_thickness +
                   (i - 1) * (2 * level_retainer_thickness + level_thickness + 2 * tolerence) +
                   j * (level_retainer_thickness + level_thickness + 2 * tolerence),
                   wall_thickness + level_retainer_protrusion + level_retainer_overflow + tolerence])
        square([level_retainer_thickness, inner_y]);
    }
}

module case()
{
    union()
    {
        base();

        for(i = [0:180:180])
        rotate(i, [0, 0, 1])
        translate([-outer_x / 2, 0, wall_thickness])
        side_wall();

        translate([0, 0, outer_z])
        rotate(180, [1, 0, 0])
        base();
    }
}

*case();

difference()
{
    minkowski()
    {
        cube([outer_x - 2 * case_fillet, outer_y - 2 * case_fillet, outer_z - 2 * case_fillet], true);
        sphere(case_fillet);
    }
    cube([inner_x + 2 * (level_retainer_overflow + level_retainer_protrusion + tolerence),
          inner_y + 2 * (level_retainer_overflow + level_retainer_protrusion + tolerence), 
          inner_z], true);
    translate([0, - outer_y / 2 + 5, 0])
    cube([outer_x, 10, outer_z], true);
}