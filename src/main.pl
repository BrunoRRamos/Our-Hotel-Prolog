:- use_module(init).
:- use_module(database).
:- use_module("models/create").
:- use_module(library(prosqlite)).

main:-
  install,
  get_db_connection(Conn),
  create_tables,
  sqlite_disconnect(Conn).
  % halt.
