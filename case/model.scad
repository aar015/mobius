/*[Global Settings]*/
render_fn = 24;
viewport_fn = 12;
tolerence = 0.2;
viewport_mult = 1;

/*[Body Settings]*/
inner_x = 130.8;
inner_y = 120.8;
wall_thickness = 4.0;
render_inner_fillet = 0.4;
render_outer_fillet = 0.8;
viewport_inner_fillet = 0.4 * viewport_mult;
viewport_outer_fillet = 0.8 * viewport_mult;

/*[Rack Settings]*/
rack_thickness = 3.2;
rack_wall_per_z = 0.5;
rack_wall_thickness = 1.6;
rack_support = max(0, 2 * rack_wall_thickness + 4 * tolerence);
render_rack_fillet = 0.4;
viewport_rack_fillet = 0.4 * viewport_mult;

/*[Retainer Settings]*/
retainer_thickness = 2.4;
retainer_protrusion = 2.4;
render_retainer_fillet = 0.4;
viewport_retainer_fillet = 0.4 * viewport_mult;

/*[Network Settings]*/
network_y = 98.8;
network_z = 26.4;
network_objects = [[23.75, 43.2, 4.8, 10], [100.4, 98.4, 6.8, 15]];

/*[Power Settings]*/
power_y = 98.8;
power_z = 30.0;
power_objects = [[69.7, 101.4, 4.8, 15], [9.2, 101.4, 1.2, 15], [9.2, 101.4, 1.2, 15], [9.2, 101.4, 1.2, 15]];

/*[NanoPi Settings]*/
nanopi_y = 98.8;
nanopi_z = 62.4;

/*[Fan Settings]*/
fan_mount_large_r = 10.4;
fan_mount_small_r = 5.6;
fan_mount_thickness = 2.0;

/*[Back Fan Settings]*/
backfan_outer = 60.0;
backfan_inner = 55.0;

/*[Top Fan Settings]*/
topfan_y = inner_y;
topfan_z = 20.0 + tolerence;
topfan_outer = 120;
topfan_inner = 105;

/*[Door Settings]*/
door_inner_thickness = 1.2;
door_dovetail_angle = 38.0;
render_door_fillet = 0.4;
viewport_door_fillet = 0.4 * viewport_mult;

/*[Honeycomb Settings]*/
render_honeycomb_fillet = 0.4;
viewport_honeycomb_fillet = 0 * viewport_mult;

/*[Calculated Dimensions]*/
inner_z = network_z + power_z + nanopi_z + topfan_z + 4 * rack_thickness + tolerence;
outer_x = inner_x + 2 * (retainer_protrusion + tolerence + wall_thickness);
outer_y = inner_y + 2 * (retainer_protrusion + tolerence + wall_thickness);
outer_z = inner_z + 2 * wall_thickness;

/*[Hidden Settings]*/
which_model = "viewport";

module dovetail()
{
    translate([0, wall_thickness / 2 - door_inner_thickness])
    hull()
    {
        translate([0, door_inner_thickness / 2])
        square([outer_x - wall_thickness, door_inner_thickness], true);
        translate([0, - (wall_thickness - door_inner_thickness) / 2])
        square([outer_x - wall_thickness - 2 * (wall_thickness - door_inner_thickness) * tan(door_dovetail_angle), 
                wall_thickness - door_inner_thickness], true);
    }
}

module fillet_extrude(r, height)
{
    translate([0, 0, r])
    minkowski()
    {
        linear_extrude(height - 2 * r)
        offset(-r)
        children();
        sphere(r);
    }
}

module honeycomb(r=10, stroke=1, fill=1)
{
    l = (r - stroke / 2) / (1 + 3 * fill);
    translate([-l * cos(60), -l * sin(60)])
    intersection()
    {
        rotate(30)
        for(i = [-3 * fill:3 * fill])
        for(j = [-3 * fill:3 * fill])
        translate([2 * i * l * sin(60) + j * l * sin(60), j * l * (cos(60) + 1)])
        for(k = [0:2])
        hull()
        {
            circle(stroke / 2);
            rotate(k * 120)
            translate([0, l])
            circle(stroke / 2);
        }
        translate([l * cos(60), l * sin(60)])
        offset(delta=stroke / 2)
        circle(r - stroke / 2, $fn=6);
    }
    difference()
    {
        offset(delta=stroke / 2)
        circle(r - stroke / 2, $fn=6);
        offset(delta=-stroke / 2)
        circle(r - stroke / 2, $fn=6);
    }
}

// Need to implement logo
module logo()
{
}

