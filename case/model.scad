/*[Global]*/
render_fn = 256;
viewport_fn = 64;
tolerence = 0.2;

/*[Body]*/
inner_x = 162.0;
inner_y = 167.2;
inner_z = 167.2;
wall_thickness = 3.6;

/*[Logo]*/
logo_outer = 115.2;
logo_inner = 28.8;
logo_stroke = 2.4;
logo_thickness = -wall_thickness - 0.1;
logo_honeycomb = true;
logo_honeycomb_fill = 34;
logo_offset = -6.0;

/*[Rack]*/
rack_support = 2.4;
rack_y = 101.4 + tolerence + rack_support;
rack_thickness = 3.6;
rack_wall_height = 0.6;

/*[Retainer]*/
retainer_thickness = 2.4;
retainer_protrusion = 2.4;

/*[Power Block]*/
power_x = 69.6;
power_y = 101.4;
power_z = 30;
power_lip = 4.8;
power_leg = 15.6;
power_hole_x = 26.4;
power_hole_z = 14.4;
power_hole_z_offset = -2.0;

/*[Portable SSD]*/
ssd_x = 9.2;
ssd_y = 101.4;
ssd_z = 30;
ssd_lip = 1.2;
ssd_leg = 15.6;
ssd_count = 4;

/*[2_5 Inch Drive]*/
drive_x = 69.6;
drive_y = 100.0;
drive_z = 21.6;

/*[Network Plug]*/
plug_x = 23.6;
plug_y = 43.2;
plug_z = 26.4;
plug_lip = 4.8;
plug_leg = 15.6;
plug_hole_x = 16.8;
plug_hole_z = 16.8;

/*[Network Switch]*/
switch_x = 100.4;
switch_y = 98.8;
switch_z = 25.6;
switch_lip = 6.8;
switch_leg = 15.6;
switch_hole_x = 12.0;
switch_hole_z = 14.4;
switch_hole_x_offset = -30.0;

/*[60mm Fan]*/
fan_y = tolerence + rack_support;
fan_z = 69.6;
fan_inner = 50;
fan_mount_thickness = 3.6;
fan_mount_small_thickness = 2.0;
fan_mount_large = 10.0;
fan_mount_small = 5.2;
fan_mount_support = 1.2;
fan_honeycomb_x = inner_x;
fan_honeycomb_z = 62.4;
fan_honeycomb_fill = 10;

/*[Honeycomb]*/
honeycomb_stroke = 1.2;

/*[pi]*/
pi_x = [16.8, 8.4];
pi_y = rack_y;
pi_z = fan_z - 2 * (rack_thickness + retainer_thickness + 2 * tolerence);
pi_count = 4;
pi_mount_y = 42;
pi_mount_z = 42;
pi_mount_thickness = 3.6;
pi_mount_support = 0.6;
pi_screw = 3;
pi_nut = 6.2;

/*[Rack Zero]*/
zero_z = wall_thickness + tolerence;

/*[Rack One]*/
one_z = zero_z + rack_thickness + drive_z + 2 * tolerence;

/*[Rack Two]*/
two_z = one_z + rack_thickness + max(power_z, drive_z, ssd_z) + 2 * tolerence;

/*[Rack Three]*/
three_z = two_z + rack_thickness + max(plug_z, switch_z) + 2 * tolerence;

/*[Rack Four]*/
four_z = three_z + (fan_z - pi_z) / 2;

/*[Rack Five]*/
five_z = four_z + rack_thickness + pi_z + 2 * tolerence;

/*[Rack Six]*/
six_z = three_z + rack_thickness + fan_z + 2 * tolerence;

