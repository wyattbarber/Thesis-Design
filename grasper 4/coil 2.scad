include <helpers.scad>
include <params.scad>


module link(a, h, theta)
{
    n = $fn;
    
    for(i=[0:n-1])
    {
        translate([
            i * h/n * tan(theta), 
            i * h/n, 
            0]
           )
        union()
        {
            triangle_2(a, h/2, h/n + eps);
            rotate([0, 180, 0])
            triangle_2(a, h/2, h/n + eps);
        }
    }
};


module coil_2(
    h, h_i, l, b, n,
    d, w_g, h_g,
    t, twist
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
            
            // Full angle wedges
            for(i = [0:n+1])
            {
                translate([b+(i*a), 0, h/2])
                link(a, h, twist);
            }
            
            // Thin base
            translate([b, 0, h/2])
            cube([l-2*b, h, t]);
        }
        union()
        {
            // Cable routing
            translate([b/2, h/2, 3*h/4])
            rotate([0, 90, 0])
            flared_cylinder(l-b, d/2, d/2 + 1);
            translate([b/2, h/2, h/4])
            rotate([0, 90, 0])
            flared_cylinder(l-b, d/2, d/2 + 1);
        }
    }
};



coil_2(
    conn_outer, conn_inner, bend_length, conn_length, bend_n,
    cable_d, flex_w, flex_t,
    base_thickness, bend_twist
);

