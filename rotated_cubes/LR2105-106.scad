//
// LR2101-106
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


// The radius of the hexagon.
hex_radius = 8;
// The height of the hex objects
hex_height = hex_radius*8;
// Distance between the cubes
object_distance = 12;
// The random z variation.
random_z_variation = hex_radius*2;
// The random xy variation
random_xy_variation = hex_radius/2;
// The random x rotation
random_x_rotation = 12;
// The random y rotation
random_y_rotation = 12;
// Repetition extension x
repeat_x = 30;
// Repetition extension y
repeat_y = round(repeat_x / sin(60));


// The object x distances.
object_distance_x = object_distance;
// The object y distance.
object_distance_y = object_distance * sin(60);
// The maximum distance.
max_distance = norm([repeat_x, repeat_y]);


// Create the randomized object
//
module createObject() {
    rotate([0, 0, 30])
        cylinder(h=hex_height, r=hex_radius, center=true, $fn=6);
}


/// Repeat the objects.
///
module repeatObject() {
    random_count = (repeat_y+10)*(repeat_x+10);
    random_x = rands(-1.0, 1.0, random_count);
    random_y = rands(-1.0, 1.0, random_count);
    random_z = rands(-1.0, 1.0, random_count);
    random_xr = rands(-1.0, 1.0, random_count);
    random_yr = rands(-1.0, 1.0, random_count);
    random_z_index = 0;
    for (y = [0:repeat_y]) {
        is_even = (y % 2 == 0);
        adjustment = (is_even ? 0 : 0.5);
        begin_x = adjustment;
        end_x = repeat_x - adjustment;
        for (x = [begin_x:1.0:end_x]) {
            distance = norm([-repeat_x/2, -repeat_y/2]+[x, y]);
            rand_index = (y*repeat_y+x);
            dist_f = 1.0-(distance/max_distance);
            height_factor = pow(dist_f, 3);
            translate_factor = max(0, pow(dist_f, 3)-repeat_x/4);
            rotation_factor = max(0, pow(dist_f, 2));
            terrain_z = max(0, pow(dist_f, 5) - 0.1) * 300;
            tz = terrain_z + height_factor * random_z_variation * random_z[rand_index];
            tx = translate_factor * random_xy_variation * random_x[rand_index];
            ty = translate_factor * random_xy_variation * random_y[rand_index];
            rx = rotation_factor * random_x_rotation * random_xr[rand_index];
            ry = rotation_factor * random_y_rotation * random_yr[rand_index];
            translate([object_distance_x*x+tx, object_distance_y*y+ty, tz]) {
                rotate([rx, ry, 0]) {
                    children();
                }
            }
            random_z_index = random_z_index + 1;
            // Add the support below.
            translate([object_distance_x*x, object_distance_y*y, -hex_height]) {
                cube([object_distance_x+0.1, object_distance_y+0.1, hex_height + terrain_z]);
            }
        }
    }
}

intersection() {
    repeatObject()
        createObject();
    radius = repeat_x/2*object_distance;
    translate([radius, radius, 0])
        cylinder(r=radius, h=500, $fn=120);
}

