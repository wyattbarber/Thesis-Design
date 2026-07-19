include <helpers.scad>
include <params.scad>


module servo_mount_2(
    l1, l2, l3, l4, l5,
    d, h,
    s2, s3, s4, s9, st
)
{
    difference()
    {
        cube([l2+s2, d, l1]);
        union()
        {
            // Center cutout
            translate([
                l2/2 - h/2, 
                -d/4, 
                l1/2 - h/2 - del
            ])
            cube([l2+s2, 2*d, h+2*del]);
            // Lower cutout
            translate([
                l2 - l4,
                -eps, 
                2-del
            ])
            union()
            {
                cube([s2+2*del, 2, s9+2*del]);   
                translate([s2-(s3+s4)-del, 2-eps, 0])
                cube([s4+2*del, st+eps, s9+2*del]);
            }
            // Upper cutout
            translate([
                l2 - l4,
                -eps, 
                l1-s9-2-del
            ])
            union()
            {
                cube([s2+2*del, 2, s9+2*del]);   
                translate([s2-(s3+s4)-del, 2-eps, 0])
                cube([s4+2*del, st+eps, s9+2*del]);
            }
        };
    };
};

//rotate([-90, 0, 0])
//servo_mount_2(
//    conn_outer+2*servo_width+8,
//    conn_outer+1,
//    servo_attach_width,
//    servo_attach_width/2 - servo_gear_shaft,
//    servo_attach_length,
//    servo_attach_length+2, conn_inner,
//    23, 17, 2, 12, servo_tab
//);