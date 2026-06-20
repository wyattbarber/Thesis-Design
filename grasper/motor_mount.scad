include <BOSL2/std.scad>
include<BOSL2/gears.scad>
include <MCAD/servos.scad>


gear_pitch = 2;
min_thickness = 2;
gear_clearance = 3; // Clearance around non-contacting gears
rotation_clearance = 0.1; // Clearance in "bearings"
bolt_radius = 1;

servo_mating_worm_teeth = 20;
servo_mating_servo_teeth = 24;

module geared_drum(ratio, worm_diam, drum_diam, worm_length, drum_length, mount_width)
{
    gear_pitch_radius = pitch_radius(gear_pitch, ratio);
    gear_radius = outer_radius(gear_pitch, ratio);
    gear_thickness = worm_gear_thickness(gear_pitch, ratio, worm_diam);
    drum_x_shift = gear_pitch_radius+worm_diam/2;
    mount_block_width = (gear_radius + gear_clearance)*2;
    
    // Worm gear assembly
    translate([0, gear_thickness/2, 0])
    worm(
        d = worm_diam,
        l = worm_length,
        circ_pitch=gear_pitch
    );    
    // Worm drive shaft
    translate([0, gear_thickness/2, (-mount_block_width/2) + mount_width/2])
    cylinder(h=mount_block_width - mount_width, r=(worm_diam*0.8)/2);
    // Servo mating gear
    servo_gear_z_space = (mount_block_width - worm_length)/2 - mount_width;
    translate([0, gear_thickness/2, mount_block_width/2-mount_width-servo_gear_z_space*0.4-rotation_clearance])
    spur_gear(gear_pitch, servo_mating_worm_teeth, servo_gear_z_space*0.8);
    
    translate([0, gear_thickness/2, 0])
    rotate([90, 0, 0])
    translate([gear_pitch_radius+worm_diam/2, 0, 0])
    worm_gear(
        worm_diam=worm_diam,
        circ_pitch=gear_pitch,
        teeth=ratio
    );
    
    // Add winding drum
    translate([drum_x_shift, gear_thickness, 0])
    rotate([-90, 0, 0])
    difference()
    {
        cylinder(h=drum_length+0.1, r=drum_diam/2);
        translate([-(drum_diam+0.2)/2, 0, drum_length/2])
        rotate([0, 90, 0])
        cylinder(h=drum_diam+0.2, r=min_thickness);
    };
    
    // Drum mounting shafts
    translate([drum_x_shift, 0.1, 0])
    rotate([90, 0, 0])
    cylinder(h=mount_width+0.1, r=0.8*gear_radius);
    
    translate([drum_x_shift, drum_length+gear_thickness+mount_width-0.1, 0])
    rotate([90, 0, 0])
    cylinder(h=mount_width+0.1, r=0.8*drum_diam/2);
};


module worm_clearance(ratio, worm_length, worm_diam, mount_width)
{    
    gear_thickness = worm_gear_thickness(gear_pitch, ratio, worm_diam);
    gear_radius = outer_radius(gear_pitch, ratio);
    mount_block_width = (gear_radius + gear_clearance)*2;
    
    // Worm gear space
    translate([0, gear_thickness/2, -worm_length*0.6])    
    cylinder(h=worm_length*1.2, r=worm_diam/2 + gear_clearance);
    // Drive shaft space
    translate([0, gear_thickness/2, (-mount_block_width/2) + mount_width/2])
    cylinder(h=mount_block_width - mount_width + 0.1, r=(worm_diam*0.8)/2 + rotation_clearance);
    // Mating gear space
    servo_gear_z_space = (mount_block_width - worm_length)/2 - mount_width;
    translate([0, gear_thickness/2, mount_block_width/2-mount_width-rotation_clearance-servo_gear_z_space*0.8])
    cylinder(h=servo_gear_z_space*0.8, r=outer_radius(gear_pitch, servo_mating_worm_teeth)+gear_clearance);
};


module drum_clearance(ratio, worm_diam, drum_length, mount_width)
{
    gear_pitch_radius = pitch_radius(gear_pitch, ratio);
    gear_radius = outer_radius(gear_pitch, ratio);
    gear_thickness = worm_gear_thickness(gear_pitch, ratio, worm_diam);
    mount_block_width = (gear_radius + gear_clearance)*2;   
    drum_x_shift = gear_pitch_radius+worm_diam/2;
    mount_block_x_shift = drum_x_shift - mount_block_width/2; 
    total_drum_length = drum_length+gear_thickness;
    