/*[Calculated]*/
outer_x = inner_x + 2 * wall_thickness + 2 * retainer_protrusion + 4 * tolerence;
outer_y = inner_y + 2 * wall_thickness + 2 * tolerence;
outer_z = inner_z + 2 * wall_thickness + 2 * tolerence;
fan_mount_x = (fan_inner + fan_mount_large + 2 * tolerence + 2 * fan_mount_support);
fan_offset = (inner_x - 2 * fan_mount_x) / 3;
pi_offset = (inner_x - pi_count * (pi_x[0] + pi_x[1])) / (pi_count + 1);
top_z = outer_z - wall_thickness - (six_z + rack_thickness) - 2 * tolerence;
pi_mount_r = pi_nut / 2 + pi_mount_support + tolerence;
one_total_x = 2 * rack_support + 3 * tolerence + power_x + drive_x;
two_total_x = 3 * rack_support + 4 * tolerence + plug_x + switch_x;
ssd_total_x = (ssd_count + 1) * rack_support + ssd_count * (ssd_x + 2 * tolerence);
ssd_offset = (inner_x - 2 * rack_support - 2 * tolerence - power_x - ssd_total_x) / 2;

/*[Viewport]*/
which_model = "viewport"; //["viewport", "body", "door", "rack_one_ssd", "rack_one_drive", "rack_two", "rack_three_six", "rack_four", "rack_five", "fan_mount", "pi_mount"]

/*[Assertions]*/
assert(top_z > -101 * tolerence / 100);
assert(fan_offset > -0.01);
assert(pi_offset > -0.01);

module walls()
{
    translate([0, 0, wall_thickness])
    difference()
    {
        hull()
        for(i = [-1:2:1])
        for(j = [0:1])
        translate([i * (outer_x / 2 - wall_thickness), outer_y / 2, j * (outer_z - 2 * wall_thickness)])
        rotate(90, [1, 0, 0])
        cylinder(outer_y, r=wall_thickness);

        translate([0, 0, outer_z / 2 - wall_thickness])
        cube([outer_x - 2 * wall_thickness, outer_y - 2 * wall_thickness, outer_z - 2 * wall_thickness], true);
    }
}

module dovetail()
{
    polygon([[(outer_x - wall_thickness) / 2, wall_thickness], 
             [-(outer_x - wall_thickness) / 2, wall_thickness],
             [-(outer_x -  2 * wall_thickness) / 2, 0],
             [(outer_x -  2 * wall_thickness) / 2, 0]]);
}

module logo()
{
    difference()
    {
        rotate(90)
        circle(logo_outer, $fn=3);
        rotate(90)
        circle(logo_inner, $fn=3);
        for(i = [0:2])
        rotate(i * 120)
        translate([0, logo_outer])
        square(logo_outer - logo_inner, center=true);
        hull(){
            translate([logo_outer, logo_inner + sqrt(3) * logo_outer])
            circle(logo_stroke);
            translate([-logo_outer, logo_inner - sqrt(3) * logo_outer])
            circle(logo_stroke);
        }
        hull(){
            translate([0, logo_inner])
            circle(logo_stroke);
            translate([logo_outer, logo_inner - sqrt(3) * logo_outer])
            circle(logo_stroke);
        }
    }
}

module door()
{
    difference()
    {
        intersection()
        {
            linear_extrude(outer_z - wall_thickness - tolerence)
            dovetail();

            translate([0, outer_y / 2, - wall_thickness - tolerence])
            walls();
        }

        if(logo_thickness < 0)
        translate([0, -logo_thickness, outer_z / 2 + logo_offset])
        rotate(90, [1, 0, 0])
        intersection()
        {
            linear_extrude(-logo_thickness + 0.1)
            logo();

            if(logo_honeycomb)
            honeycomb([2 * logo_outer, 2 * logo_outer, -logo_thickness + 0.1], logo_honeycomb_fill);
        }
    }

    if(logo_thickness > 0)
    translate([0, 0, outer_z / 2])
    rotate(90, [1, 0, 0])
    linear_extrude(logo_thickness)
    logo();
}

module honeycomb(size, fill, stroke=honeycomb_stroke)
{
    r = (size[1] / fill - stroke) / sqrt(3);
    fill_x = 2 * floor(size[0] / (3 * r + sqrt(3) * stroke));
    true_x = fill_x * (3 * r + sqrt(3) * stroke) / 2;

