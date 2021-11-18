/* [Globals] */
model = "all"; // ["all", "top", "bottom", "front-wall", "back-wall", "left-wall", "right-wall", "level-two", "level-three", "level-four", "pi-mount"]
tolerence = 0.2; // [0.1:0.05:0.5]
resolution = "viewport"; // ["viewport", "render"]
viewport_fn = 64;
render_fn = 512;

/* [Walls] */
wall_thickness = 7.2;
wall_bracket_thickness = 3.6;
wall_bracket_z = 10;
wall_screw = 3;
wall_screw_head = 6;
wall_screw_head_thickness = 1.6;
wall_nut = 6.2;

/* [Levels] */
inner_x = 185.2;
inner_y = 185.2;
level_thickness = 2.4;
level_support = 2.4;
level_wall_z = 0.6;
level_one_z = 30;
level_two_z = 30;
level_three_z = 65;
level_four_z = 20;
inner_z = level_one_z + level_two_z + level_three_z + level_four_z + 3 * level_thickness;
outer_x = inner_x + 2 * wall_thickness;
outer_y = inner_y + 2 * wall_thickness;
outer_z = inner_z + 2 * wall_thickness;
level_screw = 3;
level_screw_head = 6;
level_screw_head_thickness = 1.6;
level_rod = 4.8;
working_x = inner_x - 2 * wall_bracket_thickness - wall_bracket_z - level_rod;
working_y = inner_y - 2 * wall_bracket_thickness - wall_bracket_z - level_rod;

/* [Power Block] */
power_x = 69.6;
power_y = 101.4;
power_z = 30;
power_lip = 4.8;
power_leg = 15.6;
power_hole_x = 26.4;
power_hole_z = 14.4;
power_hole_z_offset = -2.0;

/*[Network Plug]*/
plug_x = 23.6;
plug_y = 43.2;
plug_z = 26.4;
plug_lip = 4.8;
plug_leg = 15.6;
plug_hole_x = 16.8;
plug_hole_z = 16.8;

/* [Portable SSD] */
ssd_x = 9.2;
ssd_y = 101.4;
ssd_z = 30;
ssd_lip = 1.2;
ssd_leg = 15.6;
ssd_count = 3;

/*[Network Switch]*/
switch_x = 100.4;
switch_y = 98.8;
switch_z = 26.4;
switch_lip = 6.8;
switch_leg = 15.6;
switch_y_offset = 18.0;

/*[2_5 Inch Drive]*/
drive_x = 69.6;
drive_y = 100.0;
drive_z = 9.6;
drive_screw = 3;
drive_inner_x = 61.6;
drive_inner_y = 76.6;

/* [Pi] */
pi_x = [16.8, 8.4];
pi_y = 92.0;
pi_count = 4;
pi_mount_y = 42;
pi_mount_z = 42;
pi_mount_thickness = 2.4;
pi_mount_support = -0.01;
pi_screw = 3;
pi_nut = 6.2;
pi_offset = (working_x - pi_count * (pi_x[0] + pi_x[1])) / (pi_count + 1);
pi_mount_r = pi_nut / 2 + pi_mount_support + tolerence;

/* [60mm Fan] */
fan_thickness = 25.2;
fan_inner = 50;
fan_outer = 60;
fan_x_sep = 25.2;
fan_y_sep = 25.2;
fan_mount_thickness = 2.0;
fan_mount_large = 10.0;
fan_mount_small = 5.2;
fan_mount_support = 1.2;

/* [Fan Controller] */
ctrl_x = 60.8;
ctrl_y = 20.4;
ctrl_z = 16.8;
ctrl_hole = 16;

/* [Handle] */
handle_z = 32.2;
handle_mount_z = 13.2;
handle_screw = 3.8;
handle_mount_support = 2.4;
handle_mount_x = 128.4;

/* [Window] */
window_x = 178;
window_y = 127;
window_padding = 4.8;
window_inner_x = window_x - 2 * window_padding;
window_inner_y = window_y - 2 * window_padding;
window_screw = 3;
window_nut = 6.2;
window_bracket_thicknes = 4.8;
window_bracket_l = 2 * window_padding + 2 * tolerence;

/* [Slats] */
slat_width = 2.4;
slat_sep = 7.2;
slat_num = 2;

