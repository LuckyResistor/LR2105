//
// LR2101-104 random blocks
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
// Distance between the cubes
cube_distance = cube_side * 0.8;
// The random z variation.
random_z_variation = cube_side;
// distance_factor
distance_factor = 0.4;
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


// Create a cube.
//
module createCube() {
    cube([cube_side, cube_side, cube_side], center=true);
}


/// Repeat thee cubes.
///
module repeatCubes() {
    random_z = rands(-1.0, 1.0, (2*repeat_y+10)*(2*repeat_x+10));
    cube_distance_x = cube_distance;
    cube_distance_y = cube_distance * sin(60);
    max_distance = norm([repeat_x, repeat_y]);
    random_z_index = 0;
    for (y = [-repeat_y:repeat_y]) {
        is_even = (y % 2 == 0);
        adjustment = (is_even ? 0 : 0.5);
        begin_x = -repeat_x + adjustment;
        end_x = repeat_x - adjustment;
        for (x = [begin_x:1.0:end_x]) {
            distance = norm([x, y]);
            rand_index = ((y+repeat_y)*(2*repeat_y+1))+x-begin_x;
            dist_f = (distance/max_distance);
            tz = pow(dist_f, 2) * distance_factor * random_z_variation * random_z[rand_index];
            translate([cube_distance_x*x, cube_distance_y*y, tz]) {
                children();
            }
            random_z_index = random_z_index + 1;
        }
    }
    translate([0, 0, -base/2]) {
        cube([(2*repeat_x+1)*cube_distance_x, (2*repeat_y+1)*cube_distance_y, base], center=true);
    }
}


repeatCubes()
    createCube();

