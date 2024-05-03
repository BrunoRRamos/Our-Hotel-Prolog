:- use_module("../../Models/reservation.pl").

option("1"):-
    write('Enter the room number: '), read_string(user_input, '\n', '\r', _, RoomNumber),
    get_one(Reservation, RoomNumber),
    write(Reservation),
    write("\n Check-In Sucess !").

option("2"):-
    write("checkout").

option("3"):-
    write("go back")

checkInMenu():-
    write("\nAvailable commands:")
    write("1.  Check-In\n")
    write("2.  Check-Out\n")
    write("3.  Go back\n")
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option).