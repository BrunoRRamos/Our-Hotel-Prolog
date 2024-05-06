:- module(service_menu, [
    service_menu/1]).

:- use_module(library(prosqlite)).
:- use_module("../../Models/service.pl", [
    insert_service/3,
    get_service/2,
    update_service/4,
    delete_service/1
]).
:- use_module("../util/util.pl").
:- use_module("../../Models/reservation.pl").
:- use_module("./adminMenu").


service_menu(User) :-
    write('\nAvailable commands:\n'),
    writeln('1. Add Service'),
    writeln('2. Edit Service'),
    writeln('3. Remove Service'),
    writeln('4. Go Back'),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option, User);
    service_menu(User).

        
option("1", User) :-
    service_create_form(User),
    press_to_continue.

option("2", Conn) :-
    service_edit_form(User),
    press_to_continue.

service_edit_form(User) :-
    parse_input("Enter the id of the service to edit: ", Input, atom_number, ServiceId),
          
    Input \= "q",  
    (  
    (get_service(ServiceId, Service), 
    Service = service(_, SerPrice, SerType, SerDescription)) ->
        tty_clear,
        write("Service found!\n\n"),
        
        parse_optional_input("Enter a new price: ", _, atom_number, Price),
        parse_optional_input("\nEnter a new description: ", _, atom_string, Description),

        update_service(ServiceId, Price, SerType, Description),
        write("Your service was edited successfully!\n\n");

    tty_clear,
    write("Service not found!\n\n")
).

option("3", Conn) :-
    parse_input("Enter the id of the service to delete: ", _, atom_number, ServiceId),
    get_service(ServiceId, Service),
  
    Service = service(_, _, _, _),
    parse_input("Would you like to cancel the service? (y/n) ", _, parse_boolean, Cancel),
  
    (Cancel -> 
      delete_service(ServiceId),
      write("Service deleted successfully!\n\n"),
      service_menu(Conn)
    ; 
      write("Service not deleted.\n\n"),
      service_menu(Conn)
    );
    write("Reservation not found!\n\n"),
    press_to_continue,
    service_menu(Conn).

option("4", User) :-
    admin_menu(User).

service_create_form(User):-
    parse_input("Enter a price: ", _, atom_number, Price),
    parse_input("Enter a type (CLEANING/MEAL): ", _, atom_string, Type),
    parse_input("Enter a description: ", _, atom_string, Description),

    insert_service(Price, Type, Description),
          
    SuccessMessage = 'Your service was made successfully!\n\n',
    write(SuccessMessage).
    service_menu(User).

option(_):-true.
