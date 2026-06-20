include <helpers.scad>

// display controls
show_electronics = false; // Display pcb and other parts that won't be printed
show_fov = false; // Display sensor field of view
max_range = 50; /// Maximum sensing range to show FOV
$fn = $preview ? 10 : 100;

// design dimensions
overlap = 0.001; // Overlap for joining parts

material_thickness = 3; // Smallest dimension of printed parts
pcb_standoff = 1; // Spacing underneath main PCB
cam_standoff = 3; // Spacing underneath camera PCBs

tof_dim = [22.86, 12.7]; // Time-of-flight sensor breakout dimensions
pcb_dim = [90, 70]; // PCB x-y size
pcb_mount_border = 10; // Material space around PCB
// PCB mounting holes x-y pos relative to PCB origin
pcb_mount_bl = [4.064, 3.556];
pcb_mount_tl = [4.064, pcb_dim[1]-3.5567];
pcb_mount_br = [pcb_dim[0]-4.572, 3.556];
pcb_mount_tr = [pcb_dim[0]-4.472, pcb_dim[1]-3.556];
pcb_mount_d = 2.5; // PCB mount hole diameter

cam_mount_height = 25; // Height above PCB level for camera parts
cam_dim = [25, 23.862]; // Camera dimensions
cam_sensor = [0, 14.4 - (cam_dim[1]/2)]; // Camera sensor position, relative to camera center
cam_mount_border = 2; // Material thickness around camera mounting
cam_mount_d = 2.2; // Camera mount hole diameter
cam_add_clearance = 4; // Extra spacing between cameras to allow for tof field of view
cam_left_center = [17.272 - cam_sensor[0] - (cam_add_clearance/2), 9.652 - cam_sensor[1]]; // Left camera xy center, relative to PCB origin
cam_right_center = [cam_left_center[0]+53.34+cam_add_clearance, 9.652 - cam_sensor[1]]; // Right camera xy center, relative to PCB origin


// Components mounted on the CPU board
if(show_electronics){
    union(){    
        // ToF sensor, aligned to holes on carrier PCB, with mounting height of 8.51mm (female header pin insulation) + 2.5mm (male header pin insulation)
        translate([
            33 + pcb_mount_border, 
            tof_dim[1] + 3.302 + pcb_mount_border, 
            8.51 + 2.5 + material_thickness + pcb_standoff]
        ) 
        rotate([0, 0, -90])
            import("vl53l8cx-carrier-model.stl");
        
        if(show_fov){
            translate([
                33 + pcb_mount_border + (tof_dim[0]/2), 
                3.302 + pcb_mount_border + (tof_dim[1]/2), 
                8.51 + 2.5 + material_thickness +   pcb_standoff + 3]
            ) 
            field_of_view(
                57.9, 57.9,
                20, max_range
            );
        }
        
        // PCB model, without RPi (smaller height than    other components, so can ommit)
        translate([
            pcb_mount_border, 
            pcb_mount_border, 
            material_thickness + pcb_standoff
        ])
            import("../cpu_carrier/cpu_carrier.stl");
    };
}

// Plastic body of CPU mount
difference(){
    union(){
        cube([
            pcb_dim[0] + 2*pcb_mount_border, 
            pcb_dim[1] + 2*pcb_mount_border, 
            material_thickness
        ]);
        // Standoffs to provide space under PCB
        standoff(
            pcb_mount_bl[0] + pcb_mount_border, 
            pcb_mount_bl[1] + pcb_mount_border, 
            material_thickness,
            pcb_standoff + overlap,
            4
        );
        standoff(
            pcb_mount_tl[0] + pcb_mount_border, 
            pcb_mount_tl[1] + pcb_mount_border, 
            material_thickness,
            pcb_standoff + overlap,
            4
        );
        standoff(
            pcb_mount_br[0] + pcb_mount_border, 
            pcb_mount_br[1] + pcb_mount_border, 
            material_thickness,
            pcb_standoff + overlap,
            4
        );
        standoff(
            pcb_mount_tr[0] + pcb_mount_border, 
            pcb_mount_tr[1] + pcb_mount_border, 
            material_thickness - overlap,
            pcb_standoff + overlap,
            4
        );
    };
    // Holes
    union(){
        standoff(
            pcb_mount_bl[0] + pcb_mount_border, 
            pcb_mount_bl[1] + pcb_mount_border, 
            -overlap,
            pcb_standoff + material_thickness + 3*overlap,
            pcb_mount_d
        );
        standoff(
            pcb_mount_tl[0] + pcb_mount_border, 
            pcb_mount_tl[1] + pcb_mount_border, 
            -overlap,
            pcb_standoff + material_thickness + 3*overlap,
            pcb_mount_d
        );
        standoff(
            pcb_mount_br[0] + pcb_mount_border, 
            pcb_mount_br[1] + pcb_mount_border, 
            -overlap,
            pcb_standoff + material_thickness + 3*overlap,
            pcb_mount_d
        );
        standoff(
            pcb_mount_tr[0] + pcb_mount_border, 
            pcb_mount_tr[1] + pcb_mount_border, 
            -overlap,
            pcb_standoff + material_thickness + 3*overlap,
            pcb_mount_d
        );
    }
};

