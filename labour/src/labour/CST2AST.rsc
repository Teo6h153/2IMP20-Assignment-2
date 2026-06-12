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
    switch(w) {
        case (BoulderingWall)`bouldering_wall <IntegerLiteral id> <StringLiteral name> { <RouteList routes> <VolumeList volumes> }`:
            return boulderingWall(
                lex2int(id), 
                lex2str(name), 
                cst2ast(routes), 
                cst2ast(volumes),
                src=w.src
            );
        default: throw "Malformed BoulderingWall node";
    }
}

list[BoulderingRoute] cst2ast(RouteList rl) {
    return [ cst2ast(r) | BoulderingRoute r <- rl.routes ];
}

BoulderingRoute cst2ast(BoulderingRoute r){
    switch(r) {
        case (BoulderingRoute)`bouldering_route <StringLiteral name> { grade: <StringLiteral grade>, grid_base_point <Point basePoint>, holds [<{HoldReference ","}* holds>] }`:
            return boulderingRoute(
                lex2str(name), 
                lex2str(grade), 
                cst2ast(basePoint), 
                [ cst2ast(h) | HoldReference h <- holds ],
                src=r.src
            );
        default: throw "Malformed BoulderingRoute node";
    }
}

list[Volume] cst2ast(VolumeList vl) {
    return [ cst2ast(v) | Volume v <- vl.volumes ];
}

Volume cst2ast(Volume v) {
    switch(v) {
        case (Volume)`circle { pos: <Point pos>, depth: <IntegerLiteral depth>, radius: <IntegerLiteral radius>, front_holds <HoldGroup front>, side_holds <HoldGroup side> }`:
            return circle(
                cst2ast(pos), 
                lex2int(depth), 
                lex2int(radius), 
                [ cst2ast(h) | Hold h <- front.holds ], 
                [ cst2ast(h) | Hold h <- side.holds ],
                src=v.src
            );
            
        case (Volume)`triangle { pos: <Point pos>, extrusion: <Point ext>, depth: <IntegerLiteral depth>, corners [ <Point c1> , <Point c2> , <Point c3> ], left_holds <HoldGroup left> }`:
            return triangle(
                cst2ast(pos), 
                cst2ast(ext), 
                lex2int(depth), 
                [cst2ast(c1), cst2ast(c2), cst2ast(c3)], 
                [ cst2ast(h) | Hold h <- left.holds ],
                src=v.src
            );
            
        default: throw "Malformed Volume node";
    }
}

Hold cst2ast(Hold h) {
    // 1. Initialize variables for our optional elements with fallback defaults
    int rotation = 0;
    int startVal = 0;
    bool endHold = false;
    
    // 2. We extract data safely by inspecting the underlying structured concrete pieces
    // Extract optional rotation
    if (h.rotation?) {
        rotation = lex2int(h.rotation.rotation);
    }
    
    // Extract optional start hold
    if (h.startVal?) {
        startVal = lex2int(h.startVal.startVal);
    }
    
    // Extract optional end hold flag
    if (h.endHold?) {
        endHold = true;
    }
    
    return hold(
        lex2str(h.holdId),
        cst2ast(h.pos),
        lex2str(h.shape),
        rotation,
        [ "<c>" | Id c <- h.colours.colours ], // Maps standard identifiers to lists of strings
        startVal,
        endHold,
        src=h.src
    );
}

HoldReference cst2ast(HoldReference hr) {
    switch(hr) {
        case (HoldReference)`<StringLiteral holdId>`:
            return singleHold(lex2str(holdId), src=hr.src);
            
        case (HoldReference)`{ <{StringLiteral ","}+ holdIds> }`:
            return groupHolds([ lex2str(id) | StringLiteral id <- holdIds ], src=hr.src);
            
        default: throw "Malformed HoldReference node";
    }
}

Point cst2ast(Point p) {
    switch(p) {
        case (Point)`{ x: <IntegerLiteral x>, y: <IntegerLiteral y> }`:
            return point(lex2int(x), lex2int(y), src=p.src);
        default: throw "Malformed Point node";
    }
}

// Converts a concrete string literal (with quotes) to a clean Rascal primitive string
str lex2str(StringLiteral sl) {
    str raw = "<sl>";
    return substring(raw, 1, size(raw) - 1); // Strips the wrapping quotes "..."
}

// Converts a concrete integer literal to a Rascal primitive int
int lex2int(IntegerLiteral il) {
    return toInt("<il>");
}