:- module(models_room, [
  create_room_table/0,
  insert_room/4,
  get_all_rooms/1,
  get_one_room/2,
  update_room/4,
  delete_room/1,
  list_rooms/1,
  print_room/1,
  update_status_room/2
  ]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

create_room_table:-
  get_db_connection(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS room (
    id INTEGER PRIMARY KEY,
    daily_rate REAL NOT NULL,
    status TEXT CHECK(status IN ('AVAILABLE', 'RESERVED', 'BLOCKED')) NOT NULL,
    occupancy INTEGER NOT NULL);",
    _).

insert_room(DailyRate, Status, Occupancy, Row):-
  get_db_connection(Conn),
  format(atom(SQL), "INSERT INTO room(daily_rate, status, occupancy)
                     VALUES(~w, '~w', ~w)",
                     [DailyRate, Status, Occupancy]),
  sqlite_query(Conn,SQL, Row).

get_all_rooms(Rooms) :-
  get_db_connection(_),
  findall(
      room(Id, DailyRate, Status, Occupancy),
      room(Id, DailyRate, Status, Occupancy),
      Rooms
  ).

get_one_room(Room, Id):-
  get_db_connection(_),
  room(Id, DailyRate, Status, Occupancy),
  Room = room(Id, DailyRate, Status, Occupancy).

update_room(Id, DailyRate, Status, Occupancy):-
  get_db_connection(Conn),
  format(atom(SQL), "UPDATE room SET daily_rate = ~w, status = '~w', occupancy = ~w WHERE id = ~w",
                     [DailyRate, Status, Occupancy, Id]),
  sqlite_query(Conn,SQL, _).

update_status_room(Id, Status):-
  get_db_connection(Conn),
  format(atom(SQL), "UPDATE room SET status = '~w' WHERE id = ~w",
                      [Status, Id]),
  sqlite_query(Conn,SQL, _).

delete_room(Id):-
  get_db_connection(Conn),
  format(atom(SQL), "DELETE FROM room WHERE id = ~w", [Id]),
  sqlite_query(Conn,SQL, _).

print_room(Room):-
  write("--------------------------------------------------\n"),
  Room = room(Id, DailyRate, Status, Occupancy),
  write("Room ID: "), write(Id), write("\n"),
  write("Daily Rate: "), write(DailyRate), write("\n"),
  write("Status: "), write(Status), write("\n"),
  write("Occupancy: "), write(Occupancy), write("\n"),
  write("--------------------------------------------------\n").

list_rooms([]):-
  write("List Ended\n").

list_rooms([Room|Rest]):-
  write("\n"),
  print_room(Room),
  write("\n"),
  list_rooms(Rest).