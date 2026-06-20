include <helpers.scad>
include <params.scad>


module right_bend(
    h, h_i, b,
    d, w_g, h_g,
    t
)
{
    theta = 15;
    a = 2*h*tan(theta);
    l = 2*b + 3*a;
    
    difference()
    {
        union()
        {
            // End blocks
            cutout_block(h, h_i, b+eps);
            translate([l, h, 0])
            rotate([0, 0, 180])
            cutout_block(h, h_i, b+eps);
            
            // Half-angle wedges
            translate([b, 0, 0])
            rotate([-90, -90, 0])
            triangle(a/2, h, h);
            translate([b+3*a, h, 0])
            rotate([-90, -90, 180])
            triangle(a/2, h, h);
            
            // Full angle wedges
            translate([b+a, 0, 0])
            triangle_2(a, h, h);
            translate([b+2*a, 0, 0])
            triangle_2(a, h, h);
            
            // Thin base
            cube([l, h, t]);
        }
        union()
        {
            // Cable routing
            translate([b/2, h/2, 2*h/3])
            rotate([0, 90, 0])
            flared_cylinder(l-b, d/2, d/2 + 1);
            // Flex guide
            translate([-l/4, (h-w_g)/2, (h-h_i)/2])
            cube([2*l, w_g, h_g]);
        }
    }
};

right_bend(
    conn_outer, conn_inner, conn_length,
    cable_d, flex_w, flex_t,
    base_thickness
);