    // Drum and gear rotation space
    translate([drum_x_shift, -0.1, 0])
    rotate([-90, 0, 0])
    cylinder(h=drum_length+gear_thickness + 0.2, r=gear_radius+gear_clearance);
    // Space for winding access opposite servo
    translate([mount_block_x_shift+mount_block_width/2, total_drum_length/2, 0])
    rotate([-90, 0, -90])
    scale([total_drum_length/2, mount_block_width/4, 1])
    cylinder(h=mount_block_width/2+0.1, r=1, $fn=10);
    // Space for winding access on sides
    translate([mount_block_x_shift-0.1+mount_block_width/2, total_drum_length/2, -mount_block_width/2-0.1])
    rotate([0, 0, -90])
    scale([total_drum_length/2, mount_block_width/4, 1])
    cylinder(h=mount_block_width+0.2, r=1, $fn=10);
};

module mount_clearance(ratio, worm_diam, drum_length, drum_diam, mount_width)
{
    gear_pitch_radius = pitch_radius(gear_pitch, ratio);
    gear_radius = outer_radius(gear_pitch, ratio);
    gear_thickness = worm_gear_thickness(gear_pitch, ratio, worm_diam);
    drum_x_shift = gear_pitch_radius+worm_diam/2-0.1;
    
    translate([drum_x_shift, 0.1, 0])
    rotate([90, 0, 0])
    cylinder(h=mount_width+0.2, r=0.8*gear_radius + rotation_clearance);
    
    translate([
        drum_x_shift,
        drum_length+gear_thickness+mount_width+0.1, 
        0])
    rotate([90, 0, 0])
    cylinder(h=mount_width+0.2, r=0.8*drum_diam/2 + rotation_clearance);
};


module drum_mount(ratio, worm_diam, drum_diam, worm_length, drum_length, mount_width)
{
    gear_pitch_radius = pitch_radius(gear_pitch, ratio);
    gear_radius = outer_radius(gear_pitch, ratio);
    gear_thickness = worm_gear_thickness(gear_pitch, ratio, worm_diam);
    drum_x_shift = gear_pitch_radius+worm_diam/2;
    mount_block_width = (gear_radius + gear_clearance)*2;
    mount_block_x_shift = drum_x_shift - mount_block_width/2;
    total_drum_length = drum_length+gear_thickness;
    total_length = total_drum_length + mount_width*2;
    
    // Drum mounts
    difference()
    {
        union()
        {
            // Gear side
            translate([
                mount_block_x_shift,
                0,
                -mount_block_width/2
            ])
            rotate([0, 0, -90])
            cube([mount_width, mount_block_width, mount_block_width]);
            // Undriven side
            translate([
                mount_block_x_shift,
                drum_length+gear_thickness+mount_width,
                -mount_block_width/2
            ])
            rotate([0, 0, -90])
            cube([mount_width, mount_block_width, mount_block_width]);
        };
        // Cutout for drum shaft and gears
        union()
        {
            mount_clearance(ratio, worm_diam, drum_length, drum_diam, mount_width);
            worm_clearance(ratio, worm_length, worm_diam, mount_width);
        };
    };
    
    // Cross bars
    difference(){
        // Bars
        union(){
            bar_width = (mount_block_width - gear_clearance)/2;
            translate([
                bar_width + mount_block_x_shift,
                -mount_width,
                -mount_block_width/2
            ])
                rotate([0, 0, 90])
                cube([
                    total_length, 
                    bar_width,
                    bar_width        
                ]);            
            translate([
                mount_block_x_shift + mount_block_width,
                -mount_width,
                -mount_block_width/2
            ])
                rotate([0, 0, 90])
                cube([
                    total_length, 
                    bar_width,
                    bar_width        
                ]);
            translate([
                mount_block_x_shift + mount_block_width,
                -mount_width,
                mount_block_width/2 - bar_width
            ])
                rotate([0, 0, 90])
                cube([
                    total_length, 
                    bar_width,
                    bar_width        
                ]);
            
            translate([
                bar_width + mount_block_x_shift,
                -mount_width,
                mount_block_width/2 - bar_width
            ])
                rotate([0, 0, 90])
                cube([
                    total_length, 
                    bar_width,
                    bar_width        
                ]);
        };
        // Cutout for gear and drum
        union(){
            drum_clearance(ratio, worm_diam, drum_length, mount_width);
            worm_clearance(ratio, worm_length, worm_diam, mount_width);
            mount_clearance(ratio, worm_diam, drum_length, drum_diam, mount_width);
        };
        
    };
    
    
    // Worm drive mount
    difference()
    {
        worm_mount_width = worm_diam+gear_clearance*2;
        union()
        {
            translate([
                -worm_mount_width/2, 
                (gear_thickness-worm_mount_width)/2, 
                -mount_block_width/2
            ])
            cube([worm_mount_width, worm_mount_width, mount_width]);
            
            translate([
                -worm_mount_width/2, 
                (gear_thickness-worm_mount_width)/2, 
                mount_block_width/2 - mount_width
            ])
            cube([worm_mount_width, worm_mount_width, mount_width]);
        };
        union(){
            drum_clearance(ratio, worm_diam, drum_length, mount_width);
            worm_clearance(ratio, worm_length, worm_diam, mount_width);
            mount_clearance(ratio, worm_diam, drum_length, drum_diam, mount_width);
        };
    };
};


