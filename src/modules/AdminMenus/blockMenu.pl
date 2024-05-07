:- module(block_menu, [block_menu/0]).

:- use_module("../util/blockClient").
:- use_module("../util/util.pl").
:- use_module("../../Models/user.pl").

option("1"):-
    block_client_menu.

option("2"):-true.

option(_):- true.

block_menu :-
    tty_clear,
    write('Available commands:\n'),
    write('1. Block a client\n'),
    write('2. Exit\n'),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option);
    block_menu.

block_client_menu :-
    parse_input("Please provide client email: ", Input, atom_string, Email),
    parse_input("Please provide the blocked reason: ", _, atom_string, Reason),

    Input \= "q",
    (
        get_one_user(_, Email) ->
        block_client(Email, Reason),
        write("\n")
    ;
        write("User not found\n")
  ),
    press_to_continue.
