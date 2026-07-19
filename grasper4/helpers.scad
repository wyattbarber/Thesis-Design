include <MCAD/triangles.scad>

eps = 0.01;

module triangle_2(b, h, d)
{
    rotate([-90, -90, 0])
    triangle(b/2, h, d);
    translate([eps, d, 0])
    rotate([-90, -90, 180])
    triangle(b/2, h, d);
}


module cutout_block(w, wi, d)
{
    difference()
    {
        cube([d, w, w]);
        union()
        {
            translate([-eps, (w-wi)/2, (w-wi)/2])
            cube([d/2+eps, wi, wi]);
            translate([w/2, w*3/4, -0.5])
            cylinder(h=w+1, r=2);
            translate([w/2, w/4, -0.5])
            cylinder(h=w+1, r=2);
        }
    }
};

module flared_cylinder(h, r, rb)
{
    cylinder(h=h, r=r);
    cylinder(h=(rb-r), r1=rb, r2=r);
    translate([0,0,h])
    rotate([180, 0, 0])
    cylinder(h=(rb-r), r1=rb, r2=r);
}


module connector(h_i, h_o, d)
{
    difference()
    {
        cube([d, h_o, h_o]);
        translate([
            -d/4,
            (h_o-h_i)/2,
            (h_o-h_i)/2
        ])
        cube([d*2, h_i, h_i]);
    }
}

module half_ring(h, r1, r2)
{
    difference()
    {
        difference()
        {
            cylinder(h=h, r=r1);
            translate([0,0,-h/4])
            cylinder(h=h*2, r=r2);
        }
        translate([0, -r1, -h/4])
        cube([r1*2, r1*2, h*2]);
    }
};