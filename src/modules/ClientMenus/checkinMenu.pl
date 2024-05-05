:- module(checkInMenu, [checkInMenu/0]).
:- use_module("../../Models/reservation.pl").
:- use_module("../../Models/room.pl").
:- use_module("./clientMenu.pl").
:- use_module("./../login/loginMenu.pl").

getRoomStatusReserved(room(_, _, Status, _)):-
    Status == 'RESERVED'.

getRoomStatusFree(room(_, _, Status, _)):-
    Status == 'AVAILABLE'.

formatFreeRoom(reservation(_, RoomId, _, _, _, _, _)):-
    get_one_room(Room, RoomId),
    getRoomStatusReserved(Room) -> (
    update_status_room(RoomId, "AVAILABLE")); write("Invalid reservation number"), checkInMenu().

formatReservedRoom(reservation(_, RoomId, _, _, _, _, _)):-
    get_one_room(Room, RoomId),
    getRoomStatusFree(Room) -> (
    update_status_room(RoomId, "RESERVED")); write("Invalid reservation number"), checkInMenu().

option("1"):-
    write('\nEnter the reservation number: '), read_string(user_input, '\n', '\r', _, ReservationId),
    string_to_atom(ReservationId, Number),
    get_one_reservation(Reservation, ReservationId) -> (
    formatReservedRoom(Reservation),
    write("\n Check-In Sucess !"), client_menu(User)); write("Reservation not found"), checkInMenu().

option("2"):-
    write('\nEnter the reservation number: '), read_string(user_input, '\n', '\r', _, ReservationId),
    string_to_atom(ReservationId, Number),
    get_one_reservation(Reservation, ReservationId) -> (
    formatFreeRoom(Reservation),
    write("\nCheck-Out Done"), client_menu(User)); write("Reservation not found"), checkInMenu().

option("3"):-
    client_menu(User).

checkInMenu():-
    write("\nAvailable commands:\n"),
    write("1.  Check-In\n"),
    write("2.  Check-Out\n"),
    write("3.  Go back\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option).