    intersection()
    {
        translate([0, 0, size[2] / 2])
        cube([true_x, size[1], size[2]], true);

        for(i = [0:fill_x])
        for(j = [0:fill])
        translate([-true_x / 2 + i * sqrt(3) * (sqrt(3) * r + stroke) / 2, 
                -size[1] / 2 + j * (sqrt(3) * r + stroke) + (i % 2) * (sqrt(3) * r + stroke) / 2, 0])
        cylinder(size[2], r=r, $fn=6);
    }
}

module retainer()
{
    translate([0, 0, -retainer_thickness / 2 - tolerence])
    for(i = [-1:2:1])
    for(j = [0:1])
    translate([i * (outer_x / 2 - wall_thickness), tolerence, j * (rack_thickness + retainer_thickness + 2 * tolerence)])
    cube([2 * (retainer_protrusion + tolerence), inner_y + tolerence, retainer_thickness], true);
}

module body()
{
    difference()
    {
        walls();

        translate([0, -outer_y / 2, wall_thickness])
        linear_extrude(outer_z)
        offset(tolerence)
        dovetail();

        translate([0, outer_y / 2 + 0.1, wall_thickness + tolerence + rack_thickness + three_z + fan_z / 2])
        rotate(90, [1, 0, 0])
        honeycomb([fan_honeycomb_x, fan_honeycomb_z, wall_thickness + 0.2], fan_honeycomb_fill);

        translate([-one_total_x / 2 + rack_support + tolerence + power_x / 2, 
                   outer_y / 2 - wall_thickness / 2, 
                   one_z + rack_thickness + tolerence + power_z / 2 + power_hole_z_offset])
        cube([power_hole_x, wall_thickness + 1, power_hole_z], true);

        translate([-two_total_x / 2 + rack_support + tolerence + plug_x / 2, 
                   outer_y / 2 - wall_thickness / 2, 
                   two_z + rack_thickness + tolerence + plug_z / 2])
        cube([plug_hole_x, wall_thickness + 1, plug_hole_z], true);

        translate([-two_total_x / 2 + 2 * rack_support + 3 * tolerence + plug_x + switch_x / 2 + switch_hole_x_offset, 
                   outer_y / 2 - wall_thickness / 2, 
                   two_z + rack_thickness + tolerence + switch_z / 2])
        cube([switch_hole_x, wall_thickness + 1, switch_hole_z], true);
    }

    for(z = [zero_z, one_z, two_z, three_z, four_z, five_z, six_z])
    translate([0, 0, z])
    retainer();
}

module rack()
{
    difference()
    {
        hull()
        for(i = [-1:2:1])
        for(j = [0:1])
        translate([i * inner_x / 2, inner_y / 2 - j * rack_y + (2 * j - 1) * (retainer_protrusion + tolerence), 0])
        cylinder(rack_thickness, r=retainer_protrusion + tolerence);

        translate([0, (inner_y - rack_y) / 2, rack_thickness / 2])
        cube([inner_x - 2 * rack_support, rack_y - 2 * (retainer_protrusion + tolerence + rack_support), rack_thickness + 0.2], true);
    }

    for(i = [0:1])
    translate([inner_x / 2 - retainer_protrusion - i * (inner_x + tolerence), 0, 0])
    hull()
    {
        translate([0, inner_y / 2 - rack_y, 0])
        cube([tolerence + retainer_protrusion + rack_support, tolerence + retainer_protrusion + rack_support, rack_thickness]);

        translate([0, -inner_y / 2, 0])
        cube([tolerence + retainer_protrusion + rack_support, tolerence + retainer_protrusion + rack_support, rack_thickness]);
    }
}

module rack_zero()
{
    rack();
}

module rack_one()
{
    rack();

