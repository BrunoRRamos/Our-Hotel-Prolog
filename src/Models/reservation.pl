:- module(models_reservation, [
  create_reservation_table/0, 
  get_one_reservation/2, 
  get_all_reservations/1, 
  get_available_rooms/4, 
  insert_reservation/7, 
  update_reservation/7,
  get_one_reservation/2,
  delete_reservation/1
  ]).

:- use_module("../database.pl").
:- use_module("./room.pl").
:- use_module(library(prosqlite)).

to_boolean(1, true).
to_boolean(0, true).

create_reservation_table:-
  get_db_connection(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS reservation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_id INTEGER NOT NULL,
    user_id TEXT NOT NULL,
    start TEXT NOT NULL,
    end TEXT NOT NULL,
    rating INTEGER,
    block_services BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (room_id) REFERENCES room(id),
    FOREIGN KEY (user_id) REFERENCES user(email));",
    _).


get_one_reservation(Reservation, ReservationId):-
  get_db_connection(_),
  reservation(ReservationId, RoomId, UserId, Start, End, Rating, BlockServices),
  to_boolean(BlockServices, BlockServicesInt),
  Reservation = reservation(ReservationId, RoomId, UserId, Start, End, Rating, BlockServicesInt).

get_all_reservations(Reservations):-
  get_db_connection(_),
  findall(
      reservation(Id, RoomId, UserId, Start, End, Rating, BlockServices),
      (
      reservation(Id, RoomId, UserId, StartISO, EndISO, Rating, BlockServicesInt),
        to_boolean(BlockServicesInt, BlockServices),
        parse_time(StartISO, Start),
        parse_time(EndISO, End)
      ),
      Reservations
  ).

update_reservation(ReservationId, RoomId, UserId, Start, End, Rating, BlockServices):-
  get_db_connection(Conn),
  findall(
    SQLFragment,
    (
      (nonvar(UserId), format(atom(SQLFragment), "user_id = '~w'", [UserId]));
      (nonvar(RoomId), format(atom(SQLFragment), "room_id= ~w", [RoomId]));
      (nonvar(Start), format(atom(SQLFragment), "start = '~w'", [Start]));
      (nonvar(End), format(atom(SQLFragment), "end = '~w'", [End]));
      (nonvar(Rating), format(atom(SQLFragment), "rating = ~w", [Rating]));
      (nonvar(BlockServices), format(atom(SQLFragment), "block_services = ~w", [BlockServices]))
    ),
    SQLFragments
  ),
  atomic_list_concat(SQLFragments, ', ', SQLSetClause),
  format(atom(SQL), "UPDATE reservation SET ~w WHERE id = ~w", [SQLSetClause, ReservationId]),
  sqlite_query(Conn, SQL, _).

insert_reservation(RoomId, UserId, Start, End, Rating, BlockServices, Id):-
  get_db_connection(Conn),
  format(atom(SQL), "INSERT INTO reservation(room_id, user_id, start, end, rating, block_services)
                      VALUES(~w, '~w', '~w', '~w', ~w, ~w)",
                      [RoomId, UserId, Start, End, Rating, BlockServices]),
  sqlite_query(Conn, SQL, _),
  sqlite_query(Conn, "SELECT last_insert_rowid()", row(Id)).

delete_reservation(ReservationId):-
  get_db_connection(Conn),
  format(atom(SQL), "DELETE FROM reservation WHERE id = ~w", [ReservationId]),
  sqlite_query(Conn, SQL, _).


get_available_rooms(Start, End, AvailableRooms, CurrentRoom):-
  get_all_reservations(Reservations),
  get_all_rooms(Rooms),
  findall(
    Room,
    (
      member(Room, Rooms),
      Room = room(RoomId, _, Status, _),
      Status = 'AVAILABLE',
      \+ (
        member(Reservation, Reservations),
        Reservation = reservation(_, RoomId, _, _, _, _, _),
        (nonvar(CurrentRoom) -> RoomId =\= CurrentRoom; true),
        overlap(Start, End, Reservation)
      )
    ),
    AvailableRooms).

  overlap(Start, End, reservation(_, _, _, ReservationStart, ReservationEnd, _, _)) :-
    Start < ReservationEnd, End > ReservationStart.

