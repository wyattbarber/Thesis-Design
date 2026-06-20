del = 0.25;
eps = 0.1;

include <BOSL2/std.scad>


module part_a(Ax, Ay, Az, Dd, Gd, Gw)
{
    l1 = (Ay - Gw) / 2;
    
    difference()
    {
        union()
        {
            translate([0, Ay/2, (Az/2)+Dd])
            rotate_extrude(convexity = 10)
            translate([3, 0, 0])
                circle(r = 1);
            translate([0, 0, -del]) cube([Ax, Ay, Az+del]);
        };
        
        union()
        {
            translate([-Ax/4, l1+Gw, Az/2])
            rotate([0, 90, 0])
            cylinder(h=2*Ax, r=(Gd/2)+eps);

            translate([-Ax/4, l1, Az/2])
            rotate([0, 90, 0])
            cylinder(h=2*Ax, r=(Gd/2)+eps);
            
            translate([Ax/2, Ay/2, Az/2])
            rotate([0, -90, 0])
            cylinder(h=Ax, r=(Dd/2)+eps);
        }
    }
};


//part_a(10, 40, 40, 8, 5, 15);