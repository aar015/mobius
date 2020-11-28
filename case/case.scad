/*[Global Settings]*/
$fn = 100;
tolerence = 0.2;

/*[Body Settings]*/
inner_x = 121.2;
inner_y = 121.2;
wall_thickness = 4.8;
outer_fillet = 0.8;

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
power_z = 30.4;

/*[Memory Settings]*/
memory_z = 9;

/*[NanoPi Settings]*/
nanopi_z = 62;

/*[Back Fan Settings]*/


/*[Top Fan Settings]*/
topfan_z = 25;

/*[Door Settings]*/
door_inner_thickness = 1.6;
door_dovetail_angle = 45;

/*[Calculated Dimensions]*/
inner_z = network_z + power_z + nanopi_z + topfan_z + 4 * rack_thickness + tolerence;
outer_x = inner_x + 2 * (retainer_protrusion + tolerence + wall_thickness);
outer_y = inner_y + 2 * (retainer_protrusion + tolerence + wall_thickness);
outer_z = inner_z + 2 * wall_thickness;

echo(str("External Dimensions Are = ", [outer_x, outer_y, outer_z]));

module dovetail(_outer_x=outer_x, _inset=wall_thickness/2, _inner_thickness=door_inner_thickness,
                _outer_thickness=(wall_thickness - door_inner_thickness), _angle=door_dovetail_angle)
{
    translate([0, _outer_thickness])
    hull()
    {
        translate([0, _inner_thickness / 2])
        square([_outer_x - 2 * _inset, _inner_thickness], true);
        translate([0, - _outer_thickness / 2])
        square([_outer_x - 2 * _inset - _outer_thickness * tan(_angle), _outer_thickness], true);
    }
}

module fillet_cube(_x=10, _y=10, _z=10, _r=1)
{
    minkowski()
    {
        cube([_x - 2 * _r, _y - 2 * _r, _z - 2 * _r], true);
        sphere(_r);
    }
}

// Need to implement honeycomb
module honeycomb()
{

}

// Need to implement logo
module logo()
{

}

module rack(_x=inner_x, _y=inner_y, _thickness=rack_thickness, 
            _protrusion=retainer_protrusion, _fillet=rack_fillet)
{
    translate([0, 0, _thickness / 2])
    minkowski()
    {
        difference()
        {
            cube([_x + 2 * (_protrusion - _fillet),
                  _y + 2 * (_protrusion - _fillet),
                  _thickness - 2 * _fillet], true);
            cube([_x + 2 * _fillet, _y + 2 * _fillet, _thickness + 1], true);
        }
        sphere(_fillet);
    }
}

module retainer(_x=inner_x, _y=inner_y, _thickness=retainer_thickness, _fillet=retainer_fillet,
                _offset=retainer_thickness + rack_thickness + 2 * tolerence,
                _protrusion=retainer_protrusion, _tolerence=tolerence)
{
    for(i = [0:1])
    for(j = [-1:2:1])
    translate([j * (_x + _protrusion + _tolerence + _fillet)/ 2, 
               _fillet / 2 + _tolerence / 2, 
               i * _offset + _thickness / 2])
    fillet_cube(_protrusion + _tolerence + _fillet, 
                _y + 2 * (_protrusion + _tolerence) + _fillet - _tolerence,
                _thickness, _fillet);
}

module walls()
{
    difference()
    {
        fillet_cube(outer_x, outer_y, outer_z, outer_fillet);
        cube([outer_x - 2 * wall_thickness, outer_y - 2 * wall_thickness, inner_z], true);
    }
}

module body()
{
    intersection()
    {
        union()
        {
            translate([0, 0, outer_z / 2])
            difference()
            {
                walls();
                translate([0, -outer_y / 2, -outer_z / 2 + wall_thickness])
                linear_extrude(outer_z)
                offset(tolerence)
                dovetail();
            }
            for(i = [[0, 0], [2, network_z + power_z], [3, network_z + power_z + nanopi_z]])
            translate([0, 0, wall_thickness - retainer_thickness + i[0] * rack_thickness + i[1]])
            retainer();
            // Need to put in power retainer
        }
        // Need to create wifi antenna hole
        // Need to create io holes
        // Need to make grates for fans
        translate([0, 0, outer_z / 2])
        fillet_cube(outer_x, outer_y, outer_z, outer_fillet);
    }
}

module door()
{
    intersection()
    {
        translate([0, -outer_y / 2, wall_thickness + tolerence])
        linear_extrude(outer_z - wall_thickness - tolerence)
        dovetail();
        translate([0, 0, outer_z / 2])
        walls();
    }
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
    difference()
    {
        union()
        {
            body();
            door();
        }
        // Need to put in divet for magnet
    }
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