:- module(models_reservation, [create_reservation_table/0, get_one/2]).

:- use_module("../database.pl").
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

get_one(Reservation, RoomId):-
  get_db_connection(_),
  reservation(RoomId, UserId, Start, End, Rating, BlockServices),
  to_boolean(BlockServices, BlockServicesInt),
  Reservation = reservation(RoomId, UserId, Start, End, Rating, BlockServicesInt).