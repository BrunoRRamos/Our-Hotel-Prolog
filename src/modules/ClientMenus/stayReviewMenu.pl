:- module(stay_review_menu, [stay_review_menu/1]).

:- dynamic current_conn/1.
:- dynamic current_reservation/1.

:- use_module("../../Models/reservation.pl").
:- use_module("../../Models/user.pl").
:- use_module("../../Util/stayReview.pl", [generate_stay_review/3]).

option("1"):-
    current_conn(Conn),
    current_reservation(Reservation),
    read_user(User),
    generate_stay_review(Conn, Reservation, User),
    writeln("Review created successfully."),
    press_to_continue.

option("2"):-
    writeln("Exiting...").

option(Option):-
    writeln("Invalid option."),
    press_to_continue.

stay_review_menu(User) :-
    tty_clear,
    write('Available commands:\n'),
    write('1. Create review\n'),
    write('2. Exit\n'),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option),
    Option \== "2",
    stay_review_menu(User).

read_user(User) :-
    writeln("Please provide user email: "),
    read_string(user_input, '\n', '\r', _, Email),
    get_one_user(User, Email).