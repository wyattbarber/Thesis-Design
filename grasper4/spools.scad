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
            half_ring(t/3, d_o/4, d_o/4 - 2);
            
            cylinder(h=t*2, r=s_d/4);
            translate([0, 0, -eps])
            cylinder(h=2*t/3+eps, r=s_d/2);
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
servo_spool(spool_diam_o, spool_diam_i, spool_t, servo_axel_diam);

// Dual-direction spool
translate([spool_diam_o+1, 0, 0])
double_spool(spool_diam_o, spool_diam_i, spool_t, servo_axel_diam);