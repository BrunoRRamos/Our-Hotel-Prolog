:- module(checkInMenu, [checkInMenu/0]).
:- use_module("../../Models/reservation.pl").
:- use_module("../../Models/room.pl").
:- use_module("./clientMenu.pl").
:- use_module("./../login/loginMenu.pl").
:- use_module("./../util/util.pl").
:- use_module("./../util/stayReview.pl").

getRoomStatusReserved(room(_, _, Status, _)):-
    Status == 'RESERVED'.

getRoomStatusFree(room(_, _, Status, _)):-
    Status == 'AVAILABLE'.

formatFreeRoom(reservation(_, RoomId, _, _, _, _, _)):-
    get_one_room(Room, RoomId),
    getRoomStatusReserved(Room) -> (
    update_status_room(RoomId, "AVAILABLE")).

formatReservedRoom(reservation(_, RoomId, _, _, _, _, _)):-
    get_one_room(Room, RoomId),
    getRoomStatusFree(Room) -> (
    update_status_room(RoomId, "RESERVED")).

option("1"):-
    tty_clear,
    write('\nEnter the reservation number: '), read_string(user_input, '\n', '\r', _, ReservationId),
    string_to_atom(ReservationId, Number),
    get_one_reservation(Reservation, ReservationId) -> 
    (
        write("\nCheck-In Successfull!\n"), 
        formatReservedRoom(Reservation),
        press_to_continue
    ); 
    write("Reservation not found"), press_to_continue.

option("2"):-
    tty_clear,
    write('\nEnter the reservation number: '), read_string(user_input, '\n', '\r', _, ReservationId),
    string_to_atom(ReservationId, Number),
    get_one_reservation(Reservation, ReservationId) -> 
    (
        generate_stay_review(ReservationId),
        write("\nCheck-Out Done!\n"), 
        formatFreeRoom(Reservation),
        press_to_continue
    ); 
    write("Reservation not found"),
    press_to_continue.

option("3"):-
    tty_clear.

option(_):-true.

checkInMenu():-
    tty_clear,
    write("\nAvailable commands:\n"),
    write("1.  Check-In\n"),
    write("2.  Check-Out\n"),
    write("3.  Go back\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option).