/*[Global]*/
render_fn = 24;
viewport_fn = 12;
tolerence = 0.2;

/*[Body]*/
inner_x = 158.4;
inner_y = 158.4;
wall_thickness = 4.0;

/*[Logo]*/
logo_outer = 45;
logo_inner = 20;
logo_stroke = 1.6;
logo_thickness = 1.2;

/*[Rack]*/
rack_thickness = 3.6;
rack_support = 1.6;

/*[Retainer]*/
retainer_thickness = 2.4;
retainer_protrusion = 2.4;

/*[Power Block]*/
power_x = 69.7;
power_y = 101.4;
power_lip = 4.8;

/*[2_5 Inch Drive]*/

/*[Network Plug]*/
plug_x = 23.75;
plug_y = 43.2;
plug_z = 26.4;
plug_lip = 4.8;

/*[Network Switch]*/
switch_x = 100.4;
switch_y = 98.4;
switch_lip = 6.8;

/*[Portable SSD]*/
ssd_x = 9.2;
ssd_y = 101.4;
ssd_lip = 1.2;

/*[60mm Fan]*/
fan_outer = 60;
fan_inner = 50;
fan_mount_large = 10.4;
fan_mount_small = 5.6;
fan_mount_thickness = 2.0;
fan_mount_support = 1.2;
fan_honeycomb_fill = 10;

/*[Honeycomb]*/
honeycomb_stroke = 1.2;

/*[Neo3]*/
neo3_x = [15, 7];
neo3_y = 92.0;
neo3_z = 95.8;
neo3_count = 4;
neo3_mount_y = 42;
neo3_mount_z = 42;
neo3_mount_support = 1.2;
neo3_screw = 3;
neo3_nut = 6.2;

/*[Rack One]*/
one_z = 0.2;

/*[Rack Two]*/
two_z = one_z;

/*[Rack Three]*/

/*[Rack Four]*/

/*[Rack Five]*/

/*[Rack Six]*/

/*[Calculated]*/
inner_z = 100;
outer_x = inner_x + 2 * wall_thickness + 2 * retainer_protrusion + 4 * tolerence;
outer_y = inner_y + 2 * wall_thickness + 2 * tolerence;
outer_z = inner_z + 2 * wall_thickness;

/*[Hidden]*/
which_model = "viewport";

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
        translate([0, -logo_thickness, outer_z / 2])
        rotate(90, [1, 0, 0])
        linear_extrude(-logo_thickness + 0.1)
        logo();
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

module body()
{
    difference()
    {
        walls();

        translate([0, -outer_y / 2, wall_thickness])
        linear_extrude(outer_z)
        offset(tolerence)
        dovetail();
    }
}

module fan_mount()
{
    difference()
    {
        for(i = [-1:2:1])
        for(j = [-1:2:1])
        translate([i * backfan_inner / 2, j * backfan_inner / 2, 0])
        {
            difference()
            {
                union()
                {
                    cylinder(r=fan_mount_large / 2 + fan_mount_support, h=rack_thickness);

                    translate([-i * backfan_inner / 4, 0, rack_thickness / 2])
                    cube([backfan_inner / 2, fan_mount_large + 2 * fan_mount_support, rack_thickness], true);

                    translate([0, -j * backfan_inner / 4, rack_thickness / 2])
                    cube([fan_mount_large + 2 * fan_mount_support, backfan_inner / 2, rack_thickness], true);
                
                    translate([0, j * (nanopi_z - backfan_inner) / 4, rack_thickness / 2])
                    cube([fan_mount_large + 2 * fan_mount_support, (nanopi_z - backfan_inner + rack_thickness) / 2, rack_thickness], true);
                }

                translate([0, 0, -0.5])
                cylinder(r=fan_mount_small / 2, h=rack_thickness + 1);

                translate([0, 0, rack_thickness - fan_mount_thickness])
                cylinder(r=fan_mount_large / 2, h=fan_mount_thickness + 1);
            }
        }
    }
}

if (which_model == "viewport")
{
    $fn = viewport_fn;

    echo(str("External Dimensions Are = ", [outer_x, outer_y, outer_z]));

    body();
    translate([0, -outer_y / 2, wall_thickness + tolerence])
    door();
}
else
{
    $fn = render_fn;

    if (which_model == "body")
    {
        translate([outer_z / 2, 0, outer_y / 2])
        rotate(-90, [0, 1, 0])
        rotate(90, [0, 0, 1])
        body();
    }

    else if (which_model == "door")
    {
        translate([-outer_z / 2, 0, wall_thickness / 2])
        rotate(90, [0, 1, 0])
        rotate(90, [0, 0, 1])
        door();
    }
}