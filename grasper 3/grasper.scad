$fn = $preview ? 10 : 100;

test = false;

module base(
    w, l, t, theta,
    d_m, d_c,
    w_m
) 
{
    p1 = [
        (t/2)*cos(theta),
        (t/2)*sin(theta)
    ];
    p2 = p1 + [0, w];
    p4 = [
        (l-t)*cos(theta),
        (l-t)*sin(theta)
    ] + p1;
    p3 = p4 + [0, w];
    
    translate([0, 0, -t/2]) 
    difference()
    {
        union()
        {
            linear_extrude(height=t)
            polygon([
                p1, p2, p3, p4
            ]);
            
            translate([t/2, 0, t/2])
            rotate([-90, 0, 0])
            cylinder(h=w, r=t/2);
            
            translate([
                l * cos(theta) - t/2,
                l * sin(theta) - t/2,
                t/2
            ])
            rotate([-90, 0, 0])
            cylinder(h=w, r=t/2);
        }
        union()
        {
            translate([
                (l/2)*cos(theta),
                (l/2)*sin(theta) + w/2,
                -t/2
            ])
            cylinder(h=t*2, r=d_c/2);
            
            translate([
                (l/2)*cos(theta),
                (l/2)*sin(theta) + w/2 - w_m/2,
                -t/2
            ])
            cylinder(h=t*2, r=d_m/2);
            translate([
                (l/2)*cos(theta),
                (l/2)*sin(theta) + w/2 + w_m/2,
                -t/2
            ])
            cylinder(h=t*2, r=d_m/2);
        }
    }
};

module flex_guide(wo, wi, l, to, ti, theta)
{
    translate([
        0,
        (wo - wi)/2,
        -ti
    ])
    rotate([0, 0, theta])
    cube([l*2, wi*cos(theta), ti]);
}

module wire_guide_a(wo, wi, wg, to, tg, l, theta)
{
    translate([
        0,
        (wo - wi)/2,
        (to/2 - tg)/2
    ])
    rotate([0, 0, theta])
    cube([l*2, wg*cos(theta), tg]);    
    
    translate([
        0,
        wo - (wo - wi)/2 - wg,
        (to/2 - tg)/2
    ])
    rotate([0, 0, theta])
    cube([l*2, wg*cos(theta), tg]);
}

module wire_guide_b(wo, wi, wg, to, tg, l, theta)
{
    translate([
        0,
        (wo - wi)/2,
        (to/2 - tg)/2
    ])
    rotate([0, 0, theta + (90 - theta)/2.5])
    cube([l*2, wg*cos(theta), tg]);    
    
    translate([
        0,
        wo - (wo - wi)/2 - wg,
        (to/2 - tg)/2
    ])
    rotate([0, 0, theta - (180 - theta)/3])
    cube([l*2, wg*cos(theta), tg]);
}


if(test)
{
    base(40, 40, 8, 45, 5, 10, 20);
    color("blue") flex_guide(40, 30, 40, 8, 2, 45);
    color("red") wire_guide_a(40, 30, 2, 8, 2, 40, 45);
    color("green") wire_guide_b(40, 30, 2, 8, 2, 40, 45);
}


module unit(
    w, l, t, theta,
    dm, wm, dg
)
{
    difference()
    {
        base(w, l, t, theta, dm, dg, wm);
        union()
        {
            flex_guide(w, w-10, l, t, 2, theta);
            wire_guide_a(w, w-10, 2, t, 2, l, theta);
            wire_guide_b(w, w-10, 2, t, 2, l, theta);
        }
    }
}

module assembly(
    w, l, t, theta,
    dm, wm, dg)
{
    n = ceil(l/40);
    
    for(i = [0:n])
    {
        translate([
            i*45*cos(theta),
            i*45*sin(theta),
            0            
        ]) unit(w, 40, t, theta, dm, wm, dg);
    }
}

w = 40;
l = 400;
t = 10;
theta = 45;
dm = 3;
dg = 10;
wm = 20;

if(!test)
{
    assembly(w, l, t, theta, dm, wm, dg);
}

