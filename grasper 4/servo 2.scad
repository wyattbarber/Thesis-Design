include <helpers.scad>
include <params.scad>


module servo_mount_2(
    l1, l2, l3, l4, l5,
    d, h,
    s9
)
{
    difference()
    {
        cube([l2, d, l1]);
        union()
        {
            // Center cutout
            translate([
                l2/2 - h/2, 
                -d/4, 
                l1/2 - h/2 - del
            ])
            cube([l2, 2*d, h+2*del]);
            // Lower cutout
            translate([
                l2 - l4,
                -eps, 
                l1/2 - l3/2 - s9 - (l3-h)/2 - del
            ])
            cube([l4+eps, l5+eps, s9+2*del]);            
            // Upper cutout
            translate([
                l2 - l4,
                -eps, 
                l1/2 + l3/2 + (l3-h)/2 - del
            ])
            cube([l4+eps, l5+eps, s9+2*del]);
        };
    };
};

rotate([0, -90, 0])
servo_mount_2(
    conn_outer+2*servo_width+8,
    conn_outer+1,
    servo_attach_width,
    servo_attach_width/2 - servo_gear_shaft,
    servo_attach_length,
    servo_attach_length+2, conn_outer,
    servo_width
);