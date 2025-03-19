include <svg_dimensions.scad>;

KEYCAP_WIDTH = 17.5;
KEYCAP_HEIGHT = 9.2;
KEYCAP_SURFACE_LOWEST_POINT = 8.28; // Lowest point on the surface
KEYCAP_SURFACE_WIDTH = 10.5;
KEYCAP_SURFACE_LENGTH = 12;
KEYCAP_CONVEXITY = 7; // To address preview issues
KEYCAP_COLOUR = "LightGrey"; // This color and others below are for preview TO_RENDER

// SPACING between keycaps
SPACING = 4;
LAYER_HEIGHT = 0.1; // With 0.2 nozzle the layer height is usually 0.1
LAYER_LINE_WIDTH = 0.22;
PRINT_DEPTH = LAYER_HEIGHT * 2; // Best when it is double layer height
SURFACE_DIFF_DEPTH = KEYCAP_HEIGHT - KEYCAP_SURFACE_LOWEST_POINT + PRINT_DEPTH;

// Either place keys in a precise layout you configured them,
// or just in a number of rows one by one
AUTO_LAYOUT = false;
AUTO_LAYOUT_KEYS_PER_ROW = 8;

SURFACE_PRINT_ANGLE = 0; // In the case surface is at angle

/**
 * Surface Center Print (for Base layer)
 */
SURFACE_CENTER_PRINT_COLOUR = "black";
SURFACE_CENTER_PRINT_RELATIVE_Y = 0;
// Leaving one layer above the colour
// The calculation should be KEYCAP_SURFACE_LOWEST_POINT - PRINT_DEPTH - LAYER_HEIGHT,
// but we want it to be dividable by layer height
SURFACE_CENTER_PRINT_POSITION_Z = KEYCAP_SURFACE_LOWEST_POINT - PRINT_DEPTH - LAYER_HEIGHT;

/**
 * Surface Upper Right Print (for Upper / Raise layer)
 */
 SURFACE_RIGHT_PRINT_COLOUR = "red";
 SURFACE_RIGHT_PRINT_POSITION_Z = SURFACE_CENTER_PRINT_POSITION_Z;
 
/**
 * Surface Lower Left Print (for Lower layer)
 */
 SURFACE_LEFT_PRINT_COLOUR = "blue";
 SURFACE_LEFT_PRINT_POSITION_Z = SURFACE_CENTER_PRINT_POSITION_Z;

/**
 * Side print (for Adjust Layer)
 */
SIDE_PRINT_ANGLE = 74.798;
SIDE_PRINT_POSITION_Z = 6;
SIDE_PRINT_RELATIVE_Y = -6.67;
SIDE_PRINT_COLOUR = "purple";

/**
 * TO_RENDER print selected part
 * Options are: all, body, print, center, left, right, side
 */
TO_RENDER = "all";

// Default keycap body to be TO_RENDERed if alternative not provided
defaultBody = "bodies/cylindric-concave.3mf";

