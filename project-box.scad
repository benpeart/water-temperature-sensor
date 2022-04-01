$fn=50;

// ********************************************************************7
// Paremeters
// *********************************************************************

fudge=0.004;

// screw dimenstions
m2_screw_diameter = 2.2;
m3_screw_diameter = 3.2;
screw_length = 10;
screw_diameter = m2_screw_diameter;
screw_head_height = 1.5;
screw_head_diameter = 3.5;
screw_column_width = screw_diameter * 2;

// PCB dimensions
pcb_width = 88.9;
pcb_length = 52.1;
pcb_height = 1.6;
pcb_radius = 6;
mounting_hole_width = 78.7;
mounting_hole_length = 35.6;

// box interior dimensions
width = pcb_width + 2 * screw_column_width;
length = pcb_length + 2 * screw_column_width;
height = 30;

// case exterior dimensions
wall_thickness = 2;
wall_radius = wall_thickness;
case_width = width + 2 * wall_thickness;
case_length = length + 2 * wall_thickness;
case_height = height + 2 * wall_thickness;

// lid dimensions
lid_thickness = 4;
lid_clearance = 0.2;

// position of standoff for PCB
pcb_hole_x_offset = wall_thickness + (width - mounting_hole_width) / 2;
pcb_hole_y_offset = wall_thickness + (length - mounting_hole_length) / 2;
pcb_hole_diam = 2.2;
pcb_standoff_diameter = 5;
pcb_standoff_height = 5;

// sizes of penetrations
usb_width = 12;
usb_height = 8;
usb_height_from_pcb = 1;
thermocouple_diameter = 3;

// ********************************************************************7
// Build
// *********************************************************************

// Render the project box
project_box();

// You can render your pcb to show it inside the case
color("blue") translate([wall_thickness - wall_radius / 2 + screw_column_width + pcb_radius, wall_thickness - wall_radius / 2 + screw_column_width + pcb_radius,wall_thickness+pcb_standoff_height]) pcb();

// Render the lid
#translate([0,0,wall_thickness + height + lid_thickness / 2 + 5])
    project_lid();

// Render the lid for printing
*project_lid();

// ********************************************************************7
// Modules
// *********************************************************************

module project_box() 
{
    difference()
    {
        // make the outside box
        linear_extrude(case_height)
        {
            minkowski()
            {
                square([case_width - wall_radius, case_length - wall_radius]);
                circle(wall_radius);
            }
        }

        // remove the interior
        translate([wall_thickness - wall_radius / 2, wall_thickness - wall_radius / 2, wall_thickness])
            cube([width, length, height + wall_thickness + fudge]);

        // make a hole centered on the usb port above the PCB
        translate([- wall_radius - fudge, (case_length - wall_radius - usb_width) / 2, wall_thickness + pcb_standoff_height + pcb_height + usb_height_from_pcb - usb_height / 2]) 
            cube([wall_thickness + wall_radius / 2 + 2 * fudge, usb_width, usb_height]);
        
        // make a hole for the temperature probe
        translate([- wall_radius - fudge, case_length / 4 - wall_radius / 2, wall_thickness + case_height - lid_thickness - thermocouple_diameter / 2])
            rotate([0, 90, 0])
                union()
                {
                    cylinder(h = wall_thickness + wall_radius / 2 + fudge * 2, d = thermocouple_diameter);
                    translate([-lid_thickness, -thermocouple_diameter / 2, 0])
                        cube([lid_thickness, thermocouple_diameter, wall_thickness + wall_radius / 2 + fudge * 2]);
                }
    }

    // add columns to hold lid screws
    translate([wall_thickness - wall_radius / 2, wall_thickness - wall_radius / 2, wall_thickness])
        screw_column(screw_column_width, height, screw_diameter, screw_length);
    translate([width + wall_thickness - wall_radius / 2 - screw_column_width, wall_thickness - wall_radius / 2, wall_thickness])
        screw_column(screw_column_width, height, screw_diameter, screw_length);
    translate([wall_thickness - wall_radius / 2, length + wall_thickness - wall_radius / 2 - screw_column_width, wall_thickness])
        screw_column(screw_column_width, height, screw_diameter, screw_length);
    translate([width + wall_thickness - wall_radius / 2 - screw_column_width, length + wall_thickness - wall_radius / 2 - screw_column_width, wall_thickness])
        screw_column(screw_column_width, height, screw_diameter, screw_length);

