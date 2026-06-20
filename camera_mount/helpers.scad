module standoff(x, y, z, h, r){
    translate([x, y, z])
        cylinder(h, r=r);
}


cam_dim = [25, 23.862]; // Camera dimensions
// Camera mounting holes relative to camera center
_cam_mount_bl = [(-cam_dim[0]/2)+2, (-cam_dim[1]/2)+2];
_cam_mount_tl = [(-cam_dim[0]/2)+2, 14.5-(cam_dim[1]/2)];
_cam_mount_br = [(cam_dim[0]/2)-2, (-cam_dim[1]/2)+2];
_cam_mount_tr = [(cam_dim[0]/2)-2, 14.5-(cam_dim[1]/2)];
module camera_standoffs(cam_x, cam_y, z, h, r){
    standoff(
        cam_x + _cam_mount_bl[0], 
        cam_y + _cam_mount_bl[1],
        z,
        h,
        r
    );
    standoff(
        cam_x + _cam_mount_br[0], 
        cam_y + _cam_mount_br[1],
        z,
        h,
        r
    );
    standoff(
        cam_x + _cam_mount_tl[0], 
        cam_y + _cam_mount_tl[1],
        z,
        h,
        r
    );
    standoff(
        cam_x + _cam_mount_tr[0], 
        cam_y + _cam_mount_tr[1],
        z,
        h,
        r
    );
}

module field_of_view(angle_x, angle_y, low, high){
    x = 2 * low * tan(angle_x/2);
    y = 2 * low * tan(angle_y/2);
    s = high / low;
    
    translate([0,0,low]) linear_extrude(
        height=high-low, 
//        v=[0,0,1], 
        center=false,
        scale=s
    ) scale([x,y]) circle(1, $fn=20);
}


cam_sensor = [0, 14.4 - (cam_dim[1]/2)]; // Camera sensor position, relative to camera center

module camera_and_mount(standoff, show_camera=false)
{
    if(show_camera)
    {
        translate([
            -cam_dim[0]/2, 
            -cam_dim[1]/2-cam_sensor[1], 
            standoff
        ])
        rotate([180, 0, 90])
            color("green") import("Camera_module_3_std_model_simple.stl");
    };
    difference()
    {
        camera_standoffs(0, -cam_sensor[1], 0, standoff, 3);
        camera_standoffs(0, -cam_sensor[1], -0.1, standoff+0.2, 1.5);
    };
}


module camera_and_mount_diff(standoff)
{
    camera_standoffs(0, -cam_sensor[1], -50-standoff/2, 100+standoff, 1.5);
    translate([0, 0, standoff+8])    
    field_of_view(
        66, 41,
        0.1, 50
    );
}


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


module main_board(standoff, show_electronics=false)
{

    translate([- 33 - pcb_mount_border - tof_dim[0]/2, 
                - tof_dim[1] - 3.302 - pcb_mount_border + tof_dim[1]/2, 
                0]) union() // Shift entire assembly so sensor is at origin in x-y plane
    {
        if(show_electronics)
        {
            // ToF sensor, aligned to holes on carrier PCB, with mounting height of 8.51mm (female header pin insulation) + 2.5mm (male header pin insulation)
            translate([
                33 + pcb_mount_border, 
                tof_dim[1] + 3.302 + pcb_mount_border, 
                8.51 + 2.5 + standoff]
            ) 
            rotate([0, 0, -90])
                color("green") import("vl53l8cx-carrier-model.stl");
           
            
            // PCB model, without RPi (smaller height than    other components, so can ommit)
            translate([
                pcb_mount_border, 
                pcb_mount_border, 
                standoff
            ])
                color("green") import("../cpu_carrier/cpu_carrier.stl");
        };
        
        // Mounting
        difference(){
            union(){
                // Standoffs to provide space under PCB
                standoff(
                    pcb_mount_bl[0] + pcb_mount_border, 
                    pcb_mount_bl[1] + pcb_mount_border, 
                    0,
                    standoff,
                    4
                );
                standoff(
                    pcb_mount_tl[0] + pcb_mount_border, 
                    pcb_mount_tl[1] + pcb_mount_border, 
                    0,
                    standoff,
                    4
                );
                standoff(
                    pcb_mount_br[0] + pcb_mount_border, 
                    pcb_mount_br[1] + pcb_mount_border, 
                    0,
                    standoff,
                    4
                );
                standoff(
                    pcb_mount_tr[0] + pcb_mount_border, 
                    pcb_mount_tr[1] + pcb_mount_border, 
                    0 ,
                    standoff,
                    4
                );
            };
            // Holes
            union(){
                standoff(
                    pcb_mount_bl[0] + pcb_mount_border, 
                    pcb_mount_bl[1] + pcb_mount_border, 
                    -overlap,
                    standoff+2*overlap,
                    1.5
                );
                standoff(
                    pcb_mount_tl[0] + pcb_mount_border, 
                    pcb_mount_tl[1] + pcb_mount_border, 
                    -overlap,
                    standoff+2*overlap,
                    1.5
                );
                standoff(
                    pcb_mount_br[0] + pcb_mount_border, 
                    pcb_mount_br[1] + pcb_mount_border, 
                    -overlap,
                    standoff+2*overlap,
                    1.5
                );
                standoff(
                    pcb_mount_tr[0] + pcb_mount_border, 
                    pcb_mount_tr[1] + pcb_mount_border, 
                    -overlap,
                    standoff+2*overlap,
                    1.5
                );
            }
        };
    };
}


module main_board_diff(standoff)
{

    translate([0, 0, 8.51 + 2.5 + standoff + 3]) field_of_view(
        60, 60,
        0.1, 50
    );
    translate([- 33 - pcb_mount_border - tof_dim[0]/2, 
                - tof_dim[1] - 3.302 - pcb_mount_border + tof_dim[1]/2, 
                0]) 
    union() // Shift entire assembly so sensor is at origin in x-y plane
    {
        standoff(
            pcb_mount_bl[0] + pcb_mount_border, 
            pcb_mount_bl[1] + pcb_mount_border, 
            -50-standoff/2,
            100+standoff,
            1.5
        );
        standoff(
            pcb_mount_tl[0] + pcb_mount_border, 
            pcb_mount_tl[1] + pcb_mount_border, 
            -50-standoff/2,
            100+standoff,
            1.5
        );
        standoff(
            pcb_mount_br[0] + pcb_mount_border, 
            pcb_mount_br[1] + pcb_mount_border, 
            -50-standoff/2,
            100+standoff,
            1.5
        );
        standoff(
            pcb_mount_tr[0] + pcb_mount_border, 
            pcb_mount_tr[1] + pcb_mount_border, 
            -50-standoff/2,
            100+standoff,
            1.5
        );
    };
}

