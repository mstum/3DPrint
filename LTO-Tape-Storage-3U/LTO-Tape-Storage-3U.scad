/* LTO Tape Holder for 19" (Half-)Rack, 3U, 7 Tapes, mirror-able
 * By Michael Stum
 * https://www.stum.de/
 *
 * This work is licensed under a
 * Creative Commons Attribution-ShareAlike 4.0 International License.
 * https://creativecommons.org/licenses/by-sa/4.0/
 */
 
/* Usage Notes:
 * - You should strengthen the mounting ear and horizontal
 *   area with some piece of metal or wood or similar.
 * - LTO Tapes weigh around 250g/8.8oz each (in their cases).
 *   That's 1.75kg for 7 tapes.
 * - Slot width is meant to hold tapes in their protective cases
 * - Slot width should accomodate wider cases
 * - Can hold RDX Cartridges as well, and smaller
 *   tape formats like AIT, DDS, VXA, ...
 * - Not compatible with DLT/SDLT Tapes in their cases,
 *   Slots are slightly too narrow.
 * - All Units are in Millimeters (mm), unless multiplied with
 *   inch_to_mm, at which point they are in inch (in/")
 */
 
 use <../scadlib/misc.scad>
 use <../scadlib/rack_mount.scad>

// Should the spacers between tapes go all the way to the top?
full_height_walls = false;

// Add a ceiling?
add_ceiling = false;

// Add mounting ears for rack mount? (Set false if put on a desk or if you want to attach your own ear/rail)
add_rack_mount_ear = false;

// Two mirrored pieces (Left and Right) can be combined
// to fill out a 19" Rack. This sets whether we're doing
// the Left (false) or Right (true) side piece
is_right_side_piece = false;

// How thick should the floor be? (mm)
floor_strength = 3;

// How thick should the ceiling be if add_ceiling is true? (mm)
ceiling_strength = 3;

// Draw Tapes (for visualization, set false for STL export)
draw_tapes = false;

// Draw a mirrored second half for full 19" width (for visualization, set false for STL export)
draw_second_half = false;

// How "smooth" screw holes and other rounded parts are.
$fn = 256;

/********************************************
 * The actual drawing code                  *
 * stuff here isn't meant to be customized, *
 * as it may not work correctly.            */
/********************************************/
num_tapes = 7; // Can't change this, other magic numbers assume this
total_height = rack_units(3, apply_spacing = true);

wall_strength = 2;
back_strength = wall_strength;
ear_strength = wall_strength;

floor_width = 225;
floor_depth = 120;
wall_height_full = total_height-floor_strength;
wall_height =  full_height_walls
        ? add_ceiling
            ? wall_height_full-ceiling_strength
            : wall_height_full
        : 20;

/* LTO Tape in one of those annoying wide cases */
tape_width = 29;
tape_depth = 112;
tape_height = 114;

/* Breathing room on the side of each tape, basically whatever is left after subtracting the tape width and wall width */
tape_box_extra_width = (floor_width - (num_tapes * tape_width) - ((num_tapes+1) * wall_strength)) / num_tapes;
tape_box_width = tape_width + tape_box_extra_width;

module half_rack()
{
    // Floor
    color("LightGreen")
      cube(size = [floor_width, floor_depth, floor_strength], center = false);

    // First Spacer Wall - always full height
    color("Blue")
    translate([0,0,floor_strength])
      cube(size = [wall_strength, floor_depth, wall_height_full], center = false);
    
    // Spacer Walls
    for ( i = [1 : num_tapes-1] ){
        color("DimGray")
        translate([(tape_box_width + wall_strength) * i,0,floor_strength])
          cube(size = [wall_strength, floor_depth, wall_height], center = false);
    }
    
    // Spacer wall back supports
    if (!full_height_walls) {
        for ( i = [1 : num_tapes-1] ){
            color("Yellow")
            translate([(tape_box_width + wall_strength) * i,floor_depth-back_strength,floor_strength + wall_height])
              cube(size = [wall_strength, back_strength, wall_height_full-wall_height], center = false);
        }
    }
    
    // Last Spacer Wall - always full height
    color("Blue")
    translate([(tape_box_width + wall_strength) * num_tapes,0,floor_strength])
      cube(size = [wall_strength, floor_depth, wall_height_full], center = false);

    // Back Wall
    color("Red")
    translate([0,floor_depth,0])
      cube(size = [floor_width, back_strength, total_height], center = false);

    if (add_ceiling) {
        color("Green")
        translate([0,0,total_height-ceiling_strength])
          cube(size = [floor_width, floor_depth, ceiling_strength], center = false);
    }
    
    if (add_rack_mount_ear) {
        color("DarkViolet") mounting_ear();
    }

    // Tapes
    if (draw_tapes) {
        for ( i = [0 : num_tapes-1] ){
            tape_position = ((tape_box_width + wall_strength) * i) + wall_strength + (tape_box_extra_width/2);
            
            color("DeepSkyBlue", 0.7)
            translate([tape_position,0,floor_strength+1])
              cube(size = [tape_width, tape_depth, tape_height], center = false);
        }
    }
}

module mounting_ear()
{
    ear_width = inch_to_mm(1);
    
    translate([-ear_width,0,0]) 
    difference() {            
        rack_mounting_ear(units = 3, ear_width = ear_width, ear_strength = ear_strength);
        
        // Bottom U: Two Holes
        rack_mounting_ear_holes(bottom = true, top = true, middle = false, ear_width = ear_width, ear_strength = ear_strength);
        
        // Top U: Middle Hole
        translate([0,0,rack_units(2)])
            rack_mounting_ear_holes(bottom = false, top = false, middle = true, ear_width = ear_width, ear_strength = ear_strength);
    }
}

mirror_first = is_right_side_piece ? 1 : 0;
mirror_second = is_right_side_piece ? 0 : 1;
translate_second_multi = is_right_side_piece ? -1 : 1;

mirror([mirror_first,0,0]) half_rack();

if (draw_second_half) {
  translate([(floor_width * 2) * translate_second_multi,0,0])
  mirror([mirror_second,0,0])
    half_rack();
}
