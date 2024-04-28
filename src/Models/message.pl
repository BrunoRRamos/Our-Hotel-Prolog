:- module(models_message, [create_message_table/0]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

create_message_table:-
  connect_to_database(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS message (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sender_id INTEGER NOT NULL,
    recipient_id INTEGER NOT NULL,
    message TEXT NOT NULL,
    sentDate TEXT NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES user(id),
    FOREIGN KEY (recipient_id) REFERENCES user(id));",
    _),
    sqlite_disconnect(Conn).