include <camera_mount/helpers.scad>
include <mount modules/parts.scad>
include <grasper4/servo2.scad>
include <grasper4/latch.scad>
include <grasper4/params.scad>


$fn = $preview ? 30 : 100;


show_base = true;

// Motor parameters
M_p = fill_param(
    [10, 30, 30],
    15,
    10,
    [110, 70],
    10, 
    10, 40,
    11.1760,
    3
);
M_v = fill_vecs(M_p);
check_param(M_p);


camera_baseline = 57; // Measured
pcb_standoff = 4;
camera_standoff = 4;


module servo_hole()
{
    difference()
    {
        cube([26, 10, 16]);
        union()
        {
            translate([2-del, 1, 2-del])
            cube([22+2*del, 10, 12+2*del]);            
            translate([-eps, 4+eps, 4+2-del])
            cube([10, 6, 5]);
        }
    }
}

// Base plate
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

// Grasper mount
translate([
    -struct_val(M_p, "Mx")/2 - struct_val(M_p, "Mbx") - conn_inner,
    100-conn_inner-1,
    -3
])
difference()
{
    cube([conn_inner+1, conn_inner, 3]);
    union()
    {
        translate([conn_inner * 3/4, conn_inner/2, -0.5])
        cylinder(h=4, r=2);
        translate([conn_inner * 1/4, conn_inner/2, -0.5])
        cylinder(h=4, r=2);
    }
}
translate([3,struct_val(M_p, "My"),-1])
servo_hole();
translate([-29,struct_val(M_p, "My"),-1])
servo_hole();

// Latch 
translate([
    struct_val(M_p, "Mx")/2 + struct_val(M_p, "Mbx")-5,
    struct_val(M_p, "My") - conn_inner,
    -3
])
rotate([180,0,0])
rotate([0,90,0])
rotate([0,0,90])
latch(
    conn_inner*1.2, 5, servo_mount_length,
    servo_width+5, pin_height+3*pin_diam/2, pin_height - pin_diam/2 - (loop_outer-loop_inner)/2 - 2,
    pin_diam, pin_act_diam, 2.5, servo_tab, pin_height,
    servo_depth+2, 2*pin_diam, servo_width, servo_length, servo_depth, servo_height
);

// Camera plates
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