    translate([0, inner_y / 2 - power_y])
    {
        translate([-one_total_x / 2, 0, 0])
        {
            cube([2 * rack_support + tolerence, power_y, rack_thickness]);

            translate([0, -tolerence, 0])
            cube([rack_support, power_leg + tolerence, rack_thickness + rack_wall_height * power_z]);

            translate([0, power_y - power_leg, 0])
            cube([rack_support, power_leg, rack_thickness + rack_wall_height * power_z]);
        }

        translate([-one_total_x / 2 + power_x + tolerence, 0, 0])
        {
            cube([2 * rack_support + tolerence, power_y, rack_thickness]);

            translate([rack_support + tolerence, -tolerence, 0])
            cube([rack_support, power_leg + tolerence, rack_thickness + rack_wall_height * power_z]);

            translate([rack_support + tolerence, power_y - power_leg, 0])
            cube([rack_support, power_leg, rack_thickness + rack_wall_height * power_z]);
        }

        translate([-inner_x / 2, -rack_support - tolerence, 0])
        cube([inner_x, 2 * rack_support + tolerence, rack_thickness]);

        for(i = [0:1])
        translate([-one_total_x / 2 + i * (power_x - power_lip + tolerence + rack_support), -rack_support - tolerence, 0])
        cube([rack_support + tolerence + power_lip, rack_support, rack_thickness + rack_wall_height * power_z]);
    }

    *#translate([-one_total_x / 2 + rack_support + tolerence, inner_y / 2 - power_y, rack_thickness + tolerence])
    cube([power_x, power_y, power_z]);
}

module rack_one_ssd()
{
    rack_one();

    translate([0, inner_y / 2 - ssd_y])
    {
        translate([-one_total_x / 2 + power_x + rack_support + 2 * tolerence + ssd_offset, 0, 0])
        {
            cube([2 * rack_support + tolerence, ssd_y, rack_thickness]);

            translate([0, -tolerence, 0])
            cube([rack_support, ssd_leg + tolerence, rack_thickness + rack_wall_height * ssd_z]);

            translate([0, ssd_y - ssd_leg, 0])
            cube([rack_support, ssd_leg, rack_thickness + rack_wall_height * ssd_z]);
        }

        for(i = [1:ssd_count - 1])
        translate([-one_total_x / 2 + power_x + tolerence + ssd_offset + i * (ssd_x + rack_support + 2 * tolerence), 0, 0])
        {
            cube([3 * rack_support + 2 * tolerence, ssd_y, rack_thickness]);

            translate([rack_support + tolerence, -tolerence, 0])
            cube([rack_support, ssd_leg + tolerence, rack_thickness + rack_wall_height * ssd_z]);

            translate([rack_support + tolerence, ssd_y - ssd_leg, 0])
            cube([rack_support, ssd_leg, rack_thickness + rack_wall_height * ssd_z]);
        }

        translate([-one_total_x / 2 + power_x + tolerence + ssd_offset + ssd_count * (ssd_x + rack_support + 2 * tolerence), 0, 0])
        {
            cube([2 * rack_support + tolerence, ssd_y, rack_thickness]);

            translate([rack_support + tolerence, -tolerence, 0])
            cube([rack_support, ssd_leg + tolerence, rack_thickness + rack_wall_height * ssd_z]);

            translate([rack_support + tolerence, ssd_y - ssd_leg, 0])
            cube([rack_support, ssd_leg, rack_thickness + rack_wall_height * ssd_z]);
        }

        translate([-inner_x / 2, -rack_support - tolerence, 0])
        cube([inner_x, 2 * rack_support + tolerence, rack_thickness]);

        translate([-one_total_x / 2 + power_x + rack_support + 2 * tolerence + ssd_offset, -rack_support - tolerence, 0])
        cube([rack_support + tolerence + ssd_lip, rack_support, rack_thickness + rack_wall_height * ssd_z]);

        for(i = [1:ssd_count - 1])
        translate([-one_total_x / 2 + power_x + tolerence + rack_support - ssd_lip + ssd_offset + i * (rack_support + 2 * tolerence + ssd_x), -rack_support - tolerence, 0])
        cube([rack_support + 2 * tolerence + 2 * ssd_lip, rack_support, rack_thickness + rack_wall_height * ssd_z]);

        translate([-one_total_x / 2 + power_x + tolerence + rack_support - ssd_lip + ssd_offset + ssd_count * (rack_support + 2 * tolerence + ssd_x), -rack_support - tolerence, 0])
        cube([rack_support + tolerence + ssd_lip, rack_support, rack_thickness + rack_wall_height * ssd_z]);
    }

