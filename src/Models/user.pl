:- module(models_user, [create_user_table/0]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

create_user_table:-
  connect_to_database(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS user( 
    email TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    password TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT 1,
    block_reason TEXT,
    role TEXT CHECK(role IN ('ADMIN', 'CLIENT')) NOT NULL);",
    _),
    sqlite_disconnect(Conn).