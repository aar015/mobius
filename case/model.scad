/*[Global Settings]*/
render_fn = 100;
viewport_fn = 25;
tolerence = 0.2;

/*[Body Settings]*/
inner_x = 135.2;
inner_y = 135.2;
wall_thickness = 3.2;
render_inner_fillet = 0.4;
render_outer_fillet = 0.8;
viewport_inner_fillet = 0;
viewport_outer_fillet = 0;

/*[Rack Settings]*/
rack_thickness = 3.2;
rack_support = 3.2;
rack_wall_per_z = 0.75;
rack_wall_thickness = 3.2;
render_rack_fillet = 0.4;
viewport_rack_fillet = 0;

/*[Retainer Settings]*/
retainer_thickness = 3.2;
retainer_protrusion = 3.2;
render_retainer_fillet = 0.4;
viewport_retainer_fillet = 0;

/*[Network Settings]*/
network_y = 100.4 - retainer_protrusion;
network_z = 28;
network_objects = [[24, 43.2, 5, 10], [100.4, 98.4, 3, 10]];

/*[Power Settings]*/
power_x = 70;
power_y = 100;
power_z = 30.8;
power_rack_x = 72.4;

/*[Memory Settings]*/
memory_x = 30;
memory_y = 90;
memory_z = 9.2;
memory_rack_x = 49.6;

/*[NanoPi Settings]*/
nanopi_y = 100;
nanopi_z = 61.2;

/*[Back Fan Settings]*/
backfan_outer = 60;
backfan_inner = 55;

/*[Top Fan Settings]*/
topfan_y = inner_y;
topfan_z = 25;
topfan_outer = 120;
topfan_inner = 110;

/*[Door Settings]*/
door_inner_thickness = 1.6;
door_dovetail_angle = 45;
render_door_fillet = 0.4;
viewport_door_fillet = 0;

