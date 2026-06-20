del = 0.25;
eps = 0.1;


$fn = $preview ? 30 : 100;


include <BOSL2/std.scad>
include <BOSL2/threading.scad>


module sweep(angle, r1, r2)
{
    difference() {
        arc(n=$fn, r=r1, angle=angle, wedge=true);
        rotate(-1) arc(n=$fn, r=r2, angle=angle+2, wedge=true);
    };
};


module mate(r, l)
{
    linear_extrude(l) union() 
    {
        sweep(angle=360/6 - 1, r1=r, r2=r-3);
        rotate(2*360/6) sweep(angle=360/6 - 1, r1=r, r2=r-3);
        rotate(4*360/6) sweep(angle=360/6 - 1, r1=r, r2=r-3);
    };
};


module part_d(Mx, Mbx, Ax, Bx, Tl, Tm, Dd)
{
    Dl = Mx + (2*Mbx) - Bx - (Ax/2) - Tl;
    
    threaded_rod(Dd, Dl, 1, end_len1=Ax/2);
    
    translate([0, 0, (Dl/2)-eps])
    mate(Dd/2, Tm+eps);
};


module part_t(Tl, Tm, Tb, Ti, To, Ts, S6, S7)
{
difference()
{
    union()
    {
        cylinder(h=Tb, r=To/2);
        translate([0, 0, Tb-eps])
        mate(To/2, Tm+eps);
    };
    union()
    {
        translate([0, 0, -Tb/2])
        cylinder(h=2*Tb, r=Ts/2);
        translate([0, 0, -eps])
        cylinder(h=S6+eps, r=S7/2);
    };
    };
};


//part_d(100, 5, 10, 10, 20, 15, 10);
//part_t(20, 15, 5, 3, 10, 2, 3, 5);