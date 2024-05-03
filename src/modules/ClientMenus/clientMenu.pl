:- module(clientMenu, [clientMenu/0]).
:- use_module("./checkinMenu.pl").
:- use_module("../util/util.pl").

option("1"):-
    write("Reservations menu here").

option("2"):-
    write("Service menu here").

option("3"):-
    checkInMenu().

option("4"):-
    write("Chat menu here").

option("5"):-
    exit().

clientMenu():-
    write("\nAvailable commands:\n"),
    write("1.  Reservations\n"),
    write("2.  Service\n"),
    write("3.  Check-In / Check-Out\n"),
    write("4.  Chat\n"),
    write("5.  exit - Quit the program\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option).
    