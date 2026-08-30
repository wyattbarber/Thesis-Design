include <helpers.scad>
include <params.scad>
include <BOSL2/std.scad>
include <BOSL2/gears.scad>


module latch(
    w1, w2, w3,
    h1, h2, h3,
    d1, d2, l1, l2, l3,
    t1, t2, sw, sl, sd, sh
)
{
    l4 = t2 / 2;
    
    // Servo block
    translate([0, -t1, -12])
    cube([w3, t1, h1]);
    translate([0, -t1-sw, -12])
    difference()
    {
        cube([w3, t1, h1]);
        translate([l1, -eps, l2])
        union()
        {
            cube([sl+2*del, sd+eps, 2*sw]);
            translate([sl, 0, sw/3-del])
            cube([sl, sd+eps, sw/3+2*del]);
        };
    };
    
    // Pin block
    difference()
    {
        union()
        {
            translate([-(w1+2*w2), -t2/2, 0])
            rotate([0,0,-90])
            triangle_2(t2, h3, w1+2*w2+eps);
            translate([0, 0, eps])
            rotate([0,90,180])
            triangle(t2, h3/2, w1+2*w2+eps);
            translate([-w2, -t2, 0])
            cube([w2+eps, t2, h2]);
            translate([-w2*2-w1, -t2, 0])
            cube([w2, t2, h2]);
            translate([(sl+2*del)+l1, -t2, 0])
            cube([w2, t2, h2]);
            translate([-w2/2, -t2+l4, l3-(d1+del)/2 - 2])
            cube([w3, d1/2+1, d1+4]);
        };
        union()
        {
            translate([-500, -t2+l4-(d1+del)/2, l3-(d1+del)/2])
            cube([1000, (d1+del), (d1+del)]);
            translate([(sl+2*del)+l1-eps, -t2-eps, h2/2])
            cube([w2+2*eps, t2/2+eps, h2/2+eps]);
        }
    }
};


module pin(
    w1, w2, w3,
    d1, d2
)
{
    L = w1+(2*w2)+(2*d2)+w3;
    p = 4;
    n = floor(L / p);
    
    translate([L/2,d1/2,d1/2 - eps])
    rack(pitch=p, teeth=n, thickness=d1, width=d1/2 + eps, anchor=BOTTOM);  
    cube([L, d1, d1/2]);
    translate([eps, d1/2, d1/2]) 
    rotate([45, 0, 0])
    rotate([0, -90, 0])
    cylinder(h=d1, r1=sqrt(2)*d1/2, r2=0, $fn=4);
    cube([p/2, d1, d1]);
};


module gear(
    w1, w2, w3,
    d1, d2
)
{    
    p = 4;
    D = 24;
    C = D * PI;
    n = floor(C/p);
    t = 8;
    
    translate([0,0,t])
    rotate([180,0,0])
    difference()
    {
        translate([0,0,t/2])
        spur_gear(circ_pitch=p, teeth=n, thickness=t);
        union()
        {            
            translate([0,0,-0.5])
            cylinder(h=t+1, r=servo_axel_diam/2);
            
            translate([-4, -13.5, -eps])
            cube([8, 27, t/2]);
            translate([-13.5, -4, -eps])
            cube([27, 8, t/2]);
        };
    };
}


//latch(
//    conn_inner*1.2, 5, servo_mount_length,
//    servo_width+5, pin_height+3*pin_diam/2, pin_height - pin_diam/2 - (loop_outer-loop_inner)/2 - 2,
//    pin_diam, pin_act_diam, servo_tab, 2.5, pin_height,
//    servo_depth+2, 2*pin_diam, servo_width, servo_length, servo_depth, servo_height
//);


//pin(conn_inner*1.2, 5, servo_mount_length, pin_diam, 10);

//gear(conn_inner*1.2, 5, servo_mount_length, pin_diam, 10);