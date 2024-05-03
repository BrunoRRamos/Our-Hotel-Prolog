:- use_module(database).
:- use_module(library(prosqlite)).
:- use_module("modules/login/loginMenu.pl").

main:-
  get_db_connection(Conn),
  write("╔══════════════════════════════════════════════════════════════════════════════╗\n"),
  write("║                      WELCOME TO OURHOTEL, ENJOY YOUR STAY!                   ║\n"),
  write("╚══════════════════════════════════════════════════════════════════════════════╝\n"),
  loginLoop(),
  sqlite_disconnect(Conn).
  % halt.
