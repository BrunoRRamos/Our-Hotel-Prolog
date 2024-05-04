:- module(room_service_loop, [
    service_loop/1
]).

:- use_module("../../Models/reservation.pl").
:- use_module(database).
:- use_module(models_reservation).
:- use_module(library(date)).
:- use_module(library(readutil)).
:- use_module(library(dcg/basics)).

:- dynamic reservation/1.

service_loop(_) :-
    start_db(Conn),
    parse_time('2021-12-01', Start),
    parse_time('2021-12-05', End),
    Reservation = reservation(1, 505, "007@gmail.com", Start, End, false, _),
    writeln("\nAvailable commands:"),
    writeln("1. Request room cleaning"),
    writeln("2. Request meal service"),
    writeln("3. Exit - Quit the program"),
    writeln("\nEnter a command: "),
    read_line_to_string(user_input, Cmd),
    split_string(Cmd, " ", "", [CmdHead | CmdTail]),
    process_command(CmdHead, CmdTail, Conn, Reservation).

process_command("1", _, Conn, Reservation) :-
    writeln("\nRequesting room cleaning..."),
    writeln("Enter reservation ID:"),
    read_integer(ReservationId),
    (   ReservationId =:= Reservation^_id ->
        writeln("Enter price:"),
        read_number(Price),
        writeln("Enter description:"),
        read_line_to_string(user_input, Description),
        catch(request_room_service(Conn, ReservationId, Price, cleaning, Description), _, writeln("Failed to request room cleaning.")),
        writeln("Cleaning service requested successfully!")
    ;   writeln("Reservation ID does not exist.")
    ),
    hospede_loop(_).

process_command("2", _, Conn, Reservation) :-
    writeln("\nRequesting meal service..."),
    writeln("Enter reservation ID:"),
    read_integer(ReservationId),
    (   ReservationId =:= Reservation^_id ->
        writeln("Enter price:"),
        read_number(Price),
        writeln("Enter description:"),
        read_line_to_string(user_input, Description),
        catch(request_room_service(Conn, ReservationId, Price, meal, Description), _, writeln("Failed to request meal service.")),
        writeln("Meal service requested successfully!")
    ;   writeln("Reservation ID does not exist.")
    ),
    hospede_loop(_).

process_command("3", _, _) :-
    writeln("Goodbye!").

process_command(_, _, _) :-
    writeln("Invalid command. Please try again."),
    hospede_loop(_).
