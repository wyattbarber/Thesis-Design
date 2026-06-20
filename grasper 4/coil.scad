include <helpers.scad>
include <params.scad>


module link(
    l, w, d,
    d_c, d_h,
    twist
)
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    rotate([90, 0, 90])
                    triangle_2(w, l, d);
                }
                union()
                {
                    translate([0, 0, -d/4])
                    cylinder(h=2*d, r=d_h/2);
                    
                    translate([-l/4, 3*w/8, d/2])
                    rotate([0, 90, 0])
                    cylinder(h=l, r=d_c/2);
                    
                    translate([-l/4, -3*w/8, d/2])
                    rotate([0, 90, 0])
                    cylinder(h=l, r=d_c/2);
                    
                    translate([l-(3*d_h/4), -d_h, -d/4])
                    cube([d_h, d_h*2, 2*d]);
                }          
            }
            translate([0, 0, d/2])
            rotate([twist, 0, 0])
            translate([l-(d_h/2), 0, -d/2])
            cylinder(h=d, r=d_h/2);
        }
        
                
        translate([0, 0, d/2])
        rotate([0, 90, 0])
        cylinder(h=2*l, r=d_c/2);
    }
};


module coil(
    h, h_i, b, 
    l, n, w,
    d, d_c, d_h,
    twist)
{    
    // End block
    difference()
    {
        union()
        {
            cutout_block(h, h_i, b+eps);
            translate([h, h/2, 0])
            cylinder(h=h, r=d_h/2);
        }
        union()
        {   
            translate([b/2, h/4, h/2])
            rotate([0, 90, 0])
            cylinder(h=b, r=d_c/2);
            translate([b/2, 3*h/4, h/2])
            rotate([0, 90, 0])
            cylinder(h=b, r=d_c/2);
        }
    }
    // Links
    ls = l/n;
    for(i=[0:ceil(sqrt(n))])
    {
        for(j=[0:ceil(sqrt(n))])
        {
            translate([
                b + (i+1) * (ls+1), 
                w/2 + j*(w+1), 
                0
            ])
            link(        
                ls, w, d,
                d_c, d_h,
                twist
            );
        }
    }
};


coil(
    conn_outer, conn_inner, conn_length, 
    bend_length, bend_n, bend_width,
    bend_thickness, cable_d, bend_link_diam,
    bend_twist
);