// Camera mounting body
difference(){
    // Material
    union(){
        // Risers from PCB level
        translate([0,0,-overlap])
        cube([
            material_thickness, 
            material_thickness, 
            cam_mount_height + 2*overlap
        ]);
        translate([
            (pcb_dim[0]+2*pcb_mount_border)/2,
            0,
            -overlap
        ])
        cube([
            material_thickness, 
            material_thickness, 
            cam_mount_height + 2*overlap
        ]);    
        translate([
            pcb_dim[0]+2*pcb_mount_border-material_thickness,
            0,
            -overlap
        ])
        cube([
            material_thickness, 
            material_thickness, 
            cam_mount_height + 2*overlap
        ]);
        translate([0,pcb_dim[1]+2*pcb_mount_border-material_thickness,-overlap])    
        cube([
            material_thickness, 
            material_thickness, 
            cam_mount_height + 2*overlap
        ]);
        translate([
            (pcb_dim[0]+2*pcb_mount_border-material_thickness)/2,
            pcb_dim[1]+2*pcb_mount_border-material_thickness,
            -overlap
        ])
        cube([
            material_thickness, 
            material_thickness, 
            cam_mount_height + 2*overlap
        ]);
        translate([
            pcb_dim[0]+2*pcb_mount_border-material_thickness,
            pcb_dim[1]+2*pcb_mount_border-material_thickness,
            -overlap
        ])
        cube([
            material_thickness, 
            material_thickness, 
            cam_mount_height + 2*overlap
        ]);
        // Bars for camera mounting level
        translate([
            0,
            0,
            cam_mount_height
        ])
        cube([
            pcb_dim[0]+2*pcb_mount_border, 
            material_thickness, 
            material_thickness
        ]);
        translate([
            0,
            pcb_dim[1]+2*pcb_mount_border-material_thickness,
            cam_mount_height
        ])
        cube([
            pcb_dim[0]+2*pcb_mount_border, 
            material_thickness, 
            material_thickness
        ]);
        translate([
            pcb_mount_border + cam_left_center[0] -( cam_dim[1]/2)-cam_mount_border,
            0,
            cam_mount_height
        ])
        cube([
            cam_dim[0]+2*cam_mount_border, 
            pcb_dim[1]+2*pcb_mount_border, 
            material_thickness
        ]);
        translate([
            pcb_mount_border + cam_right_center[0] -( cam_dim[1]/2)-cam_mount_border,
            0,
            cam_mount_height
        ])
        cube([
            cam_dim[0]+2*cam_mount_border, 
            pcb_dim[1]+2*pcb_mount_border, 
            material_thickness
        ]);
        // Standoffs
        camera_standoffs(
            pcb_mount_border + cam_left_center[0],
            pcb_mount_border + cam_left_center[1],
            cam_mount_height + material_thickness - overlap,
            cam_standoff + overlap,
            3
        );
        camera_standoffs(
            pcb_mount_border + cam_right_center[0],
            pcb_mount_border + cam_right_center[1],
            cam_mount_height + material_thickness - overlap,
            cam_standoff + overlap,
            3
        );
    };
    // Holes
    union(){
        camera_standoffs(
            pcb_mount_border + cam_left_center[0],
            pcb_mount_border + cam_left_center[1],
            cam_mount_height - overlap,
            cam_standoff + material_thickness + 2*overlap,
            cam_mount_d
        );
        camera_standoffs(
            pcb_mount_border + cam_right_center[0],
            pcb_mount_border + cam_right_center[1],
            cam_mount_height - overlap,
            cam_standoff + material_thickness + 2*overlap,
            cam_mount_d
        );
    }
};

// Camera modules
if(show_electronics){
    translate([
        pcb_mount_border + cam_left_center[0] - (cam_dim[0]/2), 
        pcb_mount_border + cam_left_center[1] - (cam_dim[1]/2), 
        cam_mount_height + material_thickness + cam_standoff
    ])
    rotate([180, 0, 90])
        import("Camera_module_3_std_model_simple.stl");
    
    translate([
        pcb_mount_border + cam_right_center[0] - (cam_dim[0]/2), 
        pcb_mount_border + cam_right_center[1] - (cam_dim[1]/2), 
        cam_mount_height + material_thickness + cam_standoff
    ])
    rotate([180, 0, 90])
        import("Camera_module_3_std_model_simple.stl");
    
    if(show_fov){        
        translate([
            pcb_mount_border + cam_left_center[0], 
            pcb_mount_border + cam_left_center[1] + cam_sensor[1], 
            cam_mount_height + material_thickness + cam_standoff + 8
        ])
        field_of_view(
            66, 41,
            0.1, max_range
        );
        
        translate([
            pcb_mount_border + cam_right_center[0], 
            pcb_mount_border + cam_right_center[1] + cam_sensor[1], 
            cam_mount_height + material_thickness + cam_standoff + 8
        ])
        field_of_view(
            66, 41,
            0.1, max_range
        );
    }
}   