module servo_mount(ratio, worm_diam, worm_length, drum_length, drum_diam, mount_width, show_servo=false)
{
    gear_pitch_radius = pitch_radius(gear_pitch, ratio);
    gear_radius = outer_radius(gear_pitch, ratio);
    gear_thickness = worm_gear_thickness(gear_pitch, ratio, worm_diam);
    mount_block_width = (gear_radius + gear_clearance)*2;
    drum_x_shift = gear_pitch_radius+worm_diam/2;
    mount_block_x_shift = drum_x_shift - mount_block_width/2;
    
    servo_width = 12;
    servo_length = 27;
    servo_shaft_from_front = 12;
    servo_shaft_from_back = 19;
    servo_tab_width = 4;
    servo_tab_height = 18;
    
    if(show_servo)
    {
        // Servo model
        translate([
            - servo_width/2 - worm_diam/2 - gear_clearance, 
            gear_thickness - worm_diam/2 + gear_clearance, 
            -mount_block_width/2
        ])
        rotate([0, 0, 90])
        color("green") towerprosg90(position=[0,0,0], rotation=[0,0,0], screws = 0, axle_length = 0, cables=0);
    }      
    
    // Mating gear
    servo_gear_z_space = (mount_block_width - worm_length)/2 - mount_width;
    translate([
            - servo_width/2 - worm_diam/2 - gear_clearance, 
            gear_thickness - worm_diam/2 + gear_clearance, 
            mount_block_width/2-mount_width-servo_gear_z_space*0.4-rotation_clearance
        ])
        difference()
        {
            spur_gear(gear_pitch, servo_mating_servo_teeth, servo_gear_z_space*0.8);
            translate([0, 0, -servo_gear_z_space/2])
            cylinder(h=servo_gear_z_space, r=1);
        };
    
    servo_x_dist = abs(- servo_width/2 - worm_diam/2 - gear_clearance);
    assert(
        abs(gear_dist(servo_mating_servo_teeth, servo_mating_worm_teeth, circ_pitch=gear_pitch) - servo_x_dist) <= 1,
        "Servo mating gears spaced incorrectly with given tooth counts"
    );
    
    
    // Mounting
    difference()
    {
        union()
        {
            // Front mount
            translate([
                -worm_diam/2 - gear_clearance - servo_width - 1, 
                gear_thickness - servo_shaft_from_front, 
                -mount_block_width/2
            ])
            cube([servo_width + worm_diam + gear_clearance*2 + 1, servo_tab_width, servo_tab_height]);
            // Back mount    
            translate([
                -worm_diam/2 - gear_clearance - servo_width - 1, 
                gear_thickness - servo_shaft_from_front + servo_length, 
                -mount_block_width/2
            ])
            cube([servo_width + worm_diam + gear_clearance*2 + 1, servo_tab_width, servo_tab_height]);
            // Side cage    
            translate([
                -worm_diam/2 - gear_clearance - servo_width - min_thickness,  
                gear_thickness - servo_shaft_from_front,  
                -mount_block_width/2
            ])
            cube([min_thickness, servo_length+servo_tab_width, servo_tab_height]);
        };
        union()
        {
            drum_clearance(ratio, worm_diam, drum_length, mount_width);
            worm_clearance(ratio, worm_length, worm_diam, mount_width);
            mount_clearance(ratio, worm_diam, drum_length, drum_diam, mount_width);
            translate([
                - servo_width/2 - worm_diam/2 - gear_clearance, 
                gear_thickness - worm_diam/2 + gear_clearance, 
                -mount_block_width/2
            ])
            rotate([0, 0, 90]) 
            towerprosg90(position=[0,0,0], rotation=[0,0,0], screws = 0, axle_length = 0, cables=0);
        };
    };
};


