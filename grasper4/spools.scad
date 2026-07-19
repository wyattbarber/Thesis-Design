include <helpers.scad>
include <params.scad>

module servo_spool(d_o, d_i, t, s_d)
{
    difference()
    {
        flared_cylinder(t, d_i/2, d_o/2);
        union()
        {
            translate([d_o/2, 0, t/3])
            half_ring(t/3, d_o/3, d_o/3 - 2);
            
            translate([0,0,-0.5])
            cylinder(h=t+1, r=s_d/2);
            
            translate([-4, -13.5, -eps])
            cube([8, 27, 2+eps]);
            translate([-13.5, -4, -eps])
            cube([27, 8, 2+eps]);
        }
    }
}

module double_spool(d_o, d_i, t, s_d)
{
    servo_spool(d_o, d_i, t, s_d);
    translate([0,0,t-eps])
    difference()
    {        
        servo_spool(d_o, d_i, t, s_d);
        translate([0,0,-t/4])
        cylinder(h=2*t, r=s_d/2 + 1);
    }
};

// Single spool
servo_spool(spool_diam_o, spool_diam_i, spool_t, 7.5);

// Dual-direction spool
//translate([spool_diam_o+1, 0, 0])
//double_spool(spool_diam_o, spool_diam_i, spool_t, 7.5);