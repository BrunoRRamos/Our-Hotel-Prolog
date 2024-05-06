:-module(review_menu, [review_menu/1]).

:-use_module("../../Models/reservation.pl", [get_all_reservations/1, get_available_rooms/4]).
:-use_module("../util/util.pl").
:-use_module("../../Models/room.pl").

option("1"):-
  tty_clear,
  write("Total clients in reservations today\n"),
  get_all_reservations(Reservations),
  findall(
    Reservation,
    (
      member(Reservation, Reservations),
      get_time(Today),
      Reservation = reservation(_, _, _, Start, End, _, _),
      Start =< Today,
      End >= Today
    ),
    ReservationsToday),
    length(ReservationsToday, Len),
    write("Today there are "),
    write(Len),
    write(" Clients in reservation today.\n\n"),
    press_to_continue.

option("2"):-
  tty_clear,
  write("Room availability\n"),
  get_time(Today),
  get_available_rooms(Today, Today, Rooms, _),
  list_rooms(Rooms),
  press_to_continue.

option("3"):-
  tty_clear,
  write("Average rating\n"),
  get_all_reservations(Reservations),
  findall(
    Rating,
    (
      member(Reservation, Reservations),
      Reservation = reservation(_, _, _, _, _, Rating, _)
    ),
    Ratings),
    length(Ratings, Len),
    ( Len > 1 ->
    sum_list(Ratings, Sum),
    Avg is Sum / Len,
    write("The average rating is "),
    write(Avg),
    write(".\n\n")
  );
  write("There is no average classification\n\n"),
  press_to_continue.

option("4"):-
  tty_clear,
  write("Total revenue\n"),
  get_all_reservations(Reservations),
  get_all_rooms(Rooms),
  findall(
    CalculatedDailyRate,
    (
      member(Reservation, Reservations),
      member(Room, Rooms),
      Reservation = reservation(_, RoomId, _, Start, End, _, _),
      Room = room(RoomId, DailyRate, _, _),
      CalculatedDailyRate is DailyRate * ((End - Start) / 86400)
    ),
    DailyRates),
    sum_list(DailyRates, TotalRevenue),
    write("The total revenue is "),
    write(TotalRevenue),
    write(".\n\n"),
  press_to_continue.

option("5"):-
  tty_clear,
  write("Best rooms\n"),
  get_all_reservations(Reservations),
  get_all_rooms(Rooms),
  findall(
    RoomId,
    (
      member(Room, Rooms),
      member(Reservation, Reservations),
      Room = room(RoomId, _, _, _),
      Reservation = reservation(_, RoomId, _, _, _, _, _)
    ),
    RoomIds),
    list_to_set(RoomIds, UniqueRoomIds),
    findall(
      RoomId-Count,
      (
        member(RoomId, UniqueRoomIds),
        findall(
          Reservation,
          (
            member(Reservation, Reservations),
            Reservation = reservation(_, RoomId, _, _, _, _, _)
          ),
          RoomReservations
        ),
        length(RoomReservations, Count)
      ),
      RoomReservationsCount
    ),
    sort(2, @>=, RoomReservationsCount, SortedRoomReservationsCount),
    write("The best rooms are:\n"),
    get_first_elements(SortedRoomReservationsCount, 3, BestRooms),
    print_best_rooms(BestRooms),
    write("\n"),
  press_to_continue.

  get_first_elements(List, X, SubList) :-
    length(List, Len),
    (X < Len ->
      append(Prefix, Suffix, List),
      length(Prefix, X),
      SubList = Prefix;
     SubList = List
    ).

print_best_rooms([]).
print_best_rooms([RoomId-Count|Tail]):-
  room(RoomId, _, _, _),
  write("Room Number: "),
  write(RoomId),
  write(" - "),
  write(Count),
  write(" reservations.\n"),
  print_best_rooms(Tail).

option("6"):-
  tty_clear,
  write("Last month reservations\n"),
  get_all_reservations(Reservations),
  findall(
    Reservation,
    (
      member(Reservation, Reservations),
      get_time(Today),
      stamp_date_time(Today, (date(Year, Month, Day,_,_,_,_,_,_)), 'UTC'),
      LastMonth is Month - 1,
      date_time_stamp(date(Year, LastMonth, 1,0,0,0,0,_,_), StartOfTheMonthTimeStamp),
      date_time_stamp(date(Year, Month, 1,0,0,0,0,_,_), NextMonthTimeStamp),
      LastDayOfTheMonthTimeStamp is NextMonthTimeStamp - 86400,
      Reservation = reservation(_, _, _, Start, End, _, _),
      Start =< StartOfTheMonthTimeStamp,
      End >= LastDayOfTheMonthTimeStamp
    ),
    ReservationsToday),
    length(ReservationsToday, Len),
    write("There are "),
    write(Len),
    write(" Reservations last month.\n\n"
  ), 
  press_to_continue.

option("7"):-
  tty_clear,
  write("This month reservations\n"),
  get_all_reservations(Reservations),
  findall(
    Reservation,
    (
      member(Reservation, Reservations),
      get_time(Today),
      stamp_date_time(Today, (date(Year, Month, Day,_,_,_,_,_,_)), 'UTC'),
      date_time_stamp(date(Year, Month, 1,0,0,0,0,_,_), StartOfTheMonthTimeStamp),
      NextMonth is Month + 1,
      date_time_stamp(date(Year, NextMonth, 1,0,0,0,0,_,_), NextMonthTimeStamp),
      LastDayOfTheMonthTimeStamp is NextMonthTimeStamp - 86400,
      Reservation = reservation(_, _, _, Start, End, _, _),
      Start =< StartOfTheMonthTimeStamp,
      End >= LastDayOfTheMonthTimeStamp
    ),
    ReservationsToday),
    length(ReservationsToday, Len),
    write("There are "),
    write(Len),
    write(" Reservations this month.\n\n"
  ),
  press_to_continue.

option("8"):- true.
option(_):- true.

review_menu(User) :-
  tty_clear,
  write('Available commands:\n'),
  write('1. Total clients in reservations today\n'),
  write('2. Room availability\n'),
  write('3. Average rating\n'),
  write('4. Total revenue\n'),
  write('5. Best rooms\n'),
  write('6. Last month reservations\n'),
  write('7. This month reservations\n'),
  write('8. Go back\n'),
  write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
  option(Option);
  review_menu(User).