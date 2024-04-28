:- module(models_reservation, [create_reservation_table/0]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

create_reservation_table:-
  connect_to_database(Conn),
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
    _),
    sqlite_disconnect(Conn).