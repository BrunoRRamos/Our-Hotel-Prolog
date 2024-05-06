:- module(clientMenu, [client_menu/1]).
:- use_module("./checkinMenu.pl").
:- use_module("./chatMenu.pl").
:- use_module("../util/util.pl").
:- use_module("./reservationMenu.pl").

option("1", User):-
    reservationMenu(User).

option("2", _):-
    write("Service menu here").

option("3", _ ):-
    checkInMenu().

option("4", User):-
    chatMenu(User).

option("5", _):-
    exit().

option(_):-true.

client_menu(User):-
    tty_clear,
    write("\nAvailable commands:\n"),
    write("1.  Reservations\n"),
    write("2.  Service\n"),
    write("3.  Check-In / Check-Out\n"),
    write("4.  Chat\n"),
    write("5.  exit - Quit the program\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option, User),
    client_menu(User).
    