/* [Level One] */
bottom_x = power_x + plug_x + 3 * level_support + 4 * tolerence + ssd_count * (ssd_x + level_support + 2 * tolerence);

/* [Level Two] */
level_two_x = switch_x + drive_x + 2 * level_support + 4 * tolerence;

module wall_bracket()
{
    translate([0, 0, wall_bracket_thickness / 2])
    difference()
    {
        cube([wall_bracket_z, wall_bracket_z, wall_bracket_thickness], true);
        union()
        {
            translate([0, 0, -wall_bracket_thickness / 2 - 0.1])
            cylinder(wall_bracket_thickness + 0.2, r=wall_screw / 2 + tolerence, $fn=render_fn);
            cylinder(wall_bracket_thickness / 2 + 0.1, r=wall_nut / 2 + tolerence, $fn=6);
        }
    }
}

module window_bracket()
{
    translate([0, 0, window_bracket_thicknes / 2])
    difference()
    {
        cube([window_bracket_l, window_bracket_l, window_bracket_thicknes], true);
        union()
        {
            translate([0, 0, -window_bracket_thicknes / 2 - 0.1])
            cylinder(window_bracket_thicknes + 0.2, r=window_screw / 2 + tolerence, $fn=render_fn);
            cylinder(window_bracket_thicknes / 2 + 0.1, r=window_nut / 2 + tolerence, $fn=6);
        }
    }
}

module top_bottom()
{
    difference()
    {
        translate([0, 0, wall_thickness / 2])
        {   
            difference()
            {
                hull()
                {
                    cube([inner_x, inner_y, wall_thickness], true);
                    translate([0, 0, -wall_thickness / 2 - 0.5])
                    cube([outer_x, outer_y, 1], true);
                }

                translate([0, 0, -wall_thickness / 2 - 1])
                cube([outer_x + 1, outer_y + 1, 2], true);
            }

            for(i = [0:180:180])
            rotate(i, [0, 0, 1])
            for(j = [-1:2:1])
            translate([inner_x / 2,
                    j * ((inner_y - wall_bracket_z) / 2 - wall_bracket_thickness),
                    (wall_bracket_z + wall_thickness) / 2 - tolerence])
            rotate(-90, [0, 1, 0])
            wall_bracket();

            for(i = [0:180:180])
            rotate(i, [0, 0, 1])
            for(j = [-1:2:1])
            translate([j * ((inner_x - wall_bracket_z) / 2 - wall_bracket_thickness),
                    inner_y / 2,
                    (wall_bracket_z + wall_thickness) / 2 - tolerence])
            rotate(90, [1, 0, 0])
            wall_bracket();
        }

        for(i = [-1:2:1])
        for(j = [-1:2:1])
        translate([i * (inner_x / 2 - wall_bracket_z / 2 - wall_bracket_thickness), 
                   j * (inner_y / 2 - wall_bracket_z / 2 - wall_bracket_thickness), 0])
        {
            translate([0, 0, -0.5])
            cylinder(wall_thickness + 1, r=level_screw / 2 + tolerence);
            translate([0, 0, -1])
            cylinder(level_screw_head_thickness + 1, r=level_screw_head / 2 + tolerence);
        }
    }

    for(i = [0:90:270])
    rotate(i, [0, 0, 1])
    translate([inner_x / 2 - wall_bracket_thickness, inner_y / 2 - wall_bracket_thickness, wall_thickness - tolerence])
    intersection()
    {
        cylinder(wall_bracket_z, r=wall_bracket_thickness);
        cube(wall_bracket_z);
    }
}

module top()
{   
    difference()
    {
        union()
        {
            top_bottom();

            for(i = [-1:2:1])
            translate([i * handle_mount_x / 2, 0, 0])
            cylinder(handle_mount_z, r=handle_screw / 2 + tolerence + handle_mount_support);
        }

        for(i = [-1:2:1])
        translate([i * handle_mount_x / 2, 0, -0.5])
        cylinder(handle_mount_z + 1, r=handle_screw / 2 + tolerence);

        for(i = [0:slat_num])
        for(j = [-1:2:1])
        translate([0, outer_y / 4 + i * j * (slat_width / 2 + slat_sep), wall_thickness / 2])
        cube([working_x, slat_width, wall_thickness + 1], true);
    }
}

module power_cradle()
{
  
    cube([2 * level_support + tolerence, power_y, level_thickness]);

