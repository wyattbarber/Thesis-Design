include <helpers.scad>
include <params.scad>



module loop(
    h, d_h,
    l, w_o, w_i
)
{
    a = l;
    
    translate([-w_o/2 - d_h/4, 0, 0])
    rotate([0,0,180])
    half_ring(h, d_h/2, d_h/2-1);
    
    // Loop ends
    difference()
    {
        half_ring(h, w_o/2, w_i/2);
        union()
        {
            translate([0, d_h, h/2])
            rotate([0, -90, 0])
            cylinder(h = w_o, r=d_h/2);
            translate([0, -d_h, h/2])
            rotate([0, -90, 0])
            cylinder(h = w_o, r=d_h/2);
        }
    }
    translate([l, 0, 0])
    rotate([0,0,180])
    half_ring(h, w_o/2, w_i/2);
    
    // Loop sides
    translate([
        -eps,
        -w_o/2,
        0,
    ])
    cube([a+2*eps, (w_o-w_i)/2, h]);
    translate([
        -eps,
        w_o/2 - (w_o-w_i)/2,
        0,
    ])
    cube([a+2*eps, (w_o-w_i)/2, h]);
    
};

loop(
    conn_outer, bend_link_diam,
    loop_length, loop_outer, loop_inner
);