include <camera_mount/helpers.scad>
include <mount modules/parts.scad>
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
    37, 43,
    11.1760,
    3
);
M_v = fill_vecs(M_p);
check_param(M_p);


camera_baseline = 57; // Measured
pcb_standoff = 4;
camera_standoff = 4;

module clasp_mount(width, height, slice_t)
{
    translate([(width + 10)/2 - 10, 0, 0])
    union()
    {
        difference()
        {
            union()
            {
                cube([10, slice_t, height+7]);
                translate([0, 4*slice_t, 0])
                cube([10, slice_t, height+7]);
            }
            translate([5, 5*slice_t+0.1, height+3])
            rotate([90, 0, 0])
            cylinder(h=slice_t*5+0.2, r=2);
        }
        translate([-width, 0, 0]) 
        difference()
        {
            union()
            {
                cube([10, slice_t, height+7]);
                translate([0, 4*slice_t, 0])
                cube([10, slice_t, height+7]);
            }
            translate([5, 5*slice_t+0.1, height+3])
            rotate([90, 0, 0])
            cylinder(h=slice_t*5+0.2, r=2);
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
slice_thickness = 6.35; // 1/4 inch thick slices
mount_width = 50;
translate([0, 70, -3])
clasp_mount(mount_width, 30, slice_thickness);
translate([0, -47, -3])
clasp_mount(mount_width, 30, slice_thickness);
 

// Camera plates
difference()
{
    union()
    {
        translate([camera_baseline/2 - 15, -15, 17])
        cube([35, 20, 3]);        
        camera_standoffs(camera_baseline/2, -2.5, 18.9, 4, 2);
    }
    translate([camera_baseline/2, 0, 20-0.1])
    camera_and_mount_diff(camera_standoff);
};
difference()
{   
    union()
    {
        translate([-camera_baseline/2 - 20, -15, 17])
        cube([35, 20, 3]);        
        camera_standoffs(-camera_baseline/2, -2.5, 18.9, 4, 2);
    }
    translate([-camera_baseline/2, 0, 20-0.1])
    camera_and_mount_diff(camera_standoff);
};
translate([-17, -15, -1])
cube([34, 3, 20]);
translate([-50, -15, -1])
cube([3, 20, 20]);
translate([47, -15, -1])
cube([3, 20, 20]);