:- module(models_service, [create_service_table/0]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

create_service_table:-
  get_db_connection(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS service (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    price REAL NOT NULL,
    type TEXT CHECK(type IN ('CLEANING', 'MEAL')) NOT NULL,
    description TEXT NOT NULL,
    reservation_id INTEGER NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservation(id));",
    _).