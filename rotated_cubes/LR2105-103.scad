//
// LR2101-103 soft cubes
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
// The radius of the cube sides
cube_radius = 2;
// Distance between the cubes
cube_distance = cube_side * 0.8;
// Repetition extension x
repeat_x = 15;
// Repetition extension y
repeat_y = round(repeat_x / sin(60));
// The z rotation per distance unit.
rotate_z_step = 10;
// The x and y rotation per distance unit.
rotate_y_step = 5;
// Height of the base socket.
base = cube_side;


// Create a soft cube.
//
module createSoftCube() {
    delta = (cube_side-2*cube_radius)/2;
    hull() {
        dirs = [-1, 1];
        for (x = dirs) {
            for (y = dirs) {
                for (z = dirs) {
                    translate([x*delta, y*delta, z*delta])
                        sphere(r=cube_radius, $fn=20);
                }
            }
        }
    }
}


/// Repeat thee cubes.
///
module repeatCubes() {
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
                rotate_x = rotate_y_step * distance;
                rotate_z = rotate_z_step * distance;
                rotate([rotate_x, rotate_x, rotate_z]) {
                    children();
                }
            }
        }
    }
    translate([0, 0, -base/2]) {
        cube([(2*repeat_x+1)*cube_distance_x, (2*repeat_y+1)*cube_distance_y, base], center=true);
    }
}


repeatCubes()
    createSoftCube();

