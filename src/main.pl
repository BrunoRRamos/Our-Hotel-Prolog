:- use_module(init).
:- use_module(database).
:- use_module("models/create").
:- use_module(library(prosqlite)).
:- use_module("modules/login/loginMenu.pl").

main:-
  install,
  get_db_connection(Conn),
  create_tables,
  write("╔══════════════════════════════════════════════════════════════════════════════╗\n"),
  write("║                      WELCOME TO OURHOTEL, ENJOY YOUR STAY!                   ║\n"),
  write("╚══════════════════════════════════════════════════════════════════════════════╝\n"),
  loginLoop(),
  sqlite_disconnect(Conn).
  % halt.
