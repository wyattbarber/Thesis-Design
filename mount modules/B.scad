del = 0.25;
eps = 0.1;

include <MCAD/servos.scad>


module servo(S2, S5, S6)
{
    rotate([180, 0, 0])
    rotate([0, 90, 0])
    translate([0, 0, -(S2 + (S5-S6))])
    towerprosg90(position=[0,0,0], rotation=[0,0,0], screws = 0, axle_length = 0, cables=0);
    
};


module part_b(Bx, By, Bz, Dd, Gd, Gw)
{
    l1 = (By - Gw) / 2;
    
    difference()
    {
        translate([0, 0, -del]) cube([Bx, By, Bz+del]);

        union()
        {
            translate([-Bx/4, l1+Gw, Bz/2])
            rotate([0, 90, 0])
            cylinder(h=2*Bx, r=(Gd/2)+eps);

            translate([-Bx/4, l1, Bz/2])
            rotate([0, 90, 0])
            cylinder(h=2*Bx, r=(Gd/2)+eps);
                        
            translate([Bx, By/2, Bz/2])
            scale([1.1, 1.1, 1.1]) servo(23, 8, 5);
        }
    }
};


//part_b(10, 40, 40, 8, 5, 15);