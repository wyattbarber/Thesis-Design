$fn = $preview ? 10 : 100;

del = 0.5;

// Servo dims
servo_length = 22;
servo_width = 12;
servo_depth = 10;
servo_height = 27;
servo_tab = 5;
servo_axel_diam = 5;

servo_spacing = 25;
servo_mount_length = servo_length + 10;
servo_mount_width = servo_spacing + servo_width + 10;
servo_mount_height = servo_depth * 3/2;
//servo_attach_length = 10;
servo_gear_shaft = 8;

// Connections between links
conn_outer = 23;
conn_inner = conn_outer - 4;
connector_width = conn_outer + 4;
servo_attach_width = conn_outer+2;

// Cable and flex guide routing
cable_d = 3;
flex_t = 3;
flex_w = conn_inner * 0.75;
base_thickness = 0.5;
spool_diam_o = 20;
spool_diam_i = spool_diam_o - 5;
spool_t = 6;
servo_attach_length = 32 - spool_diam_o;
conn_length = 2*servo_attach_length;

// Bend parameters
bend_length = 200;
bend_n = 25;
bend_link_diam = 5;
bend_width = 20;
bend_thickness = 10;
bend_twist = 20;

// Loop parameters
loop_outer = 20;
loop_inner = 15;
loop_length = 40;

// Latch parameters
pin_height = 24;
pin_diam = 7;
pin_act_diam = 3;