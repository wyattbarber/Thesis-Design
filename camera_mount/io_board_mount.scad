include <helpers.scad>

// Base and mount holes
difference(){
    cube([180, 110, 2]);
    union(){
        translate([14, 90, -0.5])
            cylinder(3, r=2);
        translate([14, 22, -0.5])
            cylinder(3, r=2);
        translate([159, 90, -0.5])
            cylinder(3, r=2);
        translate([159, 22, -0.5])
            cylinder(3, r=2);
    };
};

// Camera platform
union(){
    difference(){
        union(){
            // Platform
            translate([86, 0, 40]) cube([30, 30, 2]);
            translate([150, 63, 40]) cube([30, 30, 2]);
            translate([116, 0, 40]) rotate([0, 0, 45])
                cube([90, 30, 2]);
            // Camera standoffs
            translate([115, 25, 41]) rotate([0, 0, 45])
                camera_standoffs(0, 0, 0, 3, 3);
            translate([155, 65, 41]) rotate([0, 0, 45])
                camera_standoffs(0, 0, 0, 3, 3);
        };
        union(){
            translate([115, 25, 41]) rotate([0, 0, 45])
            translate([0,0,-3]) camera_standoffs(0, 0, 0, 7, 2);
            translate([155, 65, 41]) rotate([0, 0, 45])
            translate([0,0,-3]) camera_standoffs(0, 0, 0, 7, 2);
        }
    };
};

// Vertical connectors
translate([86, 0, 0]) cube([30, 2, 42]);
translate([178, 63, 0]) cube([2, 30, 42]);