    translate([0, -tolerence, 0])
    cube([level_support, power_leg + tolerence, level_thickness + level_wall_z * level_one_z]);

    translate([0, power_y - power_leg, 0])
    cube([level_support, power_leg, level_thickness + level_wall_z * level_one_z]);

    translate([power_x + tolerence, 0, 0])
    {
        cube([2 * level_support + tolerence, power_y, level_thickness]);

        translate([level_support + tolerence, -tolerence, 0])
        cube([level_support, power_leg + tolerence, level_thickness + level_wall_z * level_one_z]);

        translate([level_support + tolerence, power_y - power_leg, 0])
        cube([level_support, power_leg, level_thickness + level_wall_z * level_one_z]);
    }

    translate([0, -level_support - tolerence, 0])
    cube([power_x + 2 * level_support + 2 * tolerence, 2 * level_support + tolerence, level_thickness]);

    for(i = [0:1])
    translate([i * (power_x - power_lip + tolerence + level_support), -level_support - tolerence, 0])
    cube([level_support + tolerence + power_lip, level_support, level_thickness + level_wall_z * level_one_z]);
}

module plug_cradle()
{
    cube([2 * level_support + tolerence, plug_y, level_thickness]);

    translate([0, -tolerence, 0])
    cube([level_support, plug_leg + tolerence, level_thickness + level_wall_z * level_one_z]);

    translate([0, plug_y - plug_leg, 0])
    cube([level_support, plug_leg, level_thickness + level_wall_z * level_one_z]);

    translate([plug_x + tolerence, 0, 0])
    {
        cube([2 * level_support + tolerence, plug_y, level_thickness]);

        translate([level_support + tolerence, -tolerence, 0])
        cube([level_support, plug_leg + tolerence, level_thickness + level_wall_z * level_one_z]);

        translate([level_support + tolerence, plug_y - plug_leg, 0])
        cube([level_support, plug_leg, level_thickness + level_wall_z * level_one_z]);
    }

    translate([0, -level_support - tolerence, 0])
    cube([plug_x + 2 * level_support + 2 * tolerence, 2 * level_support + tolerence, level_thickness]);

    for(i = [0:1])
    translate([i * (plug_x - plug_lip + tolerence + level_support), -level_support - tolerence, 0])
    cube([level_support + tolerence + plug_lip, level_support, level_thickness + level_wall_z * level_one_z]);
}

module ssd_cradle()
{
    for (i = [0:ssd_count - 1])
    translate([i * (ssd_x + level_support + 2 * tolerence), 0, 0])
    {
        cube([2 * level_support + tolerence, ssd_y, level_thickness]);

        translate([0, -tolerence, 0])
        cube([level_support, ssd_leg + tolerence, level_thickness + level_wall_z * level_one_z]);

        translate([0, ssd_y - ssd_leg, 0])
        cube([level_support, ssd_leg + tolerence, level_thickness + level_wall_z * level_one_z]);

        translate([ssd_x + tolerence, 0, 0])
        {
            cube([2 * level_support + tolerence, ssd_y, level_thickness]);

            translate([level_support + tolerence, -tolerence, 0])
            cube([level_support, ssd_leg + tolerence, level_thickness + level_wall_z * level_one_z]);

            translate([level_support + tolerence, ssd_y - ssd_leg, 0])
            cube([level_support, ssd_leg + tolerence, level_thickness + level_wall_z * level_one_z]);
        }

        for(i = [0:1])
        translate([0, i * (power_y + level_support + 2 * tolerence), 0])
        {
            translate([0, - (i + 1) * (level_support + tolerence), 0])
            cube([ssd_x + 2 * level_support + 2 * tolerence, 2 * level_support + tolerence, level_thickness]);

            for(j = [0:1])
            translate([j * (ssd_x - ssd_lip + tolerence + level_support), -level_support - tolerence, 0])
            cube([level_support + tolerence + ssd_lip, level_support, level_thickness + level_wall_z * level_one_z]);
        }
    }
}

module bottom()
{
    top_bottom();