module rack(x, y, z, objects=[])
{
    function sum_x(i=len(objects), j=0, r=0) = (j == i) ? r : sum_x(i, j + 1, r + objects[j][0]);
    total_x = sum_x() + (len(objects) - 1) * (rack_wall_thickness + 2 * tolerence) + 2 * (rack_wall_thickness + tolerence);
    assert(total_x <= inner_x, str("Inner x too small to fit rack of total x = ", total_x));
    function center_x(i=0) = (objects[i][0] - total_x) / 2 + (1 + i) * rack_wall_thickness + sum_x(i) + (1 + 2 * i) * tolerence;
    function center_y(i=0) = (inner_y - objects[i][1]) / 2 + retainer_protrusion;

    fillet_extrude($rack_fillet, rack_thickness)
    {
        difference()
        {
            offset(rack_support / 2)
            square([x + 2 * retainer_protrusion - rack_support, inner_y + 2 * retainer_protrusion - rack_support], true);
            translate([0, (inner_y - y) / 2])
            offset(rack_support / 2)
            square([x - 2 * (rack_support - retainer_protrusion) - rack_support,
                    y - 2 * (rack_support - retainer_protrusion) - rack_support], true);
            translate([0, -y - retainer_protrusion])
            offset(rack_support / 2)
            square([x - rack_support, inner_y - rack_support], true);
        }

        for(i = [-1:2:1])
        translate([i * (x / 2 + retainer_protrusion / 2), 
                   - inner_y / 2 - retainer_protrusion / 2])
        square(retainer_protrusion, true);

        if(len(objects) > 0)
        for(i = [0:(len(objects) - 1)])
        {
            translate([0, center_y(i) - objects[i][1] / 2])
            square([inner_x, rack_support], true);

            for(j = [-1:2:1])
            translate([center_x(i) + j * objects[i][0] / 2, (inner_y - y) / 2])
            square([rack_support, y], true);
        }

        children();
    }

    if(len(objects) > 0)
    fillet_extrude($rack_fillet, rack_wall_per_z * z + rack_thickness)
    for(i = [0:(len(objects) - 1)])
    translate([center_x(i), center_y(i), 0])
    {
        for(j = [-1:2:1])
        {
            translate([j * (objects[i][0] - objects[i][2] + tolerence) / 2, 
                       (-objects[i][1] + objects[i][3] - tolerence) / 2])
            difference()
            {
                translate([j * rack_wall_thickness / 2, -rack_wall_thickness / 2])
                square([objects[i][2] + tolerence + rack_wall_thickness,
                        objects[i][3] + tolerence + rack_wall_thickness], true);
                translate([-j * 0.1, 0.1])
                square([objects[i][2] + tolerence + 0.2,
                        objects[i][3] + tolerence + 0.2], true);
            }

            translate([j * (objects[i][0] + rack_wall_thickness + 2 * tolerence) / 2, 
                       (objects[i][1] - objects[i][3]) / 2])
            square([rack_wall_thickness, objects[i][3]], true);
        }
    }

    *if(len(objects) > 0)
    for(i = [0:(len(objects) - 1)])
    {
        translate([center_x(i), center_y(i), z / 2 + rack_thickness])
        cube([objects[i][0], objects[i][1], z - 2 * tolerence], true);
    }
}

module retainer(x, y)
{
    for(i = [0:1])
    for(j = [-1:2:1])
    translate([j * (x + retainer_protrusion + tolerence + $retainer_fillet)/ 2, 
               $retainer_fillet / 2 + tolerence / 2,
               i * (retainer_thickness + rack_thickness + 2 * tolerence)])
    fillet_extrude($retainer_fillet, retainer_thickness)
    square([retainer_protrusion + tolerence + $retainer_fillet, 
            y + 2 * (retainer_protrusion + tolerence) + $retainer_fillet - tolerence], true);
}

module walls()
{
    difference()
    {
        fillet_extrude($outer_fillet, outer_z)
        square([outer_x, outer_y], true);
        translate([0, 0, wall_thickness])
        fillet_extrude($inner_fillet, outer_z - 2 * wall_thickness)
        square([outer_x - 2 * wall_thickness, outer_y - wall_thickness], center=true);
    }
}

module body()
{
    difference()
    {
        walls();

        // Remove Space For Door
        translate([0, -outer_y / 2 + wall_thickness / 2, wall_thickness])
        fillet_extrude($door_fillet, outer_z)
        offset(tolerence)
        dovetail();

        // Clean up corners of dovetail

        // Need to put in divet for magnet

        // Need to create io holes

        // Remove Space For Fan Grates
    }

    //Insert Rack Retainers
    for(i = [[0, 0], [1, network_z], [2, network_z + power_z], [3, network_z + power_z + nanopi_z]])
    translate([0, 0, wall_thickness - retainer_thickness + i[0] * rack_thickness + i[1]])
    retainer(inner_x, inner_y);

    // Need to make grates for fans
}

