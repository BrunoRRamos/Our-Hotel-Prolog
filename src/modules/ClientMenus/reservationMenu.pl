:- module(reservationMenu, [reservationMenu/1, find_room/3]).

:- use_module(library(yall)).
:- use_module(library(time)).
:- use_module("../util/util.pl").
:- use_module("../../models/reservation.pl").
:- use_module("../../models/room.pl").
:- use_module("../../models/service.pl").

reservationMenu(User):-
  tty_clear,
  write('Available commands:\n\n'),
  write('1. Make a reservation\n'),
  write('2. Edit a reservation\n'),
  write('3. Cancel a reservation\n'),
  write('4. Reservation overview\n'),
  write('5. Go back\n'),
  write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
  option(Option, User);
  reservationMenu(User).

option("1", User):-
  tty_clear,
  reservation_create_form(User),
  press_to_continue.

option("2", User):-
  tty_clear,
  reservation_edit_form(User),
  press_to_continue.

option("3", User):-
  User = user(UserId, _, _, _, _, _, _),

  tty_clear,
  parse_input("Enter the id of the reservation to cancel: ", Input, atom_number, ReservationId),

  Input \= "q",
  (
    get_one_reservation(Reservation, ReservationId) ->
    Reservation = reservation(_, _, UserIdRes, _, _, _, _),
    atom_string(UserId, UserIdRes),
    parse_input("Would you like to cancel the reservation? (y/n) ", _, parse_boolean, Cancel),

    (Cancel -> 
      delete_reservation(ReservationId),
      write("Reservation cancelled successfully!\n\n"),
      press_to_continue
    ; 
      write("Reservation not cancelled.\n\n"),
      press_to_continue,
      fail
    );

    tty_clear,
    write("Reservation not found!\n\n"),
    press_to_continue
  ).

option("4", User):-
  tty_clear,
  User = user(UserId, _, _, _, _, _, _),

  parse_input("Enter the id of the reservation: ", Input, atom_number, ReservationId),

  Input \= "q",
  ( 
    get_one_reservation(Reservation, ReservationId), 
    Reservation = reservation(_, RoomId, UserIdRes, StartStr, EndStr, _, _), 
    atom_string(UserIdRes, UserId) -> 

    parse_time(StartStr, Start),
    parse_time(EndStr, End),
    stamp_date_time(Start, StartDate, 'UTC'),
    stamp_date_time(End, EndDate, 'UTC'),

    get_one_room(Room, RoomId),
    Room = room(_, DailyRate, _, Occupancy),
    Stay is (End - Start) / (60 * 60 * 24),
    StayTotal is Stay * DailyRate,

    get_services_by_reservation(ReservationId, Services),
    findall(Price, (member(service(_, Price, _, _, _), Services)), Prices),
    sum_list(Prices, ServicesTotal),

    format("\n~`#t Reservation ~`#t~40|\n"),

    format_time(atom(StartFormatted), '%d/%m/%Y', StartDate),
    format_time(atom(EndFormatted), '%d/%m/%Y', EndDate),
    format("Start: ~w ~t End: ~w~40|\n", [StartFormatted, EndFormatted]),
    format("Room: ~w \nPrice: $~2f/ night\n", [RoomId, DailyRate]),
    format("Occupancy: ~w\n", [Occupancy]),

    format("\n~`-t Receipt ~`-t~40|\n"),

    format("\n~`#t Items ~`#t~40|\n"),
    format("0 Room ~w stay ~`-t~30+ $~2f x~0f\n", [RoomId, DailyRate, Stay]),
    forall(member(Service, Services), print_service(Service)),

    format("~n~`#t Details ~`#t~40|~n"),
    format("Services ~`-t~30+ $~2f\n", [ServicesTotal]),
    format("Accommodations ~`-t~30+ $~2f\n", [StayTotal]),

    format("\nTotal ~`-t~30+ $~2f\n\n", [ServicesTotal + StayTotal]),

    press_to_continue;

    tty_clear,
    write("Reservation not found!\n\n"),
    press_to_continue
  ).


option("5", _):-true.

