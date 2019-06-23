/* OpenSCAD Utility Library: Rack Mounted Stuff
 * By Michael Stum
 * https://www.stum.de/
 *
 * This work is licensed under a
 * Creative Commons Attribution-ShareAlike 4.0 International License.
 * https://creativecommons.org/licenses/by-sa/4.0/
 */

use <misc.scad>;

function rack_spacing() = 0.794; // ​1⁄32 inch (0.03125 in or 0.794 mm)
function rack_units(units = 1, apply_spacing = false)
    = apply_spacing
        ? (44.45 * units) - rack_spacing()
        : (44.45 * units);
        
module rack_mounting_ear(units = 1, apply_spacing = true, ear_width = 25.4, ear_strength = 2)
{   
    total_height = rack_units(units, apply_spacing);    
    cube(size = [ear_width, ear_strength, total_height], center = false);
}

module rack_mounting_ear_holes(bottom = true, top = true, middle = true, ear_width = inch_to_mm(1), ear_strength = 2)
{    
    // Assuming an M6 Screw/Bolt
    ear_screwhole_width = 12;
    ear_screwhole_height = 6.5;
    ear_screwhole_height_half = ear_screwhole_height/2;
    ear_screwhole_ypos = -(ear_strength/2);
    
    vpos = (ear_width - ear_screwhole_width) / 2;
    top_pos = (rack_units() - ear_screwhole_height) - (inch_to_mm(0.25) - ear_screwhole_height_half);
    middle_pos = rack_units(0.5) - (ear_screwhole_height/2);
    bottom_pos = inch_to_mm(0.25) - ear_screwhole_height_half;
    
    if (top) {
        translate([vpos,ear_screwhole_ypos,top_pos])
          rounded_cube([ear_screwhole_width, ear_strength*2, ear_screwhole_height]);
    }
    
    if (middle) {
        translate([vpos,ear_screwhole_ypos,middle_pos])
          rounded_cube([ear_screwhole_width, ear_strength*2, ear_screwhole_height]);
    }
    
    if (bottom) {
        translate([vpos,ear_screwhole_ypos,bottom_pos])
          rounded_cube([ear_screwhole_width, ear_strength*2, ear_screwhole_height]);
    }
}