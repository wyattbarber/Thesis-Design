del = 0.25;
eps = 0.1;


include <BOSL2/std.scad>
include <BOSL2/threading.scad>


module part_c(Cx, Cy, Cz, Dd, Gd, Gw, Ca, Cb)
{
difference()
{
    linear_extrude(height=Cx)
    polygon(points=[
        [Cz/2, -Dd/2],
        [Gd/2, -Cy/2],
        [-Gd/2, -Cy/2],
        [-Cz/2, -Dd/2],
        [-Cz/2, Dd/2],
        [-Gd/2, Cy/2],
        [Gd/2, Cy/2],
        [Cz/2, Dd/2]
    ]);

    union()
    {
        threaded_rod(Dd+2*del, 3*Cx, 1);
        
        translate([0, Gw/2, -Cx/2])
        cylinder(h=2*Cx, r=(Gd/2)+del);
        
        translate([0, -Gw/2, -Cx/2])
        cylinder(h=2*Cx, r=(Gd/2)+del);
        
        translate([Cb, 0, -Cx/2])
        cylinder(h=2*Cx, r=(Ca/2)+del);
        
        translate([-Cb, 0, -Cx/2])
        cylinder(h=2*Cx, r=(Ca/2)+del);
    }
}
}

//part_c(10, 30, 30, 8, 5, 15, 3, 10); 