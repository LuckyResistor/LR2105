

cube_side = 16;
cube_distance = 12;
base = cube_side;

rotate_z_step = 5;
rotate_x_step = 10;
rotate_y_step = 10;

repeat_x = 10;
repeat_y = 10;

module createCube() {
    rotate([atan(2*cos(45)), 0, 0]) {
        rotate([0, 0, 45]) {
            cube([cube_side, cube_side, cube_side], center=true);
        }
    }
}


union() {
    for (x = [-repeat_x:repeat_x]) {
        for (y = [-repeat_y:repeat_y]) {
            distance = norm([x, y]);
            translate([cube_distance*x, cube_distance*y, 0]) {
                rotate([rotate_x_step*x, rotate_y_step*y, rotate_z_step*distance]) {
                    createCube();
                }
            }
        }
    }
    translate([0, 0, -base/2]) {
        cube([(2*repeat_x+1)*cube_distance, (2*repeat_y+1)*cube_distance, base], center=true);
    }
}