    *#for(i = [1:ssd_count])
    translate([-one_total_x / 2 + (i + 1) * rack_support + (2 * i + 1) * tolerence + power_x + (i - 1) * ssd_x + ssd_offset,
               inner_y / 2 - ssd_y, rack_thickness + tolerence])
    cube([ssd_x, ssd_y, ssd_z]);
}

module rack_one_drive()
{
    rack_one();

    *#translate([-one_total_x / 2 + 2 * rack_support + 3 * tolerence + power_x, inner_y / 2 - drive_y, rack_thickness + tolerence])
    cube([drive_x, drive_y, drive_z]);
}

module rack_two()
{
    rack();

    translate([0, inner_y / 2 - plug_y])
    {
        translate([-two_total_x / 2, 0, 0])
        {
            cube([2 * rack_support + tolerence, plug_y, rack_thickness]);

            translate([0, -tolerence, 0])
            cube([rack_support, plug_leg + tolerence, rack_thickness + rack_wall_height * plug_z]);

            translate([0, plug_y - plug_leg, 0])
            cube([rack_support, plug_leg, rack_thickness + rack_wall_height * plug_z]);
        }

        translate([-two_total_x / 2 + plug_x + tolerence, 0, 0])
        {
            cube([2 * rack_support + tolerence, plug_y, rack_thickness]);

            translate([rack_support + tolerence, -tolerence, 0])
            cube([rack_support, plug_leg + tolerence, rack_thickness + rack_wall_height * plug_z]);

            translate([rack_support + tolerence, plug_y - plug_leg, 0])
            cube([rack_support, plug_leg, rack_thickness + rack_wall_height * plug_z]);
        }

        translate([-inner_x / 2, -rack_support - tolerence, 0])
        cube([inner_x, 2 * rack_support + tolerence, rack_thickness]);

        for(i = [0:1])
        translate([-two_total_x / 2 + i * (plug_x - plug_lip + tolerence + rack_support), -rack_support - tolerence, 0])
        cube([rack_support + tolerence + plug_lip, rack_support, rack_thickness + rack_wall_height * plug_z]);
    }

    translate([plug_x + 2 * tolerence + rack_support, inner_y / 2 - switch_y])
    {
        translate([-two_total_x / 2, 0, 0])
        {
            cube([2 * rack_support + tolerence, switch_y, rack_thickness]);

            translate([0, -tolerence, 0])
            cube([rack_support, switch_leg + tolerence, rack_thickness + rack_wall_height * switch_z]);

            translate([0, switch_y - switch_leg, 0])
            cube([rack_support, switch_leg, rack_thickness + rack_wall_height * switch_z]);
        }

        translate([-two_total_x / 2 + switch_x + tolerence, 0, 0])
        {
            cube([2 * rack_support + tolerence, switch_y, rack_thickness]);

            translate([rack_support + tolerence, -tolerence, 0])
            cube([rack_support, switch_leg + tolerence, rack_thickness + rack_wall_height * switch_z]);

            translate([rack_support + tolerence, switch_y - switch_leg, 0])
            cube([rack_support, switch_leg, rack_thickness + rack_wall_height * switch_z]);
        }

        translate([-inner_x / 2 - plug_x - 2 * tolerence - rack_support, -rack_support - tolerence, 0])
        cube([inner_x, 2 * rack_support + tolerence, rack_thickness]);

        for(i = [0:1])
        translate([-two_total_x / 2 + i * (switch_x - switch_lip + tolerence + rack_support), -rack_support - tolerence, 0])
        cube([rack_support + tolerence + switch_lip, rack_support, rack_thickness + rack_wall_height * switch_z]);
    }
}

module fan_mount()
{
    r = fan_mount_large / 2 + fan_mount_support + tolerence;

