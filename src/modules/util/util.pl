:- module(util, [exit/0, input/2, optionalInput/3, parse_date/2, parse_input/4, parse_optional_input/4, press_to_continue/0, parse_boolean/2, parse_room_status/2 ]).

:-use_module("../AdminMenus/roomMenu.pl").
:-use_module("../ClientMenus/reservationMenu.pl").

exit():-
    write("╔══════════════════════════════════════════════════════════════════════════════╗\n"),
    write("║                    THANK YOU FOR VISITING, COME BACK SOON                    ║\n"),
    write("║══════════════════════════════════════════════════════════════════════════════║\n"),
    write("║                                    TEAM:                                     ║\n"),
    write("║══════════════════════════════════════════════════════════════════════════════║\n"),
    write("║                               Bruno Rodrigues                                ║\n"),
    write("║                              José Gabriel Melo                               ║\n"),
    write("║                             Pedro Henrique Costa                             ║\n"),
    write("║                              Pedro Silva Filho                               ║\n"),
    write("║                                Suelen Felix                                  ║\n"),
    write("╚══════════════════════════════════════════════════════════════════════════════╝\n"),
    halt.

input(Input, GoBack):-
    read_line_to_string(user_input, Line),
    (Line = "q" -> call(GoBack); Input = Line).
    
optionalInput(Input, OldValue, GoBack):-
    read_string(user_input, '\n', '\r', _, Input),
    (Input = "" -> Input = OldValue; true),
    (Input = "q" -> call(GoBack); true).

optionalInput(Input):-
    read_line_to_string(user_input, Line),
    Line \= "q",
    (Line = "" -> true; Input = Line).

parse_date(DateStr, DateStruct):-
    parse_time(DateStr, Stamp),
    stamp_date_time(Stamp, DateStruct, 'UTC').

input(Input):-
    read_line_to_string(user_input, Line),
    Line \= "q",
    Input = Line.

parse_input(Prompt, Input, Parser, Parsed):-
    write(Prompt),
    input(Input),
    (call(Parser, Input, Parsed) -> true; 
    write("Invalid input, please try again\n\n"), 
    parse_input(Prompt, _, Parser, Parsed)).

parse_optional_input(Prompt, Input,  Parser, Parsed):-
    write(Prompt),
    optionalInput(Input),
    (Input = "" -> true; 
    (call(Parser, Input, Parsed) -> true; 
    write("Invalid input, please try again\n\n"),
    parse_optional_input(Prompt, _,  Parser, Parsed))).

parse_boolean(Input, Bool):- 
  Input == "y", Bool = true; 
  Input == "n", Bool = false;
  false.

parse_room_status(Input, Status):-
    Input = "y", Status = "BLOCKED";
    Input = "n", Status = "AVAILABLE";
    false.

press_to_continue:-
  write("Press any key to continue"),
  get_single_char(_).