/*[Honeycomb Settings]*/
render_honeycomb_fillet = 0.4;
viewport_honeycomb_fillet = 0;

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
    minkowski()
    {
        translate([0, 0, r])
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

module rack(x, y, z, objects=[], mode="center")
{
    function sum_x(i=len(objects), j=0, r=0) = (j == i) ? r : sum_x(i, j + 1, r + objects[j][0]);

    total_x = sum_x() + (len(objects) - 1) * (rack_wall_thickness + 2 * tolerence) + 2 * (rack_wall_thickness + tolerence);
    support = max(rack_support, 2 * rack_wall_thickness + 4 * tolerence);
    
    assert(total_x + 2 * tolerence - 0.001 <= inner_x, str("Inner x too small to fit rack of total x = ", total_x));

    function center_x(i=0) = (objects[i][0] - total_x) / 2 + (1 + i) * rack_wall_thickness + sum_x(i) + (1 + 2 * i) * tolerence;
    function center_y(i=0) = (inner_y - objects[i][1]) / 2 + retainer_protrusion;

    fillet_extrude($rack_fillet, rack_thickness)
    {
        difference()
        {
            square([x + 2 * retainer_protrusion, inner_y + 2 * retainer_protrusion], true);
            translate([0, (inner_y - y) / 2])
            square([x, y], true);
            if (mode == "center")
            translate([0, -y - retainer_protrusion])
            square([x, inner_y], true);
            if (mode == "left")
            translate([retainer_protrusion / 2, -y - retainer_protrusion])
            square([x + retainer_protrusion, inner_y], true);
            if (mode == "right")
            translate([-retainer_protrusion / 2, -y - retainer_protrusion])
            square([x + retainer_protrusion, inner_y], true);
        }

        if(len(objects) > 0)
        for(i = [0:(len(objects) - 1)])
        {
            translate([0, (inner_y - support / 2 + retainer_protrusion) / 2])
            square([inner_x, support / 2 - retainer_protrusion], true);

            translate([0, center_y(i) - objects[i][1] / 2])
            square([inner_x, support], true);

            for(j = [-1:2:1])
            translate([center_x(i) + j * objects[i][0] / 2, (inner_y - y) / 2])
            square([support, y], true);
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

    //Insert Retainers for Network, Nano Pi, and Top Fan Racks
    for(i = [[0, 0], [1, network_z], [2, network_z + power_z], [3, network_z + power_z + nanopi_z]])
    translate([0, 0, wall_thickness - retainer_thickness + i[0] * rack_thickness + i[1]])
    retainer(inner_x, inner_y);

    // Insert Retainers for Power and Memory Racks
    translate([(power_rack_x -inner_x) / 2, (inner_y - power_y) / 2, 
               wall_thickness - retainer_thickness + rack_thickness + network_z])
    retainer(power_rack_x, power_y);

    for(i = [1:2])
    translate([0, 0, wall_thickness - retainer_thickness + network_z + rack_thickness + i * (memory_z + rack_thickness)])
    difference()
    {
        retainer(inner_x, inner_y);
        translate([-outer_x / 2, -0.5])
        cube([outer_x, outer_y + 2, outer_z], true);
    }

    for(i = [0:2])
    translate([(inner_x - memory_rack_x) / 2, (inner_y - power_y) / 2, 
               wall_thickness - retainer_thickness + rack_thickness + network_z + i * (memory_z + rack_thickness)])
    retainer(memory_rack_x, power_y);

    translate([(power_rack_x - memory_rack_x) / 2, (inner_y - power_y + $retainer_fillet + tolerence) / 2, 
               wall_thickness - retainer_thickness + rack_thickness + network_z])
    {
        fillet_extrude($retainer_fillet, power_z + retainer_thickness + rack_thickness)
        square([inner_x - memory_rack_x - power_rack_x - 2 * (retainer_protrusion + tolerence),
                power_y + 2 * retainer_protrusion + $retainer_fillet + tolerence], true);
        for(i = [0:1])
        translate([0, 0, retainer_thickness / 2 + i * (retainer_thickness + rack_thickness + 2 * tolerence)])
        cube([inner_x - memory_rack_x - power_rack_x - 2 * (retainer_protrusion + tolerence) + 0.1,
              power_y + 2 * retainer_protrusion + $retainer_fillet + tolerence,
              retainer_thickness - 2 * $retainer_fillet], true);
        for(j = [1:2])
        translate([$retainer_fillet, 0, j * (memory_z + rack_thickness)])
        for(i = [0:1])
        translate([0, 0, retainer_thickness / 2 + i * (retainer_thickness + rack_thickness + 2 * tolerence)])
        cube([inner_x - memory_rack_x - power_rack_x - 2 * (retainer_protrusion + tolerence) + 0.1 - $retainer_fillet,
              power_y + 2 * retainer_protrusion + $retainer_fillet + tolerence,
              retainer_thickness - 2 * $retainer_fillet], true);
        translate([0, $retainer_fillet / 2, $retainer_fillet / 2])
        cube([inner_x - memory_rack_x - power_rack_x - 2 * (retainer_protrusion + tolerence),
               power_y + 2 * retainer_protrusion + tolerence, $retainer_fillet], true);
    }

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

// Need To implement Power Rack
module power_rack()
{
    rack(power_rack_x, power_y, "left");
}

// Need to implement Memory Rack
module memory_rack()
{
    rack(memory_rack_x, power_y, "right");
}

// Need to implement Nano Pi Rack
module nanopi_rack()
{
    rack(inner_x, nanopi_y);
}

// Need to implement Nano Pi Mounts
module nanopi_mounts()
{

}

// Need to implement Top Fan Rack
module topfan_rack()
{
    rack(inner_x, topfan_y);
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
    translate([(power_rack_x - inner_x) / 2, 0, wall_thickness + tolerence + network_z + rack_thickness])
    power_rack();
    for(i = [0:2])
    translate([(inner_x - memory_rack_x) / 2, 0, 
               wall_thickness + tolerence + network_z + rack_thickness + i * (memory_z + rack_thickness)])
    memory_rack();
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
        body();
    }

    else if (which_model == "door")
    {
        door();
    }

    else if (which_model == "network_rack")
    {
        network_rack();
    }

    else if (which_model == "power_rack")
    {
        power_rack();
    }

    else if (which_model == "memory_rack")
    {
        memory_rack();
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