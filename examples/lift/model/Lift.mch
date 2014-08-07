MODEL Lift
CONSTANTS groundf,topf
PROPERTIES (topf : INTEGER) & (groundf : INTEGER) & (groundf = -1) & (topf = 2) & (groundf < topf)
VARIABLES call_buttons,cur_floor,direction_up,door_open
INVARIANT (cur_floor : (groundf .. topf)) & (door_open : BOOL) & (call_buttons : POW((groundf .. topf))) & (direction_up : BOOL) & ((door_open = TRUE) => (cur_floor : call_buttons))
INITIALISATION cur_floor := (groundf) || door_open := (FALSE) || call_buttons := ({}) || direction_up := (TRUE)
OPERATIONS
 move_up = SELECT (door_open = FALSE) & (cur_floor < topf) & (direction_up = TRUE) & # c.((c : INTEGER) & ((c : INTEGER) & (c > cur_floor) & (c : call_buttons))) & (cur_floor /: call_buttons) THEN cur_floor := ((cur_floor)+(1)) END ;
 move_down = SELECT (door_open = FALSE) & (cur_floor > groundf) & (direction_up = FALSE) & # cu.((cu : INTEGER) & ((cu : INTEGER) & (cu < cur_floor) & (cu : call_buttons))) & (cur_floor /: call_buttons) THEN cur_floor := ((cur_floor)-(1)) END ;
 reverse_lift_up = SELECT (direction_up = FALSE) & (door_open = FALSE) & # c.((c : INTEGER) & ((c : INTEGER) & (c > cur_floor) & (c : call_buttons))) & ! l.((l : INTEGER) => (((l : INTEGER) & (l <= cur_floor) & (l >= groundf)) => (l /: call_buttons))) THEN direction_up := (TRUE) END ;
 reverse_lift_down = SELECT (direction_up = TRUE) & (door_open = FALSE) & # cd.((cd : INTEGER) & ((cd : INTEGER) & (cd < cur_floor) & (cd : call_buttons))) & ! u.((u : INTEGER) => (((u : INTEGER) & (u >= cur_floor) & (u <= topf)) => (u /: call_buttons))) THEN direction_up := (FALSE) END ;
 open_door = SELECT (door_open = FALSE) & (cur_floor : call_buttons) THEN door_open := (TRUE) END ;
 close_door = SELECT (door_open = TRUE) THEN door_open := (FALSE) || call_buttons := ((call_buttons)\({cur_floor})) END ;
 push_call_button = ANY floor WHERE (floor : (groundf .. topf)) & (floor /: call_buttons) THEN call_buttons := ((call_buttons)\/({floor})) END 
END 
