module labour::CST2AST

// This provides println which can be handy during debugging.
import IO;

// These provide useful functions such as toInt, keep those in mind.
import Prelude;
import String;

import labour::AST;
import labour::Syntax;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 * Hint: Use switch to do case distinction with concrete patterns
 * Map regular CST arguments (e.g., *, +, ?) to lists
 * Map lexical nodes to Rascal primitive types (bool, int, str)
 */

// Main entry point for the transformation
BoulderingWall cst2ast(start[BoulderingWall] wall) {
    return cst2ast(wall.top);
}

BoulderingWall cst2ast(BoulderingWall w) {
    
}

list[BoulderingRoute] cst2ast(RouteList rl) {

}

BoulderingRoute cst2ast(BoulderingRoute r){

}

list[Volume] cst2ast(VolumeList vl) {

}

Volume cst2ast(Volume v) {

}

Hold cst2ast(Hold h) {

}

HoldReference cst2ast(HoldReference hr) {
    
}

Point cst2ast(Point p) {

}