    translate([0, 0, wall_thickness - level_thickness])
    {
        translate([-bottom_x / 2, inner_y / 2 - power_y, 0])
        power_cradle();

        translate([-bottom_x / 2 + power_x + level_support + 2 * tolerence, inner_y / 2 - plug_y, 0])
        plug_cradle();

        translate([-bottom_x / 2 + power_x + plug_x + 2 * level_support + 4 * tolerence, inner_y / 2 - ssd_y - level_support - tolerence, 0])
        ssd_cradle();

        translate([-working_x / 2, inner_y / 2 - ssd_y - 2 * level_thickness - 2 * tolerence, 0])
        cube([working_x, 3 * level_thickness + 2 * tolerence, level_thickness]);
    }
}

module front_back_wall()
{
    difference()
    {
        hull()
        {
            translate([0, 0, wall_thickness / 2])
            cube([inner_x, inner_z, wall_thickness], true);
            translate([0, 0, -0.5])
            cube([outer_x, outer_z, 1], true);
        }
        translate([0, 0, -1])
        cube([outer_x + 1, outer_z + 1, 2], true);

        for(i = [-1:2:1])
        for(j = [-1:2:1])
        translate([i * (inner_x / 2 - wall_bracket_z / 2 - wall_bracket_thickness),
                   j * (inner_z / 2 - wall_bracket_z / 2 + tolerence), 0])
        {
            translate([0, 0, -0.5])
            cylinder(wall_thickness + 1, r=wall_screw / 2 + tolerence);
            translate([0, 0, -1])
            cylinder(wall_screw_head_thickness + 1, r=wall_screw_head / 2 + tolerence);
        }
    }
}

module front_wall()
{
    difference()
    {
        front_back_wall();

        translate([0, 0, wall_thickness / 2])
        cube([window_x + 2 * tolerence, window_y + 2 * tolerence, wall_thickness + 1], true);
    }

    for(i = [-1:2:1])
    for(j = [-1:2:1])
    translate([i * window_inner_x / 2, j * window_inner_y / 2, window_bracket_thicknes])
    rotate(180, [1, 0, 0])
    window_bracket();

    for(i = [-1:2:1])
    translate([i * (window_inner_x - i * window_bracket_l) / 2, (window_bracket_l - window_inner_y - 0.1) / 2, 0])
    cube([window_bracket_l, window_inner_y - window_bracket_l + 0.1, window_bracket_thicknes]);

    for(i = [-1:2:1])
    translate([(window_bracket_l - window_inner_x - 0.1) / 2, i * (window_inner_y - i * window_bracket_l) / 2, 0])
    cube([window_inner_x - window_bracket_l + 0.1, window_bracket_l,window_bracket_thicknes]);
}

module back_wall()
{
    fan_hole = fan_inner - sqrt(2) * (fan_mount_large / 2 + tolerence + fan_mount_support);

    difference() {
        front_back_wall();

        for(k = [-1:2:1])
        translate([
            k * (fan_outer + fan_x_sep) / 2, 
            -inner_z / 2 + level_one_z + level_two_z + level_three_z / 2 + 2 * level_thickness, 
            0
        ])
        {
            for(i = [-1:2:1])
            for(j = [-1:2:1])
            translate([i * fan_inner / 2, j * fan_inner / 2, 0])
            {
                translate([0, 0, wall_thickness - fan_mount_thickness - 0.01])
                cylinder(fan_mount_thickness + 1, r=fan_mount_small / 2 + tolerence);

                translate([0, 0, -1])
                cylinder(wall_thickness - fan_mount_thickness + 1, r=fan_mount_large / 2 + tolerence);
            }

            translate([0, 0, wall_thickness / 2])
            cube([fan_hole, fan_hole, wall_thickness + 1], true);
            
            // Fan model
            *translate([0, 0, fan_thickness / 2 + wall_thickness + tolerence])
            cube([fan_outer, fan_outer, fan_thickness], true);
        }

        translate([
            -bottom_x / 2 + level_support + tolerence + power_x / 2,
            -inner_z / 2 + power_z / 2 + power_hole_z_offset,
            wall_thickness / 2
        ])
        cube([power_hole_x, power_hole_z, wall_thickness + 1], true);

        translate([
            -bottom_x / 2 + 2 * level_support + 3 * tolerence + power_x + plug_x / 2,
            -inner_z / 2 + tolerence + plug_z / 2,
            wall_thickness / 2
        ])
        cube([plug_hole_x, plug_hole_z, wall_thickness + 1], true);

        translate([
            0,
            -inner_z / 2 + level_one_z + level_two_z + level_three_z + 3 * level_thickness - ctrl_hole / 2 + tolerence + ctrl_z,
            -0.5
        ])
        cylinder(wall_thickness + 1, r=ctrl_hole / 2 + tolerence);
    }
}

