include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn = $preview ? 100 : 1000;


function arc_points(r, a1, a2) = [ 
    for (a = [a1 : sign(a2 - a1) : a2]) [r * cos(a), r * sin(a)] 
];


module arc2d(or, ir, a1, a2) {
    polygon([
        each arc_points(ir, a1, a2), 
        each arc_points(or, a2, a1)
    ]);
}


module servo_hole(a)
{
    translate([0, 5, 0])
    difference()
    {
        union()
        {
            square([22,36], center=true);
            translate([-8-(a/2)+0.1, 0, 0])
            square([a+0.1, 36], center=true);
        }
        union()
        {
            square([13,23], center=true);
            translate([8, 13, 0])
            circle(1.5);
            translate([-8, 13, 0])
            circle(1.5);
            translate([8, -13, 0])
            circle(1.5);
            translate([-8, -13, 0])
            circle(1.5);
        }
    }
}


module align_hole()
{
    difference()
    {
        union()
        {
            circle(5);
            translate([-5, 0, 0])
            square([10,10], center=true);
        }
        circle(2);
    }
}


module align_holes(r_2, theta_s, theta_sp, theta_b, theta_bp, mount_width)
{ 
    r_m = r_2 + 2;    
    theta_m = asin(mount_width / (2 * r_m));
    
    th1 = (270 - theta_sp) - (theta_s/2);
    th2 = theta_o/2;
    
    rotate([0, 0, (th1 + th2)/2-10])
    translate([r_m, 0, 0])
    align_hole();
    
    rotate([0, 0, (th1 + th2)/2+10])
    translate([r_m, 0, 0])
    align_hole();    
            
    rotate([0, 0, -90-theta_bp+(theta_b/2)])
    translate([r_m, 0, 0])
    align_hole();    
    
    rotate([0, 0, 180-theta_m])
    translate([r_m, 0, 0])
    align_hole();
    
    rotate([0, 0, 180+theta_m])
    translate([r_m, 0, 0])
    align_hole();
}

module gear_ring(r_3, circ_p, n, theta_o, theta_b, theta_bp)
{
    theta_ob = 90 - ((theta_o/2) + (theta_b - theta_bp));
    difference()
    {
        spur_gear2d(circ_p, n);
        union()
        {
            circle(r_3);
            arc2d(
                outer_radius(circ_p,n)*3/2, r_3/2, 
                -theta_o/2, (theta_o/2) + theta_ob + theta_b);
        }   
    }
};


module track_ring_1(r_1, r_2, r_5, theta_o, theta_s, theta_sp, theta_b, theta_bp, mount_width)
{
    difference()
    {
        union()
        {
            circle(r_2);
            
            rotate([0, 0, 270 - theta_sp])
            translate([r_5, 0, 0])
            servo_hole(r_2-r_1);
            
            align_holes(r_2, theta_s, theta_sp, theta_b, theta_bp, mount_width);
        }
        union()
        {
            circle(r_1);
            arc2d(
                1.1*r_2, 0.9*r_1,
                -theta_o/2, theta_o/2
            );
        }
    }
}


module track_ring_2(r_1, r_2, r_3, r_4, circ_p, n, 
    theta_o, theta_s, theta_sp, theta_b, theta_bp, mount_width)
{    
    // Outer wall
    difference()
    {
        union()
        {
            circle(r_2);
            
            align_holes(r_2, theta_s, theta_sp, theta_b, theta_bp, mount_width);
        }
        union()
        {
            circle(r_4);
            arc2d(
                1.1*r_2, 0.9*r_4,
                -theta_o/2, theta_o/2
            );
            rotate(270 - theta_sp)
            arc2d(
                1.1*r_2, 0.9*r_4,
                -theta_s/2, theta_s/2
            );
        }
    }
    // Inner wall
    difference()
    {
        circle(r_3);
        union()
        {
            circle(r_1);
            arc2d(
                1.1*r_2, 0.9*r_1,
                -theta_o/2, theta_o/2
            );
        }
    }
    // Block
    arc2d(
        r_1, r_2,
        -90-theta_bp, -90-theta_bp+theta_b
    );    
    // Knob for locking
    r_k = outer_radius(circ_p, n) - pitch_radius(circ_p, n);
    rotate([0,0,-theta_o/2-asin(r_k/r_4)])
    translate([r_4, 0, 0])
    circle(r_k);
}


module track_ring_3(r_1, r_2, theta_o, theta_s, theta_sp, theta_b, theta_bp, mount_width)
{
    difference()
    {   
        union()
        {
            circle(r_2);
            
            align_holes(r_2, theta_s, theta_sp, theta_b, theta_bp, mount_width);
        }
        union()
        {
            circle(r_1);
            arc2d(
                1.1*r_2, 0.9*r_1,
                -theta_o/2, theta_o/2
            );
        }
    }
};


module servo_gear(circ_p, n, t)
{
    servo_axel_diam = 5;
    l = 2 * root_radius(n, circ_pitch=circ_p) - 4;
    difference()
    {
        translate([0,0,t/2])
        spur_gear(circ_p, n_g, t);
        union()
        {            
            translate([0,0,-0.5])
            cylinder(h=t+1, r=servo_axel_diam/2);
            
            translate([-4, -l/2, -0.01])
            cube([8, l, t/2]);
            translate([-l/2, -4, -0.01])
            cube([l, 8, t/2]);
        };
    }
}


max_width = 50;
circ_p = 5;
n = 57;
r_1 = 35;
r_2 = 50;
r_3 = 40;
r_4 = outer_radius(circ_p, n) + 0.1;
r_5 = 60;
theta_o = 2 * asin(max_width / (2 * r_1));
theta_sp = 165;
theta_b = 45;
theta_bp = 25;
theta_ob = 90 - ((theta_o/2) + (theta_b - theta_bp));
r_g = r_5 - pitch_radius(circ_p, n);
n_g = round((PI*2*r_g)/circ_p);
theta_s = (2*outer_radius(circ_p, n_g)/r_2) * 180 / PI;
mount_width = 50;

assert(r_4 < r_2, "Required gear clearance exceeds outer radius");
assert(theta_sp > theta_o + theta_ob, "Servo position results in insufficient travel");
assert(r_4 > r_3, "Latch outer radius is smaller than inner radius");
assert(r_2 > r_1, "Guide outer radius is smaller than inner radius");
assert(abs(r_g - pitch_radius(circ_p, n_g)) <= 0.5, "Servo gear cannot correctly align");
assert(abs(r_5 - gear_dist(n, n_g, circ_pitch=circ_p)) <= 0.5, "Servo gear cannot correctly align");


linear_extrude(6.35) union() // 1/4 inch slices
{
    translate([0, 2 * r_2 + 15, 0])
    track_ring_1(r_1, r_2, r_5, theta_o, theta_s, theta_sp, theta_b, theta_bp, mount_width);
    
    track_ring_2(r_1, r_2, r_3, r_4, circ_p, n, 
    theta_o, theta_s, theta_sp, theta_b, theta_bp, mount_width);

    translate([0, -2 * r_2 - 15, 0])
    track_ring_3(r_1, r_2, theta_o, theta_s, theta_sp, theta_b, theta_bp, mount_width);
        
    rotate([180, 0, 0])
    translate([-2 * r_2 - 10, 0, 0])
    gear_ring(r_3, circ_p, n, theta_o, theta_b, theta_bp);
}

translate([-2 * r_2 - 10, 0, 0])
servo_gear(circ_p, n_g, 6.35);



