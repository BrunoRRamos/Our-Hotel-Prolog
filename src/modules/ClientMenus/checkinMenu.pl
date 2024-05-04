:- module(checkInMenu, [checkInMenu/0]).
:- use_module("../../Models/reservation.pl").
:- use_module("../../Models/room.pl").

option("1"):-
    write('Enter the room number: '), read_string(user_input, '\n', '\r', _, RoomNumber),
    get_one(Reservation, RoomNumber),
    write(Reservation),
    write("\n Check-In Sucess !").

option("2"):-
    write('Enter the room number: '), read_string(user_input, '\n', '\r', _, RoomNumber),
    update_room(RoomNumber, _, 'AVAILABLE', _),
    write("Check-Out Sucess !").

option("3"):-
    write("go back").

checkInMenu():-
    write("\nAvailable commands:\n"),
    write("1.  Check-In\n"),
    write("2.  Check-Out\n"),
    write("3.  Go back\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option).