// Data to TO_RENDER keycaps
keycaps = [
    keycap(0, 0, center_svg = "KC_Q",    left_svg = "KC_ESC",  right_svg = "KC_ESC", side_svg = "KC_ESC"),
    keycap(0, 7, center_svg = "KC_I",    left_svg = "KC_UP",   right_svg = "KC_8", side_svg = "KC_LBRC"),
    keycap(0, 8, center_svg = "KC_O",    left_svg = "KC_END",  right_svg = "KC_9", side_svg = "KC_RBRC"),
    keycap(0, 9, center_svg = "KC_P",    left_svg = "KC_BSPC_small", right_svg = "KC_BSPC_small", side_svg = "KC_BSPC"),

    keycap(1, 0, center_svg = "KC_A",    left_svg = "KC_GRV",  right_svg = "KC_QUOT", side_svg="KC_TAB"),

    keycap(2, 0, center_svg = "KC_Z",    left_svg = "KC_LSFT", right_svg = "MS_BTN3", side_svg = "KC_LSFT"),
    keycap(2, 1, center_svg = "KC_X",    left_svg = "KC_F1",   right_svg = "KC_BSLS",  side_svg = "KC_LCTL"),
    keycap(2, 2, center_svg = "KC_C",    left_svg = "KC_F2",   right_svg="KC_COMM", side_svg = "KC_LALT"),
    keycap(2, 3, center_svg = "KC_V",    left_svg = "KC_F3",   right_svg = "KC_DOT", side_svg = "KC_LGUI"),
    keycap(2, 4, center_svg = "KC_B",    left_svg = "KC_F11",  side_svg = "KC_DEL"),
    
    keycap(2, 5, center_svg = "KC_N",    left_svg = "KC_DEL",  right_svg = "MS_BTN1", side_svg = "KC_ENT"),
    keycap(2, 6, center_svg = "KC_M",    left_svg = "KC_TAB",  right_svg= "KC_1", side_svg = "KC_LGUI"),
    keycap(2, 7, center_svg = "KC_COMM", left_svg = "KC_INS",  right_svg= "KC_2", side_svg = "KC_LALT"),
    keycap(2, 8, center_svg = "KC_DOT",  left_svg = "KC_APP",  right_svg= "KC_3", side_svg = "ctrl"),
    keycap(2, 9, center_svg = "KC_SLSH", right_svg="MS_ACL0",  side_svg = "KC_LSFT"),

    keycap(3, 3, center_svg = "KC_SPC"),
    keycap(3, 4, center_svg = "TL_LOWR", side_svg = "ADJUST"),
    keycap(3, 5, center_svg = "TL_UPPR", side_svg = "ADJUST"),
    keycap(3, 6, center_svg = "KC_ENT_with_icon")
];

// Prepares keycap definition
function keycap(
    line, row, // Row and line how the keycap should appear on the print board
    body = defaultBody,
    center_svg="",
    left_svg="",
    right_svg="",
    side_svg="",
    side_relative_y=SIDE_PRINT_RELATIVE_Y,
    side_position_z=SIDE_PRINT_POSITION_Z,
    side_angle=SIDE_PRINT_ANGLE,    
) = [    
    ["line", line],
    ["row", row],
    ["body", body],
    ["center_svg", center_svg],
    ["left_svg", left_svg],
    ["right_svg", right_svg],
    ["side_svg", side_svg],
    ["side_relative_y", side_relative_y],
    ["side_position_z", side_position_z],
    ["side_angle", side_angle]
];

if (TO_RENDER == "all" || TO_RENDER == "body") {
    color(KEYCAP_COLOUR) union() for (i = [0:len(keycaps)-1]) printBody(keycaps[i], i);
}

// Surface center (Base Layer)
if (TO_RENDER == "all" || TO_RENDER == "base" || TO_RENDER == "print") {
    color(SURFACE_CENTER_PRINT_COLOUR) union() for (i = [0:len(keycaps)-1]) printBase(keycaps[i], i);
}
// Surface left (Lower Layer)
if (TO_RENDER == "all" || TO_RENDER == "left" || TO_RENDER == "print") {
    color(SURFACE_LEFT_PRINT_COLOUR) union() for (i = [0:len(keycaps)-1]) printLower(keycaps[i], i);
}
// Surface right (Raise / Upper Layer)
if (TO_RENDER == "all" || TO_RENDER == "right" || TO_RENDER == "print") {
    color(SURFACE_RIGHT_PRINT_COLOUR) union() for (i = [0:len(keycaps)-1]) printRaise(keycaps[i], i);
}
// Surface center (Adjust Layer)
if (TO_RENDER == "all" || TO_RENDER == "side" || TO_RENDER == "print") {
    color(SIDE_PRINT_COLOUR) union() for (i = [0:len(keycaps)-1]) printAdjust(keycaps[i], i);
}

