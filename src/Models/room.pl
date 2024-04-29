:- module(models_room, [create_room_table/0]).

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