    for(i = [-1:2:1])
    for(j = [-1:2:1])
    translate([i * fan_inner / 2, j * fan_inner / 2, 0])
    {
        difference()
        {
            union()
            {
                cylinder(fan_mount_thickness, r=r);

                translate([-i * fan_inner / 4, 0, fan_mount_thickness / 2])
                cube([fan_inner / 2, 2 * r, fan_mount_thickness], true);

                translate([0, -j * fan_inner / 4, fan_mount_thickness / 2])
                cube([2 * r, fan_inner / 2, fan_mount_thickness], true);
                
                translate([0, j * (fan_z - fan_inner + 2 * tolerence  + rack_thickness) / 4, fan_mount_thickness / 2])
                cube([2 * r, (fan_z - fan_inner + 2 * tolerence + rack_thickness) / 2, fan_mount_thickness], true);
            }

            translate([0, 0, -0.5])
            cylinder(fan_mount_thickness + 1, r=fan_mount_small / 2 + tolerence);

            translate([0, 0, fan_mount_small_thickness])
            cylinder(fan_mount_thickness - fan_mount_small_thickness + 1, r=fan_mount_large / 2 + tolerence);
        }
    }
}

module rack_three_six()
{
    difference()
    {
        union()
        {
            rack();

            fill_y = 2 * (tolerence + rack_support) + fan_mount_thickness;
            translate([0, inner_y / 2 - fill_y / 2 - fan_y + tolerence + rack_support, rack_thickness / 2])
            cube([inner_x, fill_y, rack_thickness], true);
        }

        r = fan_mount_large / 2 + fan_mount_support + tolerence;
        for(i = [0:1])
        for(j = [0:1])
        translate([-inner_x / 2 + r + fan_offset + i * (fan_mount_x + fan_offset) + j * fan_inner, 
                   inner_y / 2 - fan_mount_thickness / 2 - fan_y, 3 * rack_thickness / 4])
        cube([2 * (r + tolerence), fan_mount_thickness + 2 * tolerence, rack_thickness / 2 + 2 * tolerence], true);
    }
}

module pi_mount()
{
    r = pi_mount_r;

    for(i = [0:1])
    for(j = [-1:2:1])
    rotate(i * 180, [1, 0, 0])
    translate([(pi_x[0] - pi_x[1]) / 2, j * pi_mount_y / 2, pi_mount_z / 2])
    difference()
    {
        union()
        {
            rotate(90, [0, 1, 0])
            cylinder(pi_mount_thickness, r=r);

            translate([pi_mount_thickness / 2, 0, (pi_z - pi_mount_z) / 4 + tolerence / 2 + rack_thickness / 4])
            cube([pi_mount_thickness, 2 * r, (pi_z - pi_mount_z) / 2 + tolerence + rack_thickness / 2], true);

            translate([pi_mount_thickness / 2, j * 3 * r / 3, 0])
            cube([pi_mount_thickness, 2 * r, 2 * r], true);

            translate([pi_mount_thickness / 2, -j * pi_mount_y / 4, 3 * r / 2])
            cube([pi_mount_thickness, pi_mount_y / 2, r], true);

            translate([pi_mount_thickness / 2, 3 * j * r / 2, -pi_mount_z / 4])
            cube([pi_mount_thickness, r, pi_mount_z / 2], true);
        }

        rotate(90, [0, 1, 0])
        {
            translate([0, 0, -0.1])
            cylinder(pi_mount_thickness + 0.2, r=pi_screw / 2 + tolerence);

            translate([0, 0, pi_mount_thickness / 2])
            cylinder(pi_mount_thickness / 2 + 0.1, r=pi_nut / 2 + tolerence, $fn=6);
        }
    }

    *cube([pi_x[0] + pi_x[1], pi_mount_y, pi_mount_z], true);
}

module pi_rack() 
{
    for(i = [0:1])
    translate([inner_x / 2 - retainer_protrusion - i * (inner_x + tolerence), -inner_y / 2, 0])
    cube([tolerence + retainer_protrusion + rack_support, inner_y, rack_thickness]);

    for(i = [0:1])
    translate([-inner_x / 2, inner_y / 2 - pi_y + pi_mount_r - tolerence - rack_support + i * pi_mount_y, 0])
    cube([inner_x, 2 * (pi_mount_r + tolerence + rack_support), rack_thickness]);