module left_right_wall()
{
    difference()
    {
        hull()
        {
            translate([0, 0, wall_thickness / 2])
            cube([inner_z, inner_y, wall_thickness], true);
            translate([0, 0, -0.5])
            cube([outer_z, outer_y, 1], true);
        }
        translate([0, 0, -1])
        cube([outer_z + 1, outer_y + 1, 2], true);

        for(i = [-1:2:1])
        for(j = [-1:2:1])
        translate([i * (inner_z / 2 - wall_bracket_z / 2 + tolerence), 
                   j * (inner_y / 2 - wall_bracket_z / 2 - wall_bracket_thickness), 0])
        {
            translate([0, 0, -0.5])
            cylinder(wall_thickness + 1, r=wall_screw / 2 + tolerence);
            translate([0, 0, -1])
            cylinder(wall_screw_head_thickness + 1, r=wall_screw_head / 2 + tolerence);
        }
    }
}

module left_wall()
{
    left_right_wall();
}

module right_wall()
{
    left_right_wall();
}

module walls()
{
    translate([0, -inner_y / 2 - wall_thickness - tolerence, outer_z / 2])
    rotate(-90, [1, 0, 0])
    front_wall();
    translate([0, inner_y / 2 + wall_thickness + tolerence, outer_z / 2])
    rotate(90, [1, 0, 0])
    back_wall();
    translate([-inner_x / 2 - wall_thickness - tolerence, 0, outer_z / 2])
    rotate(90, [0, 1, 0])
    rotate(90, [0, 0, 1])
    front_wall();
    translate([inner_x / 2 + wall_thickness + tolerence, 0, outer_z / 2])
    rotate(-90, [0, 1, 0])
    rotate(90, [0, 0, 1])
    front_wall();
}

module level()
{   
    difference()
    {   
        union()
        {
            intersection()
            {
                hull()
                for(i = [0:90:270])
                rotate(i, [0, 0, 1])
                translate([inner_x / 2 - wall_bracket_thickness, inner_y / 2 - wall_bracket_thickness, 0])
                cylinder(level_thickness, r=wall_bracket_thickness);
            
                for(i = [0:90:270])
                rotate(i, [0, 0, 1])
                hull()
                for(j = [-1:2:1])
                translate([j * (inner_x / 2 - wall_bracket_z / 2 - wall_bracket_thickness), inner_y / 2 - wall_bracket_z / 2 - wall_bracket_thickness, level_thickness / 2])
                cube([wall_bracket_z + 2 * wall_bracket_thickness, wall_bracket_z + 2 * wall_bracket_thickness, level_thickness], true);
            }

            intersection()
            {
                hull()
                for(i = [0:90:270])
                rotate(i, [0, 0, 1])
                translate([inner_x / 2 - wall_bracket_thickness, inner_y / 2 - wall_bracket_thickness, 0])
                cylinder(level_thickness, r=wall_bracket_thickness);
            
                for(i = [0:90:270])
                rotate(i, [0, 0, 1])
                hull()
                {
                    translate([0, 0, level_thickness / 2])
                    cube([(wall_bracket_z + 2 * wall_bracket_thickness) / sqrt(2), (wall_bracket_z + 2 * wall_bracket_thickness) / sqrt(2), level_thickness], true);
                    translate([inner_x / 2 - wall_bracket_z / 2 - wall_bracket_thickness, inner_y / 2 - wall_bracket_z / 2 - wall_bracket_thickness, level_thickness / 2])
                    cube([(wall_bracket_z + 2 * wall_bracket_thickness) / sqrt(2), (wall_bracket_z + 2 * wall_bracket_thickness) / sqrt(2), level_thickness], true);
                }
            }
        }

        for(i = [-1:2:1])
        for(j = [-1:2:1])
        translate([i * (inner_x / 2 - wall_bracket_z / 2 - wall_bracket_thickness), 
                   j * (inner_y / 2 - wall_bracket_z / 2 - wall_bracket_thickness), -0.5])
        cylinder(level_thickness + 1, r=level_screw / 2 + tolerence);
    }
}