option(_):-true.

print_service(Service):-
  Service = service(Id, Price, _, Description, _),
  format('~w ~w ~`-t~30+ $~2f\n', [Id, Description, Price]).

reservation_create_form(User):-
  User = user(UserId, _, _, _, _, _, _),
  
  parse_input("Enter a start date (YYYY-MM-DD): ", _, parse_date, Start),
  parse_input("Enter an end date (YYYY-MM-DD): ",_, parse_date, End),
  date_time_stamp(Start, StartTimestamp),
  date_time_stamp(End, EndTimestamp),

  check_dates(StartTimestamp, EndTimestamp),

  parse_input("Block room service? (y/n) ", _, parse_boolean, BlockServices),

  get_available_rooms(StartTimestamp, EndTimestamp, Rooms, _),
  select_room(Rooms, SelectedRoom),
  
  format_time(atom(StartStr), '%F', Start),
  format_time(atom(EndStr), '%F', End),

  insert_reservation(SelectedRoom, UserId, StartStr, EndStr, 'NULL', BlockServices, ReservationId),

  tty_clear,
  format(atom(SuccessMessage), 'Your reservation was made successfully!\nReservation id: ~w\n\n', [ReservationId]),
  write(SuccessMessage).


reservation_edit_form(User):-
  User = user(UserId, _, _, _, _, _, _),
  parse_input("Enter the id of the reservation to edit: ", Input, atom_number, ReservationId),

  Input \= "q",
  (
    (get_one_reservation(Reservation, ReservationId), 
    Reservation = reservation(_, RoomId, UserIdRes, ReservationStartStr, ReservationEndStr, _, _), atom_string(UserIdRes, UserId)) ->
      tty_clear,
      write("Reservation found!\n\n"),

      parse_optional_input("Enter a new start date (YYYY-MM-DD) (Press enter to skip): ", _, parse_date, Start),
      parse_optional_input("\nEnter a new end date (YYYY-MM-DD) (Press enter to skip): ", _, parse_date, End),

      parse_time(ReservationStartStr, ReservationStartTimestamp),
      parse_time(ReservationEndStr, ReservationEndTimestamp),
      stamp_date_time(ReservationStartTimestamp, ReservationStartDate, 'UTC'),
      stamp_date_time(ReservationEndTimestamp, ReservationEndDate, 'UTC'),

      (nonvar(Start) -> true ; Start = ReservationStartDate),
      (nonvar(End) -> true ; End = ReservationEndDate),

      date_time_stamp(Start, StartTimestamp),
      date_time_stamp(End, EndTimestamp),

      check_dates(StartTimestamp, EndTimestamp),

      ((StartTimestamp \= ReservationStartTimestamp; EndTimestamp \= ReservationEndTimestamp) -> 
        get_available_rooms(StartTimestamp, EndTimestamp, Rooms, RoomId),
        select_room(Rooms, SelectedRoom)
      ; true),

      parse_optional_input("Block room service? (y/n) ", _, parse_boolean, BlockServices),

      format_time(atom(StartStr), '%F', Start),
      format_time(atom(EndStr), '%F', End),

      update_reservation(ReservationId, SelectedRoom, UserId, StartStr, EndStr, _, BlockServices),
      write("Your reservation was edited successfully!\n\n");

    tty_clear,
    write("Reservation not found!\n\n")
  ).

select_room(Rooms, SelectedRoom):-
  ( Rooms = [] ->
      write("No rooms available for the selected dates.\n\n"),
      write("Press any key to go back"),
      get_char(_),
      false
  ;   write("Available rooms:\n\n"),
      forall(member(Room, Rooms), print_room(Room)),
      parse_input("Select a room: ", _, [In, Out]>> (find_room(In, Rooms, Out)), SelectedRoom)
  ).

check_dates(Start, End):-
  (Start > End -> 
    write("End date must be greater than start date\n\n"), 
    press_to_continue,
    fail
  ;
    true
  ).

find_room(RoomId, Rooms, Room):-
   atom_number(RoomId, Num), 
   member(room(Num, _, _, _), Rooms),
   Room = Num.