    translate([0, (inner_y + tolerence + retainer_protrusion + rack_support) / 2 - pi_y, rack_thickness / 2])
    cube([inner_x, tolerence + retainer_protrusion + rack_support, rack_thickness], true);
}

module rack_four()
{
    difference()
    {
        pi_rack();

        for(i = [0:pi_count - 1])
        for(j = [0:1])
        translate([-inner_x / 2 + pi_offset + pi_x[0] - tolerence + i * (pi_offset + pi_x[0] + pi_x[1]),
                   inner_y / 2 - pi_y + pi_mount_r - tolerence + j * pi_mount_y, 
                   rack_thickness / 2 - tolerence])
        cube([pi_mount_thickness + 2 * tolerence, 2 * (pi_mount_r + tolerence), rack_thickness]);
    }
}

module rack_five()
{
    difference()
    {
        pi_rack();

        for(i = [0:pi_count - 1])
        for(j = [0:1])
        translate([-inner_x / 2 + pi_offset + pi_x[0] - tolerence + i * (pi_offset + pi_x[0] + pi_x[1]),
                   inner_y / 2 - pi_y + pi_mount_r - tolerence + j * pi_mount_y, 
                   -rack_thickness / 2 + tolerence])
        cube([pi_mount_thickness + 2 * tolerence, 2 * (pi_mount_r + tolerence), rack_thickness]);
    }
}

if (which_model == "viewport")
{
    $fn = viewport_fn;

    echo(str("External Dimensions = ", [outer_x, outer_y, outer_z]));
    echo(str("Top Cuby Height = ", top_z));

    body();

    translate([0, -outer_y / 2, wall_thickness + tolerence])
    door();

    translate([0, 0, zero_z])
    rack_zero();

    translate([0, 0, one_z])
    rack_one_ssd();

    translate([0, 0, two_z])
    rack_two();

    translate([0, 0, three_z])
    rack_three_six();

    translate([0, 0, four_z])
    rack_four();

    translate([0, 0, five_z])
    rack_five();

    translate([0, 0, six_z + rack_thickness])
    rotate(180, [0, 1, 0])
    rack_three_six();

    for(i = [0:1])
    translate([fan_mount_x / 2 - inner_x / 2 + fan_offset + i * (fan_mount_x + fan_offset), 
               inner_y / 2 - fan_mount_thickness - fan_y, 
               rack_thickness + three_z + fan_z / 2 + tolerence])
    rotate(-90, [1, 0, 0])
    fan_mount();

    for(i = [0:pi_count - 1])
    translate([(pi_x[0] + pi_x[1]) / 2 - inner_x / 2 + pi_offset + i * (pi_x[0] + pi_x[1] + pi_offset),
                inner_y / 2 + pi_mount_y / 2 + pi_nut + 2 * pi_mount_support + 2 * tolerence - pi_y, 
                rack_thickness + four_z + pi_z / 2 + tolerence])
    pi_mount();
}
else
{
    $fn = render_fn;

    if (which_model == "body")
    rotate(90, [0, 0, 1])
    translate([outer_z / 2, 0, outer_y / 2])
    rotate(-90, [0, 1, 0])
    rotate(90, [0, 0, 1])
    body();

    else if (which_model == "door")
    translate([0, -(outer_z - wall_thickness - tolerence) / 2, wall_thickness])
    rotate(-90, [1, 0, 0])
    door();

    else if (which_model == "rack_zero")
    rack_zero();

    else if (which_model == "rack_one_ssd")
    rack_one_ssd();

    else if (which_model == "rack_one_drive")
    rack_one_drive();

    else if (which_model == "rack_two")
    rack_two();

    else if (which_model == "rack_three_six")
    rack_three_six();

    else if (which_model == "rack_four")
    rack_four();

    else if (which_model == "rack_five")
    translate([0, 0, rack_thickness])
    rotate(180, [0, 1, 0])
    rack_five();

    else if (which_model == "fan_mount")
    fan_mount();

    else if (which_model == "pi_mount")
    translate([0, 0, -(pi_x[0] - pi_x[1]) / 2])
    rotate(-90, [0, 1, 0])
    pi_mount();
}