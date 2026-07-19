include <helpers.scad>
include <params.scad>


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
        };
        translate([w2/2, -t2+l4, l3])
        rotate([0, -90, 0])
        cylinder(h=w1+3*w2, r=(d1+del)/2);
    }
};


module pin(
    w1, w2, 
    d1, d2
)
{
    difference()
    {
        cylinder(h=w1+(2*w2)+(2*d2), r=d1/2);
        translate([-d1/2, -1.5, d2])
        cube([2*d1, 3, d2]);        
    };
};


//latch(
//    conn_inner*1.2, 5, servo_mount_length,
//    servo_width+5, pin_height+3*pin_diam/2, pin_height - pin_diam/2 - (loop_outer-loop_inner)/2 - 2,
//    pin_diam, pin_act_diam, servo_tab, 2.5, pin_height,
//    servo_depth+2, 2*pin_diam, servo_width, servo_length, servo_depth, servo_height
//);


pin(conn_inner*1.2, 5, pin_diam, 10);