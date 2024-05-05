:- module(util_room_service, [request_room_service/3]).

% Import necessary predicates
:- use_module(library(lists)).          % for find/2
:- use_module(library(assoc)).           % for assoc/1
:- use_module(library(sql)).             % for SQLite database interaction

% Define data structures (replace with your actual definitions)
:- record(reservation, [id, user_id]).
:- record(room_service, [id, reservation_id, service_id]).
:- record(service, [id, type, description, price]).

% Function to request room service
request_room_service(Conn, User, ServiceType) :-
    validate_reservation(Conn, User, ReservationId),  % Get valid reservation ID
    (   ReservationId \= none ->  % Check if reservation is valid
        get_service_by_type(Conn, ServiceType, Services),   % Get services of that type
        (   Services \= [] ->   % Check if any services are available
            write('\n## Service List ##\n'),
            maplist(show_service, Services), % Display available services
            get_user_input("Select a service: ", ServiceId, validate_service(ServiceId, Services), Service),  % Get user input for service
            create_room_service(Conn, ReservationId, Service.id)  % Create room service record
        ;   write('No services available!\n')
        ),
        press_enter  % Wait for user input
    ;   true  % Do nothing if reservation invalid
    ).

  

% Validate reservation based on user ID
validate_reservation(Conn, User, ReservationId) :-
    sql_query_params(Conn, "SELECT * FROM reservation WHERE id = ? AND user_id = ?", [ReservationId, User.email], [Reservation]),  % Get reservation by ID and user ID
    (   Reservation = [] ->  % Check if reservation exists and user ID matches
        ReservationId = none
    ;   Reservation = [ReservationRow | _], % Extract the first row of the result
        ReservationId = ReservationRow.id  % Extract the reservation ID from the row
    ).



% Validate user input for service selection
validate_service(Services) :-
    \+ (atom_chars(Input, _), number_string(Id, Input), member(Service, Services), Service.id = Id),
    write('Invalid service id!\n'), fail.

% Helper function to show service details
show_service(Service) :-
    write(Service.id), write('.'), write(' $'), write(Service.price), write(' - '), write(Service.description), nl.

% Get user input with validation
get_user_input(Prompt, Validation) :-
    write(Prompt),
    flush_output(current_output),  % Certifique-se de que o prompt é exibido antes da entrada
    read_line_to_codes(user_input, ServiceIdCodes),  % Leia a entrada como uma lista de códigos de caracteres
    string_codes(ServiceIdString, ServiceIdCodes),  % Converta os códigos de caracteres em uma string
    call(Validation, ServiceIdString).  % Chame o validador com a string de entrada

% Function to create room service record
create_room_service(Conn, ReservationId, ServiceId) :-
    sql(Conn, "INSERT INTO room_service (reservation_id, service_id) VALUES (?, ?)",
        [ReservationId, ServiceId]).  % Insert room service data

% Function to get reservation data by ID (replace with actual query if needed)
get_reservation_by_id(Conn, Reservation) :-
    sql(Conn, "SELECT * FROM reservation WHERE id = ?", [ReservationId], Reservation).

% Function to get services by type (replace with actual query if needed)
get_service_by_type(Conn, ServiceType, Services) :-
    sql(Conn, "SELECT * FROM service WHERE type = ?", [ServiceType], ServiceList),
    Services = map(service, ServiceList).  % Convert list to records

% Helper function to convert service list to records
service([Id, Price, Type, Description]) :-
    service(Id, Price, Type, Description).

