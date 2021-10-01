// Written by Manuel Braun aka Mommel <https://github.com/mommel>
//
// This parametrized Incubator is intended to be printed with pla with 
// any common 3D printer. 
// This file and the models created by anybody with it are licensed under
// Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
// This software is distributed without any warranty.
// For scientific use, you can ask for permission (free of charge) by contacting the author
// or directly add credits for the used product to the papers it was used in.
// Dedication along with this software.

/*[ Define the amount of containers the model will be created for you]*/

// Amount of containers per column 
container_column_amount=6; // [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// Amount of containers per row
container_row_amount=4; // [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

module __Customizer_Limit__ () {} 

baseplate_height=2;
outer_wall_thickness = 2;
outer_wall_height = 8;
inner_wall_thickness = 3;
inner_wall_height = 15;
injection_mole_height = 6.2;
container_width_outline = 19;
container_connector_width = 2 ;
baseplate_width = container_width_outline * ( container_column_amount + 0.5 );
baseplate_length = container_width_outline * ( container_row_amount + 0.5 );

// Creating the incubator
paraboot();

module paraboot() {
    union(){
        peel();
        translate([-2, 0, 0])
            containers();
    }

}

module peel() {
    // baseplate
    cube([baseplate_width, baseplate_length, baseplate_height]);
    rotate([90, 0, 0])
        linear_extrude(height = 1) {
            translate([2, 2])
            text(chr([80, 97, 114, 97, 98, 114, 111, 111, 116]), 4);
        }
    translate([2, 2, 8])
    rotate([90, 0, 0])
    linear_extrude(height = 1) {
        translate([2, 2]) 
        text(chr([77, 111, 109, 109, 101, 108 ]), 4);
    }
    // Outer walls
    peel_outherwalls();
    // Inner walls
    peel_innerwalls();
}

// The higher walls direcly attached to the outher walls
module peel_innerwalls() {
    translate([outer_wall_thickness, outer_wall_thickness, 0])
      difference() {
        cube([
            container_width_outline * container_column_amount + 2 * inner_wall_thickness, 
            container_width_outline * container_row_amount + 2 * inner_wall_thickness,
            inner_wall_height
        ]);

        translate([inner_wall_thickness, inner_wall_thickness, 0])  
            cube([container_width_outline * container_column_amount, 
                  container_width_outline * container_row_amount,
                  inner_wall_height + 0.1]);
      }
}

// The outher walls
module peel_outherwalls() {
    difference() {
        cube([baseplate_width, baseplate_length, outer_wall_height]);
        translate([outer_wall_thickness + inner_wall_thickness, outer_wall_thickness + inner_wall_thickness, 0])
          cube([
            baseplate_width - 2 * ( outer_wall_thickness + inner_wall_thickness ),
            container_width_outline * ( container_row_amount + 0.5 ) - 2 * ( outer_wall_thickness + inner_wall_thickness ), 
            outer_wall_height + 0.1
        ]);    
    }
}

// Container
module containers() {
    difference() {
        translate([16.45, 14.25, 2])
          union() {
            // creates columns
            for(columnNum =[0:container_column_amount - 1])
                // creates rows
                for(rowNum =[0:container_row_amount - 1])
                    translate([columnNum * container_width_outline, rowNum * container_width_outline, 0])
                        container();
          }
          // Bridges between containers
          container_bridge_columns();
          container_bridge_rows();
          
    }
    injection_moles();
}

// Bridges between row based containers
module container_bridge_rows() {
for(rowNum =[0:container_row_amount - 1])
    translate([13.45, 13.15 + rowNum * container_width_outline + 0.05, 6])
        cube([
            container_width_outline * (container_column_amount -0.5),
            container_connector_width,
            inner_wall_height
        ]);
}


// Bridges between columns based containers
module container_bridge_columns() {
    for(columnNum =[0:container_column_amount - 1])
        translate([15.45 + columnNum * container_width_outline, 10.15, 6])
            cube([
                container_connector_width,
                container_width_outline * (container_row_amount - 0.5),
                inner_wall_height
            ]);
}

// Creates a container
module container() {
    // Creates the container walls
    difference() {
        cylinder(h = inner_wall_height + 0.8, r = container_width_outline/2);
        cylinder(h = inner_wall_height + 0.9, r = (container_width_outline/2) - 1.5 );
    }
    // Creates primitive and incomplete injector molde
    cylinder(h = 8.2, r = 2.6);
    combiner();
}


// Combing blocks around containers
module combiner() {
    // YAxis +
    translate([-3.4, 8.5, 0])
      cube([7, 2, 15]);
    
    // YAxis -
    translate([-3.4, -10.5, 0])
      cube([7, 2, 15]);
    
    rotate([0, 0, 90])
      union(){
        // XAxis -
        translate([-3.4, 8.5, 0])
          cube([7, 2, 15]);
        
        // XAxis +
        translate([-3.4, -10.5, 0])
          cube([7, 2, 15]); 
      }
}

// Injection moles
module injection_moles() {
    translate([16.45, 14.25, 2])
      union(){
            for(columnNum =[0:container_column_amount - 1])
                for(rowNum =[0:container_row_amount - 1])
                    translate([columnNum * container_width_outline, rowNum * container_width_outline, 0])
                      difference() {
                        cylinder(h = injection_mole_height, r = 2.6);
                        translate([0, 0, injection_mole_height])
                          sphere(r = 0.8);
                      }  
                
        }
}