function motor_assembly_height() =
    let (
        ratio = 50,
        worm_diam = 10,
        gear_pitch_radius = pitch_radius(gear_pitch, ratio),
        gear_radius = outer_radius(gear_pitch, ratio),
        gear_thickness = worm_gear_thickness(gear_pitch, ratio, worm_diam)
    )
    (gear_radius + gear_clearance)*2;
    

//module motor_assembly(length, show_servo=false)
//{
//    ratio = 50;
//    worm_diam = 10;
//    drum_diam = 20;
//    worm_length = 20;
//    mount_width = 5;
//    drum_length = length-mount_width*2-worm_gear_thickness(gear_pitch, ratio, worm_diam);
//    
//    servo_mount(ratio, worm_diam, worm_length, drum_length, drum_diam, mount_width, show_servo);
//    geared_drum(ratio, worm_diam, drum_diam, worm_length, drum_length, mount_width);
//    drum_mount(ratio, worm_diam, drum_diam, worm_length, drum_length, mount_width);
//}


// Servo dims
S_A = 30.3;
S_B = 22.7;
S_C = 27;
S_D = 12.2;
S_E = 32.3;
S_F = 17;
S_G = 4.6;
S_H = 3.2;
S_I = 10.2;
S_J = (S_E - S_B)/2;

function motor_dims(ratio, worm_length, worm_diam) = let(
    G_Rp = pitch_radius(gear_pitch, ratio),
    G_Ro = outer_radius(gear_pitch, ratio),
    G_D = worm_gear_thickness(gear_pitch, ratio, worm_diam),
    del = 3,
    L_1 = G_Ro + del,
    L_2 = S_C + (worm_length / 2),
    L_3 = L_2 + G_Ro + del,
    L_8 = worm_dist(worm_diam, 1, ratio, circ_pitch = gear_pitch),
    L_4 = L_1 + L_8 - S_I,
    L_5 = L_3 - S_C,
    L_6 = L_4 + S_E,
    L_7 = S_D / 2,
) [L_1, L_2, L_3, L_4, L_5, L_6, L_7, L_8];

module motor_assembly(ratio, worm_length, worm_diam, show_servo=false)
{
    
    // Gear dimensions
    G_Rp = pitch_radius(gear_pitch, ratio);
    G_Ro = outer_radius(gear_pitch, ratio);
    G_D = worm_gear_thickness(gear_pitch, ratio, worm_diam);
    
    // Placement parameters
    L = motor_dims(ratio, worm_length, worm_diam);
    
    if(show_servo)
    {
        translate([L[0] + L[7], -L[6], S_C + L[4]])
        rotate([180,0,0])
        color("green") 
        towerprosg90(position=[0,0,0], rotation=[0,0,0], screws = 0, axle_length = 0, cables=0);
    }
    
    // Worm
    translate([L[0]+L[7], -L[6], L[2] - L[1]])
    difference()
    {
        worm(
            d = worm_diam,
            l = worm_length,
            circ_pitch=gear_pitch
        );
        // Hole for mounting to servo
        union()
        {
            // Small hole for screw
            translate([0,0,-worm_length/2 - 0.1])
            cylinder(h=worm_length+0.2, r=1);
            // Large hole for servo shaft
            translate([0,0,worm_length/2 - S_H])
            cylinder(h=S_H+0.1, r=S_G/2);
            // Large hole for screw head
            translate([0,0,-worm_length/2-0.1])
            cylinder(h=worm_length-(S_H+2)+0.1, r=S_G/2);
        };
    };
    
    
    
    
    // Worm gear
//    translate([L[0], -L[6], L[2] - L[1]])
//    rotate([90, 0, 0])
//    worm_gear(
//        worm_diam=worm_diam,
//        circ_pitch=gear_pitch,
//        teeth=ratio
//    );
    
//    // Mounting blocks
//    translate([L[3], -L[6]-S_D/2, L[2]-S_F])
//    difference()
//    {
//        cube([S_J, S_D+0.1, S_F]);
//        translate([S_J/2,S_D/2,-0.1])
//        cylinder(h=S_F+0.2, r=1);
//    };
//    translate([L[3]+S_B+S_J, -L[6]-S_D/2, L[2]-S_F])
//    difference()
//    {
//        cube([S_J, S_D+0.1, S_F]);
//        translate([S_J/2,S_D/2,-0.1])
//        cylinder(h=S_F+0.2, r=1);
//    };
}


M_ratio = 20;
M_diam = 10;
M_length = 10;
M_orig = [-50, 80, 0];
//motor_assembly(M_ratio, M_diam, M_length, false);