include <helpers.scad>
include <params.scad>


module servo_mount(
    l1, l2, w1, w2, h,
    s_w, s_l, s_d,
    a
)
{
    difference()
    {
        union()
        {
            cube([l1, w1, h]);
            difference()
            {                
                translate([l1-eps, 0, 0])
                cube([l2+eps, w1, h]);
                
                translate([
                    l1,
                    (w1-w2)/2 - del,
                    -eps
                ])
                cube([l2+eps, w2+2*del, h+2*eps]);
            }
        }
        union()
        {
            y = a - s_w;
            x = (w1 - y - (2*s_w)) / 2;
            b1 = x + s_w + y;
            b2 = x;
            
            translate([-eps, b1, h-s_d])
            cube([s_l+eps, s_w, s_d+eps]);
            translate([-eps, b2, h-s_d])
            cube([s_l+eps, s_w, s_d+eps]);
            
            translate([
                s_l + h/4,
                -w1/4,
                2*h/3
            ])
            rotate([-90, 0, 0])
            cylinder(h=2*w1, r=h/4);
        }
    }
};


servo_mount(
    servo_mount_length, servo_attach_length,
    servo_mount_width, servo_attach_width,
    servo_mount_height,
    servo_width, servo_length, servo_depth,
    servo_spacing
);