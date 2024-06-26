:- module(room_service_menu, [
    room_service_menu/1]).

:- use_module(library(prosqlite)).
:- use_module("../../Models/roomService.pl").
:- use_module("../../Models/reservation.pl").
:- use_module("../../Models/service.pl", [get_service/2]).
:- use_module("../util/util.pl").
:- use_module("./clientMenu").


room_service_menu(User) :-
    write('\nAvailable commands:\n'),
    writeln('1. Request room cleaning'),
    writeln('2. Request meal service'),
    writeln('3. Go back'),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option, User);
    room_service_menu(User).

option("1", User) :-
    User = user(UserId, _, _, _, _, _, _),
    findall(
        service(ServiceId, Price, Type, Description),
        (service(ServiceId, Price, Type, Description), Type = 'CLEANING'),
        Services
    ),
    ( member(Service, Services),
        tty_clear,
        print_service(Service)
    ),
    
    parse_input("Enter the id of the service to request: ", Input, atom_number, ServiceUserId),

    Input \= "q",  
    (  
    (get_service(ServiceUserId, Service), 
    Service = service(_, SerPrice, SerType, SerDescription)) ->
        write("Service found!\n\n"),
        parse_input("Enter the id of your reservation: ", Input2, atom_number, ReservationId),
        Input2 \= "q",  
        (  
        (get_one_reservation(Reservation, ReservationId), 
        Reservation = reservation(_, RoomId, UserIdRes, ReservationStartStr, ReservationEndStr, _, _), atom_string(UserIdRes, UserId)) ->
            writeln("Reservation found!\n"),
            insert_room_service(ServiceUserId, ReservationId),
            writeln("Your service was made successfully!\n")
    ;
        write("Reservation not found!\n\n")
)
        ;

    write("Service not found!\n\n")
),
     room_service_menu(User).


option("2", User) :-
    User = user(UserId, _, _, _, _, _, _),

    findall(
        service(ServiceId, Price, Type, Description),
        (service(ServiceId, Price, Type, Description), Type = 'MEAL'),
        Services
    ),
    ( member(Service, Services),
        print_service(Service)
    ),
    parse_input("Enter the id of the service to request: ", Input, atom_number, ServiceUserId),         
    Input \= "q",  
    (   
    (get_service(ServiceUserId, Service), 
    Service = service(_, SerPrice, SerType, SerDescription)) ->
        write("Service found!\n\n"),
        parse_input("Enter the id of your reservation: ", Input2, atom_number, ReservationId),
        Input2 \= "q",  
    (  
    (get_one_reservation(Reservation, ReservationId), 
    Reservation = reservation(_, RoomId, UserIdRes, ReservationStartStr, ReservationEndStr, _, _), atom_string(UserIdRes, UserId)) ->
        writeln("Reservation found!\n"),
        insert_room_service(ServiceUserId, ReservationId),
        writeln("Your service was made successfully!\n")

        ;

    write("Reservation not found!\n\n")
)
        ;

    write("Service not found!\n\n")
),
    room_service_menu(User).
    
print_service(service(ServiceId, Price, Type, Description)) :-
    write("  ### Services available ###\n"),
    \+ ((var(ServiceId); var(Price); var(Type); var(Description))), 
    format('~w ~w ~`-t~30+ $~2f\n\n', [ServiceId, Description, Price]).
    
option("3", _):-
    client_menu(User).

option(_):-true.     

to_boolean(1, true).
to_boolean(0, true).

    
    