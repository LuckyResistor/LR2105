//
// LR2101-102 rotated cubes hex grid
// ---------------------------------
// Copyright (c) 2021 by Lucky Resistor. https://luckyresistor.me
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.


// The side of the cube.
cube_side = 16;
// The distances between the cubes.
cube_distance = 12;
// The height of the base.
base = cube_side;

// The z rotation per distance unit.
rotate_z_step = 16;

// The repetition count in both x directions.
repeat_x = 10;
// The repetition count in both y directions.
repeat_y = 10;


/// Create a cube with the tip at the Z axis.
///
module createCube() {
    rotate([atan(2*cos(45)), 0, 0]) {
        rotate([0, 0, 45]) {
            cube([cube_side, cube_side, cube_side], center=true);
        }
    }
}


// Build the scene
module createScene() {
    union() {
        cube_distance_x = cube_distance;
        cube_distance_y = cube_distance * sin(60);
        for (y = [-repeat_y:repeat_y]) {
            is_even = (y % 2 == 0);
            adjustment = (is_even ? 0 : 0.5);
            begin_x = -repeat_x + adjustment;
            end_x = repeat_x - adjustment;
            for (x = [begin_x:1.0:end_x]) {
                distance = norm([x, y]);
                translate([cube_distance_x*x, cube_distance_y*y, 0]) {
                    rotate([0, 0, rotate_z_step*distance]) {
                        createCube();
                    }
                }
            }
        }
        translate([0, 0, -base/2]) {
            cube([(2*repeat_x+1)*cube_distance_x, (2*repeat_y+1)*cube_distance_y, base], center=true);
        }
    }
}

scale([1, 1, 1]) {
    createScene();
}

