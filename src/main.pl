:- use_module(database).
:- use_module(library(prosqlite)).
:- use_module("modules/login/loginMenu.pl").

main:-
  get_db_connection(Conn),
  loginLoop(),
  sqlite_disconnect(Conn).
  % halt.
