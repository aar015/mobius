/*[Dimensions]*/
$fn = 50;
inner_x = 125;
inner_y = 125;
base_thickness = 3.2;
wall_thickness = 1.6;
wall_overflow = 1.6;
level_thickness = 1.6;
level_heights = [2.7, 30, 35, 10, 60, 25];
level_wing = 1.6;
level_wing_thickness = 1.6;
level_wing_overflow = 1.6;
tolerence = 0.3;
assert(level_heights[0] >= level_wing_thickness + level_thickness / 2 + tolerence);

function sum(v, num=-1, i=0, r=0) = (i<min(num, len(v))  || (i<len(v) && num==-1)) ? sum(v, num, i+1, r+v[i]) : r;

module base()
{
    linear_extrude(base_thickness)
    minkowski()
    {
        square([inner_x, inner_y], true);
        circle(level_wing + wall_thickness + wall_overflow);
    }
}

module level()
{
    linear_extrude(level_thickness)
    difference()
    {
        minkowski()
        {
            square([inner_x, inner_y], true);
            circle(level_wing + level_wing_overflow);
        }
        square([inner_x, inner_y], true);
    }
}

module side_wall()
{
    translate([-wall_thickness / 2, 0, 0])
    rotate(90, [0, 1, 0])
    union()
    {
        linear_extrude(wall_thickness)
        square([sum(level_heights), inner_y], true);
        linear_extrude(wall_thickness + level_wing)
        for(i = [1:len(level_heights) - 1])
        for(j = [-1:2:1])
        translate([sum(level_heights) / 2 - sum(level_heights, i) + j * ((level_thickness + level_wing_thickness) / 2 + tolerence), 0])
        square([level_wing_thickness, inner_y], true);
    }
}

base();

for(i = [0:180:180])
rotate(i, [0, 0, 1])
translate([-inner_x / 2 - level_wing - wall_thickness / 2, 0, sum(level_heights) / 2 + base_thickness + tolerence])
side_wall();

translate([0, 0, sum(level_heights) + 2 * base_thickness + 2 * tolerence])
rotate(180, [1, 0, 0])
base();