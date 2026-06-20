include <helpers.scad>
include <params.scad>


module large_bend(
    h, h_i, l, b, n,
    d, w_g, h_g,
    t
)
{
    a = (l - (2*b)) / (n+1);
    
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
            translate([b+(n+1)*a, h, 0])
            rotate([-90, -90, 180])
            triangle(a/2, h, h);
            
            // Full angle wedges
            for(i = [1:n])
            {
                translate([b+i*a, 0, 0])
                triangle_2(a, h, h);
            }
            
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

large_bend(
    conn_outer, conn_inner, bend_length, conn_length, bend_n,
    cable_d, flex_w, flex_t,
    base_thickness
);