    // add standoff for PCB
    translate([pcb_hole_x_offset - wall_radius / 2, pcb_hole_y_offset - wall_radius / 2, wall_thickness])
        round_stand_off(pcb_standoff_diameter, pcb_standoff_height, screw_length, screw_diameter);
    translate([pcb_hole_x_offset - wall_radius / 2 + mounting_hole_width, pcb_hole_y_offset - wall_radius / 2, wall_thickness])
        round_stand_off(pcb_standoff_diameter, pcb_standoff_height, screw_length, screw_diameter);
    translate([pcb_hole_x_offset - wall_radius / 2, pcb_hole_y_offset - wall_radius / 2 + mounting_hole_length, wall_thickness])
        round_stand_off(pcb_standoff_diameter, pcb_standoff_height, screw_length, screw_diameter);
    translate([pcb_hole_x_offset - wall_radius / 2 + mounting_hole_width, pcb_hole_y_offset - wall_radius / 2 + mounting_hole_length, wall_thickness])
        round_stand_off(pcb_standoff_diameter, pcb_standoff_height, screw_length, screw_diameter);
}

module project_lid()
{
    difference()
    {
        union()
        {
            linear_extrude(lid_thickness / 2)
            {
                minkowski()
                {
                    square([case_width - wall_radius, case_length - wall_radius]);
                    circle(wall_radius);
                }
            }
            translate([wall_thickness - wall_radius / 2, wall_thickness - wall_radius / 2, -lid_thickness / 2 + lid_clearance])
                cube([width, length, lid_thickness / 2 - lid_clearance]);
        }
        
        // TODO: mounting screw holes
        translate([screw_column_width / 2 + wall_thickness - wall_radius / 2, screw_column_width / 2 + wall_thickness - wall_radius / 2, - lid_thickness / 2 + lid_clearance / 2 - fudge])
            cylinder(h = lid_thickness + fudge * 2, d = screw_diameter);
        translate([-screw_column_width / 2 + wall_thickness - wall_radius / 2 + width, screw_column_width / 2 + wall_thickness - wall_radius / 2, - lid_thickness / 2 + lid_clearance / 2 - fudge])
            cylinder(h = lid_thickness + fudge * 2, d = screw_diameter);
        translate([screw_column_width / 2 + wall_thickness - wall_radius / 2, length - screw_column_width / 2 + wall_thickness - wall_radius / 2, - lid_thickness / 2 + lid_clearance / 2 - fudge])
            cylinder(h = lid_thickness + fudge * 2, d = screw_diameter);
        translate([-screw_column_width / 2 + wall_thickness - wall_radius / 2 + width, length - screw_column_width / 2 + wall_thickness - wall_radius / 2, - lid_thickness / 2 + lid_clearance / 2 - fudge])
            cylinder(h = lid_thickness + fudge * 2, d = screw_diameter);

        // TODO: mounting screw hole counter sinks
        translate([screw_column_width / 2 + wall_thickness - wall_radius / 2, screw_column_width / 2 + wall_thickness - wall_radius / 2, lid_thickness / 2 - screw_head_height + fudge])
            cylinder(h = screw_head_height + fudge, d = screw_head_diameter);
        translate([-screw_column_width / 2 + wall_thickness - wall_radius / 2 + width, screw_column_width / 2 + wall_thickness - wall_radius / 2, lid_thickness / 2 - screw_head_height + fudge])
            cylinder(h = screw_head_height + fudge * 2, d = screw_head_diameter);
        translate([screw_column_width / 2 + wall_thickness - wall_radius / 2, length - screw_column_width / 2 + wall_thickness - wall_radius / 2, lid_thickness / 2 - screw_head_height + fudge])
            cylinder(h = screw_head_height + fudge * 2, d = screw_head_diameter);
        translate([-screw_column_width / 2 + wall_thickness - wall_radius / 2 + width, length - screw_column_width / 2 + wall_thickness - wall_radius / 2, lid_thickness / 2 - screw_head_height + fudge])
            cylinder(h = screw_head_height + fudge * 2, d = screw_head_diameter);
    }
}

module pcb()
{
    linear_extrude(pcb_height) 
    {
        minkowski()
        {
            square([pcb_width - 2 * pcb_radius, pcb_length - 2 * pcb_radius]);
            circle(pcb_radius);
        }
    }
}


module screw_column(width, height, screw_diameter, screw_length)
{
    difference()
    {
        cube([width, width, height]);
        translate([width / 2, width / 2, height - screw_length])
            cylinder(h = screw_length + fudge, d = screw_diameter);
    }
}

module round_stand_off(diam, height, screw_length, screw_diam)
{
	difference()
	{
		translate([0,0,height/2])
            cylinder(h=height,r=diam/2, center=true);
		translate([0,0,height-screw_length])
            cylinder(h=screw_length+fudge,r=screw_diam/2);
	}
}

module stand_off(width, height, screw_diam, screw_length)
{
	difference()
	{
		translate([0,0,height/2])
            cube([width,width,height], center=true);
		translate([0,0,height-screw_length])
            cylinder(h=screw_length+fudge,r=screw_diam/2);
	}
}