module printBody(definition, index) {    
    row = getRow(definition, index);
    line = getLine(definition, index);
    body = get(definition, "body");
    center_svg = get(definition, "center_svg");
    left_svg = get(definition, "left_svg");
    right_svg = get(definition, "right_svg");
    side_svg = get(definition, "side_svg");
    side_relative_y = get(definition, "side_relative_y");
    side_position_z = get(definition, "side_position_z");
    side_angle = get(definition, "side_angle");
    difference() {
        translate([row * (KEYCAP_WIDTH + SPACING), -line * (KEYCAP_WIDTH + SPACING), KEYCAP_HEIGHT/2]) {
            // There's some issue with 2025.03.16 imported files are floating a few mm above XY plane
            import(body, center=true, convexity=KEYCAP_CONVEXITY);
        }
        printSvg(
            row, line,
            svg = center_svg,
            relative_y = SURFACE_CENTER_PRINT_RELATIVE_Y,
            position_z = SURFACE_CENTER_PRINT_POSITION_Z,
            angle = SURFACE_PRINT_ANGLE,
            depth = SURFACE_DIFF_DEPTH
        );
        printSvg(
            row, line,
            svg = left_svg,
            relative_x = -getRelativeSvgPositionX(left_svg),
            relative_y = -getRelativeSvgPositionY(left_svg),            
            position_z = SURFACE_LEFT_PRINT_POSITION_Z,
            angle = SURFACE_PRINT_ANGLE,
            depth = SURFACE_DIFF_DEPTH
        );
        printSvg(
            row, line,
            svg = right_svg,
            relative_x = getRelativeSvgPositionX(right_svg),
            relative_y = getRelativeSvgPositionY(right_svg),            
            position_z = SURFACE_RIGHT_PRINT_POSITION_Z,
            angle = SURFACE_PRINT_ANGLE,
            depth = SURFACE_DIFF_DEPTH
        );
        printSvg(
            row, line,
            svg = side_svg,
            relative_y = side_relative_y,
            position_z = side_position_z,
            angle = side_angle,
            depth = LAYER_LINE_WIDTH*2
        );
    }
}

module printBase(definition, index) {
    color(SURFACE_CENTER_PRINT_COLOUR) union() for (definition = keycaps) printSvg(
        getRow(definition, index), getLine(definition, index),
        svg = get(definition, "center_svg"),
        relative_y = SURFACE_CENTER_PRINT_RELATIVE_Y,
        position_z = SURFACE_CENTER_PRINT_POSITION_Z,
        angle = SURFACE_PRINT_ANGLE
    );
}

module printLower(definition, index) {
    printSvg(
        getRow(definition, index), getLine(definition, index),
        svg = get(definition, "left_svg"),
        relative_x = -getRelativeSvgPositionX(get(definition, "left_svg")),
        relative_y = -getRelativeSvgPositionY(get(definition, "left_svg")),       
        position_z = SURFACE_LEFT_PRINT_POSITION_Z,
        angle = SURFACE_PRINT_ANGLE
    );
}

module printRaise(definition, index) {
    printSvg(
        getRow(definition, index), getLine(definition, index),
        svg = get(definition, "right_svg"),
        relative_x = getRelativeSvgPositionX(get(definition, "right_svg")),
        relative_y = getRelativeSvgPositionY(get(definition, "right_svg")),       
        position_z = SURFACE_LEFT_PRINT_POSITION_Z,
        angle = SURFACE_PRINT_ANGLE
    );
}

module printAdjust(definition, index) {
    printSvg(
        getRow(definition, index), getLine(definition, index),
        get(definition, "side_svg"),
        relative_y = get(definition, "side_relative_y"),
        position_z = get(definition, "side_position_z"),
        angle = get(definition, "side_angle"),
        depth = LAYER_LINE_WIDTH*2
    );
}

module printSvg(
    row, line,
    svg,
    relative_x = 0,
    relative_y,
    position_z,
    angle = 0,
    depth = PRINT_DEPTH
) {
    if (svg != "") {
        translate([row * (KEYCAP_WIDTH + SPACING), -line * (KEYCAP_WIDTH + SPACING), 0]) {
            translate([relative_x, relative_y, position_z])
            rotate([angle])
            linear_extrude(height=depth) {                
                import(str("svg/", svg, ".svg"), center=true);
            }
        }
    }
}

// Finds a value from pseudo-map (a collection of tuples)
function get(map, key) = map[search([key], map)[0]][1];

function getRow(definition, index) = AUTO_LAYOUT ? index %AUTO_LAYOUT_KEYS_PER_ROW : get(definition, "row");
function getLine(definition, index) = AUTO_LAYOUT ? floor(index/AUTO_LAYOUT_KEYS_PER_ROW) : get(definition, "line");

function getRelativeSvgPositionX(name) = name != "" ? KEYCAP_SURFACE_WIDTH/2 - get(svg_dimensions, name)[0]/2 : 0;
function getRelativeSvgPositionY(name) = name != "" ? KEYCAP_SURFACE_LENGTH/2 - get(svg_dimensions, name)[1]/2 : 0;