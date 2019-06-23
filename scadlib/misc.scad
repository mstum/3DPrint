/* OpenSCAD Utility Library
 * By Michael Stum
 * https://www.stum.de/
 *
 * This work is licensed under a
 * Creative Commons Attribution-ShareAlike 4.0 International License.
 * https://creativecommons.org/licenses/by-sa/4.0/
 */

function inch_to_mm(inch) = inch * 25.4;

module rounded_cube(d,r=2) {
    cube_width = d[0]-(r*2);
    cube_height = d[1];
    cube_depth = d[2]-(r*2);
   
    minkowski() {
        translate([r,0,r]) cube([cube_width, cube_height, cube_depth]);
        
        rotate([90,0,0])
        cylinder(r=r,h=cube_depth,center=true, $fn=64);
    }
}