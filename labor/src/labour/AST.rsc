module labour::AST

/*
 * Define the Abstract Syntax for LaBouR
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data BoulderingWall(loc src=|unknown:///|)
  = boulderingWall(str name, list[BoulderingRoute] rountes, list[Volume] volumes)
  ;

data BoulderingRoute(loc src=|unknown:///|)
  = BoulderingRoute(str name, str grade, Point grid_base_point, list[HoldReference] holds)
  ;

data Volume(loc src = |unknown:///|)
  = circle(Point pos, int depth, int radius, list[Hold] front_holds, list[Hold] side_holds)
  | triangle(Point pos, Point extrusion, int depth, list[Point] corners, list[Hold] left_holds, list[Hold] right_holds, list[Hold] bottom_holds)
  ;

data Hold(loc src = |unknown:///|)
  = hold(str hold_id, Point pos, str shape, int rotation, list[str] colours, int start_hold, bool end_hold)
  ;

data HoldReference(loc src=|unknown:///|)
  = singleHold(str holdId) | groupHolds(list[str] holdIds)
  ;

data Point(loc src = |unknown:///|)
  = point(int x, int y)
  ;