:- module(block_menu, [block_menu/0]).

:- use_module("../util/blockClient").

option("1"):-
    block_client_menu.

option("2"):-
    writeln("Exiting...").

option(_):-
    writeln("Invalid option."),
    press_to_continue.

block_menu :-
    tty_clear,
    write('Available commands:\n'),
    write('1. Block a client\n'),
    write('2. Exit\n'),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option),
    Option \== "2",
    block_menu.

block_client_menu :-
    writeln("Please provide client email: "),
    read_string(user_input, '\n', '\r', _, Email),
    block_client(Email),
    press_to_continue.
