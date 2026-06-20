del = 0.25;
eps = 0.1;


module part_u(Ux, Uy, Uz)
{
    translate([Ux/2, Uy/2, -Uz])
    difference()
    {
        translate([-Ux/2, -Uy/2, 0]) cube([Ux, Uy, Uz]);
        translate([0, 0, -Uz/4]) cylinder(h=2*Uz, r=Uy/4);
    };
};

