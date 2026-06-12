module labour::Syntax

/*
 * Define a concrete syntax for LaBouR. The language's specification is available in the PDF (Section 2)
 */

/*
 * Note, the Server expects the language base to be called BoulderingWall.
 * You are free to change this name, but if you do so, make sure to change everywhere else to make sure the
 * plugin works accordingly.
 */

lexical StringLiteral = "\"" ![\"\n]* "\"";
lexical IntegerLiteral = [\-]? [0-9]+;
lexical Id = [a-z_][a-zA-Z0-9_]*;

start syntax BoulderingWall
 = wall: "bouldering_wall" IntegerLiteral id StringLiteral name "{" RouteList routes VolumeList volumes "}"
 ;

syntax RouteList 
  = "routes" "[" {BoulderingRoute ","}* routes "]"
 ;

start syntax BoulderingRoute
 = "bouldering_route" StringLiteral name "{" 
      "grade:" StringLiteral grade ","
      "grid_base_point" Point basePoint ","
      "holds" "[" {HoldReference ","}* holds "]"
    "}"
 ;

syntax VolumeList 
  = "volumes" "[" {Volume ","}* volumes "]"
 ;
 
start syntax Volume
 = circle: "circle" "{" 
      "pos:" Point pos ","
      "depth:" IntegerLiteral depth ","
      "radius:" IntegerLiteral radius ","
      HoldGroup front "front_holds"
      HoldGroup side "side_holds"
    "}"
  | triangle: "triangle" "{"
      "pos:" Point pos ","
      "extrusion:" Point extrusion ","
      "depth:" IntegerLiteral depth ","
      "corners" "[" Point c1 "," Point c2 "," Point c3 "]" ","
      (HoldGroup left "left_holds")
      (HoldGroup right "right_holds")
      (HoldGroup bottom "bottom_holds")
    "}"
 ;

syntax HoldGroup
  = "[" {Hold ","}* holds "]" 
 ;

start syntax Hold
 = "hold" StringLiteral holdId "{" 
      "pos:" Point pos ","
      "shape:" StringLiteral shape ","
      ( "rotation:" IntegerLiteral rotation "," )?
      "colours" "[" {Id ","}+ colours "]"
      ( "," "start_hold:" IntegerLiteral startVal )?
      ( "," "end_hold" )?
    "}"
 ;

start syntax HoldReference
 = single: StringLiteral holdId
  | group: "{" {StringLiteral ","}+ holdIds "}"
 ;

start syntax Point
 = "{" "x:" IntegerLiteral x "," "y:" IntegerLiteral y "}"
 ;