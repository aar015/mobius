/*[Global Settings]*/
$fn = 100;
tolerence = 0.2;

/*[Body Settings]*/
inner_x = 120.4;
inner_y = 120.4;
wall_thickness = 3.2;
inner_fillet = 1.2;
outer_fillet = 0.4;

/*[Rack Settings]*/
rack_thickness = 1.6;
rack_fillet= 0.4;

/*[Retainer Settings]*/
retainer_thickness = 2.4;
retainer_protrusion = 2.4;
retainer_fillet = 0.4;

/*[Network Settings]*/
network_z = 26.4;

/*[Power Settings]*/
power_x = 70;
power_y = 100;
power_z = 30.4;
power_rack_x = 73.4;

/*[Memory Settings]*/
memory_x = 30;
memory_y = 90;
memory_z = 9;
memory_rack_x = 33.4;

/*[NanoPi Settings]*/
nanopi_z = 62;

/*[Back Fan Settings]*/


/*[Top Fan Settings]*/
topfan_z = 25;

/*[Door Settings]*/
door_inner_thickness = 1.6;
door_dovetail_angle = 45;
door_fillet = 0.4;

/*[Calculated Dimensions]*/
inner_z = network_z + power_z + nanopi_z + topfan_z + 4 * rack_thickness + tolerence;
outer_x = inner_x + 2 * (retainer_protrusion + tolerence + wall_thickness);
outer_y = inner_y + 2 * (retainer_protrusion + tolerence + wall_thickness);
outer_z = inner_z + 2 * wall_thickness;

echo(str("External Dimensions Are = ", [outer_x, outer_y, outer_z]));

module dovetail(_angle=door_dovetail_angle, _total_thickness=wall_thickness,
                _inner_x=outer_x - wall_thickness, _inner_thickness=door_inner_thickness)
{
    _outer_thickness = _total_thickness - _inner_thickness;
    translate([0, _outer_thickness - _total_thickness / 2])
    hull()
    {
        translate([0, _inner_thickness / 2])
        square([_inner_x, _inner_thickness], true);
        translate([0, - _outer_thickness / 2])
        square([_inner_x - 2 * _outer_thickness * tan(_angle), _outer_thickness], true);
    }
}

module fillet_extrude(r, height, center, convexity, twist, slices, scale)
{
    minkowski()
    {
        translate([0, 0, center ? 0 : r])
        linear_extrude(height = height - 2 * r, center=center, convexity=convexity, 
                       twist=twist, slices=slices, scale=scale)
        offset(r=-r)
        children();
        sphere(r=r);
    }
}

// Need to implement honeycomb
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

module rack(_x=inner_x, _y=inner_y, _thickness=rack_thickness, 
            _protrusion=retainer_protrusion, _fillet=rack_fillet)
{
    fillet_extrude(_fillet, _thickness)
    {
        difference()
        {
            square([_x + 2 * _protrusion, _y + 2 * _protrusion], true);
            square([_x, _y], true);
        }
    }
}

module retainer(_x=inner_x, _y=inner_y, _thickness=retainer_thickness, _fillet=retainer_fillet,
                _offset=retainer_thickness + rack_thickness + 2 * tolerence,
                _protrusion=retainer_protrusion, _tolerence=tolerence)
{
    for(i = [0:1])
    for(j = [-1:2:1])
    translate([j * (_x + _protrusion + _tolerence + _fillet)/ 2, 
               _fillet / 2 + _tolerence / 2, i * _offset])
    fillet_extrude(_fillet, _thickness)
    square([_protrusion + _tolerence + _fillet, 
            _y + 2 * (_protrusion + _tolerence) + _fillet - _tolerence], true);
}

module walls(_x=outer_x, _y=outer_y, _z=outer_z, _thickness=wall_thickness,
             _outer_fillet=outer_fillet, _inner_fillet=inner_fillet)
{
    difference()
    {
        fillet_extrude(_outer_fillet, _z)
        square([_x, _y], true);
        translate([0, 0, _thickness])
        fillet_extrude(_inner_fillet, _z - 2 * _thickness)
        square([_x - 2 * _thickness, _y - _thickness], center=true);
    }
}

module body()
{
    difference()
    {
        walls();

        // Remove Space For Door
        translate([0, -outer_y / 2 + wall_thickness / 2, wall_thickness])
        fillet_extrude(door_fillet, outer_z)
        offset(tolerence)
        dovetail();

        // Clean up corners of dovetail

        // Need to put in divet for magnet

        // Need to create wifi antenna hole

        // Need to create io holes

        // Remove Space For Fan Grates
    }

    //Insert Retainers for Network, Nano Pi, and Top Fan Racks
    for(i = [[0, 0], [1, network_z], [2, network_z + power_z], [3, network_z + power_z + nanopi_z]])
    translate([0, 0, wall_thickness - retainer_thickness + i[0] * rack_thickness + i[1]])
    retainer();

    // Insert Retainers for Power and Memory Racks
    translate([(power_rack_x -inner_x) / 2, (inner_y - power_y) / 2, 
               wall_thickness - retainer_thickness + rack_thickness + network_z])
    retainer(power_rack_x, power_y);

    for(i = [0:2])
    translate([(inner_x - memory_rack_x) / 2, (inner_y - power_y) / 2, 
               wall_thickness - retainer_thickness + rack_thickness + network_z + i * (memory_z + rack_thickness)])
    retainer(memory_rack_x, power_y);

    translate([(power_rack_x - memory_rack_x) / 2, (inner_y - power_y + retainer_fillet + tolerence) / 2, 
               wall_thickness - retainer_thickness + rack_thickness + network_z])
    fillet_extrude(retainer_fillet, power_z + retainer_thickness + rack_thickness)
    square([inner_x - memory_rack_x - power_rack_x - 2 * (retainer_protrusion + tolerence),
            power_y + 2 * retainer_protrusion + retainer_fillet + tolerence], true);

    // Need to make grates for fans
}

//!body();

module door()
{
    intersection()
    {
        fillet_extrude(door_fillet, outer_z - wall_thickness - tolerence)
        dovetail();
        translate([0, outer_y / 2 - wall_thickness / 2, - wall_thickness - tolerence])
        walls();
    }
    // Need to put in divet for magnet
}

// Need to implement Network Rack
module network_rack()
{
    rack();
}

// Need To implement Power Rack
module power_rack()
{
    rack();
}

// Need to implement Memory Rack
module memory_rack()
{
    rack();
}

// Need to implement Nano Pi Rack
module nanopi_rack()
{
    rack();
}

// Need to implement Nano Pi Mounts
module nanopi_mounts()
{

}

// Need to implement Top Fan Rack
module topfan_rack()
{
    rack();
}

module case()
{
    body();
    translate([0, -outer_y / 2 + wall_thickness / 2, wall_thickness + tolerence])
    *door();
    translate([0, 0, wall_thickness + tolerence])
    network_rack();
    // Need to arrange power / memory block
    translate([0, 0, wall_thickness + tolerence + network_z + power_z + 2 * rack_thickness])
    nanopi_rack();
    // Need to arrange nanopi mounts
    translate([0, 0, wall_thickness + tolerence + network_z + power_z + nanopi_z + 3 * rack_thickness])
    topfan_rack();
}

case();