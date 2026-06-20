include <BOSL2/std.scad>

del = 0.25;
eps = 0.1;

function fill_param(Axyz, Cx, Dd, Mxy, Mbx, Mby1, Mby2, Vy, Uz) = 
    let (
        S10 = 11,
        S6=3,
        Tm = 15,
        Tb = 2*S6,
        Gd = Dd/2
    )
    struct_set([], [
        "Ax", Axyz[0],    
        "Ay", Axyz[1],    
        "Az", Axyz[2],    
        "Bx", Axyz[0],    
        "By", Axyz[1],    
        "Bz", Axyz[2],    
        "Cx", Cx,    
        "Cy", Axyz[1]-2,   
        "Cz", 2*Dd,   
        "Ca", 2,    
        "Cb", Dd/2 + 2, 
        "Dd", Dd,   
        "Td", S10-1,   
        "Tb", Tb,   
        "Ti", 4, 
        "To", S10-1,   
        "Tm", Tm,     
        "Ts", 2,     
        "Tl", Tb+Tm,   
        "Ga", 3,  
        "Gb", Gd * 0.5,  
        "Gc", Gd + 2,  
        "Gd", Gd,  
        "Gt", 5,
        "Gm", Gd*0.25,  
        "Gw", Dd*2,
        "Mx", Mxy[0],
        "Mbx", Mbx,
        "My", Mxy[1],
        "Mby1", Mby1,  
        "Mby2", Mby2,
        "S1", 22,
        "S2", 23,
        "S3", 17,
        "S4", 2,
        "S5", 8,
        "S6", S6,
        "S7", 5,
        "S8", 32,
        "S9", 12,
        "S10", S10,
        "S11", 3,
        "Vy", Vy,
        "Ux", Mxy[0] + 2*Mbx - Axyz[0] + eps,
        "Uy", Axyz[1],
        "Uz", Uz
    ]);
    

function fill_vecs(p) = 
    let(
        y = struct_val(p, "My") + struct_val(p, "Mby2") - struct_val(p, "Vy"),
        x = (struct_val(p, "Mx")/2) + struct_val(p, "Mbx")
    )
    struct_set([], [
        "A", [x - struct_val(p, "Ax"), y - struct_val(p, "Ay"), 0], 
        "B", [-x, y - struct_val(p, "By"), 0], 
        "U", [-x+struct_val(p, "Bx")-eps, y - struct_val(p, "Uy"), struct_val(p, "Az")], 
        "Q", [0, y - (struct_val(p, "Ay")/2), struct_val(p, "Az")] 
    ]);

    
module check_param(p)
{
    Gw = struct_val(p, "Gw");
    Gd = struct_val(p, "Gd");
    Dd = struct_val(p, "Dd");
    Ay = struct_val(p, "Ay");
    Az = struct_val(p, "Az");
    assert(Gw > (Gd + Dd), "Carriage axel spacing invalid");
    assert(Ay > (Gw + Gd), "Block width is invalid");
    
    Gc = struct_val(p, "Gc");
    S9 = struct_val(p, "S9");
    S10 = struct_val(p, "S10");
    S11 = struct_val(p, "S11");
    By = struct_val(p, "By");
    Bz = struct_val(p, "Bz");
    assert((Gw - Gc) > S9, "No horizontal space for servo");
    assert(By > (Gw + Gd), "Blocxk width is invalid");
    assert(Bz > (S10 + S11), "No vertical space for servo");
    
    Ca = struct_val(p, "Ca");
    Cb = struct_val(p, "Cb");
    Cy = struct_val(p, "Cy");
    Cz = struct_val(p, "Cz");
    assert(Cy > (Gw + Gd), "Carriage is too narrow");
    assert(Cz > ((2*Cb) + Ca), "Carriage is too short");
        
    Mx = struct_val(p, "Mx");
    Mbx = struct_val(p, "Mbx");
    Ax = struct_val(p, "Ax");
    Bx = struct_val(p, "Bx");
    Tl = struct_val(p, "Tl");
    Tb = struct_val(p, "Tb");
    Tm = struct_val(p, "Tm");
    To = struct_val(p, "To");
    Ti = struct_val(p, "Ti");
    S6 = struct_val(p, "S6");
    S7 = struct_val(p, "S7");
    Dl = Mx + (2*Mbx) - Bx - (Ax/2) - Tl;
//    assert(
//        (Dl + Tm + (Ax/2)) < (Mx + (2*Mbx) - Bx - Tb),
//        "Spindle mating length invalid"
//    );
//    assert(
//        (Dl + Tm + (Ax/2) - Mx - (2*Mbx) + Mx + Tb) <= (Tm / 2),
//        "Spindle mating length too short"
//    );
    assert(Tb > S6, "Spindle connector too short for servo");
    assert(To <= S10, "Spindle connector too wide for servo");
//    assert(Ti >= S7, "Spindle connector too narrow for servo screw");
    
    Gb = struct_val(p, "Gb");
    Gm = struct_val(p, "Gm");
    assert(Gm < Gb, "Invalid rod cap connector");
    assert(Gb < Gd, "Rod cap connector too wide");
    assert(Gc > Gd, "Rod cap too narrow");
    
    Mby2 = struct_val(p, "Mby2");
    assert(Cy < Mby2, "Carriage too wide for available space");
};   
 