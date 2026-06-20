module pill(length, radius)
{
    translate([0, 0, radius - length/2])
    union()
    {
       cylinder(h=length-2*radius, r=radius);
       sphere(radius);
       translate([0, 0, length-2*radius]) sphere(radius);
    };
};


module segment(width, length, angle, thickness, mount_diameter) 
{
    pitch = 90 - angle;
    link_r = 5;
    
    difference()
    {
    union(){
        rotate([0, 0, pitch]) 
        translate([-(length+width*tan(pitch))/2, -width/2, 0]) // Place at the center
        union(){
            // Base
            difference(){
                linear_extrude(thickness)
                polygon([
                    [0,0],
                    [length,0],
                    [length+width*tan(pitch),width],
                    [width*tan(pitch),width]
                ]);
                union(){
                    // Cable routing hole
                    translate([(length+width*tan(pitch))/2, width/2, -thickness*0.1])
                    cylinder(h=thickness*1.2, r=2);
                    // Mounting holes
                    translate([length*0.5 + width*0.25*tan(pitch), width*0.25, -thickness*0.1])
                    cylinder(h=thickness*1.2, r=mount_diameter/2);
                    translate([length*0.5 + width*0.75*tan(pitch), width*0.75, -thickness*0.1])
                    cylinder(h=thickness*1.2, r=mount_diameter/2);
                    // Elastic band routing
                    elastic_w = 4;
                    translate([-50, 1, thickness/4])
                    cube([length*100, elastic_w, thickness*0.3]);
                    translate([-50, width-(elastic_w+1), thickness/4])
                    cube([length*100, elastic_w, thickness*0.3]);
                };
            };
            // Cable routing
            difference(){
                translate([length*0.2, 0, thickness-0.1])
                linear_extrude(link_r+0.1)
                polygon([
                    [0,0],
                    [length*0.6,0],
                    [length*0.6+3*tan(pitch),3],
                    [3*tan(pitch),3]
                ]);
                translate([0, 1, thickness+link_r-1])
                cube([length, 1, 0.5]);
            };
            difference(){
                translate([(length*0.2)+(width-3)*tan(pitch), width-3, thickness-0.1])
                linear_extrude(link_r+0.1)
                polygon([
                    [0,0],
                    [length*0.6,0],
                    [length*0.6+3*tan(pitch),3],
                    [3*tan(pitch),3]
                ]);
                translate([width*tan(pitch), width-2, thickness+link_r-1])
                cube([length, 1, 0.5]);
            };
        };
        // Rotation links
        translate([length/2, width/8 + (length/2)*tan(pitch), thickness])
        rotate([90, 0, 0])
        difference(){
            cylinder(h=width/4, r=link_r);
            translate([0,0,-1]) cylinder(h=width/2, r=link_r-2);
        };
    };
    
    union(){
        // Rotation link cutout
        translate([-length/2-1, width*3/8+1, thickness])
        rotate([90, 0, 0])
        difference(){
            cylinder(h=width/4+2, r=link_r+1);
            translate([0,0,-1]) cylinder(h=width/2, r=link_r-2);
        };
        // Cable guide cutout
        translate([-0.5, -width, thickness+link_r-1])
        cube([1, width*2, 1.1]);
    };
    };
};


module grasper(width, length, pitch, n, thickness, mount_diameter)
{
    assert(n%2==1, "Segment count in grasper must be odd.");
    l = length / n;
    n2 = (n-1)/2;
    pad = 0.5;
    
    union()
    {
        // Place center segment
        segment(width, l, pitch, thickness, mount_diameter);
        // Place x+ segments
        for(i = [0:1:n2]){
            translate([i*(l+pad), i*((l+pad)*tan(90-pitch)), 0])
            segment(width, l, pitch, thickness, mount_diameter);
        };
        // Place x- segments
        for(i = [0:1:n2]){
            translate([-i*(l+pad), -i*((l+pad)*tan(90-pitch)), 0])
            segment(width, l, pitch, thickness, mount_diameter);
        };
    };
};


module grasper_holes(width, length, pitch, n, thickness, mount_diameter)
{
    l = length / n;
    p = 90 - pitch;
    
    rotate([0, 0, p])
    translate([-(l+width*tan(p))/2, -width/2, 0])
    union()
    {
        // Cable routing hole
        translate([(l+width*tan(p))/2, width/2, -thickness*0.1])
        cylinder(h=thickness*1.2, r=2);
        // Mounting holes
        translate([l*0.5 + width*0.25*tan(p), width*0.25, -thickness*0.1])
        cylinder(h=thickness*1.2, r=mount_diameter/2);
        translate([l*0.5 + width*0.75*tan(p), width*0.75, -thickness*0.1])
        cylinder(h=thickness*1.2, r=mount_diameter/2);
    };
};


$fn = $preview ? 30 : 100;
G_w = 20;
G_l = 150;
G_pitch = -60;
G_n = 9;
G_t = 5; 
G_md = 2;
//grasper(G_w, G_l, G_pitch, G_n, G_t, G_md);