module switch_cradle()
{   
    translate([0, level_support + tolerence, 0])
    {
        for(i=[0:1])
        translate([i * (switch_x + tolerence), 0, 0])
        {   
            translate([0, -tolerence, 0])
            cube([2 * level_support + tolerence, switch_y + 2 * tolerence + level_support, level_thickness]);

            translate([i * (level_support + tolerence), -tolerence, 0])
            cube([level_support, switch_leg + tolerence, level_thickness + level_wall_z * switch_z]);

            translate([i * (level_support + tolerence), switch_y - switch_leg, 0])
            cube([level_support, switch_leg + tolerence, level_thickness + level_wall_z * switch_z]);
        }

        for(i = [0:1])
        for(j = [0:1])
        translate([
            i * (switch_x - switch_lip + tolerence + level_support), 
            -level_support - tolerence + j * (switch_y + level_support + 2 * tolerence),
            0
        ])
        cube([level_support + tolerence + switch_lip, level_support, level_thickness + level_wall_z * switch_z]);

        for(i = [0:1])
        translate([2 * level_support, i * (switch_y + tolerence) -level_support - tolerence, 0])
        cube([switch_x - 2 * (level_support - tolerence), 2 * level_support + tolerence, level_thickness]);

        // Switch Model
        *translate([level_support + tolerence, 0, level_thickness + tolerence])
        cube([switch_x, switch_y, switch_z]);
    }
}

module drive_holes()
{
    translate([
        (-level_two_x + drive_x - drive_inner_x) / 2 + 2 * level_support + 3 * tolerence + switch_x,
        -switch_y - switch_y_offset - level_support - tolerence + (inner_y + drive_y - drive_inner_y) / 2,
        -0.5
    ])
    for(i = [0:1])
    for(j = [0:1])
    translate([i * drive_inner_x, j * drive_inner_y, 0])
    cylinder(level_thickness + 1, r=drive_screw / 2 + tolerence);
}

module level_two()
{   
    difference()
    {
        union()
        {
            level();

            translate([
                -level_two_x / 2,
                -switch_y - level_support - tolerence + inner_y / 2 - switch_y_offset,
                0
            ])
            switch_cradle();

            for(i = [0:1])
            translate([
                -inner_x / 2, 
                -switch_y - switch_y_offset - 2 * (level_support + tolerence) + (inner_y + drive_y - drive_inner_y - drive_screw) / 2 + i * drive_inner_y, 
                0
            ])
            cube([inner_x, drive_screw + 2 * (tolerence + level_support), level_thickness]);

            translate([-level_two_x / 2 + tolerence, -switch_y - level_support - tolerence + inner_y / 2 - switch_y_offset, 0])
            cube([switch_x + 2 * tolerence, 10, level_thickness]);

            translate([-level_two_x / 2 + tolerence, level_support - tolerence + inner_y / 2 - switch_y_offset - 15, 0])
            cube([level_two_x, 15, level_thickness]);

            translate([13, 0, level_thickness / 2])
            cube(level_thickness, true);
        }

        drive_holes();
    }

    // Drive Model
    *translate([
        -level_two_x / 2 + 2 * level_support + 3 * tolerence + switch_x,
        -switch_y - level_support - tolerence + inner_y / 2 - switch_y_offset,
        level_thickness + tolerence
    ])
    cube([drive_x, drive_y, drive_z]);
}

module level_three()
{
    difference()
    {
        union()
        {
            level();

            translate([
                0, 
                (inner_y - pi_mount_y) / 2 - pi_nut - 2 * pi_mount_support - 3 * tolerence - fan_thickness - fan_y_sep,
                level_thickness / 2
            ])
            cube([inner_x, pi_mount_y + pi_nut + 4 * tolerence + 2 * level_support, level_thickness], true);
        }

        for(i = [0:pi_count - 1])
        for(j = [-1:2:1])
        translate([
            - 1.5 * (pi_x[0] + pi_x[1] + pi_offset) + (pi_x[0] - pi_x[1]) / 2 + pi_mount_thickness / 2 + i * (pi_x[0] + pi_x[1] + pi_offset),
            (inner_y - pi_mount_y) / 2 - pi_nut - 2 * pi_mount_support - 3 * tolerence - fan_thickness - fan_y_sep + j * pi_mount_y / 2,
            level_thickness / 2
        ])
        cube([pi_mount_thickness + 2 * tolerence, pi_nut + 4 * tolerence, level_thickness + 1], true);
    }
}

