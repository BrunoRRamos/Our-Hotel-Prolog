:- module(checkInMenu, [checkInMenu/0]).
:- use_module("../../Models/reservation.pl").
:- use_module("../../Models/room.pl").

verifyRoom(RoomNumber, Result):-
    get_one_room(Room, RoomNumber) -> Result is "\nCheck-Out Sucess !"; write("\nRoom not found"), chatMenu().

option("1"):-
    write('\nEnter the reservation number: '), read_string(user_input, '\n', '\r', _, RoomNumber),
    atom_number(ReservationId, Number),
    get_one(Reservation, ReservationId),
    write(Reservation),
    write("\n Check-In Sucess !").

option("2"):-
    write('\nEnter the room number: '), read_string(user_input, '\n', '\r', _, RoomNumber),
    atom_number(RoomNumber, Number),
    verifyRoom(RoomNumber, Result),
    update_room(RoomNumber, _, 'AVAILABLE', _),
    write(Result).

option("3"):-
    write("go back").

checkInMenu():-
    write("\nAvailable commands:\n"),
    write("1.  Check-In\n"),
    write("2.  Check-Out\n"),
    write("3.  Go back\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option).