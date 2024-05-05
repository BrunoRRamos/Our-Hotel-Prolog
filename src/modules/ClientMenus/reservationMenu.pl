:- module(reservationMenu, [reservationMenu/1, find_room/3]).

:- use_module(library(yall)).
:- use_module(library(time)).
:- use_module("../util/util.pl").
:- use_module("../../models/reservation.pl").
:- use_module("../../models/room.pl").

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

  parse_input("Enter the id of the reservation to cancel: ", _, atom_number, ReservationId),
  get_one_reservation(Reservation, ReservationId),

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
  % tty_clear,
  write("Reservation not found!\n\n"),
  press_to_continue.


option("5", _):-true.

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
  
  format_time(atom(StartStr), '%FT%T%z', StartTimestamp),
  format_time(atom(EndStr), '%FT%T%z', EndTimestamp),

  insert_reservation(SelectedRoom, UserId, StartStr, EndStr, 'NULL', BlockServices, ReservationId),

  tty_clear,
  format(atom(SuccessMessage), 'Your reservation was made successfully!\nReservation id: ~w\n\n', [ReservationId]),
  write(SuccessMessage).


reservation_edit_form(User):-
  User = user(UserId, _, _, _, _, _, _),
  parse_input("Enter the id of the reservation to edit: ", _, atom_number, ReservationId),

  get_one_reservation(Reservation, ReservationId), 

  (
    get_one_reservation(Reservation, ReservationId), 
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
      ),

      parse_optional_input("Block room service? (y/n) ", _, parse_boolean, BlockServices),

      format_time(atom(StartStr), '%FT%T%z', StartTimestamp),
      format_time(atom(EndStr), '%FT%T%z', EndTimestamp),

      update_reservation(ReservationId, SelectedRoom, UserId, StartStr, EndStr, _, BlockServices),
      write("Your reservation was edited successfully!\n\n");

    tty_clear,
    write("Reservation not found!\n\n").

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