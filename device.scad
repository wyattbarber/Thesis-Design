include <camera_mount/helpers.scad>
include <grasper/coil.scad>
include <mount modules/parts.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <MCAD/servos.scad>


$fn = $preview ? 30 : 100;

show_grasper = false;
show_base = false;
show_rod = true;
show_carriage = false;
show_driver = false;
show_guides = false;
show_electronics = false;

camera_baseline = 57; // Measured
pcb_standoff = 4;
camera_standoff = 4;


union()
{
//    main_board(pcb_standoff+0.1, show_electronics);
//    translate([-camera_baseline/2, 0, 20-0.1]) camera_and_mount(camera_standoff+0.1, show_electronics);
//    translate([camera_baseline/2, 0, 20-0.1]) camera_and_mount(camera_standoff+0.1, show_electronics);
}

// Motor parameters
M_p = fill_param(
    [10, 30, 30],
    15,
    10,
    [90, 70],
    10, 
    10, 40,
    11.1760,
    3
);
M_v = fill_vecs(M_p);
check_param(M_p);

// Grasper parameters
G_w = 20;
G_l = 250;
G_pitch = -60;
G_n = 11;
G_t = 3; 
G_md = 1;

module ring(r1, r2, h)
{
    difference() {
        cylinder(h=h, r=r1);
        translate([0, 0, -1]) cylinder(h=h+2, r=r2);
    };
};

module sweep(angle, r1, r2)
{
    difference() {
        arc(n=$fn, r=r1, angle=angle, wedge=true);
        rotate(-1) arc(n=$fn, r=r2, angle=angle+2, wedge=true);
    };
};


if(show_driver) {
    part_t(
        struct_val(M_p, "Tl"),
        struct_val(M_p, "Tm"),
        struct_val(M_p, "Tb"),
        struct_val(M_p, "Ti"),
        struct_val(M_p, "To"),
        struct_val(M_p, "Ts"),
        struct_val(M_p, "S6"),
        struct_val(M_p, "S7")
    );
};



if(show_rod) {
    part_d(
        struct_val(M_p, "Mx"),
        struct_val(M_p, "Mbx"),
        struct_val(M_p, "Ax"),
        struct_val(M_p, "Bx"),
        struct_val(M_p, "Tl"),
        struct_val(M_p, "Tm"),
        struct_val(M_p, "Dd")
    );
};


if(show_guides) {
    part_g(
        struct_val(M_p, "Ga"),
        struct_val(M_p, "Gb"),
        struct_val(M_p, "Gc"),
        struct_val(M_p, "Gt"),
        struct_val(M_p, "Gm"),
        struct_val(M_p, "Gd"),
        struct_val(M_p, "Mx"),
        struct_val(M_p, "Mbx")
    );
    translate([10, 0, 0])
    part_g(
        struct_val(M_p, "Ga"),
        struct_val(M_p, "Gb"),
        struct_val(M_p, "Gc"),
        struct_val(M_p, "Gt"),
        struct_val(M_p, "Gm"),
        struct_val(M_p, "Gd"),
        struct_val(M_p, "Mx"),
        struct_val(M_p, "Mbx")
    );
    
    for(i = [0:1])
    {
        for(j = [1:2])
        {    
            translate([i*10, j*10, struct_val(M_p, "Ga")])
            part_g1(
                struct_val(M_p, "Ga"),
                struct_val(M_p, "Gb"),
                struct_val(M_p, "Gc"),
                struct_val(M_p, "Gt"),
                struct_val(M_p, "Gm")
            );
        };
    };
};


if(show_carriage) {
    part_c(
        struct_val(M_p, "Cx"),
        struct_val(M_p, "Cy"),
        struct_val(M_p, "Cz"),
        struct_val(M_p, "Dd"),
        struct_val(M_p, "Gd"),
        struct_val(M_p, "Gw"),
        struct_val(M_p, "Ca"),
        struct_val(M_p, "Cb")
    );
};
// Base plate
if(show_base) {
    difference()
    {
        translate([
            -struct_val(M_p, "Mx")/2 - struct_val(M_p, "Mbx"), 
            -struct_val(M_p, "Mby1") - struct_val(M_p, "Vy"), 
            -3
        ])
        cube([
            struct_val(M_p, "Mx") + 2*struct_val(M_p, "Mbx"), 
            struct_val(M_p, "My") + struct_val(M_p, "Mby1") + struct_val(M_p, "Mby2"), 
            3
        ]);
        main_board_diff(pcb_standoff);
    };

    // Servo mount support
    translate(struct_val(M_v, "A"))
    part_a(
        struct_val(M_p, "Ax"),
        struct_val(M_p, "Ay"),
        struct_val(M_p, "Az"),
        struct_val(M_p, "Dd"),
        struct_val(M_p, "Gd"),
        struct_val(M_p, "Gw")
    );        
    translate(struct_val(M_v, "B"))
    part_b(
        struct_val(M_p, "Bx"),
        struct_val(M_p, "By"),
        struct_val(M_p, "Bz"),
        struct_val(M_p, "Dd"),
        struct_val(M_p, "Gd"),
        struct_val(M_p, "Gw")
    );            
    translate(struct_val(M_v, "U"))
    part_u(
        struct_val(M_p, "Ux"),
        struct_val(M_p, "Uy"),
        struct_val(M_p, "Uz"),
    );  
};

// Grasper
if(show_grasper) {
    translate([0, M_orig[1] - M_L[0], 31])  
    grasper(G_w, G_l, G_pitch, G_n, G_t, G_md);
};

// Camera plates
if(show_base) {
    difference()
    {
        translate([camera_baseline/2 - 15, -15, 17])
        cube([35, 20, 3]);
        translate([camera_baseline/2, 0, 20-0.1])
        camera_and_mount_diff(camera_standoff);
    };
    difference()
    {
        translate([-camera_baseline/2 - 20, -15, 17])
        cube([35, 20, 3]);
        translate([-camera_baseline/2, 0, 20-0.1])
        camera_and_mount_diff(camera_standoff);
    };
    translate([-17, -15, -1])
    cube([34, 3, 20]);
    translate([-50, -15, -1])
    cube([3, 20, 20]);
    translate([47, -15, -1])
    cube([3, 20, 20]);
};