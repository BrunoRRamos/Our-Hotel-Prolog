:- module(service_menu, [
    service_menu/1,
    create_service_table/0
]).

:- use_module(library(prosqlite)).
:- use_module("../../Models/service.pl", [
    add_service/2,
    edit_service/2,
    remove_service/2,
    insert_service/3,
    get_service/2,
    update_service/4,
    delete_service/1,
    get_all_services/2
]).
:- use_module("../util/util.pl").
:- use_module("../../Models/reservation.pl").
:- use_module("./adminMenu").



service_menu(User) :-
    write('Available commands:\n'),
    writeln("1. Add Service"),
    writeln("2. Edit Service"),
    writeln("3. Remove Service"),
    writeln("4. Go Back"),
    writeln("\nEnter a command: "),
    read_line_to_string(user_input, Cmd),
    process_command(Cmd, Conn),
    (   Cmd == "5" -> ! ; fail ). % Stop looping if the command is 5

        
process_command("1", User) :-
    service_create_form(User),
    service_menu(User).

process_command("2", Conn) :-
    service_edit_form(User),
    service_menu(Conn).

    service_edit_form(User) :-
        User = user(UserId, _, _, _, _, _, _),
        parse_input("Enter the id of the service to edit: ", _, atom_number, ServiceId),
          
        get_service(ServiceId, Service), 
          
        (   get_service(ServiceId, Service), 
            Service = service(_, SerPrice, SerType, SerDescription) 
        ) ->
            tty_clear,
            write("Service found!\n\n"),
                
            % Get user input for optional updates
            parse_optional_input("Enter a new price: ", _, atom_number, Price),
            parse_optional_input("\nEnter a new description: ", _, atom_string, Description),
    
            % Update service with non-empty user inputs
            (  nonvar(Price) -> UpdatedPrice = Price ; UpdatedPrice = SerPrice  ),
            (  nonvar(Description) -> UpdatedDescription = Description ; UpdatedDescription = SerDescription  ),
            update_service(ServiceId, UpdatedPrice, SerType, UpdatedDescription),
            write("Your service was edited successfully!\n\n");
        
        (   \+ get_service(ServiceId, _)  ) ->  % Service not found (alternative negation)
            tty_clear,
            write("Service not found!\n\n").

process_command("3", Conn) :-
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
    % tty_clear,
    write("Reservation not found!\n\n"),
    press_to_continue,
    service_menu(Conn).

process_command("4", User) :-
    admin_menu(User).

service_create_form(User):-
    parse_input("Enter a price: ", _, atom_number, Price),
    parse_input("Enter a type (CLEANING/MEAL): ", _, atom_string, Type),
    parse_input("Enter a description: ", _, atom_string, Description),

    insert_service(Price, Type, Description),
          
    % tty_clear,
    SuccessMessage = 'Your service was made successfully!\n\n',
    write(SuccessMessage).
    press_enter,
    service_menu(User).

process_command(_, Conn) :-
    writeln("Invalid command. Please try again"),
    service_menu(Conn).

            