module level_four()
{
    level_three();

    translate([0, (inner_y - ctrl_y) / 2, level_thickness / 2])
    cube([ctrl_x, ctrl_y, level_thickness], true);
}

module pi_mount()
{
    r = pi_mount_r;
    leg_drop = (level_three_z - pi_mount_z) / 2 - r - tolerence;

    for(i = [0:1])
    for(j = [-1:2:1])
    rotate(i * 180, [1, 0, 0])
    translate([(pi_x[0] - pi_x[1]) / 2, j * pi_mount_y / 2, pi_mount_z / 2])
    difference()
    {
        union()
        {
            rotate(90, [1, 0, 0])
            rotate(90, [0, 1, 0])
            cylinder(pi_mount_thickness, r=r, $fn=6);

            translate([pi_mount_thickness / 2, 0, (level_three_z - pi_mount_z) / 4 + level_thickness / 2])
            cube([pi_mount_thickness, 2 * r, (level_three_z - pi_mount_z) / 2 +  level_thickness], true);

            translate([pi_mount_thickness / 2, j * 3 * r / 3, 0])
            cube([pi_mount_thickness, 2 * r, 2 * r * sin(60)], true);

            translate([pi_mount_thickness / 2, -j * pi_mount_y / 4, r + leg_drop / 2])
            cube([pi_mount_thickness, pi_mount_y / 2, leg_drop], true);

            translate([pi_mount_thickness / 2, 3 * j * r / 2, -pi_mount_z / 4])
            cube([pi_mount_thickness, r, pi_mount_z / 2], true);
        }

        rotate(90, [0, 1, 0])
        {
            translate([0, 0, -0.1])
            cylinder(pi_mount_thickness + 0.2, r=pi_screw / 2 + tolerence);
            
            rotate(90, [0, 0, 1])
            translate([0, 0, pi_mount_thickness / 2])
            cylinder(pi_mount_thickness / 2 + 0.1, r=pi_nut / 2 + tolerence, $fn=6);
        }
    }

    *cube([pi_x[0] + pi_x[1], pi_mount_y, pi_mount_z], true);
}

module all()
{
    echo(str("External Dimensions = ", [outer_x + 2 * tolerence, outer_y + 2 * tolerence, outer_z + handle_z]));
    echo(str("Working Area = ", [working_x, working_y]))

    translate([0, 0, inner_z + 2 * wall_thickness])
    rotate(180, [1, 0, 0])
    top();
    bottom();
    walls();
    translate([0, 0, wall_thickness + level_one_z])
    level_two();
    translate([0, 0, wall_thickness + level_one_z + level_two_z + level_thickness])
    level_three();
    translate([0, 0, wall_thickness + level_one_z + level_two_z + level_three_z + 2 * level_thickness])
    level_four();

    for(i = [0:pi_count - 1])
    translate([
        i * (pi_x[0] + pi_x[1] + pi_offset) - 1.5 * (pi_x[0] + pi_x[1] + pi_offset),
        (inner_y - pi_mount_y) / 2 - pi_nut - 2 * pi_mount_support - 3 * tolerence - fan_thickness - fan_y_sep, 
        wall_thickness + level_one_z  + level_two_z + level_three_z / 2 + 2 * level_thickness
    ])
    pi_mount();

    *translate([0, 0, 127 / 2 + wall_thickness + tolerence + 1])
    cube([178, 2, 127], true);
}

module render()
{
    if (model == "all") all();
    else if (model == "top") top();
    else if (model == "bottom") bottom();
    else if (model == "front-wall") front_wall();
    else if (model == "back-wall") back_wall();
    else if (model == "left-wall") left_wall();
    else if (model == "right-wall") right_wall();
    else if (model == "level-two") level_two();
    else if (model == "level-three") level_three();
    else if (model == "level-four") level_four();
    else if (model == "pi-mount")
    rotate(90, [0, -1, 0])
    translate([(pi_x[1] - pi_x[0]) / 2, 0, 0])
    pi_mount();
}

if (resolution == "viewport")
{
    $fn = viewport_fn;
    render();
}
else if (resolution == "render")
{
    $fn = render_fn;
    render();
}