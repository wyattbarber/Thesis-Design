del = 0.25;
eps = 0.1;


module part_g1(Ga, Gb, Gc, Gt, Gm)
{
    translate([-Gm/2, -Gb/2, -eps])
    cube([Gm, Gb, Gt+eps]);
    
    translate([-Gb/2, -Gm/2, -eps])
    cube([Gb, Gm, Gt+eps]);
    
    translate([0, 0, -Ga])
    cylinder(h=Ga, r=Gc/2);
};


module part_g(Ga, Gb, Gc, Gt, Gm, Gd, Mx, Mxb)
{
    l = Mx + (2*Mxb);
    difference()
    {    
        cylinder(h=l, r=Gd/2);
        
        union()
        {
            part_g1(Ga, Gb+eps, Gc, Gt, Gm+eps);
            translate([0, 0, l])
            rotate([180, 0, 0])
            part_g1(Ga, Gb+eps, Gc, Gt, Gm+eps);
        };
    };
};


//part_g(3, 5, 8, 5, 2, 7, 100, 5);