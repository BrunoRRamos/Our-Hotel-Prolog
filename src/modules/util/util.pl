:- module(util, [exit/0, input/2, optionalInput/3]).

:-use_module("../AdminMenus/roomMenu.pl").

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
    read_string(user_input, '\n', '\r', _, Input),
    (Input = "q" -> GoBack; true).
    
optionalInput(Input, OldValue, GoBack):-
    read_string(user_input, '\n', '\r', _, Input),
    (Input = "" -> Input = OldValue; true),
    (Input = "q" -> GoBack; true).