module door()
{
    intersection()
    {
        fillet_extrude($door_fillet, outer_z - wall_thickness - tolerence)
        dovetail();
        translate([0, outer_y / 2 - wall_thickness / 2, - wall_thickness - tolerence])
        walls();
    }

    // Need to put in divet for magnet
}

module network_rack()
{
    rack(inner_x, network_y, network_z, network_objects);
}

module power_rack()
{
    rack(inner_x, power_y, power_z, power_objects);
}

// Need to implement Nano Pi Rack
module nanopi_rack()
{
    rack(inner_x, nanopi_y);
}

// Need to implement Nano Pi Mounts
module nanopi_mount()
{
    translate([0, 0, 5])
    cube(10, true);
}

// Need to implement Top Fan Rack
module topfan_rack()
{
    difference()
    {
        rack(inner_x, topfan_y)
        {
            for(i = [-1:2:1])
            for(j = [-1:2:1])
            translate([i * topfan_inner / 2, j * topfan_inner / 2])
            {
                difference()
                {
                    union()
                    {
                        circle(fan_mount_large_r / 2 + rack_support);

                        translate([i * (inner_x - topfan_inner) / 4, 0])
                        square([(inner_x - topfan_inner) / 2, fan_mount_large_r + 2 * rack_support], true);

                        translate([0, j * (inner_y - topfan_inner) / 4])
                        square([fan_mount_large_r + 2 * rack_support, (inner_y - topfan_inner) / 2], true);
                    }
                    circle(fan_mount_small_r / 2);
                }
            }
        }

        for(i = [-1:2:1])
        for(j = [-1:2:1])
        translate([i * topfan_inner / 2, j * topfan_inner / 2, fan_mount_thickness])
        {
            fillet_extrude($rack_fillet, rack_thickness - fan_mount_thickness + 0.1)
            circle(fan_mount_large_r / 2);

            translate([0, 0, rack_thickness - fan_mount_thickness - $rack_fillet])
            difference()
            {
                linear_extrude(2 * $rack_fillet)
                circle(fan_mount_large_r / 2 + $rack_fillet);
                rotate_extrude(angle=360)
                translate([fan_mount_large_r / 2 + $rack_fillet, 0])
                circle($rack_fillet);
            }

            translate([0, 0, - $rack_fillet])
            difference()
            {
                linear_extrude(2 * $rack_fillet)
                circle(fan_mount_small_r / 2 + $rack_fillet);
                rotate_extrude(angle=360)
                translate([fan_mount_small_r / 2 + $rack_fillet, 0])
                circle($rack_fillet);
            }
        }
    }
}

if (which_model == "viewport")
{
    $fn = viewport_fn;
    $inner_fillet = viewport_inner_fillet;
    $outer_fillet = viewport_outer_fillet;
    $rack_fillet = viewport_rack_fillet;
    $retainer_fillet = viewport_retainer_fillet;
    $door_fillet = viewport_door_fillet;
    $honeycomb_fillet = viewport_honeycomb_fillet;

    echo(str("External Dimensions Are = ", [outer_x, outer_y, outer_z]));

    body();
    translate([0, -outer_y / 2 + wall_thickness / 2, wall_thickness + tolerence])
    *door();
    translate([0, 0, wall_thickness + tolerence])
    network_rack();
    translate([0, 0, wall_thickness + tolerence + network_z + rack_thickness])
    power_rack();
    translate([0, 0, wall_thickness + tolerence + network_z + power_z + 2 * rack_thickness])
    nanopi_rack();
    // Need to arrange nanopi mounts
    translate([0, 0, wall_thickness + tolerence + network_z + power_z + nanopi_z + 3 * rack_thickness])
    topfan_rack();
}
else
{
    $fn = render_fn;
    $inner_fillet = render_inner_fillet;
    $outer_fillet = render_outer_fillet;
    $rack_fillet = render_rack_fillet;
    $retainer_fillet = render_retainer_fillet;
    $door_fillet = render_door_fillet;
    $honeycomb_fillet = render_honeycomb_fillet;

    if (which_model == "body")
    {
        translate([outer_z / 2, 0, outer_y / 2])
        rotate(-90, [0, 1, 0])
        rotate(90, [0, 0, 1])
        body();
    }

    else if (which_model == "door")
    {
        translate([outer_z / 2, 0, 0])
        rotate(-90, [0, 1, 0])
        rotate(90, [0, 0, 1])
        door();;
    }

    else if (which_model == "network_rack")
    {
        network_rack();
    }

    else if (which_model == "power_rack")
    {
        power_rack();
    }

    else if (which_model == "nanopi_rack")
    {
        nanopi_rack();
    }

    else if (which_model == "nanopi_mount")
    {
        nanopi_mount();
    }

    else if (which_model == "topfan_rack")
    {
        topfan_rack();
    }
}